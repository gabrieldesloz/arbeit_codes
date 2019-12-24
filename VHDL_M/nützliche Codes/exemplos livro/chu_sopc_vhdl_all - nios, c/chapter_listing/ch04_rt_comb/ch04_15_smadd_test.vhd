-- Listing 4.15
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sm_add_test is
   port(
      sw: in std_logic_vector(7 downto 0);
      hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0)
   );
end sm_add_test;

architecture arch of sm_add_test is
   signal sum, oct: std_logic_vector(3 downto 0);
begin
   -- instantiate adder
   sm_adder_unit: entity work.sign_mag_add
      generic map(N=>4)
      port map(a=>sw(3 downto 0), b=>sw(7 downto 4),
               sum=>sum);
   -- 3-bit magnitude displayed on rightmost 7-seg LED
   oct <= '0' & sum(2 downto 0);
   sseg_unit: entity work.bin_to_sseg
      port map(bin=>oct, sseg=>hex0);
   -- sign displayed on 2nd 7-seg LED
   hex1 <= "0111111" when sum(3)='1' else -- middle bar
           "1111111";                      -- blank
   -- other two 7-seg LEDs blank
   hex2 <= "1111111";
   hex3 <= "1111111";
end arch;