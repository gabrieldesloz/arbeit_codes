-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Hinweis
-- Author      : DesLoz
-- Company     : Desloz
--
-------------------------------------------------------------------------------
--
-- File        : c:\Forschung\Codes\forschung\Hinweis\compile\clock_generator_dice.vhd
-- Generated   : Fri Nov 11 11:06:51 2011
-- From        : c:\Forschung\Codes\forschung\Hinweis\src\proj_dice\clock_generator_dice.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;


entity clock_generator_dice is
  port(
       clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       pulse_1000 : out STD_LOGIC;
       pulse_2000 : out STD_LOGIC;
       pulse_32 : out STD_LOGIC;
       pulse_500 : out STD_LOGIC;
       pulse_8 : out STD_LOGIC;
       time_out : out STD_LOGIC;
       tone_4000 : out STD_LOGIC;
       tone_5333 : out STD_LOGIC;
       tone_6400 : out STD_LOGIC
  );
end clock_generator_dice;

architecture clock_generator_dice of clock_generator_dice is

---- Component declarations -----

component clock_div
  generic(
       divider : NATURAL := 2
  );
  port (
       clock : in STD_LOGIC;
       ena : in STD_LOGIC;
       reset : in STD_LOGIC;
       carry : out STD_LOGIC;
       q : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal carry6 : STD_LOGIC;
signal NET1425 : STD_LOGIC;
signal p1000_tmp : STD_LOGIC;
signal p2000_tmp : STD_LOGIC;
signal p32_tmp : STD_LOGIC;
signal p500_tmp : STD_LOGIC;
signal p8_tmp : STD_LOGIC;

---- Configuration specifications for declared components 

for U10 : clock_div use entity work.clock_div(divide);
for U3 : clock_div use entity work.clock_div(divide);
for U7 : clock_div use entity work.clock_div(divide);

begin

----  Component instantiations  ----

U1 : clock_div
  generic map (
       divider => 16
  )
  port map(
       carry => p2000_tmp,
       clock => clk,
       ena => enable,
       q => open,
       reset => reset_n
  );

U10 : clock_div
  generic map (
       divider => 2
  )
  port map(
       carry => open,
       clock => clk,
       ena => NET1425,
       q => tone_5333,
       reset => reset_n
  );

U2 : clock_div
  generic map (
       divider => 2
  )
  port map(
       carry => p1000_tmp,
       clock => clk,
       ena => p2000_tmp,
       q => open,
       reset => reset_n
  );

U3 : clock_div
  generic map (
       divider => 2
  )
  port map(
       carry => p500_tmp,
       clock => clk,
       ena => p1000_tmp,
       q => open,
       reset => reset_n
  );

U4 : clock_div
  generic map (
       divider => 16
  )
  port map(
       carry => p32_tmp,
       clock => clk,
       ena => p500_tmp,
       q => open,
       reset => reset_n
  );

U5 : clock_div
  generic map (
       divider => 4
  )
  port map(
       carry => p8_tmp,
       clock => clk,
       ena => p32_tmp,
       q => open,
       reset => reset_n
  );

U6 : clock_div
  generic map (
       divider => 64
  )
  port map(
       carry => carry6,
       clock => clk,
       ena => p8_tmp,
       q => open,
       reset => reset_n
  );

U7 : clock_div
  generic map (
       divider => 5
  )
  port map(
       carry => open,
       clock => clk,
       ena => enable,
       q => tone_6400,
       reset => reset_n
  );

U8 : clock_div
  generic map (
       divider => 3
  )
  port map(
       carry => NET1425,
       clock => clk,
       ena => enable,
       q => open,
       reset => reset_n
  );

U9 : clock_div
  generic map (
       divider => 8
  )
  port map(
       carry => open,
       clock => clk,
       ena => enable,
       q => tone_4000,
       reset => reset_n
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	pulse_1000 <= p1000_tmp;
	pulse_2000 <= p2000_tmp;
	pulse_32 <= p32_tmp;
	pulse_500 <= p500_tmp;
	pulse_8 <= p8_tmp;
	time_out <= carry6;


end clock_generator_dice;
