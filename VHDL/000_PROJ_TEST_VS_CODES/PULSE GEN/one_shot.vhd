library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.lpm_components.all;

library work;
use work.rl131_constants.all;


  entity one_shot is
  port(
    clock, n_reset : in  std_logic;
    go, stop   : in  std_logic;
    pulse      : out std_logic;
    pulse_go   : in  std_logic;
    p_width    : in  std_logic_vector(DL_BITS-1 downto 0)
    );
end one_shot;


architecture pulse_gen_RTL of pulse_gen is
  TYPE fsmd_state_type is (idle, delay);
  signal state_reg, state_next : fsmd_state_type;
  signal c_reg, c_next         : std_logic_vector(DL_BITS-1 downto 0);
begin


  process(clk, n_reset)
  begin
    if (reset = '0') then
      state_reg <= idle;
      c_reg     <= (others => '0');
    elsif (clock'event and clock = '1') then
      state_reg <= state_next;
      c_reg     <= c_next;
    end if;
  end process;



  process(state_reg, go, stop, c_reg)
  begin
    pulse  <= '0';
    c_next <= c_reg;
    case state_reg is
      when idle =>
        if go = '1' then
          state_next <= delay;
        else
          state_next <= idle;
        end if;
        c_next <= (others => '0');
      when delay =>
        if stop = '1' then
          state_next <= idle;
        else
          if (c_reg = P_WIDTH-1) then
            state_next <= idle;
          elsif pulse_go = '1' then
            state_next <= delay;
            c_next     <= c_reg + 1;
            pulse      <= '1';
          end if;
        end if;
    end case;
  end process;
end pulse_gen_RTL;
