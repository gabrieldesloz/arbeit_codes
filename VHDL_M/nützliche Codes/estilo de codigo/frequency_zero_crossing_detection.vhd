-------------------------------------------------------------------------------
-- Title      : Frequency calculation using zero-crossing algorithm 
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : frequency_zero_crossing_detection.vhd
-- Author     : Celso Luis de Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-03-20
-- Last update: 2013-05-07
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:  Frequency algorithm implementation
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-03-20  1.0      CLS     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.rl131_constants_pkg.all;


-- entity declaration
entity frequency_zero_crossing_detection is
  port(
    -- system signals
    sysclk    : in std_logic;
    a_reset_n : in std_logic;

    -- interface signals
    sample_signal_i : in std_logic;
    new_sample_i    : in std_logic;

    -- output signals
    single_period_v_o  : out std_logic_vector(15 downto 0);
    single_period_ok_o : out std_logic;
    period_read_i      : in  std_logic

    );
end frequency_zero_crossing_detection;


architecture rtl_frequency_zero_crossing_detection of
  frequency_zero_crossing_detection is
  
  type PERIOD_METER_ST_TYPE is (ST_WAIT_POSITIVE_1, ST_WAIT_TRANSITION_1,
                                ST_WAIT_POSITIVE_2, ST_WAIT_TRANSITION_2,
                                ST_END_PERIOD);

  attribute SYN_ENCODING                         : string;
  attribute SYN_ENCODING of PERIOD_METER_ST_TYPE : type is "safe";


  -- Internal Signals

  signal period_meter_state      : PERIOD_METER_ST_TYPE;
  signal period_meter_state_next : PERIOD_METER_ST_TYPE;


  signal sample_signal_reg     : std_logic;
  signal period_counter_reg    : natural range 0 to 65535;
  signal period_counter_next   : natural range 0 to 65535;
  signal single_period_reg     : natural range 0 to 65535;
  signal single_period_next    : natural range 0 to 65535;
  signal single_period_ok_reg  : std_logic;
  signal single_period_ok_next : std_logic;
  
  
begin
  -- output assignments
  single_period_ok_o <= single_period_ok_reg;
  -- converts natural to std_logic_vector
  single_period_v_o  <= std_logic_vector(TO_UNSIGNED(single_period_reg, 16));

  -- syncronize input signals
  process (sysclk, a_reset_n) is
  begin
    if (a_reset_n = '0') then
      sample_signal_reg <= '0';
    elsif rising_edge(sysclk) then
      sample_signal_reg <= sample_signal_i;
    end if;
  end process;



  process (a_reset_n, sysclk) is
  begin
    if (a_reset_n = '0') then
      period_meter_state   <= ST_WAIT_POSITIVE_1;
      period_counter_reg   <= 0;
      single_period_ok_reg <= '0';
      single_period_reg    <= 0;
    elsif rising_edge(sysclk) then
      period_meter_state   <= period_meter_state_next;
      period_counter_reg   <= period_counter_next;
      single_period_ok_reg <= single_period_ok_next;
      single_period_reg    <= single_period_next;
    end if;
  end process;



  process (sample_signal_reg, new_sample_i, period_counter_reg,
           period_meter_state, period_read_i, single_period_reg) is
  begin
    period_meter_state_next <= period_meter_state;
    period_counter_next     <= period_counter_reg;
    single_period_ok_next   <= '0';
    single_period_next      <= single_period_reg;
    case period_meter_state is

      when ST_WAIT_POSITIVE_1 =>
        if ((new_sample_i = '1') and (sample_signal_reg = '0')) then
          period_meter_state_next <= ST_WAIT_TRANSITION_1;
        end if;

      when ST_WAIT_TRANSITION_1 =>
        if (new_sample_i = '1') and (sample_signal_reg = '1') then
          period_counter_next     <= 0;
          period_meter_state_next <= ST_WAIT_POSITIVE_2;
        end if;

      when ST_WAIT_POSITIVE_2 =>
        if (new_sample_i = '1') then
          period_counter_next <= period_counter_reg + 1;
          if (sample_signal_reg = '0') then
            period_meter_state_next <= ST_WAIT_TRANSITION_2;
          end if;
        end if;

      when ST_WAIT_TRANSITION_2 =>
        if (new_sample_i = '1') then
          period_counter_next <= period_counter_reg + 1;
          if (sample_signal_reg = '1') then
            period_meter_state_next <= ST_END_PERIOD;
          end if;
        end if;
        
      when ST_END_PERIOD =>
        single_period_ok_next <= '1';
        single_period_next    <= period_counter_reg;
        if (period_read_i = '1') then
          period_meter_state_next <= ST_WAIT_POSITIVE_2;
          period_counter_next     <= 0;
        end if;
        
      when others =>
        period_meter_state_next <= ST_WAIT_TRANSITION_1;

    end case;
  end process;


  


end rtl_frequency_zero_crossing_detection;

