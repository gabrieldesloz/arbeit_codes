----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:36 04/28/2014 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- 			Revision 0.04 - Added serial 1MHz transceiver
-- 			Revision 0.05 - Added serial communication block between FPGA 1-2 and FPGA 1-3 controlled by Luminary requests
-- 			Revision 0.06 - Added serial communication controller (Serial commands "MASTER_SERIAL_COMMANDS")
-- 			Revision 0.07 - Added EJ_SERIAL_MASTER that controls serial communication between test rig and ejector board
--								  - Added uC-FPGA new commands for inter-FPGA serial data request
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TOP is
    Port ( 		 
				--------------------------------------------------------------------------------
				-------------------------------- System Signals --------------------------------
				--------------------------------------------------------------------------------
				-- Reset circuit input
				FPGA_RESET : IN STD_LOGIC; -- n�o utilizado???
				
				-- Free IO's output (open for general use)
				EX_IO_FPGA1 : inout STD_LOGIC_VECTOR(7 downto 0);
				
				-- Clock input
				GCLK1 : in STD_LOGIC;	-- in 37,5 MHz											-- 37 Clock input
				
				-- FPGA 2 and 3 serial interface
				FPGA_RX2 : out STD_LOGIC;
				FPGA_TX2 : in STD_LOGIC;
				FPGA_RX3 : out STD_LOGIC;
				FPGA_TX3 : in STD_LOGIC;
				--------------------------------------------------------------------------------
				------------------ FPGA - uC Communication Interface (Test rig) ----------------
				--------------------------------------------------------------------------------
				-- Microcontroller - FPGA parallel communication interface
				UC_FPGA_DATA : inout STD_LOGIC_VECTOR (15 downto 0); 	-- LDATA
				UC_FPGA_ADDR : in STD_LOGIC;									-- LADDR(0)
				UC_FPGA_CLK : in std_logic;									-- LCLKL
				UC_FPGA_WR : in std_logic;										-- LWR
				UC_FPGA_RD : in std_logic;										-- LRD
				
				UC_FPGA_IO1 : IN STD_LOGIC;									-- FPGA_RSTCOM
				UC_FPGA_IO2 : OUT STD_LOGIC;									-- FPGA_BUSYCOM
				--------------------------------------------------------------------------------
				------------------------ Illumination Board (Not used?) ------------------------
				--------------------------------------------------------------------------------
				-- LED Control 
				LED_A : out STD_LOGIC; -- <= s_enable_LED_outputs <= uc_interface
				LED_B : out STD_LOGIC;
				LED_C : out STD_LOGIC;
				LED_D : out STD_LOGIC;
				--------------------------------------------------------------------------------
				-------------------------- Sorting Board Test Signals --------------------------
				--------------------------------------------------------------------------------
				-- Ejector Serial Communication Interface
				-- cc7				
				EACK : in STD_LOGIC; -- => uc_interface
				EATXD : in STD_LOGIC; -- => uc_interface
				EARXD : out STD_LOGIC; -- <= s_enable_ejectors <= uc_interface
				-- cc10
				
				EBCK : in STD_LOGIC; -- mux
				EBTXD : in STD_LOGIC; -- mux
				EBRXD : out STD_LOGIC; -- mux
				
				
				-- CCD 1-4 Control Signals
				CCD_DIS1 : in STD_LOGIC; -- => uc_interface
				CCD_CLK1 : in STD_LOGIC; -- => uc_interface
				CCD_SI1 : in STD_LOGIC; -- => uc_interface
				
				CCD_DIS2 : in STD_LOGIC; -- ...
				CCD_CLK2 : in STD_LOGIC;
				CCD_SI2 : in STD_LOGIC;
				
				CCD_DIS3 : in STD_LOGIC;
				CCD_CLK3 : in STD_LOGIC;
				CCD_SI3 : in STD_LOGIC;
				
				CCD_DIS4 : in STD_LOGIC;
				CCD_CLK4 : in STD_LOGIC;
				CCD_SI4 : in STD_LOGIC;
				
				-- Interboard communication
				TSYNC1 : in STD_LOGIC;  -- => uc_interface
				RSYNC1 : out STD_LOGIC; -- <= uc_interface
				
				TSYNC2 : in STD_LOGIC; --...
				RSYNC2 : out STD_LOGIC;
				--------------------------------------------------------------------------------
				---------------------------- IO Board Test Signals -----------------------------
				--------------------------------------------------------------------------------
				ALARME_TEST : in STD_LOGIC; -- => uc_interface
				LIMP1_TEST : in STD_LOGIC; -- ...
				LIMP2_TEST : in STD_LOGIC;
				AQUEC_TEST : in STD_LOGIC;
				FREE_TEST_1 : in STD_LOGIC;
				FREE_TEST_2 : in STD_LOGIC;
				
				TEST_PRESS : out STD_LOGIC; -- <= s_enable_IO_test <= ucInterface
				TEST_PROD : out STD_LOGIC_VECTOR (5 downto 0); -- ... <= s_enable_IO_test <= uc_interface
				TEST_FREE_ISO1 : out STD_LOGIC;
				TEST_FREE_ISO2 : out STD_LOGIC
           );
