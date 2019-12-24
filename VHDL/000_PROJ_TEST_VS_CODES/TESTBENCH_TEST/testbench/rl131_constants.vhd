

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


package rl131_constants is

-- general constants

  constant FIRMWARE_VERSION  : std_logic_vector(7 downto 0) := "00000001";
  constant CLK_FREQUENCY_MHZ : natural                      := 100;
  constant WORD_SIZE         : natural                      := 16;
  constant ONE_SECOND        : natural                      := CLK_FREQUENCY_MHZ * 1000000;
  constant HALF_SECOND       : natural                      := CLK_FREQUENCY_MHZ * 500000;
  constant ONE_MILI_SECOND   : natural                      := CLK_FREQUENCY_MHZ * 1000;
  constant ONE_HUND_MICRO    : natural                      := CLK_FREQUENCY_MHZ * 100;
  constant TEN_MICROSECONDS  : natural                      := (CLK_FREQUENCY_MHZ * 10);
  constant RESET_DIV         : natural                      := CLK_FREQUENCY_MHZ * 20000;  -- in microseconds
  constant TIMEOUT_PPS       : natural                      := CLK_FREQUENCY_MHZ * 1010000;
  constant PPS_WINDOW        : natural                      := CLK_FREQUENCY_MHZ * 999000;
  constant ONE_MICRO_SECOND  : natural                      := CLK_FREQUENCY_MHZ;


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
  constant S_BUFFER_SIZE : natural := 16;
  constant S_BUFFER_BITS : natural := 4;
  --constant L_BUFFER_SIZE : natural := 256;
  constant L_BUFFER_SIZE : natural := 1024;
  --constant L_BUFFER_BITS : natural := 8;
  constant L_BUFFER_BITS : natural := 10;
  constant FREQUENCY_BUFFER_SIZE  : natural := 32;
  constant F_BUFFER_BITS : natural := 5;

-- cic filter constants  
  constant FORBIDDEN : std_logic_vector(15 downto 0) := x"1C00";

-- fir filter constants  
  constant CHANNEL           : natural := N_CHANNELS_ANA;  -- Number of channels
  constant CHANNEL_SIZE      : natural := N_CHANNELS_COUNTER_BITS;  -- Number of bits to represent channels
  constant FILTER_ORDER      : natural := 19;  -- Number of TAPs and Coeficients of the filter
  constant FILTER_ORDER_SIZE : natural := 5;  -- Number of bits to represent the filter order + 1 - Used to generate the address size of the memories
  constant MEMORY_SIZE       : natural := 2**(FILTER_ORDER_SIZE + CHANNEL_SIZE);  -- 2^(FILTER_ORDER_SIZE + CHANNEL_SIZE);
  constant COEFICIENT_WIDTH  : natural := 13;  -- Size of coeficient path in bits
  constant DATA_WIDTH        : natural := 16;  -- Size of input and output sample data path in bits
  constant ACCUMULATOR_WIDTH : natural := 34;  -- Size of accumulator in bits
  constant RESULT_WIDTH      : natural := 28;  -- Size of data path in bits 
  constant OUTPUT_WIDTH      : natural := 16;  -- Size of data path in bits  
  constant ADD_PLL_MULTIPLIER        : natural := 6;


