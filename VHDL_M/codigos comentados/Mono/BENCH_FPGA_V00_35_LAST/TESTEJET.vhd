----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: C.E.Bertagnolli
--
-- Create Date:    17:09:29 02/06/2012 
-- Design Name: 
-- Module Name:    TESTEJET - Behavioral 
-- Project Name: 
-- Target Devices: SP6 XC6SLX16
-- Tool versions: 
-- Description: Testejet generator
--
-- Dependencies: 
--
-- Revision: 
-- Revision   0.01 - File Created
-- 31.05.2012 0.02 - Test frequency changed from 15Hz to 100Hz
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

entity TESTEJET is
    Port ( 	CLK_1_i : IN std_logic;
				CLK_18_i : IN std_logic;
				RESET_i : IN std_logic;
				TEJET_CHUTE_i : IN std_logic;
				TEJET_DWELL_i : IN std_logic_vector(9 downto 0);
				TEJETBUFF_i : IN std_logic_vector (31 downto 0);
				
--				TEJET_ACTIVE_TIME_i : in std_logic;
				
				DO_TESTEJETA_o : out std_logic;
				DO_TESTEJETB_o : out std_logic;
				TJET_o : out std_logic_vector (31 downto 0)
				);
end TESTEJET;

architecture Behavioral of TESTEJET is
-- Testejet detect
signal s_istestejet : std_logic;

-- Output signal generator
signal s_tjet : std_logic_vector(31 downto 0);
signal s_pwm_release : std_logic;
signal s_tjet_state : integer range 0 to 7;
signal s_tjet_inactive : integer range 0 to 65535;
signal s_tjet_before_pwm : integer range 0 to 15;
signal s_tjet_pwm_counter : integer range 0 to 127;
signal s_tjet_active : integer range 0 to 512;
--signal s_active_time : integer range 0 to 512;

-- PWM counter
signal s_pwm_counter_end : std_logic;
signal s_pwm_state : integer range 0 to 1;
signal s_pwm_counter_max : std_logic_vector(15 downto 0);
signal s_other_counter : std_logic_vector(15 downto 0);

begin

	s_istestejet <= (TEJETBUFF_i(0) or TEJETBUFF_i(1) or TEJETBUFF_i(2) or TEJETBUFF_i(3) or TEJETBUFF_i(4) or TEJETBUFF_i(5) or TEJETBUFF_i(6) or TEJETBUFF_i(7) or
							TEJETBUFF_i(8) or TEJETBUFF_i(9) or TEJETBUFF_i(10) or TEJETBUFF_i(11) or TEJETBUFF_i(12) or TEJETBUFF_i(13) or TEJETBUFF_i(14) or TEJETBUFF_i(15) or 
							TEJETBUFF_i(16) or TEJETBUFF_i(17) or TEJETBUFF_i(18) or TEJETBUFF_i(19) or TEJETBUFF_i(20) or TEJETBUFF_i(21) or TEJETBUFF_i(22) or TEJETBUFF_i(23) or 
							TEJETBUFF_i(24) or TEJETBUFF_i(25) or TEJETBUFF_i(26) or TEJETBUFF_i(27) or TEJETBUFF_i(28) or TEJETBUFF_i(29) or TEJETBUFF_i(30) or TEJETBUFF_i(31));  
							
	DO_TESTEJETA_o <= (not(TEJET_CHUTE_i) and s_istestejet);
	DO_TESTEJETB_o <= (TEJET_CHUTE_i and s_istestejet);

	TJET_o <= s_tjet;
	
	s_pwm_counter_max <= TEJET_DWELL_i & "000000";
		
--	s_active_time <= 400 when TEJET_ACTIVE_TIME_i = '1' else 500;
		
   process (CLK_1_i,RESET_i) -- 1MHz
	begin	
		if rising_edge(CLK_1_i) then
			if (RESET_i = '1') then
				s_pwm_release <= '0';
				s_tjet_before_pwm <= 0;
				s_tjet_pwm_counter <= 0;
				s_tjet_state <= 0;
				s_tjet_inactive <= 0;
				s_tjet_active <= 0;
				s_tjet <= (others => '0');	-- 32 bit output, each bit represents one ejector
			else
				case s_tjet_state is
					when 0 =>	-- In this state the ejectors are in silence for 1ms
								s_tjet <= (others => '0');	-- 32 bit output, each bit represents one ejector
								if (s_tjet_inactive = 10000) then	-- 10 ms silence time between ejections
									s_tjet_inactive <= 0;
									s_tjet_state <= 1;
								else
									s_tjet_state <= 0;
									s_tjet_inactive <= s_tjet_inactive + 1;
								end if;
								
					when 1 =>	-- In this state the ejectors are active, before PWM state
								s_tjet <= TEJETBUFF_i;	-- 32 bit output, each bit represents one ejector
								if (s_tjet_active = 500) then	-- In this state the ejectors are active for 400 us
									s_tjet_state <= 2;
									s_pwm_release <= '1';	-- This will release the other counter to count the PWM state
									s_tjet_active <= 0;
								else
									s_tjet_state <= 1;	-- case the counter did not reached 400 us stay here and continue counting
									s_tjet_active <= s_tjet_active + 1;
									s_pwm_release <= '0';
								end if;
								
					when 2 =>	-- Wait time to delay between active and PWM
								s_pwm_release <= '0';
								s_tjet <= (others => '0');	-- 32 bit output, each bit represents one ejector
								if (s_tjet_before_pwm = 15) then	-- 15 us silence time between ejections
									s_tjet_state <= 3;
									s_tjet_before_pwm <= 0;
								else
									s_tjet_state <= 2;
									s_tjet_before_pwm <= s_tjet_before_pwm + 1;
								end if;
								
					when 3 =>	-- In this state the ejectors will be on PWM state waiting for the other counter to end
								if (s_pwm_counter_end = '1') then -- If the other counter reached maximum (tjet_dwell)
									s_tjet_state <= 0;
									s_tjet_pwm_counter <= 0;
									s_tjet <= (others => '0');
								else	-- If the other counter did not reached maximum (tjet_dwell)
									s_tjet_state <= 3;
									if (s_tjet_pwm_counter = 70) then -- Generate PWM output (7 KHz)
										s_tjet <= s_tjet xor TEJETBUFF_i; -- Invert output
										s_tjet_pwm_counter <= 0;
									else
										s_tjet_pwm_counter <= s_tjet_pwm_counter + 1;
									end if;
								end if;
					when others =>
								s_tjet_state <= 0;
				end case;
				
			end if;
		end if;
	end process;
	
	process (CLK_18_i,RESET_i) -- 18.75MHz
	begin
		if rising_edge(CLK_18_i) then
			if (RESET_i = '1') then
				s_other_counter <= "0000000000000000";
				s_pwm_counter_end <= '0';
				s_pwm_state <= 0;
			else
				case s_pwm_state is
					when 0 =>
								s_other_counter <= "0000000000000000";
								if s_pwm_release = '1' then
									s_pwm_state <= 1;
								else
									s_pwm_state <= 0;
								end if;
					when 1 =>
								s_pwm_counter_end <= '0';
								if s_other_counter = s_pwm_counter_max then
									s_pwm_state <= 0;
									s_pwm_counter_end <= '1';
								else
									s_pwm_state <= 1;
									s_other_counter <= s_other_counter + '1';
								end if;
					when others =>
								s_pwm_state <= 0;
				end case;
			end if;
		end if;
	end process;
		
end Behavioral;

