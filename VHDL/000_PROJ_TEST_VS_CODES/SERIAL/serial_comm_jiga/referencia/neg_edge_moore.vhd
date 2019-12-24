library ieee;
use ieee.std_logic_1164.all;
entity neg_edge_moore is
  port(
    sysclk  : in  std_logic;
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
  signal tick_next, tick_reg           : std_logic;
  
begin

  tick_o <= tick_reg;

  -- state register
  process(sysclk, reset_n)
  begin
    if (reset_n = '0') then
      tick_reg  <= '0';
      state_reg <= zero;
    elsif (falling_edge(sysclk)) then
      tick_reg  <= tick_next;
      state_reg <= state_next;
    end if;
  end process;


  -- next-state/output logic
  process(state_reg, level_i)
  begin
    state_next <= state_reg;
    tick_next  <= '0';
    case state_reg is
      when one =>
        if level_i = '0' then
          state_next <= one;
          tick_next  <= '1';
        end if;
      when zero =>
        if level_i = '1' then
          state_next <= zero;
        end if;
    end case;
  end process;
end moore_arch;
