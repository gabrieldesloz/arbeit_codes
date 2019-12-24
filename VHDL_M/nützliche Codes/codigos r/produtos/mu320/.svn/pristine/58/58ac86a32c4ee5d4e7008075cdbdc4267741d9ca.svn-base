-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : k_controller_soc.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2013-06-06
-- Platform   :
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A vhdl module for an ADPLL (All Digital Phase Locked Loop)
-- A 15360 (256*60) Hz square waveform phase controller
-- Measures drift distance between dco freq and pps after each pps signal
-- Indicates wich region between 2 pps the controller is acting
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2004         1.0      CLS     Created
-- 2012-09-03   2.0      GDL     Revised and Optimized
-- 2013-02-27   3.0      GDL     Region and drift per second indicators added,
-- numeric_std added
-------------------------------------------------------------------------------


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity k_controller_soc is
  generic (
    D                   : natural;
    N_BITS_NCO_SOC      : natural;
    LIMIT_TIMER_SOC     : natural;
    SOC_TIME_SOC        : natural;  
    LIMIT_LO_SOC_LOCKED : natural;
    LIMIT_HI_SOC        : natural;
    LIMIT_HI_SOC_LOCKED : natural;
    LIMIT_LO_SOC        : natural;
    STEP_LOW_BITS       : natural;
    STEP_NORMAL_BITS    : natural
    );
  port(

    STEP_LOW_SOC      : in std_logic_vector(STEP_LOW_BITS-1 downto 0);
    STEP_NORMAL_SOC   : in std_logic_vector(STEP_NORMAL_BITS-1 downto 0);
    K_DEFAULT_STD_SOC : in std_logic_vector((N_BITS_NCO_SOC-1) downto 0);

    n_reset             : in  std_logic;
    sysclk              : in  std_logic;
    sync_soc            : in  std_logic;
    sync_pps            : in  std_logic;
    irig_ok             : in  std_logic;
    time_out            : in  std_logic;
    k_calculated        : in  std_logic_vector ((N_BITS_NCO_SOC-1) downto 0);
    k_out               : out std_logic_vector ((N_BITS_NCO_SOC-1) downto 0);
    clear_dco           : out std_logic;
    locked              : out std_logic;
    region_k_controller : out std_logic_vector(2 downto 0);
    pps_drift_p_s       : out std_logic_vector(31 downto 0);

    soc_timer_d2_var      : in std_logic_vector(D-1 downto 0);
    limit_high_var        : in std_logic_vector(D-1 downto 0);
    limit_high_locked_var : in std_logic_vector(D-1 downto 0)


    );
end entity k_controller_soc;
------------------------------------------------------------
architecture k_controller_RTL of k_controller_soc is

-- Type declarations

  type STATE_CONTROLLER_TYPE is (WAIT_SYNC_STATE,
                                 COUNT_TIME_STATE,
                                 UPDATE_K_STATE
                                 );

  attribute SYN_ENCODING                          : string;
  attribute SYN_ENCODING of STATE_CONTROLLER_TYPE : type is "safe";



-- Constant declarations


-- Local (internal to the model) signals declarations.

  signal state_controller      : STATE_CONTROLLER_TYPE;
  signal state_controller_next : STATE_CONTROLLER_TYPE;

  signal time_counter      : unsigned(D-1 downto 0);
  signal time_counter_next : unsigned(D-1 downto 0);
  --signal time_counter          : natural range 0 to LIMIT_TIMER_SOC;
  --signal time_counter_next     : natural range 0 to LIMIT_TIMER_SOC;
  signal freq_int              : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal freq_next             : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal clear_dco_flag_int    : std_logic;
  signal clear_dco_flag_next   : std_logic;
  signal b_next, b_reg         : std_logic_vector(N_BITS_NCO_SOC-1 downto 0);

  -- artificio para nao alterar a estrutura da maquina de estado
  signal step_low_soc_int    : integer range 0 to (2**STEP_LOW_BITS);
  signal step_normal_soc_int : integer range 0 to (2**STEP_NORMAL_BITS);


-- teste signal tap
  signal region_k_controller_next                             : std_logic_vector(2 downto 0);
  signal region_k_controller_reg                              : std_logic_vector(2 downto 0);
-- test
  signal sample1_reg, sample2_reg, sample1_next, sample2_next : unsigned(D-1 downto 0);
  signal pps_drift_p_s_reg, pps_drift_p_s_next                : unsigned(31 downto 0);

  attribute syn_keep                             : boolean;
  attribute preserve                             : boolean;
  attribute syn_keep of region_k_controller_reg  : signal is true;
  attribute syn_keep of region_k_controller_next : signal is true;

  attribute preserve of pps_drift_p_s_reg  : signal is true;
  attribute preserve of pps_drift_p_s_next : signal is true;



  -- test functions

  function maximum (
    left, right : unsigned)             -- inputs
    return unsigned is
  begin  -- function max
    if (left) > (right) then return left;
    else return right;
    end if;
  end function maximum;

  function minimum (
    left, right : unsigned)             -- inputs
    return unsigned is
  begin  -- function minimum
    if (left) < (right) then return left;
    else return right;
    end if;
  end function minimum;



-- Component declarations

