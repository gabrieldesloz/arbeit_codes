--=============================
-- Listing 9.7 Gray counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gray_counter4 is
   port(
      clk, reset: in std_logic;
      q: out std_logic_vector(3 downto 0)
   );
end gray_counter4;

architecture arch of gray_counter4 is
   constant WIDTH: natural := 4;
   signal g_reg: unsigned(WIDTH-1 downto 0);
   signal g_next, b, b1: unsigned(WIDTH-1 downto 0);
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         g_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         g_reg <= g_next;
      end if;
   end process;
   -- next-state logic
   -- gray to binary
   b <= g_reg xor ('0' & b(WIDTH-1 downto 1));
   b1 <= b+1; -- increment
   -- binary to gray
   g_next <= b1 xor ('0' & b1(WIDTH-1 downto 1));
   -- output logic
   q <= std_logic_vector(g_reg);
end arch;