--=============================
-- Listing 14.24 priority encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity prio_encoder is
  generic(WIDTH: natural:=8);
  port(
     r: in std_logic_vector(WIDTH-1 downto 0);
     bcode: out std_logic_vector(log2c(WIDTH)-1 downto 0);
     valid: out std_logic
  );
end prio_encoder;

architecture loop_linear_arch of prio_encoder is
   constant B: natural := log2c(WIDTH);
   signal tmp: std_logic_vector(WIDTH-1 downto 0);
begin
   -- binary code
   process(r)
   begin
      bcode <= (others=>'0');
      for i in 0 to (WIDTH-1) loop
         if r(i)= '1' then
            bcode <= std_logic_vector(to_unsigned(i,B));
         end if;
      end loop;
   end process;
   -- reduced-or circuit
   process(r,tmp)
   begin
      tmp(0) <= r(0);
      for i in 1 to (WIDTH-1) loop
         tmp(i) <= r(i) or tmp(i-1);
      end loop;
   end process;
   valid <= tmp(WIDTH-1);
end loop_linear_arch;
