----------------------------------------------------------------------------------
-- Company: 			Bühler Sanmak	 
-- Engineer: 			Carlos Eduardo Bertagnolli
-- 
-- Create Date:    	14:17:16 03/11/2013 
-- Design Name: 	 	MAIN_BOARD_DETECTION
-- Module Name:    	MAIN_BOARD_DETECTION - Behavioral 
-- Project Name: 	 	L8
-- Target Devices: 	SPARTAN 6 SLX25
-- Tool versions:  	ISE 14.1
-- Description: 		Main board detector
--
-- Dependencies: 		MAIN.vhd
--
-- Revision: 
-- Revision 0.78 		- File Created
-- Additional Comments: 
--							Test every 4 illumination cycles if there was
--							a synchronization input signal, otherwise it means
--							this is board #1 (Replaces conf(0) jumper)
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

entity MAIN_BOARD_DETECTION is
    Port ( SYNC_IN_i : in  STD_LOGIC;					-- Synchrony signal input
           ILLUM_CYCLE_i : in  STD_LOGIC;				-- Illumination cycle
           RST_i : in  STD_LOGIC;					
           MAIN_BOARD_o : out  STD_LOGIC);			-- Output flag (replaces jumper)
end MAIN_BOARD_DETECTION;

architecture Behavioral of MAIN_BOARD_DETECTION is

signal s_is_main_board, s_check_sync : std_logic;
signal s_sync_count : std_logic_vector(1 downto 0);

begin

process(ILLUM_CYCLE_i, RST_i)
begin

	if ((RST_i = '1') or (s_check_sync = '1')) then		-- If there is a reset or was a periodic check
		s_is_main_board <= '1';									-- Reset synchrony input flag
	else
		if rising_edge(SYNC_IN_i) then						--	On rising edge of synchronization signal
			s_is_main_board <= '0';								-- Set synchrony flag 
		end if;
	end if;

end process;

process(ILLUM_CYCLE_i, RST_i)
begin

	if (RST_i = '1') then										-- On a reset
	
		s_sync_count <= "00";									-- Set counter to 0
		MAIN_BOARD_o <= '1';										-- On reset all boards are main boards until next check
		
	else
		if rising_edge(ILLUM_CYCLE_i) then					-- On rising edge of illumination cycle
			
			if (s_sync_count = "11") then						-- If counter reached maximum
				MAIN_BOARD_o <= not(s_is_main_board);		-- Receives synchrony check flag
				s_check_sync <= '1';								-- Clear the synchrony check flag
				s_sync_count <= "00";							-- Set counter to 0
			else														-- If counter did not reached maximum
				s_check_sync <= '0';								-- Set clear latch to 0
				s_sync_count <= s_sync_count + '1';			-- Increase counter
			end if;
		
		end if;
	end if;

end process;

end Behavioral;

