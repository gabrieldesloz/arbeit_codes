----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:44:15 07/22/2014 
-- Design Name: 
-- Module Name:    SERIAL_SLAVE_FPGA2_3 - Behavioral 
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

entity SERIAL_SLAVE_FPGA2_3 is
    Port ( 	RX_FPGA2_i : in STD_LOGIC;
				RX_FPGA3_i : in STD_LOGIC;

				CLK_60MHz_i : in STD_LOGIC;
				CLK_EN_1MHz_i : in STD_LOGIC;
				RESET_i : in STD_LOGIC;

				TX_FPGA2_i : out STD_LOGIC;
				TX_FPGA3_i : out STD_LOGIC
);
end SERIAL_SLAVE_FPGA2_3;

architecture Behavioral of SERIAL_SLAVE_FPGA2_3 is
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
component SERIAL_COMMANDS_FPGA2
    Port ( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i : in STD_LOGIC;
				EN_CLK_i : in STD_LOGIC;
				
				RESET_i : in STD_LOGIC;
				-------------------------------------------------------------------------
				------------------------- Serial block signals --------------------------
				-------------------------------------------------------------------------
				-- Serial data (from serial communication block)
				SERIAL_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);
				SERIAL_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);
				
				-- Control signals from Serial communication block 
				PACKET_SENT_i : in  STD_LOGIC;
				PACKET_FAIL_i : in  STD_LOGIC;
				PACKET_READY_i : in  STD_LOGIC;
				
				SEND_PACKET_o : out  STD_LOGIC;
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------				
				-- Front Illumination signals
				FRONT_LED_A_i : in  STD_LOGIC;
				FRONT_LED_B_i : in  STD_LOGIC;
				FRONT_LED_C_i : in  STD_LOGIC;
				FRONT_LED_D_i : in  STD_LOGIC;
				
				-- Rear Illumination signals
				REAR_LED_A_i : in  STD_LOGIC;
				REAR_LED_B_i : in  STD_LOGIC;
				REAR_LED_C_i : in  STD_LOGIC;
				REAR_LED_D_i : in  STD_LOGIC;
				
				-- Background Illumination signals
				V_BCKGND_i : in  STD_LOGIC;
				
				-- R2R Digital-to-Analog outputs to Sorting board CCD inputs
				R2R1_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R2_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R3_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R4_o : out  STD_LOGIC_VECTOR (7 downto 0);
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------		
				-- Ejector board
				EJET_i : in  STD_LOGIC_VECTOR (31 downto 0);
				
				-- Ejector board communication test
				EJECTOR_COM_TEST_i : in  STD_LOGIC;
				EJECTOR_COM_TEST_o : out  STD_LOGIC
			  );
end component;
----------------------------------------------------------------------------------
component SERIAL_COMMANDS_FPGA3
    Port ( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i : in STD_LOGIC;
				EN_CLK_i : in STD_LOGIC;
				
				RESET_i : in STD_LOGIC;
				-------------------------------------------------------------------------
				------------------------- Serial block signals --------------------------
				-------------------------------------------------------------------------
				-- Serial data (from serial communication block)
				SERIAL_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);
				SERIAL_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);
				
				-- Control signals from Serial communication block 
				PACKET_SENT_i : in  STD_LOGIC;
				PACKET_FAIL_i : in  STD_LOGIC;
				PACKET_READY_i : in  STD_LOGIC;
				
				SEND_PACKET_o : out  STD_LOGIC;
				--------------------------------------------------------------------------------
				---------------------------- Feeder board output test --------------------------
				--------------------------------------------------------------------------------
				-- Vibrator driver board feeder output
				TEST_FED_OUT_i : in  STD_LOGIC_VECTOR(11 downto 0);	
				--------------------------------------------------------------------------------
				------------------------------- Resistor board test ----------------------------
				--------------------------------------------------------------------------------
				-- Resistor board test output
				R_TEST_o : out STD_LOGIC_VECTOR(31 downto 0);			
				-- Resistor board test input feedback
				R_COMP_i : in STD_LOGIC_VECTOR(31 downto 0)			
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
			  
           TX_o => TX_FPGA2_i,
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
			  
           TX_o => TX_FPGA3_i,
           SENT_o => s_sent_FPGA3,
           FAIL_o => s_fail_FPGA3,
           READY_o => s_ready_FPGA3,
           RX_DATA_o => s_rx_data_FPGA3
			  );
----------------------------------------------------------------------------------
i_SERIAL_COMMANDS_FPGA2 : SERIAL_COMMANDS_FPGA2
    Port map( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i => CLK_60MHz_i,
				EN_CLK_i => CLK_EN_1MHz_i,
				
				RESET_i => RESET_i,
				-------------------------------------------------------------------------
				------------------------- Serial block signals --------------------------
				-------------------------------------------------------------------------
				-- Serial data (from serial communication block)
				SERIAL_DATA_i => s_rx_data_FPGA2,
				SERIAL_DATA_o => s_tx_data_FPGA2,
				
				-- Control signals from Serial communication block 
				PACKET_SENT_i => s_sent_FPGA2,
				PACKET_FAIL_i => s_fail_FPGA2,
				PACKET_READY_i => s_ready_FPGA2,
				
				SEND_PACKET_o => s_send_FPGA2,
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------				
				-- Front Illumination signals
				FRONT_LED_A_i => '1',
				FRONT_LED_B_i => '1',
				FRONT_LED_C_i => '0',
				FRONT_LED_D_i => '1',
				
				-- Rear Illumination signals
				REAR_LED_A_i => '1',
				REAR_LED_B_i => '0',
				REAR_LED_C_i => '1',
				REAR_LED_D_i => '1',
				
				-- Background Illumination signals
				V_BCKGND_i => '1',
				
				-- R2R Digital-to-Analog outputs to Sorting board CCD inputs
				R2R1_o => open,
				R2R2_o => open,
				R2R3_o => open,
				R2R4_o => open,
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------		
				-- Ejector board
				EJET_i => (others=>'1'),
				
				-- Ejector board communication test
				EJECTOR_COM_TEST_i => '1',
				EJECTOR_COM_TEST_o => open
			  );
----------------------------------------------------------------------------------
i_SERIAL_COMMANDS_FPGA3 : SERIAL_COMMANDS_FPGA3
    Port map( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i => CLK_60MHZ_i,
				EN_CLK_i => CLK_EN_1MHz_i,
				
				RESET_i => RESET_i,
				-------------------------------------------------------------------------
				------------------------- Serial block signals --------------------------
				-------------------------------------------------------------------------
				-- Serial data (from serial communication block)
				SERIAL_DATA_i => s_rx_data_FPGA3,
				SERIAL_DATA_o => s_tx_data_FPGA3,
				
				-- Control signals from Serial communication block 
				PACKET_SENT_i => s_sent_FPGA3,
				PACKET_FAIL_i => s_fail_FPGA3,
				PACKET_READY_i => s_ready_FPGA3,
				
				SEND_PACKET_o => s_send_FPGA3,
				--------------------------------------------------------------------------------
				---------------------------- Feeder board output test --------------------------
				--------------------------------------------------------------------------------
				-- Vibrator driver board feeder output
				TEST_FED_OUT_i => "101010101001",
				--------------------------------------------------------------------------------
				------------------------------- Resistor board test ----------------------------
				--------------------------------------------------------------------------------
				-- Resistor board test output
				R_TEST_o => open,
				-- Resistor board test input feedback
				R_COMP_i => "10001111111011011100101110101001" --(others=>'1')
			  );
----------------------------------------------------------------------------------

end Behavioral;