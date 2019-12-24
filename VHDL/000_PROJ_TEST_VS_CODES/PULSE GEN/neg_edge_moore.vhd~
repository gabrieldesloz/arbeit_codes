library ieee;
use ieee.std_logic_1164.all;
entity neg_edge_mealy is
  port(
    clock, n_reset : in  std_logic;
    level          : in  std_logic;
    tick           : out std_logic
    );
end neg_edge_mealy;

architecture mealy_arch of neg_edge_mealy is
  type state_type is (zero, one);
  signal state_reg, state_next         : state_type;
  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";

  
begin
  -- state register
  process(clock, n_reset)
  begin
    if (n_reset = '0') then
      state_reg <= zero;
    elsif (clock'event and clock = '1') then
      state_reg <= state_next;
    end if;
  end process;
  -- next-state/output logic
  process(state_reg, level)
  begin
    state_next <= state_reg;
    tick       <= '0';
    case state_reg is
      when zero=>
        if level = '0' then
          state_next <= one;
          tick       <= '1';
        end if;
      when one =>
        if level = '1' then
          state_next <= zero;
        end if;
    end case;
  end process;
end mealy_arch;
