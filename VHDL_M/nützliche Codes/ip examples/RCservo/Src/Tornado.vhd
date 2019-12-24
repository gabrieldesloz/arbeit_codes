-- --------------------------------------
--  Tornado Top Level for R/C Servo Demo
-- --------------------------------------
-- (c) ALSE Bertrand CUZEAU - http://www.alse-fr.com
-- Contact : info@alse-fr.com
--

Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- -------------------------------------------------------------------------
    Entity tornado is
-- -------------------------------------------------------------------------
  port (   Clk           : in    std_logic; -- 60 MHe oscillator
           Reset_n       : in    std_logic; -- SW4, active low
           SW1           : in    std_logic; -- (active low)
           SW2           : in    std_logic; -- (active low)
           SW3           : in    std_logic; -- (active low)
           SevSeg        : out   std_logic_vector (0 to 7);     -- 7seg [a .. g, dp] active low
           Cdisp         : out   std_logic_vector (3 downto 0); -- Column select active low
           RCserv        : out   std_logic_vector (3 downto 0)  -- Servo drive active low
--        ;USB_D         : inout std_logic_vector (7 downto 0)  -- not used
       );
end entity tornado;

-- -----------------------------------------------------------------
    Architecture RTL of tornado is
-- -----------------------------------------------------------------

  signal R1n, RST : std_logic;
  signal Tick7us  : std_logic;
  signal Tick1ms  : std_logic;
  signal Q, Start : std_logic;
  signal Done     : std_logic;
  signal SW1r,SW2r: std_logic;
  signal SW3r     : std_logic;
  signal Posit    : unsigned(7 downto 0);
  signal Div5Hz   : integer range 0 to 250; -- ~5 Hz
  signal HexData  : std_logic_vector(3 downto 0);
  signal DispIdx  : integer range 0 to 1; -- instead of 0 to 3

-----\
Begin -- architecture
-----/

RCserv <= (others=>not Q); --drive 4 servos with same command

-- Reset & push buttons Resynchronization
SW1r <= not SW1 when rising_edge(Clk);
SW2r <= not SW2 when rising_edge(Clk);
SW3r <= not SW3 when rising_edge(Clk);
R1n  <= Reset_n when rising_edge(Clk);
RST  <= not R1n when rising_edge(Clk);

-- Frequency Divider instanciation
i_FDIV : entity work.FDIV
  generic map ( Fclock  => 60E6 )   -- 60 MHz
  port map ( Clk      => CLK,
             Rst      => RST,
             Tick7us  => Tick7us );

-- Servo Controller
RCS: Entity work.SERVO Port map (
      CLK   => Clk,
      RST   => Rst,
      Tick  => Tick7us,
      Start => Start,
      Posit => std_logic_vector(Posit),
      Done  => Done,
      Q     => Q     );

-- Start one pulse every 10 ms...
process (Clk,Rst)
  variable Offtime : integer range 0 to 15;
begin
  if Rst='1' then
    Start <= '0';
    OffTime := 0;
  elsif rising_edge(Clk) then
    Start <= '0';
    if Tick1ms = '1' then
      if Done = '1' then
        if OffTime = 8 then
          OffTime := 0;
          Start <= '1';
        else
          OffTime := OffTime + 1;
        end if;
      end if;
    end if;
  end if;
end process;

-- Command modified with Push Buttons
process (Clk,Rst)
begin
  if Rst='1' then
    Posit <= x"80";  -- 50% (halfway)
    Div5Hz <= 0;
  elsif rising_edge(Clk) then
    if Tick1ms='1' then
      if Div5Hz=0 then
        Div5Hz <= 80;   -- be a bit fast
        if SW1r='1' then -- Increment
          if Posit /= 0 then Posit<= Posit-1; end if;
        elsif SW2r='1' then -- Decrement
          if Posit /= 255 then Posit<= Posit+1; end if;
        elsif SW3r='1' then -- Zero
          Posit<= x"00";
        end if;
      else
        Div5Hz <= Div5Hz - 1;
      end if;
    end if;
  end if;
end process;

-- Multiplexed Display (2 digits used only)

process(HexData)
begin
  case HexData is
    when  x"0"  => SevSeg <= not "11111100";
    when  x"1"  => SevSeg <= not "01100000";
    when  x"2"  => SevSeg <= not "11011010";
    when  x"3"  => SevSeg <= not "11110010";
    when  x"4"  => SevSeg <= not "01100110";
    when  x"5"  => SevSeg <= not "10110110";
    when  x"6"  => SevSeg <= not "10111110";
    when  x"7"  => SevSeg <= not "11100000";
    when  x"8"  => SevSeg <= not "11111110";
    when  x"9"  => SevSeg <= not "11110110";
    when  x"A"  => SevSeg <= not "11101110";
    when  x"B"  => SevSeg <= not "00111110";
    when  x"C"  => SevSeg <= not "00011010";
    when  x"D"  => SevSeg <= not "01111010";
    when  x"E"  => SevSeg <= not "10011110";
    when  x"F"  => SevSeg <= not "10001110";
    when others => SevSeg <= (others => '-'); -- Ignored in this (full) case
  end case;
end process;

process (CLK, RST)
  variable div : integer range 0 to 127;  -- divide 7us to ~0.9 ms
begin
  if Rst = '1' then
    Cdisp <= "1110";
    DispIdx <= 0;
    div := 0;
    Tick1ms <= '0';
  elsif rising_edge (Clk) then
    Tick1ms <= '0';
    if Tick7us='1' then
      if div /= 0 then
        div := div - 1;
      else
        Tick1ms <= '1';
        div := 127;
        if DispIdx=1 then  -- we need only the two LS digits
          Cdisp <= "1110";
          DispIdx <= 0;
        else
          DispIdx <= 1;
          Cdisp <= "1101";
        end if;
      end if;
    end if;
  end if;
end process;

HexData <= std_logic_vector(Posit(3 downto 0)) when DispIdx=0
      else std_logic_vector(Posit(7 downto 4));


end architecture RTL;