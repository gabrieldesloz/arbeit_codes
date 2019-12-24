--=============================
-- Listing 14.10 ring counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity para_ring_counter is
   generic(WIDTH: natural:=8);
   port(
      clk, reset: in std_logic;
      q: out std_logic_vector(WIDTH-1 downto 0)
   );
end para_ring_counter;

-- architecture using asynchronous initialization
architecture reset_arch of para_ring_counter is
   signal r_reg: std_logic_vector(WIDTH-1  downto 0);
   signal r_next: std_logic_vector(WIDTH-1  downto 0);
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (0=>'1',others=>'0');
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   r_next <=r_reg(0) & r_reg(WIDTH-1 downto 1);
   -- output logic
   q <= r_reg;
end reset_arch;

-- architecture using self-correcting circuit
architecture self_correct_arch of para_ring_counter is
   signal r_reg: std_logic_vector(WIDTH-1  downto 0);
   signal r_next: std_logic_vector(WIDTH-1  downto 0);
   signal s_in: std_logic;
   alias r_high: std_logic_vector(WIDTH-2  downto 0) is
                 r_reg(WIDTH-1 downto 1)  ;
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
   s_in <= '1' when r_high=(r_high'range=>'0') else
           '0';
   r_next <= s_in & r_reg(WIDTH-1 downto 1);
   -- output logic
   q <= r_reg;
end self_correct_arch;