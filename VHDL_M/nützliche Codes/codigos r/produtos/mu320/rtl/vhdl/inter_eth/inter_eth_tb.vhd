-------------------------------------------------------------------------------
-- Title      : Testbench for design "inter_eth"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : inter_eth_tb.vhd
-- Author     :   <lgs@IRIS>
-- Company    : 
-- Created    : 2012-05-21
-- Last update: 2012-06-13
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-05-21  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity inter_eth_tb is

end inter_eth_tb;

-------------------------------------------------------------------------------

architecture inter_eth_tb_rtl of inter_eth_tb is

  component inter_eth
    generic (
      SYMBOLS_PER_BEAT : natural;
      BITS_PER_SYMBOL  : natural;
      READY_LATENCY    : natural;
      ERROR_LENGTH     : natural);
    port (
      reset_n           : in  std_logic;
      sysclk            : in  std_logic;
      sink_dma_ready    : out std_logic;
      sink_dma_valid    : in  std_logic;
      sink_dma_data     : in  std_logic_vector(31 downto 0);
      sink_dma_empty    : in  std_logic_vector(1 downto 0);
      sink_dma_sop      : in  std_logic;
      sink_dma_eop      : in  std_logic;
      sink_dma_err      : in  std_logic_vector((ERROR_LENGTH - 1) downto 0);
      sink_analog_ready : out std_logic;
      sink_analog_valid : in  std_logic;
      sink_analog_data  : in  std_logic_vector(31 downto 0);
      sink_analog_empty : in  std_logic_vector(1 downto 0);
      sink_analog_sop   : in  std_logic;
      sink_analog_eop   : in  std_logic;
      sink_analog_err   : in  std_logic_vector((ERROR_LENGTH - 1) downto 0);
      source_ready      : in  std_logic;
      source_valid      : out std_logic;
      source_data       : out std_logic_vector(31 downto 0);
      source_empty      : out std_logic_vector(1 downto 0);
      source_sop        : out std_logic;
      source_eop        : out std_logic;
      source_err        : out std_logic_vector((ERROR_LENGTH - 1) downto 0);
      hold_counter      : in  std_logic_vector(3 downto 0));
  end component;

  -- component generics
  constant SYMBOLS_PER_BEAT : natural := 4;
  constant BITS_PER_SYMBOL  : natural := 8;
  constant READY_LATENCY    : natural := 0;
  constant ERROR_LENGTH     : natural := 1;

  -- component ports
  signal reset_n           : std_logic;
  signal sysclk            : std_logic;
  signal sink_dma_ready    : std_logic;
  signal sink_dma_valid    : std_logic;
  signal sink_dma_data     : std_logic_vector(31 downto 0);
  signal sink_dma_empty    : std_logic_vector(1 downto 0);
  signal sink_dma_sop      : std_logic;
  signal sink_dma_eop      : std_logic;
  signal sink_dma_err      : std_logic_vector((ERROR_LENGTH - 1) downto 0);
  signal sink_analog_ready : std_logic;
  signal sink_analog_valid : std_logic;
  signal sink_analog_data  : std_logic_vector(31 downto 0);
  signal sink_analog_empty : std_logic_vector(1 downto 0);
  signal sink_analog_sop   : std_logic;
  signal sink_analog_eop   : std_logic;
  signal sink_analog_err   : std_logic_vector((ERROR_LENGTH - 1) downto 0);
  signal source_ready      : std_logic;
  signal source_valid      : std_logic;
  signal source_data       : std_logic_vector(31 downto 0);
  signal source_empty      : std_logic_vector(1 downto 0);
  signal source_sop        : std_logic;
  signal source_eop        : std_logic;
  signal source_err        : std_logic_vector((ERROR_LENGTH - 1) downto 0);
  signal hold_counter      : std_logic_vector(3 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- inter_eth_tb_rtl

  -- component instantiation
  DUT : inter_eth
    generic map (
      SYMBOLS_PER_BEAT => SYMBOLS_PER_BEAT,
      BITS_PER_SYMBOL  => BITS_PER_SYMBOL,
      READY_LATENCY    => READY_LATENCY,
      ERROR_LENGTH     => ERROR_LENGTH)
    port map (
      reset_n           => reset_n,
      sysclk            => sysclk,
      sink_dma_ready    => sink_dma_ready,
      sink_dma_valid    => sink_dma_valid,
      sink_dma_data     => sink_dma_data,
      sink_dma_empty    => sink_dma_empty,
      sink_dma_sop      => sink_dma_sop,
      sink_dma_eop      => sink_dma_eop,
      sink_dma_err      => sink_dma_err,
      sink_analog_ready => sink_analog_ready,
      sink_analog_valid => sink_analog_valid,
      sink_analog_data  => sink_analog_data,
      sink_analog_empty => sink_analog_empty,
      sink_analog_sop   => sink_analog_sop,
      sink_analog_eop   => sink_analog_eop,
      sink_analog_err   => sink_analog_err,
      source_ready      => source_ready,
      source_valid      => source_valid,
      source_data       => source_data,
      source_empty      => source_empty,
      source_sop        => source_sop,
      source_eop        => source_eop,
      source_err        => source_err,
      hold_counter      => hold_counter);

  -- clock generation
  Clk <= not Clk after 5 ns;

  sysclk <= Clk;

  process
  begin
    reset_n <= '0';
    wait for 10 us;
    reset_n <= '1';
    wait;
  end process;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    hold_counter      <= x"1";
    sink_dma_valid    <= '0';
    sink_dma_data     <= (others => '0');
    sink_dma_empty    <= (others => '0');
    sink_dma_sop      <= '0';
    sink_dma_eop      <= '0';
    sink_dma_err      <= (others => '0');
    sink_analog_valid <= '0';
    sink_analog_data  <= (others => '0');
    sink_analog_empty <= (others => '0');
    sink_analog_sop   <= '0';
    sink_analog_eop   <= '0';
    sink_analog_err   <= (others => '0');
    source_ready      <= '1';
    wait for 200 us;
    sink_dma_sop      <= '1';
    wait for 20 ns;
    sink_dma_sop      <= '0';
    wait for 1 us;
    sink_dma_data     <= x"AAAAAAAA";
    wait for 1 us;
    sink_dma_data     <= x"55555555";
    wait for 1 us;
    sink_dma_data     <= x"AAAAAAAA";
    sink_dma_eop      <= '1';
    wait for 20 ns;
    sink_dma_eop      <= '0';
    wait until Clk = '1';
  end process WaveGen_Proc;
  

end inter_eth_tb_rtl;

-------------------------------------------------------------------------------

configuration inter_eth_tb_inter_eth_tb_rtl_cfg of inter_eth_tb is
  for inter_eth_tb_rtl
  end for;
end inter_eth_tb_inter_eth_tb_rtl_cfg;

-------------------------------------------------------------------------------