end TOP;

architecture Behavioral of TOP is
--------------------------------------------------------------------------------
----------------------------- uC Parallel Interface ----------------------------
--------------------------------------------------------------------------------
component UC_INTERFACE
	Port (		LDATA : inout STD_LOGIC_VECTOR (15 downto 0);			-- 16 Bit interface
				LADDR : in STD_LOGIC;											-- Determines if the uC is reading or writing
				LCLKL : in std_logic;											-- Sinchrony clock signal
				LFRAME : in std_logic;
				LWR : in std_logic;
				LRD : in std_logic;
				FPGA_RSTCOM : in std_logic;

				RST_i : in STD_LOGIC;
				CLK_10MHz_i : in STD_LOGIC;
				CLK_60MHz_i : in STD_LOGIC;
				
				FPGA_BUSYCOM : out std_logic;
--------------------------------------------------------------------------------
-- FPGA 1 test signals
				EACK_i : in STD_LOGIC;
				EATXD_i : in STD_LOGIC;
				EBCK_i : in STD_LOGIC;
				EBTXD_i : in STD_LOGIC;
				
				ENABLE_EJECTORS_o: out STD_LOGIC;
--------------------------------------------------------------------------------
				CCD_DIS1_i : in STD_LOGIC;
				CCD_CLK1_i : in STD_LOGIC;
				CCD_SI1_i  : in STD_LOGIC;

				CCD_DIS2_i  : in STD_LOGIC;
				CCD_CLK2_i  : in STD_LOGIC;
				CCD_SI2_i  : in STD_LOGIC;

				CCD_DIS3_i  : in STD_LOGIC;
				CCD_CLK3_i  : in STD_LOGIC;
				CCD_SI3_i : in STD_LOGIC;

				CCD_DIS4_i  : in STD_LOGIC;
				CCD_CLK4_i : in STD_LOGIC;
				CCD_SI4_i : in STD_LOGIC;
--------------------------------------------------------------------------------
				TSYNC1_i : in STD_LOGIC;
				TSYNC2_i : in STD_LOGIC;
				
				RSYNC_o: out STD_LOGIC;
--------------------------------------------------------------------------------
				ALARME_TEST_i : in STD_LOGIC;
				LIMP1_TEST_i : in STD_LOGIC;
				LIMP2_TEST_i : in STD_LOGIC;
				AQUEC_TEST_i : in STD_LOGIC;
				FREE_TEST_1_i : in STD_LOGIC;
				FREE_TEST_2_i : in STD_LOGIC;				
				
				IO_TEST_o: out STD_LOGIC;
--------------------------------------------------------------------------------
				LED_OUTPUTS_o : out STD_LOGIC;
-------------------------------------------------------------------------
------------ Serial controller and FPGA 2 and 3 test signals ------------
-------------------------------------------------------------------------
-- Serial controller signals
				uC_REQUEST_o : out STD_LOGIC;
				uC_FPGA_SELECT_o : out STD_LOGIC;
				
				uC_COMMAND_o : out STD_LOGIC_VECTOR(7 downto 0);
				uC_DATA_o : out STD_LOGIC_VECTOR(31 downto 0);
				
				DATA_TO_uC_RECEIVED_o : out STD_LOGIC;
				DATA_TO_uC_READY_i : in STD_LOGIC;
-------------------------------------------------------------------------
-- FPGA 2 and 3 versions
				FPGA_2_VERSION_i : in STD_LOGIC_VECTOR(7 downto 0);
				FPGA_3_VERSION_i : in STD_LOGIC_VECTOR(7 downto 0);
-------------------------------------------------------------------------
-- R2R Digital to analog converter
				R2R_o : out STD_LOGIC_VECTOR(7 downto 0);
-------------------------------------------------------------------------
-- Illumination pins
				FRONT_LED_A_i : in STD_LOGIC;
				FRONT_LED_B_i : in STD_LOGIC;
				FRONT_LED_C_i : in STD_LOGIC;
				FRONT_LED_D_i : in STD_LOGIC;
					
				REAR_LED_A_i : in STD_LOGIC;
				REAR_LED_B_i : in STD_LOGIC;
				REAR_LED_C_i : in STD_LOGIC;
				REAR_LED_D_i : in STD_LOGIC;
				
				V_BCKGND_i : in STD_LOGIC;
-------------------------------------------------------------------------
-- Ejector board output status
				EJET_i : out STD_LOGIC_VECTOR(31 downto 0);				-- Returns ejectors activation (if ejector board outputs are active)
-------------------------------------------------------------------------
-- 12 Feeders board
				TEST_FED_OUT_i : in STD_LOGIC_VECTOR(11 downto 0);
-------------------------------------------------------------------------
-- Resistor board test signals
				R_COMP_i : in STD_LOGIC_VECTOR(31 downto 0)
				
				);
