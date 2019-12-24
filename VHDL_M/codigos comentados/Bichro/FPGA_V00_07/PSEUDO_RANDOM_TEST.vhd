----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:58:03 10/11/2011 
-- Design Name: 
-- Module Name:    PSEUDO_RANDOM_TEST - Behavioral 
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

entity PSEUDO_RANDOM_TEST is
	Port (	ENABLE_TST_i : IN std_logic; 	--Conf jumper that enables the test
				RST_i : IN std_logic;	
				CLK_i : IN std_logic;
				
				EJET_o : OUT std_logic_vector (31 downto 0)	--32bit Pseudo-random Output signal 
			);
end PSEUDO_RANDOM_TEST;

architecture Behavioral of PSEUDO_RANDOM_TEST is

signal s_pseudo_gen_a, s_pseudo_gen_b, s_pseudo_gen_c, s_pseudo_gen_d, s_pseudo_gen_e : std_logic_vector (15 downto 0);
signal s_pseudo_a, s_pseudo_b, s_pseudo_c, s_pseudo_d, s_pseudo_e, s_pseudo_f, s_pseudo_g : std_logic_vector (4 downto 0);
signal s_pseudo_h, s_pseudo_i, s_pseudo_j, s_pseudo_k, s_pseudo_l, s_pseudo_m, s_pseudo_n : std_logic_vector (4 downto 0);

signal s_pst : integer range 0 to 1300000;

signal s_ejet : std_logic_vector (31 downto 0);

begin

	EJET_o <= s_ejet;

------------------------------------------------------------------------------------------------------
	-- Pseudo - random Ejector generation
	p_pseudorandom : process (RST_i, CLK_i)
	begin
		
		if (RST_i = '1') then
			s_pst <= 0;
			s_pseudo_gen_a <= "0000000000000001";
			s_pseudo_gen_b <= "0000000000001101";
			s_pseudo_gen_c <= "0000000000001011";
			s_pseudo_gen_d <= "0000000000000111";
			s_pseudo_gen_e <= "0000000000001111";
			s_ejet <= (others=>'0');
			
		elsif rising_edge(CLK_i) then

			if ENABLE_TST_i = '0' then

				s_ejet <= (others=>'0');
				
				if s_pst = 300000 then
									
					s_ejet(CONV_INTEGER(s_pseudo_a)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_b)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_c)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_d)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_e)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_f)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_g)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_h)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_i)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_j)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_k)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_l)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_m)) <= '1';
					s_ejet(CONV_INTEGER(s_pseudo_n)) <= '1';
					s_pst <= 0;
					
				else
				
					s_pst <= s_pst + 1;
					-- Pseudo-aleatory generation
					s_pseudo_gen_a(15 downto 1) <= s_pseudo_gen_a(14 downto 0);
					s_pseudo_gen_a(0) <= not(s_pseudo_gen_a(15) XOR s_pseudo_gen_a(14) XOR s_pseudo_gen_a(13) XOR s_pseudo_gen_a(4)); 
					
					s_pseudo_gen_b(15 downto 1) <= s_pseudo_gen_b(14 downto 0);
					s_pseudo_gen_b(0) <= not(s_pseudo_gen_b(15) XOR s_pseudo_gen_b(14) XOR s_pseudo_gen_b(13) XOR s_pseudo_gen_b(4)); 
					
					s_pseudo_gen_c(15 downto 1) <= s_pseudo_gen_c(14 downto 0);
					s_pseudo_gen_c(0) <= not(s_pseudo_gen_c(15) XOR s_pseudo_gen_c(14) XOR s_pseudo_gen_c(13) XOR s_pseudo_gen_c(4)); 
					
					s_pseudo_gen_d(15 downto 1) <= s_pseudo_gen_d(14 downto 0);
					s_pseudo_gen_d(0) <= not(s_pseudo_gen_d(15) XOR s_pseudo_gen_d(14) XOR s_pseudo_gen_d(13) XOR s_pseudo_gen_d(4)); 
					
					s_pseudo_gen_e(15 downto 1) <= s_pseudo_gen_e(14 downto 0);
					s_pseudo_gen_e(0) <= not(s_pseudo_gen_e(15) XOR s_pseudo_gen_e(14) XOR s_pseudo_gen_e(13) XOR s_pseudo_gen_e(4)); 
				end if;
						
			else
				s_ejet <= (others=>'0');
				s_pst <= 0;
			end if;
		
		end if;
	end process;
	
	---------------------------------------------------------
	-- Randomly chosen bits to set Pseudo-random registers --
	---------------------------------------------------------
	s_pseudo_a <= s_pseudo_gen_a(3 downto 0) & s_pseudo_gen_b(2);	-- Pseudo number 1
	s_pseudo_b <= s_pseudo_gen_b(3 downto 0) & s_pseudo_gen_c(2);	-- Pseudo number 2
	s_pseudo_c <= s_pseudo_gen_c(3 downto 0) & s_pseudo_gen_d(2);	-- Pseudo number 3
	s_pseudo_d <= s_pseudo_gen_d(3 downto 0) & s_pseudo_gen_e(2);	-- Pseudo number 4
	s_pseudo_e <= s_pseudo_gen_e(3 downto 0) & s_pseudo_gen_a(2);	-- Pseudo number 5
	s_pseudo_f <= s_pseudo_gen_a(2 downto 1) & s_pseudo_gen_d(1 downto 0) & s_pseudo_gen_a(0);	-- Pseudo number 6
	s_pseudo_g <= s_pseudo_gen_b(2 downto 1) & s_pseudo_gen_e(1 downto 0) & s_pseudo_gen_b(0);	-- Pseudo number 7
	s_pseudo_h <= s_pseudo_gen_c(2 downto 1) & s_pseudo_gen_a(1 downto 0) & s_pseudo_gen_c(0);	-- Pseudo number 8
	s_pseudo_i <= s_pseudo_gen_d(2 downto 1) & s_pseudo_gen_b(1 downto 0) & s_pseudo_gen_d(0);	-- Pseudo number 9
	s_pseudo_j <= s_pseudo_gen_e(2 downto 1) & s_pseudo_gen_c(1 downto 0) & s_pseudo_gen_e(0);	-- Pseudo number 10
	s_pseudo_k <= s_pseudo_gen_a(0) & s_pseudo_gen_c(2) & s_pseudo_gen_e(2 downto 0);	-- Pseudo number 11
	s_pseudo_l <= s_pseudo_gen_b(0) & s_pseudo_gen_d(2) & s_pseudo_gen_a(2 downto 0);	-- Pseudo number 12
	s_pseudo_m <= s_pseudo_gen_c(0) & s_pseudo_gen_e(2) & s_pseudo_gen_b(2 downto 0);	-- Pseudo number 13
	s_pseudo_n <= s_pseudo_gen_d(0) & s_pseudo_gen_a(2) & s_pseudo_gen_c(2 downto 0);	-- Pseudo number 14
	
------------------------------------------------------------------------------------------------------

end Behavioral;

