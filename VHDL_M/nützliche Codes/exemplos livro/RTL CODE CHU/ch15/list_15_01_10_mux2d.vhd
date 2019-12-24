--=============================
-- Listing 15.1 2d mux
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity mux2d is
   generic(
      P: natural:=4; -- number of input ports
      B: natural:=3  -- number of bits per port
   );
   port(
      a: in std_logic_2d(P-1 downto 0, B-1 downto 0);
      sel: in std_logic_vector(log2c(P)-1 downto 0);
      y: out std_logic_vector(B-1 downto 0)
   );
end mux2d;

architecture two_d_arch of mux2d is
begin
   process(a,sel)
   begin
      y <=(others=>'0');
      for i in 0 to (P-1) loop
         if i= to_integer(unsigned(sel)) then
            for j in 0 to (B-1) loop -- B-bits of the port
               y(j) <= a(i,j);
            end loop;
         end if;
      end loop;
   end process;
end two_d_arch;


--=============================
-- Listing 15.10
--=============================
architecture from_mux1d_arch of mux2d is
   type aoa_transpose_type is
      array(B-1 downto 0) of std_logic_vector(P-1 downto 0);
   signal aa: aoa_transpose_type;
   component mux1 is
      generic(WIDTH: natural);
      port(
         a: in std_logic_vector(WIDTH-1 downto 0);
         sel: in std_logic_vector(log2c(WIDTH)-1 downto 0);
         y: out std_logic
      );
   end component;
begin
   -- convert to array-of-arrays data type
   process(a)
   begin
      for i in 0 to (B-1) loop
         for j in 0 to (P-1) loop
            aa(i)(j) <= a(j,i);
         end loop;
      end loop;
   end process;
   -- replicate 1-bit multiplexer B times
   gen_nbit: for i in 0 to (B-1) generate
      mux: mux1
         generic map(WIDTH=>P)
         port map(a=>aa(i), sel=>sel, y=>y(i));
   end generate;
end from_mux1d_arch;
