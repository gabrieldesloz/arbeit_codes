--=============================
-- Listing 15.7 binary decoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity tree_decoder is
   generic(WIDTH: natural:=4);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      en:std_logic;
      code: out std_logic_vector(2**WIDTH-1 downto 0)
   );
end tree_decoder;

architecture loop_tree_arch of tree_decoder is
   constant STAGE: natural:= WIDTH;
   signal p:
      std_logic_2d(STAGE downto 0, 2**STAGE-1 downto 0);
begin
   process(a,p)
   begin
      -- leftmost stage
      p(STAGE,0) <= en;
      -- middle stages
      for s in STAGE downto 1 loop
         for r in 0 to (2**(STAGE-s)-1) loop
            p(s-1,2*r) <= (not a(s-1)) and p(s,r);
            p(s-1,2*r+1) <= a(s-1) and p(s,r);
         end loop;
      end loop;
      -- last stage and output
      for i in 0 to (2**STAGE-1) loop
         code(i) <= p(0,i);
      end loop;
   end process;
end loop_tree_arch;