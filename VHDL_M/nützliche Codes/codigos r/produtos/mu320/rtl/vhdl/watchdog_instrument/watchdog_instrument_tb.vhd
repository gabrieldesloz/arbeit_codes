
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------

entity watchdog_instrument_tb is


end watchdog_instrument_tb;

-------------------------------------------------------------------------------

architecture watchdog_instrument_tb_rtl of watchdog_instrument_tb is


  -- component ports

  -- clock
  constant sys_clk_period : time := 10 ns;


-- uut signals

  signal sysclk         : std_logic := '0';
  signal reset_n        : std_logic := '0';
  signal avs_address    : std_logic_vector(1 downto 0);
  signal avs_chipselect : std_logic;
  signal avs_write      : std_logic;
  signal avs_writedata  : std_logic_vector(31 downto 0);
  
  

  
begin


  -- clock generation
  sysclk <= not sysclk after sys_clk_period;




  -- component instantiation

  wtd_instrument_1 : entity work.watchdog_instrument
    generic map (   
      FREQ_MHZ => 25)
    port map (
      sysclk         => sysclk,
      reset_n        => reset_n,
      avs_read       => '0',
      avs_address    => avs_address,
      avs_chipselect => avs_chipselect,
      avs_write      => avs_write,
      avs_writedata  => avs_writedata,
      avs_readdata   => open,
      coe_alarm      => open);

-- indiferente
  avs_address   <= (others => '0');

  -- alterar constante INSTRUMENT_TIMEOUT para simulacao
  -- emula o funcionamento do barramento do NIOS 
  WaveGen_Proc : process
  begin
    wait until reset_n = '1';
    wait for 1 us;
    avs_chipselect <= '0';
    avs_write      <= '0';
    avs_writedata  <= (others => '0');    
    wait for 5 ms;
    avs_chipselect <= '1';
    avs_write      <= '1';
    avs_writedata  <= (others => '1');
    wait for 40 ns;
    avs_chipselect <= '0';
    avs_write      <= '0';
    avs_writedata  <= (others => '0');
    
  end process;



-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => reset_n
      );


end watchdog_instrument_tb_rtl;