end component;
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
component GENERATED_RESET 
    Port ( CLK_37MHz_i : in  STD_LOGIC;
           RESET_o : out  STD_LOGIC);
end component;
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
component DCM_CLOCK
	Port ( 		CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_60MHz_o : out STD_LOGIC;
				EN_30MHz_o : out STD_LOGIC;
				EN_10MHz_o : out STD_LOGIC;
				EN_1MHz_o : out STD_LOGIC
			);
end component;

--------------------------------------------------------------------------------
------------------------- Multiplexing -----------------------------------------
--------------------------------------------------------------------------------

 component mux is
     port (
       CLK_60MHZ_i	 : in  std_logic;
       reset		 : in  std_logic;
       EARX_o		 : out std_logic;
       EBRX_o		 : out std_logic;
       EJ_DATA_RX_o	 : out std_logic;
       EATXD_to_uC_o	 : out std_logic;
       EACK_to_uC_o	 : out std_logic;
       EBCK_to_uC_o	 : out std_logic;
       EBTXD_to_uC_o	 : out std_logic;
       SCK_SERIAL_i	 : in  std_logic;
       EJ_DATA_TX_i	 : in  std_logic;
       ENABLE_EJECTORS_i : in  std_logic;
       EATX_i		 : in  std_logic;
       EACK_i		 : in  std_logic;
       EBCK_i		 : in  std_logic;
       EBTX_i		 : in  std_logic;
       mux_i		 : in  std_logic;
       EOP_i		 : in  std_logic;
       SOP_i		 : in  std_logic;
       debug_o		 : out std_logic);
   end component mux;

--------------------------------------------------------------------------------
------------------------- Serial communication block ---------------------------
--------------------------------------------------------------------------------
component SERIAL_COMMUNICATION -- comunicacao entre os FPGAs
    Port ( RX_i : in  STD_LOGIC;										-- Received data bit
           TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);				-- Byte to be sent
           SEND_i : in  STD_LOGIC;										-- Flag to send byte (rising edge activated)
           CLK_60MHz_i : in  STD_LOGIC;									-- 60 MHz input system clock	
		   CLK_EN_1MHz_i : in STD_LOGIC;								-- 1 MHz enable signal
           RST_i : in  STD_LOGIC;										-- Reset signal
			  
           TX_o : out  STD_LOGIC;										-- Serial data out
           SENT_o : out  STD_LOGIC;										-- Flag that indicates the byte was sent
           FAIL_o : out  STD_LOGIC;										-- Indicates either parity is not correct or the end bit did not come
           READY_o : out  STD_LOGIC;									-- Indicates that a valid byte has been received
           RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));		-- Received serial byte
end component;

