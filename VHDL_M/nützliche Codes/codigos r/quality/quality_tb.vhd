-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2013-10-29
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0      lgs	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;
-------------------------------------------------------------------------------

entity quality_tb is

end quality_tb;

-------------------------------------------------------------------------------

architecture quality_rtl_tb of quality_tb is

  component quality
    port (
      sysclk            : in  std_logic;
      reset_n           : in  std_logic;
      data_in           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
      data_in_available : in  std_logic;
      data_out_ready    : out std_logic;
      data_out          : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0));
  end component;

  -- component ports
  signal sysclk            : std_logic;
  signal reset_n           : std_logic;
  signal data_in           : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
  signal data_in_available : std_logic;
  signal data_out_ready    : std_logic;
  signal data_out          : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- quality_rtl_tb

  -- component instantiation
  DUT: quality
    port map (
      sysclk            => sysclk,
      reset_n           => reset_n,
      data_in           => data_in,
      data_in_available => data_in_available,
      data_out_ready    => data_out_ready,
      data_out          => data_out);

  -- clock generation
  Clk <= not Clk after 5 ns;
  sysclk <= Clk;
  process
  begin  -- process
    reset_n <= '0';
    wait for 50 ns;
    reset_n <= '1';
    wait;
  end process;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    data_in_available <= '0';
    data_in <= x"AAAA0AAA0AAA0AAA0AAA0AAAAAAA0AAA0AAA0AAAAAAA0AAA0AAA0AAA0AAA0AAA";
    wait for 100 ns;
    data_in_available <= '1';
    wait for 10 ns;
    data_in_available <= '0';
    wait;
  end process WaveGen_Proc;

  

end quality_rtl_tb;

-------------------------------------------------------------------------------

configuration quality_tb_quality_rtl_tb_cfg of quality_tb is
  for quality_rtl_tb
  end for;
end quality_tb_quality_rtl_tb_cfg;

-------------------------------------------------------------------------------
