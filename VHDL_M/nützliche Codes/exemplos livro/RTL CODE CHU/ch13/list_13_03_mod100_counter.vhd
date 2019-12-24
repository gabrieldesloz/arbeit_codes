--=============================
-- Listing 13.3 2-digit free-running bcd counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity free_run_hundred_counter is
   port(
      clk, reset: in std_logic;
      q_ten, q_one: out std_logic_vector(3 downto 0)
   );
end free_run_hundred_counter;

architecture vhdl_87_arch of free_run_hundred_counter is
   component dec_counter
      port(
         clk, reset: in std_logic;
         en: in std_logic;
         q: out std_logic_vector(3 downto 0);
         pulse: out std_logic
      );
   end component;
   signal p_one: std_logic;
begin
   one_digit: dec_counter
      port map (clk=>clk, reset=>reset, en=>'1',
                pulse=>p_one, q=>q_one);
   ten_digit: dec_counter
      port map (clk=>clk, reset=>reset, en=>p_one,
                pulse=>open, q=>q_ten);
end vhdl_87_arch;
