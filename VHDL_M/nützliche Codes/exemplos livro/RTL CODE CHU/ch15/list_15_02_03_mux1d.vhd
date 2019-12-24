--=============================
-- Listing 15.2  emulated 2d mux
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity mux_emu_2d is
   generic(
      P: natural:=4; -- number of input ports
      B: natural:=3  -- number of bits per port
   );
   port(
      a: in std_logic_vector(P*B-1 downto 0);
      sel: in std_logic_vector(log2c(P)-1 downto 0);
      y: out std_logic_vector(B-1 downto 0)
   );
end mux_emu_2d;


architecture emu_2d_arch of mux_emu_2d is
   function ix(r,c: natural) return natural is
      begin
         return (r*B + c);
      end ix;
begin
   process(a,sel)
   begin
      y <=(others=>'0');
      for r in 0 to (P-1) loop
         if r= to_integer(unsigned(sel)) then
            for c in 0 to (B-1) loop -- B-bits of the port
               y(c) <= a(ix(r,c));
            end loop;
         end if;
      end loop;
   end process;
end emu_2d_arch;

--=============================
-- Listing 15.32 use array-of-arrays
--=============================
architecture a_of_a_arch of mux_emu_2d is
   type std_aoa_type is
      array(P-1 downto 0) of std_logic_vector(B-1 downto 0);
   signal aa: std_aoa_type;
begin
   -- convert to array-of-arrays data type
   process(a)
   begin
      for r in 0 to (P-1) loop
         for c in 0 to (B-1) loop
            aa(r)(c) <= a(r*B+c);
         end loop;
      end loop;
   end process;
   -- mux
   process(aa,sel)
   begin
      y <=(others=>'0');
      for i in 0 to (P-1) loop
         if i= to_integer(unsigned(sel)) then
            y <= aa(i);
         end if;
      end loop;
   end process;
end a_of_a_arch;