--=============================
-- parameterized binary counter 
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity para_binary_counter  is
   generic(WIDTH: natural);
   port(
      clk, reset: in std_logic;
      q: out std_logic_vector(WIDTH-1 downto 0)
   );
end para_binary_counter;

architecture arch of para_binary_counter is
   signal r_reg, r_next: unsigned(WIDTH-1 downto 0);
begin
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   r_next <= r_reg + 1;
   q <= std_logic_vector(r_reg);
end arch;


--=============================
-- Listing 13.4 demo of generic binary counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity generic_demo is
   port(
      clk, reset: in std_logic;
      q_4: out std_logic_vector(3 downto 0);
      q_12: out std_logic_vector(11 downto 0)
   );
end generic_demo;

architecture vhdl_87_arch of generic_demo is
   component para_binary_counter
      generic(WIDTH: natural);
      port(
         clk, reset: in std_logic;
         q: out std_logic_vector(WIDTH-1 downto 0)
      );
   end component;
begin
   four_bit: para_binary_counter
      generic map (WIDTH=>4)
      port map (clk=>clk, reset=>reset, q=>q_4);
   twe_bit: para_binary_counter
      generic map (WIDTH=>12)
      port map (clk=>clk, reset=>reset, q=>q_12);
end vhdl_87_arch;