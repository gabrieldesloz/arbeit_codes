-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : debouncer module
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : debouncer.vhd
-- Author     : Lucas Groposo
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-17
-- Last update: 2012-10-15
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:   A VHDL module for debouncing an input
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-17   1.0      LGS     Created
-- 2012-10-15   2.0      GDL     Modified
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity debouncer is
  generic(
    DEBOUNCE_MAX : natural := 10_000*100
    );  
  port (
    sysclk  : in  std_logic;
    reset_n : in  std_logic;
    input   : in  std_logic;
    output  : out std_logic
    );

end debouncer;


architecture debouncer_RTL of debouncer is

  type DEBOUNCER_TYPE is (STATE_1,
                          STATE_1_0,
                          STATE_0,
                          STATE_0_1);

  attribute ENUM_ENCODING                   : string;
  attribute ENUM_ENCODING of DEBOUNCER_TYPE : type is "00 01 10 11";

  signal debouncer_state      : DEBOUNCER_TYPE;
  signal debouncer_state_next : DEBOUNCER_TYPE;

  signal input_reg        : std_logic;
  signal input_reg_next   : std_logic;
  signal output_reg       : std_logic;
  signal output_reg_next  : std_logic;
  signal counter_reg      : natural range 0 to (DEBOUNCE_MAX);
  signal counter_reg_next : natural range 0 to (DEBOUNCE_MAX);
  

begin  -- debouncer_RTL

  output <= output_reg;

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      debouncer_state <= STATE_1;
      output_reg      <= '1';
      input_reg       <= '1';
      counter_reg     <= DEBOUNCE_MAX;
    elsif rising_edge(sysclk) then      -- rising clock edge
      debouncer_state <= debouncer_state_next;
      output_reg      <= output_reg_next;
      input_reg       <= input_reg_next;
      counter_reg     <= counter_reg_next;
    end if;
  end process;

  process (counter_reg, debouncer_state, input, input_reg, output_reg)
  begin  -- process
    debouncer_state_next <= debouncer_state;
    input_reg_next       <= input_reg;
    output_reg_next      <= output_reg;
    counter_reg_next     <= counter_reg;

    if counter_reg < DEBOUNCE_MAX then
      counter_reg_next <= counter_reg + 1;
    end if;

    case debouncer_state is

      when STATE_1 =>
        if counter_reg = DEBOUNCE_MAX then
          output_reg_next <= input_reg;
        end if;
        if input /= input_reg then
          counter_reg_next     <= 0;
          debouncer_state_next <= STATE_1_0;
        end if;
        input_reg_next <= input;

      when STATE_1_0 =>
        if counter_reg = DEBOUNCE_MAX then
          output_reg_next      <= input_reg;
          debouncer_state_next <= STATE_0;
        end if;
        if input /= input_reg then
          counter_reg_next     <= 0;
          debouncer_state_next <= STATE_0_1;
        end if;
        input_reg_next <= input;

      when STATE_0 =>
        if counter_reg = DEBOUNCE_MAX then
          output_reg_next <= input_reg;
        end if;
        if input /= input_reg then
          counter_reg_next     <= 0;
          debouncer_state_next <= STATE_0_1;
        end if;
        input_reg_next <= input;

      when STATE_0_1 =>
        if counter_reg = DEBOUNCE_MAX then
          output_reg_next      <= input_reg;
          debouncer_state_next <= STATE_1;
        end if;
        if input /= input_reg then
          counter_reg_next     <= 0;
          debouncer_state_next <= STATE_1_0;
        end if;
        input_reg_next <= input;


      when others =>
        debouncer_state_next <= STATE_1;
    end case;
  end process;

end debouncer_RTL;
