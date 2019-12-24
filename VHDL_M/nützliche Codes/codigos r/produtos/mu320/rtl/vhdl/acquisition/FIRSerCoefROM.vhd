-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : FIR coefficients
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firsercoefrom.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  Coeficient ROM of the FIR filter - Single Port Memory
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

entity FIRSerCoefROM is
  generic
    (
      -- Filter Order - Number of TAPs
      FILTER_ORDER      : natural := 127;  -- Number of TAPs and Coeficients of the filer
      FILTER_ORDER_SIZE : natural := 8;  -- Number of bits to represent the filter order - Used to generate the address size of the memories
      -- Coeficients
      COEFICIENT_WIDTH  : natural := 16  -- Size of coeficient path in bits
      );
  port
    (
      -- Common signals
      sysclk      : in  std_logic;      -- Clock  active high signal
      -- Interface Signals
      ReadAddress : in  std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
      ReadData    : out std_logic_vector(COEFICIENT_WIDTH-1 downto 0)  -- Data read from RAM
      );
end FIRSerCoefROM;


architecture FIRSerCoefROM_rtl of FIRSerCoefROM is
  signal ReadAddressInt : integer;      -- Integer value of Read Address 

begin

-- Global integer conversion
  ReadAddressInt <= CONV_INTEGER(ReadAddress);


--* --------------------------------------------------------------------------------------------------------------------------------------
--* Coeficient Single-Port Coeficient ROM generation
--* Generate the single-port coeficient ROM
--* Input      : readaddress
--* Output     : readdata
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      case ReadAddressInt is
        when 0      => ReadData <= std_logic_vector(TO_SIGNED(-14, COEFICIENT_WIDTH));
        when 1      => ReadData <= std_logic_vector(TO_SIGNED(18, COEFICIENT_WIDTH));
        when 2      => ReadData <= std_logic_vector(TO_SIGNED(16, COEFICIENT_WIDTH));
        when 3      => ReadData <= std_logic_vector(TO_SIGNED(-93, COEFICIENT_WIDTH));
        when 4      => ReadData <= std_logic_vector(TO_SIGNED(22, COEFICIENT_WIDTH));
        when 5      => ReadData <= std_logic_vector(TO_SIGNED(253, COEFICIENT_WIDTH));
        when 6      => ReadData <= std_logic_vector(TO_SIGNED(-261, COEFICIENT_WIDTH));
        when 7      => ReadData <= std_logic_vector(TO_SIGNED(-508, COEFICIENT_WIDTH));
        when 8      => ReadData <= std_logic_vector(TO_SIGNED(1154, COEFICIENT_WIDTH));
        when 9      => ReadData <= std_logic_vector(TO_SIGNED(2513, COEFICIENT_WIDTH));
        when 10     => ReadData <= std_logic_vector(TO_SIGNED(1154, COEFICIENT_WIDTH));
        when 11     => ReadData <= std_logic_vector(TO_SIGNED(-508, COEFICIENT_WIDTH));
        when 12     => ReadData <= std_logic_vector(TO_SIGNED(-261, COEFICIENT_WIDTH));
        when 13     => ReadData <= std_logic_vector(TO_SIGNED(253, COEFICIENT_WIDTH));
        when 14     => ReadData <= std_logic_vector(TO_SIGNED(22, COEFICIENT_WIDTH));
        when 15     => ReadData <= std_logic_vector(TO_SIGNED(-93, COEFICIENT_WIDTH));
        when 16     => ReadData <= std_logic_vector(TO_SIGNED(16, COEFICIENT_WIDTH));
        when 17     => ReadData <= std_logic_vector(TO_SIGNED(18, COEFICIENT_WIDTH));
        when 18     => ReadData <= std_logic_vector(TO_SIGNED(-14, COEFICIENT_WIDTH));
        when others => ReadData <= (others => '0');
      end case;
    end if;
  end process;

end FIRSerCoefROM_rtl;

