-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : pulse_generator.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-06-21
-- Last update: 2012-06-21
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-06-21  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity pulse_generator is
  
  generic (
    CLK_FREQ_MHZ    : natural := 100;
    PULSE_PERIOD_US : natural := 208);

  port (
    sysclk       : in  std_logic;
    reset_n      : in  std_logic;
    pulse_output : out std_logic);
end pulse_generator;


architecture pulse_generator_struct of pulse_generator is

  constant MAX_PERIOD : natural := (CLK_FREQ_MHZ * PULSE_PERIOD_US);

  signal period_counter : natural range 0 to ((CLK_FREQ_MHZ * PULSE_PERIOD_US) - 1);
  
begin  -- pulse_generator_rtl

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      period_counter <= 0;
      pulse_output <= '1';
    elsif rising_edge (sysclk) then     -- rising clock edge
      if period_counter = (MAX_PERIOD - 1) then
        period_counter <= 0;
        pulse_output <= '0';
      else
        pulse_output <= '1';
        period_counter <= period_counter + 1;
      end if;
    end if;
  end process;

end pulse_generator_struct;
