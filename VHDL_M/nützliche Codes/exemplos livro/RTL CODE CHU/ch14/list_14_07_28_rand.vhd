--=============================
-- Listing 14.7 reduced and
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity reduced_and is
   generic(WIDTH: natural:=8);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      y: out std_logic
   );
end reduced_and;

architecture array_arch of reduced_and is
begin
   y <= '1' when a=(a'range=>'1') else
        '0';
end array_arch;
--=============================
-- Listing 14.28 use exit
--=============================
architecture exit_arch of reduced_and is
begin
   process(a)
      variable tmp: std_logic;
   begin
      tmp := '1';   -- default output
      for i in 0 to (WIDTH-1) loop
         if a(i)='0' then
            tmp := '0';
            exit;
         end if;
      end loop;
      y <= tmp;
   end process;
end exit_arch;