--=============================
-- Listing 4.2
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity decoder4 is
   port(
      s: in  std_logic_vector(1 downto 0);
      x: out std_logic_vector(3 downto 0)
   );
end decoder4;

architecture cond_arch of decoder4 is
begin
    x <= "0001" when (s="00") else
         "0010" when (s="01") else
         "0100" when (s="10") else
         "1000";
end cond_arch;


--=============================
-- Listing 4.6
--=============================
architecture sel_arch of decoder4 is
begin
   with s select
     x <= "0001" when "00",
          "0010" when "01",
          "0100" when "10",
          "1000" when others;
end sel_arch;