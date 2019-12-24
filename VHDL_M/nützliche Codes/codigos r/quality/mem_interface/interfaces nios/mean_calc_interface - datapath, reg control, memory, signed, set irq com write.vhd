-- ok  -- funcionamento: write e chipselect acionados ao mesmo tempo: escrita instantanea no endereço indicado pelo 
-- ok                                    -- barramento address
-- ok  -- monitoramento constante do endereço "control_status"
-- se iniciar, setar o regitrador status para o software parar de mandar requisições
-- wr_en, rd_en 
-- 2 processos concorrentes tentando acessar a memoria
-- so um pode acessar simultaneamente
-- fazer um mux com wr_en e address_mem
-- process que mnitora a memoria de controle quando rd_en = '0'
-- apagar registradores de gravação do controle
-- acessa-los com multiplexador, se address for maior que 1023 então
-- ok  -- 2 processos concorrentes tentando acessar a memoria
-- ok  -- so um pode acessar simultaneamente
-- ok  -- fazer um mux com wr_en e address_mem
-- ok process que monitora a memoria de controle quando rd:en = '0'
-- ok eliminar primeira parte da maquina de estados, fazer monitoração do registrador
-- ok fazer maquina 64 bits escrever 1, depois o outro
-- ok -- remover registradores write e read address reg

-- look ahead - leitura 1 ciclo
-- escrita - 2 ciclos para ter o valor no barramento
-- 22/2 - sum_reg --> signed



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mean_calc_interface is

  generic (
    BUFFER_SIZE : natural := 1024  -- + vetor para armazenar st_ctrl + valor media
    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;


    -- Avalon Interrupt Interface
    mclc_irq : out std_logic;



    -- Avalon MM Slave - Interface
    mclc_read       : in  std_logic;
    mclc_address    : in  std_logic_vector(10 downto 0);
    mclc_chipselect : in  std_logic;
    mclc_write      : in  std_logic;
    mclc_writedata  : in  std_logic_vector(31 downto 0);
    mclc_readdata   : out std_logic_vector(31 downto 0)


    );


end entity mean_calc_interface;


architecture mean_calc_RTL of mean_calc_interface is





  -- buffer size "-2" por cause que o último valor é um registrador externo
  type BUFFER_TYPE is array (0 to BUFFER_SIZE-1) of std_logic_vector (31 downto 0);
  type STATE_TYPE is (INIT_ZERO_1, INIT_ZERO_2, NIOS_CTRL, DO_SUM_CALC, START_DIV_ST, WAIT_RDY_DIV, WRITE_RESULT_LOW, WRITE_RESULT_HIGH, WRITE_CTRL_REG,
                      WAIT_1_CYCLE, WAIT_1_CYCLE_2, WAIT_1_CYCLE_3, WAIT_1_CYCLE_4, WAIT_1_CYCLE_5, WAIT_1_CYCLE_6, WAIT_1_CYCLE_7, WAIT_1_CYCLE_8);

  signal state_reg, state_next : STATE_TYPE;
  signal buffer_MEM            : BUFFER_TYPE;


  signal mean_value_size_reg, mean_value_size_next         : std_logic_vector(10 downto 0);  --1024
  signal sum_reg, sum_next                                 : signed(31+32 downto 0);
  signal wr_en, rd_en                                      : std_logic;
  signal buffer_write                                      : std_logic;
  signal vhdl_buffer_write_next, vhdl_buffer_write_reg     : std_logic;
  signal done_div                                          : std_logic;
  signal start                                             : std_logic;
  signal div_start                                         : std_logic;
  signal address                                           : unsigned(9 downto 0);
  signal vhdl_address_reg, vhdl_address_next               : unsigned(9 downto 0);
  signal value_to_write                                    : std_logic_vector(31 downto 0);
  signal value_to_read                                     : std_logic_vector(31 downto 0);
  signal mean_value_tmp                                    : std_logic_vector(31+32 downto 0);
  signal vhdl_value_to_write_reg, vhdl_value_to_write_next : std_logic_vector(31 downto 0);
  signal control_reg, control_next                         : std_logic_vector(31 downto 0);
  signal mean_value_high_reg, mean_value_high_next         : std_logic_vector(31 downto 0);
  signal mean_value_low_reg, mean_value_low_next           : std_logic_vector(31 downto 0);
  signal sign_bit_sum_reg, sign_bit_sum_next               : std_logic;



  constant mean_value_low_addr  : natural := 0;
  constant mean_value_high_addr : natural := 1;


  
begin



