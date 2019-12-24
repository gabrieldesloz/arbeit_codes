--=============================
-- Listing 16.5 dual edge detector
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity transitions_counter is
  generic (
    BITS : natural := 16);
  port(
    clk, reset : in  std_logic;
    strobe     : in  std_logic;
    pulse      : out std_logic
    );
end transitions_counter;

architecture direct_arch of transitions_counter is
  signal delay_reg                         : std_logic;
  signal transitions_reg, transitions_next : unsigned(BITS-1 downto 0);
  
begin
  -- delay register
  process(clk, reset)
  begin
    if (reset = '1') then
      delay_reg       <= '0';
      transitions_reg <= 0;
    elsif (clk'event and clk = '1') then
      delay_reg       <= strobe;
      transitions_reg <= transitions_next;
    end if;
  end process;


-- decoding logic
  pulse            <= delay_reg xor strobe;
  transitions_next <= transitions_reg + 1 when (pulse = '1') else transitions_reg;
  
  

  
end direct_arch;
