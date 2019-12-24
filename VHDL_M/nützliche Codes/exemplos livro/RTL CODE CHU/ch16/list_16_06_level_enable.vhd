--=============================
-- Listing 16.6 level-alternating enable pulse
--=============================
architecture level_arch of sync_en_pulse is
   component synchronizer
      port(
         clk, reset: in std_logic;
         in_async: in std_logic;
         out_sync: out std_logic
      );
   end component;
   component dual_edge_detector
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
   edge_detect: dual_edge_detector
      port map (clk=>clk, reset=>reset, strobe=>en_strobe,
                pulse=>en_out);
end level_arch;
