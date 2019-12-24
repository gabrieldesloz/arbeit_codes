-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      :  Module  
-- Project    : 
-------------------------------------------------------------------------------
-- File       : frequency_meter.vhd
-- Author     :  
-- Company    : Reason Tecnologia S.A.
-- Created    : 
-- Last update: 2013-04-18
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description

-- 
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;


library work;

entity pulse_counter is

-- Definition of incoming and outgoing signals.  
  port (
    sysclk           : in  std_logic;
    n_reset          : in  std_logic;
    clk_output_in    : in  std_logic;
    pps_in           : in  std_logic;
    freq_current_out : out std_logic_vector((28-1) downto 0)
    );
end pulse_counter;
------------------------------------------------------------------------------

architecture pulse_counter_RTL of pulse_counter is

-- Local (internal to the model) signals declarations.
  
  type STATE_TYPE is (CLEAR_COUNTER, COUNT_FREQ);
  attribute ENUM_ENCODING               : string;
  attribute ENUM_ENCODING of STATE_TYPE : type is "0 1";

  signal counter           : std_logic_vector((28-1) downto 0);
  signal counter_next      : std_logic_vector((28-1) downto 0);
  signal freq_current      : std_logic_vector((28-1) downto 0);
  signal freq_current_next : std_logic_vector((28-1) downto 0);
  signal state             : STATE_TYPE;
  signal state_next        : STATE_TYPE;
  
begin

  freq_current_out <= freq_current;

  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      --timeout <= '0';
      freq_current <= (others => '0');  
      counter      <= (others => '0');
      state        <= CLEAR_COUNTER;
    elsif rising_edge (sysclk) then
      --timeout <= timeout_next;
      counter      <= counter_next;
      freq_current <= freq_current_next;
      state        <= state_next;
    end if;
  end process;


  --time_out <= timeout_reg;

  process(counter, clk_output_in, pps_in, state, freq_current)
  begin
    state_next        <= state;
    --timeout_next <= timeout;
    freq_current_next <= freq_current;
    counter_next      <= counter;

    case state is
      when CLEAR_COUNTER =>
        counter_next      <= (others => '0');
        freq_current_next <= counter;
        state_next        <= COUNT_FREQ;

      when COUNT_FREQ =>   
        if clk_output_in = '1' then
          counter_next <= counter + 1;
        end if;
        if pps_in = '1' then
          state_next <= CLEAR_COUNTER;
        else
          state_next <= COUNT_FREQ;
        end if;
        
      when others =>
        state_next <= CLEAR_COUNTER;

    end case;
  end process;
  

  
end pulse_counter_RTL;



