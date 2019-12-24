----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:27 06/25/2014 
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

entity TOP is
    Port ( 
				--------------------------------------------------------------------------------
				-------------------------------- System Signals --------------------------------
				--------------------------------------------------------------------------------
				-- Reset circuit input
				FPGA_RESET : in STD_LOGIC;						
				
				-- 37MHz Clock input
				GCLK3 : in STD_LOGIC;		

				-- Free IO pins
				EX_IO_FPGA3 : out  STD_LOGIC_VECTOR(14 downto 0);					
				
				-- Serial interface between FPGA 3 and 1
				FPGA3_RX3 : in STD_LOGIC;									
				FPGA3_TX3 : out STD_LOGIC; 									
				--------------------------------------------------------------------------------
				---------------------------- Feeder board output test --------------------------
				--------------------------------------------------------------------------------
				-- Vibrator driver board feeder output
				TEST_FED_OUT : in  STD_LOGIC_VECTOR(11 downto 0);	
				--------------------------------------------------------------------------------
				------------------------------- Resistor board test ----------------------------
				--------------------------------------------------------------------------------
				-- Resistor board test output
				R_TEST : out STD_LOGIC_VECTOR(31 downto 0);			
				-- Resistor board test input feedback
				R_COMP : in STD_LOGIC_VECTOR(31 downto 0)				
			  );
end TOP;

architecture Behavioral of TOP is
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
component GENERATED_RESET 
    Port ( CLK_37MHz_i : in  STD_LOGIC;
           RESET_o : out  STD_LOGIC);
end component;
--------------------------------------------------------------------------------
--------------------- DCM generated clocks from 37.5MHz ------------------------
--------------------------------------------------------------------------------
component DCM_CLOCK
	Port ( 	CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_60MHz_o : out STD_LOGIC;
				EN_30MHz_o : out STD_LOGIC;
				EN_10MHz_o : out STD_LOGIC;
				EN_1MHz_o : out STD_LOGIC
			);
end component;
--------------------------------------------------------------------------------
------------------------- Serial communication block ---------------------------
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
----------------------- Serial communication controller ------------------------
--------------------------------------------------------------------------------
component SERIAL_COMMANDS 
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
--------------------------------------------------------------------------------
------------------------------- Internal signals -------------------------------
--------------------------------------------------------------------------------
signal s_reset : std_logic;
-- Clock signals
signal s_clk_60MHz : std_logic;
signal s_en_30MHz, s_en_10MHz, s_en_1MHz : std_logic;
-- Serial communication signals
signal s_send : std_logic;
signal s_sent, s_fail, s_ready : std_logic;
signal s_tx_data, s_rx_data : std_logic_vector(7 downto 0);

begin
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
	i_GENERATED_RESET : GENERATED_RESET 
		Port map( 
					CLK_37MHz_i => GCLK3,
					RESET_o  => s_reset
					);
					
--------------------------------------------------------------------------------
--------------------- DCM generated clocks from 37.5MHz ------------------------
--------------------------------------------------------------------------------
	i_DCM_CLOCK : DCM_CLOCK
		Port map( 	
					CLK_37MHZ_i => GCLK3,
					RST_i => s_reset,
					CLK_60MHz_o => s_clk_60MHz,
					EN_30MHz_o => s_en_30MHz,
					EN_10MHz_o => s_en_10MHz,
					EN_1MHz_o => s_en_1MHz
					);
--------------------------------------------------------------------------------
---------------------- Serial communication FPGA 2 - 1 -------------------------
--------------------------------------------------------------------------------	
	i_SERIAL_COMMUNICATION : SERIAL_COMMUNICATION
		Port map( 
					RX_i => FPGA3_RX3,
					
					TX_DATA_i => s_tx_data,
					SEND_i => s_send,
					
					CLK_60MHz_i => s_clk_60MHz,
					CLK_EN_1MHz_i => s_en_1MHz,
					RST_i => s_reset,

					TX_o => FPGA3_TX3,
					
					SENT_o => s_sent,
					FAIL_o => s_fail,
					READY_o => s_ready,
					RX_DATA_o => s_rx_data
					);
--------------------------------------------------------------------------------
----------------------- Serial communication controller ------------------------
--------------------------------------------------------------------------------
	i_SERIAL_COMMANDS : SERIAL_COMMANDS 
		 Port map( 
					-------------------------------------------------------------------------
					---------------------------- System signals -----------------------------
					-------------------------------------------------------------------------
					CLK_60MHZ_i => s_clk_60MHz,
					EN_CLK_i => s_en_1MHz,
					
					RESET_i => s_reset,
					-------------------------------------------------------------------------
					------------------------- Serial block signals --------------------------
					-------------------------------------------------------------------------
					-- Serial data (from serial communication block)
					SERIAL_DATA_i => s_rx_data,
					SERIAL_DATA_o => s_tx_data,
					
					-- Control signals from Serial communication block 
					PACKET_SENT_i => s_sent,
					PACKET_FAIL_i => s_fail,
					PACKET_READY_i => s_ready,
					
					SEND_PACKET_o => s_send,
					--------------------------------------------------------------------------------
					---------------------------- Feeder board output test --------------------------
					--------------------------------------------------------------------------------
					-- Vibrator driver board feeder output
					TEST_FED_OUT_i => TEST_FED_OUT,
					--------------------------------------------------------------------------------
					------------------------------- Resistor board test ----------------------------
					--------------------------------------------------------------------------------
					-- Resistor board test output
					R_TEST_o => R_TEST,
					-- Resistor board test input feedback
					R_COMP_i => x"FFFFFFFF" -- R_COMP
				  );
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end Behavioral;