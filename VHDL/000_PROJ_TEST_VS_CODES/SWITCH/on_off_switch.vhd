library ieee;
use ieee.std_logic_1164.all;

library work;


entity on_off_switch is

  port(
    in_debounce    : in  std_logic;
    clock, n_reset : in  std_logic;
    in_signal      : in  std_logic;
    out_signal     : out std_logic
    );

end on_off_switch;


architecture ARQ_RTL of on_off_switch is

  type FSMD_STATE_TYPE is (OFF_SWITCH, ON_SWITCH);
  attribute ENUM_ENCODING                    : string;
  attribute ENUM_ENCODING of FSMD_STATE_TYPE : type is "01 10";
  signal state_reg, state_next               : fsmd_state_type;
  signal in_debounce_reg                     : std_logic;
  signal out_signal_reg, out_signal_next     : std_logic;

  
begin
  
  
  process(clock, n_reset)
  begin
    if (n_reset = '0') then
      in_debounce_reg <= '0';
      out_signal_reg  <= '0';
      state_reg       <= OFF_SWITCH;
    elsif rising_edge(clock) then
      in_debounce_reg <= in_debounce;
      out_signal_reg  <= out_signal_next;
      state_reg       <= state_next;
    end if;
  end process;
  
  out_signal       <= out_signal_reg;
 
  process(in_debounce_reg, in_signal, out_signal_reg, state_reg)
  begin

    
    state_next       <= state_reg;
    out_signal_next  <= out_signal_reg;

    case state_reg is

      when OFF_SWITCH =>
        out_signal_next <= '0';

        if in_debounce_reg = '1' then
          state_next <= ON_SWITCH;
        end if;
        

      when ON_SWITCH =>
        out_signal_next <= in_signal;

        if in_debounce_reg = '1' then
          state_next <= OFF_SWITCH;
        end if;

      when others =>
        state_next <= OFF_SWITCH;
        
    end case;

  end process;
  
end ARQ_RTL;
