-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Hinweis
-- Author      : DesLoz
-- Company     : Desloz
--
-------------------------------------------------------------------------------
--
-- File        : c:\Forschung\Codes\forschung\Hinweis\compile\dice_generator.vhd
-- Generated   : Thu Nov 17 17:23:42 2011
-- From        : c:\Forschung\Codes\forschung\Hinweis\src\proj_dice\dice_generator.bde
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


entity dice_generator is
  generic(
       n: natural:= 6; 
       p: natural:= 8 
  );
  port(
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
end dice_generator;

architecture dice_generator of dice_generator is

---- Component declarations -----

component accumulator
  generic(
       n : NATURAL := 6;
       p : NATURAL := 8
  );
  port (
       cin : in STD_LOGIC;
       clock : in STD_LOGIC;
       d : in STD_LOGIC_VECTOR(n-1 downto 0);
       e : in STD_LOGIC_VECTOR(p-1 downto 0);
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       reg_cout : out STD_LOGIC;
       reg_q : out STD_LOGIC_VECTOR(p-1 downto 0)
  );
end component;
component bin_counter_updown
  generic(
       MAX : NATURAL := 63;
       MIN : NATURAL := 0;
       N : INTEGER := 6
  );
  port (
       acc_carry : in STD_LOGIC;
       clock : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       up : in STD_LOGIC;
       carry : out STD_LOGIC;
       q : out STD_LOGIC_VECTOR(n-1 downto 0);
       zero : out STD_LOGIC
  );
end component;
component Decoder_dice
  port (
       clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       a_f : out STD_LOGIC;
       b_e : out STD_LOGIC;
       c_d : out STD_LOGIC;
       g : out STD_LOGIC;
       one : out STD_LOGIC;
       six : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal acc_carry : STD_LOGIC;
signal enable_decoder_dice : STD_LOGIC;
signal NET76 : STD_LOGIC;
signal zero : STD_LOGIC;
signal b1 : STD_LOGIC_VECTOR (n-1 downto 0);

---- Configuration specifications for declared components 

for U4 : decoder_dice use entity work.decoder_dice(Decoder_dice);

begin

----  Component instantiations  ----

U1 : accumulator
  generic map (
       n => n,
       p => p
  )
  port map(
       cin => '0',
       clock => clk,
       d => b1( n-1 downto 0 ),
       e => "00000000",
       enable => pulse_500,
       reg_cout => acc_carry,
       reg_q => open,
       reset => reset_n
  );

U3 : bin_counter_updown
  port map(
       acc_carry => acc_carry,
       carry => open,
       clock => clk,
       enable => pulse_32,
       q => b1( n-1 downto 0 ),
       reset => reset_n,
       up => push_button,
       zero => zero
  );

U4 : Decoder_dice
  port map(
       a_f => a_f,
       b_e => b_e,
       c_d => c_d,
       clk => clk,
       enable => enable_decoder_dice,
       g => g,
       one => one,
       reset_n => reset_n,
       six => six
  );

start_tick <= acc_carry and NET76;

NET76 <= not(push_button);

enable_decoder_dice <= acc_carry or push_button;


---- Terminal assignment ----

    -- Output\buffer terminals
	start_melody <= zero;


end dice_generator;
