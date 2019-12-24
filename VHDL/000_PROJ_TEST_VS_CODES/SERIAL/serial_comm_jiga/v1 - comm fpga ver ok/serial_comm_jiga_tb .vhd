
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
--use work.my_types_pkg.all;


-------------------------------------------------------------------------------

entity serial_comm_jiga_tb is


end serial_comm_jiga_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of serial_comm_jiga_tb is


  -- component ports
  -- clock
  constant CLKi_PERIOD   : time := 16.6666666 ns;  -- 60 MHz
  constant CLK_EN_period : time := 1 us;           -- 1 MHz

  constant END_OF_TIMES : time := 50 ms;


-- uut signals

  signal uC_REQUEST_i : std_logic                                 := '0';
  signal uC_FPGA_SELECT_i : std_logic                             := '0';
  signal uC_COMMAND_i  : std_logic_vector(7 downto 0)  := (others => '0');
  signal uC_DATA_i     : std_logic_vector(31 downto 0) := (others => '0');
  signal DATA_TO_uC_RECEIVED_i: std_logic              := '0';
  signal DATA_TO_uC_READY_o: std_logic                 := '0';
  signal FPGA_TX2      : std_logic                     := '0';
  signal FPGA_RX2      : std_logic                     := '0';
  signal FPGA_TX3      : std_logic                     := '0';
  signal FPGA_RX3      : std_logic                     := '0';
  signal CLK_60MHz_i   : std_logic                     := '0';
  signal CLK_EN_1MHz_i : std_logic                     := '0';
  signal reset         : std_logic                     := '0';


begin

  -- 60 MHz
  CLK_60MHz_i   <= not CLK_60MHz_i   after CLKi_PERIOD/2;
  CLK_EN_1MHz_i <= not CLK_EN_1MHz_i after CLK_EN_period/2;

  -- reset generation
  reset_n_proc : process
  begin
    reset <= '1';
    wait for 10*CLKi_PERIOD;
    reset <= '0';
    wait for END_OF_TIMES;
  end process;





  FPGA1_1 : entity work.FPGA1
    port map (
      FPGA_TX2 => FPGA_TX2,
      FPGA_RX2 => FPGA_RX2,
      FPGA_TX3 => FPGA_TX3,
      FPGA_RX3 => FPGA_RX3,

      CLK_60MHz_i   => CLK_60MHz_i,
      CLK_EN_1MHz_i => CLK_EN_1MHz_i,
      RST_i         => reset,

      uC_REQUEST_i          => uC_REQUEST_i,
      uC_FPGA_SELECT_i      => uC_FPGA_SELECT_i,
      uC_COMMAND_i          => uC_COMMAND_i,
      uC_DATA_i             => uC_DATA_i,
      DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,
      DATA_TO_uC_READY_o    => DATA_TO_uC_READY_o,

      R_COMP_o       => open,
      TEST_FED_OUT_o => open,
      EJET_o         => open,
      REAR_LED_A_o   => open,
      REAR_LED_B_o   => open,
      REAR_LED_C_o   => open,
      REAR_LED_D_o   => open,
      FRONT_LED_A_o  => open,
      FRONT_LED_B_o  => open,
      FRONT_LED_C_o  => open,
      FRONT_LED_D_o  => open,
	  FPGA_2_VERSION_o  => open,                     
	  FPGA_3_VERSION_o  => open,
	  R2R_i => (others => '0'),
	  V_BCKGND_o  => open	  
	); 



  FPGA2_1 : entity work.FPGA2
    port map (
      FPGA2_TX2 => FPGA_TX2,
      FPGA2_RX2 => FPGA_RX2,

      CLK_60MHz_i   => CLK_60MHz_i,
      CLK_EN_1MHz_i => CLK_EN_1MHz_i,
      RST_i         => reset,

      FRONT_LED_A_i      => '0',
      FRONT_LED_B_i      => '0',
      FRONT_LED_C_i      => '0',
      FRONT_LED_D_i      => '0',
      REAR_LED_A_i       => '0',
      REAR_LED_B_i       => '0',
      REAR_LED_C_i       => '0',
      REAR_LED_D_i       => '0',
      V_BCKGND_i         => '0',
      R2R1_o             => open,
      R2R2_o             => open,
      R2R3_o             => open,
      R2R4_o             => open,
      EJET_i             => (others => '0'),
      EJECTOR_COM_TEST_i => '0',
      EJECTOR_COM_TEST_o => open
	  );



  FPGA3_1 : entity work.FPGA3
    port map (
      FPGA3_TX3 => FPGA_TX3,
      FPGA3_RX3 => FPGA_RX3,

      CLK_60MHz_i   => CLK_60MHz_i,
      CLK_EN_1MHz_i => CLK_EN_1MHz_i,
      RST_i         => reset,

      R_TEST_o       => open,
      TEST_FED_OUT_i => (others => '0'),
      R_COMP_i       => (others => '0')
	  ); -- 32 bits);

  
  
  
	  -- uC_REQUEST_i          => uC_REQUEST_i,
      -- uC_FPGA_SELECT_i      => uC_FPGA_SELECT_i,
      -- uC_COMMAND_i          => uC_COMMAND_i,
      -- uC_DATA_i             => uC_DATA_i,
      -- DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,
      -- DATA_TO_uC_READY_o    => DATA_TO_uC_READY_o,
  

  sending_state_machine : process(CLK_60MHz_i, reset)
    constant STATE_END    : natural := 1000;
    variable time_counter : unsigned(31 downto 0);
  begin
    if reset = '1' then
      time_counter := (others => '0');
	  uC_REQUEST_i <= '0';
	  uC_FPGA_SELECT_i <= '0';   -- reg 
	  uC_COMMAND_i     <= (others => '0'); -- reg    
	  DATA_TO_uC_RECEIVED_i <= '0';	  
      
      
    elsif rising_edge(CLK_60MHz_i) then

      -- default 
      time_counter := time_counter + 1;
	  DATA_TO_uC_RECEIVED_i <= '0';
      uC_REQUEST_i <= '0';	
      ---------------------

	  -- reads version FPGA 2
      if time_counter = 100 then
			uC_REQUEST_i <= '1';
			uC_FPGA_SELECT_i <= '0';  --"2"
			uC_COMMAND_i    <= "00000000"; 
      end if;	  
	  
	  
	  if time_counter = 200 then
		DATA_TO_uC_RECEIVED_i <= '1';
      end if;	  
	  
	  
	  -- reads version FPGA 3 
	  if time_counter = 400 then
			uC_REQUEST_i <= '1';
			uC_FPGA_SELECT_i <= '1';  --"3"
			uC_COMMAND_i    <= "00000000"; 
      end if;	  
	  
	  
	  if time_counter = 600 then
		DATA_TO_uC_RECEIVED_i <= '1';
      end if;	  

      -- end condition 
      if time_counter = STATE_END then
        time_counter := (others => '0');
      end if;
      -------- 
    end if;
  end process;



end generic_tb_rtl;



-- LocalWords:  microcontrolador ativa envio
