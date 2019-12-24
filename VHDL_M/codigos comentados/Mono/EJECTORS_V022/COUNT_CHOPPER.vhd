----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
--				 
-- Create Date:    17:01:58 06/12/2012 
-- Design Name: 	 Count Chopper
-- Module Name:    COUNT_CHOPPER - Behavioral 
-- Project Name:   EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 Valves ejection counter protection
--
-- Dependencies:   COUNT_MEM_CONTROL.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This module is reponsibble for identifying when a valve should
--						 	   stop ejecting due to excess of ejections
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

entity COUNT_CHOPPER is
    Port ( 
			  VALVE_STATE_i : in STD_LOGIC_VECTOR (31 downto 0);		-- 32 Valve state input
			  COUNT_i : in  STD_LOGIC_VECTOR (19 downto 0);				-- Memory output counter
           CURRENT_VALVE_i : in  STD_LOGIC_VECTOR (4 downto 0);	-- The current valve being read by the memory controller
			  MAX_FLAG_i : in  STD_LOGIC;										-- Flag that shows the counter reached maximum value (MAX_COUNT)
           C1MHZ_i : in  STD_LOGIC;											
           RST_i : in  STD_LOGIC;											
			  
			  PROTOTYPE_o : out STD_LOGIC_VECTOR(7 downto 0);
			  MAX_FLAG_o : out  STD_LOGIC;									-- Flag that shows the counter reached maximum value (MAX_COUNT)
           COUNT_o : out  STD_LOGIC_VECTOR (19 downto 0);			-- Memory input counter
			  VALVE_STATE_o : out STD_LOGIC_VECTOR (31 downto 0));	-- 32 chopper output (If one of the choppers is 1 then should cool down the valve)
end COUNT_CHOPPER;

architecture Behavioral of COUNT_CHOPPER is
signal s_count_decision : std_logic_vector (1 downto 0);
-- debug
signal s_is_valve_0, s_max_count, s_min_count, s_max_flag_o : std_logic;
signal s_valve_state_o : std_logic_vector(31 downto 0);
signal s_probe : std_logic_vector(2 downto 0);
begin

	MAX_FLAG_o <= s_max_flag_o;

	PROTOTYPE_o <= s_probe(2) & s_probe(1) & s_probe(0) & s_is_valve_0 & MAX_FLAG_i & s_max_flag_o & VALVE_STATE_i(CONV_INTEGER(CURRENT_VALVE_i)) & '0';
	
	

	s_is_valve_0 <= '1' when (CURRENT_VALVE_i = "00000") else '0';

	-- Concatenation to use on the case and identify if the ejector should be chopped or not
	s_count_decision <= MAX_FLAG_i & VALVE_STATE_i(CONV_INTEGER(CURRENT_VALVE_i));
	
	process (RST_i, C1MHZ_i)
	begin
		if falling_edge(C1MHZ_i) then
			if (RST_i = '1') then
				s_MAX_FLAG_o <= '0';
				COUNT_o <= (others => '0');
				VALVE_STATE_o <= (others => '0');
				s_probe <= "000"; -- probe
			else
			
				VALVE_STATE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '0'; -- Keep chopper in 0
				case s_count_decision is
					-- s_count_decision = MAX_FLAG_i & Current valve (VALVE_STATE_i(CURRENT_VALVE_i))
					
					when "00" => 																					-- Maximum count flag is off and valve is off
																														-- Should output 0 and nothing else
										
										s_MAX_FLAG_o <= '0'; 														-- Keep max flag in 0
										
										if (COUNT_i <= "00000000000000000100") then						-- If the counter is below the minimum
											s_probe <= "001";
											COUNT_o <= COUNT_i;													-- Just keep the count on the memory
										else																			-- If the counter did not reached minimum yet
											s_probe <= "010";
											COUNT_o <= COUNT_i - "00000000000000000100";					-- Keep decreasing the counter
										end if;
					
					when "01" => 																					-- Maximum count flag is off and valve is on
																														-- Should set valve output 1 
																														-- Test if COUNT_i reached maximum and set s_max_flag to 1 
																														-- Increase or not counter with INC_VALUE_i
										
										if (COUNT_i >= "10100000000000000000") then						-- Tests if the counter reached the determined maximum
											s_probe <= "011";
											VALVE_STATE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '1';		-- Set the chopper output to 1
											COUNT_o <= COUNT_i - "00000000000000000100";					-- Start decrementing the counter
											s_MAX_FLAG_o <= '1';													-- Set the maximum flag
										else																			-- If the counter did not reached determined maximum
											s_probe <= "100";
											COUNT_o <= COUNT_i + "00000000000000000001";					-- Keep incrementing the counter
											s_MAX_FLAG_o <= '0';													-- Keep the maximum flag in 0
										end if;
											
					when others => 																				-- Maximum count flag is on and valve is off
																														-- Should keep output in 0
										VALVE_STATE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '1';			-- Keep the chopper output to 1
										
																														-- Test if COUNT_i reached minimum and set s_max_flag to 0
																														-- Decrease or not counter with INC_VALUE_i
										if (COUNT_i <= "00000000000000000100") then						-- If the counter is below or equal the minimum 
											s_probe <= "101";
											COUNT_o <= COUNT_i;													-- Keep the counter as it is
											s_MAX_FLAG_o <= '0';													-- Set the maximum flag to 0
										else																			-- If the counter is still higher than minimum
											s_probe <= "110";
											COUNT_o <= COUNT_i - "00000000000000000100";					-- Keep cooling down and decreasing value
											s_MAX_FLAG_o <= '1';													-- Keep maximum flag in 1
										end if;
										
				end case;

			end if;
		end if;
	end process;

end Behavioral;