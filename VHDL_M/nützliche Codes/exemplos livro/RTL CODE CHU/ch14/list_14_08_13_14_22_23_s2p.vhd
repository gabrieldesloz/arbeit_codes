--=============================
-- Listing 14.8 seria-to-parallel converter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity s2p_converter is
   generic(WIDTH: natural:=8);
   port(
      clk: in std_logic;
      si: in std_logic;
      q: out std_logic_vector(WIDTH-1 downto 0)
   );
end s2p_converter;

architecture array_arch of s2p_converter is
   signal q_reg, q_next: std_logic_vector(WIDTH-1 downto 0);
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
        q_reg <= q_next;
      end if;
   end process;
   q_next  <= si & q_reg(WIDTH-1 downto 1);
   q <= q_reg;
end array_arch;


--=============================
-- Listing 14.13 use for generate
--=============================
architecture gen_proc_arch of s2p_converter is
   signal q_next: std_logic_vector(WIDTH-1 downto 0);
   signal q_reg: std_logic_vector(WIDTH downto 0);
begin
   q_reg(WIDTH) <= si;
   dff_gen:
   for i in (WIDTH-1) downto 0 generate
      -- D FF
      process(clk)
      begin
         if (clk'event and clk='1') then
           q_reg(i) <= q_next(i);
         end if;
      end process;
      -- next-state logic
      q_next(i) <= q_reg(i+1);
   end generate;
   --output
   q <= q_reg(WIDTH-1 downto 0);
end gen_proc_arch;

--=============================
-- Listing 14.14
--=============================
-- D FF
library ieee;
use ieee.std_logic_1164.all;
entity dff is
   port(
      clk: in std_logic;
      d: in std_logic;
      q: out std_logic
   );
end dff;

architecture arch of dff is
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
        q  <= d;
      end if;
   end process;
end arch;

-- architecture using component instantiation
architecture gen_comp_arch of s2p_converter is
   signal q_reg: std_logic_vector(WIDTH downto 0);
   component dff
      port(
         clk: in std_logic;
         d: in std_logic;
         q: out std_logic
      );
  end component;
begin
   q_reg(WIDTH) <= si;
   dff_gen:
   for i in (WIDTH-1) downto 0 generate
      dff_array: dff
         port map (clk=>clk, d=>q_reg(i+1), q=>q_reg(i));
   end generate;
   q <= q_reg(WIDTH-1 downto 0);
end gen_comp_arch;

--=============================
-- Listing 14.22 use for loop
--=============================
architecture loop1_arch of s2p_converter is
   signal q_next: std_logic_vector(WIDTH-1 downto 0);
   signal q_reg: std_logic_vector(WIDTH downto 0);
begin
   q_reg(WIDTH) <= si;
   process(clk,q_reg)
   begin
      for i in WIDTH-1 downto 0 loop
         -- D FF
         if (clk'event and clk='1') then
            q_reg(i) <= q_next(i);
         end if;
         -- next-state logic
         q_next(i) <= q_reg(i+1);
      end loop;
   end process;
   q <= q_reg(WIDTH-1 downto 0);
end loop1_arch;

--=============================
-- Listing 14.23 use 2 for loop
--=============================
architecture loop2_arch of s2p_converter is
   signal q_reg, q_next: std_logic_vector(WIDTH-1 downto 0);
begin
   -- registers
   process(clk)
   begin
      for i in WIDTH-1 downto 0 loop
         if (clk'event and clk='1') then
            q_reg(i) <= q_next(i);
         end if;
      end loop;
   end process;
   -- next-state logic
   process(si,q_reg)
   begin
     q_next(WIDTH-1) <= si;
     for i in WIDTH-2 downto 0 loop
        q_next(i) <= q_reg(i+1);
     end loop;
   end process;
   q <= q_reg;
end loop2_arch;
