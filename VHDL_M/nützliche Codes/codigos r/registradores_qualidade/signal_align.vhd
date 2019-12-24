
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
      reg1 <= slow_signal_i;
      reg2 <= reg1;
    end if;
  end process;

  slow_signal_aligned_o <= reg2;
  
end rtl;
