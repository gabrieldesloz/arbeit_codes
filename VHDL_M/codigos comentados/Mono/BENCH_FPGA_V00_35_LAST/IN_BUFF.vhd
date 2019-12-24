----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:11 03/22/2011 
-- Design Name: 
-- Module Name:    IN_BUFF - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IN_BUFF  is
    Port ( 
           LENGTH_i : in  STD_LOGIC_VECTOR (2 downto 0);
           C56MHz_i : in  STD_LOGIC;
		   RST_i : in STD_LOGIC;
           CLEAR_FF_i : in  STD_LOGIC;
           LENGTH_o : out  STD_LOGIC_VECTOR (2 downto 0));
end IN_BUFF;

architecture Behavioral of IN_BUFF is

signal s_TST1 : std_logic;
signal s_TST2 : std_logic;
signal s_LENGTH : std_logic_vector (2 downto 0);

begin

s_TST1 <= LENGTH_i(0) or LENGTH_i(1);
s_TST2 <= LENGTH_i(2) or s_TST1;

LENGTH_o <= s_LENGTH;

p_TST : process (C56MHz_i, CLEAR_FF_i, s_TST2, RST_i)
begin
   if (CLEAR_FF_i='1') or (RST_i='1') then
			s_LENGTH <= "000";
	elsif rising_edge(C56MHz_i) and s_TST2='1' then
			s_LENGTH <= LENGTH_i;
	end if;		

end process;

end Behavioral;

