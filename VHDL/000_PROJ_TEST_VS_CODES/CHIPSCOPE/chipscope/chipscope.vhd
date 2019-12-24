
library ieee;
use ieee.std_logic_1164.all;


entity chipscope is
  
  port
    (
      clk   : in std_logic;
      TRIG0 : in std_logic_vector(31 downto 0)

      );


end chipscope;

architecture ARQ of chipscope is

  signal CONTROL0 : std_logic_vector(35 downto 0);


  component chipscope_icon

    port (
      CONTROL0 : inout std_logic_vector(35 downto 0)
      );

  end component;

  component chipscope_ila
    port (
      CONTROL : inout std_logic_vector(35 downto 0);
      CLK     : in    std_logic;
      TRIG0   : in    std_logic_vector(31 downto 0));

  end component;

  
begin

  ILA : chipscope_ila
    port map (
      CONTROL => CONTROL0,
      CLK     => clk,
      TRIG0   => TRIG0);

  ICON : chipscope_icon
    port map (
      CONTROL0 => CONTROL0);





end ARQ;
