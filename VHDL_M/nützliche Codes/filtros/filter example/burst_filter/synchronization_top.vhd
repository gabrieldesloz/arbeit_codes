

library ieee;
use ieee.std_logic_1164.all;
use work.rl131_constants.all;


-------------------------------------------------------------------------------

entity synchronization_top is

end entity synchronization_top;



-------------------------------------------------------------------------------

architecture synchronization_top_RTL of synchronization_top is

  signal sysclk                     : std_logic := '1';
  signal reset                      : std_logic := '1';
  signal mdat1, mdat2, mdat3, mdat4 : std_logic_vector(((N_CHANNELS_ANA*N_BITS_ADC)/4)-1 downto 0);
  signal mdat                       : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC)-1 downto 0);
  signal n_reset                    : std_logic := '1';
  signal lsfr_clock                 : std_logic := '1';

  -- constants
  constant sys_clk_period    : time := 10 ns;
  constant lsfr_clock_period : time := 1 us;
  
begin


  -- clock generation
  sysclk <= not sysclk after sys_clk_period/2;

  -- clock generation
  lsfr_clock <= not lsfr_clock after lsfr_clock_period/2;



  bfilter_1 : entity work.bfilter
    port map (
      sysclk    => sysclk,
      reset_n   => n_reset,
      start     => '1',
      ready     => open,
      d_ana_in  => mdat,
      d_ana_out => open);


  -- gerador de numeros pseudo randomicos
  lfsr_1 : entity work.lfsr
    generic map (
      N         => 8,
      WITH_ZERO => 0)
    port map (
      SEED  => "00000110",
      clk   => lsfr_clock,
      reset => reset,
      q     => mdat1);


  -- gerador de numero pseudo_randomico
  lfsr_2 : entity work.lfsr
    generic map (
      N         => 8,
      WITH_ZERO => 0)
    port map (
      SEED  => "00000001",
      clk   => lsfr_clock,
      reset => reset,
      q     => mdat2);


  -- gerador de numero pseudo_randomico
  lfsr_3 : entity work.lfsr
    generic map (
      N         => 8,
      WITH_ZERO => 0)
    port map (
      SEED  => "00001001",
      clk   => lsfr_clock,
      reset => reset,
      q     => mdat3);



  -- gerador de numero pseudo_randomico
  lfsr_4 : entity work.lfsr
    generic map (
      N         => 8,
      WITH_ZERO => 0)
    port map (
      SEED  => "00001010",
      clk   => lsfr_clock,
      reset => reset,
      q     => mdat4);

  mdat  <= mdat1 & mdat2 & mdat3 & mdat4;
  reset <= not n_reset;


-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => n_reset);


end architecture synchronization_top_RTL;

