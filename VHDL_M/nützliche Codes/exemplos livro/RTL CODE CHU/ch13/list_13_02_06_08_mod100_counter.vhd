--=============================
-- Listing 13.2 2-digit bcd counter
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity hundred_counter is
   port(
      clk, reset: in std_logic;
      en: in std_logic;
      q_ten, q_one: out std_logic_vector(3 downto 0);
      p100: out std_logic
   );
end hundred_counter;

architecture vhdl_87_arch of hundred_counter is
   component dec_counter
      port(
         clk, reset: in std_logic;
         en: in std_logic;
         q: out std_logic_vector(3 downto 0);
         pulse: out std_logic
      );
   end component;
   signal p_one, p_ten: std_logic;
begin
   one_digit: dec_counter
      port map (clk=>clk, reset=>reset, en=>en,
                pulse=>p_one, q=>q_one);
   ten_digit: dec_counter
      port map (clk=>clk, reset=>reset, en=>p_one,
                pulse=>p_ten, q=>q_ten);
   p100 <= p_one and p_ten;
end vhdl_87_arch;


--=============================
-- Listing 13.6 with paramterized mod-N counter
--=============================
architecture generic_arch of hundred_counter is
   component mod_n_counter
      generic(
         N: natural;
         WIDTH: natural
       );
       port(
          clk, reset: in std_logic;
          en: in std_logic;
          q: out std_logic_vector(WIDTH-1 downto 0);
          pulse: out std_logic
       );
   end component;
   signal p_one, p_ten: std_logic;
begin
   one_digit: mod_n_counter
      generic map (N=>10, WIDTH=>4)
      port map (clk=>clk, reset=>reset, en=>en,
                pulse=>p_one, q=>q_one);
   ten_digit: mod_n_counter
      generic map (N=>10, WIDTH=>4)
      port map (clk=>clk, reset=>reset, en=>p_one,
                pulse=>p_ten, q=>q_ten);
   p100 <= p_one and p_ten;
end generic_arch;


--=============================
-- Listing 13.9 direct binding
--=============================
architecture vhdl_93_arch of hundred_counter is
   signal p_one, p_ten: std_logic;
begin
   one_digit: entity work.dec_counter(up_arch)
      port map (clk=>clk, reset=>reset, en=>en,
                pulse=>p_one, q=>q_one);
   ten_digit: entity work.dec_counter(up_arch)
      port map (clk=>clk, reset=>reset, en=>p_one,
                pulse=>p_ten, q=>q_ten);
   p100 <= p_one and p_ten;
end vhdl_93_arch;
