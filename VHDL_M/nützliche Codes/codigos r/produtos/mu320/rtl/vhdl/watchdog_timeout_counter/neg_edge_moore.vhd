library ieee;
use ieee.std_logic_1164.all;

entity neg_edge_moore is
  port(
    clock   : in  std_logic;
    reset_n : in  std_logic;
    level_i : in  std_logic;
    tick_o  : out std_logic
    );

end neg_edge_moore;

architecture moore_arch of neg_edge_moore is
  type state_type is (zero, one);
  signal state_reg, state_next : state_type;


  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";

  
begin 
  -- state register
  process(clock, reset_n)
  begin
    if (reset_n = '0') then
      state_reg <= zero;
    elsif (rising_edge(clock)) then
      state_reg <= state_next;
    end if;
  end process;


  -- next-state/output logic
  process(state_reg, level_i)
  begin
    state_next <= state_reg;
    tick_o     <= '0';
    case state_reg is
      when zero =>
        if level_i = '0' then
          state_next <= one;
        end if;
      when one =>
        if level_i = '1' then
          tick_o     <= '1';
          state_next <= zero;
        end if;
    end case;
  end process;
end moore_arch;
