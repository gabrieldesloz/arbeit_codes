--=============================
-- Listing 14.1 reduced-xor
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity reduced_xor is
   generic(WIDTH: natural:=8);  -- generic declaration
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      y: out std_logic
   );
end reduced_xor;

architecture loop_linear_arch of reduced_xor is
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
begin
   process(a,tmp)
   begin
      tmp(0) <= a(0);   -- boundary bit
      for i in 1 to (WIDTH-1) loop
         tmp(i) <= a(i) xor tmp(i-1);
      end loop;
   end process;
   y <= tmp(WIDTH-1);
end loop_linear_arch;


--=============================
-- Listing 14.2 use attribute
--=============================
architecture attr_arch of reduced_xor is
   signal tmp: std_logic_vector(a'length-1 downto 0);
begin
   process(a,tmp)
   begin
      tmp(0) <= a(0);
      for i in 1 to (a'length-1) loop
         tmp(i) <= a(i) xor tmp(i-1);
      end loop;
   end process;
   y <= tmp(a'length-1);
end attr_arch;


--=============================
-- Listing 14.6 use array
--=============================
architecture array_arch of reduced_xor is
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
begin
   tmp <= (tmp(WIDTH-2 downto 0) & '0') xor a;
   y <= tmp(WIDTH-1);
end array_arch;

--=============================
-- Listing 14.12 use for generate
--=============================
architecture gen_linear_arch of reduced_xor is
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
begin
   tmp(0) <= a(0);
   xor_gen:
   for i in 1 to (WIDTH-1) generate
      tmp(i) <= a(i) xor tmp(i-1);
   end generate;
   y <= tmp(WIDTH-1);
end gen_linear_arch;


--=============================
-- Listing 14.15 use if generate
--=============================
architecture gen_if_arch of reduced_xor is
   signal tmp: std_logic_vector(WIDTH-2 downto 1);
begin
   xor_gen:
   for i in 1 to (WIDTH-1) generate
      -- leftmost stage
      left_gen: if i=1 generate
         tmp(i) <= a(i) xor a(0);
      end generate;
      -- middle stages
      middle_gen: if (1 < i) and (i < (WIDTH-1)) generate
         tmp(i) <= a(i) xor tmp(i-1);
      end generate;
      -- rightmost stage
      right_gen: if i=(WIDTH-1) generate
         y <= a(i) xor tmp(i-1);
      end generate;
   end generate;
end gen_if_arch;


--=============================
-- Listing 14.26 use varaible
--=============================
architecture loop_linear_var_arch of reduced_xor is
begin
   process(a)
      variable tmp: std_logic;
   begin
      tmp := a(0);
      for i in 1 to (WIDTH-1) loop
         tmp := a(i) xor tmp;
      end loop;
      y <= tmp;
   end process;
end loop_linear_var_arch;
