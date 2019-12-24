
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- test packages
--use work.RandomBasePkg.all;
--use work.RandomPkg.all;
--use work.CoveragePkg.all;
--use ieee.math_real.all;

-------------------------------------------------------------------------------

entity phase_sum_tb is


end phase_sum_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of phase_sum_tb is


  -- component ports
  -- clock
  constant clock_linux_period : time := 40 ns;
  constant sys_clk_period     : time := 10 ns;
  constant clock_stim_period  : time := 200 ns;


-- uut signals

  signal sysclk             : std_logic                     := '0';
  signal clock_linux        : std_logic                     := '0';
  signal clock_stim         : std_logic                     := '0';
  signal clock_stim_b       : std_logic                     := '0';
  signal reset_n            : std_logic;
  signal avs_read           : std_logic;
  signal avs_address        : std_logic_vector(1 downto 0);
  signal avs_chipselect     : std_logic                     := '0';
  signal avs_write          : std_logic                     := '0';
  signal avs_writedata      : std_logic_vector(31 downto 0) := x"00000000";
  signal avs_readdata       : std_logic_vector(31 downto 0);
  signal coe_data_input     : std_logic_vector(127 downto 0);
  signal coe_data_output    : std_logic_vector(127 downto 0);
  signal coe_data_ready_in  : std_logic                     := '0';
  signal coe_data_ready_out : std_logic;
  

  
begin


  -- clock generation
  clock_linux  <= not clock_linux      after clock_linux_period/2;
  sysclk       <= not sysclk           after sys_clk_period/2;
  clock_stim   <= not clock_stim       after clock_stim_period/2;
  clock_stim_b <= transport clock_stim after sys_clk_period/2;

  -- component instantiation


  phase_sum_1 : entity work.phase_sum
    generic map (
      COE_IN_OUT_BITS      => 128,
      N_CHANNELS_ANA_BOARD => 8)
    port map (
      clk                => clock_linux,
      reset_n            => reset_n,
      avs_read           => '0',
      avs_address        => "00",
      avs_chipselect     => avs_chipselect,
      avs_write          => avs_write,
      avs_writedata      => avs_writedata,  --  x"00000000",
      avs_readdata       => open,
      coe_data_input     => coe_data_input,
      coe_data_output    => open,
      coe_data_ready_in  => coe_data_ready_in,
      coe_data_ready_out => coe_data_ready_out,
      coe_sysclk         => sysclk);



  p_random_generic_1 : entity work.p_random_generic
    generic map (
      SEED => 666,
      N    => 128)
    port map (
      clk         => clock_stim_b,
      n_reset     => reset_n,
      random_vect => coe_data_input);


  -- gera um pulso de sys_clk_period quando ocorre uma mudança em
  -- coe_data_input
  stimuli : process
  begin
    wait until coe_data_input'event;
    coe_data_ready_in <= '1';
    wait for sys_clk_period;
    coe_data_ready_in <= '0';
  end process;


  -- controle nios
  WaveGen_Proc : process
  begin
    wait until reset_n = '1';
    wait for 3 ms;
    wait until clock_linux = '1';
    avs_write      <= '1';
    avs_chipselect <= '1';
    avs_writedata  <= x"0000000" & "000" & '1';
    wait for 2*clock_linux_period;
    avs_write      <= '0';
    avs_chipselect <= '0';
    avs_writedata  <= x"0000000" & "000" & '0';
    wait for 3 ms;
    wait until clock_linux = '1';
    avs_write      <= '1';
    avs_chipselect <= '1';
    avs_writedata  <= x"0000000" & "000" & '0';
    wait for 2*clock_linux_period;
    avs_write      <= '0';
    avs_chipselect <= '0';
    avs_writedata  <= x"0000000" & "000" & '0';
    wait for 3 ms;
    wait until clock_linux = '1';
    avs_write      <= '1';
    avs_chipselect <= '1';
    avs_writedata  <= x"0000000" & "000" & '1';
    wait for 2*clock_linux_period;
    avs_write      <= '0';
    avs_chipselect <= '0';
    avs_writedata  <= x"0000000" & "000" & '0';
    wait for 3 ms;    
    
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


end generic_tb_rtl;

