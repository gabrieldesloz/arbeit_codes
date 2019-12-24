-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synchronization_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-06-29
-- Last update: 2012-06-29
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-06-29  1.0      lgs	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity synchronization_tb is

end synchronization_tb;

-------------------------------------------------------------------------------

architecture sync_tb of synchronization_tb is

  component synchronization
    port (
      n_reset        : in  std_logic;
      sysclk         : in  std_logic;
      freq_sel       : in  std_logic;
      pps            : in  std_logic;
      locked         : out std_logic;
      locking        : out std_logic;
      sync_soc       : out std_logic;
      freq_mclk      : out std_logic;
      edge_freq_mclk : out std_logic);
  end component;

  -- component ports
  signal n_reset        : std_logic;
  signal sysclk         : std_logic;
  signal freq_sel       : std_logic;
  signal pps            : std_logic;
  signal locked         : std_logic;
  signal locking        : std_logic;
  signal sync_soc       : std_logic;
  signal freq_mclk      : std_logic;
  signal edge_freq_mclk : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- sync_tb

  -- component instantiation
  DUT: synchronization
    port map (
      n_reset        => n_reset,
      sysclk         => sysclk,
      freq_sel       => freq_sel,
      pps            => pps,
      locked         => locked,
      locking        => locking,
      sync_soc       => sync_soc,
      freq_mclk      => freq_mclk,
      edge_freq_mclk => edge_freq_mclk);

  -- clock generation
  Clk <= not Clk after 5 ns;

  sysclk <= Clk;

  process
  begin  -- process
    n_reset <= '0';
    wait for 10 us;
    n_reset <= '1';
    wait;
  end process;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    pps <= '0';
    freq_sel <= '0';
    wait for 1000 ms;
    pps <= '1';
    wait for 10 ns;
    pps <= '0';
    wait for 1001 ms;
    pps <= '1';
    wait for 10 ns;
    
  end process WaveGen_Proc;

  

end sync_tb;

-------------------------------------------------------------------------------

configuration synchronization_tb_sync_tb_cfg of synchronization_tb is
  for sync_tb
  end for;
end synchronization_tb_sync_tb_cfg;

-------------------------------------------------------------------------------
