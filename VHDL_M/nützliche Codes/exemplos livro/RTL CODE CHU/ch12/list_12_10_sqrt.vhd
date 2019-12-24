--=============================
-- Listing 12.10 approximated square root
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sqrt is
   port(
      a_in, b_in: in std_logic_vector(7 downto 0);
      r: out std_logic_vector(8 downto 0)
   );
end sqrt;

architecture comb_arch of sqrt is
   constant WIDTH: natural:=8;
   signal a, b, x, y: signed(WIDTH downto 0);
   signal t1, t2, t3, t4, t5, t6, t7: signed(WIDTH downto 0);
begin
   a <= signed(a_in(WIDTH-1) & a_in); -- signed extension
   b <= signed(b_in(WIDTH-1) & b_in);
   t1 <= a when a > 0 else
         0 - a;
   t2 <= b when b > 0 else
         0 - b;
   x <= t1 when t1 - t2 > 0 else
        t2;
   y <= t2 when t1 - t2 > 0 else
        t1;
   t3 <= "000" & x(WIDTH downto 3);
   t4 <= "0" & y(WIDTH downto 1);
   t5 <= x - t3;
   t6 <= t4 + t5;
   t7 <= t6 when t6 - x > 0 else
         x;
   r <= std_logic_vector(t7);
end comb_arch;