



-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.rl131_constants.all;

entity pps_detector is
  port (
    sysclk   : in  std_logic;
    n_reset  : in  std_logic;
    sync_pps : in  std_logic;
    pps_ok   : out std_logic
    );
end pps_detector;
------------------------------------------------------------
architecture pps_detector_RTL of pps_detector is

-- Type declarations

-- Local (internal to the model) signals declarations.
  
  signal pps_ok_counter_reg  : natural range 0 to (TIMEOUT_PPS - 1);
  signal pps_ok_counter_next : natural range 0 to (TIMEOUT_PPS - 1);
  signal pps_ok_reg          : std_logic;
  signal pps_ok_next         : std_logic;

-- Component declarations

begin
-- concurrent signal assignment statements

  pps_ok <= pps_ok_reg;


  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      pps_ok_counter_reg <= 0;
      pps_ok_reg         <= '0';
    elsif rising_edge (sysclk) then
      pps_ok_counter_reg <= pps_ok_counter_next;
      pps_ok_reg         <= pps_ok_next;
    end if;
  end process;


  process (pps_ok_counter_reg, pps_ok_reg, sync_pps) is
  begin
    pps_ok_counter_next <= pps_ok_counter_reg;
    pps_ok_next         <= pps_ok_reg;
    if (sync_pps = '1') then
      pps_ok_counter_next <= 0;
      pps_ok_next         <= '1';
    elsif (pps_ok_counter_reg < (TIMEOUT_PPS - 1)) then
      pps_ok_counter_next <= pps_ok_counter_reg + 1;
    else
      pps_ok_counter_next <= (TIMEOUT_PPS - 1);
      pps_ok_next         <= '0';
    end if;
    
  end process;


end pps_detector_RTL;

-- eof $Id: pps_detector.vhd 4687 2009-07-29 12:27:03Z cls $




