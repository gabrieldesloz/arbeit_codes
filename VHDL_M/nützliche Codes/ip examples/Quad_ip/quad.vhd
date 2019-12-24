-- QUAD.vhd
-- --------------------------------------------
--  Quadrature Encoder
-- --------------------------------------------
-- (c) 2004-2009 - Bert Cuzeau, ALSE
-- http://www.alse-fr.com
-- Contact : info@alse-fr.com
-- Notes :
-- * A and B are resynchronized internally by a single FF each
-- * There is a delay (BootDly) before the decoder starts working
-- * FSM State encoding could be binary, one-hot or custom (like here)
--   make sure your synthesis tool does not re-encode or ignore the encoding.
-- * Implemented as re-synchronized, one-process, Mealy State machine.
-- * The counter size can be modified directly in the port declaration.
-- * Cnt (n downto 2) returns the position in full turns.

Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- --------------------------------------------
    Entity QUAD is
-- --------------------------------------------
  port( Rst : in  std_logic;  -- Asynchronous Reset
        Clk : in  std_logic;  -- System Clock
        A,B : in  std_logic;  -- Quadrature inputs (resynch'ed internally)
        Cnt : out std_logic_vector; -- Position is an unconstrained vector
        Dir : out std_logic); -- Clockwise information (of last step)
end entity QUAD;


-- --------------------------------------------
    Architecture MealyR of QUAD is
-- --------------------------------------------
constant BootDly : natural := 8;
subtype SLV2 is std_logic_vector (0 to 1);
attribute enum_encoding : string;

type   state_t is (Boot, S00, S01, S10, S11);
attribute enum_encoding of state_t : type is "000 100 101 110 111";
signal state : state_t;

signal Count : unsigned (Cnt'range);
signal A_B   : SLV2;
signal BootDlyCnt : integer range 0 to BootDly-1;

-----\
Begin -- Architecture
-----/

Cnt <= std_logic_vector(Count); -- cannot read output

-- Resynchronize the inputs (critical !)
A_B <= A & B when rising_edge(Clk);

process (Rst,Clk)
begin
  if Rst='1' then
    State <= Boot;
    Count <= x"00";
    Dir   <= '0';
    BootDlyCnt <= BootDly-1;  -- Clock cycles after reset before enabled

  elsif rising_edge(Clk) then

    case State is

      when Boot =>
        if BootDlyCnt /= 0 then
          BootDlyCnt <= BootDlyCnt - 1;
        else
          case A_B is
              when "00" => State <= S00;
              when "10" => State <= S10;
              when "11" => State <= S11;
              when "01" => State <= S01;
              when others => null;
          end case;
        end if;

      when S00 =>
        case A_B is
          when "10" => State <= S10;
                       Count <= Count+1;
                       Dir   <= '1';
          when "11" => null; -- possible : State <= S11;
          when "01" => State <= S01;
                       Count <= Count-1;
                       Dir   <= '0';
          when others => null;
        end case;

      when S10 =>
        case A_B is
          when "00" => State <= S00;
                       Count <= Count-1;
                       Dir   <= '0';
          when "11" => State <= S11;
                       Count <= Count+1;
                       Dir   <= '1';
          when "01" => null; -- possible : State <= S01;
          when others => null;
        end case;

      when S11 =>
        case A_B is
          when "10" => State <= S10;
                       Count <= Count-1;
                       Dir   <= '0';
          when "01" => State <= S01;
                       Count <= Count+1;
                       Dir   <='1';
          when "00" => null; -- possible : State <= S00;
          when others => null;
        end case;

      when S01 =>
        case A_B is
          when "11" => State <= S11;
                       Count <= Count-1;
                       Dir   <= '0';
          when "00" => State <= S00;
                       Count <= Count+1;
                       Dir   <= '1';
          when "10" => null; -- possible : State <= S10;
          when others => null;
        end case;

      when others =>
        State <= Boot; -- useless (ignored by synthesis)

    end case;
  end if;
end process;

end MealyR;