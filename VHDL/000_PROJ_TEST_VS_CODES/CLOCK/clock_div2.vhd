-- generical clock divider, for 
-- even and odd division factors
-- with enable, carry, and reset 
-- Gabriel Deschamps Lozano 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is

  generic(
    divider : natural := 2
    );

  port (
    clock    : in  std_logic;
    q        : out std_logic;
    carry    : out std_logic;
    ena      : in  std_logic;
    n_reset  : in  std_logic;
    clk_vect : out std_logic_vector(31 downto 0)

    );
end entity;

architecture divide of clock_div is     -- odd numbers

  -- function that determines whether the division factor is odd or even
  function odd (v : natural) return boolean is
    variable x : natural;
  begin
    x := v mod 2;
    if x = 1 then
      return true;
    else
      return false;
    end if;
  end function odd;

  signal cnt_next, cnt_reg           : integer range 0 to divider-1;
  signal div_temp_next, div_temp_reg : std_logic;
  signal carry_next, carry_reg       : std_logic;
  
begin

  process(clock, n_reset)
  begin
    if n_reset = '0' then
      div_temp_reg <= '1';
      cnt_reg      <= 0;
      carry_reg    <= '0';
    elsif rising_edge(clock) then
      if ena = '1' then
        div_temp_reg <= div_temp_next;
        cnt_reg      <= cnt_next;
        carry_reg    <= carry_next;
      end if;
    end if;
  end process;


  process(cnt_reg, div_temp_reg)
  begin
    -- the next line means that the carry
    -- signal will only last
    -- one clock period
    carry_next <= '0';

    if odd(divider) then
      -- odd case routine     
      -- mark space (3/2, 4/3, etc...) 
      if cnt_reg = (divider-1)/2 then
        div_temp_next <= not(div_temp_reg);
      else
        div_temp_next <= div_temp_reg;
      end if;
    else
      -- even case routine 
      if cnt_reg = (divider/2)-1 then
        div_temp_next <= not(div_temp_reg);
      else
        div_temp_next <= div_temp_reg;
      end if;
    end if;

    -- counter and carry logic
    if cnt_reg = divider-1 then
      carry_next    <= '1';
      cnt_next      <= 0;
      div_temp_next <= not(div_temp_reg);
    else
      cnt_next <= cnt_reg + 1;
    end if;

end process;

carry    <= carry_reg;
q        <= div_temp_reg;
clk_vect <= std_logic_vector(to_unsigned(cnt_reg,32));

end divide;
