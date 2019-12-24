--=============================
-- Listing 8.5 D FF w/ reset/preset
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity dffrp is
   port(
      clk: in std_logic;
      reset, preset: in std_logic;
      d: in std_logic;
      q: out std_logic
   );
end dffrp;

architecture arch of dffrp is
begin
   process(clk,reset,preset)
   begin
      if (reset='1') then
         q <='0';
      elsif (preset='1') then
         q <= '1';
      elsif (clk'event and clk='1') then
         q <= d;
      end if;
   end process;
end arch;