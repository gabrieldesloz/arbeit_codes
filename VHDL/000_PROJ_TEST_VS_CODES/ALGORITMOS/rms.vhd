-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : RMS calculation module
-- Project    : protective relay
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- File       : rms.vhd
-- Author     : Lucas Groposo
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-16
-- Last update: 2013-01-23
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A VHDL module for calculating RMS   
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-16   1.0      LGS     Created
-- 2011-10-21   1.0      CLS     Code revision
-- 2012-09-26   1.0      GDL     Code revision, optimization
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity rms is
  generic(
    N_BITS_INPUT  : natural := 8;
    N_POINTS_BITS : natural := 16);

  port (
    -- System signals
    sysclk  : in std_logic;             -- Input Clock
    reset_n : in std_logic;             -- System Reset

    -- Input interface signals
    data_input      : in std_logic_vector(N_BITS_INPUT-1 downto 0);  -- Input data -- 
    data_available  : in std_logic;     -- New data at input
    n_point_samples : in std_logic_vector(N_POINTS_BITS-1 downto 0);

    -- Output interface signals
    data_output : out std_logic_vector((N_BITS_INPUT-1) downto 0);  -- Output data
    data_ready  : out std_logic);       -- Signals data ready at output

end rms;


-------------------------------------------------------------------------------

architecture rms_RTL of rms is

-- Type and enumeration declarations
  type RMS_TYPE is (INIT, WAIT_NEW_DATA, ACCUMULATE, VERIFY);
  type SQRT_TYPE is (WAIT_NEW_DATA, WAIT_STATE);


  attribute syn_encoding             : string;
  attribute syn_encoding of RMS_TYPE : type is "safe";

  attribute syn_encoding             : string;
  attribute syn_encoding of RMS_TYPE : type is "safe";



-- Registers to hold the current and next state from the machine

  signal rms_state          : RMS_TYPE;
  signal rms_state_next     : RMS_TYPE;
  signal divider_state      : SQRT_TYPE;
  signal divider_state_next : SQRT_TYPE;
  signal sqrt_state         : SQRT_TYPE;
  signal sqrt_state_next    : SQRT_TYPE;

-- Internal signals

  signal power_acc_reg                   : std_logic_vector((2*N_BITS_INPUT)-1 downto 0);
  signal power_acc_next                  : std_logic_vector((2*N_BITS_INPUT)-1 downto 0);
  signal acc_reg                         : std_logic_vector((2*N_BITS_INPUT)+15 downto 0);
  signal acc_next                        : std_logic_vector((2*N_BITS_INPUT)+15 downto 0);
  signal counter_reg                     : natural range 0 to 2**N_POINTS_BITS;
  signal counter_next                    : natural range 0 to 2**N_POINTS_BITS;
  signal accum_available_reg             : std_logic;
  signal accum_available_next            : std_logic;
  signal sqrt_input_reg                  : std_logic_vector((2*N_BITS_INPUT)-1 downto 0);
  signal sqrt_input_next                 : std_logic_vector((2*N_BITS_INPUT)-1 downto 0);
  signal sqrt_result_reg                 : std_logic_vector(N_BITS_INPUT-1 downto 0);
  signal sqrt_data_ready_reg             : std_logic;
  signal sqrt_data_ready_next            : std_logic;
  signal sqrt_output_reg                 : std_logic_vector((N_BITS_INPUT -1) downto 0);
  signal sqrt_output_next                : std_logic_vector((N_BITS_INPUT -1) downto 0);
  signal divider_input_reg               : std_logic_vector((2*N_BITS_INPUT)+15 downto 0);
  signal divider_input_next              : std_logic_vector((2*N_BITS_INPUT)+15 downto 0);
  signal divider_result_reg              : std_logic_vector((2*N_BITS_INPUT)+15 downto 0);
  signal divider_data_ready_reg          : std_logic;
  signal divider_data_ready_next         : std_logic;
  signal divider_output_reg              : std_logic_vector(2*N_BITS_INPUT-1 downto 0);
  signal divider_output_next             : std_logic_vector(2*N_BITS_INPUT-1 downto 0);
  signal n_point_samples_reg             : std_logic_vector(N_POINTS_BITS downto 0);
  signal ready                           : std_logic;
  signal div_start_reg, div_start_next   : std_logic;
  signal sqrt_ready                      : std_logic;
  signal sqrt_start_reg, sqrt_start_next : std_logic;



