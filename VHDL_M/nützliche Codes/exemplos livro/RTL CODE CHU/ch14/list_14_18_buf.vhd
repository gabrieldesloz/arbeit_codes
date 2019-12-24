--=============================
-- Listing 14.8 seria-to-parallel converter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity op_buf_counter  is
   generic(
      WIDTH: natural:=4;
      BUFF: natural:=0
   );
   port(
      clk, reset: in std_logic;
      pulse: out std_logic
   );
end op_buf_counter;

architecture arch of op_buf_counter is
   signal r_reg: unsigned(WIDTH-1 downto 0);
   signal r_next: unsigned(WIDTH-1 downto 0);
   signal p_next, p_reg: std_logic;
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
   r_next <= r_reg + 1;
   -- output logic
   p_next <= '1' when r_reg=0 else '0';
   buf_gen:  -- with buffer
   if BUFF=1 generate
      process(clk,reset)
      begin
         if (reset='1') then
            p_reg <= '0';
         elsif (clk'event and clk='1') then
            p_reg <= p_next;
         end if;
      end process;
      pulse <= p_reg;
   end generate;
   no_buf_gen: -- without buffer
   if BUFF/=1 generate
      pulse <= p_next;
   end generate;
end arch;