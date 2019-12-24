--=============================
-- Listing 14.4 unconstrained reduced-xor
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity unconstrain_reduced_xor is
   port(
      a: in std_logic_vector;
      y: out std_logic
   );
end unconstrain_reduced_xor;

architecture arch of unconstrain_reduced_xor is
   constant WIDTH : natural:= a'length;
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
begin
   process(a,tmp)
   begin
      tmp(0) <= a(0);
      for i in 1 to (WIDTH-1) loop
         tmp(i) <= a(i) xor tmp(i-1);
      end loop;
   end process;
   y <= tmp(WIDTH-1);
end arch;

--=============================
-- Listing 14.5
--=============================
architecture better_arch of unconstrain_reduced_xor is
   constant WIDTH : natural:= a'length;
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
   signal aa: std_logic_vector(WIDTH-1 downto 0);
begin
   aa <= a;
   process(aa,tmp)
   begin
      tmp(0) <= aa(0);
      for i in 1 to (WIDTH-1) loop
         tmp(i) <= aa(i) xor tmp(i-1);
      end loop;
   end process;
   y <= tmp(WIDTH-1);
end better_arch;



--=============================
-- simple test
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity test_reduced_xor is
   port(
      a: in std_logic_vector(15 downto 7);
      y: out std_logic
   );
end test_reduced_xor;

architecture arch of test_reduced_xor is
begin
   uut: entity work.unconstrain_reduced_xor(better_arch)
      port map (a=>a, y=>y);
end arch;


