-- LCD_DRV.vhd
---------------------------------------------------------------
--  LCD driver for 2-lines LCD displays with controller
---------------------------------------------------------------
-- Derived from an original driver found at University of Alberta.
--
-- Author : B. Cuzeau
-- http://www.alse-fr.com
-- Tested on NIOS board.
--
-- Design notes :
--   * Implements an continuous overwrite Line1 -> Line2 ->Line1...
--   * No effort made to read from the LCD controller :
--   * All is based on delays supposed to match execution time
--     from the Data sheet (the LCD busy flag is not tested)
--   * A FormFeed (0Ch = Ctrl-L) clears the screen.
--
-- Possible enhancements :
--   * Interpreting other ASCII codes as commands.

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ------------------------------
    Entity LCD_DRV is
-- ------------------------------
  port( Clk  : in std_logic;                      -- System Clock
        Rst  : in std_logic;                      -- asynchronous Reset, active high

        Tick : in std_logic;                      -- Tick at 250 kHz (one clock cycle long)

        Din  : in std_logic_vector (7 downto 0);  -- Input data
        Dav  : in std_logic;                      -- Write Data command (1 clock cycle)

        Busy    : out   std_logic;                -- '1' if device busy

        -- LCD signals
        Dout    : inout std_logic_vector(7 downto 0); -- LCD data is a bidirectional bus...
        Lcd_Sel : out   std_logic;                -- LCD register select
        Lcd_Rw  : out   std_logic;                -- LCD Read / nWrite
        Lcd_En  : out   std_logic                 -- LCD Enable
        );
end LCD_DRV;


-- ------------------------------
    Architecture RTL of LCD_DRV is
-- ------------------------------

  type State_type is (Boot, Initial, Display, Entrymode, Clear,
                      Address_set, Waiting, Verify, Putchar, Homecursor);
  signal State : State_type;

  -- Function set for 8-bit data transfer and 2-line display
  constant SET   : std_logic_vector(7 downto 0) := "00111100";  -- 0011 N F xx

  -- Display ON, with cursor.**I set the last digit to one so the cursor does blink**
  constant DON   : std_logic_vector(7 downto 0) := "00001111";

  -- Set Entry Mode to increment cursor automatically after each character displayed.
  --**If the last digit is set to 1, then the whole display is shifted to the left.**
  constant SEM   : std_logic_vector(7 downto 0) := "00000110";

  -- Clear screen command.
  constant CLR   : std_logic_vector(7 downto 0) := "00000001";

  -- DD RAM address set
  constant DDRAS : std_logic_vector(7 downto 0) := "10000000";

  -- Home cursor
  constant HOME1 : std_logic_vector(7 downto 0) := "00000010"; -- set addr to Beg of line 1
  constant HOME2 : std_logic_vector(7 downto 0) := "11000000"; -- set addr to Beg of line 2

-- Timing Constants :

  constant Big_delay    : integer := 7500;  -- 30 ms
  constant Clr_delay    : integer := 500;   -- 2 ms
  constant Small_delay  : integer := 12;    -- > 39 us after E down
  constant En_delay     : integer := 2;
  constant LastPosition : integer := 16;

  signal DavM  : std_logic;
  signal DataM : std_logic_vector (7 downto 0);
  signal Position : integer range 0 to 32;
  signal Count    : integer range 0 to Big_delay;

begin

  Lcd_Rw <= '0';                        -- always in Write mode...


  process (Clk, Rst)

  begin

    if Rst = '1' then
      State    <= Boot;
      Position <= 0;
      Count    <= 0;
      DavM     <= '0';
      Lcd_En   <= '0';
      Lcd_Sel  <= '1';
      Busy     <= '1';
      Dout     <= (others=>'0');

    elsif rising_edge(Clk) then

      if Dav = '1' then
        DavM  <= '1';
        DataM <= Din;
        Busy  <= '1';
      end if;

      if Tick = '1' then

        case State is

          when Boot =>                  -- Power up wait 30 ms
            Lcd_Sel  <= '1';
            Lcd_En   <= '0';
            Busy <= '1';
            if Count = Big_delay then
              Lcd_Sel <= '0';
              Count <= 0;
              State <= Initial;
            else
              Count <= Count + 1;
            end if;


          when Initial =>               -- Set Function & Mode
            Dout    <= SET;
            Lcd_Sel <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Small_delay then
              State <= EntryMode;
              Count <= 0;
            else
              Count <= Count+1;
            end if;


          when EntryMode =>             -- set Entry Mode,
            Dout    <= SEM;
            Lcd_Sel <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Small_delay then
              State <= Display;
              Count <= 0;
            else
              Count <= Count+1;
            end if;


          when Display =>               -- set Display ON
            Dout    <= DON;
            Lcd_Sel <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Small_delay then
              State <= Clear;
              Count <= 0;
            else
              Count <= Count+1;
            end if;

          when Clear =>                 -- Clear the screen
            Dout     <= CLR;
            Position <= 0;
            Lcd_Sel  <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Clr_delay then
              Count <= 0;
              State <= Address_set;
            else
              Count <= Count+1;
            end if;

          when Address_set =>           -- DD RAM address set
            Dout    <= DDRAS;
            Lcd_Sel <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Small_delay then
              State <= Waiting;
              Count <= 0;
            else
              Count <= Count+1;
            end if;

          when Waiting =>               -- Waits for input
            if DavM = '1' then
              DavM    <= '0';
              State   <= Verify;
              Lcd_Sel <= '1';
            else
              Busy <= '0';
            end if;

          when Verify =>
              if DataM = x"0C" then     -- FormFeed => Clear Screen
                State <= Clear;
              elsif Position = 16 then
                Dout     <= HOME2;
                State    <= HomeCursor;
              elsif Position = 32 then
                Position <= 0;
                Dout     <= HOME1;
                State    <= HomeCursor;
              else
                Dout  <= DataM;
                State <= Putchar;
              end if;

          when Putchar =>               -- Display the character on the LCD
            Lcd_Sel <= '1';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Small_delay then
              Position <= Position + 1;
              Count    <= 0;
              State    <= Waiting;
            else
              Count <= Count + 1;
            end if;

          when HomeCursor =>
            Lcd_Sel <= '0';
            if Count = 1 then
              Lcd_En <= '1';
            elsif Count = En_delay then
              Lcd_En <= '0';
            end if;
            if Count = Clr_delay then
              Dout  <= DataM;
              State <= Putchar;
              Count <= 0;
            else
              Count <= Count+1;
            end if;

        end case;
      end if;
    end if;
  end process;

end RTL;
