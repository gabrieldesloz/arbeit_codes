library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity clk_div_gen is
  generic (
    n   : natural;
    DIV : natural);
  
  port
    (
      clock   : in  std_logic;
      n_reset : in  std_logic;
      ext_ena : in  std_logic;
      CLK_EN  : out std_logic
      );

end clk_div_gen;

architecture ARQ1 of clk_div_gen is

  signal clk_vect : std_logic_vector(DIV-1 downto 0);

begin

  gen : for i in 0 to DIV-1 generate
    
    left : if i = 0 generate
      
      clock_div_1 : entity work.clock_div
        generic map (
          divider => n)
        port map (
          clock    => clock,
          q        => open,
          carry    => clk_vect(i),
          ena      => ext_ena,
          n_reset  => n_reset,
          clk_vect => open
          );     

    end generate left;

    right : if i > 0 and i <= DIV-1 generate

      clock_div_1 : entity work.clock_div
        generic map (
          divider => n)
        port map (
          clock    => clock,
          q        => open,
          carry    => clk_vect(i),
          ena      => clk_vect(i-1),
          n_reset  => n_reset,
          clk_vect => open
          );

    end generate right;
    
  end generate gen;

  clk_en <= clk_vect(clk_vect'high);

end ARQ1;
