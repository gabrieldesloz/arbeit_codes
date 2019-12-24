----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:43:03 07/21/2014 
-- Design Name: 
-- Module Name:    SERIAL_MASTER - Behavioral 
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
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SERIAL_MASTER is
    Port ( RX_FPGA2_i : in  STD_LOGIC;
			  RX_FPGA3_i : in  STD_LOGIC;
			  
			  uC_REQUEST_i : in STD_LOGIC;
			  uC_FPGA_SELECT_i : in STD_LOGIC;
			  uC_COMMAND_i : in STD_LOGIC_VECTOR(7 downto 0);
			  uC_DATA_i : in STD_LOGIC_VECTOR(31 downto 0);
			  DATA_TO_uC_RECEIVED_i : in STD_LOGIC;
			  
			  DATA_TO_uC_READY_o : out STD_LOGIC;
			  
			  CLK_60MHz_i : in  STD_LOGIC;
			  CLK_EN_1MHz_i : in  STD_LOGIC;
			  
			  RESET_i : in  STD_LOGIC;
			  
			  TX_FPGA2_o : out  STD_LOGIC;
			  TX_FPGA3_o : out  STD_LOGIC);
end SERIAL_MASTER;

architecture Behavioral of SERIAL_MASTER is
----------------------------------------------------------------------------------
component SERIAL_COMMUNICATION
    Port ( RX_i : in  STD_LOGIC;											-- Received data bit
           TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);		-- Byte to be sent
           SEND_i : in  STD_LOGIC;										-- Flag to send byte (rising edge activated)
           CLK_60MHz_i : in  STD_LOGIC;								-- 60 MHz input system clock	
			  CLK_EN_1MHz_i : in STD_LOGIC;								-- 1 MHz enable signal
           RST_i : in  STD_LOGIC;										-- Reset signal
			  
           TX_o : out  STD_LOGIC;										-- Serial data out
           SENT_o : out  STD_LOGIC;										-- Flag that indicates the byte was sent
           FAIL_o : out  STD_LOGIC;										-- Indicates either parity is not correct or the end bit did not come
           READY_o : out  STD_LOGIC;									-- Indicates that a valid byte has been received
           RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));		-- Received serial byte
end component;
----------------------------------------------------------------------------------
component MASTER_SERIAL_COMMANDS 
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
				-------------------------------------------------------------------------
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
				-- Communication pin
				EJEC_SDATA_Q_o : out STD_LOGIC;		
				-------------------------------------------------------------------------
				-- Ejector board output status
				EJET_o : out STD_LOGIC_VECTOR(31 downto 0);
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
----------------------------------------------------------------------------------
signal s_send_FPGA2, s_send_FPGA3 : std_logic;
signal s_sent_FPGA2, s_sent_FPGA3 : std_logic;			  
signal s_fail_FPGA2, s_fail_FPGA3 : std_logic;		
signal s_ready_FPGA2, s_ready_FPGA3 : std_logic;		
signal s_tx_data_FPGA2, s_tx_data_FPGA3 : std_logic_vector(7 downto 0);
signal s_rx_data_FPGA2, s_rx_data_FPGA3 : std_logic_vector(7 downto 0);
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
i_SERIAL_COMMUNICATION_FPGA2 : SERIAL_COMMUNICATION
    Port map( 
				RX_i => RX_FPGA2_i,
				TX_DATA_i => s_tx_data_FPGA2,
				SEND_i => s_send_FPGA2,
				CLK_60MHz_i => CLK_60MHz_i,
				CLK_EN_1MHz_i => CLK_EN_1MHz_i,
				RST_i => RESET_i,

				TX_o => TX_FPGA2_o,
				SENT_o => s_sent_FPGA2,
				FAIL_o => s_fail_FPGA2,
				READY_o => s_ready_FPGA2,
				RX_DATA_o => s_rx_data_FPGA2
			  );
----------------------------------------------------------------------------------
i_SERIAL_COMMUNICATION_FPGA3 : SERIAL_COMMUNICATION
    Port map( 
				RX_i => RX_FPGA3_i,
				TX_DATA_i => s_tx_data_FPGA3,
				SEND_i => s_send_FPGA3,
				CLK_60MHz_i => CLK_60MHz_i,
				CLK_EN_1MHz_i => CLK_EN_1MHz_i,
				RST_i => RESET_i,

				TX_o => TX_FPGA3_o,
				SENT_o => s_sent_FPGA3,
				FAIL_o => s_fail_FPGA3,
				READY_o => s_ready_FPGA3,
				RX_DATA_o => s_rx_data_FPGA3
			  );
----------------------------------------------------------------------------------
i_MASTER_SERIAL_COMMANDS : MASTER_SERIAL_COMMANDS 
    Port map( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i => CLK_60MHZ_i,
				EN_CLK_i => CLK_EN_1MHz_i,
				RESET_i => RESET_i,
				-------------------------------------------------------------------------
				--------------------- Communication control signals ---------------------
				-------------------------------------------------------------------------				
				uC_REQUEST_i => uC_REQUEST_i,
				uC_FPGA_SELECT_i => uC_FPGA_SELECT_i,
				
				uC_COMMAND_i => uC_COMMAND_i,
				uC_DATA_i => uC_DATA_i,
				
				DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,
				DATA_TO_uC_READY_o => DATA_TO_uC_READY_o,
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 2 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_2_i => s_rx_data_FPGA2,
				SERIAL_DATA_1_2_o => s_tx_data_FPGA2,

				PACKET_SENT_1_2_i => s_sent_FPGA2,
				PACKET_FAIL_1_2_i => s_fail_FPGA2,
				PACKET_READY_1_2_i => s_ready_FPGA2,

				SEND_PACKET_1_2_o => s_send_FPGA2,
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
				FPGA_2_VERSION_o => open,
				FPGA_3_VERSION_o => open,
				-------------------------------------------------------------------------
				---------------------------- uC Requested Data --------------------------
				-------------------------------------------------------------------------
				-- R2R Digital to analog converter
				R2R_i => "10110101",
				-------------------------------------------------------------------------
				-- Illumination pins
				FRONT_LED_A_o => open,
				FRONT_LED_B_o => open,
				FRONT_LED_C_o => open,
				FRONT_LED_D_o => open,
				
				REAR_LED_A_o => open,
				REAR_LED_B_o => open,
				REAR_LED_C_o => open,
				REAR_LED_D_o => open,
				
				V_BCKGND_o => open,
				-------------------------------------------------------------------------
				-- Communication pin
				EJEC_SDATA_Q_o => open,
				-------------------------------------------------------------------------
				-- Ejector board output status
				EJET_o => open,
				-------------------------------------------------------------------------
				-- 12 Feeders board
				TEST_FED_OUT_o => open,
				-------------------------------------------------------------------------
				-- Resistor board test signals
				R_COMP_o => open
			  
			);
----------------------------------------------------------------------------------
end Behavioral;

