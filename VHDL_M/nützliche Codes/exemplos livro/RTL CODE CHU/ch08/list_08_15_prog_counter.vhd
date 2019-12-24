--=============================
-- Listing 8.15 programmable mod-m counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prog_counter is
   port(
      clk, reset: in std_logic;
      m: in std_logic_vector(3 downto 0);
      q: out std_logic_vector(3 downto 0)
   );
end prog_counter;

architecture two_seg_clear_arch of prog_counter is
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
   r_next <= (others=>'0') when r_reg=(unsigned(m)-1) else
             r_reg + 1;
   -- output logic
   q <= std_logic_vector(r_reg);
end two_seg_clear_arch;


--=============================
-- Listing 8.16
--=============================
architecture two_seg_effi_arch of prog_counter is
   signal r_reg: unsigned(3 downto 0);
   signal r_next, r_inc: unsigned(3 downto 0);
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
   r_inc <= r_reg + 1;
   r_next <= (others=>'0') when r_inc=unsigned(m) else
             r_inc;
   -- output logic
   q <= std_logic_vector(r_reg);
end two_seg_effi_arch;


--=============================
-- Listing 8.22
--=============================
architecture not_work_one_arch of prog_counter is
   signal r_reg: unsigned(3 downto 0);
begin
   process(clk,reset)
   begin
      if reset='1' then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         r_reg <= r_reg+1;
         if (r_reg=unsigned(m)) then
            r_reg<= (others=>'0');
         end if;
      end if;
   end process;
   q <= std_logic_vector(r_reg);
end not_work_one_arch;


--=============================
-- Listing 8.23
--=============================
architecture work_one_arch of prog_counter is
   signal r_reg: unsigned(3 downto 0);
   signal r_inc: unsigned(3 downto 0);
begin
   process(clk,reset)
   begin
      if reset='1' then
         r_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         if (r_inc=unsigned(m)) then
            r_reg <= (others=>'0');
         else
            r_reg <= r_inc;
         end if;
      end if;
   end process;
   r_inc <= r_reg + 1;
   q <= std_logic_vector(r_reg);
end work_one_arch;