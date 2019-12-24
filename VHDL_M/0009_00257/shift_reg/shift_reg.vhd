
library ieee;
use ieee.std_logic_1164.all;


entity shift_right_register is
  
  generic
    (
      N : natural := 32
      );

  port
    (
      clk      : in  std_logic;
      reset    : in  std_logic;
      d        : in  std_logic;
      q        : out std_logic;
      q_vector : out std_logic_vector(N-1 downto 0)
      );

  
end shift_right_register;

architecture two_seg_arch of shift_right_register is
  
  signal r_reg  : std_logic_vector(N-1 downto 0);
  signal r_next : std_logic_vector(N-1 downto 0);
  
begin
  -- register
  process(clk, reset)
  begin
    if (reset = '1') then
      r_reg <= (others => '0');
    elsif rising_edge(clk) then
      r_reg <= r_next;
    end if;
  end process;

  -- next-state logic (shift right 1 bit)
  r_next <= d & r_reg(N-1 downto 1);

  -- output
  q_vector <= r_reg;
  q        <= r_reg(0);
  
  
end two_seg_arch;
