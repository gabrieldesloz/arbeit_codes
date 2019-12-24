--=============================
-- Listing 7.4 dual-mode comparator
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity comp2mode is
   port(
      a,b: in std_logic_vector(7 downto 0);
      mode: in std_logic;
      agtb: out std_logic
   );
end comp2mode;

architecture direct_arch of comp2mode is
   signal agtb_signed, agtb_unsigned: std_logic;
begin
   agtb_signed <= '1' when signed(a) > signed(b) else
                  '0';
   agtb_unsigned <= '1' when unsigned(a) > unsigned(b) else
                    '0';
   agtb <= agtb_unsigned when (mode='0') else
           agtb_signed;
end direct_arch ;


--=============================
-- Listing 7.5
--=============================
architecture shared_arch of comp2mode is
signal a1_b0, agtb_mag: std_logic;
begin
   a1_b0 <= '1' when a(7)='1' and b(7)='0' else
            '0';
   agtb_mag <= '1' when a(6 downto 0) > b(6 downto 0) else
               '0';
   agtb <= agtb_mag when (a(7)=b(7)) else
           a1_b0 when mode='0' else
           not a1_b0;
end shared_arch;