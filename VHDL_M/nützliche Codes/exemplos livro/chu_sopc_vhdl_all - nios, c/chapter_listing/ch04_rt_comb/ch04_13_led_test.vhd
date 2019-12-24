--List 4.13
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity led_test is
   port(
      sw: in std_logic_vector(7 downto 0);
      hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0)
   );
end led_test;

architecture arch of led_test is
   signal inc: std_logic_vector(7 downto 0);
begin
   -- increment input
   inc <= std_logic_vector(unsigned(sw) + 1);

   -- instantiate four instances of 7-seg LED decoders
   -- instance for 4 LSBs of input
   sseg_unit_0: entity work.bin_to_sseg
      port map(bin=>sw(3 downto 0), sseg=>hex0);
   -- instance for 4 MSBs of input
   sseg_unit_1: entity work.bin_to_sseg
      port map(bin=>sw(7 downto 4), sseg=>hex1);
   -- instance for 4 LSBs of incremented value
   sseg_unit_2: entity work.bin_to_sseg
      port map(bin=>inc(3 downto 0), sseg=>hex2);
   -- instance for 4 MSBs of incremented value
   sseg_unit_3: entity work.bin_to_sseg
      port map(bin=>inc(7 downto 4), sseg=>hex3);
end arch;