--=============================
-- Listing 15.27 lfsr next-state logic
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity lfsr_next is
   generic(N: natural);
   port(
      q_in: in std_logic_vector(N-1 downto 0);
      q_out: out std_logic_vector(N-1 downto 0)
   );
end lfsr_next;

architecture para_arch of lfsr_next is
   constant MAX_N: natural:= 8;
   type tap_array_type is
     array(2 to MAX_N) of std_logic_vector(MAX_N-1 downto 0);
   constant TAP_CONST_ARRAY: tap_array_type:=
     (2 => (1|0=>'1', others=>'0'),
      3 => (1|0=>'1', others=>'0'),
      4 => (1|0=>'1', others=>'0'),
      5 => (2|0=>'1', others=>'0'),
      6 => (1|0=>'1', others=>'0'),
      7 => (3|0=>'1', others=>'0'),
      8 => (4|3|2|0=>'1', others=>'0'));
   signal fb: std_logic;
begin
   -- next-state logic
   process(q_in)
      constant TAP_CONST: std_logic_vector(MAX_N-1 downto 0)
         := TAP_CONST_ARRAY(N);
      variable tmp: std_logic;
   begin
      tmp := '0';
      for i in 0 to (N-1) loop
         tmp := tmp xor (q_in(i) and TAP_CONST(i));
      end loop;
      fb <= not(tmp); -- exclude all 1's
   end process;
   q_out <= fb & q_in(N-1 downto 1) ;
end para_arch;