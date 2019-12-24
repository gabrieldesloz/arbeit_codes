--=============================
-- Listing 15.17 adder based multiplier
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity multn is
   generic(
      N: natural:=4;
      WITH_PIPE: natural:=1
   );
   port(
      clk, reset: std_logic;
      a, b: in std_logic_vector(N-1 downto 0);
      y: out std_logic_vector(2*N-1 downto 0)
   );
end multn;

architecture n_stage_pipe_arch of multn is
   type std_aoa_n_type is
      array(N-2 downto 1) of std_logic_vector(N-1 downto 0);
   type std_aoa_2n_type is
      array(N-1 downto 0) of unsigned(2*N-1 downto 0);
   signal a_reg, a_next, b_reg, b_next: std_aoa_n_type;
   signal bp, pp_reg, pp_next: std_aoa_2n_type;

begin
   -- part 1
   -- without pipeline buffers
   g_wire:
   if (WITH_PIPE/=1) generate
      a_reg <= a_next;
      b_reg <= b_next;
      pp_reg(N-1 downto 1) <= pp_next(N-1 downto 1);
   end generate;
   -- with pipeline buffers
   g_reg:
   if (WITH_PIPE=1) generate
      process(clk,reset)
      begin
         if (reset ='1') then
            a_reg <= (others=>(others=>'0'));
            b_reg <= (others=>(others=>'0'));
            pp_reg(N-1 downto 1) <= (others=>(others=>'0'));
         elsif (clk'event and clk='1') then
            a_reg <= a_next;
            b_reg <= b_next;
            pp_reg(N-1 downto 1) <= pp_next(N-1 downto 1);
         end if;
      end process;
   end generate;
   -- part 2
   -- bit-product generation
   process(a,b,a_reg,b_reg)
   begin
      -- bp(0) and bp(1)
      for i in 0 to 1 loop
         bp(i) <= (others=>'0');
         for j in 0 to N-1 loop
            bp(i)(i+j) <= a(j) and b(i);
         end loop;
      end loop;
      -- regular bp(i)
      for i in 2 to (N-1) loop
         bp(i) <= (others=>'0');
         for j in 0 to (N-1) loop
            bp(i)(i+j) <= a_reg(i-1)(j) and b_reg(i-1)(i);
         end loop;
      end loop;
   end process;
   -- part 3
   -- addition of the first stage
   pp_next(1) <= bp(0) + bp(1);
   a_next(1) <= a;
   b_next(1) <= b;
   -- addition of the middle stages
   g1:
   for  i in 2 to (N-2) generate
      pp_next(i) <= pp_reg(i-1) + bp(i);
      a_next(i) <= a_reg(i-1);
      b_next(i) <= b_reg(i-1);
   end generate;
   -- addition of the last stage
   pp_next(N-1) <= pp_reg(N-2) + bp(N-1);
   -- rename output
   y <= std_logic_vector(pp_reg(N-1));
end n_stage_pipe_arch;