-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-19
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------


-- 1a versao apenas com insercao da qualidade

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity board_processor is

  
  port (

    sysclk  : in std_logic;
    reset_n : in std_logic;

    -- entradas --
    -- 256
    sample_values_0_i       : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    -- 512
    sample_values_0_o       : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
    sample_values_ready_0_o : out std_logic;

    -- to sv_gen _0     
    config_0_i                   : in std_logic_vector(1 downto 0);
    phase_sum_ovf_0_i            : in std_logic_vector(1 downto 0);
    phase_sum_data_ready_0_i     : in std_logic;
    gain_register_data_ready_0_i : in std_logic;
    acq_data_ready_0_i           : in std_logic;
    gain_register_data_0_i       : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0);
    acq_data_0_i                 : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0);


    -- soft quality input
    quality_soft_i : in std_logic_vector(((N_CHANNELS_ANA/2)*BITS)-1 downto 0)



    ); 


end board_processor;



architecture board_processor_arq of board_processor is


  -- quality 
  signal quality_or_0_ok_o : std_logic_vector((N_CHANNELS_ANA/2)-1 downto 0);
  signal sv_channel_proc   : std_logic_vector((N_CHANNELS_ANA/2)*(4*N_CHANNELS_ANA)-1 downto 0);
  signal sv_ready          : std_logic_vector((N_CHANNELS_ANA/2)-1 downto 0);
  
begin


  GEN_REG : for I in 0 to (N_CHANNELS_ANA/2)-1 generate

    -- zerar por padrao a entrada overflow quando nao forem  processados
    --  os canais de neutro 
    a : if ((I /= N2_CHANNEL) and (I /= N1_CHANNEL)) generate

      channel_a : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          -- SVs input
          sample_values_i => sample_values_0_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),

          config_0_i        => config_0_i,
          phase_sum_ovf_0_i => '0',

          phase_sum_data_ready_0_i => phase_sum_data_ready_0_i,

          gain_register_data_ready_0_i => gain_register_data_ready_0_i,
          gain_register_data_0_i       => gain_register_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          acq_data_ready_0_i => acq_data_ready_0_i,
          acq_data_0_i       => acq_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          -- quality from software input 
          quality_soft_i => quality_soft_i(((I)*Q_BITS)+(Q_BITS-1) downto ((I)*Q_BITS)),

          -- sv output (64 bits) 
          data_out_ready_o => sv_ready(I),
          data_out_o       => sv_channel_proc(((I)*4*N_BITS_ADC)+(4*N_BITS_ADC)-1 downto ((I)*4*N_BITS_ADC))

          );

    end generate a;


    b : if (I = N1_CHANNEL) generate

      channel_b : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          -- SVs input
          sample_values_i => sample_values_0_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),

          config_0_i        => config_0_i,
          phase_sum_ovf_0_i => phase_sum_ovf_0_i(0),

          phase_sum_data_ready_0_i => phase_sum_data_ready_0_i,

          gain_register_data_ready_0_i => gain_register_data_ready_0_i,
          gain_register_data_0_i       => gain_register_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          acq_data_ready_0_i => acq_data_ready_0_i,
          acq_data_0_i       => acq_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          -- quality from software input 
          quality_soft_i => quality_soft_i(((I)*Q_BITS)+(Q_BITS-1) downto ((I)*Q_BITS)),

          -- sv output (64 bits) 
          data_out_ready_o => sv_ready(I),
          data_out_o       => sv_channel_proc(((I)*4*N_BITS_ADC)+(4*N_BITS_ADC)-1 downto ((I)*4*N_BITS_ADC))

          );

    end generate b;

    c : if (I = N2_CHANNEL) generate

      channel_c : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          -- SVs input
          sample_values_i => sample_values_0_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),

          config_0_i        => config_0_i,
          phase_sum_ovf_0_i => phase_sum_ovf_0_i(1),

          phase_sum_data_ready_0_i => phase_sum_data_ready_0_i,

          gain_register_data_ready_0_i => gain_register_data_ready_0_i,
          gain_register_data_0_i       => gain_register_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          acq_data_ready_0_i => acq_data_ready_0_i,
          acq_data_0_i       => acq_data_0_i(((I)*N_BITS_ADC)+(N_BITS_ADC)-1 downto ((I)*N_BITS_ADC)),

          -- quality input 
          quality_soft_i => quality_soft_i(((I)*Q_BITS)+(Q_BITS-1) downto ((I)*Q_BITS)),


          -- sv output (64 bits) 
          data_out_ready_o => sv_ready(I),
          data_out_o       => sv_channel_proc(((I)*4*N_BITS_ADC)+(4*N_BITS_ADC)-1 downto ((I)*4*N_BITS_ADC))


          );

    end generate c;




    process (sysclk, reset_n)
    begin
      if reset_n = '0' then
        sv_data_o_reg <= (others => '0');
        sv_ready_reg  <= '0';
      elsif rising_edge(sysclk) then    -- rising clock edge
        if  data_out_ready_o = (others => '1') then
          sv_data_o_reg <= sv_channel_proc;
          sv_ready_reg  <= 

        end if;

    end process;



    

    


    
    
  end generate GEN_REG;



  -- unidade que junta toda a informação
  -- 8 pedaços de 64 bits
  -- e forma um só, conforme
  -- data ready
  -- sv_concat



  


  

end board_processor_arq;


-- configurations
