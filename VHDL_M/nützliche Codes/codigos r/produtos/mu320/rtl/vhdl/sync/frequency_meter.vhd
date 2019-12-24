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
-- Last update: 2013-06-11
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
use ieee.numeric_std.all;


entity frequency_meter is

  generic (
    D                : natural;
    PERIOD_FREQ_MIN  : natural;
    PERIOD_FREQ_MAX  : natural;
    TIMEOUT_PPS      : natural;
    FM_MAX_DEVIATION : natural;
    FREQ_TOLERANCE   : natural

    );
  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    m_freq            : out std_logic_vector(D-1 downto 0);
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    start_stop        : in  std_logic;
    time_out          : out std_logic
    );
end frequency_meter;
------------------------------------------------------------------------------

architecture frequency_meter_RTL of frequency_meter is

-- Local (internal to the model) signals declarations.

  type STATE_TYPE is (SYS_START, SYS_START_WAIT_PPS, FILTER_PPS);
  type STATE_TYPE_TIMEOUT is (TIME_OUT_LOW, TIME_OUT_HIGH);


  attribute SYN_ENCODING                       : string;
  attribute SYN_ENCODING of STATE_TYPE         : type is "safe";
  attribute SYN_ENCODING of STATE_TYPE_TIMEOUT : type is "safe";


  signal state_next, state_reg                    : STATE_TYPE;
  signal timeout_st_next, timeout_st_reg          : STATE_TYPE_TIMEOUT;
  signal counter_reg, counter_next, m_reg, m_next : unsigned((D-1) downto 0);
  signal timeout_reg, timeout_next                : std_logic;
  signal m_freq_low_next, m_freq_high_next        : unsigned(m_freq'range);
  signal m_freq_low_reg, m_freq_high_reg          : unsigned(m_freq'range);
  signal clear                                    : std_logic;
  signal count_recovery_reg, count_recovery_next  : natural range 0 to 5;

begin

  m_freq   <= std_logic_vector(m_reg);
  time_out <= timeout_reg;

  process (CLK_FREQUENCY_STD, n_reset, sysclk)
  begin
    if (n_reset = '0') then
      m_freq_low_reg     <= (others => '0');
      m_freq_high_reg    <= (others => '0');
      timeout_st_reg     <= TIME_OUT_LOW;
      state_reg          <= SYS_START;
      timeout_reg        <= '0';
      m_reg              <= unsigned(CLK_FREQUENCY_STD);
      counter_reg        <= (others => '0');
      count_recovery_reg <= 0;

    elsif rising_edge (sysclk) then
      m_freq_low_reg     <= m_freq_low_next;
      m_freq_high_reg    <= m_freq_high_next;
      timeout_st_reg     <= timeout_st_next;
      state_reg          <= state_next;
      timeout_reg        <= timeout_next;
      counter_reg        <= counter_next;
      m_reg              <= m_next;
      count_recovery_reg <= count_recovery_next;
    end if;
  end process;




  -- main state_machine - frequency filter
  process (counter_reg, m_freq_high_reg, m_freq_low_reg, m_reg, start_stop, count_recovery_reg,
           state_reg)
  begin
    clear               <= '0';
    m_next              <= m_reg;
    state_next          <= state_reg;
    count_recovery_next <= count_recovery_reg;

    case state_reg is

      when SYS_START =>

        -- filtro de inicializacao - recover ---------------------------------------------
        if (start_stop = '1') then
          clear <= '1';
          if (counter_reg > PERIOD_FREQ_MIN) and (counter_reg < PERIOD_FREQ_MAX) then
            m_next     <= counter_reg;
            state_next <= SYS_START_WAIT_PPS;
          end if;
        end if;

      when SYS_START_WAIT_PPS =>

        if (start_stop = '1') then
          clear <= '1';
          if (counter_reg > PERIOD_FREQ_MIN) and (counter_reg < PERIOD_FREQ_MAX) then
            m_next     <= counter_reg;
            state_next <= FILTER_PPS;
          else
            state_next <= SYS_START;
          end if;
        end if;
        ------------------------------------------------------------------------ 
        
      when FILTER_PPS =>
        if start_stop = '1' then
          clear <= '1';
          if (counter_reg > m_freq_low_reg) and (counter_reg < m_freq_high_reg) then
            count_recovery_next <= 0;
            m_next              <= counter_reg;
          else
            if count_recovery_reg = 4 then
              count_recovery_next <= 0;
              state_next          <= SYS_START;
            else
              count_recovery_next <= count_recovery_reg + 1;
            end if;
          end if;
        end if;
        
      when others =>
        state_next <= SYS_START;
    end case;

  end process;


  -- time_out generator state_machine
  process(
    counter_reg,
    m_freq_high_reg,
    timeout_reg,
    timeout_st_reg,
    start_stop
    )
  begin

    timeout_next    <= timeout_reg;
    timeout_st_next <= timeout_st_reg;

    case timeout_st_reg is
      when TIME_OUT_LOW =>
        timeout_next <= '0';
        if counter_reg > m_freq_high_reg then
          timeout_st_next <= TIME_OUT_HIGH;
        end if;

      when TIME_OUT_HIGH =>
        timeout_next <= '1';
        if start_stop = '1' then
          timeout_st_next <= TIME_OUT_LOW;
        end if;

      when others =>
        timeout_st_next <= TIME_OUT_LOW;
    end case;

  end process;



-- desvio maximo permitido
  m_freq_high_next <= m_reg + FM_MAX_DEVIATION;  -- PPS_MAX_DEVIATION < TOLERANCE
  m_freq_low_next  <= m_reg - FM_MAX_DEVIATION;


-- contador da frequencia
  counter_next <= (others => '0') when (clear = '1') else counter_reg + 1;

end frequency_meter_RTL;

-- eof $id:$

