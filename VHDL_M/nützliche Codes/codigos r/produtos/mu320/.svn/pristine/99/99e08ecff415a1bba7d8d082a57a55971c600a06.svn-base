
-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;


entity k_module is

  generic (
    N                : natural;
    D                : natural;
    TIMEOUT_PPS      : natural;
    N_BITS_NCO_SOC   : natural;
    PERIOD_FREQ_MIN  : natural;
    PERIOD_FREQ_MAX  : natural;
    FM_MAX_DEVIATION : natural;
    FREQ_TOLERANCE   : natural
    );

  port (
    CLK_FREQUENCY_STD     : in  std_logic_vector((D-1) downto 0);
    FREQUENCY_DEFAULT_STD : in  std_logic_vector(N-1 downto 0);
    K_DEFAULT_STD         : in  std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
    n_reset               : in  std_logic;
    sysclk                : in  std_logic;
    pps_pulse             : in  std_logic;
    time_out              : out std_logic;
    k_calculated          : out std_logic_vector(N_BITS_NCO_SOC - 1 downto 0);
    m_freq                : out std_logic_vector(D-1 downto 0)

    );


end k_module;

architecture ARQ1 of k_module is

  signal m_freq_int : std_logic_vector(D-1 downto 0);

begin

  m_freq <= m_freq_int;


  frequency_meter_inst : entity work.frequency_meter
    generic map (
      D                => D,
      PERIOD_FREQ_MIN  => PERIOD_FREQ_MIN,
      PERIOD_FREQ_MAX  => PERIOD_FREQ_MAX,
      TIMEOUT_PPS      => TIMEOUT_PPS,
      FM_MAX_DEVIATION => FM_MAX_DEVIATION,
      FREQ_TOLERANCE   => FREQ_TOLERANCE
      )
    port map (
      CLK_FREQUENCY_STD   => CLK_FREQUENCY_STD,
      m_freq              => m_freq_int,
      sysclk              => sysclk,
      n_reset             => n_reset,
      start_stop          => pps_pulse,
      time_out            => time_out
      );


  k_calculator_soc_1 : entity work.k_calculator_soc
    generic map (
      N              => N,
      D              => D,
      N_BITS_NCO_SOC => N_BITS_NCO_SOC
      )
    port map (
      K_DEFAULT_STD         => K_DEFAULT_STD,
      FREQUENCY_DEFAULT_STD => FREQUENCY_DEFAULT_STD,
      sysclk                => sysclk,
      n_reset               => n_reset,
      m_freq                => m_freq_int,
      k_out                 => k_calculated);



end ARQ1;



