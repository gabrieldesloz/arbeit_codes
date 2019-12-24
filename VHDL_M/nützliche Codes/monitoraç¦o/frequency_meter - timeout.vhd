-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module  
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : frequency_meter.vhd
-- Author     : Celso Souza 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2012-10-09
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A vhdl module for an ADPLL (All Digital Phase Locked Loop)
-- A frequency meter module based on the periodicity of the PPS start/stop
-- signal - one pulse per second
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01      1.0      CLS     Created
-- 2012-09-03   2.0      GDL     Revised and Optimized  
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.sync_constants.all;


entity frequency_meter is

-- Definition of incoming and outgoing signals.  
  port (
    sysclk     : in  std_logic;
    n_reset    : in  std_logic;
    start_stop : in  std_logic;
    m_freq     : out std_logic_vector(D-1 downto 0);
    time_out   : out std_logic
    );
end frequency_meter;
------------------------------------------------------------------------------

architecture frequency_meter_RTL of frequency_meter is

-- Local (internal to the model) signals declarations.
  
  type STATE_TYPE is (TIME_OUT_LOW, TIME_OUT_HIGH);
  attribute ENUM_ENCODING                     : string;
  attribute ENUM_ENCODING of STATE_TYPE       : type is "00 01";
  signal state_next, state_reg                : STATE_TYPE;
  signal counter, counter_next, m_reg, m_next : std_logic_vector((D-1) downto 0);
  signal timeout_reg, timeout_next            : std_logic;

begin

  m_freq <= m_reg;

  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg   <= TIME_OUT_LOW;
      timeout_reg <= '0';
      m_reg       <= CLK_FREQUENCY_STD;
      counter     <= (others => '0');
    elsif rising_edge (sysclk) then
      state_reg   <= state_next;
      timeout_reg <= timeout_next;
      counter     <= counter_next;
      m_reg       <= m_next;
    end if;
  end process;


  process (counter, m_reg, start_stop)
  begin
    m_next       <= m_reg;
    counter_next <= counter + 1;
    if (start_stop = '1') then
      counter_next <= (others => '0');
      if (counter > PERIOD_FREQ_MIN) and (counter < PERIOD_FREQ_MAX) then
        m_next <= counter + 1;
      end if;
    end if;
  end process;

  time_out <= timeout_reg;

  process(counter, start_stop, state_reg, timeout_reg)
  begin
    state_next   <= state_reg;
    timeout_next <= timeout_reg;
    case state_reg is
      when TIME_OUT_LOW =>
        timeout_next <= '0';
        if counter > PERIOD_FREQ_MAX then
          state_next <= TIME_OUT_HIGH;
        end if;
      when TIME_OUT_HIGH =>
        timeout_next <= '1';
        if start_stop = '1' then
          state_next <= TIME_OUT_LOW;
        end if;
      when others =>
        state_next <= TIME_OUT_LOW;
    end case;
  end process;
  

  
end frequency_meter_RTL;

-- eof $id:$

