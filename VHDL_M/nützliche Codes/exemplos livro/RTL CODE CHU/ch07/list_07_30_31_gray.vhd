--=============================
-- Listing 7.30 Gray code incrementor
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity g_inc is
   port(
      g: in std_logic_vector(3 downto 0);
      g1: out std_logic_vector(3 downto 0)
   );
end g_inc ;

architecture table_arch of g_inc is
begin
   with g select
      g1 <= "0001" when "0000",
            "0011" when "0001",
            "0010" when "0011",
            "0110" when "0010",
            "0111" when "0110",
            "0101" when "0111",
            "0100" when "0101",
            "1100" when "0100",
            "1101" when "1100",
            "1111" when "1101",
            "1110" when "1111",
            "1010" when "1110",
            "1011" when "1010",
            "1001" when "1011",
            "1000" when "1001",
            "0000" when others; -- "1000"
end table_arch;

--=============================
-- Listing 7.31 
--=============================
architecture compact_arch of g_inc is
   constant WIDTH: integer := 4;
   signal b, b1: std_logic_vector(WIDTH-1 downto 0);
begin
   -- Gray to binary
   b <= g xor ('0' & b(WIDTH-1 downto 1));
   -- binary increment
   b1 <= std_logic_vector((unsigned(b)) + 1);
   -- binary to Gray
   g1<= b1 xor ('0' & b1(WIDTH-1 downto 1));
end compact_arch;

