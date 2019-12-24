--=============================
-- Listing 15.4 reduced-xor
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity reduced_xor is
   generic(WIDTH: natural:=10);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      y: out std_logic
   );
end reduced_xor;

architecture gen_tree_arch of reduced_xor is
   constant STAGE: natural:= log2c(WIDTH);
   signal p:
      std_logic_2d(STAGE downto 0, WIDTH-1 downto 0);
begin
   -- rename input signal
   in_gen:
   for i in 0 to (WIDTH-1) generate
      p(STAGE,i) <= a(i);
   end generate;
   -- replicated structure
   stage_gen:
   for s in (STAGE-1) downto 0 generate
      row_gen:
      for r in 0 to (2**s-1) generate
         p(s,r) <= p(s+1,2*r) xor p(s+1,2*r+1);
      end generate;
   end generate;
   -- rename output signal
   y <= p(0,0);
end gen_tree_arch;


--=============================
-- Listing 15.5 arbitrary number of bits
--=============================
architecture gen_tree2_arch of reduced_xor is
   constant STAGE: natural:= log2c(WIDTH);
   signal p:
      std_logic_2d(STAGE downto 0, 2**STAGE-1 downto 0);
begin
   -- rename input signal
   in_gen:
   for i in 0 to (WIDTH-1) generate
      p(STAGE,i) <= a(i);
   end generate;
   -- padding 0's
   pad0_gen:
   if WIDTH < (2**STAGE) generate
      zero_gen:
      for i in WIDTH to (2**STAGE-1) generate
         p(STAGE,i) <= '0';
      end generate;
   end generate;
   -- replicated structure
   stage_gen:
   for s in (STAGE-1) downto 0 generate
      row_gen:
      for r in 0 to (2**s-1) generate
         p(s,r) <= p(s+1,2*r) xor p(s+1,2*r+1);
      end generate;
   end generate;
   -- rename output signal
   y <= p(0,0);
end gen_tree2_arch;


--=============================
-- Listing 15.6 use for loop
--=============================
architecture loop_tree_arch of reduced_xor is
   constant STAGE: natural:= log2c(WIDTH);
   signal p:
      std_logic_2d(STAGE downto 0, 2**STAGE-1 downto 0);
begin
   process(a,p)
   begin
      for i in 0 to (2**STAGE-1) loop
         if i < WIDTH then
            p(STAGE,i) <= a(i); -- rename input signal
         else
            p(STAGE,i) <= '0';  -- padding 0's
         end if;
      end loop;
        -- replicated structure
      for s in (STAGE-1) downto 0 loop
         for r in 0 to (2**s-1) loop
            p(s,r) <= p(s+1,2*r) xor p(s+1, 2*r+1);
         end loop;
      end loop;
   end process;
   -- rename output signal
   y <= p(0,0);
end loop_tree_arch;