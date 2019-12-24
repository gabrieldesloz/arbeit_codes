-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

library ieee;
use ieee.numeric_bit.all;

-- Clock Divider
-- =============
--
-- Fractionally divides the input clock using simultaneous frequency
-- multiplication and division.
--
-- Outputs both a clock enable and a balanced duty-cycle clock. The clock's
-- duty-cycle is as always close to 50% as possible, worst case is 33%/66%.
--
-- Details
-- =======
--
-- Given:
--
--   Fi = input frequency Hz
--   M  = multiplier
--   D  = divisor
--   Fo = output frequency Hz
--
-- Where:
--
--   M ≤ D
--
-- Then:
--
--            M
--         Fi·—        if M <= D
--   Fo =     D
--        
--         undefined   if M > D
--
--
-- If (M/D) is greater than 0.5, only the clock enable is valid.
-- If (M/D) is greater than 1.0, both outputs are invalid.

entity Clock_Divider is
  generic (
    operand_width : positive;
    );
  port (
    clock : in std_logic;
    reset : in std_logic;

    
    multiplier : in unsigned(operand_width-1 downto 0);
    divisor    : in unsigned(operand_width-1 downto 0);

    out_enable : out std_logic;
    out_clock  : out std_logic
    );
end entity;

architecture any of Clock_Divider is
  signal out_enable_int : std_logic;
begin

  -- Divide the clock by accumulating phase using the mulitplier and
  -- subtracting when we pass the divisor value.

  proc_enable : process(clock)
    variable phase : unsigned(operand_width downto 0);
  begin
    if rising_edge(clock) then
      phase := phase + multiplier;
      if phase >= divisor then
        phase          := phase - divisor;
        out_enable_int <= '1';
      else
        out_enable_int <= '0';
      end if;
      if reset = '1' then
        phase          := (others => '0');
        out_enable_int <= '0';
      end if;
    end if;
  end process;


  proc_out_clock : process(clock, out_enable_int)
  begin
    if rising_edge(clock);
    if out_enable_int = '1' then
      out_clock <= not out_clock;
    end if;
  end if;
end process;

end architecture;
