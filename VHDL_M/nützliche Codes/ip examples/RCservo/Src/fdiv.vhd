-- FDIV.vhd
-- ---------------------------------------
--    Freq Divider for R/C Servo
-- ---------------------------------------
-- (c) ALSE
-- http://www.alse-fr.com
--
Library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-- ---------------------------------------
    Entity FDIV is
-- ---------------------------------------
   Generic (  Fclock  : positive := 60E6); -- System Clock Freq in Hertz
      Port (  Clk     : In    std_logic;
              Rst     : In    std_logic;
              Tick7us : Out   std_logic  );
end entity FDIV;

-- ---------------------------------------
    Architecture RTL of FDIV is
-- ---------------------------------------

constant Divisor : positive := Fclock * 7 / 1E6; -- we want 142 kHz ticks
signal Count     : integer range 0 to Divisor-1;

-----
Begin
-----

process (Clk,Rst)
begin
  if Rst='1' then
    Count <= 0;
    Tick7us <= '0';
  elsif rising_edge (Clk) then
    Tick7us <= '0';
    if Count = 0  then
      Tick7us <= '1';
      Count <= Divisor-1;
    else
      Count <= Count - 1;
    end if;
  end if;
end process;

end architecture RTL;

