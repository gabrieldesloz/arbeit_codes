-- requisi��o leitura  - no 2o ciclo - leitura
-- requisi��o escrita  - no 3o ciclo - leitura
-- n_points 1022 - valores lidos - 1023 



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rms_interface is
  generic (
    N_BITS      : natural := 13;
    BUFFER_SIZE : natural := 4096
    );      
  port (
    -- Avalon clock Interface
    clk            : in  std_logic;
    -- Reset Sync
    n_reset        : in  std_logic;
    -- Avalon Interrupt Interface
    rms_irq        : out std_logic;
    -- Avalon MM Slave - Interface
    rms_read       : in  std_logic;
    rms_address    : in  std_logic_vector(N_BITS-1 downto 0);  -- 1 bit a mais que
                                                               -- buffer size                                                        
    rms_chipselect : in  std_logic;
    rms_write      : in  std_logic;
    rms_writedata  : in  std_logic_vector(31 downto 0);
    rms_readdata   : out std_logic_vector(31 downto 0)
    );
end entity rms_interface;


architecture rms_interface_RTL of rms_interface is

  

  type BUFFER_TYPE is array (0 to BUFFER_SIZE-1) of std_logic_vector (31 downto 0);
  type STATE_TYPE is (NIOS_CTRL, READ_RMS_VALUES_INIT, DATA_AVAILABLE_INIT, WAIT_RMS_SM_DELAY, READ_ADDRESS_DECODER, WAIT_RMS_DATA_READY, WRITE_RMS_MEM);

  signal state_reg, state_next : STATE_TYPE;
  signal buffer_MEM            : BUFFER_TYPE;

  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";



--control signals
  signal wr_en, rd_en                                      : std_logic;
  signal buffer_write                                      : std_logic;
  signal vhdl_buffer_write_next, vhdl_buffer_write_reg     : std_logic;
  signal start_reg, start_next                             : std_logic;
  -- 1 bit a menos
  signal address                                           : unsigned(N_BITS-2 downto 0);
  signal vhdl_address_reg, vhdl_address_next               : unsigned(N_BITS-2 downto 0);
  signal value_to_write                                    : std_logic_vector(31 downto 0);
  signal value_to_read                                     : std_logic_vector(31 downto 0);
  signal vhdl_value_to_write_reg, vhdl_value_to_write_next : std_logic_vector(31 downto 0);
  signal control_reg, control_next                         : std_logic_vector(31 downto 0);
  signal wr_en_ctrl_reg                                    : std_logic;
  signal count_wait_next, count_wait_reg                   : natural range 0 to 10;
  signal data_available_reg, data_available_next           : std_logic;

