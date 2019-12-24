-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : serial FIR
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : FIRser.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Top file of Sequential FIR project
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-25   1.0      CLS     Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity FIRSer is
  generic
    (
      -- Number of Channels
      CHANNEL      : natural := 8;      -- Number of channels
      CHANNEL_SIZE : natural := 3;      -- Number of bits to represent channels

      -- Filter Order - Number of TAPs
      FILTER_ORDER      : natural := 19;  -- Number of TAPs and Coeficients of the filter
      FILTER_ORDER_SIZE : natural := 5;  -- Number of bits to represent the filter order + 1 - Used to generate the address size of the memories

      -- Memory Size
      MEMORY_SIZE : natural := 64;  -- 2^(FILTER_ORDER_SIZE + CHANNEL_SIZE);

      -- Coeficients
      COEFICIENT_WIDTH : natural := 12;  -- Size of coeficient path in bits

      -- Data
      DATA_WIDTH : natural := 16;  -- Size of input and output sample data path in bits

      -- Accumulator
      ACCUMULATOR_WIDTH : natural := 28;  -- Size of accumulator in bits

      -- Result
      RESULT_WIDTH : natural := 16;     -- Size of data path in bits

      OUTPUT_WIDTH : natural := 16;

      MULTIPLIER : natural := 6
      );

  port
    (
      -- Common signals
      n_reset : in std_logic;           -- Reset signal - Active High
      Enable  : in std_logic;           -- Enable active high signal
      sysclk  : in std_logic;           -- Clock  active high signal

      -- Input Interface Signals
      SampleInArray : in std_logic_vector((DATA_WIDTH * CHANNEL - 1) downto 0);  -- Input Sample Value Array
      SampleInValid : in std_logic;     -- A valid sample input is preset
      ClearData     : in std_logic;  -- Clear data memory and set write pointer to 0 to start a new filtering process

      -- Input Interface Signals
      FIROutArray : out std_logic_vector((OUTPUT_WIDTH * CHANNEL - 1) downto 0);  -- Output Result of FIR Filter Array
      FIROutValid : out std_logic;      -- A valid result is present at FIROut
      Running     : out std_logic  -- Running signal - Indicate that the filter is running
      );
end FIRSer;


architecture FIRSer_rtl of FIRSer is


-- Input Register
  component FIRSerIn
    generic
      (
        -- Data
        CHANNEL      : natural := 16;   -- Number of channels
        CHANNEL_SIZE : natural := 4;    -- Number of bits to represent channels
        DATA_WIDTH   : natural := 16  -- Size of input and output sample data path in bits
        );
    port
      (
        -- Common signals
        n_reset : in std_logic;         -- Reset signal - Active High
        Enable  : in std_logic;         -- Enable active high signal
        sysclk  : in std_logic;         -- Clock  active high signal

        -- Interface Signals
        ClearSampleIn : in  std_logic;  -- Clear input data to clear data memory 
        SampleInArray : in  std_logic_vector((DATA_WIDTH * CHANNEL) - 1 downto 0);  -- Input sample value
        SampleInValid : in  std_logic;  -- A valid sample input is preset
        ActualChannel : in  std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered
        SampleInReg   : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Input Sample registered value
        );
  end component;

-- Coeficient ROM
  component FIRSerCoefROM
    generic
      (
        FILTER_ORDER      : natural := 1024;  -- Number of TAPs and Coeficients of the filer
        FILTER_ORDER_SIZE : natural := 10;  -- Number of bits to represent the filter order - Used to generate the address size of the memories
        COEFICIENT_WIDTH  : natural := 32   -- Size of coeficient path in bits
        );
    port
      (
        sysclk      : in  std_logic;    -- Clock  active high signal
        ReadAddress : in  std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
        ReadData    : out std_logic_vector(COEFICIENT_WIDTH-1 downto 0)  -- Data read from RAM
        );
  end component;


  component FIRSerDataRAM
    generic
      (
        CHANNEL           : natural := 16;  -- Number of channels
        CHANNEL_SIZE      : natural := 4;  -- Number of bits to represent channels
        FILTER_ORDER      : natural := 1024;  -- Number of TAPs and Coeficients of the filer
        FILTER_ORDER_SIZE : natural := 10;  -- Number of bits to represent the filter order - Used to generate the address size of the memories
        DATA_WIDTH        : natural := 16;  -- Size of input and output sample data path in bits
        MEMORY_SIZE       : natural := 64  -- 2^(CHANNEL_SIZE + FILTER_ORDER_SIZE)
        );   
    port
      (
        sysclk        : in  std_logic;  -- Clock  active high signal
        ReadAddress   : in  std_logic_vector(FILTER_ORDER_SIZE -1 downto 0);  -- Read Address
        WriteAddress  : in  std_logic_vector(FILTER_ORDER_SIZE -1 downto 0);  -- Write Address
        ActualChannel : in  std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered
        Write         : in  std_logic;  -- Write
        WriteData     : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data to be write
        ReadData      : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- Data read from RAM
        );
  end component;


  component FIRSerMAC
    generic
      (
        COEFICIENT_WIDTH  : natural := 32;  -- Size of coeficient path in bits
        DATA_WIDTH        : natural := 16;  -- Size of input and output sample data path in bits
        ACCUMULATOR_WIDTH : natural := 58;  -- Size of accumulator in bits
        RESULT_WIDTH      : natural := 16   -- Size of data path in bits
        );   
    port
      (
        n_reset     : in  std_logic;    -- Reset signal - Active High
        Enable      : in  std_logic;    -- Enable active high signal
        sysclk      : in  std_logic;    -- Clock  active high signal
        AccumClear  : in  std_logic;    -- Clear accumulator
        AccumEnable : in  std_logic;  -- Enable accumulator to store a new value
        Sample      : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Input Sample Value
        Coeficient  : in  std_logic_vector(COEFICIENT_WIDTH-1 downto 0);  -- Coeficient Value          
        FIROut      : out std_logic_vector(RESULT_WIDTH-1 downto 0)  -- Output Result of FIR Filter
        );
  end component;

