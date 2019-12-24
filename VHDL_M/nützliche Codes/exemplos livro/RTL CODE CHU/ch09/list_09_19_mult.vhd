--=============================
-- Listing 9.19 multiplier
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mult5 is
   port(
      clk, reset: in std_logic;
      a, b: in std_logic_vector(4 downto 0);
      y: out std_logic_vector(9 downto 0)
   );
end mult5;

architecture comb_arch of mult5 is
   constant WIDTH: integer:=5;
   signal a0, a1, a2, a3: std_logic_vector(WIDTH-1 downto 0);
   signal b0, b1, b2, b3: std_logic_vector(WIDTH-1 downto 0);
   signal bv0, bv1, bv2, bv3, bv4:
      std_logic_vector(WIDTH-1 downto 0);
   signal bp0, bp1, bp2, bp3, bp4:
      unsigned(2*WIDTH-1 downto 0);
   signal pp0, pp1, pp2, pp3, pp4:
      unsigned(2*WIDTH-1 downto 0);
begin
   -- stage 0
   bv0 <= (others=>b(0));
   bp0 <=unsigned("00000" & (bv0 and a));
   pp0 <= bp0;
   a0 <= a;
   b0 <= b;
   -- stage 1
   bv1 <= (others=>b0(1));
   bp1 <=unsigned("0000" & (bv1 and a0) & "0");
   pp1 <= pp0 + bp1;
   a1 <= a0;
   b1 <= b0;
   -- stage 2
   bv2 <= (others=>b1(2));
   bp2 <=unsigned("000" & (bv2 and a1) & "00");
   pp2 <= pp1 + bp2;
   a2 <= a1;
   b2 <= b1;
   -- stage 3
   bv3 <= (others=>b2(3));
   bp3 <=unsigned("00" & (bv3 and a2) & "000");
   pp3 <= pp2 + bp3;
   a3 <= a2;
   b3 <= b2;
   -- stage 4
   bv4 <= (others=>b3(4));
   bp4 <=unsigned("0" & (bv4 and a3) & "0000");
   pp4 <= pp3 + bp4;
   -- output
   y <= std_logic_vector(pp4);
end comb_arch;


--=============================
-- Listing 9.20
--=============================
architecture four_stage_pipe_arch of mult5 is
   constant WIDTH: integer:=5;
   signal a1_reg, a2_reg, a3_reg:
      std_logic_vector(WIDTH-1 downto 0);
   signal a0, a1_next, a2_next, a3_next:
      std_logic_vector(WIDTH-1 downto 0);
   signal b1_reg, b2_reg, b3_reg:
      std_logic_vector(WIDTH-1 downto 0);
   signal b0, b1_next, b2_next, b3_next:
      std_logic_vector(WIDTH-1 downto 0);
   signal bv0, bv1, bv2, bv3, bv4:
      std_logic_vector(WIDTH-1 downto 0);
   signal bp0, bp1, bp2, bp3, bp4:
      unsigned(2*WIDTH-1 downto 0);
   signal pp1_reg, pp2_reg, pp3_reg, pp4_reg:
      unsigned(2*WIDTH-1 downto 0);
   signal pp0, pp1_next, pp2_next, pp3_next, pp4_next:
      unsigned(2*WIDTH-1 downto 0);
begin
   -- pipeline registers (buffers)
   process(clk,reset)
   begin
      if (reset ='1') then
         pp1_reg <= (others=>'0');
         pp2_reg <= (others=>'0');
         pp3_reg <= (others=>'0');
         pp4_reg <= (others=>'0');
         a1_reg <= (others=>'0');
         a2_reg <= (others=>'0');
         a3_reg <= (others=>'0');
         b1_reg <= (others=>'0');
         b2_reg <= (others=>'0');
         b3_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         pp1_reg <= pp1_next;
         pp2_reg <= pp2_next;
         pp3_reg <= pp3_next;
         pp4_reg <= pp4_next;
         a1_reg <= a1_next;
         a2_reg <= a2_next;
         a3_reg <= a3_next;
         b1_reg <= b1_next;
         b2_reg <= b2_next;
         b3_reg <= b3_next;
      end if;
   end process;

   -- merged stage 0 & 1 for pipeline
   bv0 <= (others=>b(0));
   bp0 <=unsigned("00000" & (bv0 and a));
   pp0 <= bp0;
   a0 <= a;
   b0 <= b;
   --
   bv1 <= (others=>b0(1));
   bp1 <=unsigned("0000" & (bv1 and a0) & "0");
   pp1_next <= pp0 + bp1;
   a1_next <= a0;
   b1_next <= b0;
   -- stage 2
   bv2 <= (others=>b1_reg(2));
   bp2 <=unsigned("000" & (bv2 and a1_reg) & "00");
   pp2_next <= pp1_reg + bp2;
   a2_next <= a1_reg;
   b2_next <= b1_reg;
   -- stage 3
   bv3 <= (others=>b2_reg(3));
   bp3 <=unsigned("00" & (bv3 and a2_reg) & "000");
   pp3_next <= pp2_reg + bp3;
   a3_next <= a2_reg;
   b3_next <= b2_reg;
   -- stage 4
   bv4 <= (others=>b3_reg(4));
   bp4 <=unsigned("0" & (bv4 and a3_reg) & "0000");
   pp4_next <= pp3_reg + bp4;
   -- output
   y <= std_logic_vector(pp4_reg);
