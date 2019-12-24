-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 6.0
--  \   \        Filename: $RCSfile: floating_point_v6_0_comp.vhd,v $
--  /   /        Date Last Modified: $Date: 2011/05/30 20:25:36 $
-- /___/   /\    Date Created: Dec 2005
-- \   \  /  \
--  \___\/\___\
--
--Device  : All
--Library : xilinxcorelib
--Purpose : Floating-point operator component declaration for behavioral model
--
--------------------------------------------------------------------------------
--  (c) Copyright 2005-2009, 2011 Xilinx, Inc. All rights reserved.
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
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package floating_point_v6_0_comp is

  --core_if on component floating_point_v6_0
  component floating_point_v6_0
  generic (
    C_XDEVICEFAMILY         : string  := "no_family";  -- Device family
    C_HAS_ADD               : integer := 1;            -- Add operation: 1=yes, 0=no
    C_HAS_SUBTRACT          : integer := 0;            -- Subtract operation: 1=yes, 0=no
    C_HAS_MULTIPLY          : integer := 0;            -- Multiply operation: 1=yes, 0=no
    C_HAS_DIVIDE            : integer := 0;            -- Divide operation: 1=yes, 0=no
    C_HAS_SQRT              : integer := 0;            -- Square root operation: 1=yes, 0=no
    C_HAS_COMPARE           : integer := 0;            -- Compare operation: 1=yes, 0=no
    C_HAS_FIX_TO_FLT        : integer := 0;            -- Fixed to float operation: 1=yes, 0=no
    C_HAS_FLT_TO_FIX        : integer := 0;            -- Float to fixed operation: 1=yes, 0=no
    C_HAS_FLT_TO_FLT        : integer := 0;            -- Float to float operation: 1=yes, 0=no
    C_HAS_RECIP             : integer := 0;            -- Reciprocal: 1=yes, 0=no
    C_HAS_RECIP_SQRT        : integer := 0;            -- Reciprocal square root operation: 1=yes, 0=no
    C_A_WIDTH               : integer := 32;           -- Total bit width of A operand: range 4-80
    C_A_FRACTION_WIDTH      : integer := 24;           -- Bit width of fractional part of A operand: range 0-64
    C_B_WIDTH               : integer := 32;           -- Total bit width of B operand: range 4-80
    C_B_FRACTION_WIDTH      : integer := 24;           -- Bit width of fractional part of B operand: range 0-64
    C_RESULT_WIDTH          : integer := 32;           -- Total bit width of result: range 4-80
    C_RESULT_FRACTION_WIDTH : integer := 24;           -- Bit width of fractional part of result: range 0-64
    C_COMPARE_OPERATION     : integer := 1;            -- Comparison: 0? 1< 2= 3<= 4> 5<> 6>= 7condcode 8prog
    C_LATENCY               : integer := 1000;         -- Latency: specify cyles, or 1000 for fully-pipelined
    C_OPTIMIZATION          : integer := 1;            -- 1=optimize for speed, 2=optimize for low latency
    C_MULT_USAGE            : integer := 2;            -- Level of DSP48 usage: 0=none, 1=medium, 2=full, 3=max
    C_RATE                  : integer := 1;            -- Cycles per operation (divide and square root only)
    C_HAS_UNDERFLOW         : integer := 0;            -- Underflow exception output: 1=yes, 0=no
    C_HAS_OVERFLOW          : integer := 0;            -- Overflow exception output: 1=yes, 0=no
    C_HAS_INVALID_OP        : integer := 0;            -- Invalid operation exception output: 1=yes, 0=no
    C_HAS_DIVIDE_BY_ZERO    : integer := 0;            -- Divide by zero exception output: 1=yes, 0=no
    C_HAS_ACLKEN            : integer := 0;            -- Clock enable input: 1=yes, 0=no
    C_HAS_ARESETN           : integer := 0;            -- Synchronous reset input: 1=yes, 0=no
    C_THROTTLE_SCHEME       : integer := 1;            -- AXI handshaking: 1=CE, 2=RFD, 3=AND_TVALID, 4=GEN
    C_HAS_A_TUSER           : integer := 0;            -- A channel has TUSER signal: 1=yes, 0=no
    C_HAS_A_TLAST           : integer := 0;            -- A channel has TLAST signal: 1=yes, 0=no
    C_HAS_B                 : integer := 1;            -- B channel present: 1=yes, 0=no
    C_HAS_B_TUSER           : integer := 0;            -- B channel has TUSER signal: 1=yes, 0=no
    C_HAS_B_TLAST           : integer := 0;            -- B channel has TLAST signal: 1=yes, 0=no
    C_HAS_OPERATION         : integer := 0;            -- OPERATION channel present: 1=yes, 0=no
    C_HAS_OPERATION_TUSER   : integer := 0;            -- OPERATION channel has TUSER signal: 1=yes, 0=no
    C_HAS_OPERATION_TLAST   : integer := 0;            -- OPERATION channel has TLAST signal: 1=yes, 0=no
    C_HAS_RESULT_TUSER      : integer := 0;            -- RESULT channel has TUSER signal: 1=yes, 0=no
    C_HAS_RESULT_TLAST      : integer := 0;            -- RESULT channel has TLAST signal: 1=yes, 0=no
    C_TLAST_RESOLUTION      : integer := 1;            -- RESULT TLAST value: 1=A, 2=B, 3=OPERATION, 16=OR, 17=AND
    C_A_TDATA_WIDTH         : integer := 32;           -- Bit width of A TDATA signal: byte_roundup(C_A_WIDTH)
    C_A_TUSER_WIDTH         : integer := 1;            -- Bit width of A TUSER signal (if present): range 1-256
    C_B_TDATA_WIDTH         : integer := 32;           -- Bit width of B TDATA signal: byte_roundup(C_B_WIDTH)
    C_B_TUSER_WIDTH         : integer := 1;            -- Bit width of B TUSER signal (if present): range 1-256
    C_OPERATION_TDATA_WIDTH : integer := 8;            -- Bit width of OPERATION TDATA signal: must be 8
    C_OPERATION_TUSER_WIDTH : integer := 1;            -- Bit width of OPERATION TUSER signal (if present): range 1-256
    C_RESULT_TDATA_WIDTH    : integer := 32;           -- Bit width of RESULT TDATA signal: byte_roundup(C_RESULT_WIDTH)
    C_RESULT_TUSER_WIDTH    : integer := 1             -- Bit width of RESULT TUSER signal (if present): range 1-772
  );
  port (
    -- Global signals
    aclk                    : in  std_logic                                            := '0';  -- Clock
    aclken                  : in  std_logic                                            := '1';  -- Clock enable
    aresetn                 : in  std_logic                                            := '1';  -- Reset, active low
    -- AXI4-Stream slave channel for operand A
    s_axis_a_tvalid         : in  std_logic                                            := '0';              -- Valid
    s_axis_a_tready         : out std_logic                                            := '0';              -- Ready
    s_axis_a_tdata          : in  std_logic_vector(C_A_TDATA_WIDTH-1 downto 0)         := (others => '0');  -- Data
    s_axis_a_tuser          : in  std_logic_vector(C_A_TUSER_WIDTH-1 downto 0)         := (others => '0');  -- User
    s_axis_a_tlast          : in  std_logic                                            := '0';              -- Last
    -- AXI4-Stream slave channel for operand B
    s_axis_b_tvalid         : in  std_logic                                            := '0';              -- Valid
    s_axis_b_tready         : out std_logic                                            := '0';              -- Ready
    s_axis_b_tdata          : in  std_logic_vector(C_B_TDATA_WIDTH-1 downto 0)         := (others => '0');  -- Data
    s_axis_b_tuser          : in  std_logic_vector(C_B_TUSER_WIDTH-1 downto 0)         := (others => '0');  -- User
    s_axis_b_tlast          : in  std_logic                                            := '0';              -- Last
    -- AXI4-Stream slave channel for operation control information
    s_axis_operation_tvalid : in  std_logic                                            := '0';              -- Valid
    s_axis_operation_tready : out std_logic                                            := '0';              -- Ready
    s_axis_operation_tdata  : in  std_logic_vector(C_OPERATION_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Data
    s_axis_operation_tuser  : in  std_logic_vector(C_OPERATION_TUSER_WIDTH-1 downto 0) := (others => '0');  -- User
    s_axis_operation_tlast  : in  std_logic                                            := '0';              -- Last
    -- AXI4-Stream master channel for output result
    m_axis_result_tvalid    : out std_logic                                            := '0';              -- Valid
    m_axis_result_tready    : in  std_logic                                            := '0';              -- Ready
    m_axis_result_tdata     : out std_logic_vector(C_RESULT_TDATA_WIDTH-1 downto 0)    := (others => '0');  -- Data
    m_axis_result_tuser     : out std_logic_vector(C_RESULT_TUSER_WIDTH-1 downto 0)    := (others => '0');  -- User
    m_axis_result_tlast     : out std_logic                                            := '0'               -- Last
    );
  --core_if off
  end component;

  -- The following tells XST that floating_point_v6_0 is a black box which
  -- should be generated by the command given by the value of this attribute
  -- Note the fully qualified SIM (JAVA class) name that forms the
  -- basis of the core.
  attribute BOX_TYPE                                 : string;
  attribute BOX_TYPE of floating_point_v6_0          : component is "black_box";
  attribute GENERATOR_DEFAULT                        : string;
  attribute GENERATOR_DEFAULT of floating_point_v6_0 : component is
            "generatecore com.xilinx.ip.floating_point_v6_0.floating_point_v6_0";

end floating_point_v6_0_comp;
