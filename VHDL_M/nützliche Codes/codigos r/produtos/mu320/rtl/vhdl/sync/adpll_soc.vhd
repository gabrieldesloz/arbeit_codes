
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adpll_soc is

-- Definition of incoming and outgoing signals.

  generic (
    D                   : natural;
    N                   : natural;
    DELTA_LIMIT         : natural;
    LIMIT_LO_SOC        : natural;
    DELTA_LIMIT_LOCKED  : natural;
    N_BITS_NCO_SOC      : natural;
    LIMIT_TIMER_SOC     : natural;
    SOC_TIME_SOC        : natural;
    LIMIT_LO_SOC_LOCKED : natural;
    STEP_LOW_BITS       : natural;
    STEP_NORMAL_BITS    : natural;
    LIMIT_HI_SOC        : natural;
    LIMIT_HI_SOC_LOCKED : natural;
    TIMEOUT_PPS         : natural;
    PERIOD_FREQ_MAX     : natural;
    PERIOD_FREQ_MIN     : natural;
    FREQ_BITS           : natural;
    EDGE_TO_CHECK       : natural;
    PPS_DIFF            : natural;
    FAKE_DRIFT_VALUE    : natural;
    FM_MAX_DEVIATION    : natural;
    FAKE_DRIFT          : std_logic;
    FREQ_TOLERANCE      : natural;
    SYS_START_WAIT      : natural
    );

  port (

    EDGE_TO_RESET   : in std_logic_vector(FREQ_BITS-1 downto 0);
    K_DEFAULT_STD   : in std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
    STEP_LOW_SOC    : in std_logic_vector(STEP_LOW_BITS-1 downto 0);
    STEP_NORMAL_SOC : in std_logic_vector(STEP_NORMAL_BITS-1 downto 0);

  
    FREQUENCY_DEFAULT_STD : in  std_logic_vector(N-1 downto 0);
    CLK_FREQUENCY_STD     : in  std_logic_vector(D-1 downto 0);
    n_reset               : in  std_logic;
    sysclk                : in  std_logic;
    pps_pulse             : in  std_logic;
    irig_ok               : in  std_logic;
    locked                : out std_logic;
    start_conv            : out std_logic;
    virtual_pps           : out std_logic
    );


end adpll_soc;

architecture adpll_RTL of adpll_soc is

  signal k_out        : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal add_drift    : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal k_calculated : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal m_freq       : std_logic_vector(D-1 downto 0);
  signal locked_int   : std_logic;

  signal clear_dco           : std_logic;
  signal sync_soc_int        : std_logic;
  signal sync_pps_delayed    : std_logic;
  signal time_out            : std_logic;
  signal resync_pulse        : std_logic;
  signal clear_dco_edge_calc : std_logic;

  signal soc_timer_d2_var      : std_logic_vector(D-1 downto 0);
  signal limit_high_var        : std_logic_vector(D-1 downto 0);
  signal limit_high_locked_var : std_logic_vector(D-1 downto 0);


  attribute syn_keep                 : boolean;
  attribute syn_keep of resync_pulse : signal is true;


  signal reset_int : std_logic;


