-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : serial FIR control
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : firsercontrol.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2011-10-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  The Control State Machine generate the ROM Address, Data Address
-- and the control signals for the MAC and output modules
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


entity FIRSerControl is
  generic
    (
      CHANNEL           : natural := 1;  -- Number of channels
      CHANNEL_SIZE      : natural := 1;  -- Number of bits to represent channels        
      -- Filter Order - Number of TAPs
      FILTER_ORDER      : natural := 19;  -- Number of TAPs and Coeficients of the filer
      FILTER_ORDER_SIZE : natural := 5  -- Number of bits to represent the filter order - Used to generate the address size of the memories
      );

  -- Port Definition -----------------------------------------------------------------------------------------------------------------------
  port
    (
      -- Common signals
      n_reset : in std_logic;           -- Reset signal - Active High
      enable  : in std_logic;           -- Enable active high signal
      sysclk  : in std_logic;           -- Clock  active high signal

      -- Input Interface Signals
      SampleInValid : in std_logic;     -- A valid sample input is preset
      ClearData     : in std_logic;  -- Clear data memory and set write pointer to 0 to start a new filtering process

      -- Output Interface Signals
      AccumClear  : out std_logic;      -- Clear accumulator
      AccumEnable : out std_logic;  -- Enable accumulator to store a new value

      ClearSampleIn : out std_logic;  -- Clear input data to clear data memory 

      FIROutLoad  : out std_logic;      -- Result Load
      FIROutValid : out std_logic;      -- Result Valid Input

      Running : out std_logic;  -- Running signal - Indicate that the filter is running

      ActualChannel : out std_logic_vector (CHANNEL_SIZE - 1 downto 0);  -- Channel being filtered

      SampleWrite : out std_logic;      -- Write

      CoefReadAddress  : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
      DataReadAddress  : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Read Address
      DataWriteAddress : out std_logic_vector(FILTER_ORDER_SIZE-1 downto 0)  -- Read Address
      );
end FIRSerControl;

-- Architecture
architecture FIRSerControl_rtl of FIRSerControl is

-- State Machine States Definition
  type smControlType is (
    stControlIdle,                      -- Idle
    stControlClearPrepare,              -- Prepare to clear memorydata
    stControlClearData,                 -- Clear memory data
    stControlClearEnd,                  -- Clear memory data end
    stControlWaitSample,                -- Wait for new valid sample
    stControlPrepareCounters,  -- Store output sample and prepare de counters
    stControlFilter,           -- Filter the samples generating a new value
    stControlStoreResult,               -- Store output result
    stControlEnd,                       -- End of a Channel
    stControlUpdateChannel              -- Update Channel
    );

  signal smControl : smControlType;

  signal CoefReadAddress_g  : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Coeficient Read  Address Register
  signal DataReadAddress_g  : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Data Read  Address Register
  signal DataWriteAddress_g : std_logic_vector(FILTER_ORDER_SIZE-1 downto 0);  -- Data Write Address Register
  signal Channel_g          : std_logic_vector((CHANNEL_SIZE - 1) downto 0);  -- Keeps the actual channel

  signal OutputCntr_g : std_logic_vector(3 downto 0);  -- Output delay counter - Count clock cycles needed to store the result taking in account the pipeline latency.

-- Architecture Definition ---------------------------------------------------------------------------------------------------------------
begin

--*
--* Output Signals
--*

  ActualChannel    <= Channel_g;
  CoefReadAddress  <= CoefReadAddress_g;
  DataReadAddress  <= DataReadAddress_g;
  DataWriteAddress <= DataWriteAddress_g;


