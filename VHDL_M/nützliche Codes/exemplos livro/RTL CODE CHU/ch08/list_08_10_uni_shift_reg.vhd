--=============================
-- Listing 8.10 universal shift register
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity shift_register is
   port(
      clk, reset: in std_logic;
      ctrl: in std_logic_vector(1 downto 0);
      d: in std_logic_vector(3 downto 0);
      q: out std_logic_vector(3 downto 0)
   );
end shift_register;

architecture two_seg_arch of shift_register is
   signal r_reg: std_logic_vector(3 downto 0);
   signal r_next: std_logic_vector(3 downto 0);
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
   with ctrl select
      r_next <=
         r_reg                    when "00", --no op
         r_reg(2 downto 0) & d(0) when "01", --shift left;
         d(3) & r_reg(3 downto 1) when "10", --shift right;
         d                        when others;
   -- output
   q <= r_reg;
end two_seg_arch;
