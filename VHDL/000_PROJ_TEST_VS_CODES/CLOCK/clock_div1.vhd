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
    clock : in  std_logic;
    q     : out std_logic;
    carry : out std_logic;
    ena   : in  std_logic;
    reset : in  std_logic
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

  signal cnt      : integer range 0 to divider-1 := 0;
  signal div_temp : std_logic                    := '1';

begin
  
  process (clock, reset)
  begin
    -- assynchronous reset
    if reset = '0' then
      div_temp <= '0';
      cnt      <= 0;
    elsif rising_edge(clock) then

      -- the next line means that the carry signal will only last
      -- one clock period
      carry <= '0';
      -- synchronous enable, doenst infer latch                                                 
      if ena = '1' then
        if odd(divider) then
                                        -- odd case routine     
                                        -- mark space (3/2, 5/4, etc...) 
          if cnt = (divider-1)/2 then
            div_temp <= not(div_temp);
          else
            div_temp <= div_temp;
          end if;
        else
                                        -- even case routine 
          if cnt = (divider/2)-1 then
            div_temp <= not(div_temp);
          else
            div_temp <= div_temp;
          end if;

        end if;

        -- carry generator logic
        if cnt = (divider-1) then
          carry <= '1';
        end if;


        -- counter logic
        if cnt = divider-1 then
          cnt      <= 0;
          div_temp <= not(div_temp);
        else
          cnt <= cnt + 1;
        end if;
        
      end if;


      q <= div_temp;
      
    end if;
    
  end process;
  
end divide;
