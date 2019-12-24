-- SERVO.vhd
-- ---------------------------------------
--    R/C Servo Controller - Cascadable
-- ---------------------------------------
--
-- Author : (c) Bert Cuzeau A.L.S.E.
-- http://www.alse-fr.com
--
-- Purpose :
--   Generate a Pulse when Start is asserted while Done is true (previous pulse finished)
--   It's possible to chain several Generators (Done[i] -> Start[i+1]) and OR the outputs.
--   The pulse :
--    * Begin upon "Start"
--    * Fixed MinPulse µs @ '1'  (0.5 ms typically)
--    * + (Posit * 7 µs)  @ '1'
--    * then DeadTime     @ '0'
--    * Done goes '1'
--   Adjust MinPulse for your Servo (typically between 500 & 600)
--   Eg: Active Pulse width (at '1') is [0.5 .. 2.3] ms followed by 50 µs low
--
-- Block size = ~41 Logic Cells

Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ---------------------------------------
    Entity SERVO is
-- ---------------------------------------
      Port ( Clk     : In  std_logic;  -- main clock
             Rst     : In  std_logic;  -- asynch Reset
             Tick    : In  std_logic;  -- one clock period high, 7us repetition rate !
             Start   : In  std_logic;  -- Tested only when Done
             Posit   : in std_logic_vector (7 downto 0); -- Pulse length
             Done    : out std_logic;  -- indicates end of pulse after deadtime
             Q       : out std_logic   -- Servo PWM output
           );
end entity SERVO;

-- ---------------------------------------
    Architecture RTL of SERVO is
-- ---------------------------------------
constant MinPulse : positive := 500;  -- 0.5 ms min pulse
constant DeadTime : positive := 50;   -- 50 us dead time
function Max (a,b:integer) return integer is begin
  if a>b then return a; else return b; end if;
end function Max;
type   State_t is (Idle, Init, Pulse, Relax);
signal State   : State_t;
signal Count   : integer range 0 to Max (MinPulse,DeadTime);

-----\
Begin -- Architecture
-----/

Done <= '0' when State /= Idle or Start='1'
   else '1';

process (RST,CLK)
begin
  if RST='1' then
    Count <= 0;
    Q     <= '0';
    State <= Idle;

  elsif rising_edge (CLK) then

    case State is

      when Idle =>
        Q <= '0';
        if Start='1' then
          Count <= (MinPulse / 7) - 2; -- 0.60 ms minimal pulse
          State <= Init;
        end if;

      when Init =>
        if Tick='1' then
          Q <= '1';
          if Count /= 0 then
            Count <= Count - 1;
          else
            Count <=  to_integer(unsigned(Posit)); -- 255*7us = 1.785 ms
            State <= Pulse;                        -- -> 2.401 max length
          end if;
        end if;

      when Pulse =>
        if Tick='1' then
          if Count /= 0 then
            Count <= Count - 1;
          else
            Count <= (DeadTime / 7) - 1;
            Q <= '0';
            State <= Relax;
          end if;
        end if;

      when Relax =>
        if Tick='1' then
          if Count /= 0 then
            Count <= Count - 1;
          else
            State <= Idle;
          end if;
        end if;

    end case;

  end if;
end process;

end RTL;
