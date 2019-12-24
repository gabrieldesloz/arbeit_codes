-- Listing 4.20
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fp_adder_test is
   port(
      sw: in std_logic_vector(9 downto 0);
      key: in std_logic_vector(3 downto 0);
      hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0)
   );
end fp_adder_test;

architecture arch of fp_adder_test is
   signal sign1, sign2: std_logic;
   signal exp1, exp2: std_logic_vector(3 downto 0);
   signal frac1, frac2: std_logic_vector(7 downto 0);
   signal sign_out: std_logic;
   signal exp_out: std_logic_vector(3 downto 0);
   signal frac_out: std_logic_vector(7 downto 0);
begin
   -- set up the fp adder input signals
   sign1 <= sw(9);
   exp1 <= "1000";
   frac1<= '1' &  sw(1) & sw(0) & "10101";
   sign2 <= sw(8);
   exp2 <= not key;
   frac2 <= sw(7 downto 0);

   -- instantiate fp adder
   fp_add_unit: entity work.fp_adder
      port map(
         sign1=>sign1, sign2=>sign2, exp1=>exp1, exp2=>exp2,
         frac1=>frac1, frac2=>frac2,
         sign_out=>sign_out, exp_out=>exp_out,
         frac_out=>frac_out
      );

   -- instantiate three instances of 7-seg decoders
   -- exponent
   sseg_unit_exp: entity work.bin_to_sseg
      port map(bin=>exp_out, sseg=>hex0);
   -- 4 LSBs of fraction
   sseg_unit_frac0: entity work.bin_to_sseg
      port map(bin=>frac_out(3 downto 0), sseg=>hex1);
   -- 4 MSBs of fraction
   sseg_unit_frac1: entity work.bin_to_sseg
      port map(bin=>frac_out(7 downto 4), sseg=>hex2);
   -- sign
   hex3 <= "0111111" when sign_out='1' else -- middle bar
           "1111111";                       -- blank
end arch;