-- datapth signals
  signal data_ready                    : std_logic;
  signal n_point_samples_next          : std_logic_vector(N_BITS-2 downto 0);
  signal n_point_samples_reg           : std_logic_vector(N_BITS-2 downto 0);
  signal data_output                   : std_logic_vector(rms_readdata'range);
  signal rms_value_next, rms_value_reg : std_logic_vector(data_output'range);
  
  
  

  
begin



-- =======================================================
-- write/ read decoding logic
-- =======================================================
  wr_en          <= '1' when (rms_write = '1' and rms_chipselect = '1' and (unsigned(rms_address) < BUFFER_SIZE)) else '0';
  rd_en          <= '1' when (rms_read = '1' and rms_chipselect = '1' and (unsigned(rms_address) < BUFFER_SIZE))  else '0';
  wr_en_ctrl_reg <= '1' when (rms_write = '1' and rms_chipselect = '1' and (unsigned(rms_address) = BUFFER_SIZE)) else '0';


-- =======================================================
-- memory access mux
-- =======================================================


  buffer_write   <= wr_en                                    when start_reg = '0'                   else vhdl_buffer_write_reg;
  address        <= unsigned(rms_address(N_BITS-2 downto 0)) when start_reg = '0'                   else vhdl_address_reg;
  value_to_write <= rms_writedata                            when start_reg = '0'                   else vhdl_value_to_write_reg;
  rms_readdata   <= value_to_read                            when start_reg = '0' and (rd_en = '1') else (others => '0');



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
      rms_value_reg           <= (others => '0');
      data_available_reg      <= '0';
      n_point_samples_reg     <= (others => '0');
      count_wait_reg          <= 0;
      state_reg               <= NIOS_CTRL;
      vhdl_address_reg        <= (others => '0');
      vhdl_value_to_write_reg <= (others => '0');
      control_reg             <= (others => '0');
      vhdl_buffer_write_reg   <= '0';
      start_reg               <= '0';
    elsif rising_edge(clk) then
      rms_value_reg           <= rms_value_next;
      data_available_reg      <= data_available_next;
      n_point_samples_reg     <= n_point_samples_next;
      count_wait_reg          <= count_wait_next;
      vhdl_value_to_write_reg <= vhdl_value_to_write_next;
      state_reg               <= state_next;
      vhdl_address_reg        <= vhdl_address_next;
      control_reg             <= control_next;
      vhdl_buffer_write_reg   <= vhdl_buffer_write_next;
      start_reg               <= start_next;
    end if;
  end process;




  -- =======================================================
  --IRQ
  -- =======================================================
  rms_irq <= control_reg(1);



  state_machine : process(control_reg, start_reg,
                          count_wait_reg, data_output, data_ready,
                          n_point_samples_reg, rms_value_reg,
                          rms_writedata, state_reg,
                          vhdl_address_reg, vhdl_buffer_write_reg,
                          vhdl_value_to_write_reg, wr_en_ctrl_reg)
  begin


    -- controle do acesso aos registradores ----------------------------------- 
    if (wr_en_ctrl_reg = '1') then
      control_next <= rms_writedata(31 downto 0);
    else
      control_next <= control_reg;
    end if;

    ---------------------------------------------------------------------------

    --default
    start_next               <= '1';
    data_available_next      <= '0';
    count_wait_next          <= count_wait_reg;
    state_next               <= state_reg;
    vhdl_buffer_write_next   <= '0';
    vhdl_address_next        <= vhdl_address_reg;
    vhdl_value_to_write_next <= vhdl_value_to_write_reg;
    n_point_samples_next     <= n_point_samples_reg;
    rms_value_next           <= rms_value_reg;

    case state_reg is

      --memory clear ---------------------------
      --when INIT_ZERO_1 =>
      --  vhdl_address_next        <= to_unsigned(BUFFER_SIZE-1, rms_address'length-1);
      --  vhdl_value_to_write_next <= (others => '0');
      --  vhdl_buffer_write_next   <= '1';
      --  state_next               <= INIT_ZERO_2;


      --when INIT_ZERO_2 =>
      --  if vhdl_address_reg = 0 then
      --    vhdl_value_to_write_next <= (others => '0');
      --    vhdl_buffer_write_next   <= '0';
      --    state_next               <= NIOS_CTRL;
      --  else
      --    vhdl_address_next <= vhdl_address_reg - 1;
      --  end if;
      -------------------------------------------------------------------------
      
      
      when NIOS_CTRL =>
        start_next <= '0';
        if control_reg(0) = '1' then
          -- 31 downto 20 - 10 bits
          n_point_samples_next <= control_reg(rms_readdata'left downto (rms_readdata'length-n_point_samples_reg'length));
          control_next(0)      <= '0';
          state_next           <= READ_RMS_VALUES_INIT;
        end if;
        

      when READ_RMS_VALUES_INIT =>
        vhdl_address_next <= unsigned(n_point_samples_reg);  -- + 1        
        -- read mem delay ----------
        if count_wait_reg = 1 then
          state_next      <= DATA_AVAILABLE_INIT;
          count_wait_next <= 0;
        else
          count_wait_next <= count_wait_reg + 1;
        end if;
        -----------------------------
        
      when DATA_AVAILABLE_INIT =>
        data_available_next <= '1';
        state_next          <= WAIT_RMS_SM_DELAY;

      when WAIT_RMS_SM_DELAY =>
        -- rms state_machine delay--------
        if count_wait_reg = 4 then
          state_next      <= READ_ADDRESS_DECODER;
          count_wait_next <= 0;
        else
          count_wait_next <= count_wait_reg + 1;
        end if;
        ----------------------------------

      when READ_ADDRESS_DECODER =>
        if vhdl_address_reg = 0 then
          state_next <= WAIT_RMS_DATA_READY;
        else
          vhdl_address_next <= vhdl_address_reg - 1;
          state_next        <= DATA_AVAILABLE_INIT;
        end if;


      when WAIT_RMS_DATA_READY =>
        if (data_ready = '1') then
          rms_value_next <= data_output;
          state_next     <= WRITE_RMS_MEM;
        end if;


      when WRITE_RMS_MEM =>
        vhdl_address_next        <= to_unsigned(0, rms_address'length-1);
        vhdl_value_to_write_next <= rms_value_reg;
        vhdl_buffer_write_next   <= '1';
        control_next(0)          <= '0';  -- nao inicializa mais



        -- memory_write delay--------
        if count_wait_reg = 7 then
          control_next(1) <= '1';       -- irq 

          state_next      <= NIOS_CTRL;
          count_wait_next <= 0;
        else
          count_wait_next <= count_wait_reg + 1;
        end if;
        ----------------------------------
        

      when others =>
        state_next <= NIOS_CTRL;
        
        
    end case;
  end process state_machine;



  -----------------------------------------------------------------------------
  -- datapath components
  -----------------------------------------------------------------------------

  rms_1 : entity work.rms
    generic map (
      N_BITS_INPUT  => rms_writedata'length,
      N_POINTS_BITS => n_point_samples_reg'length)
    port map (
      sysclk          => clk,
      reset_n         => n_reset,
      data_input      => value_to_read,
      data_available  => data_available_reg,
      n_point_samples => n_point_samples_reg,
      data_output     => data_output,
      data_ready      => data_ready);



end rms_interface_RTL;

