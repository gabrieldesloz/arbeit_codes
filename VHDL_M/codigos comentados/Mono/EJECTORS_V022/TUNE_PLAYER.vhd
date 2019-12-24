----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    16:47:21 09/20/2012 
-- Design Name: 	 Tune Player
-- Module Name:    TUNE_PLAYER - Behavioral 
-- Project Name:   EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 This module is responsible for creating or playing a tune either recorded
--						 or live
--
-- Dependencies:   MAIN_VHDL.vhd
--						 COMMAND_MODULE
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--						For protocol and more info about the module refer to "Tune Player" specification
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity TUNE_PLAYER is
    Port ( CMD_i : in  STD_LOGIC_VECTOR (7 downto 0);						-- Current command
           DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);					-- Data comming from the deserializer module
           NEW_DATA_i : in  STD_LOGIC;											-- Has a new data
           ERROR_i : in  STD_LOGIC;												-- The deserializer received an invalid packet
           CMD_END_i : in  STD_LOGIC;											-- Indicates a command end
           CLK_i : in  STD_LOGIC;												
           RESET_i : in  STD_LOGIC;
			  
           FREQUENCY_o : out  STD_LOGIC);
end TUNE_PLAYER;

architecture Behavioral of TUNE_PLAYER is

-----------------------------------------------
------------ Command interpreter --------------
-----------------------------------------------
component INT_TUNE_PLAYER is
    Port ( CMD_i : in  STD_LOGIC_VECTOR (7 downto 0);						-- Current command
           DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);					-- Data comming from the deserializer module
           NEW_DATA_i : in  STD_LOGIC;											-- Has a new data
           ERROR_i : in  STD_LOGIC;												-- The deserializer received an invalid packet
           CMD_END_i : in  STD_LOGIC;											-- Indicates a command end
           CLK_i : in  STD_LOGIC;												
           RESET_i : in  STD_LOGIC;
			  
           PLAY_o : out  STD_LOGIC;												-- Play tune
           STOP_o : out  STD_LOGIC;												-- Stop tune
           REC_o : out  STD_LOGIC;												-- Record a new tune part
           REC_ADDR_o : out  STD_LOGIC_VECTOR (8 downto 0);				-- Increases as soon as the last tune part was recorded
           PERIOD_o : out  STD_LOGIC_VECTOR (23 downto 0);				-- The tune period (1/freq) in us steps
           NOTE_LENGTH_o : out  STD_LOGIC_VECTOR (39 downto 0);		-- The duration of the tune perior in us steps
           LIVE_o : out  STD_LOGIC);											-- Live flag (the period generates an output frequency)
