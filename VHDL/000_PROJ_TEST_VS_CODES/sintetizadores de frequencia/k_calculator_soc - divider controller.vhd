-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module  
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : k_calculator.vhd
-- Author     : Celso Souza 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2012-10-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A k (frequency word) calculator for the DCOs (Digitally
-- controlled oscillators). 
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2004         1.0      CLS     Created
-- 2012-09-03   2.0      GDL     Revised and Optimized  
-------------------------------------------------------------------------------

-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity k_calculator_soc is

  generic (
    N                     : natural;
    D                     : natural;
    Q                     : natural;
    N_BITS_NCO_SOC        : natural;
    FREQUENCY_DEFAULT_STD : std_logic_vector(N-1 downto 0);
    K_DEFAULT_STD         : std_logic_vector(N_BITS_NCO_SOC-1 downto 0)
    );

-- Definition of incoming and outgoing signals. 
  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    m_freq  : in  std_logic_vector(D-1 downto 0);
    k_out   : out std_logic_vector((N_BITS_NCO_SOC - 1) downto 0)
    );

end k_calculator_soc;

------------------------------------------------------------------------------

architecture k_calculator_RTL of k_calculator_soc is

-- Type declarations
  type K_CALCULATOR_TYPE is (IDLE_STATE, START_STATE, WAIT_STATE, D1);
  attribute ENUM_ENCODING                      : string;
  attribute ENUM_ENCODING of K_CALCULATOR_TYPE : type is "00 01 10 11";


-- Local (internal to the model) signals declarations.
  signal state_calc      : K_CALCULATOR_TYPE;
  signal state_calc_next : K_CALCULATOR_TYPE;


  signal k_calc_reg  : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal k_calc_next : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal start       : std_logic;
  signal quo         : std_logic_vector ((Q-1) downto 0);
  signal ready       : std_logic;
  

begin

-- components instantiations

  divider_1 : entity work.divider
    generic map (
      N => N,
      D => D,
      Q => Q)
    port map (
      sysclk  => sysclk,
      n_reset => n_reset,
      start   => start,
      num     => FREQUENCY_DEFAULT_STD,
      den     => m_freq,
      quo     => quo,
      rema    => open,
      ready   => ready);


-- concurrent signal assignment statements
  k_out <= k_calc_reg;


-- Processes

-- do division
  -- state register
  process (sysclk)
  begin
    if rising_edge(sysclk) then
      if (n_reset = '0') then
        state_calc <= IDLE_STATE;
        k_calc_reg <= K_DEFAULT_STD;
      else
        state_calc <= state_calc_next;
        k_calc_reg <= k_calc_next;
      end if;
    end if;
  end process;

  -- next state logic and output logic   
  process (k_calc_reg, quo, ready, state_calc)
  begin
    start           <= '0';
    k_calc_next     <= k_calc_reg;
    state_calc_next <= state_calc;
    case (state_calc) is
      when IDLE_STATE =>
        state_calc_next <= START_STATE;
        
      when START_STATE =>
        start           <= '1';
        state_calc_next <= WAIT_STATE;

      when WAIT_STATE =>
        state_calc_next <= WAIT_STATE;
        if (ready = '1') then
          k_calc_next     <= quo((N_BITS_NCO_SOC - 1) downto 0);
          state_calc_next <= IDLE_STATE;
        end if;

      when others =>
        state_calc_next <= IDLE_STATE;
    end case;
  end process;

end k_calculator_RTL;

-- eof $id:$
