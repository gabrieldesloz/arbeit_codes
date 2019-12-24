-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : BFILTER DATA RAM
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : bfilter_data_ram.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-04-22
-- Last update: 2012-12-07
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  RAM to store BFILTER data
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-04-22   1.0      CLS     Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity bfilter_data_ram is
  generic
    (
      DATA_WIDTH : natural := 25  -- Size of input and output sample data path in bits     
      );

  port
    (
      sysclk : in std_logic;            -- Clock  active high signal

      -- CPU Interface Signals
      ReadAddress  : in  std_logic_vector(3 downto 0);  -- Read Address
      WriteAddress : in  std_logic_vector(3 downto 0);  -- Write Address     
      write        : in  std_logic;     -- Write signal
      WriteData    : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data to be written
      ReadData     : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Data read from RAM
      );
end bfilter_data_ram;

architecture bfilter_data_ram_rtl of bfilter_data_ram is
  type   MemoryType is array (15 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
  signal Memory                : MemoryType;
  attribute ramstyle           : string;
  attribute ramstyle of Memory : signal is "M9K";

  
begin

  
--* --------------------------------------------------------------------------------------------------------------------------------------
--* Dual-Port RAM generation
--* Generate the simple dual-port RAM
--* Input      : writedata, write, WriteAddress, ReadAddress
--* Output     : readdata
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (write = '1') then
        Memory(CONV_INTEGER(WriteAddress)) <= WriteData;
      end if;
       ReadData <= Memory(CONV_INTEGER(ReadAddress));
    end if;
  end process;

end bfilter_data_ram_rtl;

