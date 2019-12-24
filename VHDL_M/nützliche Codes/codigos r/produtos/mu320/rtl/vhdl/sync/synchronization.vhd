library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


library work;
use work.mu320_constants.all;


entity synchronization is
  port (
    pps                          : in  std_logic;
    n_reset                      : in  std_logic;
    sysclk                       : in  std_logic;
    irig_ok                      : in  std_logic;
    locked                       : out std_logic;
    freq_out_80                  : out std_logic;
    freq_out_256                 : out std_logic;
    virtual_pps_80               : out std_logic;
    virtual_pps_256              : out std_logic;
    enable_pps                   : in  std_logic;
    freq_in_80                   : in  std_logic_vector(FREQ_BITS_80-1 downto 0);
    freq_in_256                  : in  std_logic_vector(FREQ_BITS_256-1 downto 0);
    frequency_default_std_in_80  : in  std_logic_vector(N-1 downto 0);
    frequency_default_std_in_256 : in  std_logic_vector(N-1 downto 0);
    k_default_std_in_80          : in  std_logic_vector(N_BITS_NCO-1 downto 0);
    k_default_std_in_256         : in  std_logic_vector(N_BITS_NCO-1 downto 0);
    step_low_in_80               : in  std_logic_vector(STEP_LOW_BITS_80-1 downto 0);
    step_low_in_256              : in  std_logic_vector(STEP_LOW_BITS_256-1 downto 0);
    step_normal_in_80            : in  std_logic_vector(STEP_NORMAL_BITS_80-1 downto 0);
    step_normal_in_256           : in  std_logic_vector(STEP_NORMAL_BITS_256-1 downto 0)
    );


end entity synchronization;

architecture synchronization_structural of synchronization is

  signal pps_reg1            : std_logic;
  signal pps_reg2            : std_logic;
  signal pps_reg3            : std_logic;
  signal pps_reg4            : std_logic;
  signal pps_reg5            : std_logic;
  signal pps_reg6            : std_logic;
  signal pps_reg7            : std_logic;
  signal pps_reg8            : std_logic;
  signal pps_reg9            : std_logic;
  signal pps_reg10           : std_logic;
  signal sync_pps            : std_logic;
  signal sync_pps_delayed    : std_logic;
  signal freq_out_256_int    : std_logic;
  signal freq_out_80_int     : std_logic;
  signal virtual_pps_80_int  : std_logic;
  signal virtual_pps_256_int : std_logic;
  signal sync_pps_enable     : std_logic;
  signal clean_pps           : std_logic;

  

  
begin
  
  virtual_pps_256 <= virtual_pps_256_int;
  virtual_pps_80  <= virtual_pps_80_int;


-------------------------------------------------------------------------------
-- sicronizador do sinal do gps - copernicus
-------------------------------------------------------------------------------  
  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      pps_reg1  <= '0';
      pps_reg2  <= '0';
      pps_reg3  <= '0';
      pps_reg4  <= '0';
      pps_reg5  <= '0';
      pps_reg6  <= '0';
      pps_reg7  <= '0';
      pps_reg8  <= '0';
      pps_reg9  <= '0';
      pps_reg10 <= '0';
    elsif rising_edge(sysclk) then
      pps_reg1  <= pps;
      pps_reg2  <= pps_reg1;
      pps_reg3  <= pps_reg2;
      pps_reg4  <= pps_reg3;
      pps_reg5  <= pps_reg4;
      pps_reg6  <= pps_reg5;
      pps_reg7  <= pps_reg6;
      pps_reg8  <= pps_reg7;
      pps_reg9  <= pps_reg8;
      pps_reg10 <= pps_reg9;
    end if;
  end process;

-------------------------------------------------------------------------------
-- detector de bordas do sinal do copernicus
-------------------------------------------------------------------------------  
  edge_detector_inst1 : entity work.edge_detector
    port map (
      n_reset  => n_reset,
      sysclk   => sysclk,
      f_in     => pps_reg10,
      pos_edge => sync_pps
      );

  sync_pps_enable <= sync_pps and enable_pps;



-------------------------------------------------------------------------------
-- filtro do sinal de pps - habilita, desabilita sinal 
-------------------------------------------------------------------------------

  pps_cleaner : entity work.pps_cleaner
    generic map (
      D                => D,
      PERIOD_FREQ_MIN  => PERIOD_FREQ_MIN,
      PERIOD_FREQ_MAX  => PERIOD_FREQ_MAX,     
      FM_MAX_DEVIATION => FM_MAX_DEVIATION
      )
    port map (
      CLK_FREQUENCY_STD => CLK_FREQUENCY_STD,
      sysclk            => sysclk,
      n_reset           => n_reset,
      pps_pulse         => sync_pps_enable,
      sync_pps_delayed  => sync_pps_delayed,
      clean_pps         => clean_pps);



-------------------------------------------------------------------------------
-- Deslocamento do sinal do pps
-------------------------------------------------------------------------------  
  pps_delay_1 : entity work.pps_delay
    generic map (
      MAX_DELAY => GROUP_DELAY)                
    port map (
      sysclk           => sysclk,
      n_reset          => n_reset,
      sync_pps         => clean_pps,
      sync_pps_delayed => sync_pps_delayed);


-------------------------------------------------------------------------------
-- atraso de 4 ciclos so sinal da frequencia em relacao ao pps virtual 4800
-------------------------------------------------------------------------------  
  pps_delay_2 : entity work.pps_delay
    generic map (
      MAX_DELAY => DELAY_80)                
    port map (
      sysclk           => sysclk,
      n_reset          => n_reset,
      sync_pps         => freq_out_80_int,
      sync_pps_delayed => freq_out_80);





