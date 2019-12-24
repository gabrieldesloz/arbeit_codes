--=============================
-- Listing 15.8 tree mux
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

architecture loop_tree_arch of mux1 is
   constant STAGE: natural:= log2c(WIDTH);
   signal p:
      std_logic_2d(STAGE downto 0, 2**STAGE-1 downto 0);
begin
   process(a,sel,p)
   begin
      for i in 0 to (2**STAGE-1) loop
         if i < WIDTH then
            p(STAGE,i) <= a(i); -- rename input signal
         else
            p(STAGE,i) <= '0'; -- padding 0's
         end if;
      end loop;
      -- replicated structure
      for s in (STAGE-1) downto 0 loop
         for r in 0 to (2**s-1) loop
            if sel((STAGE-1)-s)='0' then
               p(s,r) <= p(s+1,2*r);
            else
               p(s,r) <= p(s+1,2*r+1);
            end if;
         end loop;
      end loop;
   end process;
   -- rename output signal
   y <= p(0,0);
end loop_tree_arch;


--=============================
-- Listing 15.9
--=============================
architecture beh_arch of mux1 is
begin
   y <= a(to_integer(unsigned(sel)));
end beh_arch;
