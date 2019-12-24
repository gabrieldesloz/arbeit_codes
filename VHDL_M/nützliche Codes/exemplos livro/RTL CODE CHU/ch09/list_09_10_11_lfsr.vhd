--=============================
-- Listing 9.10 LFSR
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity lfsr4 is
   port(
      clk, reset: in std_logic;
      q: out std_logic_vector(3 downto 0)
   );
end lfsr4;

architecture no_zero_arch of lfsr4 is
   signal r_reg, r_next: std_logic_vector(3 downto 0);
   signal fb: std_logic;
   constant SEED: std_logic_vector(3 downto 0):="0001";
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= SEED;
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   fb <= r_reg(1) xor r_reg(0);
   r_next <= fb & r_reg(3 downto 1);
   -- output logic
   q <= r_reg;
end no_zero_arch;

--=============================
-- Listing 9.11
--=============================
architecture with_zero_arch of lfsr4 is
   signal r_reg, r_next: std_logic_vector(3 downto 0);
   signal fb, zero, fzero: std_logic;
   constant seed: std_logic_vector(3 downto 0):="0000";
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= seed;
      elsif (clk'event and clk='1') then
         r_reg <= r_next;
      end if;
   end process;
   -- next-state logic
   fb <= r_reg(1) xor r_reg(0);
   zero <= '1' when r_reg(3 downto 1)="000" else
           '0';
   fzero <= zero xor fb;
   r_next <= fzero & r_reg(3 downto 1);
   -- output logic
   q <= r_reg;
end with_zero_arch;
