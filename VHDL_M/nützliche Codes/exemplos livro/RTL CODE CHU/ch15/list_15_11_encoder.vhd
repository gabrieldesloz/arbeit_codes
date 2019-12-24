--=============================
-- Listing 15.11 binary encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity bin_encoder is
   generic(N: natural:=8);
   port(
      a: in std_logic_vector(N-1 downto 0);
      bcode: out std_logic_vector(log2c(N)-1 downto 0)
   );
end bin_encoder;

architecture para_arch0 of bin_encoder is
   type mask_2d_type is array(log2c(N)-1 downto 0) of
      std_logic_vector(N-1 downto 0);
   signal mask: mask_2d_type;
   function gen_or_mask return mask_2d_type is
      variable or_mask: mask_2d_type;
   begin
      for i in (log2c(N)-1) downto 0 loop
         for k in (N-1) downto 0 loop
            if (k/(2**i) mod 2)= 1 then
               or_mask(i)(k) := '1';
            else
               or_mask(i)(k) := '0';
            end if;
         end loop;
      end loop;
      return or_mask;
   end function;

begin
   mask <= gen_or_mask;
   process(mask,a)
      variable tmp_row: std_logic_vector(N-1 downto 0);
      variable tmp_bit: std_logic;
   begin
      for i in (log2c(N)-1) downto 0 loop
         tmp_row := a and mask(i);
         -- reduced or operation
         tmp_bit := '0';
         for k in (N-1) downto 0 loop
            tmp_bit := tmp_bit or tmp_row(k);
         end loop;
         bcode(i) <= tmp_bit;
      end loop;
   end process;
end para_arch0;