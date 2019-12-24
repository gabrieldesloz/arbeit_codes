--=============================
-- Listing 7.27 rotate-right shifter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity rotate_right is
   port(
      a: in std_logic_vector(7 downto 0);
      amt: in std_logic_vector(2 downto 0);
      y: out std_logic_vector(7 downto 0)
   );
end rotate_right;

architecture direct_arch of rotate_right is
begin
   with amt select
       y<= a                             when "000",
           a(0) & a(7 downto 1)          when "001",
           a(1 downto 0) & a(7 downto 2) when "010",
           a(2 downto 0) & a(7 downto 3) when "011",
           a(3 downto 0) & a(7 downto 4) when "100",
           a(4 downto 0) & a(7 downto 5) when "101",
           a(5 downto 0) & a(7 downto 6) when "110",
           a(6 downto 0) & a(7) when others; -- 111
end direct_arch;

--=============================
-- Listing 7.28
--=============================
architecture multi_level_arch of rotate_right is
   signal le0_out, le1_out, le2_out:
      std_logic_vector(7 downto 0);
begin
   -- level 0, shift 0 or 1 bit
   le0_out <= a(0) & a(7 downto 1) when amt(0)='1' else
              a;
   -- level 1, shift 0 or 2 bits
   le1_out <=
     le0_out(1 downto 0) & le0_out(7 downto 2)
        when amt(1)='1' else
     le0_out;
   -- level 2, shift 0 or 4 bits
   le2_out <=
     le1_out(3 downto 0) & le1_out(7 downto 4)
        when amt(2)='1' else
     le1_out;
   -- output
   y <= le2_out;
end multi_level_arch;