-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : signal_align.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-24
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-02-03  1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signal_align is
  
  port (
    fast_clk              : in  std_logic;
    reset_n               : in  std_logic;
    slow_signal_i         : in  std_logic;
    slow_signal_aligned_o : out std_logic
    );

end signal_align;

architecture rtl of signal_align is

  signal reg1, reg2          : std_logic;
  attribute preserve         : boolean;
  attribute preserve of reg1 : signal is true;
  attribute preserve of reg2 : signal is true;
  
begin
  
  process (fast_clk, reset_n)
  begin
    if reset_n = '0' then
      reg1 <= '0';
      reg2 <= '0';
    elsif rising_edge(fast_clk) then
      reg1 <= sig_i;
      reg2 <= reg_1;
    end if;
  end process;

  slow_signal_aligned_o <= reg2;
  
end rtl;
