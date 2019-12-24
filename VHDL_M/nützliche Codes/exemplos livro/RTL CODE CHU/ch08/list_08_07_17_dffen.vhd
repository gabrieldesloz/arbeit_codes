--=============================
-- Listing 8.7 D FF w/ emable
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity dff_en is
   port(
      clk: in std_logic;
      reset: in std_logic;
      en: in std_logic;
      d: in std_logic;
      q: out std_logic
   );
end dff_en;

architecture two_seg_arch of dff_en is
   signal q_reg: std_logic;
   signal q_next: std_logic;
begin
   -- D FF
   process(clk,reset)
   begin
      if (reset='1') then
         q_reg <= '0';
      elsif (clk'event and clk='1') then
         q_reg <= q_next;
      end if;
   end process;
   -- next-state logic
   q_next <= d when en ='1' else
             q_reg;
   -- output logic
   q <= q_reg;
end two_seg_arch;

--=============================
-- Listing 8.17
--=============================
architecture one_seg_arch of dff_en is
begin
   process(clk,reset)
   begin
      if (reset='1') then
         q <='0';
      elsif (clk'event and clk='1') then
         if (en='1') then
            q <= d;
         end if;
      end if;
   end process;
end one_seg_arch;
