--=============================
-- Listing 14.27 population counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity popu_count is
   generic(WIDTH: natural:=8);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      count: out std_logic_vector(log2c(WIDTH)-1 downto 0)
   );
end popu_count;

architecture loop_linear_arch of popu_count is
begin
   process(a)
      variable sum: unsigned(log2c(WIDTH)-1 downto 0);
   begin
      sum := (others=>'0');
      for i in 0 to (WIDTH-1) loop
         if a(i)= '1' then
            sum := sum + 1;
         end if;
      end loop;
      count <= std_logic_vector(sum);
   end process;
end loop_linear_arch;


--=============================
-- Listing 14.31
--=============================
architecture next_arch of popu_count is
begin
   process(a)
      variable sum: unsigned(log2c(WIDTH)-1 downto 0);
   begin
      sum := (others=>'0');
      for i in 0 to (WIDTH-1) loop
         next when a(i)='0';
         sum := sum + 1;
      end loop;
      count <= std_logic_vector(sum);
   end process;
end next_arch;
