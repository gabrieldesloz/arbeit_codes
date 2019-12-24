-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : MAC for FIR serial
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firsermac.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  MAC of FIR filter, with all input, out and internal,
-- registers passed as parameter.
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
use ieee.std_logic_signed.all;


entity FIRSerMAC is
  generic
    (
      -- Coeficients
      COEFICIENT_WIDTH  : natural := 32;  -- Size of coeficient path in bits
      -- Data
      DATA_WIDTH        : natural := 16;  -- Size of input and output sample data path in bits
      -- Accumulator
      ACCUMULATOR_WIDTH : natural := 58;  -- Size of accumulator in bits
      -- Result
      RESULT_WIDTH      : natural := 16   -- Size of data path in bits
      );

  port
    (
      -- Common signals
      n_reset : in std_logic;           -- Reset signal - Active Low
      enable  : in std_logic;           -- Enable active high signal
      sysclk  : in std_logic;           -- Clock  active high signal

      -- Interface Signals
      AccumClear  : in  std_logic;      -- Clear accumulator
      AccumEnable : in  std_logic;  -- Enable accumulator to store a new value
      Sample      : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Input Sample Value
      Coeficient  : in  std_logic_vector(COEFICIENT_WIDTH-1 downto 0);  -- Coeficient Value
      FIROut      : out std_logic_vector(RESULT_WIDTH-1 downto 0)  -- Output Result of FIR Filter
      );
end FIRSerMAC;

-- Architecture
architecture FIRSerMAC_rtl of FIRSerMAC is

---- Internal Signals

  signal Accumulator   : std_logic_vector(ACCUMULATOR_WIDTH-1 downto 0);  -- Accumulator
  signal MultResult    : std_logic_vector(COEFICIENT_WIDTH+DATA_WIDTH-1 downto 0);  -- Multiply result
  signal MultResultExt : std_logic_vector(ACCUMULATOR_WIDTH-1 downto 0);  -- Multiply result extended to accumulator size
  signal SumResult     : std_logic_vector(ACCUMULATOR_WIDTH-1 downto 0);  -- Sum result
  signal Sample_g      : std_logic_vector(DATA_WIDTH-1 downto 0);  -- Input Sample Value
  signal Coeficient_g  : std_logic_vector(COEFICIENT_WIDTH-1 downto 0);  -- Coeficient Value

-- Architecture Definition ---------------------------------------------------------------------------------------------------------------
begin

----------- Internal Signal Generation Process ----------------------------

  FIROut <= Accumulator((Accumulator'high) downto (Accumulator'high - RESULT_WIDTH + 1));

-- Extend (keeping the signal) the MultResult to the same size as the accumulator
  MultResultExt(MultResultExt'high downto (MultResult'high+1)) <= (others => MultResult(MultResult'high));
  MultResultExt(MultResult'high downto 0)                      <= MultResult;

-- Add the Accumulator and Multiply result
  SumResult <= Accumulator + MultResultExt;


--* --------------------------------------------------------------------------------------------------------------------------------------
--* Multiply of input coeficient and data
--* Generate multiply result
--* Input      : Data and Coeficient
--* Output     : MultResult
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------
--/

  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      MultResult   <= (others => '0');
      Sample_g     <= (others => '0');
      Coeficient_g <= (others => '0');
    elsif rising_edge(sysclk) then
      if (enable = '1') then
        Sample_g     <= Sample;
        Coeficient_g <= Coeficient;
        MultResult   <= Sample_g * Coeficient_g;
      end if;
    end if;
  end process;


--* --------------------------------------------------------------------------------------------------------------------------------------
--* Accumulator Register Generation
--* Accumulator Register generation - Store a new value when AccumEnable='1' and clear the register when AccumClear='1'
--* Input      : AccumClear, AccumEnable, SumResult
--* Output     : Accumulator
--* Latency    : 1 Clock Cycles
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------
--/
  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      Accumulator <= (others => '0');
    elsif rising_edge(sysclk) then
      if (enable = '1') then
        -- Load the Shift Register with a new value
        if (AccumClear = '1') then
          Accumulator <= (others => '0');
        elsif (AccumEnable = '1') then
          Accumulator <= SumResult(Accumulator'range);
        end if;
      end if;
    end if;
  end process;


end FIRSerMAC_rtl;

