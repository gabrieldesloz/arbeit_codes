--=============================
-- Listing 15.23 priority encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity prio_encoder is
  generic(N: natural:=8);
  port(
     a: in std_logic_vector(N-1 downto 0);
     bcode: out std_logic_vector(log2c(N)-1 downto 0)
  );
end prio_encoder;

architecture para_arch of prio_encoder is
   component reduced_and_vector is
      generic(N: natural);
      port(
         a: in std_logic_vector(N-1 downto 0);
         y: out std_logic_vector(N-1 downto 0)
      );
   end component;
   component bin_encoder is
      generic(N: natural);
      port(
         a: in std_logic_vector(N-1 downto 0);
         bcode: out std_logic_vector(log2c(N)-1 downto 0)
      );
   end component;
   signal a_not_rev: std_logic_vector(N-1 downto 0);
   signal a_vec, a_vec_rev, t: std_logic_vector(N-1 downto 0);
begin
   -- reverse a
   gen_reverse_a:
   for i in 0 to (N-1) generate
      a_not_rev(i) <= not a(N-1-i);
   end generate;
   -- reduced and operation
   unit_token: reduced_and_vector
      generic map(N=>N)
      port map(a=>a_not_rev, y =>a_vec_rev);
   -- reverse the result
   gen_reverse_t:
   for i in 0 to (N-1) generate
      a_vec(i) <= a_vec_rev(N-1-i);
   end generate;
   -- form one-hot code
   t <= a and ('1' & a_vec(N-1 downto 1));
   -- regular binary encoder
   unit_bin_code: bin_encoder
      generic map(N=>N)
      port map(a=>t, bcode=>bcode);
end para_arch;