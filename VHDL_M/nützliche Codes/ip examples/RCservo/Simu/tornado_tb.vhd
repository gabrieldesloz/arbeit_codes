-- Tornado_TB.vhd
-- ----------------------------------------------------------
--  VHDL Test Bench for Servo
-- ----------------------------------------------------------
-- (c) ALSE. http://www.alse-fr.com
-- Author : Bert Cuzeau
-- Date   : July 2009 last revision

Library IEEE;
  use IEEE.Std_Logic_1164.all;
  use IEEE.Numeric_std.all;

entity Tornado_TB is end;

architecture TEST of Tornado_TB is

  constant FClock : positive := 60e6; -- 60 MHz
  constant Period : time := 1 sec / Fclock;
  signal Stopped  : boolean;
  signal Clk      : std_logic := '0';
  signal Reset_n  : std_logic;
  signal SW1      : std_logic := '1';
  signal SW2      : std_logic := '1';
  signal SW3      : std_logic := '1';
  signal SevSeg   : std_logic_vector (0 to 7);
  signal Cdisp    : std_logic_vector (3 downto 0);
  signal RCserv   : std_logic_vector (3 downto 0);

-----
Begin -- Architecture
-----

UUT: entity work.tornado port map (
  Clk     => Clk     ,
  Reset_n => Reset_n ,
  SW1     => SW1     ,
  SW2     => SW2     ,
  SW3     => SW3     ,
  SevSeg  => SevSeg  ,
  Cdisp   => Cdisp   ,
  RCserv  => RCserv   );

-- Clock, Reset, Tick7us and simulation end

Clk     <= '0' when Stopped else not Clk after (Period / 2);
Reset_n <= '0', '1' after Period;
SW3     <= '0' after 20 ms;
Stopped <= true after 110 ms;

end;
