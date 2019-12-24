-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2014-08-21
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------


-- 1a versao apenas com inser��o da qualidade

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity quality_top is

  
  port (
  
    sysclk  : in std_logic;
    reset_n : in std_logic;

    -- entradas --
    sample_values_0_i           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    sample_values_0_o           : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
    sample_values_1_i           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    sample_values_1_o           : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
    sample_values_ready_0_o     : out std_logic;
    sample_values_ready_1_o     : out std_logic;
 
    -- to sv_gen _0     
    config_0_i                   : in std_logic_vector(1 downto 0);
    phase_sum_ovf_0_i            : in std_logic;
    phase_sum_data_ready_0_i     : in std_logic;
    gain_register_data_ready_0_i : in std_logic;
    gain_register_data_0_i       : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0);
    acq_data_ready_0_i           : in std_logic;
    acq_data_0_i                 : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0);

    -- to sv_gen_1
    config_1_i                   : in std_logic_vector(1 downto 0);
    phase_sum_ovf_1_i            : in std_logic;
    phase_sum_data_ready_1_i     : in std_logic;
    gain_register_data_ready_1_i : in std_logic;
    gain_register_data_1_i       : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0);
    acq_data_ready_1_i           : in std_logic;
    acq_data_1_i                 : in std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC/2 - 1) downto 0)

    ); 


end quality_top;



architecture quality_top_rtl of quality_top is

  signal gate_quality_0                 : std_logic_vector(Q_BITS-1 downto 0);
  signal gate_quality_0_ok              : std_logic;
  signal quality_or_0_to_quality_insert : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
  signal quality_or_0_ok                : std_logic;
  signal gate_quality_1                 : std_logic_vector(Q_BITS-1 downto 0);
  signal gate_quality_1_ok              : std_logic;
  signal quality_or_1_to_quality_insert : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
  signal quality_or_1_ok                : std_logic;
  

begin

  --board_0---
  
  quality_ctlr_0 : entity work.quality_ctlr
    generic map (
      VALUE1 => VALUE1,
      VALUE2 => VALUE2,
      VALUE3 => VALUE3,
      BITS   => BITS,
      Q_BITS => Q_BITS)
    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      -- 16 bits - 8 canais
      acq_data_in    => acq_data_0_i((16*i)-1 downto 0),
      acq_data_ready => acq_data_ready_0_i,

      gain_register_data_in    => gain_register_data_0_i,
      gain_register_data_ready => gain_register_data_ready_0_i,

      phase_sum_data_ready => phase_sum_data_ready_0_i,  --       
      phase_sum_ovf_i      => phase_sum_ovf_0_i,         --   
      config_i             => config_0_i,                -- configuracao para
                                                         -- leitura V ou I
      quality_o            => gate_quality_0,            -- para "or"
      q_vector_ready_o     => gate_quality_0_ok);        -- para "or"


  quality_or_0 : entity work.quality_or
    port map

    (
      sysclk  => sysclk,
      reset_n => reset_n,

      quality_gate_in => gate_quality_0,
      quality_soft_in => (others => '0'),
      quality_o       => quality_or_0_to_quality_insert,

      data_available_i => gate_quality_0_ok,
      data_ready_o     => quality_or_0_ok

      );


  -- entrada da qualidade, depois phase sum
  quality_insert_0 : entity work.quality_insert
    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      data_in           => sample_values_0_i,  		-- entrada sv 
      data_in_available => quality_or_0_ok,  		-- entrada sv disponivel (interna)

      data_out_ready => sample_values_ready_0_o,  	-- pacote ok (ok) -- para fora
      data_out       => sample_values_0_o,  		-- pacote sv com info q (ok)

      quality_fill_i => quality_or_0_to_quality_insert

      ); 
	  
  --board_1---    
  
  quality_ctlr_1 : entity work.quality_ctlr
    generic map (
      VALUE1 => VALUE1,
      VALUE2 => VALUE2,
      VALUE3 => VALUE3,
      BITS   => BITS,
      Q_BITS => Q_BITS)
    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      acq_data_in    => acq_data_1_i,
      acq_data_ready => acq_data_ready_1_i,

      gain_register_data_in    => gain_register_data_1_i,
      gain_register_data_ready => gain_register_data_ready_1_i,

      phase_sum_data_ready => phase_sum_data_ready_1_i,  --       
      phase_sum_ovf_i      => phase_sum_ovf_1_i,         --   
      config_i             => config_1_i,                -- configura��o para
                                                         -- leit V ou I
      quality_o            => gate_quality_1,            -- para "or"
      q_vector_ready_o     => gate_quality_1_ok);        -- para "or"



  -- ultimo ok tem que vir do phase_sum
  quality_or_1 : entity work.quality_or
    port map

    (
      sysclk  => sysclk,
      reset_n => reset_n,

      quality_gate_in => gate_quality_1,
      quality_soft_in => (others => '0'),
      quality_o       => quality_or_1_to_quality_insert,

      data_available_i => gate_quality_1_ok,
      data_ready_o     => quality_or_1_ok
      );


  -- entrada da qualidade, depois phase sum
  quality_insert_1 : entity work.quality_insert
    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      data_in           => sample_values_1_i,  		-- entrada sv 
      data_in_available => quality_or_1_ok, 		-- entrada sv disponivel (interna)

      data_out_ready => sample_values_ready_1_o, 	-- pacote ok (ok) -- para fora
      data_out       => sample_values_1_o,  		-- pacote sv com info q (ok)
						        -- para fora
      
      quality_fill_i => quality_or_1_to_quality_insert

      );                                          



end quality_top_rtl;


-- configurations
