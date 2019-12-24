--=============================
-- Listing 5.10
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity bit_xor is
   port(
      a, b: in std_logic_vector(3 downto 0);
      y: out std_logic_vector(3 downto 0)
   );
end bit_xor;

architecture demo_arch of bit_xor  is
   constant WIDTH: integer := 4;
begin
   process(a,b)
   begin
      for i in (WIDTH-1) downto 0 loop
         y(i) <= a(i) xor b(i);
      end loop;
   end process;
end demo_arch;
