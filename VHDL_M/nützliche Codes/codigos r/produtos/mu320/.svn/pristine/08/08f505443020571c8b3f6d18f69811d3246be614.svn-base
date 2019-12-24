-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : mu320_constants.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-05-03
-- Last update: 2013-06-27
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-05-03  1.0      lgs     Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


package mu320_constants is

-- general constants

  constant FIRMWARE_VERSION               : std_logic_vector(7 downto 0) := "00000001";
  constant CLK_FREQUENCY_MHZ              : natural                      := 100;
  constant ONE_SECOND                     : natural                      := CLK_FREQUENCY_MHZ * 1000000;
  constant HALF_SECOND                    : natural                      := CLK_FREQUENCY_MHZ * 500000;
  constant RESET_DIV                      : natural                      := CLK_FREQUENCY_MHZ * 20000;
  constant TWO_HUND_EIGHT_MICRO_SECONDS   : natural                      := 208;
  constant FIVE_HUND_TWENTY_MICRO_SECONDS : natural                      := 520;
  constant TIMEOUT_PPS                    : natural                      := CLK_FREQUENCY_MHZ * 1010000;
  constant PPS_WINDOW                     : natural                      := CLK_FREQUENCY_MHZ * 999000;
  constant ONE_MICRO_SECOND               : natural                      := CLK_FREQUENCY_MHZ;
  constant GROUP_DELAY                    : natural                      := CLK_FREQUENCY_MHZ * 170; 


  -- irig constants
  constant TIMEOUT_IRIG : natural := CLK_FREQUENCY_MHZ * 50000;  -- 50 miliseconds
  constant TR_IRIG_MIN  : natural := CLK_FREQUENCY_MHZ * 1000;  -- 1 miliseconds

  -- number of backplane leds
  constant N_LEDS : natural := 16;

-- analog channel constants
  constant N_CHANNELS_ANA          : natural := 16;
  constant N_CHANNELS_COUNTER_BITS : natural := 4;
  constant N_BITS_ADC              : natural := 16;
  constant VA_CHANNEL              : natural := 4;
  constant VB_CHANNEL              : natural := 5;
  constant VC_CHANNEL              : natural := 6;
  constant N_CHANNEL               : natural := 7;

-- digital channel constants
  constant N_CHANNELS_MUX : natural := 16;
  constant N_CHANNELS_DIG : natural := 12;
  constant N_CHANNELS_MON : natural := 16;
  constant N_GOOSE_INPUTS : natural := 256;
  constant DEMUX_RATE_MHZ : natural := 1;

-- cic filter constants  
  constant FORBIDDEN : std_logic_vector(15 downto 0) := x"1C00";

-- fir filter constants  
  constant CHANNEL            : natural := N_CHANNELS_ANA;  -- Number of channels
  constant CHANNEL_SIZE       : natural := N_CHANNELS_COUNTER_BITS;  -- Number of bits to represent channels
  constant FILTER_ORDER       : natural := 19;  -- Number of TAPs and Coeficients of the filter
  constant FILTER_ORDER_SIZE  : natural := 5;  -- Number of bits to represent the filter order + 1 - Used to generate the address size of the memories
  constant MEMORY_SIZE        : natural := 2**(FILTER_ORDER_SIZE + CHANNEL_SIZE);  -- 2^(FILTER_ORDER_SIZE + CHANNEL_SIZE);
  constant COEFICIENT_WIDTH   : natural := 13;  -- Size of coeficient path in bits
  constant DATA_WIDTH         : natural := 16;  -- Size of input and output sample data path in bits
  constant ACCUMULATOR_WIDTH  : natural := 34;  -- Size of accumulator in bits
  constant RESULT_WIDTH       : natural := 28;  -- Size of data path in bits 
  constant OUTPUT_WIDTH       : natural := 16;  -- Size of data path in bits  
  constant ADD_PLL_MULTIPLIER : natural := 6;


-------------------------------------------------------------------------------
-- constantes em comum 
-------------------------------------------------------------------------------

  constant DELAY_80             : natural   := 4;
  constant DELAY_256            : natural   := 4;
  constant PPS_DIFF_80          : natural   := 25;  -- x 208.3 us  -- 25
                                        -- (4800 Hz)
  constant PPS_DIFF_256         : natural   := 80;  -- x 65.1 us   -- 80
                                        -- (15360 Hz)
  constant FAKE_DRIFT           : std_logic := '0';
  constant FAKE_DRIFT_VALUE_80  : natural   := 40_000;
  constant FAKE_DRIFT_VALUE_256 : natural   := 5;
  constant FM_MAX_DEVIATION     : natural   := 100;   -- *2 = 5 us
  constant FREQ_TOLERANCE       : natural   := 1000;  -- folga no contador do
                                                      -- periodo do SYSCLK
  constant SYS_START_WAIT       : natural   := 30;  -- periodo em sque o sistema vai esperar
                                                    -- pelo sinal de pps

-------------------------------------------------------------------------------
-- constantes em comum
-------------------------------------------------------------------------------

  -- divider constants
  -- number of numerator bits -- greater
  -- or equal the number N_BITS_NCO
  constant N                 : integer                          := 60;
  -- number of denominator bits
  constant D                 : integer                          := 28;
  -- number of NCO bits
  constant N_BITS_NCO        : natural                          := 44;
  constant SOC_TIME          : natural                          := (CLK_FREQUENCY_MHZ*1_000_000);
  constant LIMIT_TIMER       : natural                          := SOC_TIME;
  constant CLK_FREQUENCY_STD : std_logic_vector((D-1) downto 0) := conv_std_logic_vector((CLK_FREQUENCY_MHZ * 1000000), D);
  constant PERIOD_FREQ_MAX   : natural                          := 101_000_000;
  constant PERIOD_FREQ_MIN   : natural                          := 98_000_000;
  constant EDGE_TO_CHECK     : natural                          := 1;



