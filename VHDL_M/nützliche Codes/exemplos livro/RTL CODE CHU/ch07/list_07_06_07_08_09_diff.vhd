--=============================
-- Listing 7.6 difference circuit
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity diff is
   port(
      a,b: in std_logic_vector(7 downto 0);
      result: out std_logic_vector(7 downto 0)
    );
end diff;

architecture direct_arch of diff is
   signal au, bu, ru, diffab, diffba: unsigned(7 downto 0);
begin
   au <= unsigned(a);
   bu <= unsigned(b);
   diffab <= au - bu;
   diffba <= bu - au;
   ru <= diffab when (au >= bu) else
         diffba;
   result <= std_logic_vector(ru);
end direct_arch;

--=============================
-- Listing 7.7
--=============================
architecture shared_arch of diff is
   signal as, bs, rs, diffab, diffba: signed(8 downto 0);
begin
   as <= signed('0'&a);
   bs <= signed('0'&b);
   diffab <= as - bs;
   diffba <= bs - as;
   rs <= diffab when diffab(8)='0' else
         diffba;
   result <= std_logic_vector(rs(7 downto 0));
end shared_arch;


--=============================
-- Listing 7.8
--=============================
architecture effi_arch of diff is
   signal as, bs, rs, diffab, diffba: signed(8 downto 0);
begin
   as <= signed('0'&a);
   bs <= signed('0'&b);
   diffab <= as - bs;
   diffba <= 0 - diffab;
   rs <= diffab when diffab(8)='0' else
         diffba;
   result <= std_logic_vector(rs(7 downto 0));
end effi_arch;


--=============================
-- Listing 7.9
--=============================
architecture shared3_arch of diff is
   signal au, bu, ru, src0, src1: unsigned(7 downto 0);
begin
   au <= unsigned(a);
   bu <= unsigned(b);
   process(au,bu)
   begin
      if au >= bu then
         src0 <= au;
         src1 <= bu;
      else
         src0 <= bu;
         src1 <= au;
      end if;
   end process;
   ru <= src0 - src1;
   result <= std_logic_vector(ru);
end shared3_arch;
