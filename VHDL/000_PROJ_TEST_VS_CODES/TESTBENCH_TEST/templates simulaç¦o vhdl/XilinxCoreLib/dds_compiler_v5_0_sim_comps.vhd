-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 4.0
--  \   \        Filename: $RCSfile: dds_compiler_v5_0_sim_comps.vhd,v $
--  /   /        Date Last Modified: $Date: 2010/09/08 11:21:21 $
-- /___/   /\    Date Created: 2006
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : dds_compiler_v5_0
-- Purpose : Simulation component declarations
-------------------------------------------------------------------------------
-- (c) Copyright 2006-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-------------------------------------------------------------------------------
library std, ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.xcc_utils_v2_0.all;
use xilinxcorelib.pkg_dds_compiler_v5_0.all;

package dds_compiler_v5_0_sim_comps is

  component dds_compiler_v5_0_behv is
    generic (
      C_XDEVICEFAMILY         : string  := "virtex4";
      C_ACCUMULATOR_WIDTH     : integer := 28;  -- width of accum and associated paths. Factor in Frequency resolution
      C_CHANNELS              : integer := 1;  -- number of time-multiplexed channels output
      C_HAS_CE                : integer := 0;  -- enables input CE port.
      C_HAS_CHANNEL_INDEX     : integer := 0;  -- enables CHANNEL output port
      C_HAS_RDY               : integer := 1;  -- enables RDY output port
      C_HAS_RFD               : integer := 0;  -- enables RFD input port (RFD is always true)
      C_HAS_SCLR              : integer := 0;  -- enables SCLR input port
      C_HAS_PHASE_OUT         : integer := 0;  -- phase_out pin visible
      C_HAS_PHASEGEN          : integer := 1;  -- generate the phase accumulator
      C_HAS_SINCOS            : integer := 1;  -- generate the sin/cos block
      C_LATENCY               : integer := -1;  -- Selects overall latency, -1 means 'fully pipelined for max performance'
      C_MEM_TYPE              : integer := 1;  -- 0= Auto, 1 = Block ROM, 2 = DIST_ROM
      C_NEGATIVE_COSINE       : integer := 0;  -- 0 = normal cosine, 1 = negated COSINE output port
      C_NEGATIVE_SINE         : integer := 0;  -- 0 = normal sine, 1 = negated SINE output port
      C_NOISE_SHAPING         : integer := 0;  -- 0 = none, 1 = Dither, 2 = Error Feed Forward (Taylor)
      C_OUTPUTS_REQUIRED      : integer := 2;  -- 0 = SIN, 1 = COS, 2 = Both;
      C_OUTPUT_WIDTH          : integer := 6;  -- sets width of output port (factor in SFDR)
      C_PHASE_ANGLE_WIDTH     : integer := 6;  -- width of phase fed to RAM (factor in RAM resource used)
      C_PHASE_INCREMENT       : integer := 2;  -- 1 = register, 2 = constant, 3 = streaming (input port);
      C_PHASE_INCREMENT_VALUE : string  := "0";  -- string of values for PINC, one for each channel.
      C_PHASE_OFFSET          : integer := 0;  -- 0 = none, 1 = reg, 2 = const, 3 = stream (input port);
      C_PHASE_OFFSET_VALUE    : string  := "0";  -- string of values for POFF, one for each channel
      C_OPTIMISE_GOAL         : integer := 0;  -- 0 = area, 1 = speed
      C_USE_DSP48             : integer := 0;  -- 0 = minimal 1 = max. Determines DSP48 use in phase accumulation.
      C_POR_MODE              : integer := 0;  -- Power-on-reset behaviour (for behavioral model)
      C_AMPLITUDE             : integer := 0  -- 0 = full scale (+/- 2^N-2), 1 = unit circle (+/- 2^(N-1))
      );
    port (
      ADDR       : in  std_logic_vector(sel_lines_reqd(C_CHANNELS)-1 downto 0) := (others => '0');  -- selects channel for register write
      REG_SELECT : in  std_logic                                               := '0';  -- selects between PINC (0) and POFF (1)
      CE         : in  std_logic                                               := '0';  -- clock enable
      CLK        : in  std_logic                                               := '0';  -- clock
      SCLR       : in  std_logic                                               := '0';  -- sync reset.
      WE         : in  std_logic                                               := '0';  -- Write enable to PINC and POFF registers.
      DATA       : in  std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)        := (others => '0');  -- data in to PINC and POFF registers
      PINC_IN    : in  std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)        := (others => '0');  -- PINC streaming input
      POFF_IN    : in  std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)        := (others => '0');  -- POFF streaming input
      PHASE_IN   : in  std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)        := (others => '0');  -- phase input (used for SIN/COS LUT only case)
      RDY        : out std_logic;       -- output validity flag
      RFD        : out std_logic;       -- input validity flag (always true)
      CHANNEL    : out std_logic_vector(sel_lines_reqd(C_CHANNELS)-1 downto 0);  -- channel output. Identifies channel of SIN and COS outputs
      COSINE     : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);  -- Main Cosine output
      SINE       : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);  -- Main Sin output
      PHASE_OUT  : out std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0);  -- Output of phase accumulator (includes dithering and POFF if present)
      DEBUG_PHASE : out std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)  -- debug loom access to phase before sin/cos LUT
      );
  end component dds_compiler_v5_0_behv;

  component dds_compiler_v5_0_lut_ram
    generic (
      INIT_VAL     : t_ram_type;
      C_CHANNELS   : integer;
      C_DATA_WIDTH : integer;
      C_ADDR_WIDTH : integer;
      C_DPRA_WIDTH : integer;
      C_HAS_MUTE   : integer := 0;
      C_HAS_CE     : integer := 0;
      C_LATENCY    : integer
      );
    port (
      CLK  : in  std_logic                                 := '0';
      WE   : in  std_logic                                 := '0';
      MUTE : in  std_logic                                 := '0';
      CE   : in  std_logic                                 := '0';
      A    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      DI   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DPRA : in  std_logic_vector(C_DPRA_WIDTH-1 downto 0) := (others => '0');
      DPO  : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
      );
  end component;

  component dds_compiler_v5_0_lut5_ram
    generic (
      INIT_VAL     : t_ram_type;
      C_CHANNELS   : integer;
      C_DATA_WIDTH : integer;
      C_ADDR_WIDTH : integer;
      C_DPRA_WIDTH : integer;
      C_HAS_MUTE   : integer := 0;
      C_HAS_CE     : integer := 0;
      C_LATENCY    : integer
      );
    port (
      CLK  : in  std_logic                                 := '0';
      WE   : in  std_logic                                 := '0';
      MUTE : in  std_logic                                 := '0';
      CE   : in  std_logic                                 := '0';
      A    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      DI   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DPRA : in  std_logic_vector(C_DPRA_WIDTH-1 downto 0) := (others => '0');
      DPO  : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
      );
  end component;

  component dds_compiler_v5_0_eff
    generic (
      C_XDEVICEFAMILY     : string;
      C_MODEL_TYPE        : integer := 0;  -- 0 = synth, 1 = RTL
      C_ACCUMULATOR_WIDTH : integer;
      CI_PIPE             : t_pipe_top;
      C_HAS_CE            : integer;
      C_OUTPUT_WIDTH      : integer;
      C_OPTIMISE_GOAL     : integer;
      CI_RAM_DATA_WIDTH   : integer;
      CI_RAM_ADDR_WIDTH   : integer;
      C_NEGATIVE_SINE     : integer;
      C_NEGATIVE_COSINE   : integer
      );
    port (
      clk              : in  std_logic;
      ce_i             : in  std_logic;
      mute_i           : in  std_logic;
      sin_x            : in  std_logic_vector(ci_ram_data_width-1 downto 0);
      cos_x            : in  std_logic_vector(ci_ram_data_width-1 downto 0);
      acc_phase_to_lut : in  std_logic_vector(C_ACCUMULATOR_WIDTH -1 downto 0);
      pre_final_sin    : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);
      pre_final_cos    : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0)
      );
  end component;

  component dds_compiler_v5_0_multadd_wrapper
    generic (
      --BaseIP modelling generics
      C_VERBOSITY     : integer := 0;  --0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_MODEL_TYPE    : integer := 0;   --0 = synth, 1 = RTL
      --BaseIP common generics
      C_XDEVICEFAMILY : string  := "virtex4";
      C_LATENCY       : integer := -1
      );
    port (
      CLK      : in  std_logic                                                      := '1';
      CE       : in  std_logic                                                      := '1';
      SCLR     : in  std_logic                                                      := '0';
      SUBTRACT : in  std_logic                                                      := '0';
      A        : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      B        : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      C        : in  std_logic_vector(ci_dsp48_c_width-1 downto 0)                  := (others => '0');
      P        : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0')
      );
  end component;

  component dds_compiler_v5_0_eff_lut is
    generic (
      C_XDEVICEFAMILY : string  := "virtex4";
      C_LATENCY       : integer := -1;
      C_MODEL_TYPE    : integer := 0    -- 0 = synth, 1 = RTL
      );
    port (
      CLK  : in  std_logic                     := '1';
      CE   : in  std_logic                     := '1';
      SCLR : in  std_logic                     := '0';
      A    : in  std_logic_vector(9 downto 0)  := (others => '0');
      D    : out std_logic_vector(17 downto 0) := (others => '0')
      );
  end component;

end package dds_compiler_v5_0_sim_comps;
