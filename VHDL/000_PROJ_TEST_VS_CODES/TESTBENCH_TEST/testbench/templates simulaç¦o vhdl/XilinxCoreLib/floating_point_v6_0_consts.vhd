-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 6.0
--  \   \        Filename: $RCSfile: floating_point_v6_0_consts.vhd,v $
--  /   /        Date Last Modified: $Date: 2011/05/30 20:25:36 $
-- /___/   /\    Date Created: Dec 2005
-- \   \  /  \
--  \___\/\___\
--
--Device  : All
--Library : xilinxcorelib.floating_point_v6_0_consts
--Purpose : Floating-point generic defaults and useful constants
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

package floating_point_v6_0_consts is

  --------------------------------------------------------------------------------
  -- Useful constants
  --------------------------------------------------------------------------------
  constant FLT_PT_MAX_W                    : integer := 128;

  -- Use to set generics with logical values
  constant FLT_PT_YES                      : integer := 1;
  constant FLT_PT_NO                       : integer := 0;
  constant FLT_PT_TRUE                     : integer := 1;
  constant FLT_PT_FALSE                    : integer := 0;

  -- C_OPTIMIZED settings
  constant FLT_PT_SPEED_OPTIMIZED          : integer := 1;
  constant FLT_PT_LOW_LATENCY              : integer := 2;

  -- C_MULT_USAGE options
  constant FLT_PT_NO_USAGE                 : integer := 0;
  constant FLT_PT_MEDIUM_USAGE             : integer := 1;
  constant FLT_PT_FULL_USAGE               : integer := 2;
  constant FLT_PT_MAX_USAGE                : integer := 3;

  -- C_LATENCY options (at present both options result in
  -- the same core)
  constant FLT_PT_MAX_LATENCY              : integer := 1000;

  -- C_SPEED
  constant FLT_PT_AREA                     : integer := 0;
  constant FLT_PT_AREA_SPEED               : integer := 1;
  constant FLT_PT_SPEED                    : integer := 2;

  -- Op-code format
  -- <cmp_mode><prim_op>
  constant FLT_PT_OP_CODE_WIDTH            : integer := 3;
  constant FLT_PT_COMPARE_OPERATION_WIDTH  : integer := 3;

  -- Operation format for compare
  -- < cmp_code >< cmp op >
  constant FLT_PT_OPERATION_WIDTH          : integer := FLT_PT_OP_CODE_WIDTH + FLT_PT_COMPARE_OPERATION_WIDTH;

  -- OPERATION TDATA signal is FLT_PT_OPERATION_WIDTH rounded up to the next byte
  constant FLT_PT_OPERATION_TDATA_WIDTH    : integer := 8;

  -- Constants required for test packages
  constant FLT_PT_STATUS_WIDTH     : integer := 5;
  constant FLT_PT_ROUND_MODE_WIDTH : integer := 2;
  constant FLT_PT_SPECIAL_SLICE    : integer := FLT_PT_OP_CODE_WIDTH;
  subtype FLT_PT_ROUND_MODE_SLICE is integer range
    FLT_PT_ROUND_MODE_WIDTH + FLT_PT_OP_CODE_WIDTH downto
    FLT_PT_OP_CODE_WIDTH+1;
  constant FLT_PT_RND_TO_NEAREST_EVEN : integer := 0;
  constant FLT_PT_RND_TO_ZERO         : integer := 1;
  constant FLT_PT_RND_TO_POS_INF      : integer := 2;
  constant FLT_PT_RND_TO_NEG_INF      : integer := 3;
  constant FLT_PT_IEEE_MODES          : integer := 4;

  constant FLT_PT_SQRT2_SGL : std_logic_vector(23 downto 0) := X"3504f3";
  constant FLT_PT_SQRT2_DBL : std_logic_vector(51 downto 0) := X"6a09e667f3bcd";

  --------------------------------------------------------------------------------
  -- Type declarations to enable operation bits to be addressed
  --------------------------------------------------------------------------------
  subtype  FLT_PT_OP_CODE_SLICE            is integer range
    FLT_PT_OP_CODE_WIDTH - 1 downto 0;
  subtype  FLT_PT_COMPARE_OPERATION_SLICE  is integer range
    FLT_PT_COMPARE_OPERATION_WIDTH + FLT_PT_OP_CODE_WIDTH - 1 downto FLT_PT_OP_CODE_WIDTH;

  -- C_COMPARE_OPERATION options
  constant FLT_PT_UNORDERED                : integer := 0;
  constant FLT_PT_LESS_THAN                : integer := 1;
  constant FLT_PT_EQUAL                    : integer := 2;
  constant FLT_PRT_LESS_THAN_OR_EQUAL      : integer := 3;
  constant FLT_PT_GREATER_THAN             : integer := 4;
  constant FLT_PT_NOT_EQUAL                : integer := 5;
  constant FLT_PT_GREATER_THAN_OR_EQUAL    : integer := 6;
  constant FLT_PT_CONDITION_CODE           : integer := 7;
  constant FLT_PT_PROGRAMMABLE             : integer := 8;

  constant FLT_PT_UNORDERED_SLV            :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "000";
  constant FLT_PT_LESS_THAN_SLV             :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "001";
  constant FLT_PT_EQUAL_SLV                :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "010";
  constant FLT_PRT_LESS_THAN_OR_EQUAL_SLV  :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "011";
  constant FLT_PT_GREATER_THAN_SLV         :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "100";
  constant FLT_PT_NOT_EQUAL_SLV            :
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "101";
  constant FLT_PT_GREATER_THAN_OR_EQUAL_SLV:
    std_logic_vector(FLT_PT_COMPARE_OPERATION_WIDTH - 1 downto 0) := "110";

  --------------------------------------------------------------------------------
  -- Integer values for operation codes
  --------------------------------------------------------------------------------
  -- REVISIT: the overloading of opcodes isn't ideal.  We can probably do away
  -- with them completely and just check generics instead
  constant FLT_PT_ADD_OP_CODE        : integer := 0;
  constant FLT_PT_SUBTRACT_OP_CODE   : integer := 1;
  constant FLT_PT_MULTIPLY_OP_CODE   : integer := 2;
  constant FLT_PT_DIVIDE_OP_CODE     : integer := 3;
  constant FLT_PT_COMPARE_OP_CODE    : integer := 4;
  constant FLT_PT_FLT_TO_FIX_OP_CODE : integer := 5;
  constant FLT_PT_FIX_TO_FLT_OP_CODE : integer := 6;
  constant FLT_PT_SQRT_OP_CODE       : integer := 7;
  constant FLT_PT_FLT_TO_FLT_OP_CODE : integer := 15;
  constant FLT_PT_RECIP_OP_CODE      : integer := 23;  -- 3 LSBs "111" to allow SQRT SLV opcode overloading
  constant FLT_PT_RECIP_SQRT_OP_CODE : integer := 31;  -- 3 LSBs "111" to allow SQRT SLV opcode overloading

  constant FLT_PT_ADD_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "000";
  constant FLT_PT_SUBTRACT_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "001";
  constant FLT_PT_MULTIPLY_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "010";
  constant FLT_PT_DIVIDE_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "011";
  constant FLT_PT_COMPARE_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "100";
  constant FLT_PT_FLT_TO_FIX_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "101";
  -- The following are not yet supported
  constant FLT_PT_FIX_TO_FLT_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "110";
  -- This is an overloaded opcode for sqrt, float-to-float, 1/x, 1/sqrt(x)
  constant FLT_PT_SQRT_FTF_OP_CODE_SLV :
    std_logic_vector(FLT_PT_OP_CODE_WIDTH - 1 downto 0) := "111";

  --------------------------------------------------------------------------------
  -- Default values for generics
  --------------------------------------------------------------------------------
  constant C_XDEVICEFAMILY_DEFAULT         : string  := "no_family";  -- to ensure that it is set correctly
  constant C_HAS_ADD_DEFAULT               : integer := FLT_PT_TRUE;
  constant C_HAS_SUBTRACT_DEFAULT          : integer := FLT_PT_FALSE;
  constant C_HAS_MULTIPLY_DEFAULT          : integer := FLT_PT_FALSE;
  constant C_HAS_DIVIDE_DEFAULT            : integer := FLT_PT_FALSE;
  constant C_HAS_SQRT_DEFAULT              : integer := FLT_PT_FALSE;
  constant C_HAS_COMPARE_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_HAS_FIX_TO_FLT_DEFAULT        : integer := FLT_PT_FALSE;
  constant C_HAS_FLT_TO_FIX_DEFAULT        : integer := FLT_PT_FALSE;
  constant C_HAS_FLT_TO_FLT_DEFAULT        : integer := FLT_PT_FALSE;
  constant C_HAS_RECIP_DEFAULT             : integer := FLT_PT_FALSE;
  constant C_HAS_RECIP_SQRT_DEFAULT        : integer := FLT_PT_FALSE;
  constant C_A_WIDTH_DEFAULT               : integer := 32;
  constant C_A_FRACTION_WIDTH_DEFAULT      : integer := 24;
  constant C_B_WIDTH_DEFAULT               : integer := 32;
  constant C_B_FRACTION_WIDTH_DEFAULT      : integer := 24;
  constant C_RESULT_WIDTH_DEFAULT          : integer := 32;
  constant C_RESULT_FRACTION_WIDTH_DEFAULT : integer := 24;
  constant C_COMPARE_OPERATION_DEFAULT     : integer := FLT_PT_LESS_THAN;
  constant C_LATENCY_DEFAULT               : integer := FLT_PT_MAX_LATENCY;
  constant C_OPTIMIZATION_DEFAULT          : integer := FLT_PT_SPEED_OPTIMIZED;
  constant C_MULT_USAGE_DEFAULT            : integer := FLT_PT_FULL_USAGE;
  constant C_RATE_DEFAULT                  : integer := 1;
  constant C_HAS_UNDERFLOW_DEFAULT         : integer := FLT_PT_FALSE;
  constant C_HAS_OVERFLOW_DEFAULT          : integer := FLT_PT_FALSE;
  constant C_HAS_INVALID_OP_DEFAULT        : integer := FLT_PT_FALSE;
  constant C_HAS_DIVIDE_BY_ZERO_DEFAULT    : integer := FLT_PT_FALSE;
  constant C_HAS_ACLKEN_DEFAULT            : integer := FLT_PT_FALSE;
  constant C_HAS_ARESETN_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_THROTTLE_SCHEME_DEFAULT       : integer := 1;
  constant C_HAS_A_TUSER_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_HAS_A_TLAST_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_HAS_B_DEFAULT                 : integer := 1;
  constant C_HAS_B_TUSER_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_HAS_B_TLAST_DEFAULT           : integer := FLT_PT_FALSE;
  constant C_HAS_OPERATION_DEFAULT         : integer := FLT_PT_FALSE;
  constant C_HAS_OPERATION_TUSER_DEFAULT   : integer := FLT_PT_FALSE;
  constant C_HAS_OPERATION_TLAST_DEFAULT   : integer := FLT_PT_FALSE;
  constant C_HAS_RESULT_TUSER_DEFAULT      : integer := FLT_PT_FALSE;
  constant C_HAS_RESULT_TLAST_DEFAULT      : integer := FLT_PT_FALSE;
  constant C_TLAST_RESOLUTION_DEFAULT      : integer := 0;
  constant C_A_TDATA_WIDTH_DEFAULT         : integer := 32;
  constant C_A_TUSER_WIDTH_DEFAULT         : integer := 1;
  constant C_B_TDATA_WIDTH_DEFAULT         : integer := 32;
  constant C_B_TUSER_WIDTH_DEFAULT         : integer := 1;
  constant C_OPERATION_TDATA_WIDTH_DEFAULT : integer := 8;
  constant C_OPERATION_TUSER_WIDTH_DEFAULT : integer := 1;
  constant C_RESULT_TDATA_WIDTH_DEFAULT    : integer := 32;
  constant C_RESULT_TUSER_WIDTH_DEFAULT    : integer := 1;

end package floating_point_v6_0_consts;
