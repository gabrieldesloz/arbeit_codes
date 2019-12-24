----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:17:03 06/28/2012 
-- Design Name: 
-- Module Name:    LED_ENCODER - Behavioral 
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

entity LED_ENCODER is
    Port ( FUSE_i : in  STD_LOGIC_VECTOR(31 downto 0);
			  NO_34V_i : in  STD_LOGIC;
           MANUAL_TESTEJET_i : in  STD_LOGIC;
           SET_34_OFF_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
           LED_o : out  STD_LOGIC);
end LED_ENCODER;

architecture Behavioral of LED_ENCODER is
signal s_led : std_logic;
signal s_34V_fail, s_fuse_fail, s_manual_tejet : std_logic;
signal s_blink_case : std_logic_vector(1 downto 0);
signal s_blink_times, s_times_blinked : std_logic_vector(1 downto 0);
signal s_encoder_case : std_logic_vector(2 downto 0);
signal s_led_count : integer range 0 to 2047;

begin
	s_34V_fail <= NO_34V_i or SET_34_OFF_i;																								-- Receives or between the flag that tells that there is no
																																						-- 34V and the enable bit coming from the communication interface
	s_fuse_fail <= not(FUSE_i(0) and FUSE_i(1) and FUSE_i(2) and FUSE_i(3) and FUSE_i(4) and FUSE_i(5) 				-- If there is any valve failure
						and FUSE_i(6) and FUSE_i(7) and FUSE_i(8) and FUSE_i(9) and FUSE_i(10) 
						and FUSE_i(11) and FUSE_i(12) and FUSE_i(13) and FUSE_i(14) and FUSE_i(15) 
						and FUSE_i(16) and FUSE_i(17) and FUSE_i(18) and FUSE_i(19) and FUSE_i(20) 
						and FUSE_i(21) and FUSE_i(22) and FUSE_i(23) and FUSE_i(24) and FUSE_i(25) 
						and FUSE_i(26) and FUSE_i(27) and FUSE_i(28) and FUSE_i(29) and FUSE_i(30) and FUSE_i(31));

	s_encoder_case <= (s_34V_fail & s_fuse_fail & MANUAL_TESTEJET_i);																-- Case signal to determine which code will be generated
	
	with s_encoder_case select 																												-- Number of times the led should blink
		s_blink_times <= 	"00" when "000",
								"11" when "001",
								"10" when "010",
								"10" when "011",
								"01" when "100",
								"01" when "101",
								"01" when "110",
								"01" when "111",
								"00" when others;

	LED_o <= not(s_led);								-- Invert the output because the LED is on a pull-up output

	process(CLK_i, RST_i)
	begin
		if rising_edge(CLK_i) then
			if (RST_i = '1') then
				
				s_led <= '1';							-- LED state (1 is on)
				s_led_count <= 0;						-- Counter for each state
				s_times_blinked <= "00";			-- Times LED should blink
				s_blink_case <= "00";				-- State that the LED should be ("00" is always on)
				
			else
				
				case s_blink_case is
				
					when "00" =>															-- In this state the LED is on
									s_led <= '1';											-- Light led up
									if (s_led_count = 2000) then						-- Wait for 2 seconds
									
										s_led_count <= 0;									-- Turn the LED off
										if (s_blink_times = "00") then				-- If there is no failure
											s_blink_case <= "00";						-- Stay here with the LED on
										else													-- If there is any failure flag on
											s_blink_case <= "01";						-- Go to next state
										end if;
										
									else														-- If did not reached 2 seconds
									
										s_led_count <= s_led_count + 1;				-- Keep on counting
										
									end if;
					
					when "01" =>															-- If there is an alarm (this state the LED is always off)
									s_led <= '0';											-- Turn LED off
									if (s_led_count = 500) then						-- Wait for half second 
									
										s_led_count <= 0;									-- Reset the timer counter
										
										if s_times_blinked = s_blink_times then	-- Check if the LED blinked the error code
											s_blink_case <= "00";						-- Goes to wait time
											s_times_blinked <= "00";					-- Reset the times LED blinked
										else													-- If the LED did not blinked the error code
											s_blink_case <= "10";						-- Go to next state
										end if;

									else														-- If did not reached timer counter maximum
									
										s_led_count <= s_led_count + 1;				-- Keep on counting
										
									end if;
						
					when "10" =>															-- In this state the LED is on
					
									s_led <= '1';											-- Turn LED on
									if (s_led_count = 500) then						-- Wait for half a second
									
										s_led_count <= 0;									-- Turn LED off
										s_blink_case <= "01";							-- Go to wait state (LED off for half second)
										s_times_blinked <= s_times_blinked + '1';	-- Increase the times the counter blinked

									else														-- If did not reached half a second
									
										s_led_count <= s_led_count + 1;				-- Keep on counting
										
									end if;
					
					when others =>
										s_blink_case <= "00";
				end case;
				
			end if;
		end if;
	end process;

end Behavioral;

