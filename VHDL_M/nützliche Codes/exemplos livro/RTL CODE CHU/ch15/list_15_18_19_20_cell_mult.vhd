--=============================
-- Listing 15.18 full adder
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity fa is
   port(
      ai, bi, ci: in std_logic;
      so, co: out std_logic
   );
end fa;

architecture arch of fa is
begin
   so <= ai xor bi xor ci;
   co <= (ai and bi) or (ai and ci) or (bi and ci);
end arch;


--=============================
-- Listing 15.19 carry-ripple multiplier
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity mult_array is
   generic(N: natural:=8);
   port(
      a_in, b_in: in std_logic_vector(N-1 downto 0);
      y: out std_logic_vector(2*N-1 downto 0)
   );
end mult_array;

architecture ripple_carry_arch of mult_array is
   type two_d_type is
      array(N-1 downto 0) of std_logic_vector(N downto 0);
   signal ab, c, s: two_d_type;
   component fa
      port(
         ai, bi, ci: in std_logic;
         so, co: out std_logic
      );
   end component;
begin
   -- bit product
   g_ab_row:
   for i in 0 to N-1 generate
      g_ab_col: for j in 0 to (N-1) generate
         ab(i)(j) <= a_in(i) and b_in(j);
      end generate;
   end generate;
   -- leftmost and rightmost columns
   g_0_N_col:
   for i in 1 to (N-1) generate
      c(i)(0) <= '0';
      s(i)(N) <= c(i)(N); -- leftmost column
   end generate;
   -- top row
   s(0) <= ab(0);
   ab(0)(N) <= '0';
   -- middle rows
   g_fa_row:
   for i in 1 to (N-1) generate
      g_fa_col:
      for j in 0 to (N-1) generate
         u_middle: fa
            port map
               (ai=>ab(i)(j), bi=>s(i-1)(j+1), ci=> c(i)(j),
                so=>s(i)(j), co=>c(i)(j+1));
      end generate;
   end generate;
   -- bottom row and output
   g_out:
   for i in 0 to (N-2) generate
      y(i) <= s(i)(0);
   end generate;
   y(2*N-1 downto N-1) <= s(N-1);
end ripple_carry_arch;

--=============================
-- Listing 15.20 carry-save multiplier
--=============================
architecture carry_save_arch of mult_array is
   type two_d_type is
      array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
   signal ab, c, s: two_d_type;
   signal rs, rc: std_logic_vector(N-1 downto 0);
   component fa
      port(
         ai, bi, ci: in std_logic;
         so, co: out std_logic
      );
   end component;
begin
   -- bit product
   g_ab_row:
   for i in 0 to N-1 generate
      g_ab_col: for j in 0 to (N-1) generate
         ab(i)(j) <= a_in(i) and b_in(j);
      end generate;
   end generate;
   -- leftmost column
   g_N_col:
   for i in 1 to (N-1) generate
      s(i)(N-1) <= ab(i)(N-1);
   end generate;
   -- top row
   s(0) <= ab(0);
   c(0) <= (others=>'0');
   -- middle rows
   g_fa_row:
   for i in 1 to (N-1) generate
      g_fa_col: for j in 0 to (N-2) generate
         u_middle: fa
            port map
               (ai=>ab(i)(j), bi=>s(i-1)(j+1), ci=> c(i-1)(j),
                so=>s(i)(j), co=>c(i)(j));
      end generate;
   end generate;
   -- bottom row ripple adder
   rc(0) <= '0';
   g_acell_N_row:
   for j in 0 to (N-2) generate
      unit_N_row: fa
         port map (ai=>s(N-1)(j+1), bi=>c(N-1)(j), ci=> rc(j),
                   so=>rs(j), co=>rc(j+1));
   end generate;
   -- output signal
   g_out:
   for i in 0 to (N-1) generate
      y(i) <= s(i)(0);
   end generate;
   y(2*N-2 downto N) <= rs(N-2 downto 0);
   y(2*N-1) <= rc(N-1);
end carry_save_arch;