--=============================
-- Listing 4.9
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity truth_table is
   port(
      a,b: in  std_logic;
      y: out   std_logic
   );
end truth_table;

architecture a of truth_table is
   signal tmp: std_logic_vector(1 downto 0);
begin
   tmp <= a & b;
   with tmp select
      y <= '0' when "00",
           '1' when "01",
           '1' when "10",
           '1' when others; -- "11"
end a;