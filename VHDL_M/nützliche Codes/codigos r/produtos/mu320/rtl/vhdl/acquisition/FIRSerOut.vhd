-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : FIR output
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firserout.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2012-08-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: FIR serial output control
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
library work;
use work.mu320_constants.all;


entity FIRSerOut is
  generic
    (
      CHANNEL      : natural := 16;     -- Number of channels
      CHANNEL_SIZE : natural := 4;      -- Number of bits to represent channels
      RESULT_WIDTH : natural := 28;     -- Size of data path in bits
      OUTPUT_WIDTH : natural := 16
      );

  port
    (
      -- Common signals
      n_reset : in std_logic;           -- Reset signal - Active High
      enable  : in std_logic;           -- Enable active high signal
      sysclk  : in std_logic;           -- Clock  active high signal

      -- Interface Signals
      ActualChannel : in std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered

      FIROutLoad : in std_logic;        -- Result Load

      FIROutValidIn : in std_logic;     -- Result Valid Input

      ResultIn : in std_logic_vector(RESULT_WIDTH-1 downto 0);  -- Input Result Value from MAC

      FIROutValid : out std_logic;  -- Result Valid signal - Output FIR Filter valid

      FIROutArray : out std_logic_vector((OUTPUT_WIDTH * CHANNEL) -1 downto 0)  -- Output Result of FIR Filter
      );
end FIRSerOut;


architecture FIRSerOut_rtl of FIRSerOut is

  type RESULT_REGISTER_TYPE is array (integer range <>)
    of std_logic_vector ((RESULT_WIDTH - 1) downto 0);

  signal ResultRegister : RESULT_REGISTER_TYPE ((CHANNEL -1) downto 0);  -- Result Out Internal Register
  signal Index          : natural range 0 to (CHANNEL - 1);


-- Architecture Definition ---------------------------------------------------------------------------------------------------------------
begin



----------- Internal Signal Generation Process ----------------------------
  Index <= CONV_INTEGER(ActualChannel);

  FIROutValid <= '1' when ((FIROutValidIn = '1') and (Index = (CHANNEL - 1))) else '0';


  TRANSFER : process (ResultRegister)
  begin
    for i in 0 to (CHANNEL - 1) loop
      for j in 0 to (OUTPUT_WIDTH - 1) loop
        FIROutArray(i*OUTPUT_WIDTH + j) <= ResultRegister(i)(j + ADD_PLL_MULTIPLIER);
      end loop;
    end loop;
  end process TRANSFER;

--* --------------------------------------------------------------------------------------------------------------------------------------
--* Register output Result 
--* Generate the output registers
--* Input      : ResultIn,  FIROutLoad
--* Output     : FIROut
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      for i in 0 to (CHANNEL - 1) loop
        ResultRegister(i) <= (others => '0');
      end loop;
    elsif rising_edge(sysclk) then
      if (Enable = '1') then
        if (FIROutLoad = '1') then
          ResultRegister(Index) <= ResultIn;
        end if;
      end if;
    end if;
  end process;

-- End of architecture
end FIRSerOut_rtl;
-- End of file
