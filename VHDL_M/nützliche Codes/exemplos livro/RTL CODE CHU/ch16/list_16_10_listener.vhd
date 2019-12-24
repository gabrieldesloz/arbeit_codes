--=============================
-- Listing 16.10 4-phase handshaking listener
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity listener_str is
   port(
      clkl: in std_logic;
      resetl: in std_logic;
      req_in: in std_logic;
      ack_out: out std_logic
   );
end listener_str;

architecture str_arch of listener_str is
   signal req_sync: std_logic;
   component listener_fsm
      port (
         clk: in std_logic;
         req_sync: in std_logic;
         reset: in std_logic;
         ack_out: out std_logic
      );
   end component;
   component synchronizer
      port (
         clk: in std_logic;
         in_async: in std_logic;
         reset: in std_logic;
         out_sync: out std_logic
      );
   end component;
begin
   sync_unit: synchronizer
      port map (clk=>clkl, reset=>resetl, in_async=>req_in,
                out_sync=> req_sync);
   fsm_unit: listener_fsm
      port map (clk=>clkl, reset=>resetl, req_sync=>req_sync,
                ack_out => ack_out);
end str_arch;