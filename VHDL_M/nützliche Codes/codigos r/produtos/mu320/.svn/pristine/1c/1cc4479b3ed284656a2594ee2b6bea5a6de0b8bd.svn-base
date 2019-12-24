-------------------------------------------------------------------------------
-- $Id: clk_divider.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/clk_divider.vhd $
-- Written by Celso Souza on 10/2007
-- Last update: 2012-09-17
-- Description: frequency divider
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;


entity clk_divider is
  generic (DES_FREQ_MHZ : natural);
  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    en_div  : out std_logic
    );

end clk_divider;

------------------------------------------------------------------------------

architecture clk_divider_RTL of clk_divider is

  constant DIVIDER : integer := (CLK_FREQUENCY_MHZ/DES_FREQ_MHZ);

  signal divider_counter : integer range 0 to (DIVIDER - 1);
  signal freq_divided    : std_logic;
  signal qa, qb          : std_logic;
  signal en_div_int      : std_logic;


begin


  en_div <= en_div_int;


-- Frequency Divider
  process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      divider_counter <= 0;
      freq_divided    <= '0';
    elsif rising_edge(sysclk) then
      if (divider_counter < (DIVIDER - 1)) then
        divider_counter <= divider_counter + 1;
        freq_divided    <= '0';
      else divider_counter <= 0;
           freq_divided <= '1';
      end if;
    end if;
  end process;

  process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      qa         <= '0';
      qb         <= '0';
      en_div_int <= '0';
    elsif rising_edge(sysclk) then
      qa         <= freq_divided;
      qb         <= qa;
      en_div_int <= qa and (not qb);
    end if;
  end process;

end clk_divider_RTL;


-- eof $Id: clk_divider.vhd 3646 2007-11-12 20:54:13Z cls $
