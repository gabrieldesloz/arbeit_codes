-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : backplane_leds_tb.vhdl
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-09-17
-- Last update: 2012-09-17
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-17  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity backplane_leds_tb is

end backplane_leds_tb;

-------------------------------------------------------------------------------

architecture backplane_leds_tb_rtl of backplane_leds_tb is

  component backplane_leds
    port (
      reset_n            : in  std_logic;
      sysclk             : in  std_logic;
      linux_ok           : in  std_logic;
      link_eth_0         : in  std_logic;
      link_eth_1         : in  std_logic;
      sync_irig          : in  std_logic_vector(1 downto 0);
      backplane_leds_out : out std_logic_vector(15 downto 0));
  end component;

  -- component ports
  signal reset_n            : std_logic;
  signal sysclk             : std_logic;
  signal linux_ok           : std_logic;
  signal link_eth_0         : std_logic;
  signal link_eth_1         : std_logic;
  signal sync_irig          : std_logic_vector(1 downto 0);
  signal backplane_leds_out : std_logic_vector(15 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- backplane_leds_tb_rtl

  -- component instantiation
  DUT : backplane_leds
    port map (
      reset_n            => reset_n,
      sysclk             => sysclk,
      linux_ok           => linux_ok,
      link_eth_0         => link_eth_0,
      link_eth_1         => link_eth_1,
      sync_irig          => sync_irig,
      backplane_leds_out => backplane_leds_out);

  -- clock generation
  Clk    <= not Clk after 5 ns;
  sysclk <= Clk;

  process
  begin  -- process
    reset_n <= '0';
    wait for 1 us;
    reset_n <= '1';
    wait;
  end process;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    linux_ok   <= '0';
    link_eth_0 <= '1';
    link_eth_1 <= '1';
    sync_irig  <= "01";
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end backplane_leds_tb_rtl;

-------------------------------------------------------------------------------

configuration backplane_leds_tb_backplane_leds_tb_rtl_cfg of backplane_leds_tb is
  for backplane_leds_tb_rtl
  end for;
end backplane_leds_tb_backplane_leds_tb_rtl_cfg;

-------------------------------------------------------------------------------
