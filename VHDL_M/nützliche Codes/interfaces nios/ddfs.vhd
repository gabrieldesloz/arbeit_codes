-- 4096 amostras minimo
-- palavra configurável
-- estado preenchimento da memoria

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ddfs is

  generic (
    BUFFER_SIZE : natural := 4096;
    K_WORD      : natural := 274877907

    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;


    -- Avalon Interrupt Interface
    ddfs_irq : out std_logic;



    -- Avalon MM Slave - Interface
    ddfs_read       : in  std_logic;
    ddfs_address    : in  std_logic_vector(12 downto 0);  -- 1 bit a mais que
                                                          -- buffer size                                                        
    ddfs_chipselect : in  std_logic;
    ddfs_write      : in  std_logic;
    ddfs_writedata  : in  std_logic_vector(31 downto 0);
    ddfs_readdata   : out std_logic_vector(31 downto 0)


    );


end entity ddfs;


architecture ddfs_RTL of ddfs is



  type BUFFER_TYPE is array (0 to BUFFER_SIZE-1) of std_logic_vector (31 downto 0);
  type STATE_TYPE is (INIT_ZERO_1, INIT_ZERO_2, NIOS_CTRL, INIT_WRITE_DCO_INFO, WRITE_DCO_INFO, WAIT_1_CYCLE, WAIT_1_CYCLE_2);

  signal state_reg, state_next : STATE_TYPE;
  signal buffer_MEM            : BUFFER_TYPE;

--control signals
  signal wr_en, rd_en                                      : std_logic;
  signal buffer_write                                      : std_logic;
  signal vhdl_buffer_write_next, vhdl_buffer_write_reg     : std_logic;
  signal start                                             : std_logic;
  signal address                                           : unsigned(11 downto 0);
  signal vhdl_address_reg, vhdl_address_next               : unsigned(11 downto 0);
  signal value_to_write                                    : std_logic_vector(31 downto 0);
  signal value_to_read                                     : std_logic_vector(31 downto 0);
  signal vhdl_value_to_write_reg, vhdl_value_to_write_next : std_logic_vector(31 downto 0);
  signal control_reg, control_next                         : std_logic_vector(31 downto 0);
  signal wr_en_4096, wr_en_4097                            : std_logic;


-- datapth signals
  signal phi_inc_i_next, phi_inc_i_reg : std_logic_vector (31 downto 0);
  signal fsin_o                        : std_logic_vector (31 downto 0);
  signal clken                         : std_logic;
  signal out_valid                     : std_logic;

  

  
begin



-- =======================================================
-- write/ read decoding logic
-- =======================================================
  wr_en <= '1' when (ddfs_write = '1' and ddfs_chipselect = '1' and (unsigned(ddfs_address) < 4096)) else '0';
  rd_en <= '1' when (ddfs_read = '1' and ddfs_chipselect = '1' and (unsigned(ddfs_address) < 4096))  else '0';

  wr_en_4096 <= '1' when (ddfs_write = '1' and ddfs_chipselect = '1' and (unsigned(ddfs_address) = 4096)) else '0';
  wr_en_4097 <= '1' when (ddfs_write = '1' and ddfs_chipselect = '1' and (unsigned(ddfs_address) = 4097)) else '0';


-- =======================================================
-- memory access mux
-- =======================================================


  buffer_write   <= wr_en                               when start = '0'                   else vhdl_buffer_write_reg;
  address        <= unsigned(ddfs_address(11 downto 0)) when start = '0'                   else vhdl_address_reg;
  value_to_write <= ddfs_writedata                      when start = '0'                   else vhdl_value_to_write_reg;
  ddfs_readdata  <= value_to_read                       when start = '0' and (rd_en = '1') else (others => '0');



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
      vhdl_value_to_write_reg <= (others => '0');
      control_reg             <= (others => '0');
      vhdl_buffer_write_reg   <= '0';
      phi_inc_i_reg           <= (others => '0');

      
      
    elsif rising_edge(clk) then
      vhdl_value_to_write_reg <= vhdl_value_to_write_next;
      state_reg               <= state_next;
      vhdl_address_reg        <= vhdl_address_next;
      control_reg             <= control_next;
      vhdl_buffer_write_reg   <= vhdl_buffer_write_next;
      phi_inc_i_reg           <= phi_inc_i_next;
      
    end if;
    
    
  end process;




  -- =======================================================
  --IRQ
  -- =======================================================
  ddfs_irq <= control_reg(1);



  state_machine : process(control_reg,
                          ddfs_writedata,
                          fsin_o,
                          out_valid,
                          phi_inc_i_reg,
                          state_reg,
                          vhdl_address_reg,
                          vhdl_buffer_write_reg,
                          vhdl_value_to_write_reg,
                          wr_en_4096,
                          wr_en_4097)

  begin


    -- controle do acesso aos registradores -----------------------------------
    if (wr_en_4097 = '1') then
      phi_inc_i_next <= ddfs_writedata(31 downto 0);
    else
      phi_inc_i_next <= phi_inc_i_reg;
    end if;

    if (wr_en_4096 = '1') then
      control_next <= ddfs_writedata(31 downto 0);
    else
      control_next <= control_reg;
    end if;

    ---------------------------------------------------------------------------


    --
    clken <= '0';
    start <= '1';

    --default
    state_next               <= state_reg;
    vhdl_buffer_write_next   <= vhdl_buffer_write_reg;
    vhdl_address_next        <= vhdl_address_reg;
    vhdl_value_to_write_next <= vhdl_value_to_write_reg;


    case state_reg is

      ----------------------------memory initialization ---------------------------
      when INIT_ZERO_1 =>
        vhdl_address_next        <= to_unsigned(BUFFER_SIZE-1, ddfs_address'length-1);
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
        -------------------------------------------------------------------------
        
        
      when NIOS_CTRL =>
        start <= '0';

        if control_reg(0) = '1' then
          state_next <= INIT_WRITE_DCO_INFO;
        end if;
        

      when INIT_WRITE_DCO_INFO =>

        clken <= '1';

        if out_valid = '1' then
          vhdl_buffer_write_next   <= '1';
          vhdl_value_to_write_next <= fsin_o;
          vhdl_address_next        <= to_unsigned(BUFFER_SIZE-1, vhdl_address_reg'length);
          state_next               <= WAIT_1_CYCLE;
        end if;

      when WRITE_DCO_INFO =>
        
        clken <= '1';

        if vhdl_address_reg = 0 then
          clken           <= '0';
          control_next(0) <= '0';       -- nao inicia novamente o algo        
          control_next(1) <= '1';       -- seta a irq  = '0'
          state_next      <= WAIT_1_CYCLE_2;
        elsif out_valid = '1' then
          vhdl_buffer_write_next   <= '1';
          vhdl_value_to_write_next <= fsin_o;
          vhdl_address_next        <= vhdl_address_reg - 1;
          state_next               <= WAIT_1_CYCLE;
        end if;

      when WAIT_1_CYCLE =>
        state_next <= WRITE_DCO_INFO;

      when WAIT_1_CYCLE_2 =>
        
        state_next <= NIOS_CTRL;

        
    end case;
  end process state_machine;


  nco_altera_1 : entity work.nco_altera
    port map (
      phi_inc_i => phi_inc_i_reg,       --85899346 / 1 MHz /274877907 100 KHz
      clk       => clk,
      reset_n   => n_reset,
      clken     => clken,
      fsin_o    => fsin_o,
      out_valid => out_valid);

end ddfs_RTL;

