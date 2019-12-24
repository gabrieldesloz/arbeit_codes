--=============================
-- Listing 14.11 binary decoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity bin_decoder is
   generic(WIDTH: natural:=3);
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      code: out std_logic_vector(2**WIDTH-1 downto 0)
   );
end bin_decoder;

architecture gen_arch of bin_decoder is
begin
   comp_gen:
   for i in 0 to (2**WIDTH-1) generate
      code(i) <= '1' when i=to_integer(unsigned(a)) else
                 '0';
   end generate;
end gen_arch;


--=============================
-- Listing 14.21
--=============================
architecture loop_arch of bin_decoder is
begin
   process(a)
   begin
      for i in 0 to (2**WIDTH-1) loop
         if i=to_integer(unsigned(a)) then
            code(i) <= '1';
         else
            code(i) <= '0';
         end if;
      end loop;
   end process;
end loop_arch;