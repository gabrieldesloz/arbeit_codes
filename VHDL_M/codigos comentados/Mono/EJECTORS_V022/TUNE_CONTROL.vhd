----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    10:44:08 09/20/2012 
-- Design Name: 	 Tune controller
-- Module Name:    TUNE_CONTROL - Behavioral 
-- Project Name: 	 EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 This module is responsible for controlling which memory address
--						 will be sent to the memory controller block
--
-- Dependencies:   TUNE_PLAYER.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
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

entity TUNE_CONTROL is
    Port ( PLAY_i : in  STD_LOGIC;														-- Start the state machine
			  STOP_i : in STD_LOGIC;														-- Returns state machine to 0 and waits for another play
           NOTE_LENGTH_MEM_i : in  STD_LOGIC_VECTOR (39 downto 0);			-- Receives note duration coming from the memory
			  CLK_i : STD_LOGIC;																-- 1 MHz clock (1us period)
			  RESET_i : STD_LOGIC;															-- Reset input
			  
           ADDR_o : out  STD_LOGIC_VECTOR (8 downto 0);							-- Addresses current tone position to memory controller
           ENABLE_o : out  STD_LOGIC);													-- Enable tune player output
end TUNE_CONTROL;

architecture Behavioral of TUNE_CONTROL is
signal s_enable_o, s_tune_state : std_logic;
signal s_addr_o : std_logic_vector(8 downto 0);
signal s_length_counter : std_logic_vector(32 downto 0);

begin

	ADDR_o <= s_addr_o;																		-- Memory address controller
	
	-- And operation between all elements (if note lenght is 0 it means the tune has ended
	s_enable_o <= NOTE_LENGTH_MEM_i(0) or NOTE_LENGTH_MEM_i(1) or NOTE_LENGTH_MEM_i(2) or NOTE_LENGTH_MEM_i(3) or NOTE_LENGTH_MEM_i(4) or
					NOTE_LENGTH_MEM_i(5) or NOTE_LENGTH_MEM_i(6) or NOTE_LENGTH_MEM_i(7) or NOTE_LENGTH_MEM_i(8) or NOTE_LENGTH_MEM_i(9) or
					NOTE_LENGTH_MEM_i(10) or NOTE_LENGTH_MEM_i(11) or NOTE_LENGTH_MEM_i(12) or NOTE_LENGTH_MEM_i(13) or NOTE_LENGTH_MEM_i(14) or
					NOTE_LENGTH_MEM_i(15) or NOTE_LENGTH_MEM_i(16) or NOTE_LENGTH_MEM_i(17) or NOTE_LENGTH_MEM_i(18) or NOTE_LENGTH_MEM_i(19) or 
					NOTE_LENGTH_MEM_i(20) or NOTE_LENGTH_MEM_i(21) or NOTE_LENGTH_MEM_i(22) or NOTE_LENGTH_MEM_i(23) or NOTE_LENGTH_MEM_i(24) or
					NOTE_LENGTH_MEM_i(25) or NOTE_LENGTH_MEM_i(26) or NOTE_LENGTH_MEM_i(27) or NOTE_LENGTH_MEM_i(28) or NOTE_LENGTH_MEM_i(29) or
					NOTE_LENGTH_MEM_i(30) or NOTE_LENGTH_MEM_i(31) or NOTE_LENGTH_MEM_i(32) or NOTE_LENGTH_MEM_i(33) or NOTE_LENGTH_MEM_i(34) or
					NOTE_LENGTH_MEM_i(35) or NOTE_LENGTH_MEM_i(36) or NOTE_LENGTH_MEM_i(37) or NOTE_LENGTH_MEM_i(38) or NOTE_LENGTH_MEM_i(39);

--	ENABLE_o <= s_enable_o and PLAY_i;													-- Enable output signal
	
--	s_start <= '1' when ((PLAY_i = '1') and (s_enable_o = '1')) else '0';	-- Start flag tests if there is a start and the enable is on

	process(CLK_i, RESET_i)
	begin
		
		if rising_edge(CLK_i) then												-- On rising edge of clock signal
			if (RESET_i = '1') then												-- If there is a reset signal
			
				ENABLE_o <= '0';													-- Set Enable output to 0
				s_addr_o <= (others=>'0');										-- Set memory address to 0
				s_length_counter <= (others=>'0');							-- Set the tune time counter to 0
				s_tune_state <= '0';												-- Set tune state machine state to 0
				
			else

				case s_tune_state is
				
					when '0' =>	-- First state waits for a tune start
					
										ENABLE_o <= '0';													-- Set Enable output to 0
										s_addr_o <= (others=>'0');										-- Set memory address to 0
										s_length_counter <= (others=>'0');							-- Set the tune time counter to 0
										
										if ((s_enable_o = '1') and (PLAY_i = '1')) then			-- If there is a tune on the memory (tone time is not 0)
																												-- and there is a start flag
											s_tune_state <= '1';											-- Goes to next state
											ENABLE_o <= '1';												-- Set enable output to 1
										else
											s_tune_state <= '0';											-- Stay in this state
										end if;
										
					when '1' =>	-- Second state generates the memory addresses and detects if the tune has ended
					
										if (s_length_counter = NOTE_LENGTH_MEM_i) then			-- If the counter reached the tone time length
											s_addr_o <= s_addr_o + 1;									-- Go to next memory address (next tone)
											s_length_counter <= (others=>'0');						-- Set the tone length to 0
										else																	-- If the counter did not reach the tone time length
											s_length_counter <= s_length_counter + 1;				-- Keep counting
										end if;
										
										if (STOP_i = '1') then											-- If the stop flag is 0
											s_tune_state <= '0';											-- Waits for a new play
										else																	-- If the stop flag is 1
											if (s_enable_o = '1') then									-- Tests if the tune has not ended (Length /= 0)
												s_tune_state <= '1';										-- Stay here
											else																-- If the tune has ended (Length = 0)
												s_tune_state <= '0';										-- Goes to the next state
											end if;
										end if;
										
					when others =>
										s_tune_state <= '0';
				
				end case;	
				
			end if;	
		end if;
	
	end process;

end Behavioral;

