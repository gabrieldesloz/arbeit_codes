-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : channel_adapter.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2013-05-07
-- Last update: 2013-05-08
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-07  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity st_channel_adapter is
  generic(
    CHANNEL_LENGTH : natural := 1;
    ERROR_LENGTH   : natural := 1);

  port (
    sysclk  : in std_logic;
    reset_n : in std_logic;

    asi_ready         : out std_logic;
    asi_valid         : in  std_logic;
    asi_data          : in  std_logic_vector(31 downto 0);
    asi_channel       : in  std_logic_vector(CHANNEL_LENGTH-1 downto 0);
    asi_error         : in  std_logic_vector(ERROR_LENGTH-1 downto 0);
    asi_startofpacket : in  std_logic;
    asi_endofpacket   : in  std_logic;
    asi_empty         : in  std_logic_vector(1 downto 0);

    aso_ready         : in std_logic;
    aso_valid         : out std_logic;
    aso_data          : out std_logic_vector(31 downto 0);
    aso_error         : out std_logic_vector(ERROR_LENGTH-1 downto 0);
    aso_startofpacket : out std_logic;
    aso_endofpacket   : out std_logic;
    aso_empty         : out std_logic_vector(1 downto 0)


    );
end st_channel_adapter;


architecture st_channel_adapter_rtl of st_channel_adapter is

  signal aso_channel : std_logic_vector(CHANNEL_LENGTH-1 downto 0);

begin  -- channel_adapter_rtl

  asi_ready         <= aso_ready;
  aso_valid         <= asi_valid;
  aso_data          <= asi_data;
  aso_error         <= asi_error;
  aso_startofpacket <= asi_startofpacket;
  aso_endofpacket   <= asi_endofpacket;
  aso_empty         <= asi_empty;

  aso_channel <= asi_channel;

end st_channel_adapter_rtl;