--------------------------------------------------------------------------------
---------------------- Master serial commands controller -----------------------
--------------------------------------------------------------------------------
component MASTER_SERIAL_COMMANDS -- controle da comunica��o ' entre os fpgas
    Port ( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i : in  STD_LOGIC;								-- Input 60MHz system clock
				EN_CLK_i : in  STD_LOGIC;									-- Input 1MHz enable signal
				RESET_i : in  STD_LOGIC;									-- Input reset signal
				-------------------------------------------------------------------------
				--------------------- Communication control signals ---------------------
				-------------------------------------------------------------------------				
				uC_REQUEST_i : in STD_LOGIC;								-- Microntroller is requesting data from other FPGAs
				uC_FPGA_SELECT_i : in STD_LOGIC;							-- Select FPGA 2 ('0') or FPGA 3 ('1')
				
				uC_COMMAND_i : in STD_LOGIC_VECTOR(7 downto 0);		-- Microntroller incoming command
				uC_DATA_i : in STD_LOGIC_VECTOR(31 downto 0);		-- Microntroller incoming data
				
				DATA_TO_uC_RECEIVED_i : in STD_LOGIC;					-- Flag that indicates uC interface has registered the data
				DATA_TO_uC_READY_o : out STD_LOGIC;						-- Indicates serial data is ready
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 2 ---------------
				s-------------------------------------------------------------------------
				SERIAL_DATA_1_2_i : in  STD_LOGIC_VECTOR (7 downto 0);	-- Input serial data from FPGA 2
				SERIAL_DATA_1_2_o : out  STD_LOGIC_VECTOR (7 downto 0);	-- Output serial data to FPGA 2

				PACKET_SENT_1_2_i : in  STD_LOGIC;								-- Indicates packet has been send to FPGA 2
				PACKET_FAIL_1_2_i : in  STD_LOGIC;								-- Indicates packet received FPGA 2 has failed
				PACKET_READY_1_2_i : in  STD_LOGIC;								-- Indicates that packet received from FPGA 2 is ready

				SEND_PACKET_1_2_o : out  STD_LOGIC;								-- Flag that iniciates serial data sending to FPGA 2
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 3 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_3_i : in  STD_LOGIC_VECTOR (7 downto 0); 	-- Input serial data from FPGA 3
				SERIAL_DATA_1_3_o : out  STD_LOGIC_VECTOR (7 downto 0);  -- Output serial data to FPGA 3
                                                                     
				PACKET_SENT_1_3_i : in  STD_LOGIC;                       -- Indicates packet has been send to FPGA 3
				PACKET_FAIL_1_3_i : in  STD_LOGIC;                       -- Indicates packet received from FPGA 3 has failed
				PACKET_READY_1_3_i : in  STD_LOGIC;                      -- Indicates that packet received from FPGA 3 is ready
                                                                     
				SEND_PACKET_1_3_o : out  STD_LOGIC;                      -- Flag that iniciates serial data sending to FPGA 3
				-------------------------------------------------------------------------
				--------------------------- Serial Information --------------------------
				-------------------------------------------------------------------------
				FPGA_2_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);		-- FPGA 2 version (4 MSB should be "1001" for this information to be valid)
				FPGA_3_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);		-- FPGA 3 version (4 MSB should be "1001" for this information to be valid)
				-------------------------------------------------------------------------
				---------------------------- uC Requested Data --------------------------
				-------------------------------------------------------------------------
				-- R2R Digital to analog converter
				R2R_i : in STD_LOGIC_VECTOR(7 downto 0);
				-------------------------------------------------------------------------
				-- Illumination pins
				FRONT_LED_A_o : out STD_LOGIC;
				FRONT_LED_B_o : out STD_LOGIC;
				FRONT_LED_C_o : out STD_LOGIC;
				FRONT_LED_D_o : out STD_LOGIC;
				
				REAR_LED_A_o : out STD_LOGIC;
				REAR_LED_B_o : out STD_LOGIC;
				REAR_LED_C_o : out STD_LOGIC;
				REAR_LED_D_o : out STD_LOGIC;
				
				V_BCKGND_o : out STD_LOGIC;	
				-------------------------------------------------------------------------
				-- Ejector board output status
				EJET_o : out STD_LOGIC_VECTOR(31 downto 0);				-- Returns ejectors activation (if ejector board outputs are active)
				-------------------------------------------------------------------------
				-- 12 Feeders board
				TEST_FED_OUT_o : out STD_LOGIC_VECTOR(11 downto 0);	-- 12 Feeders board vibrators feedback 
				-------------------------------------------------------------------------
				-- Resistor board test signals
				R_COMP_o : out STD_LOGIC_VECTOR(31 downto 0) -- Resistor board feedback 
				
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------				
			  
			);
end component;
--------------------------------------------------------------------------------
---------------------- Ejector board serial controller -------------------------
--------------------------------------------------------------------------------

