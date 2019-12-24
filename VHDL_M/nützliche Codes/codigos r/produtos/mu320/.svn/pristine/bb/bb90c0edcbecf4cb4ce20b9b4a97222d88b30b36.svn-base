-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : detects irig activity
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : irig_detector.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2012-07-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  detects irig activity
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;

entity irig_detector is
  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    irig    : in  std_logic;
    irig_ok : out std_logic
    );
end irig_detector;
------------------------------------------------------------
architecture irig_detector_RTL of irig_detector is

-- Type declarations

  type IRIG_DETECT_TYPE is (WAIT_1ST_EDGE, WAIT_2ND_EDGE);

  attribute ENUM_ENCODING                     : string;
  attribute ENUM_ENCODING of IRIG_DETECT_TYPE : type is "0 1";
-- Constant declarations


-- Local (internal to the model) signals declarations.


  signal irig_detect_state      : IRIG_DETECT_TYPE;
  signal irig_detect_state_next : IRIG_DETECT_TYPE;
  signal irig_counter           : natural range 0 to (TIMEOUT_IRIG - 1);
  signal irig_counter_next      : natural range 0 to (TIMEOUT_IRIG - 1);
  signal irig_ok_counter        : natural range 0 to (ONE_SECOND - 1);
  signal irig_edge              : std_logic;
  signal up_irig_reg            : std_logic;
  signal up_irig_next           : std_logic;
  
  
  

begin

  edge_detector_inst : entity work.edge_detector  -- detects irig rising edges
    port map(
      n_reset  => n_reset,
      sysclk   => sysclk,
      f_in     => irig,
      pos_edge => irig_edge
      );



  -- detects irig activity
  process(n_reset, sysclk)
  begin
    if (n_reset = '0') then
      irig_detect_state <= WAIT_1ST_EDGE;
      irig_counter      <= 0;
      up_irig_reg       <= '0';
    elsif (rising_edge(sysclk)) then
      irig_detect_state <= irig_detect_state_next;
      irig_counter      <= irig_counter_next;
      up_irig_reg       <= up_irig_next;
    end if;
  end process;

  process (irig_counter, irig_detect_state, irig_edge, up_irig_reg) is
  begin
    irig_detect_state_next <= irig_detect_state;
    irig_counter_next      <= irig_counter;
    up_irig_next           <= up_irig_reg;

    case irig_detect_state is
      when WAIT_1ST_EDGE =>
        up_irig_next      <= '0';
        irig_counter_next <= 0;
        if (irig_edge = '1') then
          irig_detect_state_next <= WAIT_2ND_EDGE;
        end if;

      when WAIT_2ND_EDGE =>
        if (irig_counter = (TIMEOUT_IRIG - 1)) then
          irig_detect_state_next <= WAIT_1ST_EDGE;
        else
          irig_counter_next <= irig_counter + 1;
          if (irig_edge = '1') then
            if (IRIG_COUNTER > TR_IRIG_MIN) then
              up_irig_next      <= '1';
              irig_counter_next <= 0;
            else
              irig_detect_state_next <= WAIT_1ST_EDGE;
            end if;
          end if;
        end if;
        
      when others => null;
    end case;
  end process;



  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      irig_ok_counter <= 0;
    elsif rising_edge(sysclk) then
      if (up_irig_reg = '0') then
        irig_ok_counter <= 0;
      elsif (irig_ok_counter = (ONE_SECOND - 1)) then
        irig_ok_counter <= (ONE_SECOND - 1);
      else
        irig_ok_counter <= irig_ok_counter + 1;
      end if;
    end if;
  end process;
  irig_ok <= '1' when (irig_ok_counter = (ONE_SECOND - 1)) else '0';





end irig_detector_RTL;

-- eof $Id: irig_detector.vhd 4687 2009-07-29 12:27:03Z cls $




