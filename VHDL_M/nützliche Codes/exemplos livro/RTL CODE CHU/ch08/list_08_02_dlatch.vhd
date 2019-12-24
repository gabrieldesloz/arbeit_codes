--=============================
-- Listing 8.2 D latch
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity dlatch is
   port(
      c: in std_logic;
      d: in std_logic;
      q: out std_logic
   );
end dlatch;

architecture arch of dlatch is
begin
   process(c,d)
   begin
      if (c='1') then
         q <= d;
      end if;
   end process;
end arch;
