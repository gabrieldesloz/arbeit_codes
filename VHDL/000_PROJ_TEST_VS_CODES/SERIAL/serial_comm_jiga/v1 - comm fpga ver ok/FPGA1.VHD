library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


library UNISIM;
use UNISIM.VComponents.all;

entity FPGA1 is

  port(
-- fpga comm
    FPGA_TX2 : in std_logic;
    FPGA_RX2 : out std_logic;
    FPGA_TX3 : in std_logic;
    FPGA_RX3 : out std_logic;

-- system signals
    CLK_60MHz_i   : in std_logic;
    CLK_EN_1MHz_i : in std_logic;
    RST_i         : in std_logic;

-- uc comm
    uC_REQUEST_i     		: in std_logic;
    uC_FPGA_SELECT_i 		: in std_logic;
    uC_COMMAND_i     		: in std_logic_vector(7 downto 0);
    uC_DATA_i        		: in std_logic_vector(31 downto 0);
	DATA_TO_uC_RECEIVED_i	: in std_logic;
	DATA_TO_uC_READY_o      : out std_logic;

-- testes
    R_COMP_o       : out std_logic_vector(31 downto 0);
    TEST_FED_OUT_o : out std_logic_vector(11 downto 0);
    EJET_o         : out std_logic_vector(31 downto 0);
    REAR_LED_A_o   : out std_logic;
    REAR_LED_B_o   : out std_logic;
    REAR_LED_C_o   : out std_logic;
    REAR_LED_D_o   : out std_logic;
    FRONT_LED_A_o  : out std_logic;
    FRONT_LED_B_o  : out std_logic;
    FRONT_LED_C_o  : out std_logic;
    FRONT_LED_D_o  : out std_logic;
	FPGA_2_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);                     
	FPGA_3_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);
	R2R_i : in STD_LOGIC_VECTOR(7 downto 0)	;
	V_BCKGND_o : out STD_LOGIC	
	
	
	);

end entity;


architecture arq of FPGA1 is

  signal s_FPGA_TX2, s_FPGA_TX3           : std_logic;
  signal s_send_FPGA2, s_send_FPGA3       : std_logic;
  signal s_sent_FPGA2, s_sent_FPGA3       : std_logic;
  signal s_ready_FPGA2, s_ready_FPGA3     : std_logic;
  signal s_fail_FPGA2, s_fail_FPGA3       : std_logic;
  signal s_tx_data_FPGA2, s_tx_data_FPGA3 : std_logic_vector(7 downto 0);
  signal s_rx_data_FPGA2, s_rx_data_FPGA3 : std_logic_vector(7 downto 0);

