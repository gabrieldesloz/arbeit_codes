-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Frequency calculation using zero-crossing algorithm 
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : frequency_zero_crossing.vhd
-- Author     : Celso Luis de Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-03-20
-- Last update: 2012-09-26
-- Platform   : 
-- Standard   : VHDL'87
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
use ieee.std_logic_unsigned.all;


-- entity declaration
entity frequency_zero_crossing is
  generic (
    N_POINTS_BITS : natural := 16);
  port(
    -- system signals
    sysclk  : in std_logic;
    reset_n : in std_logic;

    -- interface signals
    sample_signal : in std_logic;
    new_sample    : in std_logic;

    -- output signals
    period_out    : out std_logic_vector(N_POINTS_BITS-1 downto 0);
    period_ok_out : out std_logic

    );
end frequency_zero_crossing;


architecture rtl_frequency_zero_crossing of frequency_zero_crossing is

  constant FREQUENCY_BUFFER_SIZE : natural := 32;
  constant F_BUFFER_BITS         : natural := 5;

-- Build an enumerated type for the state machine
  type STATE_TYPE_PERIOD_METER is (INIT_ZERO_1, INIT_ZERO_2, WAIT_POSITIVE_1, WAIT_TRANSITION_1, WAIT_POSITIVE_2, WAIT_TRANSITION_2, WRITE_PERIOD, D3);
  type STATE_TYPE_PERIOD_SUM is (WAIT_PERIOD_OK, SUM_STATE_1, SUM_STATE_2, WAIT_PERIOD_NOK);
  type FREQUENCY_BUFFER is array (FREQUENCY_BUFFER_SIZE-1 downto 0) of std_logic_vector (N_POINTS_BITS-1 downto 0);

  
  attribute ENUM_ENCODING                            : string;
  attribute ENUM_ENCODING of STATE_TYPE_PERIOD_METER : type is "000 001 010 011 100 101 110 111";
  attribute ENUM_ENCODING of STATE_TYPE_PERIOD_SUM   : type is "00 01 10 11";

  -- Internal constants                                    

  -- Internal Signals

  signal period_meter_state      : STATE_TYPE_PERIOD_METER;
  signal period_meter_state_next : STATE_TYPE_PERIOD_METER;
  signal period_sum_state        : STATE_TYPE_PERIOD_SUM;
  signal period_sum_state_next   : STATE_TYPE_PERIOD_SUM;

  signal internal_sample_signal : std_logic;
  signal period_counter         : std_logic_vector(N_POINTS_BITS-1 downto 0);
  signal period_counter_next    : std_logic_vector(N_POINTS_BITS-1 downto 0);
  signal period_ok              : std_logic;
  signal period_ok_next         : std_logic;

  signal period_out_reg  : std_logic_vector(26 downto 0);
  signal period_out_next : std_logic_vector(26 downto 0);
  signal period_sum      : std_logic_vector(31 downto 0);
  signal period_sum_next : std_logic_vector(31 downto 0);
  signal sum_ok          : std_logic;
  signal sum_ok_next     : std_logic;

  signal f_buffer : FREQUENCY_BUFFER;

  signal f_address_rd      : std_logic_vector((F_BUFFER_BITS - 1) downto 0);
  signal f_address_rd_next : std_logic_vector((F_BUFFER_BITS - 1) downto 0);
  signal f_address_wr      : std_logic_vector((F_BUFFER_BITS - 1) downto 0);
  signal f_address_wr_next : std_logic_vector((F_BUFFER_BITS - 1) downto 0);
  signal f_write           : std_logic;
  signal f_write_next      : std_logic;
  signal d_out             : std_logic_vector(N_POINTS_BITS-1 downto 0);
  
  
  
  
