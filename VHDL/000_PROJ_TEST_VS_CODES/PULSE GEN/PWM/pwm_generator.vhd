-------------------------------------------------------------------------------
-- $Id$ 
-- $URL$
-- Written by Eduardo Barreto on 1/2004
-- Description : PWM generator for DC-DC converter
-- Copyright (C) 2005 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.qtw_constants.all;

entity pwm_generator is

-- Definition of incoming and outgoing signals.

  port (
    sysclk  : in std_logic;
    n_reset : in std_logic;

    -- output signals
    pwm_out_a : out std_logic;
    pwm_out_b : out std_logic
    );

end pwm_generator;

------------------------------------------------------------------------------

architecture pwm_generator_rtl of pwm_generator is

-- Type declarations]

  type STATE_PWM_TYPE is (RESET_PWM_STATE, PWM_OUT_A_STATE, PWM_OUT_B_STATE, DUMMY_PWM_STATE);
  attribute ENUM_ENCODING                      : string;
  attribute ENUM_ENCODING of STATE_PWM_TYPE : type is "00 01 10 11";


-- constant declarations

-- sampling frequency divider
  constant PWM_FREQ_DIV       : integer := (CLK_FREQUENCY_MHZ_100 * 1000)/PWM_FREQUENCY_KHZ;
  constant PWM_WIDTH_DIV      : integer := (CLK_FREQUENCY_MHZ_100 * 10 * PWM_WIDTH)/PWM_FREQUENCY_KHZ;
  constant SOFT_START_AUX_DIV : integer := ((SOFT_START_TIME * PWM_FREQUENCY_KHZ)/(10 * PWM_WIDTH));
-- Local (internal to the model) signals declarations.

-- sampling frequency counter
  signal state_pwm          : STATE_PWM_TYPE;
  signal pwm_counter        : integer range 0 to (PWM_FREQ_DIV - 1);
  signal pwm_width_counter  : integer range 0 to (PWM_FREQ_DIV - 1);
  signal pwm_soft_start     : integer range 0 to (PWM_WIDTH_DIV - 1);
  signal pwm_soft_start_aux : integer range 0 to (SOFT_START_AUX_DIV - 1);

-- Component declarations

begin

-- concurrent signal assignment statements


-- Component instantiations

-- Processes

-- PWM Frequency Generator
  PWM_FREQ : process (sysclk)
  begin
    if rising_edge(sysclk) then
    if (n_reset = '0') then
      state_pwm         <= RESET_PWM_STATE;
      pwm_out_a         <= '1';
      pwm_out_b         <= '1';
      pwm_counter       <= 0;
      pwm_width_counter <= (PWM_WIDTH_DIV - 1);
    else
      case (state_pwm) is
        when RESET_PWM_STATE =>
          if (n_reset = '1') then
            state_pwm <= PWM_OUT_A_STATE;
          end if;

        when PWM_OUT_A_STATE =>
          pwm_counter       <= pwm_counter + 1;
          pwm_width_counter <= pwm_width_counter + 1;
          if (pwm_counter = ((PWM_FREQ_DIV/2) - 1)) then
            pwm_width_counter <= pwm_soft_start;
            pwm_out_a         <= '1';
            pwm_out_b         <= '0';
            state_pwm         <= PWM_OUT_B_STATE;
          elsif (pwm_width_counter <= (PWM_WIDTH_DIV - 1)) then
            pwm_out_a <= '0';
          else
            pwm_out_a <= '1';
          end if;

        when PWM_OUT_B_STATE =>
          pwm_counter       <= pwm_counter + 1;
          pwm_width_counter <= pwm_width_counter + 1;
          if (pwm_counter = (PWM_FREQ_DIV - 1)) then
            pwm_counter       <= 0;
            pwm_width_counter <= pwm_soft_start;
            pwm_out_b         <= '1';
            pwm_out_a         <= '0';
            state_pwm         <= PWM_OUT_A_STATE;
          elsif (pwm_width_counter <= (PWM_WIDTH_DIV - 1)) then
            pwm_out_b <= '0';
          else
            pwm_out_b <= '1';
          end if;

        when others =>
          state_pwm <= RESET_PWM_STATE;

      end case;
    end if;
   end if;
  end process PWM_FREQ;


  SOFT_START_PROC : process (sysclk)
  begin
  if rising_edge (sysclk) then
    if (n_reset = '0') then
      pwm_soft_start     <= (PWM_WIDTH_DIV - 1);
      pwm_soft_start_aux <= (SOFT_START_AUX_DIV - 1);
    else
      if (pwm_soft_start_aux > 0) then
        pwm_soft_start_aux <= pwm_soft_start_aux - 1;
      elsif (pwm_soft_start > 0) then
        pwm_soft_start     <= pwm_soft_start - 1;
        pwm_soft_start_aux <= (SOFT_START_AUX_DIV - 1);
      end if;
    end if;
  end if;
  end process SOFT_START_PROC;

end pwm_generator_rtl;


-- eof $Id$ 
