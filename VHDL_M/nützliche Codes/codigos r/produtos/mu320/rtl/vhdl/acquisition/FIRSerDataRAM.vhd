-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : RAM FIR serial
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firserdataram.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  Data RAM System of Sequential FIR - dual port memory
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-25   1.0      CLS     Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FIRSerDataRAM is
  generic
    (
      CHANNEL           : natural := 16;  -- Number of channels
      CHANNEL_SIZE      : natural := 4;  -- Number of bits to represent channels
      -- Filter Order - Number of TAPs
      FILTER_ORDER      : natural := 1024;  -- Number of TAPs and Coeficients of the filer
      FILTER_ORDER_SIZE : natural := 10;  -- Number of bits to represent the filter order - Used to generate the address size of the memories
      DATA_WIDTH        : natural := 16;  -- Size of input and output sample data path in bits
      MEMORY_SIZE       : natural := 64  -- Memory Size 2^(CHANNEL_SIZE + FILTER_ORDER_SIZE)
      );

  port
    (
      sysclk : in std_logic;            -- Clock  active high signal

      -- CPU Interface Signals
      ReadAddress   : in  std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
      WriteAddress  : in  std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Write Address
      ActualChannel : in  std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered
      write         : in  std_logic;    -- Write signal
      WriteData     : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data to be written
      ReadData      : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Data read from RAM
      );
end FIRSerDataRAM;

architecture FIRSerDataRAM_rtl of FIRSerDataRAM is
  type MemoryType is array (MEMORY_SIZE - 1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
  signal Memory        : MemoryType;
  signal TWriteAddress : std_logic_vector((FILTER_ORDER_SIZE + CHANNEL_SIZE - 1) downto 0);
  signal TReadAddress  : std_logic_vector((FILTER_ORDER_SIZE + CHANNEL_SIZE - 1) downto 0);
begin

  TWriteAddress <= ActualChannel & WriteAddress;
  TReadAddress  <= ActualChannel & ReadAddress;

--* --------------------------------------------------------------------------------------------------------------------------------------
--* Dual-Port RAM generation
--* Generate the simple dual-port RAM
--* Input      : writedata, write, Twriteaddress, Treadaddress
--* Output     : readdata
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (write = '1') then
        Memory(CONV_INTEGER(TWriteAddress)) <= WriteData;
      end if;
      ReadData <= Memory(CONV_INTEGER(TReadAddress));
    end if;
  end process;

end FIRSerDataRAM_rtl;

