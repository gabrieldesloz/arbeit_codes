-- Listing 6.7
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity debounce_test is
   port(
      clk: in std_logic;
      sw: in std_logic_vector(0 downto 0);
      key: in std_logic_vector(0 downto 0);
      hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0)
   );
end debounce_test;

architecture arch of debounce_test is
   signal q1_reg, q1_next: unsigned(7 downto 0);
   signal q0_reg, q0_next: unsigned(7 downto 0);
   signal b_count, d_count: std_logic_vector(7 downto 0);
   signal sw_reg, db_reg: std_logic;
   signal db_level, db_tick, btn_tick, clr: std_logic;
begin
   --=================================================
   -- component instantiation
   --=================================================
   -- instantiate debouncing circuit
   db_unit: entity work.db_fsm(arch)
      port map(
         clk=>clk, reset=>'0',
         sw=>sw(0), db=>db_level);

   -- instantiate four instances of 7-seg LED decoders
   sseg_unit_0: entity work.bin_to_sseg
      port map(bin=>d_count(3 downto 0), sseg=>hex0);
   sseg_unit_1: entity work.bin_to_sseg
      port map(bin=>d_count(7 downto 4), sseg=>hex1);
   sseg_unit_2: entity work.bin_to_sseg
      port map(bin=>b_count(3 downto 0), sseg=>hex2);
   sseg_unit_3: entity work.bin_to_sseg
      port map(bin=>b_count(7 downto 4), sseg=>hex3);       
   --=================================================
   -- edge detection circuits
   --=================================================
   process(clk)
   begin
      if (clk'event and clk='1') then
         sw_reg <= sw(0);
         db_reg <= db_level;
      end if;
   end process;
   btn_tick <= (not sw_reg) and sw(0);
   db_tick <= (not db_reg) and db_level;
   --=================================================
   -- two counters
   --=================================================
   clr <= not key(0);
   process(clk)
   begin
      if (clk'event and clk='1') then
         q1_reg <= q1_next;
         q0_reg <= q0_next;
      end if;
   end process;
   -- next-state logic for the counter
   q1_next <= (others=>'0') when clr='1' else
              q1_reg + 1 when btn_tick='1' else
              q1_reg;
   q0_next <= (others=>'0') when clr='1' else
              q0_reg + 1 when db_tick='1' else
              q0_reg;
   --output
   b_count <= std_logic_vector(q1_reg);
   d_count <= std_logic_vector(q0_reg);
end arch;
