--=============================
-- Listing 16.2 rising edge detector
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity rising_edge_detector is
   port(
      clk, reset: in std_logic;
      strobe: in std_logic;
      pulse: out std_logic
   );
end rising_edge_detector;

architecture direct_arch of rising_edge_detector is
   signal delay_reg: std_logic;
begin
   -- delay register
   process(clk,reset)
   begin
      if (reset='1') then
         delay_reg <= '0';
      elsif (clk'event and clk='1') then
         delay_reg <= strobe;
      end if;
   end process;
   -- decoding logic
   pulse <= (not delay_reg) and strobe;
end direct_arch;