component EJ_SERIAL_MASTER is
  port (
    DATA_RX_i	    : IN  STD_LOGIC;
    SEND_DATA_i	    : IN  input_array;
    CLK_i	    : IN  STD_LOGIC;
    RST_i	    : IN  STD_LOGIC;
    RECEIVED_DATA_o : OUT input_array;
    DATA_TX_o	    : OUT STD_LOGIC;
    SYNC_CLK_o	    : OUT STD_LOGIC;
    SOP_o	    : out std_logic;
    EOP_o	    : out std_logic);
end component EJ_SERIAL_MASTER;

--------------------------------------------------------------------------------
------------------------------- Internal signals -------------------------------
--------------------------------------------------------------------------------
signal s_reset : std_logic;
-- Clock signals
signal s_clk_60MHz : std_logic;
signal s_en_30MHz, s_en_10MHz, s_en_1MHz : std_logic;
-- Output control signals
signal s_enable_LED_outputs, s_enable_IO_test, s_enable_rsync, s_enable_ejectors : std_logic;
-- Serial communication signals
signal s_FPGA_TX2, s_FPGA_TX3 : std_logic;
signal s_send_FPGA2, s_send_FPGA3 : std_logic; 
signal s_ready_FPGA2, s_ready_FPGA3 : std_logic;
signal s_tx_data_FPGA2, s_tx_data_FPGA3 : std_logic_vector(7 downto 0);
signal s_rx_data_FPGA2, s_rx_data_FPGA3 : std_logic_vector(7 downto 0);
--------------------------------------------------------------------------------
-- FPGA serial commands controller
signal s_uc_request, s_fpga_select : std_logic;
signal s_data_to_uc_received, s_data_to_uc_ready : std_logic;
signal s_uc_command : std_logic_vector(7 downto 0);
signal s_uc_data : std_logic_vector(31 downto 0);
-- Serial exchanged data
signal s_v_bckgnd : std_logic;
signal s_front_led_A, s_front_led_B, s_front_led_C, s_front_led_D : std_logic;
signal s_rear_led_A, s_rear_led_B, s_rear_led_C, s_rear_led_D : std_logic;
signal s_FPGA_2_VERSION, s_FPGA_3_VERSION : std_logic_vector(7 downto 0);
signal s_r2r : std_logic_vector(7 downto 0);
signal s_test_fed_out : std_logic_vector(11 downto 0);
signal s_ejet, s_r_comp : std_logic_vector(31 downto 0);
signal s_ejet_serial_tst : std_logic_vector(31 downto 0);

signal s_EATXD_to_uC, s_EBTXD_to_uC, s_EACK_to_uC, s_EBCK_to_uC: std_logic;
signal s_sck_serial: std_logic;
signal mux_start: std_logic;
signal SOP_master, EOP_master: std_logic.
signal EJET_info_serial,RECEIVED_DATA_serial: std_logic_vector(31 downto 0); 

begin	
--------------------------------------------------------------------------------
------------------------- DCM to generate clock enables ------------------------
--------------------------------------------------------------------------------
	i_DCM_CLOCK : DCM_CLOCK
		Port map ( 	
					CLK_37MHZ_i => GCLK1,
					RST_i => s_reset,
					CLK_60MHz_o => s_clk_60MHz,
					EN_30MHz_o => s_en_30MHz,
					EN_10MHz_o => s_en_10MHz,
					EN_1MHz_o => s_en_1MHz
	);
				
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
	i_GENERATED_RESET : GENERATED_RESET 
		 Port map( 
					CLK_37MHz_i => GCLK1,
					RESET_o => s_reset
	);
					
