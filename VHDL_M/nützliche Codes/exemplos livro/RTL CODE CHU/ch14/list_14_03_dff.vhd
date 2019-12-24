--=============================
-- Listing 14.3 unconstrained dff
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity unconstrain_dff is
   port(
      clk: std_logic;
      d: in std_logic_vector;
      q: out std_logic_vector
   );
end unconstrain_dff;

architecture arch of unconstrain_dff is
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
         q <= d;
      end if;
   end process;
end arch;