--=============================
-- Listing 8.1 D latch
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

architecture demo_arch of dlatch is
   signal q_latch: std_logic;
begin
   process(c,d,q_latch)
   begin
      if (c='1') then
         q_latch <= d;
      else
         q_latch <= q_latch;
      end if;
   end process;
   q <= q_latch;
end demo_arch;