--------------------------------------------------------------------------------
------------------------------ uC-FPGA Interface -------------------------------
--------------------------------------------------------------------------------
	i_UC_INTERFACE : UC_INTERFACE
		Port map(	
					LDATA => UC_FPGA_DATA,
					LADDR => UC_FPGA_ADDR,
					LCLKL => UC_FPGA_CLK,
					LFRAME => '0',
					LWR => UC_FPGA_WR,
					LRD => UC_FPGA_RD,
					FPGA_RSTCOM => UC_FPGA_IO1,

					RST_i => s_reset,
					CLK_10MHz_i => s_en_10MHz,
					CLK_60MHz_i => s_clk_60MHz,
					
					FPGA_BUSYCOM => UC_FPGA_IO2,
--------------------------------------------------------------------------------
					EACK_i => s_EACK_to_uC,
					EATXD_i => s_EATXD_to_uC,
					EBCK_i => s_EBCK_to_uC,
					EBTXD_i => s_EBTXD_to_uC,
					
					ENABLE_EJECTORS_o => s_enable_ejectors,
--------------------------------------------------------------------------------
					CCD_DIS1_i => CCD_DIS1,
					CCD_CLK1_i => CCD_CLK1,
					CCD_SI1_i => CCD_SI1,

					CCD_DIS2_i => CCD_DIS2,
					CCD_CLK2_i => CCD_CLK2,
					CCD_SI2_i => CCD_SI2,

					CCD_DIS3_i => CCD_DIS3,
					CCD_CLK3_i => CCD_CLK3,
					CCD_SI3_i => CCD_SI3,

					CCD_DIS4_i => CCD_DIS4,
					CCD_CLK4_i => CCD_CLK4,
					CCD_SI4_i => CCD_SI4,
--------------------------------------------------------------------------------
					TSYNC1_i => TSYNC1,
					TSYNC2_i => TSYNC2,
					
					RSYNC_o => s_enable_rsync,
--------------------------------------------------------------------------------
					ALARME_TEST_i => ALARME_TEST,
					LIMP1_TEST_i => LIMP1_TEST,
					LIMP2_TEST_i => LIMP2_TEST,
					AQUEC_TEST_i => AQUEC_TEST,
					FREE_TEST_1_i => FREE_TEST_1,
					FREE_TEST_2_i => FREE_TEST_2,
					
					IO_TEST_o => s_enable_IO_test,
--------------------------------------------------------------------------------
					LED_OUTPUTS_o => s_enable_LED_outputs,
-------------------------------------------------------------------------
------------------------------ Serial commands --------------------------
-------------------------------------------------------------------------
-- Serial controller signals
					uC_REQUEST_o => s_uc_request, 
					uC_FPGA_SELECT_o => s_fpga_select, 
					
					uC_COMMAND_o => s_uc_command,
					uC_DATA_o => s_uc_data,
					
					DATA_TO_uC_RECEIVED_o => s_data_to_uc_received,
					DATA_TO_uC_READY_i => s_data_to_uc_ready,
-------------------------------------------------------------------------
-- FPGA 2 and 3 versions
					FPGA_2_VERSION_i => s_FPGA_2_VERSION,
					FPGA_3_VERSION_i => s_FPGA_3_VERSION,
-------------------------------------------------------------------------
-- R2R Digital to analog converter
					R2R_o => s_r2r,
-------------------------------------------------------------------------
-- Illumination pins
					FRONT_LED_A_i => s_front_led_A,
					FRONT_LED_B_i => s_front_led_B,
					FRONT_LED_C_i => s_front_led_C,
					FRONT_LED_D_i => s_front_led_D,
					
					REAR_LED_A_i => s_rear_led_A,
					REAR_LED_B_i => s_rear_led_B,
					REAR_LED_C_i => s_rear_led_C,
					REAR_LED_D_i => s_rear_led_D,
					
					V_BCKGND_i => s_v_bckgnd,
-------------------------------------------------------------------------
-- Ejector board output status
					EJET_i => s_ejet, 
-------------------------------------------------------------------------
-- 12 Feeders board
					TEST_FED_OUT_i => s_test_fed_out,
-------------------------------------------------------------------------
-- Resistor board test signals
					R_COMP_i => s_r_comp,
					
-------------------------------------------------------------------------					
-- Ejector Serial Activation
					EJET_SERIAL_TST_o => s_ejet_serial_tst,
					
-- Ejector Multiplexing 
					MUX_START_O => mux_start,

-- Ejector serial input
					EJET_info_serial_i <= EJET_info_serial					

					
	);
					
	LED_A <= s_enable_LED_outputs;
	LED_B <= s_enable_LED_outputs;
	LED_C <= s_enable_LED_outputs;
	LED_D <= s_enable_LED_outputs; 

	--EARXD <= s_enable_ejectors;
	--EBRXD <= s_enable_ejectors;

	RSYNC1 <= s_enable_rsync;
	RSYNC2 <= s_enable_rsync;

	TEST_PRESS <= s_enable_IO_test;
	TEST_PROD <= "000000" when (s_enable_IO_test = '0') else "111111";
	TEST_FREE_ISO1 <= s_enable_IO_test;
	TEST_FREE_ISO2 <= s_enable_IO_test;
	
