-------------------------------------------------------------------------------
-- $Id: clk_divider.vhd 7 2006-05-26 15:08:51Z mrd $
-- $URL: file:///tcn/dsv/priv/repos/svn/components/releases/0003a-d640-v01/common/clk_divider.vhd $
-- Written by Celso Souza on 04/2005
-- Description : A Well behaved clock divider
-- Copyright (C) 2005 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;

entity clk_divider is

-- Definition of incoming and outgoing signals.

  generic(CLK_FREQUENCY_MHZ : integer := 50;
          DES_FREQ_MHZ      : integer := 5);  -- Desired Freq in MHz

  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    en_div  : out std_logic
    );

end clk_divider;

------------------------------------------------------------------------------

architecture clk_divider_RTL of clk_divider is

-- Type declarations

-- constant declarations

  constant DIVIDER : integer := (CLK_FREQUENCY_MHZ/DES_FREQ_MHZ);


-- Local (internal to the model) signals declarations.

  signal divider_counter : integer range 0 to (DIVIDER - 1);
  signal freq_divided    : std_logic;
  signal qa, qb          : std_logic;
  signal en_div_int      : std_logic;


-- Component declarations

begin

-- concurrent signal assignment statements

  en_div <= en_div_int;

-- Component instantiations

-- Processes

-- Frequency Divider
  FREQ_DIV : process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      divider_counter <= 0;
      freq_divided    <= '0';
    elsif (sysclk'event and sysclk = '1') then
      if (divider_counter < (DIVIDER - 1)) then
        divider_counter <= divider_counter + 1;
        freq_divided    <= '0';
      else divider_counter <= 0;
           freq_divided <= '1';
      end if;
    end if;
  end process FREQ_DIV;

  EN_DIV_GEN : process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      qa         <= '0';
      qb         <= '0';
      en_div_int <= '0';
    elsif (sysclk'event and sysclk = '1') then
      qa         <= freq_divided;
      qb         <= qa;
      en_div_int <= qa and (not qb);
    end if;
  end process EN_DIV_GEN;



end clk_divider_RTL;

-- eof $Id: clk_divider.vhd 7 2006-05-26 15:08:51Z mrd $

