library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is

  generic(
    divisor : natural := 100
    );

  
  port (clk_in : in  std_logic;
        div    : out std_logic
        );

end entity;

architecture divide of clock_div is
  signal cnt      : integer   := 0;
  signal div_temp : std_logic := '0';

begin

  process (clk_in)
  begin
    if rising_edge(clk_in) then
      
      if cnt = (divisor/2)-1 then
        div_temp <= not(div_temp);
        cnt      <= 0;
      else
        div_temp <= div_temp;
        cnt      <= cnt + 1;
      end if;
      div <= div_temp;
    end if;
  end process;


end divide;
