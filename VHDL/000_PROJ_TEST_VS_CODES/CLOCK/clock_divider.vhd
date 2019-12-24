
--- args: --ieee=synopsis
-- args: --std=02
-- args: --worK=WORK
-- args: -g
-- args: -d
-- args: -f


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity clk_divider is

-- Definition of incoming and outgoing signals.

  generic(CLK_FREQUENCY_MHZ : integer := 50;
          DES_FREQ_MHZ      : integer := 5);  -- Desired Freq in MHz

  port (
    sysclk : in  std_logic;
    reset  : in  std_logic;
    en_div : out std_logic
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


  EN_DIV_GEN : process (sysclk, n_reset)
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
  end process EN_DIV_GEN;




  -- Frequency Divider
  FREQ_DIV : process (sysclk, n_reset)
  begin
    if (reset = '0') then
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
  end process FREQ_DIV;



end clk_divider_RTL;
