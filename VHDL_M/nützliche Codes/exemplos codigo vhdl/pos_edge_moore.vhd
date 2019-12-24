library ieee;
use ieee.std_logic_1164.all;
entity pos_edge_moore is
  port(
    sysclk  : in  std_logic;
    reset_n : in  std_logic;
    level_i : in  std_logic;
    tick_o  : out std_logic

    );
end pos_edge_moore;

architecture moore_arch of pos_edge_moore is
  type state_type is (zero, one);

  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";


  signal state_reg, state_next : state_type;
  signal tick_reg, tick_next   : std_logic;  -- 
  
begin

  tick_o <= tick_reg;

  -- state register
  process(sysclk, reset_n)
  begin
    if (reset_n = '0') then
      state_reg <= zero;
      tick_reg  <= '0';
    elsif (falling_edge(sysclk)) then
      tick_reg  <= tick_next;
      state_reg <= state_next;
    end if;
  end process;
  -- next-state/output logic

  process(level_i, state_reg)
  begin
    state_next <= state_reg;
    tick_next  <= '0';
    case state_reg is
      when zero=>
        if level_i = '1' then
          state_next <= one;
          tick_next  <= '1';
        end if;
      when one =>
        if level_i = '0' then
          state_next <= zero;
        end if;
    end case;
  end process;
end moore_arch;
