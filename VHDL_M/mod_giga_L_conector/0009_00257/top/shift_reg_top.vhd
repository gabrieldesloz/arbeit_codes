
library ieee;
use ieee.std_logic_1164.all;


entity shift_reg_top is
  
  generic
    (
      N : natural := 32
      );

  port
    (
      clk_ext  : in  std_logic;
      q_vector : out std_logic_vector(N-1 downto 0)
      );


end shift_reg_top;

architecture arq of shift_reg_top is
  
  signal ena_pulse    : std_logic;
  signal reset_gen    : std_logic;
  signal q            : std_logic;
  signal q_vector_tmp : std_logic_vector(q_vector'range);

begin


  clock_div : entity work.clock_div
    
    generic map
    (
      divider => 3_000_000
      )  
    port map (
      clock => clk_ext,
      q     => q,
      carry => ena_pulse,
      ena   => '1',
      reset => reset_gen
      );


  p_random_32 : entity work.p_random_32
    port map
    (
      clk                      => clk_ext,
      n_reset                  => reset_gen,
      random_vect(31 downto 3) => q_vector_tmp(31 downto 3),
      random_vect(2 downto 0)  => open,
      ena                      => ena_pulse
      );

  q_vector_tmp(0) <= reset_gen;
  q_vector_tmp(1) <= ena_pulse;
  q_vector_tmp(2) <= q;


  reset_generator : entity work.reset_generator
    generic map
    (
      MAX => 20
      )  
    port map
    (
      clk     => clk_ext,
      n_reset => reset_gen

      );

  

  q_vector <=  q_vector_tmp; 
   
  --chipscope_1 : entity work.chipscope
  --  port map (
  --    clk   => clk_ext,
  --    TRIG0 => q_vector_tmp);




end arq;
