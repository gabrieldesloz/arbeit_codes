----------------------------------------------------------------------------------
-- Company: 			Buhler Sanmak
-- Engineer: 			Carlos Eduardo Bertagnolli
-- 
-- Create Date:    	10:57:31 06/09/2014 
-- Design Name: 		TEST_RIG_FPGA2
-- Module Name:    	TOP - Behavioral 
-- Project Name: 		TEST_RIG_FPGA2
-- Target Devices: 	Spartan 3 XC3S200-4TQ144
-- Tool versions: 	14.1
-- Description: 		Code for FPGA number 2 on the test rig for the L machine boards testing
--
-- Dependencies: 		
--
-- Revision: 
-- Revision 0.01 - File Created
--
-- Additional Comments: 
--							This FPGA is responsible for the illumination board tests
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
				FPGA_RESET : in  STD_LOGIC;
				
				-- Clock input
				GCLK2 : in  STD_LOGIC;
				
				-- Free IO's output (open for general use)
--				EX_IO_FPGA2 : out  STD_LOGIC_VECTOR (11 downto 0);
				
				-- Serial interface between FPGA 2 and 1
				FPGA2_RX2 : in  STD_LOGIC;
				FPGA2_TX2 : out  STD_LOGIC;
				--------------------------------------------------------------------------------
				-------------------------- Sorting Board Test Signals --------------------------
				--------------------------------------------------------------------------------
				-- Front LED activation signals from Sorting Board
				FRONT_LED_A : in  STD_LOGIC;
				FRONT_LED_B : in  STD_LOGIC;
				FRONT_LED_C : in  STD_LOGIC;
				FRONT_LED_D : in  STD_LOGIC;
				
				-- Rear LED activation signals from Sorting Board
				REAR_LED_A : in  STD_LOGIC;
				REAR_LED_B : in  STD_LOGIC;
				REAR_LED_C : in  STD_LOGIC;
				REAR_LED_D : in  STD_LOGIC;
				
				-- Background LED activation signal from Sorting Board
				V_BGROUND : in  STD_LOGIC;
				
				-- R2R Digital-Analog Converter to CCD Input on Sorting board
				R2R_1_BIT : out  STD_LOGIC_VECTOR (7 downto 0);	
				R2R_2_BIT : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R_3_BIT : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R_4_BIT : out  STD_LOGIC_VECTOR (7 downto 0);
				--------------------------------------------------------------------------------
				-------------------------- Ejector Board Test Signals --------------------------
				--------------------------------------------------------------------------------
				-- Ejector communication test signals from Ejector Board *** NÇAO EXISTE MAIS
				EJEC_SDATA_Q : in  STD_LOGIC;							-- EARXD
				EJEC_SCLK : out  STD_LOGIC;							-- EACK
				EJEC_SDATA_D : out  STD_LOGIC;						-- EATXD
				
				-- Ejector activation signal coming from Ejector boards
				EJET : in  STD_LOGIC_VECTOR (31 downto 0)	
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
--------------------------------------------------------------------------------
------------------------------- Internal signals -------------------------------
--------------------------------------------------------------------------------
signal s_reset, s_reset_tst : std_logic;
-- Clock signals
signal s_clk_60MHz : std_logic;
signal s_en_30MHz, s_en_10MHz, s_en_1MHz : std_logic;
-- Serial communication signals
signal s_send : std_logic;
signal s_sent, s_fail, s_ready : std_logic;
signal s_tx_data, s_rx_data : std_logic_vector(7 downto 0);
-- Serial communication controller
signal s_ejector_com_test : std_logic;
signal test_vector: std_logic_vector(7 downto 0); 

signal FRONT_LED_A_int: std_logic; --***
signal FRONT_LED_B_int: std_logic;
signal FRONT_LED_C_int: std_logic;
signal FRONT_LED_D_int: std_logic;
signal REAR_LED_A_int: std_logic;
signal REAR_LED_B_int: std_logic;
signal REAR_LED_C_int: std_logic;
signal REAR_LED_D_int: std_logic;

--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
	i_GENERATED_RESET : GENERATED_RESET 
		Port map( 
					CLK_37MHz_i => GCLK2,
					RESET_o  => s_reset_tst
					);
					
	process(GCLK2) --- ??? 
	begin
		if rising_edge(GCLK2) then
			s_reset <= s_reset_tst;
		end if;
	end process;
--------------------------------------------------------------------------------
--------------------- DCM generated clocks from 37.5MHz ------------------------
--------------------------------------------------------------------------------
	i_DCM_CLOCK : DCM_CLOCK
		Port map( 	
					CLK_37MHZ_i => GCLK2,
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
					RX_i => FPGA2_RX2,
					
					TX_DATA_i => s_tx_data,
					SEND_i => s_send,
					
					CLK_60MHz_i => s_clk_60MHz,
					CLK_EN_1MHz_i => s_en_1MHz,
					RST_i => s_reset,

					TX_o => FPGA2_TX2,
					
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
					-------------------------------------------------------------------------
					---------------------- Sorting board test signals -----------------------
					-------------------------------------------------------------------------				
					-- Front Illumination signals
					FRONT_LED_A_i => FRONT_LED_A_int, --***
					FRONT_LED_B_i => FRONT_LED_B_int,
					FRONT_LED_C_i => FRONT_LED_C_int,
					FRONT_LED_D_i => FRONT_LED_D_int,

					-- Rear Illumination signals
					REAR_LED_A_i => REAR_LED_A_int,
					REAR_LED_B_i => REAR_LED_B_int,
					REAR_LED_C_i => REAR_LED_C_int,
					REAR_LED_D_i => REAR_LED_D_int,

					-- Background Illumination signals
					V_BCKGND_i => V_BGROUND,

					-- R2R Digital-to-Analog outputs to Sorting board CCD inputs
					R2R1_o => R2R_1_BIT,
					R2R2_o => R2R_2_BIT,
					R2R3_o => R2R_3_BIT,
					R2R4_o => R2R_4_BIT,
					-------------------------------------------------------------------------
					---------------------- Sorting board test signals -----------------------
					-------------------------------------------------------------------------		
					-- Ejector board
					EJET_i => EJET,

					-- Ejector board communication test
					EJECTOR_COM_TEST_i => EJEC_SDATA_Q,
					EJECTOR_COM_TEST_o => s_ejector_com_test
					);
			  
	EJEC_SCLK <= s_ejector_com_test;
	EJEC_SDATA_D <= s_ejector_com_test;


	
	-- Front Illumination signals
					FRONT_LED_A_int <= FRONT_LED_A or test_vector(0); --***
					FRONT_LED_B_int <= FRONT_LED_B or test_vector(1);
					FRONT_LED_C_int <= FRONT_LED_C or test_vector(2);
					FRONT_LED_D_int <= FRONT_LED_D or test_vector(3);

	-- Rear Illumination signals
					REAR_LED_A_int <= REAR_LED_A or test_vector(4);
					REAR_LED_B_int <= REAR_LED_B or test_vector(5);
					REAR_LED_C_int <= REAR_LED_C or test_vector(6);
					REAR_LED_D_int <= REAR_LED_D or test_vector(7);
	
					test_vector <= x"AA"; --***
		
			
	
			
				
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end Behavioral;