-------------------------------------------------------------------------------
-- atraso de 4 ciclos so sinal da frequencia em relaÃ§Ã£o ao pps virtual 15360
-------------------------------------------------------------------------------  
  pps_delay_3 : entity work.pps_delay
    generic map (
      MAX_DELAY => DELAY_256)                
    port map (
      sysclk           => sysclk,
      n_reset          => n_reset,
      sync_pps         => freq_out_256_int,
      sync_pps_delayed => freq_out_256);





-------------------------------------------------------------------------------
-- adpll 80
-------------------------------------------------------------------------------
  adpll_soc_inst : entity work.adpll_soc
    generic map (
      D               => D,
      N               => N,
      N_BITS_NCO_SOC  => N_BITS_NCO,
      LIMIT_TIMER_SOC => LIMIT_TIMER,
      SOC_TIME_SOC    => SOC_TIME,
      PERIOD_FREQ_MAX => PERIOD_FREQ_MAX,
      PERIOD_FREQ_MIN => PERIOD_FREQ_MIN,
      TIMEOUT_PPS     => TIMEOUT_PPS,
      EDGE_TO_CHECK   => EDGE_TO_CHECK,

      FREQ_BITS        => FREQ_BITS_80,
      STEP_LOW_BITS    => STEP_LOW_BITS_80,
      STEP_NORMAL_BITS => STEP_NORMAL_BITS_80,
      FAKE_DRIFT_VALUE => FAKE_DRIFT_VALUE_80,
      PPS_DIFF         => PPS_DIFF_80,

      DELTA_LIMIT         => DELTA_LIMIT_80,
      LIMIT_LO_SOC        => LIMIT_LO_80,
      DELTA_LIMIT_LOCKED  => DELTA_LIMIT_80_LOCKED,
      LIMIT_LO_SOC_LOCKED => LIMIT_LO_80_LOCKED,
      LIMIT_HI_SOC        => LIMIT_HI_80,
      LIMIT_HI_SOC_LOCKED => LIMIT_HI_80_LOCKED,


      FM_MAX_DEVIATION => FM_MAX_DEVIATION,
      FAKE_DRIFT       => FAKE_DRIFT,
      SYS_START_WAIT   => SYS_START_WAIT,
      FREQ_TOLERANCE   => FREQ_TOLERANCE
      )
    port map (

      FREQUENCY_DEFAULT_STD => frequency_default_std_in_80,
      K_DEFAULT_STD         => k_default_std_in_80,
      CLK_FREQUENCY_STD     => CLK_FREQUENCY_STD,
      EDGE_TO_RESET         => freq_in_80,
      STEP_LOW_SOC          => step_low_in_80,
      STEP_NORMAL_SOC       => step_normal_in_80,


      n_reset     => n_reset,
      sysclk      => sysclk,
      pps_pulse   => sync_pps_delayed,
      irig_ok     => irig_ok,
      locked      => locked,
      start_conv  => freq_out_80_int,
      virtual_pps => virtual_pps_80_int
      );



-------------------------------------------------------------------------------
-- adpll 256
-------------------------------------------------------------------------------
  
  adpll_soc_inst2 : entity work.adpll_soc
    generic map (
      D               => D,
      N               => N,
      N_BITS_NCO_SOC  => N_BITS_NCO,
      LIMIT_TIMER_SOC => LIMIT_TIMER,
      SOC_TIME_SOC    => SOC_TIME,
      PERIOD_FREQ_MAX => PERIOD_FREQ_MAX,
      PERIOD_FREQ_MIN => PERIOD_FREQ_MIN,
      TIMEOUT_PPS     => TIMEOUT_PPS,
      EDGE_TO_CHECK   => EDGE_TO_CHECK,

      FREQ_BITS        => FREQ_BITS_256,
      STEP_LOW_BITS    => STEP_LOW_BITS_256,
      STEP_NORMAL_BITS => STEP_NORMAL_BITS_256,
      FAKE_DRIFT_VALUE => FAKE_DRIFT_VALUE_256,
      PPS_DIFF         => PPS_DIFF_256,

      DELTA_LIMIT         => DELTA_LIMIT_256,
      LIMIT_LO_SOC        => LIMIT_LO_256,
      DELTA_LIMIT_LOCKED  => DELTA_LIMIT_256_LOCKED,
      LIMIT_LO_SOC_LOCKED => LIMIT_LO_256_LOCKED,
      LIMIT_HI_SOC        => LIMIT_HI_256,
      LIMIT_HI_SOC_LOCKED => LIMIT_HI_256_LOCKED,

      FM_MAX_DEVIATION => FM_MAX_DEVIATION,
      FAKE_DRIFT       => FAKE_DRIFT,
      SYS_START_WAIT   => SYS_START_WAIT,
      FREQ_TOLERANCE   => FREQ_TOLERANCE
      )

    port map (


      FREQUENCY_DEFAULT_STD => frequency_default_std_in_256,
      K_DEFAULT_STD         => k_default_std_in_256,
      CLK_FREQUENCY_STD     => CLK_FREQUENCY_STD,
      EDGE_TO_RESET         => freq_in_256,
      STEP_LOW_SOC          => step_low_in_256,
      STEP_NORMAL_SOC       => step_normal_in_256,



      locked      => open,
      n_reset     => n_reset,
      sysclk      => sysclk,
      pps_pulse   => sync_pps_delayed,
      irig_ok     => irig_ok,
      start_conv  => freq_out_256_int,
      virtual_pps => virtual_pps_256_int
      );




  
end architecture synchronization_structural;
