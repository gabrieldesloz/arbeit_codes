-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 4.0
--  \   \        Filename: $RCSfile: dds_compiler_v5_0_comp.vhd,v $
--  /   /        Date Last Modified: $Date: 2010/09/08 11:21:20 $
-- /___/   /\    Date Created: 2006
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : dds_compiler_v5_0
-- Purpose : Component declaration for core top-level
-------------------------------------------------------------------------------
--  (c) Copyright 2006, 2009-2010 Xilinx, Inc. All rights reserved.
--
--  This file contains confidential and proprietary information
--  of Xilinx, Inc. and is protected under U.S. and
--  international copyright and other intellectual property
--  laws.
--
--  DISCLAIMER
--  This disclaimer is not a license and does not grant any
--  rights to the materials distributed herewith. Except as
--  otherwise provided in a valid license issued to you by
--  Xilinx, and to the maximum extent permitted by applicable
--  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
--  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
--  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
--  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
--  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
--  (2) Xilinx shall not be liable (whether in contract or tort,
--  including negligence, or under any other theory of
--  liability) for any loss or damage of any kind or nature
--  related to, arising under or in connection with these
--  materials, including for any direct, or any indirect,
--  special, incidental, or consequential loss or damage
--  (including loss of data, profits, goodwill, or any type of
--  loss or damage suffered as a result of any action brought
--  by a third party) even if such damage or loss was
--  reasonably foreseeable or Xilinx had been advised of the
--  possibility of the same.
--
--  CRITICAL APPLICATIONS
--  Xilinx products are not designed or intended to be fail-
--  safe, or for use in any application requiring fail-safe
--  performance, such as life-support or safety devices or
--  systems, Class III medical devices, nuclear facilities,
--  applications related to the deployment of airbags, or any
--  other applications that could lead to death, personal
--  injury, or severe property or environmental damage
--  (individually and collectively, "Critical
--  Applications"). Customer assumes the sole risk and
--  liability of any use of Xilinx products in Critical
--  Applications, subject only to applicable laws and
--  regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
--  PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package dds_compiler_v5_0_comp is

  --core_if on component dds_compiler_v5_0
  component dds_compiler_v5_0
    generic (
      C_XDEVICEFAMILY          : string  := "virtex6";
      C_ACCUMULATOR_WIDTH      : integer := 28;  -- width of accum and associated paths. Factor in Frequency resolution
      C_CHANNELS               : integer := 1;   -- number of time-multiplexed channels output
      C_HAS_CHANNEL_INDEX      : integer := 0;   -- enables CHANNEL output port
      C_HAS_PHASE_OUT          : integer := 0;   -- phase_out pin visible
      C_HAS_PHASEGEN           : integer := 1;   -- generate the phase accumulator
      C_HAS_SINCOS             : integer := 1;   -- generate the sin/cos block
      C_LATENCY                : integer := -1;  -- Selects overall latency, -1 means 'fully pipelined for max performance'
      C_MEM_TYPE               : integer := 1;   -- 0= Auto, 1 = Block ROM, 2 = DIST_ROM
      C_NEGATIVE_COSINE        : integer := 0;   -- 0 = normal cosine, 1 = negated COSINE output port
      C_NEGATIVE_SINE          : integer := 0;   -- 0 = normal sine, 1 = negated SINE output port
      C_NOISE_SHAPING          : integer := 0;   -- 0 = none, 1 = Dither, 2 = Error Feed Forward (Taylor)
      C_OUTPUTS_REQUIRED       : integer := 2;   -- 0 = SIN, 1 = COS, 2 = Both;
      C_OUTPUT_WIDTH           : integer := 6;   -- sets width of output port (factor in SFDR)
      C_PHASE_ANGLE_WIDTH      : integer := 6;   -- width of phase fed to RAM (factor in RAM resource used)
      C_PHASE_INCREMENT        : integer := 2;   -- 1 = register, 2 = constant, 3 = streaming (input port);
      C_PHASE_INCREMENT_VALUE  : string  := "0"; -- string of values for PINC, one for each channel.
      C_PHASE_OFFSET           : integer := 0;   -- 0 = none, 1 = reg, 2 = const, 3 = stream (input port);
      C_PHASE_OFFSET_VALUE     : string  := "0"; -- string of values for POFF, one for each channel
      C_OPTIMISE_GOAL          : integer := 0;   -- 0 = area, 1 = speed
      C_USE_DSP48              : integer := 0;   -- 0 = minimal 1 = max. Determines DSP48 use in phase accumulation.
      C_POR_MODE               : integer := 0;   -- Power-on-reset behaviour (for behavioral model)
      C_AMPLITUDE              : integer := 0;   -- 0 = full scale (+/- 2^N-2), 1 = unit circle (+/- 2^(N-1))
      -------------------------------------------------------------------------
      -- AXI-S interface generics
      -------------------------------------------------------------------------
      -- General
      C_HAS_ACLKEN            : integer := 0;    -- enables active-high clock enable
      C_HAS_ARESETN           : integer := 0;    -- enables active-low synchronous reset
      C_HAS_TLAST             : integer := 0;    -- enables TLAST signals on relevant channels
      C_HAS_TREADY            : integer := 1;    -- enables TREADY signals on relevant channels
      -- S_PHASE
      C_HAS_S_PHASE           : integer := 1;    -- enables phase input channel
      C_S_PHASE_TDATA_WIDTH   : integer := 8;    -- TDATA width (byte-sized)
      C_S_PHASE_HAS_TUSER     : integer := 0;    -- enables phase channel TUSER, selects TUSER content
      C_S_PHASE_TUSER_WIDTH   : integer := 1;    -- TUSER width
      -- S_CONFIG
      C_HAS_S_CONFIG          : integer := 0;    -- enables config input channel
      C_S_CONFIG_SYNC_MODE    : integer := 0;    -- specifies how config is synchronized to phase channel
      C_S_CONFIG_TDATA_WIDTH  : integer := 0;    -- TDATA width (byte-sized)
      -- M_DATA
      C_HAS_M_DATA            : integer := 1;    -- enables data output channel
      C_M_DATA_TDATA_WIDTH    : integer := 32;   -- TDATA width (byte-sized)
      C_M_DATA_HAS_TUSER      : integer := 0;    -- enables data channel TUSER, selects TUSER content
      C_M_DATA_TUSER_WIDTH    : integer := 1;    -- TUSER width
      -- M_PHASE
      C_HAS_M_PHASE           : integer := 0;    -- enables phase output channel
      C_M_PHASE_TDATA_WIDTH   : integer := 0;    -- TDATA width (byte-sized)
      C_M_PHASE_HAS_TUSER     : integer := 0;    -- enables phase channel TUSER, selects TUSER content
      C_M_PHASE_TUSER_WIDTH   : integer := 1;    -- TUSER width
      ---------------------------------------------------------------------------
      -- Debug/validation enablement
      ---------------------------------------------------------------------------
      C_DEBUG_INTERFACE       : integer := 0;
      C_CHAN_WIDTH            : integer := 1      
      );
    port (
      -- Common ports
      aclk                            : in  std_logic                                           := '0';
      aclken                          : in  std_logic                                           := '1';
      aresetn                         : in  std_logic                                           := '1';
      -- S_PHASE
      s_axis_phase_tvalid             : in  std_logic                                           := '0';
      s_axis_phase_tready             : out std_logic                                           := '0';
      s_axis_phase_tdata              : in  std_logic_vector(C_S_PHASE_TDATA_WIDTH-1 downto 0)  := (others => '0');
      s_axis_phase_tlast              : in  std_logic                                           := '0';
      s_axis_phase_tuser              : in  std_logic_vector(C_S_PHASE_TUSER_WIDTH-1 downto 0)  := (others => '0');
      -- S_CONFIG
      s_axis_config_tvalid            : in  std_logic                                           := '0';
      s_axis_config_tready            : out std_logic                                           := '0';
      s_axis_config_tdata             : in  std_logic_vector(C_S_CONFIG_TDATA_WIDTH-1 downto 0) := (others => '0');
      s_axis_config_tlast             : in  std_logic                                           := '0';
      -- M_DATA
      m_axis_data_tvalid              : out std_logic                                           := '0';
      m_axis_data_tready              : in  std_logic                                           := '0';
      m_axis_data_tdata               : out std_logic_vector(C_M_DATA_TDATA_WIDTH-1 downto 0)   := (others => '0');
      m_axis_data_tlast               : out std_logic                                           := '0';
      m_axis_data_tuser               : out std_logic_vector(C_M_DATA_TUSER_WIDTH-1 downto 0)   := (others => '0');
      -- M_PHASE
      m_axis_phase_tvalid             : out std_logic                                           := '0';
      m_axis_phase_tready             : in  std_logic                                           := '0';
      m_axis_phase_tdata              : out std_logic_vector(C_M_PHASE_TDATA_WIDTH-1 downto 0)  := (others => '0');
      m_axis_phase_tlast              : out std_logic                                           := '0';
      m_axis_phase_tuser              : out std_logic_vector(C_M_PHASE_TUSER_WIDTH-1 downto 0)  := (others => '0');
      -- Event Interface
      event_s_phase_tlast_missing     : out std_logic                                           := '0';
      event_s_phase_tlast_unexpected  : out std_logic                                           := '0';
      event_s_phase_chanid_incorrect  : out std_logic                                           := '0';
      event_s_config_tlast_missing    : out std_logic                                           := '0';
      event_s_config_tlast_unexpected : out std_logic                                           := '0';
      -- Debug ports
      debug_axi_pinc_in               : out std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)    := (others => '0');
      debug_axi_poff_in               : out std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)    := (others => '0');
      debug_axi_chan_in               : out std_logic_vector(C_CHAN_WIDTH-1 downto 0)           := (others => '0');
      debug_core_nd                   : out std_logic                                           := '0';
      debug_phase                     : out std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0)    := (others => '0');
      debug_phase_nd                  : out std_logic                                           := '0'
      );
    --core_if off
  end component;
  -- The following tells XST that dds_compiler_v5_0 is a black box which
  -- should be generated command given by the value of this attribute
  -- Note the fully qualified SIM (JAVA class) name that forms the
  -- basis of the core

  -- xcc exclude
  attribute box_type                               : string;
  attribute generator_default                      : string;
  attribute box_type of dds_compiler_v5_0          : component is "black_box";
  attribute generator_default of dds_compiler_v5_0 : component is
    "generatecore com.xilinx.ip.dds_compiler_v5_0.dds_compiler_v5_0";
  -- xcc include

end dds_compiler_v5_0_comp;