--------------------------------------------------------------------------------
---------------------- Serial communication FPGA 1 - 2 -------------------------
--------------------------------------------------------------------------------	
	i_INTER_FPGA_COMMUNICATION_FPGA_1_2 : SERIAL_COMMUNICATION
    Port map ( 		
					RX_i => FPGA_TX2, -- sinal externo vindo do FPGA 2 -- Received data bit					
					TX_DATA_i => s_tx_data_FPGA2, -- <= MASTER_SERIAL_COMMANDS -- Byte to be sent					
					SEND_i => s_send_FPGA2, -- <= MASTER_SERIAL_COMMANDS --Flag to send byte (rising edge activated)
					
					CLK_60MHz_i => s_clk_60MHz,
					CLK_EN_1MHz_i => s_en_1MHz, --???
					RST_i => s_reset,

					TX_o => FPGA_RX2, -- sinal indo para FPGA 2
					
					SENT_o => s_sent_FPGA2, -- => MASTER_SERIAL_COMMANDS -- Indicates packet has been send to FPGA 2
					FAIL_o => s_fail_FPGA2,  -- => MASTER_SERIAL_COMMANDS -- Indicates packet received FPGA 2 has failed
					READY_o => s_ready_FPGA2, -- => MASTER_SERIAL_COMMANDS -- Indicates that packet received from FPGA 2 is ready
					RX_DATA_o => s_rx_data_FPGA2 -- => MASTER_SERIAL_COMMANDS -- serial data output for  MASTER_SERIAL_COMMANDS
			  );
--------------------------------------------------------------------------------
---------------------- Serial communication FPGA 1 - 3 -------------------------
--------------------------------------------------------------------------------	
	i_INTER_FPGA_COMMUNICATION_FPGA_1_3 : SERIAL_COMMUNICATION
    Port map ( 
					RX_i => FPGA_TX3,
					
					TX_DATA_i => s_tx_data_FPGA3,
					SEND_i => s_send_FPGA3,
					
					CLK_60MHz_i => s_clk_60MHz,
					CLK_EN_1MHz_i => s_en_1MHz,
					RST_i => s_reset, 

					TX_o => FPGA_RX3,
					
					SENT_o => s_sent_FPGA3,
					FAIL_o => s_fail_FPGA3,
					READY_o => s_ready_FPGA3,
					RX_DATA_o => s_rx_data_FPGA3
			  );

--------------------------------------------------------------------------------
---------------------- Master serial commands controller -----------------------
--------------------------------------------------------------------------------
	i_MASTER_SERIAL_COMMANDS : MASTER_SERIAL_COMMANDS
		Port map( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i => s_clk_60MHz,
				EN_CLK_i => s_en_1MHz,
				RESET_i => s_reset,
				-------------------------------------------------------------------------
				--------------------- Communication control signals ---------------------
				-------------------------------------------------------------------------				
				uC_REQUEST_i => s_uc_request,  -- Microntroller is requesting data from other FPGAs
				uC_FPGA_SELECT_i => s_fpga_select, -- Select FPGA 2 ('0') or FPGA 3 ('1') 
				
				uC_COMMAND_i => s_uc_command, -- Microntroller incoming command
				uC_DATA_i => s_uc_data, -- Microntroller incoming data
				
				DATA_TO_uC_RECEIVED_i => s_data_to_uc_received, -- Flag that indicates uC interface has registered the data
				DATA_TO_uC_READY_o => s_data_to_uc_ready, -- Indicates serial data is ready
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 2 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_2_i => s_rx_data_FPGA2, -- Input serial data from FPGA 2
				SERIAL_DATA_1_2_o => s_tx_data_FPGA2, -- Output serial data to FPGA 2

				PACKET_SENT_1_2_i => s_sent_FPGA2, -- Indicates packet has been send to FPGA 2
				PACKET_FAIL_1_2_i => s_fail_FPGA2, -- Indicates packet received FPGA 2 has failed
				PACKET_READY_1_2_i => s_ready_FPGA2, -- Indicates that packet received from FPGA 2 is ready

				SEND_PACKET_1_2_o => s_send_FPGA2, -- to serial comm - start sending 
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 3 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_3_i => s_rx_data_FPGA3,
				SERIAL_DATA_1_3_o => s_tx_data_FPGA3,
                                                                     
				PACKET_SENT_1_3_i => s_sent_FPGA3,
				PACKET_FAIL_1_3_i => s_fail_FPGA3,
				PACKET_READY_1_3_i => s_ready_FPGA3,
                                                                     
				SEND_PACKET_1_3_o => s_send_FPGA3,
				-------------------------------------------------------------------------
				--------------------------- Serial Information --------------------------
				-------------------------------------------------------------------------
				FPGA_2_VERSION_o => s_FPGA_2_VERSION, -- FPGA 2 version (4 MSB should be "1001" for this information to be valid)
				FPGA_3_VERSION_o => s_FPGA_3_VERSION, -- same
				-------------------------------------------------------------------------
				---------------------------- uC Requested Data --------------------------
				-------------------------------------------------------------------------
				-- R2R Digital to analog converter
				R2R_i => s_r2r,
				-------------------------------------------------------------------------
				-- Illumination pins
				FRONT_LED_A_o => s_front_led_A,
				FRONT_LED_B_o => s_front_led_B,
				FRONT_LED_C_o => s_front_led_C,
				FRONT_LED_D_o => s_front_led_D,
				
				REAR_LED_A_o => s_rear_led_A,
				REAR_LED_B_o => s_rear_led_B,
				REAR_LED_C_o => s_rear_led_C,
				REAR_LED_D_o => s_rear_led_D,
				
				V_BCKGND_o => s_v_bckgnd,
				-------------------------------------------------------------------------
				-- Ejector board output status
				EJET_o => s_ejet, ---- Returns ejectors activation (if ejector board outputs are active)
				-------------------------------------------------------------------------
				-- 12 Feeders board
				TEST_FED_OUT_o => s_test_fed_out, -- 12 Feeders board vibrators feedback 
				-------------------------------------------------------------------------
				-- Resistor board test signals
				R_COMP_o => s_r_comp -- Resistor board feedback ???
				
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------				
			  
			);
			
