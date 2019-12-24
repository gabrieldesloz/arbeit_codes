----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:35:09 10/31/2013 
-- Design Name: 	 TOP
-- Module Name:    TOP - Behavioral 
-- Project Name: 	 L
-- Target Devices: Spartan 3 S200
-- Tool versions:  ISE 14.1
-- Description:    This is the top module wrapper for all the blocks of the L machine
--						 gig 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--						31.10.2013 	- V01 - Code creation
--								 				- Added PLL_CLOCK, GENERATED_RESET
--												- Added EJ_SERIAL_SLAVE
-- 				   15.04.2014 	- V02 - EJ_SERIAL_SLAVE
--						25.04.2014	- V03 - 	Received commands:
--													01 - Enable valve output (eval)
--													Sending commands:
--													00 - "1010101010101010" & c_version
--													01 - Activated valve feedback
--													02 - Sens feedback (has to activate EN_+50V on test rig
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package my_types_pkg is		-- Creates a type to use arrays in the entity declaration
	type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity TOP is
    Port ( 

           clk37 : in  STD_LOGIC; --37.5MHz input
	        eval : out  STD_LOGIC_VECTOR (31 downto 0); -- valve enable: one=ON
            sens_i: in std_logic_vector(31 downto 0);
			  -- Test Pins
			  PROTOTYPE_o : inout  STD_LOGIC_VECTOR(7 downto 0);	-- Pin output for verification porpouses
			  
			  -- communications interface
           RX : in  STD_LOGIC; -- Received serial bit
           TX : out  STD_LOGIC; -- Send serial bit
           CX : in  STD_LOGIC	-- Source synchronous serial clock input
			);
end TOP;

architecture Behavioral of TOP is
--********************* Used types ********************--
type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
--********************** Constants ********************--
constant c_version : std_logic_vector (15 downto 0) := X"0003"; -- 00.03
--************* Components Instantiation **************--
---------------------------------------------------------
---------------- Initial reset generation ---------------
---------------------------------------------------------
component GENERATED_RESET
    Port ( CLK_37MHz_i : in  STD_LOGIC;
           RESET_o : out  STD_LOGIC);
end component;
---------------------------------------------------------
-------------------- Clock generator --------------------
---------------------------------------------------------
component DCM_CLOCK
	Port ( 	CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_30MHz_o : out STD_LOGIC;
				EN_1MHz_o : out STD_LOGIC;
				EN_10MHz_o : out STD_LOGIC
			);
end component;
---------------------------------------------------------
---------- Ejector serial communication slave -----------
---------------------------------------------------------
component EJ_SERIAL_SLAVE
	Port (	DATA_RX_i : in STD_LOGIC;
				SEND_DATA_i : IN input_array;
				
				SYNC_CLK_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				
				RECEIVED_DATA_o : OUT input_array;
				DATA_TX_o : out STD_LOGIC
	);
end component;
---------------------------------------------------------
--**************** Signal declaration *****************--
---------------------------------------------------------
-- Input clock buffer
signal s_clk_37MHz_buf : std_logic;
---------------------------------------------------------
-- Clock generator
signal s_clk_30MHz : std_logic;
signal s_en_1MHz, s_en_10MHz : std_logic;
signal inv_en_1MHz, inv_en_10MHz : std_logic;
signal s_1MHZ_DDR_o, s_10MHZ_DDR_o : std_logic;
signal s_1MHZ_DDR_buf, s_10MHZ_DDR_buf : std_logic;
signal s_clk_30MHz_inv, s_30MHZ_DDR_o, s_30MHZ_DDR_o_buf : std_logic;
---------------------------------------------------------
-- Initial reset generation
signal s_reset : std_logic;
---------------------------------------------------------
-- Ejector serial communication slave
signal s_rx : std_logic;
signal s_send_data_0, s_send_data_1, s_send_data_2, s_send_data_3, s_send_data_4, s_send_data_5, s_send_data_6, s_send_data_7 : std_logic_vector(31 downto 0);
signal s_received_data_0, s_received_data_1, s_received_data_2, s_received_data_3, s_received_data_4, s_received_data_5, s_received_data_6, s_received_data_7 : std_logic_vector(31 downto 0);
---------------------------------------------------------
begin
---------------------------------------------------------
---------------- Initial reset generation ---------------
---------------------------------------------------------
   IBUFG_input : IBUFG -- Input clock buffer
		Port map ( 	O => s_clk_37MHz_buf,  
						I => CLK37
					); 
					
					
	i_GENERATED_RESET : GENERATED_RESET
		 Port map( 	CLK_37MHz_i => s_clk_37MHz_buf,
						RESET_o => s_reset
					);
					
---------------------------------------------------------
-------------------- Clock generator --------------------
---------------------------------------------------------
	i_CLOCK_GENERATOR : DCM_CLOCK
		Port map( 	CLK_37MHZ_i => s_clk_37MHz_buf,
						RST_i => s_reset,
						CLK_30MHz_o => s_clk_30MHz,
						EN_1MHz_o => s_en_1MHz,
						EN_10MHz_o => s_en_10MHz
					);
					
---------------------------------------------------------
---------- Ejector serial communication slave -----------
---------------------------------------------------------
   BUFG_RX : BUFG -- Input clock buffer
		Port map ( 	O => s_rx,  
						I => RX
					); 

	i_EJ_SERIAL_SLAVE : EJ_SERIAL_SLAVE
		Port map(	DATA_RX_i => s_rx,
						SEND_DATA_i(0) => s_send_data_0,
						SEND_DATA_i(1) => s_send_data_1,
						SEND_DATA_i(2) => s_send_data_2,
						SEND_DATA_i(3) => s_send_data_3,
						SEND_DATA_i(4) => s_send_data_4,
						SEND_DATA_i(5) => s_send_data_5,
						SEND_DATA_i(6) => s_send_data_6,
						SEND_DATA_i(7) => s_send_data_7,
						
						SYNC_CLK_i => CX,
						RST_i => s_reset,
						
						RECEIVED_DATA_o(0) => s_received_data_0,
						RECEIVED_DATA_o(1) => s_received_data_1,
						RECEIVED_DATA_o(2) => s_received_data_2,
						RECEIVED_DATA_o(3) => s_received_data_3,
						RECEIVED_DATA_o(4) => s_received_data_4,
						RECEIVED_DATA_o(5) => s_received_data_5,
						RECEIVED_DATA_o(6) => s_received_data_6,
						RECEIVED_DATA_o(7) => s_received_data_7,
						DATA_TX_o => TX
					);
					
	s_send_data_0 <= "1010101010101010" & c_version;
	s_send_data_1 <= s_received_data_1;					
	s_send_data_2 <= sens;			
	s_send_data_3 <= "01010101010101010101010101010101";
	s_send_data_4 <= "10101010101010101010101010101010";
	s_send_data_5 <= "01010101010101010101010101010101";
	s_send_data_6 <= "10101010101010101010101010101010";
	s_send_data_7 <= "01010101010101010101010101010101";
					
	eval <= s_received_data_1;
	sens <= sens_i;
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
PROTOTYPE_o <= (others=>'0');


end Behavioral;