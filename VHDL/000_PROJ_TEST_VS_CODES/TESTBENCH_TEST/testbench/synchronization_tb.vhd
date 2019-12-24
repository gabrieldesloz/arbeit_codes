
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


use work.RandomBasePkg.all;
use work.RandomPkg.all;
use work.CoveragePkg.all;
use ieee.math_real.all;


-------------------------------------------------------------------------------

entity synchronization_tb is
  generic (
    arq_escrita : string := "resultados5.txt"
    );


end entity synchronization_tb;

-------------------------------------------------------------------------------

architecture synchronization_tb_RTL of synchronization_tb is

-- component ports
  signal pps_copernicus : std_logic;
  signal CLOCK_100MHz   : std_logic;


-- clock
  signal clock_pps   : std_logic;
  signal clock_count : integer range 0 to 5;

  signal ready_fir           : std_logic;
  signal edge_freq_mclk      : std_logic;
  signal pps_fault           : std_logic;
  signal pps_copernicus_edge : std_logic;
  signal n_reset             : std_logic;

  -- constants
  constant pps_period          : time := 2 ms;
  constant CLOCK_100MHz_period : time := 9.98 ns;


  -- escrita arquivos
  constant largura : natural := 3;
  signal vect_out  : std_logic_vector(largura-1 downto 0);


--procedimento de escrita de arquivos
  procedure output_txt (ram_file_name : in string; vetor : in std_logic_vector(largura-1 downto 0); agora : time) is
    file file_out  : text open append_mode is ram_file_name;  --WRITE_MODE ou READ_MODE    
    variable linha : line;
  begin
    write(linha, vetor);
    write(linha, string'(" @ "));
    write(linha, agora);
    writeline(file_out, linha);
    if agora = (30 ms) then
      write(linha, string'("Fim do arquivo"));
      writeline(file_out, linha);
    end if;
  end procedure output_txt;

  
  
begin
  
-------------------------------------------------------------------------------
-- DUT
-------------------------------------------------------------------------------

  DUT : entity work.synchronization
    port map (
      pps            => pps_fault,
      n_reset        => n_reset,
      sysclk         => CLOCK_100MHz,
      irig_ok        => '1',
      ready_cic      => ready_fir,
      edge_freq_mclk => edge_freq_mclk,
      freq_mclk      => open,
      locked         => open);


-------------------------------------------------------------------------------
-- emulador do pulso cic (fir): divisor do relogio por 256
-------------------------------------------------------------------------------  
  fir_pulse_emulator_1 : entity work.fir_pulse_emulator
    port map (
      clock     => CLOCK_100MHz,
      ready_fir => ready_fir,
      n_reset   => n_reset,
      enable    => edge_freq_mclk
      );

-------------------------------------------------------------------------------
-- emulador de faltas no pps
-------------------------------------------------------------------------------


  -- detector de bordas do sinal do copernicus
  edge_detector_inst1 : entity work.edge_detector
    port map (
      n_reset  => n_reset,
      sysclk   => CLOCK_100MHz,
      f_in     => pps_copernicus,
      pos_edge => pps_copernicus_edge
      );


  pps_defect_emulator_1 : entity work.pps_defect_emulator
    generic map (
      W_PERIOD => 0,
      PPS_ON_P => 40)
    port map (
      ext_edge => pps_copernicus_edge,
      clock    => CLOCK_100MHz,
      n_reset  => n_reset,
      pps_in   => pps_copernicus_edge,
      pps_out  => pps_fault);


-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => CLOCK_100MHz,
      n_reset => n_reset);


-------------------------------------------------------------------------------
-- Escrita resultados
-------------------------------------------------------------------------------  
  vect_out <= pps_fault & ready_fir & edge_freq_mclk;
  grava_arquivo : output_txt(arq_escrita, vect_out, NOW);

-------------------------------------------------------------------------------
-- Estimulos Clock
-------------------------------------------------------------------------------

  -- estimulo clock
  relogio : process
  begin
    clock_pps <= '1';
    wait for pps_period/2;
    clock_pps <= '0';
    wait for pps_period/2;
  end process relogio;


  -- estimulo clock
  relogio_100 : process
  begin
    CLOCK_100MHz <= '0';
    wait for CLOCK_100MHz_period/2;
    CLOCK_100MHz <= '1';
    wait for CLOCK_100MHz_period/2;
  end process relogio_100;


  -- estimulo clock com skew
  relogio_2 : process
  begin
    pps_copernicus <= '0';
    if clock_count = 1 then
      wait for (pps_period/2);
      pps_copernicus <= '1';
      wait for pps_period/2;
    elsif clock_count = 2 then
      -- jitter
      wait for (pps_period/2) + 1 ns;
      pps_copernicus <= '1';
      wait for pps_period/2 - 1 ns;
    else
      wait for (pps_period/2);
      pps_copernicus <= '1';
      wait for pps_period/2;
    end if;
    
  end process relogio_2;

  count : process
    variable i : integer range 0 to 5 := 0;
  begin
    clock_count <= i;
    i           := i+1;
    if i = 5 then
      i := 0;
    end if;
    wait until clock_pps = '1';
  end process count;



  
  
end architecture synchronization_tb_RTL;

