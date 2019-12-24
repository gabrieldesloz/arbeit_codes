
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package definitions is	 -- Creates a type to use arrays in the entity declaration
  type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);  -- The array type
end package;
