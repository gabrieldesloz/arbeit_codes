
-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


use work.mu320_constants.all;

entity pps_selector is
  port (
    sysclk       : in  std_logic;
    n_reset      : in  std_logic;
    pps_copernic : in  std_logic;
    pps_irig     : in  std_logic;
    sel_gps_irig : in  std_logic;
    sync         : out std_logic;
    pps_wide     : out std_logic
    );
end pps_selector;
------------------------------------------------------------
architecture pps_selector_RTL of pps_selector is
  type STATE_PPS_TYPE is (WAIT_PPS_STATE, WAIT_WINDOW_STATE);
  attribute ENUM_ENCODING                   : string;
  attribute ENUM_ENCODING of STATE_PPS_TYPE : type is "0 1";

  signal state_pps        : STATE_PPS_TYPE;
  signal state_pps_next   : STATE_PPS_TYPE;
  signal pps_int          : std_logic;
  signal sync_int         : std_logic;
  signal pps_copernic_1   : std_logic;
  signal pps_copernic_2   : std_logic;
  signal counter_pps      : natural range 0 to (PPS_WINDOW - 1);
  signal counter_pps_next : natural range 0 to (PPS_WINDOW - 1);
  signal counter_pps_wide : natural range 0 to (ONE_MICRO_SECOND - 1); 
  



begin

  sync <= sync_int;

  -- synchronizes PPS COPERNICUS
  process(sysclk)
  begin
    if rising_edge(sysclk) then
      pps_copernic_1 <= pps_copernic;
      pps_copernic_2 <= pps_copernic_1;
    end if;
  end process;

  pps_int <= pps_copernic_2 when (sel_gps_irig = '1') else pps_irig;
 

  -- checks if there are more than one PPS in one second
  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      state_pps   <= WAIT_PPS_STATE;
      counter_pps <= 0;
    elsif rising_edge(sysclk) then
      state_pps   <= state_pps_next;
      counter_pps <= counter_pps_next;
    end if;
  end process;

  process (state_pps, pps_int, counter_pps)
  begin
    sync_int            <= '0';
    counter_pps_next <= 0;
    case (state_pps) is
      when WAIT_PPS_STATE =>
        state_pps_next <= WAIT_PPS_STATE;
        if (pps_int = '1') then
          sync_int           <= '1';
          state_pps_next <= WAIT_WINDOW_STATE;
        end if;

      when WAIT_WINDOW_STATE =>
        state_pps_next <= WAIT_WINDOW_STATE;
        if (counter_pps = (PPS_WINDOW - 1)) then
          state_pps_next <= WAIT_PPS_STATE;
        else
          counter_pps_next <= counter_pps + 1;
        end if;

      when others =>
        state_pps_next <= WAIT_PPS_STATE;
        
    end case;
  end process;
  
 process(sysclk, n_reset)
 begin
   if (n_reset = '0') then
      pps_wide <= '0';
      counter_pps_wide <= 0;
   elsif rising_edge (sysclk) then
      if (sync_int = '1') then
        pps_wide <= '1';
        counter_pps_wide <= (ONE_MICRO_SECOND - 1);
      elsif (counter_pps_wide > 0) then
          counter_pps_wide <= counter_pps_wide - 1;
          pps_wide <= '1';
      else
          counter_pps_wide <= 0;
          pps_wide <= '0';
      end if;
  end if;
end process;

end pps_selector_RTL;


-- eof $Id: pps_selector.vhd 3646 2007-11-12 20:54:13Z cls $