end component;
-----------------------------------------------
------------ Frequency generator --------------
-----------------------------------------------
component FREQUENCY_GEN is
    Port ( PERIOD_i : in  STD_LOGIC_VECTOR (23 downto 0);					-- Period input for live performance in 1u seconds steps (Ex.: 100Hz - 10000 us steps)
			  PERIOD_MEM_i : in  STD_LOGIC_VECTOR (23 downto 0);				-- Period coming from memory, also in 1us steps
			  LIVE_i : in STD_LOGIC;													-- Live perfomance ( Gets the period from the block input instead of memory
			  ENABLE_i : STD_LOGIC;														-- Enable the output
           CLK_i : in  STD_LOGIC;													-- Clock input (1 MHz - 1 us)
           RESET_i : in  STD_LOGIC;													-- Reset signal
           FREQUENCY_o : out  STD_LOGIC);											-- PWM frequency modulated output signal (with the selected frequency)
end component;
-----------------------------------------------
-------------- Tune controller ----------------
-----------------------------------------------
component TUNE_CONTROL is
    Port ( PLAY_i : in  STD_LOGIC;													-- Start the state machine
			  STOP_i : in STD_LOGIC;													-- Returns state machine to 0 and waits for another play
           NOTE_LENGTH_MEM_i : in  STD_LOGIC_VECTOR (39 downto 0);		-- Receives note duration coming from the memory
			  CLK_i : STD_LOGIC;															-- 1 MHz clock (1us period)
			  RESET_i : STD_LOGIC;														-- Reset input
           ADDR_o : out  STD_LOGIC_VECTOR (8 downto 0);						-- Addresses current tone position to memory controller
           ENABLE_o : out  STD_LOGIC);												-- Enable tune player output
end component;
-----------------------------------------------
----------- Tune memory controller ------------
-----------------------------------------------
component TUNE_MEM_CONTROL is
    Port ( REC_i : in  STD_LOGIC_VECTOR(0 downto 0);							-- Memory write enable
           REC_ADDR_i : in  STD_LOGIC_VECTOR (8 downto 0);					-- Recording address (0 - 510)
           PERIOD_i : in  STD_LOGIC_VECTOR (23 downto 0);					-- Tone period in 1us step
           NOTE_LENGTH_i : in  STD_LOGIC_VECTOR (39 downto 0);				-- Tone duration (length)
           ADDR_i : in  STD_LOGIC_VECTOR (8 downto 0);						-- Read address to the memory
           CLK_i : in  STD_LOGIC;													-- 1MHz clock
           PERIOD_MEM_o : out  STD_LOGIC_VECTOR (23 downto 0);				-- Current tone read from the memory
           NOTE_LENGTH_MEM_o : out  STD_LOGIC_VECTOR (39 downto 0));		-- Current tone duration (length)
end component;
-----------------------------------------------

signal s_enable, s_play, s_stop, s_rec_int, s_live : std_logic;
signal s_rec : std_logic_vector(0 downto 0);
signal s_addr, s_rec_addr : std_logic_vector(8 downto 0);
signal s_period_mem, s_period : std_logic_vector(23 downto 0);
signal s_note_length_mem, s_note_length : std_logic_vector(39 downto 0);

begin

	s_rec <= "1" when (s_rec_int = '1') else "0";

	i_FREQUENCY_GEN : FREQUENCY_GEN 
    Port map ( PERIOD_i => s_period,
					PERIOD_MEM_i => s_period_mem,
					LIVE_i => s_live,
					ENABLE_i => s_enable,
					CLK_i => CLK_i,
					RESET_i => RESET_i,
					FREQUENCY_o => FREQUENCY_o
					);											

	i_TUNE_CONTROL : TUNE_CONTROL
    Port map( 	PLAY_i => s_play,
					STOP_i => s_stop,
					NOTE_LENGTH_MEM_i => s_note_length_mem,
					CLK_i => CLK_i,
					RESET_i => RESET_i,
					ADDR_o => s_addr,
					ENABLE_o => s_enable
					);
	
	i_TUNE_MEM_CONTROL : TUNE_MEM_CONTROL
    Port map( 	REC_i => s_rec,
					REC_ADDR_i => s_rec_addr,
					PERIOD_i => s_period,
					NOTE_LENGTH_i => s_note_length,
					ADDR_i => s_addr,
					CLK_i => CLK_i,
					PERIOD_MEM_o => s_period_mem,
					NOTE_LENGTH_MEM_o => s_note_length_mem
					);
	
	i_INT_TUNE_PLAYER : INT_TUNE_PLAYER
    Port map( 	CMD_i => CMD_i,
					DATA_i => DATA_i,
					NEW_DATA_i => NEW_DATA_i,
					ERROR_i => ERROR_i,
					CMD_END_i => CMD_END_i,
					CLK_i => CLK_i,
					RESET_i => RESET_i,
			  
					PLAY_o => s_play,
					STOP_o => s_stop,
					REC_o => s_rec_int,
					REC_ADDR_o => s_rec_addr,
					PERIOD_o => s_period,
					NOTE_LENGTH_o => s_note_length,
					LIVE_o => s_live
					);

end Behavioral;