begin

  step_low_soc_int    <= to_integer(unsigned(STEP_LOW_SOC));
  step_normal_soc_int <= to_integer(unsigned(STEP_NORMAL_SOC));

  k_out               <= freq_int;
  locked              <= clear_dco_flag_int;
  clear_dco           <= sync_pps when (clear_dco_flag_int = '1') else '0';
  region_k_controller <= region_k_controller_reg;

  freq_next <= std_logic_vector(unsigned(k_calculated) + unsigned(b_reg));

  process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (n_reset = '0') then
        b_reg                   <= (others => '0');
        state_controller        <= WAIT_SYNC_STATE;
        time_counter            <= (others => '0');
        freq_int                <= K_DEFAULT_STD_SOC;
        clear_dco_flag_int      <= '0';
        region_k_controller_reg <= "000";

        -- test
        sample2_reg       <= (others => '0');
        sample1_reg       <= (others => '0');
        pps_drift_p_s_reg <= (others => '0');
        -- test

      else

        -- test
        sample2_reg       <= sample2_next;
        sample1_reg       <= sample1_next;
        pps_drift_p_s_reg <= pps_drift_p_s_next;
        -- test


        region_k_controller_reg <= region_k_controller_next;
        b_reg                   <= b_next;
        if (irig_ok = '1') then
          state_controller   <= state_controller_next;
          time_counter       <= time_counter_next;
          freq_int           <= freq_next;
          clear_dco_flag_int <= clear_dco_flag_next;
        else
          state_controller   <= WAIT_SYNC_STATE;
          time_counter       <= (others => '0');
          freq_int           <= k_calculated;
          clear_dco_flag_int <= '0';
        end if;
      end if;
    end if;
  end process;

  process (
    b_reg,
    clear_dco_flag_int,
    irig_ok,
    region_k_controller_reg,
    state_controller,
    sync_pps,
    sync_soc,
    time_counter,
    time_out,
    -- variables
    soc_timer_d2_var,
    limit_high_var,
    limit_high_locked_var,
    --pps_drift
    sample1_reg,
    sample2_reg,

    step_low_soc_int,
    step_normal_soc_int

    ) is


  begin  -- process

    -- test
    sample1_next <= sample1_reg;
    sample2_next <= sample2_reg;
    -- test

    b_next                   <= b_reg;
    state_controller_next    <= state_controller;
    time_counter_next        <= time_counter;
    clear_dco_flag_next      <= clear_dco_flag_int;
    -- sinal de teste
    region_k_controller_next <= region_k_controller_reg;

    case state_controller is

      when WAIT_SYNC_STATE =>

        if ((sync_pps = '1') and (irig_ok = '1')) then
          time_counter_next     <= (others => '0');
          state_controller_next <= COUNT_TIME_STATE;
        elsif time_out = '1' then
          clear_dco_flag_next <= '0';
          b_next              <= (others => '0');
        end if;

      when COUNT_TIME_STATE =>
        time_counter_next <= time_counter + 1;
        if (sync_soc = '1') then

          -- test --
          sample1_next <= time_counter;
          sample2_next <= sample1_reg;
          -- test --

          state_controller_next <= UPDATE_K_STATE;
        elsif (sync_pps = '1') then
          state_controller_next <= WAIT_SYNC_STATE;
          
        end if;


      when UPDATE_K_STATE =>
        region_k_controller_next <= "100";
        b_next                   <= (others => '0');
        state_controller_next    <= WAIT_SYNC_STATE;
        clear_dco_flag_next      <= '1';
        --if (time_counter < SOC_TIME_SOC/2 + 1) then
        if (time_counter < unsigned(soc_timer_d2_var)) then
          if (time_counter > LIMIT_LO_SOC) then
            clear_dco_flag_next      <= '0';
            --freq_next           <= k_hi_normal;
            --k_hi_normal <= k_calculated + STEP_NORMAL_SOC;
            b_next                   <= std_logic_vector(to_unsigned(step_normal_soc_int, N_BITS_NCO_SOC));
            -- saida teste signal_tap
            region_k_controller_next <= "011";
          elsif (time_counter > LIMIT_LO_SOC_LOCKED) then
            clear_dco_flag_next      <= '0';
            --freq_next           <= k_hi_low;
            --k_hi_low    <= k_calculated + STEP_LOW_SOC;
            b_next                   <= std_logic_vector(to_unsigned(step_low_soc_int, N_BITS_NCO_SOC));
            -- saida teste signal_tap
            region_k_controller_next <= "010";
          end if;
        else
          --if (time_counter < LIMIT_HI_SOC) then
          if (time_counter < unsigned(limit_high_var)) then
            --freq_next           <= k_lo_normal;
            --k_lo_normal <= k_calculated - STEP_NORMAL_SOC;
            b_next                   <= (not std_logic_vector(to_unsigned(step_normal_soc_int, N_BITS_NCO_SOC)+1));
            clear_dco_flag_next      <= '0';
            -- saida teste signal_tap
            region_k_controller_next <= "001";
          --elsif (time_counter < LIMIT_HI_SOC_LOCKED) then
          elsif (time_counter < unsigned(limit_high_locked_var)) then
            --freq_next           <= k_lo_low;
            --k_lo_low  <= k_calculated - STEP_LOW_SOC;
            b_next                   <= (not std_logic_vector(to_unsigned(step_low_soc_int, N_BITS_NCO_SOC)+1));
            clear_dco_flag_next      <= '0';
            -- saida teste signal_tap
            region_k_controller_next <= "000";
          end if;
        end if;
      when others =>
        state_controller_next <= WAIT_SYNC_STATE;
    end case;
  end process;



--medidor do drift
  pps_drift_p_s_next <= maximum(resize(sample1_reg, 32), resize(sample2_reg, 32)) - minimum(resize(sample1_reg, 32), resize(sample2_reg, 32));
  pps_drift_p_s      <= std_logic_vector(pps_drift_p_s_reg);



end k_controller_RTL;

-- eof $Id: k_controller.vhd 5253 2010-07-23 10:59:48Z cls $

