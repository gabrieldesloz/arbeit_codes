--=============================
-- Listing 8.13 featured binary counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity binary_counter4_feature is
   port(
      clk, reset: in std_logic;
      syn_clr, en, load: in std_logic;
      d: in std_logic_vector(3 downto 0);
      q: out std_logic_vector(3 downto 0)
   );
end binary_counter4_feature;

architecture two_seg_arch of binary_counter4_feature is
   signal r_reg: unsigned(3 downto 0);
   signal r_next: unsigned(3 downto 0);
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   r_next <= (others=>'0') when syn_clr='1' else
             unsigned(d)   when load='1' else
             r_reg + 1     when en ='1' else
             r_reg;
   -- output logic
   q <= std_logic_vector(r_reg);
end two_seg_arch;

--=============================
-- Listing 8.19
--=============================
architecture one_seg_arch of binary_counter4_feature is
   signal r_reg: unsigned(3 downto 0);
begin
   -- register & next-state logic
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         if syn_clr='1' then
            r_reg <= (others=>'0');
         elsif load='1' then
            r_reg <= unsigned(d);
         elsif en ='1' then
            r_reg <= r_reg + 1;
         end if;
      end if;
   end process;
   -- output logic
   q <= std_logic_vector(r_reg);
end one_seg_arch;
