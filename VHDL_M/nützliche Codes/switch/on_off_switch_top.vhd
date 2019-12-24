library ieee;
use ieee.std_logic_1164.all;

library work;


entity on_off_switch_top is

  generic (
    DEBOUNCE_MAX : natural
    );   

  port(
    in_button      : in  std_logic;
    clock, n_reset : in  std_logic;
    in_signal      : in  std_logic;
    out_signal     : out std_logic
    );

end on_off_switch_top;

architecture ARQ_RTL of on_off_switch_top is

  signal out_debounce      : std_logic;
  signal out_edge_debounce : std_logic;
  signal reg1, reg2        : std_logic;
  
  
begin

  process(clock, n_reset)
  begin
    if (n_reset = '0') then
      reg1 <= '0';
      reg2 <= '0';
    elsif rising_edge(clock) then
      reg1 <= in_button;
      reg2 <= reg1;
    end if;
  end process;


  debouncer_1 : entity work.debouncer
    generic map (
      DEBOUNCE_MAX => DEBOUNCE_MAX
      )
    port map (
      sysclk  => clock,
      reset_n => n_reset,
      input   => reg2,
      output  => out_debounce
      );

  pos_edge_mealy_1 : entity work.pos_edge_mealy
    port map (
      clock   => clock,
      n_reset => n_reset,
      level   => out_debounce,
      tick    => out_edge_debounce);


  on_off_switch_1 : entity work.on_off_switch
    port map (
      in_debounce => out_edge_debounce,
      clock       => clock,
      n_reset     => n_reset,
      in_signal   => in_signal,
      out_signal  => out_signal
      );

end ARQ_RTL;
