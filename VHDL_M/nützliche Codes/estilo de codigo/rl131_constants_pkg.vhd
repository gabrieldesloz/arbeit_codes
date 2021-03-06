-------------------------------------------------------------------------------
-- Title      : constants package
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : rl131_constants_pkg.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2013-05-07
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:   A VHDL package with rl131 constants
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-25   1.0      CLS     Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


package rl131_constants_pkg is

-- general constants

  constant FIRMWARE_VERSION  : unsigned(7 downto 0) := "00000001";
  constant CLK_FREQUENCY_MHZ : natural              := 100;
  constant WORD_SIZE         : natural              := 16;
  constant ONE_SECOND        : natural              := CLK_FREQUENCY_MHZ * 1000000;
  constant HALF_SECOND       : natural              := CLK_FREQUENCY_MHZ * 500000;
  constant ONE_MILI_SECOND   : natural              := CLK_FREQUENCY_MHZ * 1000;
  constant ONE_HUND_MICRO    : natural              := CLK_FREQUENCY_MHZ * 100;
  constant TEN_MICROSECONDS  : natural              := (CLK_FREQUENCY_MHZ * 10);
  constant RESET_DIV         : natural              := CLK_FREQUENCY_MHZ * 20000;  -- in microseconds
  constant TIMEOUT_PPS       : natural              := CLK_FREQUENCY_MHZ * 1010000;
  constant PPS_WINDOW        : natural              := CLK_FREQUENCY_MHZ * 999000;
  constant ONE_MICRO_SECOND  : natural              := CLK_FREQUENCY_MHZ;


  -- irig constants
  constant TIMEOUT_IRIG : natural := CLK_FREQUENCY_MHZ * 50000;  -- 50 miliseconds
  constant TR_IRIG_MIN  : natural := CLK_FREQUENCY_MHZ * 1000;  -- 1 miliseconds

  -- number of fixed point bits
  constant MULTIPLIER_N_BITS : natural := 16;

  -- number of backplane leds
  constant N_LEDS : natural := 16;

-- number of fft points
  constant N_POINTS_FFT    : natural := 256;
  constant N_BITS_GOERTZEL : natural := 32;

-- analog channel constants
  constant N_CHANNELS_ANA          : natural := 16;
  constant N_CHANNELS_COUNTER_BITS : natural := 4;
  constant N_BITS_ADC              : natural := 16;

-- digital channel constants
  constant N_CHANNELS_MUX : natural := 16;
  constant N_CHANNELS_DIG : natural := 12;
  constant N_CHANNELS_MON : natural := 16;
  constant N_GOOSE_INPUTS : natural := 256;
  constant DEMUX_RATE_MHZ : natural := 1;


  -- buffer constants
  constant S_BUFFER_SIZE         : natural := 16;
  constant S_BUFFER_BITS         : natural := 4;
  --constant L_BUFFER_SIZE : natural := 256;
  constant L_BUFFER_SIZE         : natural := 1024;
  --constant L_BUFFER_BITS : natural := 8;
  constant L_BUFFER_BITS         : natural := 10;
  constant FREQUENCY_BUFFER_SIZE : natural := 32;
  constant F_BUFFER_BITS         : natural := 5;

-- cic filter constants  
  constant FORBIDDEN : std_logic_vector(15 downto 0) := x"1C00";

-- fir filter constants  
  constant CHANNEL            : natural := N_CHANNELS_ANA;  -- Number of channels
  constant CHANNEL_SIZE       : natural := N_CHANNELS_COUNTER_BITS;  -- Number of bits to represent channels
  constant FILTER_ORDER       : natural := 127;  -- Number of TAPs and Coeficients of the filter
  constant FILTER_ORDER_SIZE  : natural := 7;  -- Number of bits to represent the filter order + 1 - Used to generate the address size of the memories
  constant MEMORY_SIZE        : natural := 2**(FILTER_ORDER_SIZE + CHANNEL_SIZE);  -- 2^(FILTER_ORDER_SIZE + CHANNEL_SIZE);
  constant COEFICIENT_WIDTH   : natural := 13;  -- Size of coeficient path in bits
  constant DATA_WIDTH         : natural := 16;  -- Size of input and output sample data path in bits
  constant ACCUMULATOR_WIDTH  : natural := 34;  -- Size of accumulator in bits
  constant RESULT_WIDTH       : natural := 28;  -- Size of data path in bits 
  constant OUTPUT_WIDTH       : natural := 16;  -- Size of data path in bits  
  constant ADD_PLL_MULTIPLIER : natural := 6;


-- tail constants
  constant TAIL_HEADER : std_logic_vector (7 downto 0) := X"01";
  constant TAIL_IRIG   : std_logic_vector (7 downto 0) := X"02";

  -- irig constants
  constant IRIG_SIZE  : natural := 13;   -- # of words stored in memory
  constant IRIG_BITS  : natural := 100;  -- # of irig bits in a frame
  constant IRIG_WORDS : natural := 22;   -- # of words in irig area

  -- ptoc constants
  constant SIZE_AC : natural := 9;
  constant SIZE_RS : natural := 6;

  -- cordic sontants
  constant N_CONTROL_CORDIC_READY : natural := 25;

  -- keys constants
  constant KEYS_LENGTH : natural := 9;

  
end package rl131_constants_pkg;


