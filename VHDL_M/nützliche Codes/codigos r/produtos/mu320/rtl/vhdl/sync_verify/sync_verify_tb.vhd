-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : sync_verify_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-09-10
-- Last update: 2012-09-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-10  1.0      lgs	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity sync_verify_tb is

end sync_verify_tb;

-------------------------------------------------------------------------------

architecture sync_verify_rtl_tb of sync_verify_tb is

  component sync_verify
    port (
      reset_n   : in  STD_LOGIC;
      sysclk    : in  STD_LOGIC;
      sync_irig : in  STD_LOGIC_VECTOR(7 downto 0);
      smp_sync  : out STD_LOGIC_VECTOR(1 downto 0));
  end component;

  -- component ports
  signal reset_n   : STD_LOGIC;
  signal sysclk    : STD_LOGIC;
  signal sync_irig : STD_LOGIC_VECTOR(7 downto 0);
  signal smp_sync  : STD_LOGIC_VECTOR(1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- sync_verify_rtl_tb

  -- component instantiation
  DUT: sync_verify
    port map (
      reset_n   => reset_n,
      sysclk    => sysclk,
      sync_irig => sync_irig,
      smp_sync  => smp_sync);

  -- clock generation
  Clk <= not Clk after 5 ns;
  sysclk <= Clk;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    reset_n <= '0';
    wait for 50 ns;
    reset_n <= '1';
    wait for 1 us;
    sync_irig <= "00000000";
    wait for 50 us;
    sync_irig <= "01000000";
    wait for 50 us;
    sync_irig <= "01010000";
    wait for 100 us;
    sync_irig <= "11111111";
    wait for 300 us;
    sync_irig <= "00000000";
    wait;

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end sync_verify_rtl_tb;

-------------------------------------------------------------------------------

configuration sync_verify_tb_sync_verify_rtl_tb_cfg of sync_verify_tb is
  for sync_verify_rtl_tb
  end for;
end sync_verify_tb_sync_verify_rtl_tb_cfg;

-------------------------------------------------------------------------------
