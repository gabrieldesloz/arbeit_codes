-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-17
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity channel_processor is

  
  port (

    sysclk  : in std_logic;
    reset_n : in std_logic;


    -- to sv_gen     
    config_0_i                   : in std_logic_vector(1 downto 0);
    phase_sum_ovf_0_i            : in std_logic;
    
    phase_sum_data_ready_0_i     : in std_logic;
    gain_register_data_ready_0_i : in std_logic;
    gain_register_data_0_i       : in std_logic_vector((N_BITS_ADC/2 - 1) downto 0);
    acq_data_ready_0_i           : in std_logic;
    acq_data_0_i                 : in std_logic_vector((N_BITS_ADC/2 - 1) downto 0);

    -- quality from software
    quality_soft_i : in std_logic_vector(Q_BITS-1 downto 0);

    -- quality output
    quality_or_0_ok_o                : out std_logic;
    quality_or_0_to_quality_insert_o : out std_logic_vector(BITS-1 downto 0)

    );

end channel_processor;

architecture channel_processor_arq of channel_processor is

  signal gate_quality_0    : std_logic_vector((Q_BITS-1) downto 0);
  signal gate_quality_0_ok : std_logic;

  signal quality_or_0_to_quality_insert : std_logic_vector((Q_BITS-1) downto 0);
  signal quality_soft_int               : std_logic_vector((BITS-1 downto 0));
  

begin

  
  quality_ctlr_0 : entity work.quality_ctlr
    generic map (

      VALUE1 => VALUE1,
      VALUE2 => VALUE2,
      VALUE3 => VALUE3,
      BITS   => BITS,
      Q_BITS => Q_BITS

      )

    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      -- 16 bits - 8 canais
      acq_data_in    => acq_data_0_i,
      acq_data_ready => acq_data_ready_0_i,

      gain_register_data_in    => gain_register_data_0_i,
      gain_register_data_ready => gain_register_data_ready_0_i,

      phase_sum_data_ready => phase_sum_data_ready_0_i,
      phase_sum_ovf_i      => phase_sum_ovf_0_i,
      config_i             => config_0_i,

      quality_o        => gate_quality_0,
      q_vector_ready_o => gate_quality_0_ok);        


  quality_or_0 : entity work.quality_or
    port map

    (
      sysclk  => sysclk,
      reset_n => reset_n,

      quality_gate_in => gate_quality_0,
      quality_soft_in => quality_soft_int,
      quality_o       => quality_or_0_to_quality_insert_o,

      data_available_i => gate_quality_0_ok,
      data_ready_o     => quality_or_0_ok_o

      );


  -- tranformacao do vetor de 15 bits para 32 bits
  quality_soft_int <= std_logic_vector(resize(unsigned(quality_soft_i), BITS));

  


end channel_processor_arq;


-- configurations
