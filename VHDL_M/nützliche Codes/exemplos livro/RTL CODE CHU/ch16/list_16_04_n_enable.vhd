--=============================
-- Listing 16.4 narrow enable pulse regenerator
--=============================
architecture fast_en_arch of sync_en_pulse is
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
   signal en_q: std_logic;
begin
   -- ad hoc stretcher
   process(en_in,en_strobe)
   begin
      if (en_strobe='1') then
         en_q <= '0';
      elsif (en_in'event and en_in='1') then
         en_q <= '1';
      end if;
   end process;
   -- slow enable pulse regenerator
   sync: synchronizer
      port map (clk=>clk, reset=>reset, in_async=>en_q,
                out_sync=>en_strobe);
   edge_detect: rising_edge_detector
      port map (clk=>clk, reset=>reset, strobe=>en_strobe,
                pulse=>en_out);
end fast_en_arch;