--* --------------------------------------------------------------------------------------------------------------------------------------
--* Control State Machine Generation Process
--* Generate the state machine controlled signals
--* Input      : SampleInValid, smControl, DataWriteAddress_g
--* Output     : All output and other internal signals
--* Latency    : Variable Clock Cycles
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(n_reset, sysclk)
  begin
    if (n_reset = '0') then
      smControl          <= stControlIdle;
      AccumClear         <= '0';
      AccumEnable        <= '0';
      ClearSampleIn      <= '0';
      FIROutLoad         <= '0';
      FIROutValid        <= '0';
      Running            <= '0';
      SampleWrite        <= '0';
      CoefReadAddress_g  <= (others => '0');
      DataReadAddress_g  <= (others => '0');
      DataWriteAddress_g <= (others => '0');
      OutputCntr_g       <= (others => '0');
      Channel_g          <= (others => '0');
      
    elsif rising_edge(sysclk) then
      if (Enable = '1') then
        AccumClear    <= '0';
        ClearSampleIn <= '0';
        FIROutLoad    <= '0';
        FIROutValid   <= '0';
        Running       <= '0';
        SampleWrite   <= '0';
        -- Control State Machine Case
        case smControl is
          -- Idle state - Clear all variables to start working
          -- Enters only after reset
          when stControlIdle =>
            smControl          <= stControlClearPrepare;
            AccumClear         <= '1';
            AccumEnable        <= '0';
            CoefReadAddress_g  <= (others => '0');
            DataReadAddress_g  <= (others => '0');
            DataWriteAddress_g <= (others => '0');
            OutputCntr_g       <= (others => '0');
            Channel_g          <= (others => '0');
          -- Prepare to clear data memory
          when stControlClearPrepare =>
            if (OutputCntr_g = 3) then
              OutputCntr_g <= (others => '0');
              smControl    <= stControlClearData;
              SampleWrite  <= '1';
            end if;
            OutputCntr_g       <= OutputCntr_g + 1;
            ClearSampleIn      <= '1';
            AccumClear         <= '1';
            AccumEnable        <= '0';
            DataWriteAddress_g <= (others => '0');
            Channel_g          <= (others => '0');
            Running            <= '1';

          -- Clear data memory
          when stControlClearData =>
            if (DataWriteAddress_g = (FILTER_ORDER-1)) then
              DataWriteAddress_g <= (others => '0');
              if (Channel_g = (CHANNEL - 1)) then
                Channel_g <= (others => '0');
                smControl <= stControlClearEnd;
              else
                Channel_g <= Channel_g + 1;
              end if;
            else
              DataWriteAddress_g <= DataWriteAddress_g + 1;
            end if;
            SampleWrite   <= '1';
            ClearSampleIn <= '1';
            Running       <= '1';

          -- Clear data memory End
          when stControlClearEnd =>
            smControl          <= stControlWaitSample;
            DataWriteAddress_g <= (others => '0');
            DataReadAddress_g  <= (others => '0');
            Channel_g          <= (others => '0');
            CoefReadAddress_g  <= (others => '0');
            OutputCntr_g       <= (others => '0');
            SampleWrite        <= '0';
            ClearSampleIn      <= '0';
            AccumClear         <= '1';
            Running            <= '1';

          -- Wait for a Valid Sample Input signal to begin of a new filter process
          when stControlWaitSample =>
            if (ClearData = '1') then
              smControl <= stControlClearPrepare;
            elsif (SampleInValid = '1') or (Channel_g > 0) then
              smControl   <= stControlPrepareCounters;
              SampleWrite <= '1';
            end if;
            AccumClear        <= '1';
            AccumEnable       <= '0';
            CoefReadAddress_g <= (others => '0');
            DataReadAddress_g <= DataWriteAddress_g;  ---????
            OutputCntr_g      <= (others => '0');

          -- Prepare the address for Sample Memory and Coeficient Memory read process
          when stControlPrepareCounters =>
            if (OutputCntr_g = 0) then
              DataReadAddress_g <= DataWriteAddress_g;
              CoefReadAddress_g <= (others => '0');
              if (Channel_g = 0) then
                if (DataWriteAddress_g = 0) then
                  DataWriteAddress_g <= std_logic_vector(TO_UNSIGNED(FILTER_ORDER-1, FILTER_ORDER_SIZE));
                else
                  DataWriteAddress_g <= DataWriteAddress_g - 1;
                end if;
              end if;
            end if;
            if (OutputCntr_g = 2) then
              smControl    <= stControlFilter;
              OutputCntr_g <= (others => '0');
            else
              OutputCntr_g <= OutputCntr_g + 1;
            end if;
            AccumClear  <= '1';
            AccumEnable <= '0';
            Running     <= '1';

          -- Filter the samples
          when stControlFilter =>
            if (CoefReadAddress_g < (FILTER_ORDER-1)) then
              if (DataReadAddress_g = FILTER_ORDER-1) then
                DataReadAddress_g <= (others => '0');
              else
                DataReadAddress_g <= DataReadAddress_g + 1;
              end if;
              CoefReadAddress_g <= CoefReadAddress_g + 1;
            else
              smControl <= stControlStoreResult;
            end if;
            if (CoefReadAddress_g = 2) then
              AccumEnable <= '1';
            end if;
            OutputCntr_g <= (others => '0');
            Running      <= '1';

          -- Wait for the end of filtering process and store the result
          when stControlStoreResult =>
            if (OutputCntr_g < 2) then
              OutputCntr_g <= OutputCntr_g + 1;
              AccumEnable  <= '1';
            else
              smControl    <= stControlEnd;
              FIROutLoad   <= '1';
              FIROutValid  <= '1';
              AccumEnable  <= '0';
              OutputCntr_g <= (others => '0');
            end if;
            Running <= '1';


          -- Wait for the end of filtering process and store the result
          when stControlEnd =>
            smControl    <= stControlUpdateChannel;
            FIROutLoad   <= '0';
            FIROutValid  <= '1';
            AccumEnable  <= '0';
            Running      <= '1';
            OutputCntr_g <= (others => '0');


          -- Update Channel
          when stControlUpdateChannel =>
            smControl <= stControlWaitSample;
            if (Channel_g = CHANNEL - 1) then
              Channel_g <= (others => '0');
            else
              Channel_g <= Channel_g + 1;
            end if;
            Running <= '1';
            
          when others => null;

        end case;
      end if;
    end if;
  end process;


end FIRSerControl_rtl;
