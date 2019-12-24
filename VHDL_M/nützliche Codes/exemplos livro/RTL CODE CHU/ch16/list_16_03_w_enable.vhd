--=============================
-- Listing 16.3 wide enable pulse regenerator
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity sync_en_pulse is
   port(
      clk, reset: in std_logic;
      en_in: in std_logic;
      en_out: out std_logic
   );
end sync_en_pulse;

architecture slow_en_arch of sync_en_pulse is
   component synchronizer
      port(
         clk, reset: in std_logic;
         in_async: in std_logic;
         out_sync: out std_logic
      );
   end component;
   component rising_edge_detector
      port(
         clk, reset: in std_logic;
         strobe: in std_logic;
         pulse: out std_logic
      );
   end component;
   signal en_strobe: std_logic;
begin
   sync: synchronizer
      port map (clk=>clk, reset=>reset, in_async=>en_in,
                out_sync=>en_strobe);
   edge_detect: rising_edge_detector
      port map (clk=>clk, reset=>reset, strobe=>en_strobe,
                pulse=>en_out);
end slow_en_arch;