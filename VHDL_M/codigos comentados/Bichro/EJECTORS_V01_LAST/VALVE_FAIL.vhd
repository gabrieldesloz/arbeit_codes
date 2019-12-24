----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:19:40 06/18/2012 
-- Design Name: 
-- Module Name:    VALVE_FAIL - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VALVE_FAIL is
    Port ( VALVE_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Valve state (1 is active)
           SENS_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Sens state (goes 0 with the electromotive effect just after the valve is disabled)
			  VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- Valve limiter information to clean the has activation flag in case on bit is active
			  ACTIVATION_COUNT_i : in STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter input
			  FEEDBACK_COUNT_i : in STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter input
			  CURRENT_VALVE_i : in STD_LOGIC_VECTOR(4 downto 0);			-- Current valve being analyzed
			  DEBOUNCE_i : in STD_LOGIC_VECTOR(1 downto 0);					-- Debounce input count to avoid fake alarms
			  HAS_ACTIVATION_PULSE_i : in STD_LOGIC;							-- If there was a 500us valve activation pulse
			  HAS_SENS_i : in STD_LOGIC;											-- If there was an electromotive effect
           C10MHZ_i : in  STD_LOGIC;											-- 6.25 MHz clock 
           RST_i : in  STD_LOGIC;									
			  
			  DEBOUNCE_o : out STD_LOGIC_VECTOR(1 downto 0);					-- Debounce output count to avoid fake alarms
			  PROBE_o : out STD_LOGIC_VECTOR(2 downto 0);
			  ACTIVATION_COUNT_o : out STD_LOGIC_VECTOR(12 downto 0);	-- Activation time counter output
			  FEEDBACK_COUNT_o : out STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter output
			  HAS_SENS_o : out STD_LOGIC;											-- If there was an electromotive effect
			  HAS_ACTIVATION_PULSE_o : out STD_LOGIC;							-- If there was a 500us valve activation pulse
           FUSE_o : out  STD_LOGIC_VECTOR(31 downto 0));					-- "Fuse" state
end VALVE_FAIL;

architecture Behavioral of VALVE_FAIL is
signal s_valid_valve : std_logic_vector(31 downto 0);
signal s_fail_test_state : std_logic_vector(1 downto 0);
signal s_has_sens_i, s_has_sens_o : std_logic;
-- probes 
signal is_valve_0 : std_logic;

begin
	
	is_valve_0 <= '1' when (CURRENT_VALVE_i = "11111") else '0';

	PROBE_o <= SENS_i(0) & s_has_sens_o & is_valve_0; 

	HAS_SENS_o <= not(s_has_sens_o);															-- This is made because the initialization of the memory is default to 0, so
	s_has_sens_i <= not(HAS_SENS_i);															-- the lazyness made me invert the logic so that the initialization of this HAS_SENS parameter
																										-- in the memory is not necessary ( So 0 means that there was a sens, and 1 means there was not )																							

	s_valid_valve <= VALVE_i and not(VALVE_LIMITER_i);
	
	s_fail_test_state <= s_valid_valve(CONV_INTEGER(CURRENT_VALVE_i)) & HAS_ACTIVATION_PULSE_i;

	process(C10MHZ_i, RST_i)
	begin
	
		if falling_edge(C10MHZ_i) then														-- 10 MHz Clock
		
			if (RST_i = '1') then																-- If reset signal is up

				s_has_sens_o <= '1';																-- Set the HAS_SENS output to '0'
				FUSE_o <= (others=>'1');														-- Set the fuses state to 1 (OK)
				DEBOUNCE_o <= (others=>'0');													-- Set debounce to 0
				ACTIVATION_COUNT_o <= (others=>'0');										-- Set the activation counter to 0ms
				FEEDBACK_COUNT_o <= (others=>'0');											-- Set the sens counter to 0ms
				HAS_ACTIVATION_PULSE_o <= '0';												-- Set has activation pulse flag to 0
				
			else																						-- If reset signal is 0
			
				FEEDBACK_COUNT_o <= FEEDBACK_COUNT_i;										-- Do nothing with the counters and flags by default
				ACTIVATION_COUNT_o <= ACTIVATION_COUNT_i;									
				HAS_ACTIVATION_PULSE_o <= (HAS_ACTIVATION_PULSE_i and not(VALVE_LIMITER_i(CONV_INTEGER(CURRENT_VALVE_i))));
				DEBOUNCE_o <= DEBOUNCE_i;
				s_has_sens_o <= s_has_sens_i;											

			
	-----------------------------------------------------------------------------------------------------------------------------------
				case s_fail_test_state is
				
					when "00" =>

						ACTIVATION_COUNT_o <= "0000010001101";								-- Set the activation counter to 450us again (141 x 3.2us = 450us)
						FEEDBACK_COUNT_o <= "000001001110001";								-- Set the feedback counter to 2ms again (625 x 3.2us = 2ms)
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "01" =>
					
						if (FEEDBACK_COUNT_i = "000000000000000") then						-- Only after 2ms without any ejections there will be a check
							
							if (DEBOUNCE_i = "11") then											-- If debounce count is 4
							
								FUSE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= s_has_sens_i;	-- FUSE_o receives if there was a sens in this time
								DEBOUNCE_o <= "00";													-- Debounce is reset
							
							else																			-- If debounce count is less than 4
							
								DEBOUNCE_o <= DEBOUNCE_i + '1';									-- Increase debounce count
							
							end if;
							
							HAS_ACTIVATION_PULSE_o <= '0';										-- Clear the has activation pulse flag
													
						else																				-- If the delay counter did not reached 2 ms
						
							FEEDBACK_COUNT_o <= FEEDBACK_COUNT_i - '1';						-- Keep decrementing
		
						end if;
						
						if (SENS_i(CONV_INTEGER(CURRENT_VALVE_i)) = '0') then				-- If on any moment there is a valve feedback
							s_has_sens_o <= '1';														-- Set that there was a feedback
						else																				-- If there was no feedback 
							s_has_sens_o <= s_has_sens_i;											-- Keep what was there
						end if;
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "10" =>
					
						if (ACTIVATION_COUNT_i = "0000000000000") then						-- Only after 450us of an active valve 
							
							HAS_ACTIVATION_PULSE_o <= '1';										-- Set the has activation pulse
													
						else																				-- If the delay counter did not reached 10 ms
						
							ACTIVATION_COUNT_o <= ACTIVATION_COUNT_i - '1';					-- Keep decrementing
		
						end if;
					
						if (DEBOUNCE_i = "00") then
					
							s_has_sens_o <= '0'; 														-- Clear the feedback flag
						
						else
						
							s_has_sens_o <= s_has_sens_i;
							
						end if;
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "11" =>
					
						FEEDBACK_COUNT_o <= "000001001110001";								-- Set the feedback counter to 2ms again (625 x 3.2us = 2ms)
					
					when others =>
					
				end case;
				
			end if;
		end if;
	
	end process;
	
end Behavioral;