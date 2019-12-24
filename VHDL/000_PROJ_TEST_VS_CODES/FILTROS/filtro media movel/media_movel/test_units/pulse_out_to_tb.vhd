-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pulse_out_to_tb is
  generic (
    MAX_DELAY : natural := 300);

  port (
    sysclk    : in  std_logic;
    n_reset   : in  std_logic;
    pulse_out : out std_logic;
    restart   : in  std_logic
    );


end pulse_out_to_tb;

architecture pulse_out_RTL of pulse_out_to_tb is
  type STATE_TYPE is (START, END_P);
  signal state_reg, state_next         : STATE_TYPE;
  signal count_next, count_reg         : natural range 0 to MAX_DELAY;
  signal pulse_out_reg, pulse_out_next : std_logic;
  
begin  -- architecture pps_delay_RTL


  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      state_reg     <= START;
      count_reg     <= 0;
      pulse_out_reg <= '0';
    elsif rising_edge(sysclk) then
      state_reg     <= state_next;
      count_reg     <= count_next;
      pulse_out_reg <= pulse_out_next;
    end if;
  end process;



  process(count_reg,
          state_reg,
          restart)
  begin

    pulse_out_next <= '0';
    state_next     <= state_reg;
    count_next     <= count_reg;

    case state_reg is

      when START =>
        count_next <= count_reg + 1;
        if (count_reg = MAX_DELAY-1) then
          pulse_out_next <= '1';
          count_next     <= 0;
          state_next     <= END_P;
        end if;

      when END_P =>
        if restart = '1' then
          state_next <= START;
        end if;
    end case;
    
  end process;

  pulse_out <= pulse_out_reg;

end architecture pulse_out_RTL;

