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


entity simple_freq_meter is

  generic (
    D                : natural
    );
  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    m_freq            : out std_logic_vector(D-1 downto 0);
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    start_stop        : in  std_logic
    );
end simple_freq_meter;
------------------------------------------------------------------------------

architecture simple_freq_meter_RTL of simple_freq_meter is

-- Local (internal to the model) signals declarations.

  type STATE_TYPE is (SYS_START, SYS_START_WAIT_PPS, FILTER_PPS);



  attribute SYN_ENCODING               : string;
  attribute SYN_ENCODING of STATE_TYPE : type is "safe";



  signal state_next, state_reg                    : STATE_TYPE;
  signal counter_reg, counter_next, m_reg, m_next : unsigned((D-1) downto 0);
  signal clear                                    : std_logic;


begin

  m_freq <= std_logic_vector(m_reg);


  process (CLK_FREQUENCY_STD, n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg   <= SYS_START;
      m_reg       <= unsigned(CLK_FREQUENCY_STD);
      counter_reg <= (others => '0');
      
    elsif rising_edge (sysclk) then
      state_reg   <= state_next;
      counter_reg <= counter_next;
      m_reg       <= m_next;
    end if;
  end process;




  -- main state_machine - frequency filter
  process (counter_reg,
           m_reg,
           start_stop,
           state_reg)
  begin


    clear      <= '0';
    m_next     <= m_reg;
    state_next <= state_reg;

    case state_reg is

      when SYS_START =>
        -- filtro de inicializacao - recover -----------------------------------
        if (start_stop = '1') then
          clear      <= '1';
          state_next <= SYS_START_WAIT_PPS;
        end if;
        
      when SYS_START_WAIT_PPS =>

        if (start_stop = '1') then
          clear      <= '1';
          m_next     <= counter_reg;
          state_next <= SYS_START;
        end if;       
  
        ------------------------------------------------------------------------ 

    when others =>
    state_next <= SYS_START;
  end case;

end process;

-- contador da frequencia
counter_next <= (others => '0') when (clear = '1') else counter_reg + 1;

end simple_freq_meter_RTL;

-- eof $id:$

