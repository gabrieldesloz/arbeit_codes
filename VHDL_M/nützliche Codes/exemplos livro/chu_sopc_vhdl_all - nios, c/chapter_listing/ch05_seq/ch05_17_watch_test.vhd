-- Listing 5.17
library ieee;
use ieee.std_logic_1164.all;
entity stop_watch_test is
   port(
      clk: in std_logic;
      key: in std_logic_vector(1 downto 0);
      hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0)
   );
end stop_watch_test;

architecture arch of stop_watch_test is
   signal go, clr: std_logic;
   signal d2, d1, d0: std_logic_vector(3 downto 0);
begin
  go <= not key(1);
  clr <= not key(0);
  -- instantiate watch 
  watch_unit: entity work.stop_watch(cascade_arch)
     port map(
        clk=>clk, go=>go, clr=>clr,
        d2 =>d2, d1=>d1, d0=>d0 );
   -- instantiate four instances of 7-seg LED decoders
   sseg_unit_0: entity work.bin_to_sseg
      port map(bin=>d0, sseg=>hex0);
   sseg_unit_1: entity work.bin_to_sseg
      port map(bin=>d1, sseg=>hex1);
   sseg_unit_2: entity work.bin_to_sseg
      port map(bin=>d2, sseg=>hex2);
   sseg_unit_3: entity work.bin_to_sseg
      port map(bin=>"0000", sseg=>hex3);       
end arch;