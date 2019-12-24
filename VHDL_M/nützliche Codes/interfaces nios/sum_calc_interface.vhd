

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sum_calc_interface is

  generic (
    BUFFER_SIZE : natural := 1024  -- + vetor para armazenar st_ctrl + valor media
    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;


    -- Avalon Interrupt Interface
    sum_irq : out std_logic;



    -- Avalon MM Slave - Interface
    sum_read       : in  std_logic;
    sum_address    : in  std_logic_vector(10 downto 0);
    sum_chipselect : in  std_logic;
    sum_write      : in  std_logic;
    sum_writedata  : in  std_logic_vector(31 downto 0);
    sum_readdata   : out std_logic_vector(31 downto 0)


    );


end entity sum_calc_interface;


architecture sum_calc_RTL of sum_calc_interface is
  




  type BUFFER_TYPE is array (0 to BUFFER_SIZE-1) of std_logic_vector (31 downto 0);
  type STATE_TYPE is (INIT_ZERO_1, INIT_ZERO_2, NIOS_CTRL, DO_SUM_CALC, WRITE_SUM_REGS, WRITE_RESULT_LOW, WRITE_RESULT_HIGH, WRITE_CTRL_REG,
                      WAIT_1_CYCLE, WAIT_1_CYCLE_2, WAIT_1_CYCLE_3, WAIT_1_CYCLE_4, WAIT_1_CYCLE_5, WAIT_1_CYCLE_6, WAIT_1_CYCLE_7, WAIT_1_CYCLE_8);

  signal state_reg, state_next : STATE_TYPE;
  signal buffer_MEM            : BUFFER_TYPE;


  signal sum_value_size_reg, sum_value_size_next           : std_logic_vector(10 downto 0);  --1024
  signal sum_reg, sum_next                                 : signed(31+32 downto 0);
  signal wr_en, rd_en                                      : std_logic;
  signal buffer_write                                      : std_logic;
  signal vhdl_buffer_write_next, vhdl_buffer_write_reg     : std_logic;
  signal start                                             : std_logic;
  signal address                                           : unsigned(9 downto 0);
  signal vhdl_address_reg, vhdl_address_next               : unsigned(9 downto 0);
  signal value_to_write                                    : std_logic_vector(31 downto 0);
  signal value_to_read                                     : std_logic_vector(31 downto 0);
  signal vhdl_value_to_write_reg, vhdl_value_to_write_next : std_logic_vector(31 downto 0);
  signal control_reg, control_next                         : std_logic_vector(31 downto 0);
  signal sum_value_high_reg, sum_value_high_next           : std_logic_vector(31 downto 0);
  signal sum_value_low_reg, sum_value_low_next             : std_logic_vector(31 downto 0);


  constant sum_value_low_addr  : natural := 0;
  constant sum_value_high_addr : natural := 1;


  
begin



