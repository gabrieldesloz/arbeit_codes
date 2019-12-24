library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
function decimal_string_to_unsigned(decimal_string: string; wanted_bitwidth: positive) return unsigned is
  variable tmp_unsigned: unsigned(wanted_bitwidth-1 downto 0) := (others => '0');
  variable character_value: integer;
begin
  for string_pos in decimal_string'range loop
    case decimal_string(string_pos) is
      when '0' => character_value := 0;
      when '1' => character_value := 1;
      when '2' => character_value := 2;
      when '3' => character_value := 3;
      when '4' => character_value := 4;
      when '5' => character_value := 5;
      when '6' => character_value := 6;
      when '7' => character_value := 7;
      when '8' => character_value := 8;
      when '9' => character_value := 9;
      when others => report("Illegal number") severity failure;
    end case;
    tmp_unsigned := resize(tmp_unsigned * 10, wanted_bitwidth);
    tmp_unsigned := tmp_unsigned + character_value;
  end loop;
  return tmp_unsigned;
end decimal_string_to_unsigned;
