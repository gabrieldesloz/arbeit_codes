library ieee;
use ieee.std_logic_1164.all;
entity palette_de2 is
   port (
      color_in: in  std_logic_vector(7 downto 0);  
      color_out: out std_logic_vector(29 downto 0)
   );
end palette_de2;

architecture arch of palette_de2 is
   signal r3, g3:  std_logic_vector(2 downto 0); 
   signal b2:  std_logic_vector(1 downto 0); 
begin
   r3 <= color_in(7 downto 5);          -- 3-bit red 
   g3 <= color_in(4 downto 2);          -- 3-bit green 
   b2 <= color_in(1 downto 0);          -- 2-bit blue 
   color_out <= r3 & r3 & r3 & r3(2) &  -- 10-bit red 
                g3 & g3 & g3 & g3(2) &  -- 10-bit green 
                b2 & b2 &b2 &b2 & b2;   -- 10-bit blue
end arch;
