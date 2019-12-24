library ieee;
use ieee.std_logic_1164.all;

package my_types_pkg is	 -- Creates a type to use arrays in the entity declaration
  type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);  -- The array type
end package;
