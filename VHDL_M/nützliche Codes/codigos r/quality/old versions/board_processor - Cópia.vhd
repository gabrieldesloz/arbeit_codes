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
    quality_soft_i: in std_logic_vector(((N_CHANNELS_ANA/2)*BITS)-1 downto 0 )    

    ); 


end board_processor;



architecture board_processor_arq of board_processor is


  -- redução vetor "or" std_logic_vector
   function or_reduce (arg : std_logic_vector )
    return std_logic is
    variable Upper, Lower : std_logic;
    variable Half : integer;
    variable BUS_int : std_logic_vector ( arg'length - 1 downto 0 );
    variable Result : std_logic;
  begin
    if (arg'LENGTH < 1) then            -- In the case of a NULL range
      Result := '0';
    else
      BUS_int := to_ux01 (arg);
      if ( BUS_int'length = 1 ) then
        Result := BUS_int ( BUS_int'left );
      elsif ( BUS_int'length = 2 ) then
        Result := BUS_int ( BUS_int'right ) or BUS_int ( BUS_int'left );
      else
s        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
        Upper := or_reduce ( BUS_int ( BUS_int'left downto Half ));
        Lower := or_reduce ( BUS_int ( Half - 1 downto BUS_int'right ));
        Result := Upper or Lower;
      end if;
    end if;
    return Result;
  end;

   
   -- quality 
   signal quality_or_0_ok_o: std_logic_vector((N_CHANNELS_ANA/2)-1 downto 0);
   
begin


  GEN_REG :  for I in 0 to (N_CHANNELS_ANA/2)-1 generate

    -- zerar por padrao a entrada overflow quando nao forem  processados
    --  os canais de neutro 
     a : if ((I /= N2_CHANNEL) and (I /= N1_CHANNEL)) generate

      channel_a : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          config_0_i                   => config_0_i,  
          phase_sum_ovf_0_i            => '0',  
          
          phase_sum_data_ready_0_i     => phase_sum_data_ready_0_i,  
          gain_register_data_ready_0_i => gain_register_data_ready_0_i,         
          gain_register_data_0_i       => gain_register_data_0_i,          
          acq_data_ready_0_i           => acq_data_ready_0_i,            
          acq_data_0_i                 => acq_data_0_i,  

          -- quality input 
          quality_soft_i               => quality_soft_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),
          
          -- quality output
          quality_or_0_ok_o                => quality_or_0_ok_o(I),
          quality_or_0_to_quality_insert_o => quality_or_0_to_quality_insert(((I)*BITS)+(BITS-1) downto ((I)*BITS))

          );

    end generate a;


       b : if ((I = N1_CHANNEL) generate

      channel_b : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          config_0_i                   => config_0_
          phase_sum_ovf_0_i            => phase_sum_ovf_0_i(0),   
          
          phase_sum_data_ready_0_i     => phase_sum_data_ready_0_i,  
          gain_register_data_ready_0_i => gain_register_data_ready_0_i,           
          gain_register_data_0_i       => gain_register_data_0_i,           
          acq_data_ready_0_i           => acq_data_ready_0_i,           
          acq_data_0_i                 => acq_data_0_i, 

          -- quality input
          quality_soft_i               => quality_soft_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),
          
          -- quality output
          quality_or_0_ok_o                => quality_or_0_ok_o(I),
          quality_or_0_to_quality_insert_o => quality_or_0_to_quality_insert(((I)*BITS)+(BITS-1) downto ((I)*BITS))

          );

    end generate b;

     c : if ((I = N2_CHANNEL) generate

      channel_c : entity work.channel_processor
        port map
        (
          sysclk  => sysclk,
          reset_n => reset_n,

          config_0_i                   => config_0_i,  
          phase_sum_ovf_0_i            => phase_sum_ovf_0_i(1), 
          
          phase_sum_data_ready_0_i     => phase_sum_data_ready_0_i,  
          gain_register_data_ready_0_i => gain_register_data_ready_0_i,            
          gain_register_data_0_i       => gain_register_data_0_i,           
          acq_data_ready_0_i           => acq_data_ready_0_i,           
          acq_data_0_i                 => acq_data_0_i, 

          -- quality input 
          quality_soft_i               => quality_soft_i(((I)*BITS)+(BITS-1) downto ((I)*BITS)),
          
          -- quality output
          quality_or_0_ok_o                => quality_or_0_ok_o(I),
          quality_or_0_to_quality_insert_o => quality_or_0_to_quality_insert(((I)*BITS)+(BITS-1) downto ((I)*BITS))

          );

    end generate c; 
      
    
  end generate GEN_REG;


   quality_or_0_ok <=  or_reduce(quality_or_0_ok_o);
   

  -- insercao dos bits da qualidade no stream de SV
  quality_insert_0 : entity work.quality_insert
    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      data_in           => sample_values_0_i,
      data_in_available => quality_or_0_ok,

      data_out_ready => sample_values_ready_0_o,
      data_out       => sample_values_0_o,

      quality_fill_i => quality_or_0_to_quality_insert_o

      ); 



end board_processor_arq;


-- configurations
