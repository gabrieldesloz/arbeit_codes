-------------------------------------------------------------------------------
-- Fixed constant pulse expander 
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity pulse_gen is
  generic (
    P_WIDTH : natural := 2);
  port(
    clock    : in  std_logic;
    reset_n  : in  std_logic;
    start    : in  std_logic;
    pulse    : out std_logic
    );
end pulse_gen;


architecture pulse_gen_RTL of pulse_gen is
  type FSMD_STATE_TYPE is (IDLE, DELAY);

  attribute FSMD_STATE_TYPE               : string;
  attribute FSMD_STATE_TYPE of state_type : type is "safe";


  signal state_reg, state_next : fsmd_state_type;
  signal c_reg, c_next         : natural range 0 to P_WIDTH-1;

begin

  process(clock, reset_n)
  begin
    if (reset_n = '0') then
      state_reg <= idle;
      c_reg     <= 0;      
    elsif rising_edge(clock) then
      state_reg <= state_next;
      c_reg     <= c_next;

    end if;
  end process;


  process(c_reg, pulse_go, start, state_reg)
  begin
    pulse      <= '0';
    c_next     <= c_reg;
    state_next <= state_reg;
    case state_reg is
      when IDLE =>
        c_next <= 0;
        if start = '1' then
          state_next <= delay;
        end if;

      when DELAY =>
        pulse <= '1';
        if (c_reg = P_WIDTH-1) then
          state_next <= idle;
        else
          state_next <= delay;
          c_next     <= c_reg + 1;
        end if;
    end case;
  end process;
end pulse_gen_RTL;