begin



  i_INTER_FPGA_COMMUNICATION_FPGA_1_2 : entity work.SERIAL_COMMUNICATION_fpga_1
    port map (
      RX_i      => FPGA_TX2,  -- sinal externo vindo do FPGA 2 -- Received data bit                                   
      TX_DATA_i => s_tx_data_FPGA2,  -- <= MASTER_SERIAL_COMMANDS -- Byte to be sent                                     
      SEND_i    => s_send_FPGA2,  -- <= MASTER_SERIAL_COMMANDS --Flag to send byte (rising edge activated)

      CLK_60MHz_i   => CLK_60MHz_i,
      CLK_EN_1MHz_i => CLK_EN_1MHz_i,   --???
      RST_i         => RST_i,

      TX_o => FPGA_RX2,                 -- sinal indo para FPGA 2

      SENT_o    => s_sent_FPGA2,  -- => MASTER_SERIAL_COMMANDS -- Indicates packet has been send to FPGA 2
      FAIL_o    => s_fail_FPGA2,  -- => MASTER_SERIAL_COMMANDS -- Indicates packet received FPGA 2 has failed
      READY_o   => s_ready_FPGA2,  -- => MASTER_SERIAL_COMMANDS -- Indicates that packet received from FPGA 2 is ready
      RX_DATA_o => s_rx_data_FPGA2  -- => MASTER_SERIAL_COMMANDS -- serial data output for  MASTER_SERIAL_COMMANDS
      );


  i_INTER_FPGA_COMMUNICATION_FPGA_1_3 : entity work.SERIAL_COMMUNICATION_fpga_1
    port map (
      RX_i => FPGA_TX3,

      TX_DATA_i => s_tx_data_FPGA3,
      SEND_i    => s_send_FPGA3,

      CLK_60MHz_i   => CLK_60MHz_i,
      CLK_EN_1MHz_i => CLK_EN_1MHz_i,
      RST_i         => RST_i,

      TX_o => FPGA_RX3,

      SENT_o    => s_sent_FPGA3,
      FAIL_o    => s_fail_FPGA3,
      READY_o   => s_ready_FPGA3,
      RX_DATA_o => s_rx_data_FPGA3
      );



  i_MASTER_SERIAL_COMMANDS : entity work.MASTER_SERIAL_COMMANDS
    port map(
      -------------------------------------------------------------------------
      ---------------------------- System signals -----------------------------
      -------------------------------------------------------------------------
      CLK_60MHZ_i      => CLK_60MHZ_i,
      EN_CLK_i         => CLK_EN_1MHz_i,
      RESET_i          => RST_i,
      -------------------------------------------------------------------------
      --------------------- Communication control signals ---------------------
      -------------------------------------------------------------------------                         
      uC_REQUEST_i     => uC_REQUEST_i,  -- Microntroller is requesting data from other FPGAs
      uC_FPGA_SELECT_i => uC_FPGA_SELECT_i,  -- Select FPGA 2 ('0') or FPGA 3 ('1') 

      uC_COMMAND_i => uC_COMMAND_i,     -- Microntroller incoming command
      uC_DATA_i    => uC_DATA_i,        -- Microntroller incoming data

      DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,  -- Flag that indicates uC interface has registered the data
      DATA_TO_uC_READY_o    => DATA_TO_uC_READY_o,  -- Indicates serial data is ready
      -------------------------------------------------------------------------
      --------------- Serial block signals between FPGA 1 and 2 ---------------
      -------------------------------------------------------------------------
      SERIAL_DATA_1_2_i     => s_rx_data_FPGA2,  -- Input serial data from FPGA 2
      SERIAL_DATA_1_2_o     => s_tx_data_FPGA2,  -- Output serial data to FPGA 2

      PACKET_SENT_1_2_i  => s_sent_FPGA2,  -- Indicates packet has been send to FPGA 2
      PACKET_FAIL_1_2_i  => s_fail_FPGA2,  -- Indicates packet received FPGA 2 has failed
      PACKET_READY_1_2_i => s_ready_FPGA2,  -- Indicates that packet received from FPGA 2 is ready

      SEND_PACKET_1_2_o => s_send_FPGA2,  -- to serial comm - start sending 
      -------------------------------------------------------------------------
      --------------- Serial block signals between FPGA 1 and 3 ---------------
      -------------------------------------------------------------------------
      SERIAL_DATA_1_3_i => s_rx_data_FPGA3,
      SERIAL_DATA_1_3_o => s_tx_data_FPGA3,

      PACKET_SENT_1_3_i  => s_sent_FPGA3,
      PACKET_FAIL_1_3_i  => s_fail_FPGA3,
      PACKET_READY_1_3_i => s_ready_FPGA3,

      SEND_PACKET_1_3_o => s_send_FPGA3,
      -------------------------------------------------------------------------
      --------------------------- Serial Information --------------------------
      -------------------------------------------------------------------------
      FPGA_2_VERSION_o  => FPGA_2_VERSION_o,  -- FPGA 2 version (4 MSB should be "1001" for this information to be valid)
      FPGA_3_VERSION_o  => FPGA_3_VERSION_o,  -- same
      -------------------------------------------------------------------------
      ---------------------------- uC Requested Data --------------------------
      -------------------------------------------------------------------------
      -- R2R Digital to analog converter
      R2R_i             => R2R_i,
      -------------------------------------------------------------------------
      -- Illumination pins
      FRONT_LED_A_o     => FRONT_LED_A_o,
      FRONT_LED_B_o     => FRONT_LED_B_o,
      FRONT_LED_C_o     => FRONT_LED_C_o,
      FRONT_LED_D_o     => FRONT_LED_D_o,

      REAR_LED_A_o => REAR_LED_A_o,
      REAR_LED_B_o => REAR_LED_B_o,
      REAR_LED_C_o => REAR_LED_C_o,
      REAR_LED_D_o => REAR_LED_D_o,

      V_BCKGND_o     => V_BCKGND_o,
      -------------------------------------------------------------------------
      -- Ejector board output status
      EJET_o         => EJET_o,  ---- Returns ejectors activation (if ejector board outputs are active)
      -------------------------------------------------------------------------
      -- 12 Feeders board
      TEST_FED_OUT_o => TEST_FED_OUT_o,  -- 12 Feeders board vibrators feedback 
      -------------------------------------------------------------------------
      -- Resistor board test signals
      R_COMP_o       => R_COMP_o        -- Resistor board feedback 



      );

end architecture;
