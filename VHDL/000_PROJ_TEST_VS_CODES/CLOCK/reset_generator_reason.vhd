-------------------------------------------------------------------------------
-- $Id: reset_generator.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/reset_generator.vhd $
-- Written by Celso Souza on 10/2007
-- Last update: 2011-11-07
-- Description: reset generator for RT5 board
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.rl131_constants.all;

entity reset_generator is
  port (
    sysclk     : in  std_logic;
    n_hw_reset : in  std_logic;
    n_reset    : out std_logic
    );

end entity reset_generator;
-----------------------------------------------------------------
architecture reset_generator_rtl of reset_generator is

  signal counter_reset      : natural range 0 to (RESET_DIV - 1);
  signal counter_reset_next : natural range 0 to (RESET_DIV - 1);
  signal n_hw_reset_int_1   : std_logic;
  signal n_hw_reset_int_2   : std_logic;
  signal n_reset_int        : std_logic;


begin
  -- syncronize output signals
  process (sysclk)
  begin
    if rising_edge(sysclk) then
      n_reset        <= n_reset_int;      
    end if;
  end process;

  -- syncronize input signals
  process (sysclk)
  begin
    if rising_edge(sysclk) then     
      n_hw_reset_int_1 <= n_hw_reset;
      n_hw_reset_int_2 <= n_hw_reset_int_1;
    end if;
  end process;


  -- generates reset afer one second
  -- registers
  process (sysclk, n_hw_reset_int_2)
  begin
    if (n_hw_reset_int_2 = '0') then
      counter_reset <= 0;
    elsif rising_edge (sysclk) then
      counter_reset <= counter_reset_next;
    end if;
  end process;
  -- next state logic
  counter_reset_next <= counter_reset when (counter_reset = (RESET_DIV - 1)) else (counter_reset + 1);

  -- output_logic
  n_reset_int <= '1' when (counter_reset = (RESET_DIV - 1)) else '0';
  
end architecture reset_generator_rtl;

-- eof $Id: reset_generator.vhd 3646 2007-11-12 20:54:13Z cls $

