--=============================
-- Listing 7.10 full comparator
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity comp3 is
   port(
       a,b: in std_logic_vector(15 downto 0);
       agtb, altb, aeqb: out std_logic
   );
end comp3 ;

architecture direct_arch of comp3 is
begin
   agtb <= '1' when a > b else
           '0';
   altb <= '1' when a < b else
           '0';
   aeqb <= '1' when a = b else
           '0';
end direct_arch;


--=============================
-- Listing 7.11
--=============================
architecture share1_arch of comp3 is
   signal gt, lt: std_logic;
begin
   gt <= '1' when a > b else
         '0';
   lt <= '1' when a < b else
         '0';
   agtb <= gt;
   altb <= lt;
   aeqb <= not (gt or lt);
end share1_arch;


--=============================
-- Listing 7.12
--=============================
architecture share2_arch of comp3 is
   signal eq, lt: std_logic;
begin
   eq <= '1' when a = b else
         '0';
   lt <= '1' when a < b else
         '0';
   aeqb <= eq;
   altb <= lt;
   agtb <= not (eq or lt);
end share2_arch;
