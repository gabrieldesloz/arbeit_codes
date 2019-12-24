library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity 4_bit_lut is
  
  generic (
    truth_vector : std_logic_vector(0 to 15));

  port (
    a : in  std_logic_vector(3 downto 0);
    b : out std_logic
    );

end entity 4_bit_lut;

architecture ARQ of 4_bit_lut is

begin  -- architecture ARQ

  process(a)
    variable c : natural;
  begin
    c := unsigned(a);
    b <= truth_vector(c);
  end process;

  --exemplo xor4: "0110100110010110"

end architecture ARQ;
