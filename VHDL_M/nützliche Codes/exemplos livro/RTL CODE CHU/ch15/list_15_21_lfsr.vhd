--=============================
-- Listing 15.21 LFSR
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity lfsr is
   generic(
      N: natural:=4;
      WITH_ZERO: natural:=1
   );
   port(
      clk, reset: in std_logic;
      q: out std_logic_vector(N-1 downto 0)
   );
end lfsr;

architecture para_arch of lfsr is
   constant MAX_N: natural:= 8;
   constant SEED: std_logic_vector(N-1 downto 0)
                  :=(0=>'1', others=>'0');
   type tap_array_type is array(2 to MAX_N) of
      std_logic_vector(MAX_N-1 downto 0);
   constant TAP_CONST_ARRAY: tap_array_type:=
      (2 => (1|0=>'1', others=>'0'),
       3 => (1|0=>'1', others=>'0'),
       4 => (1|0=>'1', others=>'0'),
       5 => (2|0=>'1', others=>'0'),
       6 => (1|0=>'1', others=>'0'),
       7 => (3|0=>'1', others=>'0'),
       8 => (4|3|2|0=>'1', others=>'0'));
   signal r_reg, r_next: std_logic_vector(N-1 downto 0);
   signal fb, zero, fzero: std_logic;
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= SEED;
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   process(r_reg)
      constant TAP_CONST: std_logic_vector(MAX_N-1 downto 0)
          := TAP_CONST_ARRAY(N);
      variable tmp: std_logic;
   begin
      tmp := '0';
      for i in 0 to (N-1) loop
         tmp := tmp xor (r_reg(i) and TAP_CONST(i));
      end loop;
      fb <= tmp;
   end process;
   -- with all-zero state
   gen_zero:
   if (WITH_ZERO=1) generate
      zero <= '1' when r_reg(N-1 downto 1)=
                       (r_reg(N-1 downto 1)'range=>'0')
                  else
              '0';
      fzero <= zero xor fb;
   end generate;
   -- without all-zero state
   gen_no_zero:
   if (WITH_ZERO/=1) generate
      fzero <= fb;
   end generate;
   r_next <= fzero & r_reg(N-1 downto 1) ;
   -- output logic
   q <= r_reg;
end para_arch;