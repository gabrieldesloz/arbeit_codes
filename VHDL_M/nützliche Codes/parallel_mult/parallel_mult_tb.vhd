-------------------------------------------------------------------------------
-- Title      : Testbench for design "rms"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rms_tb.vhd
-- Author     :   <reason@RL131-C>
-- Company    : 
-- Created    : 2011-10-24
-- Last update: 2013-01-24
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-24  1.0      reason  Created
-------------------------------------------------------------------------------

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

entity parallel_mult is

  generic (
    arq_escrita : string := "parallel_mult_tb.txt"
    );

end parallel_mult;

-------------------------------------------------------------------------------

architecture parallel_mult_tb_ARQ of parallel_mult_tb is



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


  -- DUT ports

  signal reset_n : std_logic;
  signal ready   : std_logic;
  signal start   : std_logic;
  signal a       : std_logic_vector(3 downto 0);
  signal b       : std_logic_vector(3 downto 0);
  signal c       : std_logic_vector(7 downto 0);



-- random inputs
  signal random_input_a : std_logic_vector(3 downto 0);
  signal random_input_b : std_logic_vector(3 downto 0);  
  signal change_rndm_input: std_logic;



    -- clock
    signal Clk : std_logic := '1';

  ------------------------------------------------------------------------------
  -- TEST STATE MACHINE
  ------------------------------------------------------------------------------
  type STATE_TYPE is (IDLE, LOAD, MULT, SUBT, CHECK, DONE);

  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";

  
  

begin


-------------------------------------------------------------------------------
-- Escrita resultados
-------------------------------------------------------------------------------  
  vect_out <= clk & reset_n & data_input & data_avaiable & data_output & data_ready;
  grava_arquivo : output_txt(arq_escrita, vect_out, NOW);
-------------------------------------------------------------------------------



-- clock generation
  Clk <= not Clk after 5 ns;


  DUT : entity work.parallel_mult
    generic map (
      N => 2)
    port map (
      sysclk  => Clk,
      n_reset => n_reset,
      start   => start,
      ready   => ready,
      a       => a,
      b       => b,
      c       => c);


-- random radical generator
  random_proc : process
    variable RV : RandomPType;
  begin
    if change_rndm_input = '1' then
      random_input_a <= RV.RandSlv(0, 2**3-1, 4);
      random_input_b <= RV.RandSlv(0, 2**3-1, 4);
    end if;
    
  end process;


  state_machine : process(all) is
  begin  -- process state_machine

    ready <= '0';

    state_next <= state_reg;


    case state_reg is
      

      when INPUT =>
        a <= random_input_a;
        b <= random_input_b;
        

      when WAIT_OUT =>


      when CHECK =>


      when others =>
        state_next <= IDLE;

        
    end case;
  end process state_machine;



-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => clk,
      n_reset => reset_n);


end parallel_mult_tb_ARQ;


-------------------------------------------------------------------------------
--  Maquina de estados : generate random number, store random number, start signal
-- input random number 
-- wait_ready signal
-- check answer with math real 
--
--

-------------------------------------------------------------------------------
