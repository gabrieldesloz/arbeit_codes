--=============================
-- Listing 8.3 D FF
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity dff is
   port(
      clk: in std_logic;
      d: in std_logic;
      q: out std_logic
   );
end dff;

architecture arch of dff is
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
         q <= d;
      end if;
   end process;
end arch;
