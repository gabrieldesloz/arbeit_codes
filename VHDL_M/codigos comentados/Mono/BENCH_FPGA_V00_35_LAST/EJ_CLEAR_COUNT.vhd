----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:57:42 05/02/2011 
-- Design Name: 
-- Module Name:    EJ_CLEAR_COUNT - Behavioral 
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

-- tempo de acumulo de informaçao

entity EJ_CLEAR_COUNT is
    Port ( TEMPO_ESTATISTICA_i : in  STD_LOGIC_VECTOR (2 downto 0);
			  C3KHZ_i : in  STD_LOGIC;
			  RST_i : in  STD_LOGIC;
			  -- em alto ('1') em intervalos regidos por conforme TEMPO_ESTATISTICA_i
           CLEAR_CNT_o : out  STD_LOGIC);
end EJ_CLEAR_COUNT;

architecture Behavioral of EJ_CLEAR_COUNT is

signal s_TEMPO_CNT : std_logic_vector (16 downto 0);
signal s_CNT : std_logic_vector (16 downto 0);

begin

CLEAR_CNT_o <= '1' when s_CNT="00000000000000000" else '0';

i_CNT : process(C3KHZ_i, RST_i, TEMPO_ESTATISTICA_i, s_CNT, s_TEMPO_CNT)
begin

	case TEMPO_ESTATISTICA_i is

	when "000" => s_TEMPO_CNT <= "00000000000001110"; -- 14  x T_3KHz
	when "001" => s_TEMPO_CNT <= "00111101100011001"; -- 31513 x T_3KHz
	when "010" => s_TEMPO_CNT <= "01001100111100000"; -- 39392
	when "011" => s_TEMPO_CNT <= "01011100010100110"; -- 47270
	when "100" => s_TEMPO_CNT <= "01101011101101100"; -- 55148
	when "101" => s_TEMPO_CNT <= "01111011000110011"; -- 63027
	when "110" => s_TEMPO_CNT <= "10001010011111001"; -- 70905
	when "111" => s_TEMPO_CNT <= "00000000001111000"; -- 120
	when others => s_TEMPO_CNT <= "00000000000000000";
	
	end case;

		if (RST_i='1') then
			s_CNT <= s_TEMPO_CNT;
		elsif rising_edge(C3KHZ_i) then
			if (s_CNT="00000000000000000") then
					s_CNT <= s_TEMPO_CNT;
			else
				s_CNT <= s_CNT - 1;
			end if;
		end if;

end process;

end Behavioral;