end four_stage_pipe_arch;


--=============================
-- Listing 9.21
--=============================
architecture two_stage_pipe_arch of mult5 is
   constant WIDTH: integer:=5;
   signal a2_reg: std_logic_vector(WIDTH-1 downto 0);
   signal a0, a1, a2_next, a3:
      std_logic_vector(WIDTH-1 downto 0);
   signal b2_reg: std_logic_vector(WIDTH-1 downto 0);
   signal b0, b1, b2_next, b3:
      std_logic_vector(WIDTH-1 downto 0);
   signal bv0, bv1, bv2, bv3, bv4:
      std_logic_vector(WIDTH-1 downto 0);
   signal bp0, bp1, bp2, bp3, bp4:
      unsigned(2*WIDTH-1 downto 0);
   signal pp2_reg, pp4_reg: unsigned(2*WIDTH-1 downto 0);
   signal pp0, pp1, pp2_next, pp3, pp4_next:
      unsigned(2*WIDTH-1 downto 0);
begin
   -- pipeline registers (buffers)
   process(clk,reset)
   begin
      if (reset ='1') then
         pp2_reg <= (others=>'0');
         pp4_reg <= (others=>'0');
         a2_reg <= (others=>'0');
         b2_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         pp2_reg <= pp2_next;
         pp4_reg <= pp4_next;
         a2_reg <= a2_next;
         b2_reg <= b2_next;
      end if;
   end process;

   -- stage 0
   bv0 <= (others=>b(0));
   bp0 <=unsigned("00000" & (bv0 and a));
   pp0 <= bp0;
   a0 <= a;
   b0 <= b;
   -- stage 1
   bv1 <= (others=>b0(1));
   bp1 <=unsigned("0000" & (bv1 and a0) & "0");
   pp1 <= pp0 + bp1;
   a1 <= a0;
   b1 <= b0;
   -- stage 2 (with buffer)
   bv2 <= (others=>b1(2));
   bp2 <=unsigned("000" & (bv2 and a1) & "00");
   pp2_next <= pp1 + bp2;
   a2_next <= a1;
   b2_next <= b1;
   -- stage 3
   bv3 <= (others=>b2_reg(3));
   bp3 <=unsigned("00" & (bv3 and a2_reg) & "000");
   pp3 <= pp2_reg + bp3;
   a3 <= a2_reg;
   b3 <= b2_reg;
   -- stage 4 (with buffer)
   bv4 <= (others=>b3(4));
   bp4 <=unsigned("0" & (bv4 and a3) & "0000");
   pp4_next <= pp3 + bp4;
   -- output
   y <= std_logic_vector(pp4_reg);
end two_stage_pipe_arch;


--=============================
-- Listing 9.22
--=============================
architecture effi_4_stage_pipe_arch of mult5 is
   signal a1_reg, a2_reg, a3_reg:
      std_logic_vector(4 downto 0);
   signal a0, a1_next, a2_next, a3_next:
      std_logic_vector(4 downto 0);
   signal b0: std_logic_vector(4 downto 1);
   signal b1_next, b1_reg: std_logic_vector(4 downto 2);
   signal b2_next, b2_reg: std_logic_vector(4 downto 3);
   signal b3_next, b3_reg: std_logic_vector(4 downto 4);
   signal bv0, bv1, bv2, bv3, bv4:
      std_logic_vector(4 downto 0);
   signal bp0, bp1, bp2, bp3, bp4: unsigned(5 downto 0);
   signal pp0: unsigned(5 downto 0);
   signal pp1_next, pp1_reg: unsigned(6 downto 0);
   signal pp2_next, pp2_reg: unsigned(7 downto 0);
   signal pp3_next, pp3_reg: unsigned(8 downto 0);
   signal pp4_next, pp4_reg: unsigned(9 downto 0);
