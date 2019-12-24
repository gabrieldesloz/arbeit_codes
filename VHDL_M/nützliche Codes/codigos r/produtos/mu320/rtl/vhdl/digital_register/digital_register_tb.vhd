-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : digital_register_tb.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2013-02-11
-- Last update: 2013-02-11
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-02-11  1.0      lgs     Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity digital_register_tb is

end digital_register_tb;

-------------------------------------------------------------------------------

architecture digital_register_tb_struct of digital_register_tb is

  component digital_register
    port (
      reset_n              : in  std_logic;
      sysclk               : in  std_logic;
      data_input_available : in  std_logic;
      data_input           : in  std_logic_vector(31 downto 0);
      data_output          : out std_logic_vector(15 downto 0);
      digital_clk          : in  std_logic;
      digital_address      : in  std_logic_vector(1 downto 0);
      digital_readdata     : out std_logic_vector(31 downto 0);
      digital_read         : in  std_logic;
      digital_chipselect   : in  std_logic;
      digital_writedata    : in  std_logic_vector(31 downto 0);
      digital_write        : in  std_logic;
      digital_irq          : out std_logic);
  end component;

  -- component ports
  signal reset_n              : std_logic := '0';
  signal sysclk               : std_logic := '1';
  signal data_input_available : std_logic;
  signal data_input           : std_logic_vector(31 downto 0);
  signal data_output          : std_logic_vector(15 downto 0);
  signal digital_clk          : std_logic := '1';
  signal digital_address      : std_logic_vector(1 downto 0);
  signal digital_readdata     : std_logic_vector(31 downto 0);
  signal digital_read         : std_logic;
  signal digital_chipselect   : std_logic;
  signal digital_writedata    : std_logic_vector(31 downto 0);
  signal digital_write        : std_logic;
  signal digital_irq          : std_logic;

begin  -- digital_register_tb_struct

  -- component instantiation
  DUT : digital_register
    port map (
      reset_n              => reset_n,
      sysclk               => sysclk,
      data_input_available => data_input_available,
      data_input           => data_input,
      data_output          => data_output,
      digital_clk          => digital_clk,
      digital_address      => digital_address,
      digital_readdata     => digital_readdata,
      digital_read         => digital_read,
      digital_chipselect   => digital_chipselect,
      digital_writedata    => digital_writedata,
      digital_write        => digital_write,
      digital_irq          => digital_irq);

  -- clock generation
  sysclk      <= not sysclk      after 5 ns;
  digital_clk <= not digital_clk after 5 ns;


  -- waveform generation
  WaveGen_Proc : process
  begin
    digital_chipselect   <= '0';
    digital_write        <= '0';
    digital_read         <= '0';
    digital_writedata    <= (others => '0');
    digital_address      <= (others => '0');
    data_input           <= (others => '0');
    data_input_available <= '0';
    wait for 50 ns;
    reset_n              <= '1';
    wait for 200 us;
    digital_chipselect   <= '1';
    digital_write        <= '1';
    digital_writedata    <= x"00000001";
    digital_address      <= "00";
    wait for 10 ns;
    digital_chipselect   <= '0';
    digital_write        <= '0';
    digital_read         <= '0';
    wait for 200 us;
    data_input <= x"AAAA5555";
    data_input_available <= '1';
    wait for 10 ns;
    data_input_available <= '0';
    wait for 100 us;
    digital_chipselect   <= '1';
    digital_write        <= '1';
    digital_writedata    <= x"00000002";
    digital_address      <= "01";
    wait for 10 ns;
    digital_chipselect   <= '0';
    digital_write        <= '0';
    digital_read         <= '0';
    wait for 100 us;
    digital_chipselect   <= '1';
    digital_write        <= '1';
    digital_writedata    <= x"0000AAAA";
    digital_address      <= "11";
    wait for 10 ns;
    digital_chipselect   <= '0';
    digital_write        <= '0';
    digital_read         <= '0';
    wait for 200 us;
    data_input <= x"5555AAAA";
    data_input_available <= '1';
    wait for 10 ns;
    data_input_available <= '0';



    wait;
  end process WaveGen_Proc;

  

end digital_register_tb_struct;

-------------------------------------------------------------------------------

configuration digital_register_tb_digital_register_tb_struct_cfg of digital_register_tb is
  for digital_register_tb_struct
  end for;
end digital_register_tb_digital_register_tb_struct_cfg;

-------------------------------------------------------------------------------