--------------------------------------------------------------------------------
---------------------- Ejector board serial controller -------------------------
--------------------------------------------------------------------------------			



i_EJ_SERIAL_MASTER : EJ_SERIAL_MASTER 
	PORT MAP( 
      DATA_RX_i	      => s_ej_data_rx,  
      
      SYNC_CLK_o      => s_sck_serial,
	  
	  CLK_i	      	=> s_clk_60MHz,
      RST_i	      => s_reset,
      SEND_DATA_i     => SEND_DATA_i,
      
	  RECEIVED_DATA_o => RECEIVED_DATA_serial,
      DATA_TX_o	      => s_ej_data_tx,
	  
      SOP_o	      => SOP_master,
      EOP_o	      => EOP_master);	   

	-------- data sent to serial -------
	SEND_DATA_i(0) => (others => '0'),
	SEND_DATA_i(1) => s_ejet_serial_tst,
	SEND_DATA_i(2) => (others => '0'),
	SEND_DATA_i(3) => (others => '0'),
	SEND_DATA_i(4) => (others => '0'),
	SEND_DATA_i(5) => (others => '0'),
	SEND_DATA_i(6) => (others => '0'),
	SEND_DATA_i(7) => (others => '0'),
	
	EJET_info_serial <= RECEIVED_DATA_serial(1); -- *** testando o recebimento (loop com o que foi enviado)

	
---------------------------------------------------------

		
i_OUT_MUX : MUX --
		
	PORT MAP( 	
      CLK_60MHZ_i => clk_60MHz_bufg,      
      reset	  => reset,

	-- i/o from hardware
      EACK_i => EACK,
      EATX_i => EATXD,			-- data coming from ejector board 
      EARX_o => EARXD,			-- to ejector board (clk)

      EBCK_i  => EBCK,          -- conector
      EBTX_i => EBTXD,			-- conector
      EBRX_o  => EBRXD,			-- to ejector board

      -- inputs from gateware
      EATXD_to_uC_o		=> s_EATXD_to_uC,
      EACK_to_uC_o		=> s_EACK_to_uC,
      EBCK_to_uC_o		=> s_EBCK_to_uC,
      EBTXD_to_uC_o		=> s_EBTXD_to_uC,
      ENABLE_EJECTORS_i => s_enable_ejectors,

     -- io from Serial Master
      EJ_DATA_RX_o => s_ej_data_rx,
      SCK_SERIAL_i => s_sck_serial,
      EJ_DATA_TX_i => s_ej_data_tx,

      SOP_i => SOP_master,
      EOP_i => EOP_master,
	  
	  debug_o => open,		
	  mux_i	  => mux_start
		);
	
    

	
	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



end Behavioral;
