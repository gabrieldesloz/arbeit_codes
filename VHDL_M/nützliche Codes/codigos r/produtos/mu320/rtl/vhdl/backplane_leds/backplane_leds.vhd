-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : backplane_leds.vhdl
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-09-17
-- Last update: 2013-07-12
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-17  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;

entity backplane_leds is
  
  port (
    reset_n                   : in  std_logic;
    sysclk                    : in  std_logic;
    link_eth_0                : in  std_logic;
    link_eth_1                : in  std_logic;
    sync_irig                 : in  std_logic_vector(1 downto 0);
    backplane_leds_out        : out std_logic_vector(5 downto 0);
    watchdog_instrument_alarm : in  std_logic;
    alarm_led                 : in  std_logic
    );

end backplane_leds;





architecture backplane_leds_rtl of backplane_leds is

  signal alarm_int              : std_logic;
  signal in_service_int         : std_logic;
  signal link0_int              : std_logic;
  signal link1_int              : std_logic;
  signal sync_int               : std_logic;
  signal power_int              : std_logic;
  signal backplane_leds_reg_out : std_logic_vector(5 downto 0);
  signal counter_sync_int       : natural range 0 to ONE_SECOND;
  
begin  -- backplane_leds_rtl

  backplane_leds_out     <= backplane_leds_reg_out;
  backplane_leds_reg_out <= power_int & sync_int & link1_int & link0_int & in_service_int & alarm_int;

  power_int      <= '1';
  in_service_int <= (not watchdog_instrument_alarm);
  alarm_int      <= (watchdog_instrument_alarm or alarm_led);
  link0_int      <= link_eth_0 and (not watchdog_instrument_alarm);
  link1_int      <= link_eth_1 and (not watchdog_instrument_alarm);


 

  
  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      sync_int <= '0';
    elsif rising_edge(sysclk) then      -- rising clock edge
      if sync_irig = "10" then
        sync_int <= '1';
      elsif sync_irig = "01" then
        if counter_sync_int = ONE_SECOND then
          counter_sync_int <= 0;
          sync_int         <= not(sync_int);
        else
          counter_sync_int <= counter_sync_int + 1;
        end if;
      elsif sync_irig = "00" then
        sync_int <= '0';
      end if;
    end if;
  end process;
  




end backplane_leds_rtl;
