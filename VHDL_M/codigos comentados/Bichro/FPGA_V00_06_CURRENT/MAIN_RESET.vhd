----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:22:01 04/17/2012 
-- Design Name: 
-- Module Name:    MAIN_RESET - Behavioral 
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

entity MAIN_RESET is
    Port ( 	CH1_i : in  STD_LOGIC;			-- Button input (0 when pressed "Pull-down")
				CLKSEL_i : in STD_LOGIC;		-- Jumper that sets if this is the main board or not
				RSYNC2_i : in STD_LOGIC;		-- Sync input
				C1US_i : in  STD_LOGIC;			-- 1us clock input
				RESET_o : out  STD_LOGIC);	-- Reset output
end MAIN_RESET;

architecture Behavioral of MAIN_RESET is
signal s_comp_ch1, s_comp_sync : std_logic;
signal s_ch1_flipflop_a, s_ch1_flipflop_b, s_downsampled_ch1 : std_logic;
signal s_sync_flipflop_a, s_sync_flipflop_b, s_downsampled_sync : std_logic;
signal s_debounced_ch1, s_debounced_sync : std_logic;
signal s_main_reset, s_external_reset : std_logic;

begin

	RESET_o <= s_main_reset; --when (CLKSEL_i = '0') else s_external_reset;
	
	--s_comp_ch1 <= s_downsampled_ch1 and CH1_i;
	
	process (C1US_i,CH1_i)
	variable v_debounce_ch1_cnt: integer range 0 to 65535 := 0;
	variable v_debounce_sync_cnt: integer range 0 to 32767 := 0;
	variable v_main_reset_cnt: integer range 0 to 524287 := 0;
	begin
	
		----------------------------------------------------------------------------
		----------------------- Reset button (CH1) debounce ------------------------
		----------------------------------------------------------------------------
		if rising_edge(C1US_i) then
--			s_ch1_flipflop_a <= CH1_i;										-- Three flip-flops to down-sample the input
--			s_ch1_flipflop_b <= s_ch1_flipflop_a;
--			s_downsampled_ch1 <= s_ch1_flipflop_b;						--		  	 ____		____	  ____
																					--  	 --|	  |--|	 |--|	   |-- downsampled_ch1
																					--			| FF1|  | FF2|  | FF3|
																					--	 		|_/\_|  |_/\_|  |_/\_|
																					--  C1US_i__|_______|_______|

--			if (s_comp_ch1 = '1') then										-- Checks if the downsampled input is equals to button state
--				if (v_debounce_ch1_cnt = 50000) then					-- If the counter reached 100 ms
--					s_debounced_ch1 <= '1';									-- The input is debounced
--				else											
--					v_debounce_ch1_cnt := v_debounce_ch1_cnt + 1;	-- Trigger debounce counter
--					s_debounced_ch1 <= '0';									-- The input is not debounced yet
--				end if;
--			else																	-- If the downsampled input is not equal the button state
--				v_debounce_ch1_cnt := 0;									-- Keep counter in 0
--				s_debounced_ch1 <= '0';										-- Keep debounce input in 0
--			end if;
		
		----------------------------------------------------------------------------
		--------------------- Sync input (RSYNC2_i) debounce -----------------------
		----------------------------------------------------------------------------
														
--			if (RSYNC2_i = '0') then										-- Checks if the downsampled input is equals to button state
--				if (v_debounce_sync_cnt = 30000) then					-- If the counter reached 100 ms
--					s_external_reset <= '1';								-- The input is debounced
--				else											
--					v_debounce_sync_cnt := v_debounce_sync_cnt + 1;	-- Trigger debounce counter
--					s_external_reset <= '0';								-- The input is not debounced yet
--				end if;
--			else																	-- If the downsampled input is not equal the button state
--				v_debounce_sync_cnt := 0;									-- Keep counter in 0
--				s_external_reset <= '0';									-- Keep debounce input in 0
--			end if;

		----------------------------------------------------------------------------
		---------------------------- Main reset counter ----------------------------
		----------------------------------------------------------------------------
			if (s_debounced_ch1 = '1') then						-- If the reset button is pressed
				s_main_reset<='1';									-- Activate main reset 
				v_main_reset_cnt:=0;									-- Zero reset counter time
			else															-- If the button is not pressed
				if (v_main_reset_cnt = 500000) then			-- Tests if the reset counter time reached 500ms
					s_main_reset<='0';								-- Set reset to 0
				else														-- If reset counter did not reached 500 ms
					s_main_reset<='1';								-- Keep the reset up
					v_main_reset_cnt:=v_main_reset_cnt+1;		-- Increment reset counter time
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;