begin
   -- pipeline registers (buffers)
   process(clk,reset)
   begin
      if (reset ='1') then
         pp1_reg <= (others=>'0');
         pp2_reg <= (others=>'0');
         pp3_reg <= (others=>'0');
         pp4_reg <= (others=>'0');
         a1_reg <= (others=>'0');
         a2_reg <= (others=>'0');
         a3_reg <= (others=>'0');
         b1_reg <= (others=>'0');
         b2_reg <= (others=>'0');
         b3_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         pp1_reg <= pp1_next;
         pp2_reg <= pp2_next;
         pp3_reg <= pp3_next;
         pp4_reg <= pp4_next;
         a1_reg <= a1_next;
         a2_reg <= a2_next;
         a3_reg <= a3_next;
         b1_reg <= b1_next;
         b2_reg <= b2_next;
         b3_reg <= b3_next;
      end if;
   end process;

   -- merged stage 0 & 1 for pipeline
   bv0 <= (others=>b(0));
   bp0 <=unsigned('0' & (bv0 and a));
   pp0 <= bp0;
   a0 <= a;
   b0 <= b(4 downto 1);
   --
   bv1 <= (others=>b0(1));
   bp1 <=unsigned('0' & (bv1 and a0));
   pp1_next(6 downto 1) <= ('0' & pp0(5 downto 1)) + bp1;
   pp1_next(0) <= pp0(0);
   a1_next <= a0;
   b1_next <= b0(4 downto 2);
   -- stage 2
   bv2 <= (others=>b1_reg(2));
   bp2 <=unsigned('0' & (bv2 and a1_reg));
   pp2_next(7 downto 2) <= ('0' & pp1_reg(6 downto 2)) + bp2;
   pp2_next(1 downto 0) <= pp1_reg(1 downto 0);
   a2_next <= a1_reg;
   b2_next <= b1_reg(4 downto 3);
   -- stage 3
   bv3 <= (others=>b2_reg(3));
   bp3 <=unsigned('0' & (bv3 and a2_reg));
   pp3_next(8 downto 3) <= ('0' & pp2_reg(7 downto 3)) + bp3;
   pp3_next(2 downto 0) <= pp2_reg(2 downto 0);
   a3_next <= a2_reg;
   b3_next(4) <= b2_reg(4);
   -- stage 4
   bv4 <= (others=>b3_reg(4));
   bp4 <=unsigned('0' & (bv4 and a3_reg));
   pp4_next(9 downto 4) <= ('0' & pp3_reg(8 downto 4)) + bp4;
   pp4_next(3 downto 0) <= pp3_reg(3 downto 0);
   -- output
   y <= std_logic_vector(pp4_reg);
end effi_4_stage_pipe_arch;

--=============================
-- Listing 9.23
--=============================
architecture tree_pipe_arch of mult5 is
   constant WIDTH: integer:=5;
   signal bv0, bv1, bv2, bv3, bv4:
      std_logic_vector(WIDTH-1 downto 0);
   signal bp0, bp1, bp2, bp3, bp4:
      unsigned(2*WIDTH-1 downto 0);
   signal bp4_s1_reg, bp4_s2_reg:
      unsigned(2*WIDTH-1 downto 0);
   signal bp4_s1_next, bp4_s2_next:
      unsigned(2*WIDTH-1 downto 0);
   signal pp01_reg, pp23_reg, pp0123_reg, pp01234_reg:
      unsigned(2*WIDTH-1 downto 0);
   signal pp01_next, pp23_next, pp0123_next, pp01234_next:
      unsigned(2*WIDTH-1 downto 0);
begin
   -- pipeline registers (buffers)
   process(clk,reset)
   begin
      if (reset ='1') then
         pp01_reg <= (others=>'0');
         pp23_reg <= (others=>'0');
         pp0123_reg <= (others=>'0');
         pp01234_reg <= (others=>'0');
         bp4_s1_reg <= (others=>'0');
         bp4_s2_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         pp01_reg <= pp01_next;
         pp23_reg <= pp23_next;
         pp0123_reg <= pp0123_next;
         pp01234_reg <= pp01234_next;
         bp4_s1_reg <= bp4_s1_next;
         bp4_s2_reg <= bp4_s2_next;
      end if;
   end process;

   -- stage 1
   -- bit product
   bv0 <= (others=>b(0));
   bp0 <=unsigned("00000" & (bv0 and a));
   bv1 <= (others=>b(1));
   bp1 <=unsigned("0000" & (bv1 and a) & "0");
   bv2 <= (others=>b(2));
   bp2 <=unsigned("000" & (bv2 and a) & "00");
   bv3 <= (others=>b(3));
   bp3 <=unsigned("00" & (bv3 and a) & "000");
   bv4 <= (others=>b(4));
   bp4 <=unsigned("0" & (bv4 and a) & "0000");
   -- adder
   pp01_next <= bp0 + bp1;
   pp23_next <= bp2 + bp3;
   bp4_s1_next <= bp4;
   -- stage 2
   pp0123_next <= pp01_reg + pp23_reg;
   bp4_s2_next <= bp4_s1_reg;
   -- stage 3
   pp01234_next <= pp0123_reg + bp4_s2_reg;
   -- output
   y <= std_logic_vector(pp01234_reg);
end tree_pipe_arch;