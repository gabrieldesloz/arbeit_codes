-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : dig_goose_processor_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-23
-- Last update: 2012-08-29
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-23  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity dig_goose_processor_tb is

end dig_goose_processor_tb;

-------------------------------------------------------------------------------

architecture dig_goose_processor_tb_rtl of dig_goose_processor_tb is

  component dig_goose_processor
    generic (
      ERROR_LENGTH : natural);
    port (
      reset_n      : in  std_logic;
      sysclk       : in  std_logic;
      clk          : in  std_logic;
      address      : in  std_logic_vector(7 downto 0);
      byteenable   : in  std_logic_vector(3 downto 0);
      writedata    : in  std_logic_vector(31 downto 0);
      write        : in  std_logic;
      chipselect   : in  std_logic;
      source_ready : in  std_logic;
      source_valid : out std_logic;
      source_data  : out std_logic_vector(31 downto 0);
      source_empty : out std_logic_vector(1 downto 0);
      source_sop   : out std_logic;
      source_eop   : out std_logic;
      source_err   : out std_logic_vector((ERROR_LENGTH - 1) downto 0);
      digital_in   : in  std_logic_vector(15 downto 0);
      pps          : in  std_logic);
  end component;

  -- component generics
  constant ERROR_LENGTH : natural := 1;

  -- component ports
  signal reset_n      : std_logic;
  signal sysclk       : std_logic;
  signal clk          : std_logic;
  signal address      : std_logic_vector(7 downto 0);
  signal byteenable   : std_logic_vector(3 downto 0);
  signal writedata    : std_logic_vector(31 downto 0);
  signal write        : std_logic;
  signal chipselect   : std_logic;
  signal source_ready : std_logic;
  signal source_valid : std_logic;
  signal source_data  : std_logic_vector(31 downto 0);
  signal source_empty : std_logic_vector(1 downto 0);
  signal source_sop   : std_logic;
  signal source_eop   : std_logic;
  signal source_err   : std_logic_vector((ERROR_LENGTH - 1) downto 0);
  signal digital_in   : std_logic_vector(15 downto 0);
  signal pps          : std_logic;

  -- clock
  signal Clock : std_logic := '1';

begin  -- dig_goose_processor_tb_rtl

  -- component instantiation
  DUT : dig_goose_processor
    generic map (
      ERROR_LENGTH => ERROR_LENGTH)
    port map (
      reset_n      => reset_n,
      sysclk       => sysclk,
      clk          => clk,
      address      => address,
      byteenable   => byteenable,
      writedata    => writedata,
      write        => write,
      chipselect   => chipselect,
      source_ready => source_ready,
      source_valid => source_valid,
      source_data  => source_data,
      source_empty => source_empty,
      source_sop   => source_sop,
      source_eop   => source_eop,
      source_err   => source_err,
      digital_in   => digital_in,
      pps          => pps);

  -- clock generation
  Clock  <= not Clock after 5 ns;
  sysclk <= Clock;

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
    wait for 10 ms;
    pps <= '1';
    wait for 10 ns;
    pps <= '0';
    wait until Clock = '1';
  end process WaveGen_Proc;


  process
  begin  -- process
    digital_in <= (others => '0');
    wait for 100 ms;
    digital_in <= (others => '1');
    wait for 100 ms;
    digital_in <= (others => '0');
    wait;
  end process;  

end dig_goose_processor_tb_rtl;

-------------------------------------------------------------------------------

configuration dig_goose_processor_tb_dig_goose_processor_tb_rtl_cfg of dig_goose_processor_tb is
  for dig_goose_processor_tb_rtl
  end for;
end dig_goose_processor_tb_dig_goose_processor_tb_rtl_cfg;

-------------------------------------------------------------------------------