-- Output system
  component FIRSerOut
    generic
      (
        CHANNEL      : natural := 16;   -- Number of channels
        CHANNEL_SIZE : natural := 4;    -- Number of bits to represent channels
        RESULT_WIDTH : natural := 16;   -- Size of data path in bits
        OUTPUT_WIDTH : natural := 16
        );     
    port
      (
        n_reset       : in  std_logic;  -- Reset signal - Active High
        Enable        : in  std_logic;  -- Enable active high signal
        sysclk        : in  std_logic;  -- Clock  active high signal
        ActualChannel : in  std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered
        FIROutLoad    : in  std_logic;  -- Result Load
        FIROutValidIn : in  std_logic;  -- Result Valid Input
        ResultIn      : in  std_logic_vector(RESULT_WIDTH-1 downto 0);  -- Input Result Value from MAC
        FIROutValid   : out std_logic;  -- Result Valid signal - Output FIR Filter valid
        FIROutArray   : out std_logic_vector((OUTPUT_WIDTH * CHANNEL) -1 downto 0)  -- Output Result of FIR Filter
        );
  end component;


  component FIRSerControl
    generic
      (CHANNEL           : natural := 16;  -- Number of channels
       CHANNEL_SIZE      : natural := 4;  -- Number of bits to represent channels        
       FILTER_ORDER      : natural := 1024;  -- Number of TAPs and Coeficients of the filer
       FILTER_ORDER_SIZE : natural := 10  -- Number of bits to represent the filter order - Used to generate the address size of the memories
       );
    port
      (
        n_reset          : in  std_logic;  -- Reset signal - Active High
        Enable           : in  std_logic;  -- Enable active high signal
        sysclk           : in  std_logic;  -- Clock  active high signal
        SampleInValid    : in  std_logic;  -- A valid sample input is preset
        ClearData        : in  std_logic;  -- Clear data memory and set write pointer to 0 to start a new filtering process
        AccumClear       : out std_logic;  -- Clear accumulator
        AccumEnable      : out std_logic;  -- Enable accumulator to store a new value
        ClearSampleIn    : out std_logic;  -- Clear input data to clear data memory 
        FIROutLoad       : out std_logic;  -- Result Load
        FIROutValid      : out std_logic;  -- Result Valid Input
        Running          : out std_logic;  -- Running signal - Indicate that the filter is running
        ActualChannel    : out std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered
        SampleWrite      : out std_logic;  -- Write
        CoefReadAddress  : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
        DataReadAddress  : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
        DataWriteAddress : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0)  -- Read Address
        );
  end component;

-- Internal Signals

  signal AccumClear            : std_logic;  -- Clear accumulator
  signal AccumEnable           : std_logic;  -- Enable accumulator to store a new value
  signal ClearSampleIn         : std_logic;  -- Clear input data to clear memory
  signal CoeficientRead        : std_logic_vector(COEFICIENT_WIDTH-1 downto 0);  -- Coeficient Value
  signal CoeficientReadAddress : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
  signal FIROutLoad            : std_logic;  -- Result Load
  signal FIROutValidIn         : std_logic;  -- Result Valid Input
  signal MACResult             : std_logic_vector(RESULT_WIDTH-1 downto 0);  -- Input Result Value from MAC
  signal SampleInReg           : std_logic_vector(DATA_WIDTH-1 downto 0);  -- Input Sample Registered Value
  signal SampleRead            : std_logic_vector(DATA_WIDTH-1 downto 0);  -- Input Sample Value
  signal SampleReadAddress     : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
  signal SampleWriteAddress    : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Write Address
  signal SampleWriteControl    : std_logic;  -- Write
  signal ActualChannel         : std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered


