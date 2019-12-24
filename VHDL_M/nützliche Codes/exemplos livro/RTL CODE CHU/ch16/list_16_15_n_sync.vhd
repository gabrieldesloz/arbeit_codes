--=============================
-- Listing 16.15 parameterized synchronizer
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity synchronizer_g is
   generic(N: natural);
   port(
      clk, reset: in std_logic;
      in_async: in std_logic_vector(N-1 downto 0);
      out_sync: out std_logic_vector(N-1 downto 0)
   );
end synchronizer_g;

architecture two_ff_arch of synchronizer_g is
   signal meta_reg, sync_reg: std_logic_vector(N-1 downto 0);
   signal meta_next, sync_next:
      std_logic_vector(N-1 downto 0);
begin
   -- two registers
   process(clk,reset)
   begin
      if (reset='1') then
         meta_reg <= (others=>'0');
         sync_reg <= (others=>'0');
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