-------------------------------------------------------------------------------
-- Title      : Testbench for design "comm_top"
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : comm_top_tb.vhd
-- Author     :	  <S10169@SMKM02>
-- Company    : 
-- Created    : 2014-09-30
-- Last update: 2014-09-30
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2014-09-30  1.0	S10169	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity comm_top_tb is

end entity comm_top_tb;

-------------------------------------------------------------------------------

architecture arq of comm_top_tb is

  -- component ports
  signal CLK_i		   : std_logic := '0';
  signal DATA_RX_serial_i  : std_logic := '0';
  signal SYNC_CLK_serial_i : std_logic := '0';
  signal DATA_TX_serial_o  : std_logic;
  signal EATX_i		   : std_logic := '0';
  signal EARX_o		   : std_logic;
  signal EBRX_o		   : std_logic;
  signal clk_60MHz_o	   : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arq

  -- component instantiation
  DUT : entity work.comm_top
    port map (
      CLK_i		=> CLK_i,	-- [std_logic]
      DATA_RX_serial_i	=> '0',		-- [std_logic]
      SYNC_CLK_serial_i => '0',		-- [std_logic]
      DATA_TX_serial_o	=> open,	-- [std_logic]
      EATX_i		=> '1',		-- [std_logic]
      EARX_o		=> open,	-- [std_logic]
      EBRX_o		=> open,	-- [std_logic]
      clk_60MHz_o	=> open);	-- [std_logic]

  -- clock generation
  CLK_i <= not CLK_i after 16.67 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture arq;

-------------------------------------------------------------------------------

configuration comm_top_tb_arq_cfg of comm_top_tb is
  for arq
  end for;
end comm_top_tb_arq_cfg;

-------------------------------------------------------------------------------