-------------------------------------------------------------------------------
-- constantes -- 80 pontos
-------------------------------------------------------------------------------


  constant STEP_LOW_BITS_80    : natural := 7;   -- 100
  constant STEP_NORMAL_BITS_80 : natural := 14;  -- 10_000

  -- frequency constants  
  constant FREQ_BITS_80               : natural                                          := 13;
  constant FREQ_4800                  : std_logic_vector(FREQ_BITS_80-1 downto 0)        := conv_std_logic_vector(4800, FREQ_BITS_80);
  constant FREQ_4000                  : std_logic_vector(FREQ_BITS_80-1 downto 0)        := conv_std_logic_vector(4000, FREQ_BITS_80);
  constant FREQUENCY_DEFAULT_STD_4800 : std_logic_vector(N-1 downto 0)                   := x"12C000000000000";  -- (2^44*4800)
  constant FREQUENCY_DEFAULT_STD_4000 : std_logic_vector(N-1 downto 0)                   := x"0FA000000000000";  -- (2^44*4000)                
  constant K_DEFAULT_STD_4800         : std_logic_vector((N_BITS_NCO - 1) downto 0)      := x"0003254E6E2";  --(((2^44)*4800) / 100E6)
  constant K_DEFAULT_STD_4000         : std_logic_vector((N_BITS_NCO - 1) downto 0)      := x"00029F16B12";  --(((2^44)*4000) / 100E6)
  constant STEP_LOW_4800              : std_logic_vector(STEP_LOW_BITS_80-1 downto 0)    := conv_std_logic_vector(100, STEP_LOW_BITS_80);
  constant STEP_LOW_4000              : std_logic_vector(STEP_LOW_BITS_80-1 downto 0)    := conv_std_logic_vector(100, STEP_LOW_BITS_80);
  constant STEP_NORMAL_4800           : std_logic_vector(STEP_NORMAL_BITS_80-1 downto 0) := conv_std_logic_vector(10_000, STEP_NORMAL_BITS_80);
  constant STEP_NORMAL_4000           : std_logic_vector(STEP_NORMAL_BITS_80-1 downto 0) := conv_std_logic_vector(10_000, STEP_NORMAL_BITS_80);


  constant DELTA_LIMIT_80        : natural := 10_000;
  constant LIMIT_LO_80           : natural := DELTA_LIMIT_80/2;
  constant LIMIT_HI_80           : natural := (SOC_TIME - DELTA_LIMIT_80/2);
  constant DELTA_LIMIT_80_LOCKED : natural := 400;
  constant LIMIT_LO_80_LOCKED    : natural := (DELTA_LIMIT_80_LOCKED/2);
  constant LIMIT_HI_80_LOCKED    : natural := (SOC_TIME - DELTA_LIMIT_80_LOCKED/2);



-------------------------------------------------------------------------------
-- constantes 256 pontos  -- (testar)
-------------------------------------------------------------------------------


  constant STEP_LOW_BITS_256    : natural := 2;
  constant STEP_NORMAL_BITS_256 : natural := 3;


  -- frequency constants
  constant FREQ_BITS_256               : natural                                           := 14;
  constant FREQ_15360                  : std_logic_vector(FREQ_BITS_256-1 downto 0)        := conv_std_logic_vector(15360, FREQ_BITS_256);
  constant FREQ_12800                  : std_logic_vector(FREQ_BITS_256-1 downto 0)        := conv_std_logic_vector(12800, FREQ_BITS_256);
  constant FREQUENCY_DEFAULT_STD_15360 : std_logic_vector(N-1 downto 0)                    := x"003C00000000000";
  constant FREQUENCY_DEFAULT_STD_12800 : std_logic_vector(N-1 downto 0)                    := x"003C00000000000";
  constant K_DEFAULT_STD_15360         : std_logic_vector((N_BITS_NCO - 1) downto 0)       := x"00000A10FAF";
  constant K_DEFAULT_STD_12800         : std_logic_vector((N_BITS_NCO - 1) downto 0)       := x"00000A10FAF";
  constant STEP_LOW_15360              : std_logic_vector(STEP_LOW_BITS_256-1 downto 0)    := conv_std_logic_vector(1, STEP_LOW_BITS_256);
  constant STEP_LOW_12800              : std_logic_vector(STEP_LOW_BITS_256-1 downto 0)    := conv_std_logic_vector(1, STEP_LOW_BITS_256);
  constant STEP_NORMAL_15360           : std_logic_vector(STEP_NORMAL_BITS_256-1 downto 0) := conv_std_logic_vector(5, STEP_NORMAL_BITS_256);
  constant STEP_NORMAL_12800           : std_logic_vector(STEP_NORMAL_BITS_256-1 downto 0) := conv_std_logic_vector(5, STEP_NORMAL_BITS_256);


  constant DELTA_LIMIT_256        : natural := 100;
  constant LIMIT_LO_256           : natural := (DELTA_LIMIT_256/2);
  constant LIMIT_HI_256           : natural := (SOC_TIME - DELTA_LIMIT_256/2);
  constant DELTA_LIMIT_256_LOCKED : natural := 10;
  constant LIMIT_LO_256_LOCKED    : natural := (DELTA_LIMIT_256_LOCKED/2);
  constant LIMIT_HI_256_LOCKED    : natural := (SOC_TIME - DELTA_LIMIT_256_LOCKED/2);



end package mu320_constants;



