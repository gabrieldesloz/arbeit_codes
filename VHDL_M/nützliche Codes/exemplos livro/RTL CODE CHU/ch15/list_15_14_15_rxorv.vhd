--=============================
-- Listing 15.14 reduced-xor-vector
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity reduced_xor_vector is
   generic(N: natural:=16);
   port(
      a: in std_logic_vector(N-1 downto 0);
      y: out std_logic_vector(N-1 downto 0)
   );
end reduced_xor_vector;

architecture linear_arch of reduced_xor_vector is
   signal p: std_logic_vector(N-1 downto 0);
begin
   p <= (p(N-2 downto 0) & '0') xor a;
   y <= p;
end linear_arch;


--=============================
-- Listing 15.15
--=============================
architecture para_prefix_arch of reduced_xor_vector is
   constant ST: natural:= log2c(N);
   signal p: std_logic_2d(ST downto 0, N-1 downto 0);
begin
   process(a,p)
   begin
      -- rename input
      for i in 0 to (N-1) loop
         p(0,i) <= a(i);
      end loop;
      -- main structure
      for s in 1 to ST loop
         for k in 0 to (2**(ST-s)-1) loop
            -- 1st half: pass-through boxes
            for i in 0 to (2**(s-1)-1) loop
               p(s, k*(2**s)+i) <= p(s-1, k*(2**s)+i);
            end loop;
            -- 2nd half: xor gates
            for i in (2**(s-1)) to (2**s-1) loop
               p(s, k*(2**s)+i) <=
                  p(s-1, k*(2**s)+i) xor
                  p(s-1, k*(2**s)+2**(s-1)-1);
            end loop;
         end loop;
      end loop;
      -- rename output
      for i in 0 to N-1 loop
         y(i) <= p(ST,i);
      end loop;
   end process;
end para_prefix_arch;
