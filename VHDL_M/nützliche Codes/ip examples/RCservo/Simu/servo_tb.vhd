-- SERVO_TB.vhd
-- ----------------------------------------------------------
-- VHDL Test Bench for Servo
-- ----------------------------------------------------------
-- (c) ALSE. http://www.alse-fr.com
-- Author : Bert Cuzeau
-- Date   : May 2003
-- Design Notes:

Library IEEE;
  use IEEE.Std_Logic_1164.all;
  use IEEE.Numeric_std.all;

entity SERVO_TB is end;

architecture TEST of SERVO_TB is

  constant FClock : positive := 10e6; -- 10 MHz
  constant Period : time := 1 sec / Fclock;
  signal Stopped  : boolean;

  signal Clk      : std_logic := '0';
  signal RST      : std_logic;
  signal Tick7us  : std_logic := '0';
  signal Start    : std_logic := '0';
  signal Posit    : std_logic_vector (7 downto 0) := x"FD";
  signal Done     : std_logic;
  signal Q        : std_logic;

-----
Begin -- Architecture
-----

UUT: entity work.SERVO
  port map( CLK     =>  CLK     ,
            RST     =>  RST     ,
            Tick    =>  Tick7us ,
            Start   =>  Start   ,
            Posit   =>  Posit   ,
            Done    =>  Done    ,
            Q       =>  Q      );

-- Clock, Reset, Tick7us and simulation end

Clk <= '0' when Stopped else not Clk after (Period / 2);
Rst <= '1', '0' after Period;
Stopped <= true after 90 ms;
Tick7us <= '0' when Stopped else not Tick7us after 7 us - Period - 1 ns, Tick7us after 7 us;

-- Loop back Done on Start (with a small delay for simulation)

process begin
  wait until Done='1';
  Posit <= std_logic_vector (unsigned(Posit)+3);
  wait for 10 us;
  wait until Clk='0'; Start   <= '0', '1' after Period, '0' after 2 * Period;
  wait until Done='0';
end process;

end;
