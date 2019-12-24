--=============================
-- Listing 7.33 signed addition with status
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity adder_status is
   port (
      a,b: in std_logic_vector(7 downto 0);
      cin: in std_logic;
      sum: out  std_logic_vector(7 downto 0);
      cout, zero, overflow, sign: out std_logic
   );
end adder_status;

architecture arch of adder_status is
   signal a_ext, b_ext, sum_ext: signed(9 downto 0);
   signal ovf: std_logic;
   alias sign_a: std_logic is a_ext(8);
   alias sign_b: std_logic is b_ext(8);
   alias sign_s: std_logic is sum_ext(8);
begin
   a_ext <= signed('0' & a & '1');
   b_ext <= signed('0' & b & cin);
   sum_ext <= a_ext + b_ext;
   ovf <= (sign_a and sign_b and (not sign_s)) or
          ((not sign_a) and (not sign_b) and sign_s);
   cout <= sum_ext(9);
   sign <= sum_ext(8) when ovf='0' else
           not sum_ext(8);
   zero <= '1' when (sum_ext(8 downto 1)=0 and ovf='0') else
           '0';
   overflow <= ovf;
   sum <= std_logic_vector(sum_ext(8 downto 1));
end arch;