begin

  data_output <= sqrt_output_reg;
  data_ready  <= sqrt_data_ready_reg;

  n_point_samples_reg <= ('0' & n_point_samples) + '1';


  sqrt_1 : entity work.sqrt
    generic map (
      N => 2*N_BITS_INPUT)
    port map (
      ready     => sqrt_ready,
      start     => sqrt_start_reg,
      sysclk    => sysclk,
      n_reset   => reset_n,
      radical   => sqrt_input_reg,
      remainder => open,
      q         => sqrt_result_reg);


  divider_1 : entity work.divider
    -- N = Q, D < N
    generic map (
      N => (2*N_BITS_INPUT)+16,
      D => N_POINTS_BITS+1
      )
    port map (
      sysclk  => sysclk,
      n_reset => reset_n,
      start   => div_start_reg,
      num     => divider_input_reg,     -- 40 bits
      den     => n_point_samples_reg,   -- 11 bits
      quo     => divider_result_reg,    -- 40 bits
      rema    => open,
      ready   => ready);



  -- main state machine process accumulation - registers
  process (reset_n, sysclk)
  begin
    if (reset_n = '0') then
      div_start_reg       <= '0';
      rms_state           <= INIT;
      power_acc_reg       <= (others => '0');
      acc_reg             <= (others => '0');
      counter_reg         <= 0;
      accum_available_reg <= '0';
    elsif rising_edge(sysclk) then
      div_start_reg       <= div_start_next;
      rms_state           <= rms_state_next;
      power_acc_reg       <= power_acc_next;
      acc_reg             <= acc_next;
      counter_reg         <= counter_next;
      accum_available_reg <= accum_available_next;
    end if;
  end process;


  -- main state machine process accumulation - next state logic
  process (acc_reg, counter_reg, data_available, data_input, power_acc_reg,
           rms_state, n_point_samples)
  begin
    rms_state_next       <= rms_state;
    power_acc_next       <= power_acc_reg;
    acc_next             <= acc_reg;
    counter_next         <= counter_reg;
    accum_available_next <= '0';

    case rms_state is
      
      when INIT =>
        power_acc_next <= (others => '0');
        acc_next       <= (others => '0');
        counter_next   <= 0;
        rms_state_next <= WAIT_NEW_DATA;

      when WAIT_NEW_DATA =>
        if (data_available = '1') then
          power_acc_next <= data_input * data_input;
          rms_state_next <= ACCUMULATE;
        end if;
        
      when ACCUMULATE =>
        acc_next       <= acc_reg + power_acc_reg;
        rms_state_next <= VERIFY;

      when VERIFY =>
        if (counter_reg = n_point_samples) then
          counter_next         <= 0;
          accum_available_next <= '1';
          rms_state_next       <= INIT;
        else
          counter_next   <= counter_reg + 1;
          rms_state_next <= WAIT_NEW_DATA;
        end if;

      when others =>
        rms_state_next <= INIT;
        
    end case;
  end process;



  --state machine process divider - registers
  process (reset_n, sysclk)
  begin
    if reset_n = '0' then
      divider_state          <= WAIT_NEW_DATA;
      divider_data_ready_reg <= '0';
      divider_input_reg      <= (others => '0');
      divider_output_reg     <= (others => '0');
    elsif rising_edge(sysclk) then
      divider_state          <= divider_state_next;
      divider_input_reg      <= divider_input_next;
      divider_output_reg     <= divider_output_next;
      divider_data_ready_reg <= divider_data_ready_next;
    end if;
  end process;


-- state machine process divider - next state logic
  process (acc_reg, accum_available_reg, divider_data_ready_reg,
           divider_input_reg, divider_output_reg, divider_result_reg,
           divider_state, ready, div_start_reg)
  begin
    div_start_next          <= '0';
    divider_state_next      <= divider_state;
    divider_input_next      <= divider_input_reg;
    divider_data_ready_next <= divider_data_ready_reg;
    divider_output_next     <= divider_output_reg;


    case divider_state is
      
      when WAIT_NEW_DATA =>
        divider_data_ready_next <= '0';
        if (accum_available_reg = '1') then
          div_start_next     <= '1';
          divider_input_next <= acc_reg;
          divider_state_next <= WAIT_STATE;
        end if;

      when WAIT_STATE =>
        if (ready = '1') then
          divider_output_next     <= divider_result_reg(2*N_BITS_INPUT-1 downto 0);
          divider_data_ready_next <= '1';
          divider_state_next      <= WAIT_NEW_DATA;
        end if;

      when others =>
        divider_state_next <= WAIT_NEW_DATA;
    end case;
  end process;

  -- state machine process sqrt - registers
  process (reset_n, sysclk)
  begin
    if reset_n = '0' then
      sqrt_start_reg      <= '0';
      sqrt_state          <= WAIT_NEW_DATA;
      sqrt_data_ready_reg <= '0';
      sqrt_input_reg      <= (others => '0');
      sqrt_output_reg     <= (others => '0');
      
    elsif rising_edge(sysclk) then
      sqrt_start_reg      <= sqrt_start_next;
      sqrt_state          <= sqrt_state_next;
      sqrt_input_reg      <= sqrt_input_next;
      sqrt_output_reg     <= sqrt_output_next;
      sqrt_data_ready_reg <= sqrt_data_ready_next;
      
    end if;
  end process;


-- state machine process sqrt - next state logic
  process (accum_available_reg, divider_output_reg, sqrt_data_ready_reg,
           sqrt_input_reg, sqrt_output_reg, sqrt_result_reg, sqrt_state,
           divider_data_ready_reg, sqrt_ready)
  begin
    sqrt_start_next      <= '0';
    sqrt_state_next      <= sqrt_state;
    sqrt_input_next      <= sqrt_input_reg;
    sqrt_data_ready_next <= sqrt_data_ready_reg;
    sqrt_output_next     <= sqrt_output_reg;

    case sqrt_state is
      
      when WAIT_NEW_DATA =>
        sqrt_data_ready_next <= '0';
        if (divider_data_ready_reg = '1') then
          sqrt_start_next <= '1';
          sqrt_input_next <= divider_output_reg;
          sqrt_state_next <= WAIT_STATE;
        end if;

      when WAIT_STATE =>
        if (sqrt_ready = '1') then
          sqrt_output_next     <= sqrt_result_reg;
          sqrt_data_ready_next <= '1';
          sqrt_state_next      <= WAIT_NEW_DATA;
        end if;
        

      when others =>
        sqrt_state_next <= WAIT_NEW_DATA;
    end case;
  end process;


  

end rms_RTL;




