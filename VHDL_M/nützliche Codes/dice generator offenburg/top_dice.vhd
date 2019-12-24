-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Hinweis
-- Author      : DesLoz
-- Company     : Desloz
--
-------------------------------------------------------------------------------
--
-- File        : c:\Forschung\Codes\forschung\Hinweis\compile\top_dice.vhd
-- Generated   : Fri Nov 18 12:25:33 2011
-- From        : c:\Forschung\Codes\forschung\Hinweis\src\proj_dice\top_dice.bde
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


entity top_dice is
  port(
       clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       melody_enable : in STD_LOGIC;
       melody_select : in STD_LOGIC;
       push_button : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       tick_enable : in STD_LOGIC;
       a_f : out STD_LOGIC;
       b_e : out STD_LOGIC;
       c_d : out STD_LOGIC;
       g : out STD_LOGIC;
       speaker : out STD_LOGIC;
       time_out : out STD_LOGIC
  );
end top_dice;

architecture top_dice of top_dice is

---- Component declarations -----

component clock_generator_dice
  port (
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
end component;
component dice_generator
  generic(
       n : natural := 6;
       p : natural := 8
  );
  port (
       clk : in STD_LOGIC;
       pulse_32 : in STD_LOGIC;
       pulse_500 : in STD_LOGIC;
       push_button : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       a_f : out STD_LOGIC;
       b_e : out STD_LOGIC;
       c_d : out STD_LOGIC;
       g : out STD_LOGIC;
       one : out STD_LOGIC;
       six : out STD_LOGIC;
       start_melody : out STD_LOGIC;
       start_tick : out STD_LOGIC
  );
end component;
component fsm_sound_gen
  port (
       clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       melody_enable : in STD_LOGIC;
       melody_select : in STD_LOGIC;
       one : in STD_LOGIC;
       pulse_1000 : in STD_LOGIC;
       pulse_8 : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       six : in STD_LOGIC;
       start_melody : in STD_LOGIC;
       start_tick : in STD_LOGIC;
       tick_enable : in STD_LOGIC;
       tone_4000 : in STD_LOGIC;
       tone_5333 : in STD_LOGIC;
       tone_6400 : in STD_LOGIC;
       finish : out STD_LOGIC;
       speaker : out STD_LOGIC
  );
end component;
component fsm_top_dice
  port (
       clk : in STD_LOGIC;
       finish : in STD_LOGIC;
       push_button : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       speaker_int : in STD_LOGIC;
       time_out_int : in STD_LOGIC;
       push_button_int : out STD_LOGIC;
       reset_int : out STD_LOGIC;
       speaker : out STD_LOGIC;
       time_out : out STD_LOGIC
  );
end component;
component start_melody_reg
  port (
       clk : in STD_LOGIC;
       pulse_8 : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       start_melody_int : in STD_LOGIC;
       start_melody : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal finish : STD_LOGIC;
signal one : STD_LOGIC;
signal pulse_1000 : STD_LOGIC;
signal pulse_2000 : STD_LOGIC;
signal pulse_32 : STD_LOGIC;
signal pulse_500 : STD_LOGIC;
signal pulse_8 : STD_LOGIC;
signal push_button_int : STD_LOGIC;
signal reset_int : STD_LOGIC;
signal six : STD_LOGIC;
signal speaker_int : STD_LOGIC;
signal start_melody : STD_LOGIC;
signal start_melody_int : STD_LOGIC;
signal start_tick : STD_LOGIC;
signal time_out_int : STD_LOGIC;
signal tone_4000 : STD_LOGIC;
signal tone_5333 : STD_LOGIC;
signal tone_6400 : STD_LOGIC;

---- Configuration specifications for declared components 

for U3 : fsm_sound_gen use entity work.fsm_sound_gen(fsm_sound_gen);
for U5 : fsm_top_dice use entity work.fsm_top_dice(fsm_top_dice);

begin

----  Component instantiations  ----

U1 : dice_generator
  port map(
       a_f => a_f,
       b_e => b_e,
       c_d => c_d,
       clk => clk,
       g => g,
       one => one,
       pulse_32 => pulse_32,
       pulse_500 => pulse_500,
       push_button => push_button_int,
       reset_n => reset_int,
       six => six,
       start_melody => start_melody_int,
       start_tick => start_tick
  );

U2 : clock_generator_dice
  port map(
       clk => clk,
       enable => enable,
       pulse_1000 => pulse_1000,
       pulse_2000 => pulse_2000,
       pulse_32 => pulse_32,
       pulse_500 => pulse_500,
       pulse_8 => pulse_8,
       reset_n => reset_int,
       time_out => time_out_int,
       tone_4000 => tone_4000,
       tone_5333 => tone_5333,
       tone_6400 => tone_6400
  );

U3 : fsm_sound_gen
  port map(
       clk => clk,
       enable => enable,
       finish => finish,
       melody_enable => melody_enable,
       melody_select => melody_select,
       one => one,
       pulse_1000 => pulse_1000,
       pulse_8 => pulse_8,
       reset_n => reset_int,
       six => six,
       speaker => speaker_int,
       start_melody => start_melody,
       start_tick => start_tick,
       tick_enable => tick_enable,
       tone_4000 => tone_4000,
       tone_5333 => tone_5333,
       tone_6400 => tone_6400
  );

U4 : start_melody_reg
  port map(
       clk => clk,
       pulse_8 => pulse_8,
       reset_n => reset_int,
       start_melody => start_melody,
       start_melody_int => start_melody_int
  );

U5 : fsm_top_dice
  port map(
       clk => clk,
       finish => finish,
       push_button => push_button,
       push_button_int => push_button_int,
       reset_int => reset_int,
       reset_n => reset_n,
       speaker => speaker,
       speaker_int => speaker_int,
       time_out => time_out,
       time_out_int => time_out_int
  );


end top_dice;