-- tail constants
  constant TAIL_HEADER : std_logic_vector (7 downto 0) := X"01";
  constant TAIL_IRIG   : std_logic_vector (7 downto 0) := X"02";

  -- irig constants
  constant IRIG_SIZE  : natural := 13;   -- # of words stored in memory
  constant IRIG_BITS  : natural := 100;  -- # of irig bits in a frame
  constant IRIG_WORDS : natural := 22;   -- # of words in irig area

  -- pll constants -soc

  constant N_BITS_NCO  : natural := 36;
  constant K_TOLERANCE : integer := 2000000;

  constant FREQUENCY_DEFAULT_STD_SOC_60 : std_logic_vector(63 downto 0)               := x"0003C00000000000";
  constant K_DEFAULT_STD_SOC_60         : std_logic_vector((N_BITS_NCO - 1) downto 0) := x"0A10FAFA0";
  constant FREQUENCY_DEFAULT_STD_SOC_50 : std_logic_vector(63 downto 0)               := x"0003C00000000000";
  constant K_DEFAULT_STD_SOC_50         : std_logic_vector((N_BITS_NCO - 1) downto 0) := x"000A10FAF";
  constant STEP_NORMAL_SOC              : natural                                     := 2;
  constant STEP_LOW_SOC                 : natural                                     := 1;
  constant SOC_TIME                     : natural                                     := CLK_FREQUENCY_MHZ*1000000/15360;
  constant DELTA_LIMIT_SOC              : natural                                     := 100;
  constant LIMIT_LO_SOC                 : natural                                     := (DELTA_LIMIT_SOC/2);
  constant LIMIT_HI_SOC                 : natural                                     := (SOC_TIME - DELTA_LIMIT_SOC/2);


  -- pll constants - mclk

  --constant FREQUENCY_DEFAULT_STD_MCLK_60 : std_logic_vector(63 downto 0)               := x"03C0000000000000";
  --constant K_DEFAULT_STD_MCLK_60         : std_logic_vector((N_BITS_NCO - 1) downto 0) := x"0A10FAFA0";
  --constant FREQUENCY_DEFAULT_STD_MCLK_50 : std_logic_vector(63 downto 0)               := x"0320000000000000";
  --constant K_DEFAULT_STD_MCLK_50         : std_logic_vector((N_BITS_NCO - 1) downto 0) := x"08637BD00";
  ---- constant SOCS_PER_SEC_MCLK            : std_logic_vector(15 downto 0)               := x"3C00";
  --constant STEP_NORMAL_MCLK              : natural                                     := 50;
  --constant STEP_LOW_MCLK                 : natural                                     := 10;
  --constant SOC_DISTANCE_MCLK             : natural                                     := 4000;
  --constant DELTA_CONTROL_MCLK            : natural                                     := 1;  --4;
  --constant DELTA_LOCKED_MCLK             : natural                                     := 200;
  --constant SOC_DISTANCE_LOW_MCLK         : natural                                     := (SOC_DISTANCE_MCLK - DELTA_CONTROL_MCLK/2);
  --constant SOC_DISTANCE_HI_MCLK          : natural                                     := (SOC_DISTANCE_MCLK + DELTA_CONTROL_MCLK/2);
  --constant SOC_DISTANCE_LOCKED_LOW_MCLK  : natural                                     := (SOC_DISTANCE_MCLK - DELTA_LOCKED_MCLK/2);
  --constant SOC_DISTANCE_LOCKED_HI_MCLK   : natural                                     := (SOC_DISTANCE_MCLK + DELTA_LOCKED_MCLK/2);



  -- divider constants
  constant N                 : integer                          := 64;  -- number of numerator bits
  constant D                 : integer                          := 28;  -- number of denominator bits
  constant Q                 : integer                          := 64;  -- number of quotient bits
  constant ZERO_STD          : std_logic_vector((D-1) downto 0) := (others => '0');
  constant CLK_FREQUENCY_STD : std_logic_vector((D-1) downto 0) := conv_std_logic_vector((CLK_FREQUENCY_MHZ * 1000000), D);


  -- ptoc constants
  constant SIZE_AC : natural := 9;
  constant SIZE_RS : natural := 6;

  -- keys constants
  constant KEYS_LENGTH : natural := 9;





-- EDGE Calculator constant
constant EC_BITS : natural := 32;

-- Divisor do Relogio Principal para o módulo Delay Control
  constant DCC_BITS : natural := 20;    

-- ERROR TRACKER
  constant DL_BITS : natural := 8;   
  
  constant DL_SIZE : natural := 2**DL_BITS; 
  
  constant HALF_T  : std_logic_vector(DL_BITS-1 downto 0) := "00001101";  -- 13                                                   
  constant PHASE_INFO : std_logic_vector(DL_BITS-1 downto 0) := "00000000";

  -- DELAY LINE
  constant DLC_BITS : natural := 8;
  constant DLC_SIZE: natural  := 2**DLC_BITS;

 constant HALF_DL : std_logic_vector(DLC_BITS-1 downto 0) := "10000000";  -- 128


  
  
end package rl131_constants;


-- eof $Id: rl131_constants.vhd 3646 2007-11-12 20:54:13Z cls $
