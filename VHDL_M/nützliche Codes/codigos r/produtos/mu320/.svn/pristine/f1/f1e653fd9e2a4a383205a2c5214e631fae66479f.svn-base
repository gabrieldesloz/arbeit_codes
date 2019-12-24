
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-------------------------------------------------------------------------------

entity watchdog_timeout_counter_tb is


end watchdog_timeout_counter_tb;

-------------------------------------------------------------------------------

architecture watchdog_timeout_counter_tb_rtl of watchdog_timeout_counter_tb is


  -- component ports

  -- clock
  constant sys_clk_period_25    : time := 40 ns;
  constant PERIOD_TIMEOUT_PULSE : time := 800*sys_clk_period_25;
  constant PULSE_TIMEOUT_PERIOD : time := 40 ns;


-- uut signals

  signal sysclk_25        : std_logic := '1';
  signal reset_n          : std_logic := '0';
  signal reset_n_watchdog : std_logic := '0';

  signal avs_chipselect : std_logic                     := '0';
  signal avs_read       : std_logic                     := '0';
  signal avs_readdata   : std_logic_vector(31 downto 0) := (others => '0');



  signal d : time := 0 ns;
  signal clock : std_logic := '0';
  signal sys_clk : std_logic := '0';
  constant SYS_CLK_PERIOD: time:= 10 ns;
  

  
  
begin


  -- clock generation
  sysclk_25 <= not sysclk_25 after sys_clk_period_25/2;


  
-------------------------------------------------------------------------------
 -- component instantiation
-------------------------------------------------------------------------------
  
  timeout_counter_1 : entity work.timeout_counter
    generic map (
      FREQ_MHZ => 25)
    port map (
      sysclk           => sysclk_25,
      reset_n          => reset_n,
      reset_n_watchdog => reset_n_watchdog,
      avs_address      => '0',
      avs_chipselect   => avs_chipselect,
      avs_read         => avs_read,
      avs_readdata     => open);


-------------------------------------------------------------------------------
-- geração de um pulso com tamanho e periodicidade ajustaveis
-------------------------------------------------------------------------------
  
  process
  begin
    reset_n_watchdog <= '1';
    wait for (PERIOD_TIMEOUT_PULSE-PULSE_TIMEOUT_PERIOD);
    reset_n_watchdog <= '0';
    wait for (PULSE_TIMEOUT_PERIOD);
  end process;




-- emula o funcionamento do barramento do NIOS 
  WaveGen_Proc : process
  begin
    wait until reset_n = '1';
    wait for 1 us;
    avs_chipselect <= '0';
    avs_read  <= '0';
    -- efetua a leitura em um momento de transição
    -- a constante HALF_SECOND no timeout counter tem que estar configurada para FREQ_MHZ*5_000
    wait for ((30.011 ms) - (120 ns));
    avs_chipselect <= '1';
    avs_read   <= '1';
    wait for 80 ns;
    avs_chipselect <= '0';
    avs_read   <= '0';    
  end process;

  

  

  
-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk_25,
      n_reset => reset_n
      );


end watchdog_timeout_counter_tb_rtl;


