--=============================
-- Listing 8.8 T FF
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity tff is
   port(
      clk: in std_logic;
      reset: in std_logic;
      t: in std_logic;
      q: out std_logic
   );
end tff;

architecture two_seg_arch of tff is
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
   q_next <= q_reg when t='0' else
             not(q_reg);
   -- output logic
   q <= q_reg;
end two_seg_arch;


--=============================
-- Listing 8.18
--=============================
architecture one_seg_arch of tff is
   signal q_reg: std_logic;
begin
   process(clk, reset)
   begin
      if reset='1' then
          q_reg <= '0';
      elsif (clk'event and clk='1') then
         if (t='1') then
            q_reg <= not q_reg;
         end if;
      end if;
   end process;
   q <= q_reg;
end one_seg_arch;