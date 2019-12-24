----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    10:22:12 09/19/2012 
-- Design Name: 	 Frequency PWM generator
-- Module Name:    FREQUENCY_GEN - Behavioral 
-- Project Name: 	 EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 This module generates the PWM frequency tone based on the 
--						 PERIOD_i input
--
-- Dependencies:   TUNE_PLAYER.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FREQUENCY_GEN is
    Port ( PERIOD_i : in  STD_LOGIC_VECTOR (23 downto 0);		-- Period input for live performance in 1u seconds steps (Ex.: 100Hz - 10000 us steps)
			  PERIOD_MEM_i : in  STD_LOGIC_VECTOR (23 downto 0);	-- Period coming from memory, also in 1us steps
			  LIVE_i : in STD_LOGIC;										-- Live perfomance ( Gets the period from the block input instead of memory
			  ENABLE_i : STD_LOGIC;											-- Enable the output
           CLK_i : in  STD_LOGIC;										-- Clock input (1 MHz - 1 us)
           RESET_i : in  STD_LOGIC;										-- Reset signal
           FREQUENCY_o : out  STD_LOGIC);								-- PWM frequency modulated output signal (with the selected frequency)
end FREQUENCY_GEN;

architecture Behavioral of FREQUENCY_GEN is
signal s_frequency_o : std_logic;
signal s_pwm_counter : std_logic_vector(22 downto 0);
signal s_period_i : std_logic_vector(22 downto 0);				-- This is needed because the input can change while the counter is still counting
																				-- and this will assure that the next frequency will start on the next moment
begin

	FREQUENCY_o <= s_frequency_o when ((ENABLE_i = '1') or (LIVE_i = '1')) else '0';

	process(CLK_i, RESET_i)
	begin
		if rising_edge(CLK_i) then										-- On rising edge of 1MHz clock			
			if (RESET_i = '1') then										-- If there is a Reset signal
			
				s_frequency_o <= '0';									-- Set PWM frequency modulated output signal to 0
				s_pwm_counter <= (others=>'0');						-- Set the PWM counter to 0
				s_period_i <= (others=>'0');							-- Set the frequency counter to 0
				
			else
			
				if (s_pwm_counter = s_period_i) then				-- If the current count is equal the requested period
				
					s_pwm_counter <= (others=>'0');					-- Set the counter to 0
					s_frequency_o <= not(s_frequency_o);			-- Set the output to the inverse
					
					if (LIVE_i = '1') then								-- If LIVE input is 1
						s_period_i <= PERIOD_i(23 downto 1);		-- Gets the TOP input period
					else														-- If LIVE input is 0
						s_period_i <= PERIOD_MEM_i(23 downto 1);	-- Gets the MEMORY input period
					end if;
					
				else															-- If the current count is NOT equal the requested period
				
					s_pwm_counter <= s_pwm_counter + 1;				-- Increase counter
					
				end if;
				
			end if;
		end if;
	end process;

end Behavioral;