begin

  internal_sample_signal <= sample_signal;
  period_out             <= period_out_reg(N_POINTS_BITS-1 downto 0);
  period_ok_out          <= sum_ok;

  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      period_meter_state <= INIT_ZERO_1;
      period_counter     <= (others => '0');
      period_ok          <= '0';
      f_address_wr       <= (others => '0');
      f_write            <= '0';
    elsif rising_edge(sysclk) then
      f_write            <= f_write_next;
      period_meter_state <= period_meter_state_next;
      period_counter     <= period_counter_next;
      period_ok          <= period_ok_next;
      f_address_wr       <= f_address_wr_next;
    end if;
  end process;



  process (f_address_wr, internal_sample_signal, new_sample, period_counter,
           period_meter_state) is
  begin
    period_meter_state_next <= period_meter_state;
    period_counter_next     <= period_counter;
    period_ok_next          <= '0';
    f_address_wr_next       <= f_address_wr;
    f_write_next            <= '0';

    case period_meter_state is

      -- memory initialization states ---------------------------------------
      when INIT_ZERO_1 =>
        f_write_next            <= '1';
        period_counter_next     <= (others => '0');
        f_address_wr_next       <= (others => '0');
        period_meter_state_next <= INIT_ZERO_2;


      when INIT_ZERO_2 =>
        f_write_next            <= '1';
        f_address_wr_next <= f_address_wr + 1;
        if (f_address_wr = (FREQUENCY_BUFFER_SIZE - 1)) then
          f_write_next            <= '0';
          period_meter_state_next <= WAIT_POSITIVE_1;
          f_address_wr_next       <= (others => '0');
        else
          f_address_wr_next       <= f_address_wr + 1;
          period_meter_state_next <= INIT_ZERO_2;
        end if;

        ------------------------------------------------------------------------         
        

      when WAIT_POSITIVE_1 =>
        if ((new_sample = '1') and (internal_sample_signal = '0')) then
          period_meter_state_next <= WAIT_TRANSITION_1;
        end if;

      when WAIT_TRANSITION_1 =>
        if (new_sample = '1') and (internal_sample_signal = '1') then
          period_counter_next     <= (others => '0');
          period_meter_state_next <= WAIT_POSITIVE_2;
        end if;

      when WAIT_POSITIVE_2 =>
        if (new_sample = '1') then
          period_counter_next <= period_counter + 1;
          if (internal_sample_signal = '0') then
            period_meter_state_next <= WAIT_TRANSITION_2;
          end if;
        end if;

      when WAIT_TRANSITION_2 =>
        if (new_sample = '1') then
          period_counter_next <= period_counter + 1;
          if (internal_sample_signal = '1') then
            period_meter_state_next <= WRITE_PERIOD;
            f_write_next            <= '1';
          end if;
        end if;

      when WRITE_PERIOD =>
        period_counter_next <= (others => '0');
        period_ok_next      <= '1';
        if (f_address_wr = (FREQUENCY_BUFFER_SIZE - 1)) then
          f_address_wr_next <= (others => '0');
        else
          f_address_wr_next <= f_address_wr + 1;
        end if;
        period_meter_state_next <= WAIT_POSITIVE_2;
        
      when others =>
        period_meter_state_next <= WAIT_TRANSITION_1;

    end case;
  end process;


  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      period_out_reg   <= (others => '0');
      period_sum_state <= WAIT_PERIOD_OK;
      period_sum       <= (others => '0');
      f_address_rd     <= (others => '0');
      sum_ok           <= '0';
    elsif rising_edge(sysclk) then
      period_out_reg   <= period_out_next;
      period_sum_state <= period_sum_state_next;
      period_sum       <= period_sum_next;
      f_address_rd     <= f_address_rd_next;
      sum_ok           <= sum_ok_next;
    end if;
  end process;

  process (d_out, f_address_rd, period_ok, period_out_reg, period_sum,
           period_sum_state) is
  begin
    period_out_next       <= period_out_reg;
    period_sum_state_next <= period_sum_state;
    period_sum_next       <= period_sum;
    f_address_rd_next     <= f_address_rd;
    sum_ok_next           <= '0';
    case period_sum_state is


      when WAIT_PERIOD_OK =>
        if (period_ok = '1') then
          period_sum_state_next <= SUM_STATE_1;
          period_sum_next       <= (others => '0');
          f_address_rd_next     <= (others => '0');
        end if;

      when SUM_STATE_1 =>
        period_sum_next <= period_sum + d_out;
        if (f_address_rd = (FREQUENCY_BUFFER_SIZE - 1)) then
          period_sum_state_next <= WAIT_PERIOD_NOK;
        else
          f_address_rd_next     <= f_address_rd + 1;
          period_sum_state_next <= SUM_STATE_2;
        end if;

      when SUM_STATE_2 =>
        period_sum_state_next <= SUM_STATE_1;

      when WAIT_PERIOD_NOK =>           -- divisao por 8
        period_out_next <= period_sum(31 downto 5);
        sum_ok_next     <= '1';
        if (period_ok = '0') then
          period_sum_state_next <= WAIT_PERIOD_OK;
        end if;
        
      when others => null;
    end case;
  end process;


  --* --------------------------------------------------------------------------------------------------------------------------------------
--* Dual-Port RAM generation
--* Generate the simple dual-port RAM
--* Input      : f_address_wr, f_address_rd, period_counter, f_write
--* Output     : d_out
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (f_write = '1') then
        f_buffer(CONV_INTEGER(f_address_wr)) <= period_counter;
      end if;
      d_out <= f_buffer(CONV_INTEGER(f_address_rd));
    end if;
  end process;



end rtl_frequency_zero_crossing;

