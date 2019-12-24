--=============================
-- Listing 14.25 mux
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity mux1 is
  generic(WIDTH: natural:=8);
  port(
     a: in std_logic_vector(WIDTH-1 downto 0);
     sel: in std_logic_vector(log2c(WIDTH)-1 downto 0);
     y: out std_logic
  );
end mux1;

architecture loop_linear_arch of mux1 is
begin
   process(a,sel)
   begin
      y <='0';
      for i in 0 to (WIDTH-1) loop
         if i= to_integer(unsigned(sel)) then
            y <= a(i);
         end if;
      end loop;
   end process;
end loop_linear_arch;