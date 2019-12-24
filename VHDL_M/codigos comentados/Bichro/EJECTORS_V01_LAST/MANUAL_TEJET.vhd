----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:55:00 04/16/2012 
-- Design Name: 
-- Module Name:    MANUAL_TEJET - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MANUAL_TEJET is
    Port ( 
				TEST_i : in std_logic;
				CLK_1K_i : in std_logic;
				C1US_i : in std_logic;
				RESET_i : in std_logic;
				
				MANUAL_TEJET_ON_o : out std_logic;
				MANUAL_TESTEJET_o : out std_logic_vector(31 downto 0)
          );
end MANUAL_TEJET;

architecture Behavioral of MANUAL_TEJET is
signal s_on_manual_testejet, s_on_inc_manual_testejet : std_logic;
signal s_manual_testejet_valve, s_manual_testejet_valve_int, s_inc_valve : std_logic_vector(4 downto 0);

begin

	MANUAL_TEJET_ON_o <= s_on_manual_testejet;

	process (CLK_1K_i,RESET_i,TEST_i)
	variable v_cnt_manual_testejet: integer range 0 to 4091 := 0;
	variable v_valve_alternate_cnt : integer range 0 to 1023 := 0;
	begin
		if rising_edge(CLK_1K_i) then													-- 1KHz clock (1 ms)
			if (RESET_i = '1') then													-- If there is a reset
				v_cnt_manual_testejet := 0;										-- Reset manual testejet counter
				s_on_manual_testejet <= '0';										-- and flag
				s_on_inc_manual_testejet <= '0';									-- Turn incremental manual testejet flag on
				s_inc_valve <= "00000";												-- Set incremental testejet valve to 0
			else
				
				if (TEST_i='1') then													-- If manual testejet button is released (state 1)
					v_cnt_manual_testejet := 0;									-- Reset manual testejet counter
				else																		-- If manual testejet is pressed
					v_cnt_manual_testejet := v_cnt_manual_testejet + 1;	-- Increase counter
					case v_cnt_manual_testejet is									-- Tests the counter
					
						when 100  => 													-- If it reached 2 seconds
										if s_on_inc_manual_testejet = '1' then -- Test if there is an incremental testejet
										
											if s_inc_valve = "11000" then
												s_inc_valve <= "00000";
											else
												s_inc_valve <= s_inc_valve + '1';-- Increments manual valve
											end if;
										
										else												-- In case test is not on
											s_inc_valve <= "00000";					-- Set valve to 0
										end if;
						when 1000 => 													-- If it reached 1 second
										s_on_manual_testejet <= '1';				-- Turn manual testejet flag on
						when 2000 => 													-- If it reached 2 seconds
										s_on_manual_testejet <= '0';				-- Turn manual testejet flag off
										s_on_inc_manual_testejet <= '1';			-- Turn incremental manual testejet flag on
						when 3000 => 													-- If it reached 3 seconds
										s_on_manual_testejet <= '0';				-- Turn manual testejet flag off
										s_on_inc_manual_testejet <= '0';			-- Turn incremental manual testejet flag on
						when others =>
										
					end case;
				end if;
			---------------------------------------------------------------------------------------------------
			-------------------------------------- Alternate valves -------------------------------------------				
			---------------------------------------------------------------------------------------------------
				
				if s_on_manual_testejet = '1' then													-- If manual testejet flag is on
					s_manual_testejet_valve <= s_manual_testejet_valve_int;					-- Receive automatic valve increase
					if v_valve_alternate_cnt = 800 then												-- Tests if the counter reached 1023 (aprox 1 sec)
						
						if s_manual_testejet_valve_int = "11000" then							-- If valve number is 24 then 
							s_manual_testejet_valve_int <= "00000";								-- Set to 0 again (only 24 valves for bichro)
						else
							s_manual_testejet_valve_int <= s_manual_testejet_valve_int + '1';	-- Increments valve index
						end if;
						
						v_valve_alternate_cnt := 0;													-- Reset counter
					else
						v_valve_alternate_cnt := v_valve_alternate_cnt + 1;					-- Increments valve alternation count (when reacheds 1024 exchange valve to test)
					end if;	
				else							
					v_valve_alternate_cnt := 0;
					s_manual_testejet_valve_int <= "00000";
					s_manual_testejet_valve <= s_inc_valve;										-- Receives incremental valve
				end if;
			end if;
		end if;
	end process;
	
	process (C1US_i,RESET_i)
	variable v_freq_gen_cnt : integer range 0 to 8191 := 0;
	begin
		if rising_edge(C1US_i)	then																		-- 1 us clock
			if (RESET_i = '1') then																			-- If there is a reset
				MANUAL_TESTEJET_o <= "00000000000000000000000000000000";							-- Assure that all tesejet valves are off
				v_freq_gen_cnt := 0;																			-- Reset frequency generator counter
			else
				if (s_on_manual_testejet = '1') or (s_on_inc_manual_testejet = '1') then	-- If the testejet flag is on
				
				---------------------------------------------------------------------------------------------------
				------------------------------------- Frequency generator -----------------------------------------				
				---------------------------------------------------------------------------------------------------
					v_freq_gen_cnt := v_freq_gen_cnt+1;														-- Increments freq gen counter
					case v_freq_gen_cnt is																		-- Test freq gen counter
						when 2 => 	
										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1'; 	-- Alternate valve state
						when 500 => 
										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
						when 600 => 
										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1';
						when 742 => 
										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
						when 884 => 
										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1';
						when 1026 => 
										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
						when 1168 => 
										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1';
						when 1310 =>
										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
--						when 850 => 
--										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1';
--						when 880 => 
--										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
--						when 950 => 
--										MANUAL_TESTEJET_o(CONV_INTEGER(s_manual_testejet_valve))<='1';
--						when 980 => 
--										MANUAL_TESTEJET_o <= "00000000000000000000000000000000";		-- Assure that all other tesejet valves are off
						when 8191 => 
										v_freq_gen_cnt := 0;																			-- Reset freq gen counter
						when others => 
					end case;
				---------------------------------------------------------------------------------------------------			
				---------------------------------------------------------------------------------------------------
					
				else																			-- If testejet flag is off
					MANUAL_TESTEJET_o <= "00000000000000000000000000000000";	-- Assure that all testejet valves are off
					v_freq_gen_cnt := 0;													-- Reset freq gen counter
				end if;
			end if;
		end if;
	end process;

end Behavioral;

