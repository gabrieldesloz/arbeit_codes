-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-06
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;
-------------------------------------------------------------------------------

entity quality_insert_tb is

end quality_insert_tb;

-------------------------------------------------------------------------------

architecture quality_insert_rtl_tb of quality_insert_tb is

  component quality_insert
    port (
      sysclk            : in  std_logic;
      reset_n           : in  std_logic;
      data_in           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
      data_in_available : in  std_logic;
      data_out_ready    : out std_logic;
      data_out          : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
      quality_fill      : in std_logic_vector(31 downto 0)
      );
  end component;

  -- component ports
  signal sysclk            : std_logic := '0';
  signal reset_n           : std_logic := '0';
  signal data_in           : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0) := (others => '0');
  signal data_in_available : std_logic := '0';
  signal data_out_ready    : std_logic := '0';
  signal data_out          : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0)  := (others => '0');
  --preenchimento seletivo para visualiza��o
  signal quality_fill      : std_logic_vector(31 downto 0) := (13 => '1', 14 => '1', 15 =>'1', 16 => '1', others => '0'); 


  -- clock
  signal Clk : std_logic := '1';

begin

  -- component instantiation
  DUT : quality_insert
    port map (
      sysclk            => sysclk,
      reset_n           => reset_n,
      data_in           => data_in,
      data_in_available => data_in_available,
      data_out_ready    => data_out_ready,
      data_out          => data_out,
      quality_fill      => quality_fill
      );

  -- clock generation
  Clk    <= not Clk after 5 ns;
  sysclk <= Clk;
  process
  begin  -- process
    reset_n <= '0';
    wait for 50 ns;
    reset_n <= '1';
    wait;
  end process;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    data_in_available <= '0';
    data_in           <= x"AAAA0AAA0AAA0AAA0AAA0AAAAAAA0AAA0AAA0AAAAAAA0AAA0AAA0AAA0AAA0AAA";
    wait for 100 ns;
    data_in_available <= '1';
    wait for 10 ns;
    data_in_available <= '0';
    wait;
  end process WaveGen_Proc;

  

end quality_insert_rtl_tb;

