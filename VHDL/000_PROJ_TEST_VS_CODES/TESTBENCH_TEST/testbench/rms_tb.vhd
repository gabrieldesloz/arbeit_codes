
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

entity rms_tb is

  generic (
    arq_escrita : string := "resultado2_rms.txt"
    );

end rms_tb;

-------------------------------------------------------------------------------

architecture rms_tb_rtl of rms_tb is




-------------------------------------------------------------------------------
-- IO
-------------------------------------------------------------------------------
-- escrita arquivos
  constant largura : natural := 36;
  signal vect_out  : std_logic_vector(largura-1 downto 0);


-- procedimento de escrita de arquivos
  procedure output_txt (ram_file_name : in string;
                        vetor         : in std_logic_vector(largura-1 downto 0);
                        agora         :    time) is

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
-------------------------------------------------------------------------------




  -- component ports
  signal reset_n         : std_logic;
  signal data_input      : std_logic_vector(15 downto 0) := "1111111101011101";
  signal data_avaiable   : std_logic;
  signal data_output     : std_logic_vector(15 downto 0);
  signal data_output_2   : std_logic_vector(15 downto 0);
  signal data_ready      : std_logic;
  signal data_ready_2    : std_logic;
  signal n_point_samples : std_logic_vector(9 downto 0)  := "0100100001";


  signal random_vect : std_logic_vector(5 downto 0) := "100100";
  signal sqrt_ready  : std_logic                    := '0';
  signal sqrt_start  : std_logic                    := '0';


  -- clock
  signal Clk : std_logic := '1';
  

begin  -- rms_tb_rtl


-------------------------------------------------------------------------------
-- Escrita resultados
-------------------------------------------------------------------------------  
  vect_out <= clk & reset_n & data_input & data_avaiable & data_output & data_ready;
  grava_arquivo : output_txt(arq_escrita, vect_out, NOW);
-------------------------------------------------------------------------------



  -- component instantiation
  DUT : entity work.rms
    port map (
      sysclk          => Clk,
      reset_n         => reset_n,
      data_input      => data_input,
      data_available  => data_avaiable,
      data_output     => data_output,
      data_ready      => data_ready,
      n_point_samples => n_point_samples

      );

  DUT2 : entity work.rms_orig
    port map (
      sysclk          => Clk,
      reset_n         => reset_n,
      data_input      => data_input,
      data_available  => data_avaiable,
      data_output     => data_output_2,
      data_ready      => data_ready_2,
      n_point_samples => n_point_samples

      );

  sqrt_1 : entity work.sqrt
    generic map (
      N => 10)
    port map (
      start     => '1',
      ready     => sqrt_ready,
      sysclk    => Clk,
      n_reset   => reset_n,
      radical   => "1111111111",
      remainder => open,
      q         => open);

  
-- random radical generator
  random_proc : process
    variable RV : RandomPType;
  begin
    wait until sqrt_ready = '1';
    random_vect <= RV.RandSlv(0, 2**6-1, 6);
  end process;




  -- clock generation
  Clk <= not Clk after 5 ns;


  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    data_avaiable <= '1';
    wait for 10 ns;
    data_avaiable <= '0';
    wait for 140 ns;
    wait until Clk = '1';
  end process WaveGen_Proc;



-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => clk,
      n_reset => reset_n);


end rms_tb_rtl;

-------------------------------------------------------------------------------

configuration rms_tb_rms_tb_rtl_cfg of rms_tb is
  for rms_tb_rtl
  end for;
end rms_tb_rms_tb_rtl_cfg;

-------------------------------------------------------------------------------
--  Maquina de estados : generate random number, store random number, start signal
-- input random number 
-- wait_ready signal
-- check answer with math real 
--
--

-------------------------------------------------------------------------------
