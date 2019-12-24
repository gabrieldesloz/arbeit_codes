-- Listing 4.18
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity shifter_test is
   port(
      sw: in std_logic_vector(7 downto 0);
      key: in std_logic_vector(2 downto 0);
      ledr: out std_logic_vector(7 downto 0)
   );
end shifter_test;

architecture arch of shifter_test is
   signal amt: std_logic_vector(2 downto 0);
begin
   amt <= not key;
   shift_unit: entity work.barrel_shifter(multi_stage_arch)
      port map(a=>sw, amt=>amt, y=>ledr);
end arch;