-- =======================================================
-- write/ read decoding logic
-- =======================================================
  wr_en <= '1' when (mclc_write = '1' and mclc_chipselect = '1' and (unsigned(mclc_address) < 1024)) else '0';
  rd_en <= '1' when (mclc_read = '1' and mclc_chipselect = '1' and (unsigned(mclc_address) < 1024))  else '0';



  --=======================================================
  -- memory access mux
  --=======================================================


  buffer_write   <= wr_en                              when start = '0'                   else vhdl_buffer_write_next;  -- next: look_ahead
  address        <= unsigned(mclc_address(9 downto 0)) when start = '0'                   else vhdl_address_next;
  value_to_write <= mclc_writedata                     when start = '0'                   else vhdl_value_to_write_next;
  mclc_readdata  <= value_to_read                      when start = '0' and (rd_en = '1') else (others => '0');



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
      mean_value_size_reg     <= (others => '0');
      sum_reg                 <= (others => '0');
      vhdl_value_to_write_reg <= (others => '0');
      mean_value_high_reg     <= (others => '0');
      mean_value_low_reg      <= (others => '0');
      control_reg             <= (others => '0');
      vhdl_buffer_write_reg   <= '0';
      sign_bit_sum_reg        <= '0';
      
      
    elsif rising_edge(clk) then
      vhdl_value_to_write_reg <= vhdl_value_to_write_next;
      state_reg               <= state_next;
      vhdl_address_reg        <= vhdl_address_next;
      mean_value_size_reg     <= mean_value_size_next;
      sum_reg                 <= sum_next;
      mean_value_high_reg     <= mean_value_high_next;
      mean_value_low_reg      <= mean_value_low_next;
      control_reg             <= control_next;
      vhdl_buffer_write_reg   <= vhdl_buffer_write_next;
      sign_bit_sum_reg        <= sign_bit_sum_next;
    end if;
    
    
  end process;




  -- =======================================================
  --IRQ
  -- =======================================================
  mclc_irq <= control_reg(1);



  state_machine : process(control_reg,
                          done_div,
                          mean_value_high_reg,
                          mean_value_low_reg,
                          mean_value_size_reg,
                          mean_value_tmp,
                          state_reg,
                          sum_reg,
                          vhdl_address_reg,
                          vhdl_buffer_write_reg,
                          vhdl_value_to_write_reg,
                          mclc_writedata,
                          mclc_write,
                          mclc_chipselect,
                          value_to_read,
                          mclc_address,
                          sign_bit_sum_reg
                          )



  begin


    -- controle do acesso ao registrador de controle
    if (mclc_write = '1' and mclc_chipselect = '1' and unsigned(mclc_address) = 1024) then
      -- limpa a flag toda a vez que ocorre a escrita
      control_next <= mclc_writedata(31 downto 2) & '0' & mclc_writedata(0);
    else
      control_next <= control_reg;
    end if;


    -- 
    start <= '1';

    --status/ctrl

    -- vhdl_buffer_write_next <= vhdl_buffer_write_reg;
    vhdl_buffer_write_next <= vhdl_buffer_write_reg;


    --datapath ctrl
    div_start <= '0';

    --default
    state_next               <= state_reg;
    vhdl_address_next        <= vhdl_address_reg;
    mean_value_size_next     <= mean_value_size_reg;
    vhdl_value_to_write_next <= vhdl_value_to_write_reg;
    sum_next                 <= sum_reg;
    mean_value_high_next     <= mean_value_high_reg;
    mean_value_low_next      <= mean_value_low_reg;
    sign_bit_sum_next        <= sign_bit_sum_reg;


    case state_reg is
      
      
      when INIT_ZERO_1 =>
        vhdl_address_next        <= to_unsigned(BUFFER_SIZE-1, mclc_address'length-1);
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
          sign_bit_sum_next    <= '0';
          mean_value_size_next <= control_reg(30 downto 20);  -- 11 bits
          sum_next             <= (others => '0');
          state_next           <= WAIT_1_CYCLE;
          vhdl_address_next    <= resize((unsigned(control_reg(30 downto 20))-1), 10);
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
          -- salva informação sobre sinal
          if(sum_reg(63)) = '1' then
            sign_bit_sum_next <= '1';
          end if;

          state_next <= START_DIV_ST;
        else
          vhdl_address_next <= vhdl_address_reg - 1;
          state_next        <= WAIT_1_CYCLE;
        end if;
        
        
      when START_DIV_ST =>
        div_start  <= '1';
        state_next <= WAIT_RDY_DIV;

      when WAIT_RDY_DIV =>
        
        if done_div = '1' then

          -- gravar parte alta, parte baixa
          mean_value_low_next  <= mean_value_tmp(31 downto 0);
          -- retona o valor do bit mais significativo
          mean_value_high_next <= sign_bit_sum_reg & mean_value_tmp(62 downto 32);
          state_next           <= WRITE_RESULT_LOW;
        end if;


      when WRITE_RESULT_LOW =>

        vhdl_buffer_write_next   <= '1';
        vhdl_value_to_write_next <= mean_value_low_reg;  -- do datapath
        vhdl_address_next        <= to_unsigned(mean_value_low_addr, vhdl_address_reg'length);
        state_next               <= WAIT_1_CYCLE_4;
        
        
      when WAIT_1_CYCLE_4 =>
        state_next <= WAIT_1_CYCLE_5;

      when WAIT_1_CYCLE_5 =>
        state_next <= WRITE_RESULT_HIGH;


      when WRITE_RESULT_HIGH =>
        vhdl_buffer_write_next   <= '1';
        vhdl_value_to_write_next <= mean_value_high_reg(31 downto 0);  -- do datapath
        vhdl_address_next        <= to_unsigned(mean_value_high_addr, vhdl_address_reg'length);
        state_next               <= WAIT_1_CYCLE_6;


      when WAIT_1_CYCLE_6 =>
        vhdl_buffer_write_next <= '0';
        state_next             <= WAIT_1_CYCLE_7;


      when WAIT_1_CYCLE_7 =>
        state_next <= WRITE_CTRL_REG;
        
      when WRITE_CTRL_REG =>
        --seta o controle 
        control_next(0) <= '0';         -- nao inicia novamente o algo        
        control_next(1) <= '1';         -- seta a irq  = '0'

        state_next <= WAIT_1_CYCLE_8;


      when WAIT_1_CYCLE_8 =>
        state_next <= NIOS_CTRL;

      when others =>
        state_next <= NIOS_CTRL;
        
    end case;
  end process state_machine;



  divider_1 : entity work.divider
    generic map (
      N => (32+32),
      D => 11                           -- 11 bits - 1024
      )
    port map (
      sysclk  => clk,
      n_reset => n_reset,
      start   => div_start,
      num     => std_logic_vector(sum_reg),
      den     => mean_value_size_reg,
      quo     => mean_value_tmp,
      rema    => open,
      ready   => open,
      done    => done_div);

end mean_calc_RTL;

