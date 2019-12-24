-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sv_packet_processor_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-07-31
-- Last update: 2012-09-12
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-07-31  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------

entity sv_packet_processor_tb is

end sv_packet_processor_tb;

-------------------------------------------------------------------------------

architecture sv_packet_processor_tb_rtl of sv_packet_processor_tb is

  component sv_packet_processor
    generic (
      ERROR_LENGTH : natural);
    port (
      reset_n                      : in  std_logic;
      clk                          : in  std_logic;
      sysclk                       : in  std_logic;
      address                      : in  std_logic_vector(7 downto 0);
      byteenable                   : in  std_logic_vector(3 downto 0);
      writedata                    : in  std_logic_vector(31 downto 0);
      write                        : in  std_logic;
      chipselect                   : in  std_logic;
      source_ready                 : in  std_logic;
      source_valid                 : out std_logic;
      source_data                  : out std_logic_vector(31 downto 0);
      source_empty                 : out std_logic_vector(1 downto 0);
      source_sop                   : out std_logic;
      source_eop                   : out std_logic;
      source_err                   : out std_logic_vector((ERROR_LENGTH - 1) downto 0);
      protection_analog_data_input : in  std_logic_vector(511 downto 0);
      protection_analog_data_ready : in  std_logic;
      monitoring_analog_data_input : in  std_logic_vector(511 downto 0);
      monitoring_analog_data_ready : in  std_logic;
      monitoring_analog_new_data   : out std_logic;
      pps                          : in  std_logic);
  end component;

  -- component generics
  constant ERROR_LENGTH : natural := 1;

  -- component ports
  signal reset_n                      : std_logic;
  signal clk                          : std_logic := '0';
  signal sysclk                       : std_logic := '0';
  signal address                      : std_logic_vector(7 downto 0);
  signal byteenable                   : std_logic_vector(3 downto 0);
  signal writedata                    : std_logic_vector(31 downto 0);
  signal write                        : std_logic;
  signal chipselect                   : std_logic;
  signal source_ready                 : std_logic;
  signal source_valid                 : std_logic;
  signal source_data                  : std_logic_vector(31 downto 0);
  signal source_empty                 : std_logic_vector(1 downto 0);
  signal source_sop                   : std_logic;
  signal source_eop                   : std_logic;
  signal source_err                   : std_logic_vector((ERROR_LENGTH - 1) downto 0);
  signal protection_analog_data_input : std_logic_vector(511 downto 0);
  signal protection_analog_data_ready : std_logic;
  signal monitoring_analog_data_input : std_logic_vector(511 downto 0);
  signal monitoring_analog_data_ready : std_logic;
  signal monitoring_analog_new_data   : std_logic;
  signal pps                          : std_logic;
  signal addr                         : std_logic_vector(7 downto 0);

  -- clock
  

begin  -- sv_packet_processor_tb_rtl

  -- component instantiation
  DUT : sv_packet_processor
    generic map (
      ERROR_LENGTH => ERROR_LENGTH)
    port map (
      reset_n                      => reset_n,
      clk                          => clk,
      sysclk                       => sysclk,
      address                      => address,
      byteenable                   => byteenable,
      writedata                    => writedata,
      write                        => write,
      chipselect                   => chipselect,
      source_ready                 => source_ready,
      source_valid                 => source_valid,
      source_data                  => source_data,
      source_empty                 => source_empty,
      source_sop                   => source_sop,
      source_eop                   => source_eop,
      source_err                   => source_err,
      protection_analog_data_input => protection_analog_data_input,
      protection_analog_data_ready => protection_analog_data_ready,
      monitoring_analog_data_input => monitoring_analog_data_input,
      monitoring_analog_data_ready => monitoring_analog_data_ready,
      monitoring_analog_new_data   => monitoring_analog_new_data,
      pps                          => pps);

  -- clock generation
  sysclk <= not sysclk after 5 ns;
  clk    <= not clk    after 8 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    -- insert signal assignments here
    addr                         <= (others => '0');
    reset_n                      <= '0';
    wait for 10 us;
    reset_n                      <= '1';
    wait for 60 ns;
    protection_analog_data_input <= x"AAAAAAAA55555555BBBBBBBB66666666CCCCCCCC77777777DDDDDDDD88888888EEEEEEEE99999999FFFFFFFF0000000033333333444444442222222299999999";
    monitoring_analog_data_input <= x"55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555";

    -- CONFIG Write
    protection_analog_data_ready <= '1';
    monitoring_analog_data_ready <= '1';
    source_ready                 <= '1';
    byteenable                   <= "1111";
    writedata                    <= x"01002B01";
    chipselect                   <= '1';
    address                      <= addr;
    write                        <= '1';
    addr                         <= addr + '1';
    wait for 16 ns;
    write                        <= '0';
    wait for 16 ns;
    address                      <= addr;
    writedata                    <= x"0114004F";
    write                        <= '1';
    addr                         <= addr + '1';
    wait for 16 ns;
    write                        <= '0';
    wait for 16 ns;
    address                      <= addr;
    writedata                    <= x"41060A00";
    write                        <= '1';
    addr                         <= addr + '1';
    wait for 16 ns;
    write                        <= '0';
    wait for 16 ns;
    address                      <= addr;
    writedata                    <= x"00000000";
    write                        <= '1';
    addr                         <= addr + '1';
    wait for 16 ns;
    write                        <= '0';

    -- PACKET Write
    wait for 16 ns;
    address   <= addr;
    writedata <= x"0005DF77";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"32120005";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"DF773313";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"81008001";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"88BA4000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00680000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"0000605E";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"800101A2";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"59305780";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"074D5530";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"32820200";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00830101";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"85010087";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"40000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00000000";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"00FFFFFF";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';
    wait for 16 ns;
    address   <= addr;
    writedata <= x"FFFFFFFF";
    write     <= '1';
    addr      <= addr + '1';
    wait for 16 ns;
    write     <= '0';

    protection_analog_data_ready <= '0';
    monitoring_analog_data_ready <= '0';
    wait for 10 ns;
    protection_analog_data_ready <= '1';
    monitoring_analog_data_ready <= '1';

    wait until monitoring_analog_new_data = '1';
    monitoring_analog_data_input <= x"66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666";

    wait until monitoring_analog_new_data = '1';
    monitoring_analog_data_input <= x"77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777";

    wait for 65 us;
    protection_analog_data_ready <= '0';
    monitoring_analog_data_ready <= '0';
    wait for 10 ns;
    protection_analog_data_ready <= '1';
    monitoring_analog_data_ready <= '1';

    wait;

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end sv_packet_processor_tb_rtl;

-------------------------------------------------------------------------------

configuration sv_packet_processor_tb_sv_packet_processor_tb_rtl_cfg of sv_packet_processor_tb is
  for sv_packet_processor_tb_rtl
  end for;
end sv_packet_processor_tb_sv_packet_processor_tb_rtl_cfg;

-------------------------------------------------------------------------------
