-------------------------------------------------------------------------------
-- $Id: edge_detector.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/edge_detector.vhd $
-- Written by Celso Souza on 10/2007
-- Last update: 2007-10-22
-- Description: detects a positive edge
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
-- Definition of incoming and outgoing signals.
  port (
    n_reset  : in  std_logic;
    sysclk   : in  std_logic;
    f_in     : in  std_logic;
    pos_edge : out std_logic
    );
end edge_detector;
------------------------------------------------------------
architecture edge_detector_RTL of edge_detector is

-- Type declarations

-- Constant declarations

-- Local (internal to the model) signals declarations.

  signal old_f : std_logic;

-- Component declarations

begin

--Processes

  process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      pos_edge <= '0';
      old_f    <= '0';
    elsif rising_edge(sysclk) then
      if (f_in /= old_f) and (f_in = '1') then
        pos_edge <= '1';
      else
        pos_edge <= '0';
      end if;
      old_f <= f_in;
    end if;
  end process;

end edge_detector_RTL;

-- eof $Id: edge_detector.vhd 3646 2007-11-12 20:54:13Z cls $
