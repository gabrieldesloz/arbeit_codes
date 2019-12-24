-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : FIR serial input
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firserin.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Input Sample and hold of the Serial FIR Design
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

entity FIRSerIn is
  generic
    (
      CHANNEL      : natural := 16;     -- Number of channels
      CHANNEL_SIZE : natural := 4;      -- Number of bits to represent channels
      DATA_WIDTH   : natural := 16  -- Size of input and output sample data path in bits
      );
  port
    (
      -- Common signals
      n_reset : in std_logic;           -- Reset signal - Active Low
      enable  : in std_logic;           -- Enable active high signal
      sysclk  : in std_logic;           -- Clock  active high signal

      -- Interface Signals
      ClearSampleIn : in  std_logic;  -- Clear input data to clear data memory 
      SampleInArray : in  std_logic_vector((DATA_WIDTH * CHANNEL) - 1 downto 0);  -- Input sample value array
      SampleInValid : in  std_logic;    -- A valid sample input is preset
      ActualChannel : in  std_logic_vector(CHANNEL_SIZE-1 downto 0);  -- Actual channel being filtered
      SampleInReg   : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Input Sample registered value
      );
end FIRSerIn;


architecture FIRSerIn_rtl of FIRSerIn is

  type SAMPLE_REGISTER_TYPE is array (integer range <>)
    of std_logic_vector ((DATA_WIDTH - 1) downto 0);
  
  signal SampleInRegister     : SAMPLE_REGISTER_TYPE((CHANNEL - 1) downto 0);
  signal SampleInRegister_Reg : SAMPLE_REGISTER_TYPE((CHANNEL - 1) downto 0);
  signal Index                : natural range 0 to (CHANNEL - 1);

begin

  Index       <= CONV_INTEGER(ActualChannel);
  SampleInReg <= SampleInRegister_Reg(Index);


-- copy input vector to an array
  process (SampleInArray)
  begin
    for i in 0 to (CHANNEL - 1) loop
      for j in 0 to (DATA_WIDTH - 1) loop
        SampleInRegister(i)(j) <= SampleInArray(i*DATA_WIDTH + j);
      end loop;
    end loop;
  end process;


--* --------------------------------------------------------------------------------------------------------------------------------------
--* Register input sample
--* Generate the input registered sample when SampleInputValid  is present
--* Input      : SampleInRegister, SampleInValid
--* Output     : SampleInRegister_Reg
--* Latency    : 1
--* Multicycle : Yes - Depends on SampleInValid input
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      for i in 0 to (CHANNEL - 1) loop
        SampleInRegister_Reg(i) <= (others => '0');
      end loop;
    elsif rising_edge(sysclk) then
      if (enable = '1') then
        if (ClearSampleIn = '1') then
          for i in 0 to (CHANNEL - 1) loop
            SampleInRegister_Reg(i) <= (others => '0');
          end loop;
        elsif (SampleInValid = '1') then
          SampleInRegister_Reg <= SampleInRegister;
        end if;
      end if;
    end if;
  end process;

end FIRSerIn_rtl;

