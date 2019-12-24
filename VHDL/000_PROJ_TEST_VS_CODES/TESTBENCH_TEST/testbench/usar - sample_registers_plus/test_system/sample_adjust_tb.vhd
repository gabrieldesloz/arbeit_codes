-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sample_adjust_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-29
-- Last update: 2013-06-28
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-29  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.mu320_constants.all;

-------------------------------------------------------------------------------

entity sample_adjust_tb is
  port (
    data_in           : in std_logic_vector(255 downto 0);
    data_in_available : in std_logic
    );

end sample_adjust_tb;

-------------------------------------------------------------------------------

architecture sample_adjust_tb_rtl of sample_adjust_tb is

  component sample_adjust
    port (
      clk               : in  std_logic;
      reset_n           : in  std_logic;
      address           : in  std_logic_vector(3 downto 0);
      byteenable        : in  std_logic_vector(3 downto 0);
      writedata         : in  std_logic_vector(31 downto 0);
      write             : in  std_logic;
      chipselect        : in  std_logic;
      sysclk            : in  std_logic;
      data_in           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
      data_in_available : in  std_logic;
      data_out_ready    : out std_logic;
      data_out          : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0));
  end component;

  -- component ports
  signal clk            : std_logic := '1';
  signal reset_n        : std_logic;
  signal address        : std_logic_vector(3 downto 0);
  signal byteenable     : std_logic_vector(3 downto 0);
  signal writedata      : std_logic_vector(31 downto 0);
  signal write          : std_logic;
  signal chipselect     : std_logic;
  signal sysclk         : std_logic;
  signal data_out       : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
  signal data_out_ready : std_logic;

  -- clock
  signal Clock : std_logic := '1';

begin  -- sample_adjust_tb_rtl

  -- component instantiation
  DUT : sample_adjust
    port map (
      clk               => clk,
      reset_n           => reset_n,
      address           => address,
      byteenable        => byteenable,
      writedata         => writedata,
      write             => write,
      chipselect        => chipselect,
      sysclk            => sysclk,
      data_in           => data_in,
      data_in_available => data_in_available,
      data_out_ready    => data_out_ready,
      data_out          => data_out);

  -- clock generation
  Clock <= not Clock after 5 ns;
  clk   <= not clk   after 50 ns;

  sysclk <= Clock;

  process
  begin
    reset_n <= '0';
    wait for 300 ns;
    reset_n <= '1';
    wait;
  end process;

  process
  begin  -- process
    address    <= x"0";
    writedata  <= x"00020000";          --x"11940000";
    chipselect <= '1';
    byteenable <= x"F";
    wait for 400 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"1";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"2";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"3";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"4";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"5";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"6";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"7";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"8";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"9";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"A";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"B";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"C";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"D";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"E";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    address    <= x"F";
    wait for 150 ns;
    write      <= '1';
    wait for 100 ns;
    write      <= '0';
    wait for 150 ns;
    wait;
    
    
  end process;


  --WaveGen_Proc : process
  --begin
  --  -- insert signal assignments here
  --  data_in_available <= '0';
  --  data_in           <= x"AAAA0AAA0AAA0AAA0AAA0AAAAAAA0AAA0AAA0AAAAAAA0AAA0AAA0AAA0AAA0AAA";
  --  wait for 10 us;
  --  data_in_available <= '1';
  --  wait for 10 ns;
  --  data_in_available <= '0';
  --  wait until Clk = '1';
  --end process WaveGen_Proc;

end sample_adjust_tb_rtl;

-------------------------------------------------------------------------------

configuration sample_adjust_tb_sample_adjust_tb_rtl_cfg of sample_adjust_tb is
  for sample_adjust_tb_rtl
  end for;
end sample_adjust_tb_sample_adjust_tb_rtl_cfg;

-------------------------------------------------------------------------------
