library ieee;
use ieee.std_logic_1164.all;
entity palette is
   port (
      color_in: in  std_logic_vector(7 downto 0);  
      color_out: out std_logic_vector(11 downto 0)
   );
end palette;

architecture arch of palette is
begin
   color_out <=   color_in(7 downto 5) & color_in(5) -- 3-bit red to 4-bit red 
                & color_in(4 downto 2) & color_in(2) -- 3-bit green to 4-bit green 
                & color_in(1 downto 0) & color_in(0) & color_in(0); -- 2-bit blue to 4-bit blue 
end arch;