-- =======================================================
-- write/ read decoding logic
-- =======================================================
  wr_en <= '1' when (sum_write = '1' and sum_chipselect = '1' and (unsigned(sum_address) < 1024)) else '0';
  rd_en <= '1' when (sum_read = '1' and sum_chipselect = '1' and (unsigned(sum_address) < 1024))  else '0';



  --=======================================================
  -- memory access mux
  --=======================================================


  buffer_write   <= wr_en                              when start = '0'                   else vhdl_buffer_write_next;  -- next: look_ahead
  address        <= unsigned(sum_address(9 downto 0))  when start = '0'                   else vhdl_address_next;
  value_to_write <= sum_writedata                      when start = '0'                   else vhdl_value_to_write_next;
  sum_readdata  <= value_to_read                       when start = '0' and (rd_en = '1') else (others => '0');



  --=======================================================
  --  memory
  --=======================================================
  process(clk)
  begin
    if rising_edge(clk) then
      if (buffer_write = '1') then
        buffer_MEM(to_integer(address)) <= value_to_write;
      end if;
      value_to_read <= buffer_MEM(to_integer(address));
    end if;
  end process;



  -- =======================================================
  --registradores
  --=======================================================

  process (clk, n_reset)
  begin
    if n_reset = '0' then
      state_reg               <= INIT_ZERO_1;
      vhdl_address_reg        <= (others => '0');
      sum_value_size_reg      <= (others => '0');
      sum_reg                 <= (others => '0');
      vhdl_value_to_write_reg <= (others => '0');
      sum_value_high_reg      <= (others => '0');
      sum_value_low_reg       <= (others => '0');
      control_reg             <= (others => '0');
      vhdl_buffer_write_reg   <= '0';
      
      
    elsif rising_edge(clk) then
      vhdl_value_to_write_reg <= vhdl_value_to_write_next;
      state_reg               <= state_next;
      vhdl_address_reg        <= vhdl_address_next;
      sum_value_size_reg      <= sum_value_size_next;
      sum_reg                 <= sum_next;
      sum_value_high_reg      <= sum_value_high_next;
      sum_value_low_reg       <= sum_value_low_next;
      control_reg             <= control_next;
      vhdl_buffer_write_reg   <= vhdl_buffer_write_next;
      
    end if;
    
    
  end process;




  -- =======================================================
  --IRQ
  -- =======================================================
  sum_irq <= control_reg(1);



  state_machine : process(control_reg,                       
                          sum_value_high_reg,
                          sum_value_low_reg,
                          sum_value_size_reg,
                          state_reg,
                          sum_reg,
                          vhdl_address_reg,
                          vhdl_buffer_write_reg,
                          vhdl_value_to_write_reg,
                          sum_writedata,
                          sum_write,
                          sum_chipselect,
                          value_to_read,
                          sum_address)
  begin


    -- controle do acesso ao registrador de controle
    if (sum_write = '1' and sum_chipselect = '1' and unsigned(sum_address) = 1024) then
      -- limpa a flag toda a vez que ocorre a escrita
      control_next <= sum_writedata(31 downto 2) & '0' & sum_writedata(0);
    else
      control_next <= control_reg;
    end if;

    -- 
    start <= '1';
    vhdl_buffer_write_next <= vhdl_buffer_write_reg;

    --default
    state_next               <= state_reg;
    vhdl_address_next        <= vhdl_address_reg;
    sum_value_size_next      <= sum_value_size_reg;
    vhdl_value_to_write_next <= vhdl_value_to_write_reg;
    sum_next                 <= sum_reg;
    sum_value_high_next      <= sum_value_high_reg;
    sum_value_low_next       <= sum_value_low_reg;


    case state_reg is
      
      
      when INIT_ZERO_1 =>
        vhdl_address_next        <= to_unsigned(BUFFER_SIZE-1, sum_address'length-1);
        vhdl_value_to_write_next <= (others => '0');
        vhdl_buffer_write_next   <= '1';
        state_next               <= INIT_ZERO_2;


      when INIT_ZERO_2 =>
        if vhdl_address_reg = 0 then
          vhdl_value_to_write_next <= (others => '0');
          vhdl_buffer_write_next   <= '0';
          state_next               <= NIOS_CTRL;
        else
          vhdl_address_next <= vhdl_address_reg - 1;
        end if;


        
      when NIOS_CTRL =>

        start <= '0';

        if control_reg(0) = '1' then
          sum_value_size_next  <= control_reg(30 downto 20);  -- 11 bits
          sum_next             <= (others => '0');
          vhdl_address_next    <= resize((unsigned(control_reg(30 downto 20))-1), 10);  
		  state_next           <= WAIT_1_CYCLE;
        end if;

        
      when WAIT_1_CYCLE =>
        state_next <= WAIT_1_CYCLE_2;


      when WAIT_1_CYCLE_2 =>
        state_next <= DO_SUM_CALC;
        

      when DO_SUM_CALC =>

        sum_next   <= sum_reg + resize(signed(value_to_read), sum_reg'length);
        state_next <= WAIT_1_CYCLE_3;


      when WAIT_1_CYCLE_3 =>

        if vhdl_address_reg = 0 then          
          state_next <= WRITE_SUM_REGS;
        else
          vhdl_address_next <= vhdl_address_reg - 1;
          state_next        <= WAIT_1_CYCLE;
        end if;
        
        
      when WRITE_SUM_REGS =>     
        
        sum_value_low_next   <= std_logic_vector(sum_reg(31 downto 0));
        sum_value_high_next  <= std_logic_vector(sum_reg(63 downto 32));
        state_next           <= WRITE_RESULT_LOW;
     


      when WRITE_RESULT_LOW =>

        vhdl_buffer_write_next   <= '1';
        vhdl_value_to_write_next <= sum_value_low_reg;        
        vhdl_address_next        <= to_unsigned(sum_value_low_addr, vhdl_address_reg'length);
        state_next               <= WAIT_1_CYCLE_4;
        
        
      when WAIT_1_CYCLE_4 =>
        state_next <= WAIT_1_CYCLE_5;

      when WAIT_1_CYCLE_5 =>
        state_next <= WRITE_RESULT_HIGH;


      when WRITE_RESULT_HIGH =>
        vhdl_buffer_write_next   <= '1';
        vhdl_value_to_write_next <= sum_value_high_reg(31 downto 0); 
        vhdl_address_next        <= to_unsigned(sum_value_high_addr, vhdl_address_reg'length);
        state_next               <= WAIT_1_CYCLE_6;


      when WAIT_1_CYCLE_6 =>
        vhdl_buffer_write_next <= '0';
        state_next             <= WAIT_1_CYCLE_7;

      when WAIT_1_CYCLE_7 =>
        state_next <= WRITE_CTRL_REG;
        
      when WRITE_CTRL_REG =>
        --seta o controle 
        control_next(0) <= '0'; -- desabilita o algo            
        control_next(1) <= '1'; -- setar irq       

        state_next <= WAIT_1_CYCLE_8;


      when WAIT_1_CYCLE_8 =>
        state_next <= NIOS_CTRL;

      when others =>
        state_next <= NIOS_CTRL;
        
    end case;
  end process state_machine;

end sum_calc_RTL;

