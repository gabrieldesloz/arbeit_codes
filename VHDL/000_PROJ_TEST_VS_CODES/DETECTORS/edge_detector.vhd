library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
  port (
    n_reset  : in  std_logic;
    sysclk   : in  std_logic;
    f_in     : in  std_logic;
    pos_edge : out std_logic
    );
end edge_detector;
------------------------------------------------------------
architecture edge_detector_RTL of edge_detector is


  signal old_f : std_logic;


begin

--Processes

  process (sysclk, n_reset)
  begin
    if (n_reset = '0') then
      pos_edge <= '0';
      old_f    <= '0';
    elsif falling_edge(sysclk) then
      if (f_in /= old_f) and (f_in = '1') then
        pos_edge <= '1';
      else
        pos_edge <= '0';
      end if;
      old_f <= f_in;
    end if;
  end process;

end edge_detector_RTL;