begin

  
  k_module_1 : entity work.k_module
    generic map (
      N                => N,
      D                => D,
      TIMEOUT_PPS      => TIMEOUT_PPS,
      N_BITS_NCO_SOC   => N_BITS_NCO_SOC,
      PERIOD_FREQ_MIN  => PERIOD_FREQ_MIN,
      PERIOD_FREQ_MAX  => PERIOD_FREQ_MAX,
      FM_MAX_DEVIATION => FM_MAX_DEVIATION,
      FREQ_TOLERANCE   => FREQ_TOLERANCE
      )
    port map (
      CLK_FREQUENCY_STD     => CLK_FREQUENCY_STD,
      FREQUENCY_DEFAULT_STD => FREQUENCY_DEFAULT_STD,
      K_DEFAULT_STD         => K_DEFAULT_STD,
      n_reset               => reset_int,
      sysclk                => sysclk,
      pps_pulse             => pps_pulse,
      time_out              => time_out,
      k_calculated          => k_calculated,
      m_freq                => m_freq
      );


  dco_inst : entity work.dco_soc
    generic map(
      N_BITS_NCO_SOC => N_BITS_NCO_SOC
      )  
    port map (
      n_reset    => reset_int,
      sysclk     => sysclk,
      sync       => clear_dco_edge_calc,
      freq       => add_drift,
      f_dco      => open,
      -- edge
      f_dco_edge => sync_soc_int
      );


  edge_calculator_1 : entity work.edge_calculator
    generic map (
      D              => D,
      PPS_DIFF       => PPS_DIFF,
      FREQ_BITS      => FREQ_BITS,
      EDGE_TO_CHECK  => EDGE_TO_CHECK,
      TIMEOUT_PPS    => TIMEOUT_PPS,
      SYS_START_WAIT => SYS_START_WAIT
      )
    port map (
      EDGE_TO_RESET     => EDGE_TO_RESET,
      clear_dco_in      => clear_dco,
      clear_dco_out     => clear_dco_edge_calc,
      set_edge_to_reset => pps_pulse,
      signal_in         => sync_soc_int,
      sysclk            => sysclk,
      n_reset           => n_reset,
      --para k_controller e virtual_pps
      resync_pulse      => resync_pulse,
      -- edge da frequencia gerada pelo dco
      sync_soc_int_in   => sync_soc_int,
      -- pulso frequencia --> externo
      sync_soc_int_out  => start_conv
      );

  k_controller_soc_inst : entity work.k_controller_soc
    generic map (
      D => D,

      STEP_LOW_BITS    => STEP_LOW_BITS,
      STEP_NORMAL_BITS => STEP_NORMAL_BITS,

      LIMIT_LO_SOC        => LIMIT_LO_SOC,
      N_BITS_NCO_SOC      => N_BITS_NCO_SOC,
      LIMIT_TIMER_SOC     => LIMIT_TIMER_SOC,
      SOC_TIME_SOC        => SOC_TIME_SOC,
      LIMIT_LO_SOC_LOCKED => LIMIT_LO_SOC_LOCKED,
      LIMIT_HI_SOC        => LIMIT_HI_SOC,
      LIMIT_HI_SOC_LOCKED => LIMIT_HI_SOC_LOCKED)
    port map (

      STEP_LOW_SOC    => STEP_LOW_SOC,
      STEP_NORMAL_SOC => STEP_NORMAL_SOC,

      soc_timer_d2_var      => soc_timer_d2_var,
      limit_high_var        => limit_high_var,
      limit_high_locked_var => limit_high_locked_var,
      n_reset               => reset_int,
      sysclk                => sysclk,
      -- antigamente sync_soc_int
      sync_soc              => resync_pulse,
      sync_pps              => pps_pulse,
      irig_ok               => irig_ok,
      locked                => locked_int,
      K_DEFAULT_STD_SOC     => K_DEFAULT_STD,
      k_calculated          => k_calculated,
      k_out                 => k_out,
      clear_dco             => clear_dco,
      time_out              => time_out,
      region_k_controller   => open,
      pps_drift_p_s         => open
      );

  reset_int   <= n_reset;
  virtual_pps <= resync_pulse;
  locked      <= locked_int;


  variable_adjust_1 : entity work.variable_adjust
    generic map (
      D                   => D,
      DELTA_LIMIT         => DELTA_LIMIT,
      DELTA_LIMIT_LOCKED  => DELTA_LIMIT_LOCKED,
      N_BITS_NCO_SOC      => N_BITS_NCO_SOC,
      SOC_TIME_SOC        => SOC_TIME_SOC,
      LIMIT_HI_SOC        => LIMIT_HI_SOC,
      LIMIT_HI_SOC_LOCKED => LIMIT_HI_SOC_LOCKED)
    port map (

      pps_pulse             => pps_pulse,
      n_reset               => n_reset,
      sysclk                => sysclk,
      m_freq                => m_freq,
      soc_timer_d2_var      => soc_timer_d2_var,
      limit_high_var        => limit_high_var,
      limit_high_locked_var => limit_high_locked_var);




  
  
  add_drift <= std_logic_vector(unsigned(k_out) + FAKE_DRIFT_VALUE) when
               (FAKE_DRIFT = '1' and time_out = '1') else k_out;


end adpll_RTL;
