--=============================
-- Listing 14.29 leading 0's
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity leading0_count is
   generic(WIDTH: natural:=8);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      zeros: out std_logic_vector(log2c(WIDTH)-1 downto 0)
   );
end leading0_count;

architecture exit_arch of leading0_count is
begin
   process(a)
      variable sum: unsigned(log2c(WIDTH)-1 downto 0);
   begin
      sum := (others=>'0');   -- initial value
      for i in WIDTH-1 downto 0 loop
         if a(i)='1' then
            exit;
         else
            sum := sum + 1;
         end if;
      end loop;
      zeros <= std_logic_vector(sum);
   end process;
end exit_arch;

--=============================
-- Listing 14.20
--=============================
architecture bypass_arch of leading0_count is
   signal bypass: std_logic_vector(WIDTH downto 0);
begin
   process(a,bypass)
      variable sum: unsigned(log2c(WIDTH)-1 downto 0);
   begin
      -- initial value
      sum := (others=>'0');
      bypass(WIDTH) <= '0';
      -- bypass flags
      for i in WIDTH-1 downto 0 loop
         if a(i)='1' then
            bypass(i) <= '1';
         else
            bypass(i) <= bypass(i+1);
         end if;
      end loop;
      -- counting 1's
      for i in WIDTH-1 downto 0 loop
         if bypass(i)='0' then
            if a(i)='0' then
               sum := sum + 1;
            end if;
         end if;
      end loop;
      zeros <= std_logic_vector(sum);
   end process;
end bypass_arch;