--=============================
-- Listing 16.9 4-phase handshaking talker
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity talker_str is
   port(
      clkt: in std_logic;
      resett: in std_logic;
      ack_in: in std_logic;
      start: in std_logic;
      ready: out std_logic;
      req_out: out std_logic
   );
end talker_str;

architecture str_arch of talker_str is
   signal ack_sync: std_logic;
   component synchronizer
      port(
         clk: in std_logic;
         in_async: in std_logic;
         reset: in std_logic;
         out_sync: out std_logic
      );
   end component;
   component talker_fsm
      port(
         ack_sync: in std_logic;
         clk: in std_logic;
         reset: in std_logic;
         start: in std_logic;
         ready: out std_logic;
         req_out: out std_logic
      );
   end component;
begin
   sync_unit: synchronizer
      port map (clk=>clkt, reset=>resett, in_async=>ack_in,
                out_sync=>ack_sync);
   fsm_unit: talker_fsm
      port map (clk=>clkt, reset=>resett, start=>start,
                ack_sync=>ack_sync, ready=>ready,
                req_out=>req_out);
end str_arch;