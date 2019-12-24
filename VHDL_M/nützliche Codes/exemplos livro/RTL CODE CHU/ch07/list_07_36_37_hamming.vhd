--=============================
-- Listing 7.36 Hamming distance circuit
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity hamming is
   port(
      a,b: in std_logic_vector(7 downto 0);
      y: out std_logic_vector(3 downto 0)
   );
end hamming;

architecture effi_arch of hamming is
   signal diff: unsigned(7 downto 0);
   signal lev0_0, lev0_2, lev0_4, lev0_6:
      unsigned(1 downto 0);
   signal lev1_0, lev1_4: unsigned(2 downto 0);
   signal lev2: unsigned(3 downto 0);
begin
   diff <= unsigned(a xor b);
   lev0_0 <= ('0' & diff(0)) + ('0' & diff(1));
   lev0_2 <= ('0' & diff(2)) + ('0' & diff(3));
   lev0_4 <= ('0' & diff(4)) + ('0' & diff(5));
   lev0_6 <= ('0' & diff(6)) + ('0' & diff(7));
   lev1_0 <= ('0' & lev0_0) + ('0' & lev0_2);
   lev1_4 <= ('0' & lev0_4) + ('0' & lev0_6);
   lev2 <= ('0' & lev1_0) + ('0' & lev1_4);
   y <= std_logic_vector(lev2);
end effi_arch;

--=============================
-- Listing 7.37
--=============================
architecture compact_arch of hamming is
   signal diff, lev0, lev1, lev2: unsigned(7 downto 0);
   constant MASK0: unsigned(7 downto 0) := "01010101";
   constant MASK1: unsigned(7 downto 0) := "00110011";
   constant MASK2: unsigned(7 downto 0) := "00001111";

begin
   diff <= unsigned(a xor b);
   lev0 <= (diff and MASK0) +
           (('0'& diff(7 downto 1)) and MASK0);
   lev1 <= (lev0 and MASK1) +
           (("00" & lev0(7 downto 2)) and MASK1);
   lev2 <= (lev1 and MASK2) +
           (("0000" & lev1(7 downto 4)) and MASK2);
   y <= std_logic_vector(lev2(3 downto 0));
end compact_arch;