begin

-------------------------------------------------------------------------------
---- Output signals
-------------------------------------------------------------------------------
--
--readdata      <= internaldata;
--

-------------------------------------------
-- Components instantiation
-------------------------------------------

-- Input Register
  FirSerInInst : FIRSerIn
    generic map
    (
      CHANNEL      => CHANNEL,
      CHANNEL_SIZE => CHANNEL_SIZE,
      DATA_WIDTH   => DATA_WIDTH
      )

    port map
    (
      n_reset       => n_reset,
      Enable        => Enable,
      sysclk        => sysclk,
      ClearSampleIn => ClearSampleIn,
      SampleInArray => SampleInArray,
      SampleInValid => SampleInValid,
      ActualChannel => ActualChannel,
      SampleInReg   => SampleInReg
      );

-- Coeficient ROM
  FIRSerCoefROMInst : FIRSerCoefROM
    generic map
    (
      FILTER_ORDER      => FILTER_ORDER,
      FILTER_ORDER_SIZE => FILTER_ORDER_SIZE,
      COEFICIENT_WIDTH  => COEFICIENT_WIDTH
      )
    port map
    (
      sysclk      => sysclk,
      ReadAddress => CoeficientReadAddress,
      ReadData    => CoeficientRead
      );

-- Data RAM
  FIRSerDataRAMInst : FIRSerDataRAM
    generic map
    (
      CHANNEL           => CHANNEL,
      CHANNEL_SIZE      => CHANNEL_SIZE,
      FILTER_ORDER      => FILTER_ORDER,
      FILTER_ORDER_SIZE => FILTER_ORDER_SIZE,
      DATA_WIDTH        => DATA_WIDTH,
      MEMORY_SIZE       => MEMORY_SIZE
      )
    port map
    (
      sysclk        => sysclk,
      ReadAddress   => SampleReadAddress,
      WriteAddress  => SampleWriteAddress,
      ActualChannel => ActualChannel,
      Write         => SampleWriteControl,
      WriteData     => SampleInReg,
      ReadData      => SampleRead
      );

-- MAC
  FIRSerMACInst : FIRSerMAC
    generic map
    (
      COEFICIENT_WIDTH  => COEFICIENT_WIDTH,
      DATA_WIDTH        => DATA_WIDTH,
      ACCUMULATOR_WIDTH => ACCUMULATOR_WIDTH,
      RESULT_WIDTH      => RESULT_WIDTH
      )
    port map
    (
      n_reset     => n_reset,
      Enable      => Enable,
      sysclk      => sysclk,
      AccumClear  => AccumClear,
      AccumEnable => AccumEnable,
      Sample      => SampleRead,
      Coeficient  => CoeficientRead,
      FIROut      => MACResult
      );

-- Output system
  FIRSerOutInst : FIRSerOut
    generic map
    (
      CHANNEL      => CHANNEL,
      CHANNEL_SIZE => CHANNEL_SIZE,
      RESULT_WIDTH => RESULT_WIDTH,
      OUTPUT_WIDTH => OUTPUT_WIDTH
      )
    port map
    (
      n_reset       => n_reset,
      Enable        => Enable,
      sysclk        => sysclk,
      ActualChannel => ActualChannel,
      FIROutLoad    => FIROutLoad,
      FIROutValidIn => FIROutValidIn,
      ResultIn      => MACResult,
      FIROutValid   => FIROutValid,
      FIROutArray   => FIROutArray
      );

-- FIR Serial Control Module
  FIRSerControlInst : FIRSerControl
    generic map
    (
      CHANNEL           => CHANNEL,
      CHANNEL_SIZE      => CHANNEL_SIZE,
      FILTER_ORDER      => FILTER_ORDER,
      FILTER_ORDER_SIZE => FILTER_ORDER_SIZE
      )
    port map
    (
      n_reset          => n_reset,
      Enable           => Enable,
      sysclk           => sysclk,
      ClearData        => ClearData,
      SampleInValid    => SampleInValid,
      AccumClear       => AccumClear,
      AccumEnable      => AccumEnable,
      ClearSampleIn    => ClearSampleIn,
      FIROutLoad       => FIROutLoad,
      FIROutValid      => FIROutValidIn,
      Running          => Running,
      ActualChannel    => ActualChannel,
      SampleWrite      => SampleWriteControl,
      CoefReadAddress  => CoeficientReadAddress,
      DataReadAddress  => SampleReadAddress,
      DataWriteAddress => SampleWriteAddress
      );

end FIRSer_rtl;

