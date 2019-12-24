--=============================
-- Listing 16.1 synchonizer
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity synchronizer is
   port(
      clk, reset: in std_logic;
      in_async: in std_logic;
      out_sync: out std_logic
   );
end synchronizer;

architecture two_ff_arch of synchronizer is
   signal meta_reg, sync_reg: std_logic;
   signal meta_next, sync_next: std_logic;
begin
   -- two D FFs
   process(clk,reset)
   begin
      if (reset='1') then
         meta_reg <= '0';
         sync_reg <= '0';
      elsif (clk'event and clk='1') then
         meta_reg <= meta_next;
         sync_reg <= sync_next;
      end if;
   end process;
   -- next-state logic
   meta_next <= in_async;
   sync_next <= meta_reg;
   -- output
   out_sync <= sync_reg;
end two_ff_arch;