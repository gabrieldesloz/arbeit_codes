----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:11:49 10/03/2012 
-- Design Name: 
-- Module Name:    DESERIALIZER - Behavioral 
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

entity DESERIALIZER is
    Port ( RX_i : in  STD_LOGIC;										-- RX 232 input
			  CLK_i : in STD_LOGIC;										-- 1 MHz input clock
           BAUD_CLK_i : in  STD_LOGIC;								-- 38400 Hz
           RESET_i : in  STD_LOGIC;
			  
           CMD_o : out  STD_LOGIC_VECTOR (7 downto 0);		-- Deserialized command 
           DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);		-- Deserialized data
           NEW_DATA_o : out  STD_LOGIC;							-- New available data signal
           ERROR_o : out  STD_LOGIC;								-- An unexpected or wrong data
           CMD_END_o : out  STD_LOGIC);							-- Command end flag 
end DESERIALIZER;

architecture Behavioral of DESERIALIZER is
------------------------------------------------
-------------- Serial Receiver -----------------
------------------------------------------------
component SERIAL_RX is
    Port ( RX_i : in  STD_LOGIC;												-- RX serial input
           BAUD_CLK_i : in  STD_LOGIC;										-- Baud clock rate (38400)
           RST_i : in  STD_LOGIC;											
			  
			  FAIL_o : out STD_LOGIC;											-- Flag that indicates if there was not an end signal
           PACKET_READY_o : out  STD_LOGIC;								-- Flag that indicates if the receiving state machine is ended
           RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));			-- RX received data (8 bits)
end component;
------------------------------------------------
---------- Serial data interpreter -------------
------------------------------------------------
component COMMAND_MODULE is
    Port ( DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);			-- Serial data input packet
           FAIL_i : in  STD_LOGIC;										-- Serial packet fail
           PACKET_READY_i : in  STD_LOGIC;							-- Serial packet ready
           CLK_i : in  STD_LOGIC;										-- 1 MHz input clock
           RESET_i : in  STD_LOGIC;										-- Reset signal
			  
           CMD_o : out  STD_LOGIC_VECTOR (7 downto 0);			-- Current command output
           DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);			-- Command data output
			  NEW_DATA_o : out  STD_LOGIC;								-- Flag that indicates that there is new data 
			  ERROR_o : out STD_LOGIC;										-- Did not received the right check packet and generated an error
           CMD_END_o : out  STD_LOGIC);								-- Flag that indicates that the command has ended
end component;
------------------------------------------------
signal s_fail, s_packet_ready : std_logic;
signal s_rx_data : std_logic_vector(7 downto 0);

begin

	i_SERIAL_RX : SERIAL_RX
    Port map( 	RX_i => RX_i,
					BAUD_CLK_i => BAUD_CLK_i,
					RST_i => RESET_i,
			  
					FAIL_o => s_fail,
					PACKET_READY_o => s_packet_ready,
					RX_DATA_o => s_rx_data
					);
					
	i_COMMAND_MODULE : COMMAND_MODULE
    Port map( 	DATA_i => s_rx_data,
					FAIL_i => s_fail,
					PACKET_READY_i => s_packet_ready,
					CLK_i => CLK_i,
					RESET_i => RESET_i,
			  
					CMD_o => CMD_o,
					DATA_o => DATA_o,
					NEW_DATA_o => NEW_DATA_o,
					ERROR_o => ERROR_o,
					CMD_END_o => CMD_END_o
					);

end Behavioral;

