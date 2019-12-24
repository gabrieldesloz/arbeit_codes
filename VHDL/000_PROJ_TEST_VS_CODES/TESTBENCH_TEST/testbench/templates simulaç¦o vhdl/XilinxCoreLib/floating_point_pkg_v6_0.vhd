--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 6.0
--  \   \        Filename: $RCSfile: floating_point_pkg_v6_0.vhd,v $
--  /   /        Date Last Modified: $Date: 2011/05/30 20:25:36 $
-- /___/   /\
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : xilinxcorelib.floating_point_pkg_v6_0
-- Purpose : Package of supporting functions
--
--------------------------------------------------------------------------------
--  (c) Copyright 2005-2007, 2009, 2011 Xilinx, Inc. All rights reserved.
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
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library xilinxcorelib;
use xilinxcorelib.floating_point_v6_0_consts.all;

library xilinxcorelib;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

library xilinxcorelib;
use xilinxcorelib.axi_utils_pkg_v1_1.all;

library xilinxcorelib;
use xilinxcorelib.mult_gen_pkg_v11_2.all;

package floating_point_pkg_v6_0 is

  -- String length sufficient to store all C_XDEVICEFAMILY values
  -- The value here is the same as the value used in xilinxcorelib for supports_*() functions
  -- 'empty_string' is a string constant of the required length, defined in bip_utils_pkg_v2_0
  constant FLT_PT_FAMILY_STR_LENGTH : integer := empty_string'length;

  -- Record to store the values of all generics.
  -- This record is populated at the floating_point_v6_0_xst level and passed to all modules in the core.
  -- Use of this record rather than separate generics makes adding generics much easier in the future.
  -- Don't store C_XDEVICEFAMILY here, as unconstrained strings cannot be put in a record.
  type generics_type is
  record
    c_has_add               : integer;  -- Add operation: 1=yes, 0=no
    c_has_subtract          : integer;  -- Subtract operation: 1=yes, 0=no
    c_has_multiply          : integer;  -- Multiply operation: 1=yes, 0=no
    c_has_divide            : integer;  -- Divide operation: 1=yes, 0=no
    c_has_sqrt              : integer;  -- Square root operation: 1=yes, 0=no
    c_has_compare           : integer;  -- Compare operation: 1=yes, 0=no
    c_has_fix_to_flt        : integer;  -- Fixed to float operation: 1=yes, 0=no
    c_has_flt_to_fix        : integer;  -- Float to fixed operation: 1=yes, 0=no
    c_has_flt_to_flt        : integer;  -- Float to float operation: 1=yes, 0=no
    c_has_recip             : integer;  -- Reciprocal operation: 1=yes, 0=no
    c_a_width               : integer;  -- Total bit width of A operand
    c_a_fraction_width      : integer;  -- Bit width of fractional part of A operand
    c_b_width               : integer;  -- Total bit width of B operand
    c_b_fraction_width      : integer;  -- Bit width of fractional part of B operand
    c_result_width          : integer;  -- Total bit width of result
    c_result_fraction_width : integer;  -- Bit width of fractional part of result
    c_compare_operation     : integer;  -- Comparison: 0? 1< 2= 3<= 4> 5<> 6>= 7condcode 8prog
    c_latency               : integer;  -- Latency: specify cyles, or 1000 for fully-pipelined
    c_optimization          : integer;  -- 1=optimize for speed, 2=optimize for low latency
    c_mult_usage            : integer;  -- Level of DSP48 usage: 0=none, 1=medium, 2=full, 3=max
    c_rate                  : integer;  -- Cycles per operation (divide and square root only)
    c_has_underflow         : integer;  -- Underflow exception output: 1=yes, 0=no
    c_has_overflow          : integer;  -- Overflow exception output: 1=yes, 0=no
    c_has_invalid_op        : integer;  -- Invalid operation exception output: 1=yes, 0=no
    c_has_divide_by_zero    : integer;  -- Divide by zero exception output: 1=yes, 0=no
    c_has_aclken            : integer;  -- Clock enable input: 1=yes, 0=no
    c_has_aresetn           : integer;  -- Synchronous reset input: 1=yes, 0=no
    c_throttle_scheme       : integer;  -- AXI handshaking: 1=CE, 2=RFD, 3=GEN, 4=AND_TVALID
    c_has_a_tuser           : integer;  -- A channel has TUSER signal: 1=yes, 0=no
    c_has_a_tlast           : integer;  -- A channel has TLAST signal: 1=yes, 0=no
    c_has_b                 : integer;  -- B channel present: 1=yes, 0=no
    c_has_b_tuser           : integer;  -- B channel has TUSER signal: 1=yes, 0=no
    c_has_b_tlast           : integer;  -- B channel has TLAST signal: 1=yes, 0=no
    c_has_operation         : integer;  -- OPERATION channel present: 1=yes, 0=no
    c_has_operation_tuser   : integer;  -- OPERATION channel has TUSER signal: 1=yes, 0=no
    c_has_operation_tlast   : integer;  -- OPERATION channel has TLAST signal: 1=yes, 0=no
    c_has_result_tuser      : integer;  -- RESULT channel has TUSER signal: 1=yes, 0=no
    c_has_result_tlast      : integer;  -- RESULT channel has TLAST signal: 1=yes, 0=no
    c_tlast_resolution      : integer;  -- RESULT TLAST value: 1=A, 2=B, 3=OPERATION, 16=AND, 17=OR
    c_a_tdata_width         : integer;  -- Bit width of A TDATA signal: byte_roundup(C_A_WIDTH)
    c_a_tuser_width         : integer;  -- Bit width of A TUSER signal (if present): range 1-256
    c_b_tdata_width         : integer;  -- Bit width of B TDATA signal: byte_roundup(C_B_WIDTH)
    c_b_tuser_width         : integer;  -- Bit width of B TUSER signal (if present): range 1-256
    c_operation_tdata_width : integer;  -- Bit width of OPERATION TDATA signal: must be 8
    c_operation_tuser_width : integer;  -- Bit width of OPERATION TUSER signal (if present): range 1-256
    c_result_tdata_width    : integer;  -- Bit width of RESULT TDATA signal: byte_roundup(C_RESULT_WIDTH)
    c_result_tuser_width    : integer;  -- Bit width of RESULT TUSER signal (if present): range 1-772
  end record;

  -- Default values of generics, in the generics_type record
  -- Default values are defined in floating_point_v6_0_consts package
  constant GENERICS_TYPE_DEFAULT : generics_type := (
    c_has_add               => C_HAS_ADD_DEFAULT,
    c_has_subtract          => C_HAS_SUBTRACT_DEFAULT,
    c_has_multiply          => C_HAS_MULTIPLY_DEFAULT,
    c_has_divide            => C_HAS_DIVIDE_DEFAULT,
    c_has_sqrt              => C_HAS_SQRT_DEFAULT,
    c_has_compare           => C_HAS_COMPARE_DEFAULT,
    c_has_fix_to_flt        => C_HAS_FIX_TO_FLT_DEFAULT,
    c_has_flt_to_fix        => C_HAS_FLT_TO_FIX_DEFAULT,
    c_has_flt_to_flt        => C_HAS_FLT_TO_FLT_DEFAULT,
    c_has_recip             => C_HAS_RECIP_DEFAULT,
    c_a_width               => C_A_WIDTH_DEFAULT,
    c_a_fraction_width      => C_A_FRACTION_WIDTH_DEFAULT,
    c_b_width               => C_B_WIDTH_DEFAULT,
    c_b_fraction_width      => C_B_FRACTION_WIDTH_DEFAULT,
    c_result_width          => C_RESULT_WIDTH_DEFAULT,
    c_result_fraction_width => C_RESULT_FRACTION_WIDTH_DEFAULT,
    c_compare_operation     => C_COMPARE_OPERATION_DEFAULT,
    c_latency               => C_LATENCY_DEFAULT,
    c_optimization          => C_OPTIMIZATION_DEFAULT,
    c_mult_usage            => C_MULT_USAGE_DEFAULT,
    c_rate                  => C_RATE_DEFAULT,
    c_has_underflow         => C_HAS_UNDERFLOW_DEFAULT,
    c_has_overflow          => C_HAS_OVERFLOW_DEFAULT,
    c_has_invalid_op        => C_HAS_INVALID_OP_DEFAULT,
    c_has_divide_by_zero    => C_HAS_DIVIDE_BY_ZERO_DEFAULT,
    c_has_aclken            => C_HAS_ACLKEN_DEFAULT,
    c_has_aresetn           => C_HAS_ARESETN_DEFAULT,
    c_throttle_scheme       => C_THROTTLE_SCHEME_DEFAULT,
    c_has_a_tuser           => C_HAS_A_TUSER_DEFAULT,
    c_has_a_tlast           => C_HAS_A_TLAST_DEFAULT,
    c_has_b                 => C_HAS_B_DEFAULT,
    c_has_b_tuser           => C_HAS_B_TUSER_DEFAULT,
    c_has_b_tlast           => C_HAS_B_TLAST_DEFAULT,
    c_has_operation         => C_HAS_OPERATION_DEFAULT,
    c_has_operation_tuser   => C_HAS_OPERATION_TUSER_DEFAULT,
    c_has_operation_tlast   => C_HAS_OPERATION_TLAST_DEFAULT,
    c_has_result_tuser      => C_HAS_RESULT_TUSER_DEFAULT,
    c_has_result_tlast      => C_HAS_RESULT_TLAST_DEFAULT,
    c_tlast_resolution      => C_TLAST_RESOLUTION_DEFAULT,
    c_a_tdata_width         => C_A_TDATA_WIDTH_DEFAULT,
    c_a_tuser_width         => C_A_TUSER_WIDTH_DEFAULT,
    c_b_tdata_width         => C_B_TDATA_WIDTH_DEFAULT,
    c_b_tuser_width         => C_B_TUSER_WIDTH_DEFAULT,
    c_operation_tdata_width => C_OPERATION_TDATA_WIDTH_DEFAULT,
    c_operation_tuser_width => C_OPERATION_TUSER_WIDTH_DEFAULT,
    c_result_tdata_width    => C_RESULT_TDATA_WIDTH_DEFAULT,
    c_result_tuser_width    => C_RESULT_TUSER_WIDTH_DEFAULT
    );

  -- Floating-point exponent width limits
  constant FLT_PT_MIN_EW : integer := 4;
  constant FLT_PT_MAX_EW : integer := 16;
  -- Floating-point fraction width limits
  constant FLT_PT_MIN_FW : integer := 4;
  constant FLT_PT_MAX_FW : integer := 64;
  -- Fixed-point width limits
  constant FIX_PT_MIN_W  : integer := 4;
  constant FIX_PT_MAX_W  : integer := 64;
  -- Fixed-point fraction width limits
  constant FIX_PT_MIN_FW : integer := 0;
  constant FIX_PT_MAX_FW : integer := 64;
  -- Fixed-point integer width limits (including sign)
  constant FIX_PT_MIN_IW : integer := 1;
  constant FIX_PT_MAX_IW : integer := 63;

  -- Widths of vectors which are concatenated as required
  constant SIGN_BIT_WIDTH   : integer := 1;
  constant HIDDEN_BIT_WIDTH : integer := 1;


  -- Add FLT_PT_LATENCY_BIAS to latency to indicate that latency
  -- provides a bit pattern for enabling specific registers.
  -- e.g. C_LATENCY = FLT_PT_LATENCY_BIAS + 30 provides a pattern
  -- "11110", and so will switch off first register
  -- and enable the next 4. The total latency will be 4.
  -- Bits over-and-above the maximum latency are discarded.
  -- Note that this is not a customer supported feature
  constant FLT_PT_LATENCY_BIAS : integer := 1000000000;

  -- Local integer array type definition
  type int_array is array (natural range <>) of integer;

  -- Types to support pipeline delay calculation
  constant FLT_PT_REG_LEN     : integer         := 200;
  type flt_pt_reg_type is array(0 to FLT_PT_REG_LEN-1) of boolean;
  constant FLT_PT_REG_DEFAULT : flt_pt_reg_type := (others => true);
  constant FLT_PT_REG_FALSE   : flt_pt_reg_type := (others => false);

  -- Vectors of ones and zeros
  constant FLT_PT_ONE  : std_logic_vector(FLT_PT_MAX_W-1 downto 0) := (others => '1');
  constant FLT_PT_ZERO : std_logic_vector(FLT_PT_MAX_W-1 downto 0) := (others => '0');

  -- Maximum internal carry chain length
  constant FLT_PT_CARRY_LENGTH : integer := 17;

  -- Types of implementation: logic or DSP48-based
  type flt_pt_imp_type is (FLT_PT_IMP_LOGIC,
                           FLT_PT_IMP_DSP48
                           );

  -- Fixed-point multiplier types
  type flt_pt_fix_mult_type is (FLT_PT_FIX_MULT_GEN,  -- Xilinx mult_gen_v11_2
                                FLT_PT_FIX_MULT_QQ,   -- QinetiQ multiplier
                                FLT_PT_FIX_MULT_DSP48E1_LAT_DBL,  -- Low latency double
                                FLT_PT_FIX_MULT_DSP48E1_SPD_DBL,  -- Speed-optimized double
                                FLT_PT_FIX_MULT_DSP48E1_SPD_SGL  -- Speed-optimized single
                                );

  -- Floating point multiplier types
  type flt_pt_mult_type is (FLT_PT_MULT_LOGIC,    -- Logic only
                            FLT_PT_MULT_DSP48A1,  -- DSP48A1 based
                            FLT_PT_MULT_DSP48E1,  -- DSP48E1 based, general case
                            FLT_PT_MULT_DSP48E1_SPD_SGL,  -- DSP48E1 based, speed-optimized single
                            FLT_PT_MULT_DSP48E1_SPD_DBL,  -- DSP48E1 based, speed-optimized double
                            FLT_PT_MULT_DSP48E1_LAT_SGL,  -- DSP48E1 based, low latency single
                            FLT_PT_MULT_DSP48E1_LAT_DBL  -- DSP48E1 based, low latency double
                            );

  -- Fixed point multadd types
  type flt_pt_fix_multadd_type is (FLT_PT_FIX_MULTADD_FABRIC,  -- LUTs only
                                   FLT_PT_FIX_MULTADD_DSP_LS_ADDER,  -- Use LS DSP's adder
                                   FLT_PT_FIX_MULTADD_DSP_EXTRA_DSP_ADDER,  -- Extra DSP on top to complete add
                                   FLT_PT_FIX_MULTADD_DSP_EXTRA_FABRIC_ADDER  -- Additional fabric adder needed to complete sum
                                   );

  -- Alignment component descriptor
  type alignment_type is
  record
    ip_width       : integer;           -- input width
    det_width      : integer;           -- zero detection width
    op_width       : integer;           -- output width
    shift_width    : integer;           -- shift distance width
    zero_det_width : integer;           -- zero detect shift width
    zero_det_stage : integer;           -- stages in zero detection
    shift_stage    : integer;           -- stages in aligment shift
    last_stage     : integer;           -- number of stages removed
    last_bits      : integer;           -- number of bits removed
    stage          : integer;           -- number of stages remaining
    stage_mask     : flt_pt_reg_type;   -- enable/disable registers
  end record;

  -- Normalize component descriptor
  type normalize_type is
  record
    norm_stage : integer;               -- stages to result and dist
    last_bits  : integer;               -- number of bits in last stage
    last_stage : integer;               -- is extra 1-bit shift required?
    can_stage  : integer;               -- stages to cancellation output
  end record;

  -- Renorm and round component descriptor
  type round_type is
  record
    imp_type  : flt_pt_imp_type;  -- Implementation type: logic or DSP48-based
    stages    : integer;                -- Number of pipelining stages
    norm_bits : integer;  -- Supported normalization distance (in bits)
    exp_stage : integer;                -- Stage that exponent should be input
    legacy    : boolean;                -- No pipelining
    optimized : boolean;                -- Use PCOUT cascade
    top_width : integer;                -- Width of part coming from cascade
    extra_cut : boolean;  -- Includes an extra cut in certain optimized variants
  end record;

  -- Fixed-point multiplier component descriptor
  type fix_mult_type is
  record
    variant     : flt_pt_fix_mult_type;  -- Major multiplier variant
    qq_imp_type : integer;  -- Implementation type for QinetiQ multiplier
    xx_imp_type : flt_pt_imp_type;  -- Implementation type for Xilinx mult_gen_v11_2 multiplier
    stages      : integer;              -- Number of pipelining stages
    op_reg      : boolean;  -- Whether a register should be placed on fixed-point multiplier output
    cascade     : boolean;  -- Specifies whether the multipler supports cascaded output
  end record;

  -- Floating-point multiplier component descriptor
  type flt_mult_type is
  record
    stages          : integer;          -- Total number of pipelining stages
    fix_mult_config : fix_mult_type;  -- Fixed-point multiplier component configuration
    exp_op_stage    : integer;  -- Stage at which exponent component should output exponent
    exp_speed       : integer;          -- Speed setting for exponent logic
    round_config    : round_type;       -- Round component configuration
  end record;

  -- Floating-point adder component descriptor
  type flt_add_type is
  record
    ab_extw            : integer;  -- low_latency: extended wordlength for low-latency variant
    last_stage         : integer;  -- low_latency: whether there is a last stage
    last_bits          : integer;  -- low_latency: number of bits implemented by last norm stage
    mux_stage          : integer;       -- input multplexing stage
    align_stage        : integer;       -- stage at which alignment starts
    align_add_op_stage : integer;  -- low-latency: stage for output of align_add
    add_stage          : integer;  -- stage at which addition/subtraction is performed
    norm_op_stage      : integer;  -- low-latency: stage for output of normalization
    lod_stage          : integer;  -- stage at which leading-one detect performed
    dist_stage         : integer;  -- stage at which normalize distance is available
    can_stage          : integer;       -- cancellation stage
    sel_stage          : integer;       -- low-latency variant
    sig_stage          : integer;       -- determine overflow signals
    sig_up_stage       : integer;       -- update
    pre_op_stage       : integer;       -- stage prior to output
    rnd_stage          : integer;       -- round input stage
    exp_stage          : integer;       -- exponent output from exp logic
    op_stage           : integer;       -- output
    stages             : integer;
    round_config       : round_type;
    round_usage        : integer;
    addsub_usage       : integer;
  end record;

  -- Some default component descriptors
  constant ROUND_DEFAULT : round_type := (
    imp_type  => FLT_PT_IMP_LOGIC,
    stages    => 0,
    norm_bits => 0,
    exp_stage => 0,
    legacy    => false,
    optimized => false,
    top_width => 0,
    extra_cut => false
    );

  constant FIX_MULT_DEFAULT : fix_mult_type := (
    variant     => FLT_PT_FIX_MULT_GEN,
    qq_imp_type => 0,
    xx_imp_type => FLT_PT_IMP_LOGIC,
    stages      => 0,
    op_reg      => false,
    cascade     => false
    );

  constant FLT_PT_MULT_TYPE_DEFAULT : flt_mult_type := (
    stages          => 0,
    fix_mult_config => FIX_MULT_DEFAULT,
    exp_op_stage    => 0,
    exp_speed       => 0,
    round_config    => ROUND_DEFAULT
    );

  constant FLT_ADD_DEFAULT : flt_add_type := (
    ab_extw            => 0,
    last_stage         => 0,
    last_bits          => 0,
    mux_stage          => 0,
    align_stage        => 0,
    align_add_op_stage => 0,
    add_stage          => 0,
    norm_op_stage      => 0,
    lod_stage          => 0,
    dist_stage         => 0,
    can_stage          => 0,
    sel_stage          => 0,
    sig_stage          => 0,
    sig_up_stage       => 0,
    pre_op_stage       => 0,
    rnd_stage          => 0,
    exp_stage          => 0,
    op_stage           => 0,
    stages             => 0,
    round_config       => ROUND_DEFAULT,
    round_usage        => 0,
    addsub_usage       => 0
    );

  --------------------------------------------------------------------------------
  -- Functions to provide information about floating-point operator core
  --------------------------------------------------------------------------------
  -- The following function can be used to determine the latency of an operation
  -- for a given set of generics. Use default values where appropriate.
  -- Parameters width and fraction_width should be set to the common value used
  -- on inputs and outputs. If 'required' have value other than default, then
  -- function will return that value.
  --------------------------------------------------------------------------------
  function flt_pt_delay(family                : string;
                        op_code               : std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
                        a_width               : integer;
                        a_fraction_width      : integer;
                        b_width               : integer;
                        b_fraction_width      : integer;
                        result_width          : integer;
                        result_fraction_width : integer;
                        optimization          : integer;
                        mult_usage            : integer;
                        rate                  : integer;
                        throttle_scheme       : integer;
                        has_add               : integer := 0;
                        has_subtract          : integer := 0;
                        has_multiply          : integer := 0;
                        has_divide            : integer := 0;
                        has_sqrt              : integer := 0;
                        has_compare           : integer := 0;
                        has_fix_to_flt        : integer := 0;
                        has_flt_to_fix        : integer := 0;
                        has_flt_to_flt        : integer := 0;
                        has_recip             : integer := 0;
                        has_recip_sqrt        : integer := 0;
                        required              : integer := FLT_PT_MAX_LATENCY
                        )
    return integer;

  -- Provide number of operations for given set of switches
  function flt_pt_number_of_operations(C_HAS_ADD, C_HAS_SUBTRACT,
                                       C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
                                       C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX,
                                       C_HAS_FLT_TO_FLT, C_HAS_RECIP, C_HAS_RECIP_SQRT : integer) return integer;

  -- Determines number of inputs required to support requested operations
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
                                   C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
                                   C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX,
                                   C_HAS_FLT_TO_FLT : integer) return integer;

  -- Determines number of inputs based upon op_code
  function flt_pt_number_of_inputs(op_code : integer) return integer;

  -- Provides op_code from switches (only one should be enabled!)
  function flt_pt_get_op_code(C_HAS_ADD, C_HAS_SUBTRACT, C_HAS_MULTIPLY,
                              C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE, C_HAS_FIX_TO_FLT,
                              C_HAS_FLT_TO_FIX, C_HAS_FLT_TO_FLT, C_HAS_RECIP, C_HAS_RECIP_SQRT : integer) return std_logic_vector;

  -- Determines if operation is add or subtract from switches
  function flt_pt_has_add_or_subtract(C_HAS_ADD, C_HAS_SUBTRACT : integer) return integer;

  -- Extracts add/subtract signal from operation
  function flt_pt_get_addsub_op(operation : std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0))
    return std_logic;

  -- Extracts compare operation from operation
  function flt_pt_get_compare_op(operation : std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0))
    return std_logic_vector;

  --------------------------------------------------------------------------------
  -- The following functions are for internal use only, and should not be called
  -- directly.
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  -- Basic utility functions
  --------------------------------------------------------------------------------
  -- Determine the number of bits needed to represent a number
  -- i.e. if x = 8, then function returns 4
  function flt_pt_get_n_bits(x        : integer) return integer;
  function flt_pt_get_n_bits_signed(x : integer) return integer;
  -- Max/min functions
  function flt_pt_max(x, y            : integer) return integer;
  function flt_pt_min(x, y            : integer) return integer;
  -- Convert boolean to std_logic
  function conv_bool_to_sl(b          : boolean) return std_logic;
  -- Converts unsigned integer into 3-bit standard logic vector
  -- Throws and error if w not equal to 3
  function conv_int_to_slv_3(a, w     : integer) return std_logic_vector;

  --------------------------------------------------------------------------------
  -- Functions for detecting family characteristics
  --------------------------------------------------------------------------------
  -- Determines which families are fast (logic, relative to route)
  function flt_pt_fast_family(xdevicefamily : string) return integer;

  --------------------------------------------------------------------------------
  -- Functions used for checking individual parameters
  --------------------------------------------------------------------------------
  -- Minimum width of exponent field
  function flt_pt_get_min_exp(fw              : integer) return integer;
  -- Check that a floating point exponent is large enough to handle a fixed point data format
  function flt_pt_exp_check(flt_w, flt_fw, fw : integer) return boolean;
  -- Check fixed and floating point data formats are compatible for conversion
  function fixed_pt_exp_check(flt_w, flt_fw, fix_w, fix_fw : integer;
                              flt_name, fix_name           : string) return boolean;
  -- Check floating point data format
  function flt_pt_check(w, fw           : integer; flt_name : string) return boolean;
  -- Check fixed point data format
  function fixed_pt_check(fix_w, fix_fw : integer; fix_name : string) return boolean;

  --------------------------------------------------------------------------------
  -- Parameter check function: returns generics in generics_type record
  --------------------------------------------------------------------------------
  function floating_point_v6_0_check_generics(
    C_XDEVICEFAMILY         : string;
    C_HAS_ADD               : integer;
    C_HAS_SUBTRACT          : integer;
    C_HAS_MULTIPLY          : integer;
    C_HAS_DIVIDE            : integer;
    C_HAS_SQRT              : integer;
    C_HAS_COMPARE           : integer;
    C_HAS_FIX_TO_FLT        : integer;
    C_HAS_FLT_TO_FIX        : integer;
    C_HAS_FLT_TO_FLT        : integer;
    C_HAS_RECIP             : integer;
    C_HAS_RECIP_SQRT        : integer;
    C_A_WIDTH               : integer;
    C_A_FRACTION_WIDTH      : integer;
    C_B_WIDTH               : integer;
    C_B_FRACTION_WIDTH      : integer;
    C_RESULT_WIDTH          : integer;
    C_RESULT_FRACTION_WIDTH : integer;
    C_COMPARE_OPERATION     : integer;
    C_LATENCY               : integer;
    C_OPTIMIZATION          : integer;
    C_MULT_USAGE            : integer;
    C_RATE                  : integer;
    C_HAS_UNDERFLOW         : integer;
    C_HAS_OVERFLOW          : integer;
    C_HAS_INVALID_OP        : integer;
    C_HAS_DIVIDE_BY_ZERO    : integer;
    C_HAS_ACLKEN            : integer;
    C_HAS_ARESETN           : integer;
    C_THROTTLE_SCHEME       : integer;
    C_HAS_A_TUSER           : integer;
    C_HAS_A_TLAST           : integer;
    C_HAS_B                 : integer;
    C_HAS_B_TUSER           : integer;
    C_HAS_B_TLAST           : integer;
    C_HAS_OPERATION         : integer;
    C_HAS_OPERATION_TUSER   : integer;
    C_HAS_OPERATION_TLAST   : integer;
    C_HAS_RESULT_TUSER      : integer;
    C_HAS_RESULT_TLAST      : integer;
    C_TLAST_RESOLUTION      : integer;
    C_A_TDATA_WIDTH         : integer;
    C_A_TUSER_WIDTH         : integer;
    C_B_TDATA_WIDTH         : integer;
    C_B_TUSER_WIDTH         : integer;
    C_OPERATION_TDATA_WIDTH : integer;
    C_OPERATION_TUSER_WIDTH : integer;
    C_RESULT_TDATA_WIDTH    : integer;
    C_RESULT_TUSER_WIDTH    : integer
    ) return generics_type;

  --------------------------------------------------------------------------------
  -- Functions to manage components
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  -- renorm_and_round component helper functions
  --------------------------------------------------------------------------------

  -- Provides fully pipelined delay of component
  function flt_pt_get_renorm_and_round_delay(config : round_type; fw : integer)
    return integer;

  -- Provides the number of bits of normalization supported
  -- prior to rounding (provided in terms of binary
  -- distance i.e. 2-bits would support a shift of 0 to 3 bits)
  function flt_pt_get_renorm_and_round_norm_bits(imp_type : flt_pt_imp_type) return integer;

  -- Provides configuration descriptor for component
  function flt_pt_get_renorm_and_round(has_multiply,
                                       has_addsub   : integer := FLT_PT_NO;
                                       optimization : integer;
                                       family       : string;
                                       mult_usage,
                                       w, fw        : integer) return round_type;

  --------------------------------------------------------------------------------
  -- addsub component helper functions
  --------------------------------------------------------------------------------

  -- Determines the type of the component
  function flt_pt_get_addsub_type(mult_usage : integer) return flt_pt_imp_type;

  -- Determines fully pipelined delay of component
  function flt_pt_get_addsub_delay(mult_usage, width : integer) return integer;

  -- Determines number of shift bits that addsub can handle
  function flt_pt_get_addsub_bits(family : string) return integer;

  -- Determines number of shift bits that a multiplexer can handle
  -- (i.e. LUT6 can both multiplex and shift by 1 bit)
  function flt_pt_get_addmux_bits(family : string) return integer;

  -- Determines number of bits of shift required for particular configuration of
  -- shifter
  function flt_pt_get_shift_msb_first_bits(
    a_width, result_width, last_bits_to_omit : integer;
    left                                     : boolean) return integer;

  -- Supplies the number of stages required by the zero_det component for given generics
  function flt_pt_get_zero_det_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;

  -- Supplies the number of stages required by the shift component for given generics
  function flt_pt_get_shift_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer;

  -- Provides fully pipelined delay of align component
  function flt_pt_get_align_delay(ip_width,
                                  op_width : integer) return integer;

  -- Provides fully pipelined delay of normalization component
  function flt_pt_get_normalization_delay(in_width : integer) return integer;

  -- Provides descriptor for alignment component
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer;
                                poss_last_bits                : integer := 0) return alignment_type;

  -- Provides descriptor for normalize component
  function flt_pt_get_normalize(data_width     : integer;
                                poss_last_bits : integer := 1) return normalize_type;

  --------------------------------------------------------------------------------
  -- Fixed-point multiplier
  --------------------------------------------------------------------------------

  -- Purpose: Selects a fixed-point multiplier
  function flt_pt_get_fix_mult(family            : string; optimization,
                               mult_usage, w, fw : integer) return fix_mult_type;

  -- Determines when to use the different fixed-point multiplier variants
  function flt_pt_get_fix_mult_variant(family                          : string;
                                       optimization, mult_usage, w, fw : integer)
    return flt_pt_fix_mult_type;

  -- Determines the number of bits from cascade output of fixed-point multiplier
  function flt_pt_get_fix_mult_top_width(fw : integer; family : string) return integer;

  -- Provides the delay for the fixed-point multiplier
  function flt_pt_get_fix_mult_delay(w, fw                    : integer;
                                     family                   : string;
                                     optimization, mult_usage : integer) return integer;

  -- Provides the implementation type for the QinetiQ multiplier variant
  function flt_pt_get_xmult_type(fw         : integer;
                                 family     : string;
                                 mult_usage : integer)
    return integer;

  -- Provides the implementation type for the Xilinx fixed-point
  -- multiplier (mult_gen_v11_2) variant
  function flt_pt_get_mult_gen_imp_type(mult_usage : integer)
    return flt_pt_imp_type;

  --------------------------------------------------------------------------------
  -- Floating-point add/subtract
  --------------------------------------------------------------------------------
  -- Provides configuration of floating-point adder-subtracter
  function flt_pt_get_flt_add(
    C_XDEVICEFAMILY    : string;
    C_MULT_USAGE       : integer;
    C_HAS_ADD          : integer;
    C_HAS_SUBTRACT     : integer;
    C_HAS_FIX_TO_FLT   : integer;
    C_HAS_FLT_TO_FIX   : integer;
    C_A_WIDTH          : integer;
    C_A_FRACTION_WIDTH : integer)
    return flt_add_type;

  -- Type of floating-point add/subtract operator
  function flt_pt_get_add_type(family : string; mult_usage, w, fw : integer)
    return flt_pt_imp_type;

  -- Fully pipelined delay of floating-point add/subtract operator
  function flt_pt_get_add_delay(family            : string;
                                mult_usage, w, fw : integer) return integer;

  --------------------------------------------------------------------------------
  -- Floating-point multiplier
  --------------------------------------------------------------------------------
  -- Provides configuration of floating-point multiplier
  function flt_pt_get_mult_type(family                          : string;
                                optimization, mult_usage, w, fw : integer)
    return flt_pt_mult_type;

  -- Provides fully pipelined delay of floating-point multiplier
  function flt_pt_get_flt_mult_delay(width, fraction_width : integer;
                                     family                : string; optimization, mult_usage : integer) return integer;

  -- Describes a floating-point multiplier
  function flt_pt_get_mult(
    family       : string;
    optimization : integer;
    mult_usage   : integer;
    w            : integer;
    fw           : integer) return flt_mult_type;

  --------------------------------------------------------------------------------
  -- Helper functions for other FP operations
  --------------------------------------------------------------------------------
  -- Provides fully pipelined delay of floating-point divider
  function flt_pt_get_div_delay(w, fw : integer) return integer;

  -- Provides fully pipelined delay of floating-point square-root
  function flt_pt_get_sqrt_delay(w, fw : integer) return integer;

  -- Provides fully pipelined delay of floating-point to fixed-point converter
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width,
                                   result_width, result_fraction_width : integer) return integer;

  -- Provides fully pipelined delay of fixed-point to floating-point converter
  function flt_pt_fix_to_flt_delay(a_width, version : integer) return integer;

  -- Provides fully pipelined delay of floating-point to floating-point converter
  function flt_pt_flt_to_flt_delay(a_width, a_fraction_width,
                                   result_width, result_fraction_width : integer) return integer;

  function flt_pt_get_multadd_structure (
    c_xdevicefamily : string;
    c_mult_usage    : integer;
    a_width         : integer;
    b_width         : integer;
    c_width         : integer)
    return flt_pt_fix_multadd_type;

  function flt_pt_fix_multadd_delay (
    c_xdevicefamily : string;
    c_mult_usage    : integer;
    a_width         : integer;
    b_width         : integer;
    c_width         : integer;
    use_preadder    : boolean)
    return integer;

  function flt_pt_is_single_precision (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return boolean;

  function flt_pt_is_double_precision (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return boolean;

  function flt_pt_recip_w (
    c_a_fraction_width : integer)
    return integer;

  function flt_pt_recip_k (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_m (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return integer;

  function flt_pt_recip_m_width (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_sqrt_delay_adjust (
    c_operation : integer)
    return integer;

  function flt_pt_recip_postprocessing_plus_one_alignment (
    C_OPERATION : integer;
    K           : integer;
    M_WIDTH     : integer)
    return integer;

  function flt_pt_recip_postprocessing_add_data_width (
    C_OPERATION        : integer;
    M_INT_WIDTH        : integer;
    RC_A_WIDTH         : integer;
    RC_B_WIDTH         : integer;
    PLUS_ONE_ALIGNMENT : integer)
    return integer;

  function flt_pt_recip_calc_rom_entry (
    i, m, rom_output_width : integer)
    return std_logic_vector;

  function flt_pt_recip_approx_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_nr_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  type FLT_PT_RECIP_M_CALC_WIDTHS is record
    -- NR stage 1
    NR1_M1_A_WIDTH : integer;
    NR1_M1_B_WIDTH : integer;
    NR1_M1_C_WIDTH : integer;
    NR1_M2_A_WIDTH : integer;
    NR1_M2_B_WIDTH : integer;
    NR1_M2_C_WIDTH : integer;
    NR1_M3_A_WIDTH : integer;
    NR1_M3_B_WIDTH : integer;
    NR1_M3_C_WIDTH : integer;

    -- NR stage 2
    NR2_M1_A_WIDTH : integer;
    NR2_M1_B_WIDTH : integer;
    NR2_M1_C_WIDTH : integer;
    NR2_M2_A_WIDTH : integer;
    NR2_M2_B_WIDTH : integer;
    NR2_M2_C_WIDTH : integer;
    NR2_M3_A_WIDTH : integer;
    NR2_M3_B_WIDTH : integer;
    NR2_M3_C_WIDTH : integer;

    -- NR stage 3
    NR3_M1_A_WIDTH : integer;
    NR3_M1_B_WIDTH : integer;
    NR3_M1_C_WIDTH : integer;
    NR3_M2_A_WIDTH : integer;
    NR3_M2_B_WIDTH : integer;
    NR3_M2_C_WIDTH : integer;
    NR3_M3_A_WIDTH : integer;
    NR3_M3_B_WIDTH : integer;
    NR3_M3_C_WIDTH : integer;

    -- Sqrt recovery
    SQRT_A_WIDTH : integer;
    SQRT_B_WIDTH : integer;
    SQRT_C_WIDTH : integer;

    -- Compensation
    CORRECTION_A_WIDTH : integer;
    CORRECTION_B_WIDTH : integer;
    CORRECTION_C_WIDTH : integer;
  end record FLT_PT_RECIP_M_CALC_WIDTHS;

  function flt_pt_recipsqrt_r_msbs_width(
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  function flt_pt_recipsqrt_r_initial_est_width(
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_init_m_calc_width_rcd (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return FLT_PT_RECIP_M_CALC_WIDTHS;

  function flt_pt_recip_m_calc_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_reduction_calc_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_evaluation_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_postprocessing_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer;

  function flt_pt_recip_recombination_delay (
    c_operation : integer)
    return integer;

  -- Provides fully pipelined delay of floating-point reciprocal
  function flt_pt_get_recip_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer;


  -- Provides latency for the calculation of a particular operation
  -- This is the latency of the core excluding latency incurred by AXI flow control
  function flt_pt_calc_delay(family                : string;
                             op_code               : std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
                             a_width               : integer;
                             a_fraction_width      : integer;
                             b_width               : integer;
                             b_fraction_width      : integer;
                             result_width          : integer;
                             result_fraction_width : integer;
                             optimization          : integer;
                             mult_usage            : integer;
                             rate                  : integer;
                             throttle_scheme       : integer;
                             has_add               : integer := 0;
                             has_subtract          : integer := 0;
                             has_multiply          : integer := 0;
                             has_divide            : integer := 0;
                             has_sqrt              : integer := 0;
                             has_compare           : integer := 0;
                             has_fix_to_flt        : integer := 0;
                             has_flt_to_fix        : integer := 0;
                             has_flt_to_flt        : integer := 0;
                             has_recip             : integer := 0;
                             has_recip_sqrt        : integer := 0;
                             required              : integer := FLT_PT_MAX_LATENCY
                             ) return integer;

  -- Provide latency incurred by AXI flow control
  function flt_pt_axi_ctrl_delay(c_throttle_scheme : integer) return integer;

  --------------------------------------------------------------------------------
  -- Functions to test  and get special fixed and float values
  --------------------------------------------------------------------------------
  -- Tests for a signalling NaN or quiet NaN as defined by this implementation
  -- Note that sign is excluded
  function flt_pt_is_nan(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for a signalling NaN as defined by this implementation
  -- Note that sign is excluded
  function flt_pt_is_signalling_nan(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for a quiet NaN as defined by this implementation
  function flt_pt_is_quiet_nan(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for positive or negative zero
  function flt_pt_is_zero(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for positive or negative infinity
  function flt_pt_is_inf(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for a denormalized number
  function flt_pt_is_denormalized(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Tests for positive or negative one
  function flt_pt_is_one(w, fw : integer; value : std_logic_vector)
    return boolean;

  -- Gets a quiet NaN as defined by this implementation
  function flt_pt_get_quiet_nan(w, fw : integer) return std_logic_vector;

  -- Gets a signalling NaN as defined by this implementation
  function flt_pt_get_signalling_nan(w, fw : integer) return std_logic_vector;

  -- Gets a signed zero
  function flt_pt_get_zero(w, fw : integer; sign : std_logic)
    return std_logic_vector;

  -- Gets a signed infinity
  function flt_pt_get_inf(w, fw : integer; sign : std_logic)
    return std_logic_vector;

  -- Gets the most negative fixed-point number
  function flt_pt_get_most_negative_fix(w : integer) return std_logic_vector;

  -- Gets the most positive fixed-point number
  function flt_pt_get_most_positive_fix(w : integer) return std_logic_vector;

  -- Determines delay provided by a particular register pattern
  function get_reg_delay(reg : flt_pt_reg_type; start, length : integer)
    return integer;

  -- Generates an integer representation of the register pattern ("100" = 4)
  function get_reg_delay_pat(reg : flt_pt_reg_type; start, length : integer)
    return integer;

  -- Slices off a particular section of register pattern starting at 'start'
  function get_reg_blk(reg : flt_pt_reg_type; start : integer)
    return flt_pt_reg_type;

  -- Converts a reg type to an array of integers (1=true, 0=false)
  function conv_reg_to_reg_int(reg : flt_pt_reg_type) return int_array;

  -- Mask register pattern with supplied mask (keep bit when mask bit is true)
  function mask_reg(reg_in, stage_mask : flt_pt_reg_type) return flt_pt_reg_type;

  function get_registers(a_width, a_fraction_width, b_width, b_fraction_width,
                         result_width, result_fraction_width, req_latency, max_latency,
                         op_code, mult_usage, optimization : integer;
                         family                            : string)
    return flt_pt_reg_type;

  function get_op_del_len(req_latency, act_latency : integer) return integer;

  --------------------------------------------------------------------------------
  -- Other functionality
  --------------------------------------------------------------------------------
  -- Determine when TREADY on input channels is required by the core
  function flt_pt_get_has_s_axis_tready(throttle_scheme, has_divide, has_sqrt, rate : integer) return integer;

  -- Determine latency of internal core after subtracting AXI interface latencies
  function fn_get_internal_core_latency (
    c_latency         : integer;
    c_throttle_scheme : integer)
    return integer;

  -- Create internal clock enables to handle AXI dataflow
  procedure assign_clock_enables (
    constant c_throttle_scheme  : in  integer;
    constant internal_latency   : in  integer;
    signal aclken_i             : in  std_logic;
    signal combiner_data_valid  : in  std_logic;
    signal m_axis_result_tready : in  std_logic;
    signal rdy_interface        : in  std_logic;
    signal ce_internal_core     : out std_logic;
    signal ce_interface         : out std_logic);

  -- Calculate total width of TUSER payload from all slave channels
  function fn_calc_user_width (c_has_a_tuser, c_has_b_tuser, c_has_operation_tuser, c_a_tuser_width, c_b_tuser_width, c_operation_tuser_width : integer) return integer;

  -- Create payload for delay line carrying TUSER and TLAST data in lockstep with the internal core
  procedure build_user_in (
    constant user_width                                                 : in  integer;
    constant has_tlast                                                  : in  integer;
    constant c_has_a_tuser, c_has_b_tuser, c_has_operation_tuser        : in  integer;
    constant c_has_a_tlast, c_has_b_tlast, c_has_operation_tlast        : in  integer;
    constant c_tlast_resolution                                         : in  integer;
    signal m_axis_z_tuser_a, m_axis_z_tuser_b, m_axis_z_tuser_operation : in  std_logic_vector;
    signal m_axis_z_tlast_a, m_axis_z_tlast_b, m_axis_z_tlast_operation : in  std_logic;
    signal user                                                         : out std_logic_vector);

  -- Create payload for output FIFO, consisting of internal core result,
  -- exception flags, and any TUSER and TLAST data
  procedure build_m_axis_fifo_in (
    constant c_result_width       : in  integer;
    constant user_width           : in  integer;
    constant has_tlast            : in  integer;
    constant output_fifo_width    : in  integer;
    constant c_has_underflow      : in  integer;
    constant c_has_overflow       : in  integer;
    constant c_has_invalid_op     : in  integer;
    constant c_has_divide_by_zero : in  integer;
    signal result                 : in  std_logic_vector;
    signal underflow              : in  std_logic;
    signal overflow               : in  std_logic;
    signal invalid_op             : in  std_logic;
    signal divide_by_zero         : in  std_logic;
    signal user                   : in  std_logic_vector;
    signal m_axis_fifo_in         : out std_logic_vector);

  -- Split output FIFO data into separate payload fields for result channel
  procedure decompose_m_axis_fifo_out (
    constant c_has_compare        : in  integer;
    constant c_compare_operation  : in  integer;
    constant c_result_width       : in  integer;
    constant c_has_underflow      : in  integer;
    constant c_has_overflow       : in  integer;
    constant c_has_invalid_op     : in  integer;
    constant c_has_divide_by_zero : in  integer;
    constant user_width           : in  integer;
    constant has_tlast            : in  integer;
    signal m_axis_fifo_out        : in  std_logic_vector;
    signal m_axis_result_tdata    : out std_logic_vector;
    signal m_axis_result_tuser    : out std_logic_vector;
    signal m_axis_result_tlast    : out std_logic);

end package floating_point_pkg_v6_0;


package body floating_point_pkg_v6_0 is
  --------------------------------------------------------------------------------
  -- Basic utility functions
  --------------------------------------------------------------------------------
  -- determines number of bits required to represent an integer
  -- if x = 0 then bits = 0
  --  x    result
  --  0       0
  --  1       1
  --  2       2
  --  3       2
  --  4       3
  --  5       3
  --  8       4
  function flt_pt_get_n_bits(x : integer) return integer is
    variable bits      : integer := 0;
    variable remainder : integer;
  begin
    assert (x >= 0)
      report "ERROR in get_n_bits: negative input is unsupported"
      severity error;

    remainder := x;
    while remainder >= 1 loop
      remainder := (remainder) / 2;
      bits      := bits + 1;
    end loop;
    return (bits);
  end function;

  -- if x = 0 then bits = 0
  --  x    result
  --  0       1
  --  1       2
  --  2       3
  --  3       4
  --  4       4
  --  5       4
  --  8       5
  --  -1      2
  --  -2      2
  --  -3      3
  function flt_pt_get_n_bits_signed(x : integer) return integer is
    variable bits      : integer := 1;  -- one bit for sign
    variable remainder : integer;
    variable neg_sign  : boolean;
  begin
    if x < 0 then
      remainder := -x;
      neg_sign  := true;
    else
      remainder := x;
      neg_sign  := false;
    end if;

    while remainder >= 1 loop
      remainder := (remainder) / 2;
      bits      := bits + 1;
    end loop;
    -- Check to see if maximum negative number,
    -- as this reqires less bits. (i.e. -2 => 10)
    if neg_sign and 2 ** bits = -x then
      bits := bits -1;
    end if;

    return (bits);
  end function;

  -- Purpose: Determine maximum integer
  function flt_pt_max(x, y : integer) return integer is
    variable ret_val : integer;
  begin
    if x < y then
      ret_val := y;
    else
      ret_val := x;
    end if;
    return(ret_val);
  end function;

  -- Purpose: Determine minimum integer
  function flt_pt_min(x, y : integer) return integer is
    variable ret_val : integer;
  begin
    if x < y then
      ret_val := x;
    else
      ret_val := y;
    end if;
    return(ret_val);
  end function;

  -- Purpose: Convert boolean to std_logic
  function conv_bool_to_sl(b : boolean) return std_logic is
  begin
    if b then
      return '1';
    else
      return '0';
    end if;
  end function;

  -- Purpose: Convert integer to 3 bit standard logic vector
  -- Throws an error if integer is too large to be represented
  function conv_int_to_slv_3(a, w : integer) return std_logic_vector is
    variable ret_val : std_logic_vector(2 downto 0);
  begin
    assert w = 3 report "ERROR in conv_int_to_slv_3: only supports op_code length of 3"
      severity error;
    case a is
      when 0 => ret_val := "000";
      when 1 => ret_val := "001";
      when 2 => ret_val := "010";
      when 3 => ret_val := "011";
      when 4 => ret_val := "100";
      when 5 => ret_val := "101";
      when 6 => ret_val := "110";
      when 7 => ret_val := "111";
      when others =>
        assert false report "ERROR in conv_int_to_slv_3: number to be converted" &
          "is out of range 0..7"
          severity error;
    end case;
    return(ret_val);
  end function;

  --------------------------------------------------------------------------------
  -- Functions to determine nature of FPGA resources
  --------------------------------------------------------------------------------
  -- Determines which families are fast (logic, relative to route)
  function flt_pt_fast_family(xdevicefamily : string) return integer is
  begin
    return 2;
  end function;

  --------------------------------------------------------------------------------
  -- Function to determine the number of operations that are enabled
  --------------------------------------------------------------------------------
  function flt_pt_number_of_operations(C_HAS_ADD,
                                       C_HAS_SUBTRACT,
                                       C_HAS_MULTIPLY,
                                       C_HAS_DIVIDE,
                                       C_HAS_SQRT,
                                       C_HAS_COMPARE,
                                       C_HAS_FIX_TO_FLT,
                                       C_HAS_FLT_TO_FIX,
                                       C_HAS_FLT_TO_FLT,
                                       C_HAS_RECIP,
                                       C_HAS_RECIP_SQRT : integer)
    return integer is

    variable n_op : integer;
  begin
    n_op := 0;
    if C_HAS_ADD = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_SUBTRACT = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_MULTIPLY = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_DIVIDE = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_SQRT = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_COMPARE = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_FIX_TO_FLT = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_FLT_TO_FIX = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_FLT_TO_FLT = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_RECIP = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    if C_HAS_RECIP_SQRT = FLT_PT_YES then
      n_op := n_op + 1;
    end if;
    return(n_op);
  end function;

  --------------------------------------------------------------------------------
  -- Function to determine the number of inputs from generics
  --------------------------------------------------------------------------------
  function flt_pt_number_of_inputs(C_HAS_ADD, C_HAS_SUBTRACT,
                                   C_HAS_MULTIPLY, C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE,
                                   C_HAS_FIX_TO_FLT, C_HAS_FLT_TO_FIX,
                                   C_HAS_FLT_TO_FLT : integer) return integer is
    variable n_ip : integer;
  begin
    if ((C_HAS_ADD = FLT_PT_YES) or (C_HAS_SUBTRACT = FLT_PT_YES) or
        (C_HAS_MULTIPLY = FLT_PT_YES) or (C_HAS_DIVIDE = FLT_PT_YES) or
        (C_HAS_COMPARE = FLT_PT_YES)) then
      n_ip := 2;
    elsif ((C_HAS_SQRT = FLT_PT_YES) or (C_HAS_FIX_TO_FLT = FLT_PT_YES) or
           (C_HAS_FLT_TO_FIX = FLT_PT_YES) or (C_HAS_FLT_TO_FLT = FLT_PT_YES)) then
      n_ip := 1;
    else
      n_ip := 0;
    end if;
    return(n_ip);
  end function;

  --------------------------------------------------------------------------------
  -- Function to determine the number of inputs from opcode
  --------------------------------------------------------------------------------
  function flt_pt_number_of_inputs(op_code : integer) return integer is
    variable n_ip : integer;
  begin
    if ((op_code = FLT_PT_ADD_OP_CODE) or
        (op_code = FLT_PT_SUBTRACT_OP_CODE) or
        (op_code = FLT_PT_MULTIPLY_OP_CODE) or
        (op_code = FLT_PT_DIVIDE_OP_CODE) or
        (op_code = FLT_PT_COMPARE_OP_CODE)) then
      n_ip := 2;
    elsif ((op_code = FLT_PT_SQRT_OP_CODE) or
           (op_code = FLT_PT_FIX_TO_FLT_OP_CODE) or
           (op_code = FLT_PT_FLT_TO_FIX_OP_CODE) or
           (op_code = FLT_PT_FLT_TO_FLT_OP_CODE)) then
      n_ip := 1;
    else
      n_ip := 0;
    end if;
    return(n_ip);
  end function;

  --------------------------------------------------------------------------------
  -- Function to provide op_code for a particular operation
  --------------------------------------------------------------------------------
  function flt_pt_get_op_code(C_HAS_ADD, C_HAS_SUBTRACT, C_HAS_MULTIPLY,
                              C_HAS_DIVIDE, C_HAS_SQRT, C_HAS_COMPARE, C_HAS_FIX_TO_FLT,
                              C_HAS_FLT_TO_FIX, C_HAS_FLT_TO_FLT, C_HAS_RECIP, C_HAS_RECIP_SQRT : integer) return std_logic_vector is

    variable op_code : integer := 0;
  begin

    if C_HAS_ADD = FLT_PT_YES then
      op_code := FLT_PT_ADD_OP_CODE;
    elsif C_HAS_SUBTRACT = FLT_PT_YES then
      op_code := FLT_PT_SUBTRACT_OP_CODE;
    elsif C_HAS_MULTIPLY = FLT_PT_YES then
      op_code := FLT_PT_MULTIPLY_OP_CODE;
    elsif C_HAS_DIVIDE = FLT_PT_YES then
      op_code := FLT_PT_DIVIDE_OP_CODE;
    elsif C_HAS_COMPARE = FLT_PT_YES then
      op_code := FLT_PT_COMPARE_OP_CODE;
    elsif C_HAS_FLT_TO_FIX = FLT_PT_YES then
      op_code := FLT_PT_FLT_TO_FIX_OP_CODE;
    elsif C_HAS_FIX_TO_FLT = FLT_PT_YES then
      op_code := FLT_PT_FIX_TO_FLT_OP_CODE;
    elsif C_HAS_SQRT = FLT_PT_YES then
      op_code := FLT_PT_SQRT_OP_CODE;
    elsif C_HAS_FLT_TO_FLT = FLT_PT_YES then
      op_code := FLT_PT_FLT_TO_FLT_OP_CODE;
    elsif C_HAS_RECIP = FLT_PT_YES then
      op_code := FLT_PT_RECIP_OP_CODE;
    elsif C_HAS_RECIP_SQRT = FLT_PT_YES then
      op_code := FLT_PT_RECIP_SQRT_OP_CODE;
    end if;
    -- Take modulus of op_code to strip off extended codes (i.e. flt_to_flt, recip, recip_sqrt)
    return(conv_int_to_slv_3((op_code mod 8), FLT_PT_OP_CODE_WIDTH));
  end function;

  --------------------------------------------------------------------------------
  -- Functions to provide delays for a subcomponents
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  -- round_and_renorm
  --------------------------------------------------------------------------------

  function flt_pt_get_renorm_and_round_delay(config : round_type; fw : integer)
    return integer is
    variable delay : integer;
  begin
    if config.legacy then
      delay := 1;
    elsif config.optimized then
      if config.extra_cut then
        -- This is here to allow extra delay to be implemented in the future
        delay := 1;
      else
        delay := 1;
      end if;
    elsif config.imp_type = FLT_PT_IMP_DSP48 then  -- use DSP48
      delay := 3;
    elsif fw <= FLT_PT_CARRY_LENGTH then
      -- Don't pipeline short chains
      delay := 1;
    else
      delay := 2;
    end if;
    return(delay);
  end function;

  -- To establish if last two stages can be packed into the round operation
  function flt_pt_get_renorm_and_round_norm_bits(imp_type : flt_pt_imp_type) return integer is
    variable norm_bits : integer;
  begin
    if imp_type = FLT_PT_IMP_DSP48 then
      norm_bits := 1;
    else
      norm_bits := 2;                   -- logic with LUT6, can do 2-bit shift
    end if;
    return norm_bits;
  end function;

  -- Renorm and round component
  function flt_pt_get_renorm_and_round(
    has_multiply, has_addsub : integer := FLT_PT_NO;
    optimization             : integer;
    family                   : string;
    mult_usage, w, fw        : integer) return round_type is
    variable r_and_r : round_type;

  begin

    -- Determine implementation type (logic or DSP48)
    if mult_usage = FLT_PT_NO_USAGE then
      -- If no_usage then we will always have a logic based rounder
      r_and_r.imp_type := FLT_PT_IMP_LOGIC;
    else
      r_and_r.imp_type := FLT_PT_IMP_DSP48;
    end if;

    r_and_r.legacy := false;            -- Single cycle latency

    -- Establish the stage at which the exponent is calculated, so that we
    -- can inject it as late as possible.
    if r_and_r.imp_type = FLT_PT_IMP_DSP48 then
      r_and_r.exp_stage := 2;           -- addition done in parallel
    elsif fw <= FLT_PT_CARRY_LENGTH then
      -- Don't pipeline short chains
      r_and_r.exp_stage := 1;
    else
      r_and_r.exp_stage := 2;           -- exp addition after mant
    end if;

    if has_multiply = FLT_PT_YES then
      -- If multiplier, then need to do some specific things
      if r_and_r.imp_type = FLT_PT_IMP_LOGIC then
        -- non-pipelined round
        r_and_r.legacy := true;
      elsif mult_usage = FLT_PT_MEDIUM_USAGE then
        if (fw = 24 and w = 32) or
          ((fw = 53 and w = 64) and not(supports_dsp48e1(family) > 0)) then
          -- Non-pipelined round
          r_and_r.legacy := true;
        end if;
      end if;

      if mult_usage /= FLT_PT_MAX_USAGE then
        -- Only enable DSP48 if max usage
        r_and_r.imp_type := FLT_PT_IMP_LOGIC;
      elsif supports_dsp48e1(family) > 0 then
        r_and_r.extra_cut := false;  -- with DSP48E1 we don't need extra cut as we have pattern detect
        if (optimization = FLT_PT_LOW_LATENCY)  -- low latency double precision
          and (fw = 53 and w = 64) then
          r_and_r.top_width := 38;
          r_and_r.optimized := true;
          r_and_r.exp_stage := 1;
        elsif (optimization = FLT_PT_SPEED_OPTIMIZED) and
          (fw = 24 and w = 32) and
          (mult_usage = FLT_PT_MAX_USAGE) then
          r_and_r.top_width := 31;
          r_and_r.optimized := true;
          r_and_r.exp_stage := -1;  -- one cycle early to accomodate delay into DSP48E1
          -- This is a placeholder for future
          --elsif (optimization = FLT_PT_SPEED_OPTIMIZED) and
          --      (fw = 53 and w = 64) and
          --      (mult_usage = FLT_PT_MAX_USAGE) then
          --  r_and_r.top_width := 21;
          --  r_and_r.optimized := true;
          --  r_and_r.exp_stage := 1;
        end if;
      elsif supports_dsp48a1(family) > 0 then
        -- use an optimized round
        r_and_r.optimized := true;
        -- width of part direct from PC_OUT
        r_and_r.top_width := flt_pt_get_fix_mult_top_width(fw => fw, family => family);
        r_and_r.exp_stage := 1;
        if fw             <= 17 then
          r_and_r.extra_cut := true;  -- need an extra cut in these circumstances
        else
          r_and_r.extra_cut := false;
        end if;
      end if;  -- DSP_TYPE
    elsif has_addsub = FLT_PT_YES then
      -- Adder, so check which architecture
      if optimization = FLT_PT_SPEED_OPTIMIZED then
        -- Use pipelined rounder
        r_and_r.legacy := false;
      else                              -- low latency
        -- Use legacy, non-pipelined, rounder
        r_and_r.legacy := true;
      end if;
    else
      -- All other components use legacy, non-pipelined, rounder
      r_and_r.legacy := true;
    end if;

    -- Determine what the maximum normalization is for a particular family
    r_and_r.norm_bits := flt_pt_get_renorm_and_round_norm_bits(r_and_r.imp_type);

    -- Based on what has been created determine the number of stages
    r_and_r.stages := flt_pt_get_renorm_and_round_delay(config => r_and_r, fw => fw);

    return r_and_r;
  end function;

  --------------------------------------------------------------------------------
  -- addsub component
  --------------------------------------------------------------------------------
  -- Provides implementation of addsub component: logic or DSP48-based
  function flt_pt_get_addsub_type(mult_usage : integer) return flt_pt_imp_type is
    variable addsub_type : flt_pt_imp_type;
  begin
    addsub_type := FLT_PT_IMP_LOGIC;
    if (mult_usage > FLT_PT_NO_USAGE) then
      addsub_type := FLT_PT_IMP_DSP48;
    end if;
    return(addsub_type);
  end function;

  -- Provides fully pipelined delay of addsub component
  function flt_pt_get_addsub_delay(mult_usage, width : integer) return integer is
    variable addsub_type : flt_pt_imp_type;
    variable delay       : integer;
  begin
    addsub_type := flt_pt_get_addsub_type(mult_usage);
    if addsub_type = FLT_PT_IMP_DSP48 then
      delay := 3;
    elsif width + 2 <= FLT_PT_CARRY_LENGTH then
      -- don't pipeline short carry chains
      delay := 1;
    else
      delay := 2;
    end if;
    return(delay);
  end function;

  -- To establish how many stages of alignment can be packed into addsub operation
  function flt_pt_get_addsub_bits(family : string) return integer is
  begin
    return 1;                           -- logic with LUT6, can do 2-bit shift
  end function;

  -- Establishes how many stages of alignment can be packed into addmux operation
  function flt_pt_get_addmux_bits(family : string) return integer is
  begin
    return 1;                           -- logic with LUT6, can do 2-bit shift
  end function;

  --------------------------------------------------------------------------------
  -- shift_msb_first component
  --------------------------------------------------------------------------------
  -- Provides number of bits required to perform specified shift
  function flt_pt_get_shift_msb_first_bits(a_width, result_width, last_bits_to_omit : integer;
                                           left                                     : boolean) return integer is
    variable width : integer;
    variable bits  : integer;
  begin
    if left then
      width := a_width;
    else
      width := result_width;
    end if;
    -- Determine if removing bits will reduce number of stages
    -- If so, return total number of bits
    bits := flt_pt_get_n_bits(width - 1);
    -- Modify bits according to last_bits_to_omit. e.g.
    -- Last bits, bits, new bits
    -- 0 7 7
    -- 1 7 6
    -- 2 7 6
    -- 0 6 6
    -- 1 6 6
    -- 2 6 4
    if last_bits_to_omit > 0 then
      bits := ((bits - last_bits_to_omit + 1) / 2) * 2;
    end if;
    return(bits);
  end function;

  --------------------------------------------------------------------------------
  -- zero_det component
  --------------------------------------------------------------------------------
  -- Provides fully pipelined delay of zero_det and zero_det_sel component
  function flt_pt_get_zero_det_delay(
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer is

    constant NEEDED_DIST_BITS : integer := flt_pt_get_n_bits(IP_WIDTH - 1);
    constant SHIFT_BITS       : integer := flt_pt_max(NEEDED_DIST_BITS, DISTANCE_WIDTH);
    constant NUMB_OF_STAGES   : integer := (SHIFT_BITS + STAGE_DIST_WIDTH - 1) / STAGE_DIST_WIDTH;
  begin
    return(NUMB_OF_STAGES);
  end function;

  --------------------------------------------------------------------------------
  -- shift component
  --------------------------------------------------------------------------------
  -- Provides fully pipelined delay of shift component
  function flt_pt_get_shift_delay (
    STAGE_DIST_WIDTH : integer;
    IP_WIDTH         : integer;
    OP_WIDTH         : integer;
    DISTANCE_WIDTH   : integer) return integer is

    constant NEEDED_DIST_BITS : integer := flt_pt_get_n_bits(OP_WIDTH - 1);
    constant SHIFT_BITS       : integer := flt_pt_max(NEEDED_DIST_BITS, DISTANCE_WIDTH);
    constant NUMB_OF_STAGES   : integer := (SHIFT_BITS + STAGE_DIST_WIDTH - 1) / STAGE_DIST_WIDTH;

  begin
    return(NUMB_OF_STAGES);
  end function;

  --------------------------------------------------------------------------------
  -- normalization component
  --------------------------------------------------------------------------------
  -- Provides fully pipelined delay of normalization component
  function flt_pt_get_normalization_delay(in_width : integer) return integer is
  begin
    return((flt_pt_get_n_bits(in_width - 2) + 1) / 2);
  end function;

  --------------------------------------------------------------------------------
  -- align component
  --------------------------------------------------------------------------------
  -- Provides fully pipelined delay of align component
  function flt_pt_get_align_delay(ip_width, op_width : integer) return
    integer is

    constant ZERO_DET_WIDTH : integer := flt_pt_get_n_bits(ip_width - 1);
    constant ZERO_DET_STAGES : integer := flt_pt_get_zero_det_delay(
      STAGE_DIST_WIDTH => 2,
      IP_WIDTH         => ip_width,
      OP_WIDTH         => op_width,
      DISTANCE_WIDTH   => ZERO_DET_WIDTH);

    constant ALIGN_WIDTH : integer := flt_pt_get_n_bits(op_width - 1);
    constant ALIGN_STAGES : integer := flt_pt_get_shift_delay(
      STAGE_DIST_WIDTH => 2,
      IP_WIDTH         => ip_width,
      OP_WIDTH         => op_width,
      DISTANCE_WIDTH   => ALIGN_WIDTH);

  begin
    return(flt_pt_max(ZERO_DET_STAGES, ALIGN_STAGES));
  end function;

  --------------------------------------------------------------------------------
  -- normalize
  --------------------------------------------------------------------------------
  -- Provides configuration for normalize component
  function flt_pt_get_normalize(data_width : integer; poss_last_bits : integer := 1) return normalize_type is
    variable norm_data       : normalize_type;
    variable full_norm_stage : integer;
    variable part_bits       : integer;
    variable full_norm_bits  : integer;
  begin
    part_bits := flt_pt_get_shift_msb_first_bits(
      data_width, data_width, poss_last_bits, true);

    norm_data.norm_stage := (part_bits + 1) / 2 + 1;

    full_norm_bits := flt_pt_get_shift_msb_first_bits(
      data_width, data_width, 0, true);

    full_norm_stage := (full_norm_bits + 1) / 2 + 1;

    norm_data.last_stage := full_norm_stage - norm_data.norm_stage;
    norm_data.last_bits  := full_norm_bits - part_bits;
    norm_data.can_stage  := 2;
    return(norm_data);
  end function;

  --------------------------------------------------------------------------------
  -- alignment
  --------------------------------------------------------------------------------
  -- Provides configuration for alignment component
  function flt_pt_get_alignment(ip_width, det_width, op_width : integer;
                                poss_last_bits                : integer := 0) return alignment_type is
    variable aa         : alignment_type;
    variable full_stage : integer;
    variable part_bits  : integer;
    variable full_bits  : integer;
  begin
    -- Determine input width of shifter
    if poss_last_bits > 0 then
      -- Need to accommodate 1-bit alignment shift within mux stage
      aa.ip_width := ip_width + 1;
    else
      aa.ip_width := ip_width;
    end if;
    -- Set detection width
    aa.det_width := det_width;
    -- Set width of shifter output
    aa.op_width  := op_width;

    assert (op_width = det_width)
      report "ERROR in flt_pt_get_alignment: OP_WIDTH and DET_WIDTH must be the same."
      severity error;

    -- Determine number of bits required to represent shift distance
    -- Implementing right-shift so base this calculation on output width

    aa.shift_width    := flt_pt_get_n_bits(op_width - 1);
    aa.zero_det_width := flt_pt_get_n_bits(det_width - 1);

    -- Determine number of bits with last bits removed
    part_bits := flt_pt_get_shift_msb_first_bits(ip_width, op_width, poss_last_bits, false);

    aa.stage := (part_bits + 1) / 2;

    -- Check if more that 2 stages, in which case we can pipeline every other stage
    -- mux + z_det R, mux R
    -- mux + z_det R, mux, mux R
    aa.stage_mask := (others => true);

    -- Determine number of bits without any last bits
    full_bits  := flt_pt_get_shift_msb_first_bits(ip_width, op_width, 0, false);
    full_stage := (full_bits + 1) / 2;

    if full_stage > 2 then
      full_stage := full_stage - 1;
    end if;

    aa.last_stage     := full_stage - aa.stage;
    aa.last_bits      := full_bits - part_bits;
    aa.shift_stage    := aa.stage;
    aa.zero_det_stage := aa.stage;

    return(aa);
  end function;

  --------------------------------------------------------------------------------
  -- Functions to provide delays for a operations
  --------------------------------------------------------------------------------

  -- Provides fully pipelined delay of floating-point to fixed-point component
  function flt_pt_flt_to_fix_delay(a_width, a_fraction_width, result_width, result_fraction_width : integer)
    return integer is
    variable align_delay : integer;
  begin
    align_delay := flt_pt_get_align_delay(ip_width => a_fraction_width + 1,
                                          op_width => result_width);
    return(align_delay + 3);
  end function;

  -- Provides fully pipelined delay of fixed-point to floating-point component
  function flt_pt_fix_to_flt_delay(a_width, version : integer) return integer is
    variable normalization_delay : integer;
    variable delay               : integer;
    variable normalize_data      : normalize_type;
  begin
    case version is
      when 2 =>
        normalization_delay := flt_pt_get_normalization_delay(a_width + 1);
        delay               := normalization_delay + 3;
      when 3 =>
        normalize_data := flt_pt_get_normalize(data_width => a_width);
        delay          := normalize_data.norm_stage + 3;
      when others =>
        report "Internal error : flt_pt_fix_to_flt_delay does not support version, latency set to 0";
        delay := 0;
    end case;
    return delay;
  end function;

  -- Provides fully pipelined delay of floating-point to floating-point component
  function flt_pt_flt_to_flt_delay(a_width, a_fraction_width, result_width, result_fraction_width : integer)
    return integer is
    variable delay : integer;
  begin
    if (a_fraction_width <= result_fraction_width) and
      ((a_width - a_fraction_width) <= (result_width - result_fraction_width)) then
      delay                         := 2;
    else
      delay := 3;
    end if;
    return(delay);
  end function;

  function flt_pt_get_multadd_structure (
    c_xdevicefamily : string;
    c_mult_usage    : integer;
    a_width         : integer;
    b_width         : integer;
    c_width         : integer)
    return flt_pt_fix_multadd_type is
    -- Calculate if the multiply will require more than 3 partial products
    -- We assume again that A is the wide port, and B is narrower or the same
    constant regular_split_add : boolean :=
      ((supports_dsp48e1(c_xdevicefamily) > 0) and not(a_width >= 59 or b_width >= 18))
      or ((supports_dsp48a1(c_xdevicefamily) > 0) and not(a_width >= 52 or b_width >= 18));
    variable multadd_style : flt_pt_fix_multadd_type;
  begin

    -- Assumptions
    assert a_width >= b_width
      report "ERROR: flt_pt_get_multadd_structure: a_width must be >= b_width"
      severity error;

    if c_mult_usage = FLT_PT_NO_USAGE then
      multadd_style := FLT_PT_FIX_MULTADD_FABRIC;
    else
      if c_width <= CI_DSP48_C_WIDTH then
        multadd_style := FLT_PT_FIX_MULTADD_DSP_LS_ADDER;
      else
        if regular_split_add then
          multadd_style := FLT_PT_FIX_MULTADD_DSP_EXTRA_DSP_ADDER;
        else
          multadd_style := FLT_PT_FIX_MULTADD_DSP_EXTRA_FABRIC_ADDER;
        end if;
      end if;
    end if;
    return multadd_style;
  end function flt_pt_get_multadd_structure;

  function flt_pt_fix_multadd_delay (
    c_xdevicefamily : string;
    c_mult_usage    : integer;
    a_width         : integer;
    b_width         : integer;
    c_width         : integer;
    use_preadder    : boolean)
    return integer is
    constant MULT_GEN_DELAY : integer :=
      mult_gen_v11_2_calc_fully_pipelined_latency_internal(family     => c_xdevicefamily,
                                                           a_width    => a_width,
                                                           a_type     => C_SIGNED,
                                                           b_width    => b_width,
                                                           b_type     => C_SIGNED,
                                                           mult_type  => boolean'pos(c_mult_usage /= FLT_PT_NO_USAGE),
                                                           opt_goal   => 1,  --Speed
                                                           ccm_imp    => 0,  --irrelevant
                                                           b_value    => "",  --irrelevant
                                                           standalone => FLT_PT_NO);  -- forces use of post-adder;
    constant ADDER_DELAY       : integer := 1;
    constant MULTADD_STRUCTURE : flt_pt_fix_multadd_type :=
      flt_pt_get_multadd_structure(c_xdevicefamily => c_xdevicefamily,
                                   c_mult_usage    => c_mult_usage,
                                   a_width         => a_width,
                                   b_width         => b_width,
                                   c_width         => c_width);
    constant PREG_DELAY : integer := 1;
    variable delay      : integer;
  begin

    assert not(use_preadder)
      report "ERROR: multadd_delay: use_preadder=true not supported"
      severity error;

    case MULTADD_STRUCTURE is
      when FLT_PT_FIX_MULTADD_FABRIC =>
        delay := MULT_GEN_DELAY + ADDER_DELAY;
      when FLT_PT_FIX_MULTADD_DSP_LS_ADDER =>
        delay := MULT_GEN_DELAY;
      when FLT_PT_FIX_MULTADD_DSP_EXTRA_DSP_ADDER =>
        delay := MULT_GEN_DELAY + PREG_DELAY;
      when FLT_PT_FIX_MULTADD_DSP_EXTRA_FABRIC_ADDER =>
        delay := MULT_GEN_DELAY + ADDER_DELAY;
      when others =>
        assert false
          report "ERROR: multadd_delay: unrecognised multadd structure"
          severity error;
    end case;

    return delay;
  end function flt_pt_fix_multadd_delay;

  function flt_pt_is_single_precision (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return boolean is
  begin
    if c_a_width = 32 and c_a_fraction_width = 24 then
      return true;
    else
      return false;
    end if;
  end function flt_pt_is_single_precision;

  function flt_pt_is_double_precision (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return boolean is
  begin
    if c_a_width = 64 and c_a_fraction_width = 53 then
      return true;
    else
      return false;
    end if;
  end function flt_pt_is_double_precision;

  function flt_pt_recip_w (
    c_a_fraction_width : integer)
    return integer is
  begin
    return c_a_fraction_width;
  end function flt_pt_recip_w;

  function flt_pt_recip_k (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
  begin
    if c_operation = FLT_PT_RECIP_OP_CODE then
      if flt_pt_is_single_precision(c_a_width, c_a_fraction_width) then
        return 7;
      elsif flt_pt_is_double_precision(c_a_width, c_a_fraction_width) then
        return 15;
      else
        return 0;
      end if;
    elsif c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      if flt_pt_is_single_precision(c_a_width, c_a_fraction_width) then
        return 7;
      elsif flt_pt_is_double_precision(c_a_width, c_a_fraction_width) then
        return 14;
      else
        return 0;
      end if;
    else
      assert false
        report "ERROR: flt_pt_recip_k: illegal c_operation " & integer'image(c_operation)
        severity error;
      return 0;
    end if;
  end function flt_pt_recip_k;

  function flt_pt_recip_m (
    c_a_width          : integer;
    c_a_fraction_width : integer)
    return integer is
  begin
    if flt_pt_is_single_precision(c_a_width, c_a_fraction_width) then
      return 3;
    elsif flt_pt_is_double_precision(c_a_width, c_a_fraction_width) then
      return 7;
    else
      return 0;
    end if;
  end function flt_pt_recip_m;

  function flt_pt_recip_m_width (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
  begin
    if c_operation = FLT_PT_RECIP_OP_CODE then
      -- Just R width (k+1)
      return flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation) + 1;
    elsif c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      -- 4K fractional bits
      return (flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation) * 4);
    else
      assert false
        report "ERROR: flt_pt_recip_m_width: illegal operation " & integer'image(c_operation)
        severity error;
      return 0;
    end if;
  end function flt_pt_recip_m_width;

  function flt_pt_recip_sqrt_delay_adjust (
    c_operation : integer)
    return integer is
  begin
    if c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      return 1;
    else
      return 0;
    end if;
  end function flt_pt_recip_sqrt_delay_adjust;

  function flt_pt_recip_postprocessing_plus_one_alignment (
    C_OPERATION : integer;
    K           : integer;
    M_WIDTH     : integer)
    return integer is
  begin
    if C_OPERATION = FLT_PT_RECIP_OP_CODE then
      return (K-2);
    elsif C_OPERATION = FLT_PT_RECIP_SQRT_OP_CODE then
      return M_WIDTH;
    else
      assert false
        report "ERROR: flt_pt_recip_postprocessing_plus_one_alignment: illegal c_operation " & integer'image(C_OPERATION)
        severity error;
      return 0;
    end if;
  end function flt_pt_recip_postprocessing_plus_one_alignment;

  function flt_pt_recip_postprocessing_add_data_width(
    C_OPERATION        : integer;
    M_INT_WIDTH        : integer;
    RC_A_WIDTH         : integer;
    RC_B_WIDTH         : integer;
    PLUS_ONE_ALIGNMENT : integer)
    return integer is
  begin
    if C_OPERATION = FLT_PT_RECIP_OP_CODE then
      return M_INT_WIDTH
        + RC_A_WIDTH
        + SIGN_BIT_WIDTH                -- actually rounding bit
        + RC_B_WIDTH;
    elsif C_OPERATION = FLT_PT_RECIP_SQRT_OP_CODE then
      return M_INT_WIDTH
        + PLUS_ONE_ALIGNMENT;
    else
      assert false
        report "ERROR: flt_pt_recip_postprocessing_add_data_width: illegal c_operation " & integer'image(C_OPERATION)
        severity error;
      return 0;
    end if;
  end function flt_pt_recip_postprocessing_add_data_width;

  function flt_pt_recip_calc_rom_entry (i, m, rom_output_width : integer) return std_logic_vector is
    -- Precalculate some constants
    constant two_to_the_m                      : real := 2.0**(real(m));
    constant two_to_the_minus_m                : real := 2.0**(-1.0*real(m));
    constant two_to_the_minus_twom_minus_three : real := 2.0**((-2.0*real(m))-3.0);
    constant upscale                           : real := real(2**(rom_output_width));
    variable p                                 : real := 0.0;
    variable table_real                        : real := 0.0;
  begin
    -- Calculate p, normalise to achieve no integer bits
    p          := (1.0 + (real(i)/two_to_the_m));  -- Treat as unsigned
    table_real := (1.0/(p*(p+two_to_the_minus_m))) - (two_to_the_minus_twom_minus_three/real(p**4));
    -- Scale data back up to allow integer representation, round and convert to binary
    return std_logic_vector(to_unsigned(integer(round(table_real*upscale)), rom_output_width));
  end function flt_pt_recip_calc_rom_entry;

  function flt_pt_recip_approx_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
    constant ROM_DELAY        : integer := 1;
    constant K                : integer := flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation);
    constant IS_DOUBLE        : boolean := flt_pt_is_double_precision(c_a_width, c_a_fraction_width);
    constant M                : integer := flt_pt_recip_m(C_A_WIDTH, C_A_FRACTION_WIDTH);
    constant EXTRA_LSBS       : integer := (2*M)-K+3;
    constant ROM_OUTPUT_WIDTH : integer := (2*M)+3;
    constant A_WIDTH          : integer := K+EXTRA_LSBS+1;
    constant B_WIDTH          : integer := ROM_OUTPUT_WIDTH;
  begin
    return ROM_DELAY +
      mult_gen_v11_2_calc_fully_pipelined_latency_internal(family     => c_xdevicefamily,
                                                           a_width    => A_WIDTH,
                                                           a_type     => C_UNSIGNED,
                                                           b_width    => B_WIDTH,
                                                           b_type     => C_UNSIGNED,
                                                           mult_type  => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                           opt_goal   => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                           ccm_imp    => 0,
                                                           b_value    => "",
                                                           standalone => FLT_PT_NO);
  end function flt_pt_recip_approx_delay;

  function flt_pt_recip_nr_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
    -- Constants for the flt_recip_nr internal widths
    constant K                                       : integer := flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation);
    variable mult1_delay, mult2_delay                : integer;  -- assign if required
    constant ADDER_DELAY, NEGATE_DELAY               : integer := 1;
    constant YK_WIDTH                                : integer := K;
    constant YK_PLUS_HIDDEN_WIDTH                    : integer := YK_WIDTH + HIDDEN_BIT_WIDTH;
    constant RA_WIDTH                                : integer := K+1;
    constant RA_SIGNED_WIDTH                         : integer := RA_WIDTH+SIGN_BIT_WIDTH;
    constant MULT1_OUT_WIDTH                         : integer := (K+3);
    -- The delay values
    variable delay_flt_recip_approx, delay_nr, delay : integer;
  begin

    delay_flt_recip_approx := flt_pt_recip_approx_delay(c_xdevicefamily    => c_xdevicefamily,
                                                        c_mult_usage       => c_mult_usage,
                                                        c_a_width          => c_a_width,
                                                        c_a_fraction_width => c_a_fraction_width,
                                                        c_operation        => c_operation);

    mult1_delay := mult_gen_v11_2_calc_fully_pipelined_latency_internal(family     => c_xdevicefamily,
                                                                        a_width    => YK_PLUS_HIDDEN_WIDTH,
                                                                        a_type     => C_UNSIGNED,
                                                                        b_width    => RA_WIDTH,
                                                                        b_type     => C_UNSIGNED,
                                                                        mult_type  => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                                        opt_goal   => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                                        ccm_imp    => 0,
                                                                        b_value    => "",
                                                                        standalone => FLT_PT_NO);

    mult2_delay := mult_gen_v11_2_calc_fully_pipelined_latency_internal(family     => c_xdevicefamily,
                                                                        a_width    => MULT1_OUT_WIDTH,
                                                                        a_type     => C_SIGNED,
                                                                        b_width    => RA_SIGNED_WIDTH,
                                                                        b_type     => C_SIGNED,
                                                                        mult_type  => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                                        opt_goal   => 0,
                                                                        ccm_imp    => 0,
                                                                        b_value    => "",
                                                                        standalone => FLT_PT_NO);

    delay_nr := mult1_delay + NEGATE_DELAY + mult2_delay + ADDER_DELAY;

    delay := delay_flt_recip_approx + delay_nr;

    return delay;
  end function flt_pt_recip_nr_delay;

  function flt_pt_recipsqrt_r_msbs_width(
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
  begin
    if flt_pt_is_double_precision(c_a_width, c_a_fraction_width) and c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      return 9;
    else
      return 0;
    end if;
  end function flt_pt_recipsqrt_r_msbs_width;

  function flt_pt_recipsqrt_r_initial_est_width(
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
  begin
    if flt_pt_is_double_precision(c_a_width, c_a_fraction_width) and c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      return 17;
    else
      return 0;
    end if;
  end function flt_pt_recipsqrt_r_initial_est_width;

  function flt_pt_recip_init_m_calc_width_rcd (
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return FLT_PT_RECIP_M_CALC_WIDTHS is

    constant R_MSBS_WIDTH : integer := flt_pt_recipsqrt_r_msbs_width(
      c_a_width,
      c_a_fraction_width,
      c_operation);
    constant RECSQRT_R_INITIAL_EST_WIDTH : integer := flt_pt_recipsqrt_r_initial_est_width(
      c_a_width,
      c_a_fraction_width,
      c_operation);

    constant R_WIDTH : integer := 1 + flt_pt_recip_k(
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      c_operation        => c_operation);
    constant R_SIGNED_WIDTH : integer := R_WIDTH+SIGN_BIT_WIDTH;
    constant M_WIDTH : integer := flt_pt_recip_m_width(
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      c_operation        => c_operation);
    variable r : FLT_PT_RECIP_M_CALC_WIDTHS;
  begin

    -- NR stage 1
    r.NR1_M1_A_WIDTH := RECSQRT_R_INITIAL_EST_WIDTH+SIGN_BIT_WIDTH;
    r.NR1_M1_B_WIDTH := r.NR1_M1_A_WIDTH;
    r.NR1_M1_C_WIDTH := 35;
    r.NR1_M2_A_WIDTH := 25;
    r.NR1_M2_B_WIDTH := R_SIGNED_WIDTH;
    r.NR1_M2_C_WIDTH := 41;
    r.NR1_M3_A_WIDTH := 25;
    r.NR1_M3_B_WIDTH := RECSQRT_R_INITIAL_EST_WIDTH+SIGN_BIT_WIDTH;
    r.NR1_M3_C_WIDTH := 1;              -- not used; truncate

    -- NR stage 2
    r.NR2_M1_A_WIDTH := 35;             -- Z1_WIDTH
    r.NR2_M1_B_WIDTH := 35;
    r.NR2_M1_C_WIDTH := 1;              -- not used
    r.NR2_M2_A_WIDTH := 69;
    r.NR2_M2_B_WIDTH := R_SIGNED_WIDTH;
    r.NR2_M2_C_WIDTH := 85;
    r.NR2_M3_A_WIDTH := 73;
    r.NR2_M3_B_WIDTH := 35;             -- Z1_WIDTH
    r.NR2_M3_C_WIDTH := 1;              -- not used; truncate

    -- NR stage 3
    r.NR3_M1_A_WIDTH := 59;
    r.NR3_M1_B_WIDTH := 59;
    r.NR3_M1_C_WIDTH := 119;
    r.NR3_M2_A_WIDTH := 73;
    r.NR3_M2_B_WIDTH := R_SIGNED_WIDTH;
    r.NR3_M2_C_WIDTH := 89;
    r.NR3_M3_A_WIDTH := 59;
    r.NR3_M3_B_WIDTH := 59;
    r.NR3_M3_C_WIDTH := 119;

    -- Sqrt recovery
    r.SQRT_A_WIDTH := 59;
    r.SQRT_B_WIDTH := R_SIGNED_WIDTH;
    r.SQRT_C_WIDTH := 76;

    -- Compensation
    r.CORRECTION_A_WIDTH := 57;
    r.CORRECTION_B_WIDTH := M_WIDTH+SIGN_BIT_WIDTH;
    r.CORRECTION_C_WIDTH := M_WIDTH+SIGN_BIT_WIDTH+r.CORRECTION_A_WIDTH;

    return r;

  end function flt_pt_recip_init_m_calc_width_rcd;

  function flt_pt_recip_m_calc_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer is
    constant IS_DOUBLE_PREC : boolean := flt_pt_is_double_precision(
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width);
    constant M_CALC_WIDTHS : FLT_PT_RECIP_M_CALC_WIDTHS := flt_pt_recip_init_m_calc_width_rcd(
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      c_operation        => c_operation);
    constant BRAM_DELAY                                              : integer := 2;
    constant MUX_DELAY                                               : integer := 1;
    variable nr1_delay, nr2_delay, nr3_delay, sqrt_delay, comp_delay : integer;
    variable delay                                                   : integer;
  begin

    if c_operation = FLT_PT_RECIP_SQRT_OP_CODE and IS_DOUBLE_PREC then

      -- NR stage 1
      nr1_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR1_M1_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR1_M1_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR1_M1_C_WIDTH,
        use_preadder    => use_preadder);
      nr1_delay := nr1_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR1_M2_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR1_M2_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR1_M2_C_WIDTH,
        use_preadder    => use_preadder);
      nr1_delay := nr1_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR1_M3_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR1_M3_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR1_M3_C_WIDTH,
        use_preadder    => use_preadder);
--      report "nr1 delay " & integer'image(nr1_delay) severity note;

      -- NR stage 2
      nr2_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR2_M1_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR2_M1_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR2_M1_C_WIDTH,
        use_preadder    => use_preadder);
      nr2_delay := nr2_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR2_M2_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR2_M2_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR2_M2_C_WIDTH,
        use_preadder    => use_preadder);
      nr2_delay := nr2_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR2_M3_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR2_M3_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR2_M3_C_WIDTH,
        use_preadder    => use_preadder);
--      report "nr2 delay " & integer'image(nr2_delay) severity note;

      -- NR stage 3
      nr3_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR3_M1_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR3_M1_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR3_M1_C_WIDTH,
        use_preadder    => use_preadder);
      nr3_delay := nr3_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR3_M2_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR3_M2_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR3_M2_C_WIDTH,
        use_preadder    => use_preadder);
      nr3_delay := nr3_delay + flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.NR3_M3_A_WIDTH,
        b_width         => M_CALC_WIDTHS.NR3_M3_B_WIDTH,
        c_width         => M_CALC_WIDTHS.NR3_M3_C_WIDTH,
        use_preadder    => use_preadder);
--      report "nr2 delay " & integer'image(nr3_delay) severity note;

      -- Sqrt recovery
      sqrt_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.SQRT_A_WIDTH,
        b_width         => M_CALC_WIDTHS.SQRT_B_WIDTH,
        c_width         => M_CALC_WIDTHS.SQRT_C_WIDTH,
        use_preadder    => use_preadder);
--      report "sqrt delay " & integer'image(sqrt_delay) severity note;

      -- Compensation
      comp_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_CALC_WIDTHS.CORRECTION_A_WIDTH,
        b_width         => M_CALC_WIDTHS.CORRECTION_B_WIDTH,
        c_width         => M_CALC_WIDTHS.CORRECTION_C_WIDTH,
        use_preadder    => use_preadder);
--      report "comp delay " & integer'image(comp_delay) severity note;

      delay := BRAM_DELAY + nr1_delay + nr2_delay + nr3_delay + sqrt_delay + comp_delay + MUX_DELAY;

--      report "M Calc max delay = " & integer'image(delay) severity note;

    else

      -- Single-precision reciprocal sqrt or any reciprocal configuration - no M calculation delay required
      delay := 0;

    end if;

    return delay;

  end function flt_pt_recip_m_calc_delay;

  function flt_pt_recip_reduction_calc_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer is
    constant W           : integer := flt_pt_recip_w(c_a_fraction_width);
    constant K           : integer := flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation);
    constant R_INT_WIDTH : integer := K+1 + SIGN_BIT_WIDTH;
    constant Y_INT_WIDTH : integer := (c_a_fraction_width-HIDDEN_BIT_WIDTH) + SIGN_BIT_WIDTH + HIDDEN_BIT_WIDTH;
    constant ADD_WIDTH   : integer := W+K+3;
    variable delay       : integer;
  begin
    delay := flt_pt_fix_multadd_delay (
      c_xdevicefamily => c_xdevicefamily,
      c_mult_usage    => c_mult_usage,
      a_width         => Y_INT_WIDTH,
      b_width         => R_INT_WIDTH,
      c_width         => ADD_WIDTH,
      use_preadder    => use_preadder);
    return delay;
  end function flt_pt_recip_reduction_calc_delay;


  function flt_pt_recip_evaluation_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer is
    constant ADDER_DELAY                                    : integer := 1;
    constant K                                              : integer := flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation);
    variable multadd1_delay, multadd2_delay, multadd3_delay : integer;
    variable delay                                          : integer;
    -- Adds the additional latency for the adders implementing coefficients
    constant RECIP_SQRT_DELAY_ADJUST                        : integer := flt_pt_recip_sqrt_delay_adjust(c_operation);
  begin

    if c_operation = FLT_PT_RECIP_OP_CODE then

      multadd1_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => (K+2),
        b_width         => (K+1),
        c_width         => ((2*K)+3),
        use_preadder    => use_preadder);

      multadd2_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => (K+2),
        b_width         => (K+1),
        c_width         => ((3*K)+1),
        use_preadder    => use_preadder);

      multadd3_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => (K+1),
        b_width         => (K+1),
        c_width         => ((3*K)+2),
        use_preadder    => use_preadder);

    elsif c_operation = FLT_PT_RECIP_SQRT_OP_CODE then

      -- Different multadd configuration

      -- Use mult instead of multadd to avoid adder stage for fabric case
      -- Latency of DSP solution is same as if we used multadd latency function
      multadd1_delay := mult_gen_v11_2_calc_fully_pipelined_latency_internal(family     => c_xdevicefamily,
                                                                             a_width    => (K+1),
                                                                             a_type     => C_SIGNED,
                                                                             b_width    => (K+1),
                                                                             b_type     => C_SIGNED,
                                                                             mult_type  => boolean'pos(C_MULT_USAGE /= FLT_PT_NO_USAGE),
                                                                             opt_goal   => 1,  -- Speed
                                                                             ccm_imp    => 0,
                                                                             b_value    => "",
                                                                             standalone => FLT_PT_NO);

      multadd2_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => (K+3),
        b_width         => (K+1),
        c_width         => ((3*K)+3),
        use_preadder    => use_preadder);

      multadd3_delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => (K+4),
        b_width         => (K+1),
        c_width         => ((3*K)+5),
        use_preadder    => use_preadder);

    end if;

    delay := multadd1_delay + multadd2_delay + multadd3_delay + ADDER_DELAY + RECIP_SQRT_DELAY_ADJUST;

    return delay;
  end function flt_pt_recip_evaluation_delay;

  function flt_pt_recip_postprocessing_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    use_preadder       : boolean;
    c_operation        : integer)
    return integer is
    constant W                  : integer := flt_pt_recip_w(c_a_fraction_width);
    constant K                  : integer := flt_pt_recip_k(c_a_width, c_a_fraction_width, c_operation);
    constant M_WIDTH            : integer := flt_pt_recip_m_width(c_a_width, c_a_fraction_width, c_operation);  --(K+1);  -- R_WIDTH
    constant B1_WIDTH           : integer := (3*K)+2;
    constant PLUS_ONE_ALIGNMENT : integer := flt_pt_recip_postprocessing_plus_one_alignment(c_operation, k, m_width);  --(K-2);
    constant M_INT_WIDTH        : integer := M_WIDTH + SIGN_BIT_WIDTH;
    constant RC_A_WIDTH         : integer := (W-K)-1;
    constant RC_B_WIDTH         : integer := (4*K)-W+2+PLUS_ONE_ALIGNMENT;
    constant ADD_DATA_WIDTH     : integer := flt_pt_recip_postprocessing_add_data_width(C_OPERATION, M_INT_WIDTH, RC_A_WIDTH, RC_B_WIDTH, PLUS_ONE_ALIGNMENT);  --SIGN_BIT_WIDTH + M_WIDTH + RC_A_WIDTH + SIGN_BIT_WIDTH + RC_B_WIDTH;
    variable delay              : integer := 0;
  begin
    if c_operation = FLT_PT_RECIP_OP_CODE then
      delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => B1_WIDTH,
        b_width         => M_INT_WIDTH,
        c_width         => ADD_DATA_WIDTH,
        use_preadder    => use_preadder);
    elsif c_operation = FLT_PT_RECIP_SQRT_OP_CODE then
      -- Ports swapped so widest is on A
      delay := flt_pt_fix_multadd_delay (
        c_xdevicefamily => c_xdevicefamily,
        c_mult_usage    => c_mult_usage,
        a_width         => M_INT_WIDTH,
        b_width         => B1_WIDTH,
        c_width         => ADD_DATA_WIDTH,
        use_preadder    => use_preadder);
    else
      assert false
        report "ERROR: flt_pt_recip_postprocessing_delay: illegal c_operation value " & integer'image(c_operation)
        severity error;
    end if;
    return delay;
  end function flt_pt_recip_postprocessing_delay;

  function flt_pt_recip_recombination_delay (
    c_operation : integer)
    return integer is
    constant MUX_DELAY : integer := 1;
  begin
    return MUX_DELAY;
  end function flt_pt_recip_recombination_delay;

  function flt_pt_get_recip_delay (
    c_xdevicefamily    : string;
    c_mult_usage       : integer;
    c_a_width          : integer;
    c_a_fraction_width : integer;
    c_operation        : integer)
    return integer is
    constant debug                                                                             : boolean := false;
    constant use_preadder                                                                      : boolean := false;  -- REVISIT
    variable nr_delay, reduction_delay                                                         : integer;
    variable reduction_calc_delay, evaluation_delay, postprocessing_delay, recombination_delay : integer;
    variable m_calc_delay                                                                      : integer;
    variable delay                                                                             : integer;
  begin

    nr_delay := flt_pt_recip_nr_delay (
      c_xdevicefamily    => c_xdevicefamily,
      c_mult_usage       => c_mult_usage,
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      c_operation        => c_operation);
    assert not(debug) report "pkg: nr_delay " & integer'image(nr_delay) severity note;

    m_calc_delay := flt_pt_recip_m_calc_delay(
      c_xdevicefamily    => c_xdevicefamily,
      c_mult_usage       => c_mult_usage,
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      use_preadder       => use_preadder,
      c_operation        => c_operation);
    assert not(debug) report "pkg: m_calc_delay " & integer'image(m_calc_delay) severity note;

    reduction_delay := flt_pt_recip_reduction_calc_delay (
      c_xdevicefamily    => c_xdevicefamily,
      c_mult_usage       => c_mult_usage,
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      use_preadder       => use_preadder,
      c_operation        => c_operation);
    assert not(debug) report "pkg: reduction_delay " & integer'image(reduction_delay) severity note;

    reduction_calc_delay := nr_delay + reduction_delay;

    evaluation_delay := flt_pt_recip_evaluation_delay (
      c_xdevicefamily    => c_xdevicefamily,
      c_mult_usage       => c_mult_usage,
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      use_preadder       => false,
      c_operation        => c_operation);
    assert not(debug) report "pkg: evaluation_delay (raw) " & integer'image(evaluation_delay) severity note;

    -- Add additional delay in evaluation datapath to compensate for higher
    -- latency of M calculation, prior to postprocessing stage
    if m_calc_delay > (reduction_delay + evaluation_delay) then
      -- DP recsqrt
      evaluation_delay := evaluation_delay + (m_calc_delay-(reduction_delay + evaluation_delay));
    end if;

    assert not(debug) report "pkg: evaluation_delay " & integer'image(evaluation_delay) severity note;

    postprocessing_delay := flt_pt_recip_postprocessing_delay (
      c_xdevicefamily    => c_xdevicefamily,
      c_mult_usage       => c_mult_usage,
      c_a_width          => c_a_width,
      c_a_fraction_width => c_a_fraction_width,
      use_preadder       => use_preadder,
      c_operation        => c_operation);
    assert not(debug) report "pkg: postprocessing_delay " & integer'image(postprocessing_delay) severity note;

    recombination_delay := flt_pt_recip_recombination_delay(
      c_operation => c_operation);
    assert not(debug) report "pkg: recombination_delay " & integer'image(recombination_delay) severity note;

    delay := reduction_calc_delay + evaluation_delay + postprocessing_delay + recombination_delay;

    assert not(debug) report "DEBUG: Reciprocal/Reciprocal Sqrt max delay is " & integer'image(delay) severity note;

    return delay;
  end function flt_pt_get_recip_delay;

  --------------------------------------------------------------------------------
  -- Functions for floating-point add/subtract
  --------------------------------------------------------------------------------
  -- Determine dsp adder implementation type
  function flt_pt_get_add_type(family : string; mult_usage, w, fw : integer)
    return flt_pt_imp_type is
    variable add_type : flt_pt_imp_type;
  begin
    -- Default is logic
    add_type := FLT_PT_IMP_LOGIC;
    if w = 32 and fw = 24 and (mult_usage > FLT_PT_NO_USAGE) and supports_dsp48e1(family) > 0 then
      add_type := FLT_PT_IMP_DSP48;
    end if;
    return(add_type);
  end function;

  -- Latency calculation function for the floating point adder
  function flt_pt_get_add_delay(family            : string;
                                mult_usage, w, fw : integer) return integer is
    variable delay             : integer         := 0;
    variable normalize_data    : normalize_type;
    variable alignment_data    : alignment_type;
    variable add_type          : flt_pt_imp_type := flt_pt_get_add_type(family, mult_usage, w, fw);
    variable norm_bits         : integer;
    variable addsub_align_bits : integer;
    variable addmux_align_bits : integer;
    variable renorm_and_rnd    : round_type;
    variable addsub_stages     : integer;
    variable round_usage       : integer;
    variable addsub_usage      : integer;
  begin

    case add_type is
      when FLT_PT_IMP_LOGIC =>
        round_usage  := FLT_PT_NO_USAGE;
        addsub_usage := FLT_PT_NO_USAGE;
        -- If double precision then used mult_usage to determine type
        -- **** Note that add_type could override this ****
        if mult_usage > FLT_PT_NO_USAGE then
          if w = 64 and fw = 53 then
            round_usage  := mult_usage;
            addsub_usage := mult_usage;
          end if;
        end if;

        addsub_stages := flt_pt_get_addsub_delay(addsub_usage, fw);
        renorm_and_rnd := flt_pt_get_renorm_and_round(has_addsub      => FLT_PT_YES,
                                                         optimization => FLT_PT_SPEED_OPTIMIZED,
                                                         family       => family,
                                                         mult_usage   => round_usage,
                                                         w            => w,
                                                         fw           => fw);

        norm_bits         := flt_pt_get_renorm_and_round_norm_bits(renorm_and_rnd.imp_type);
        normalize_data    := flt_pt_get_normalize(data_width => fw + 3, poss_last_bits => norm_bits);
        addsub_align_bits := flt_pt_get_addsub_bits(family);
        addmux_align_bits := flt_pt_get_addmux_bits(family);
        alignment_data := flt_pt_get_alignment(ip_width          => fw,
                                                  det_width      => fw + 2,
                                                  op_width       => fw + 2,
                                                  poss_last_bits => addsub_align_bits + addmux_align_bits);
        delay := 2;                     -- Input and multiplexer stages
        delay := delay + alignment_data.stage;
        delay := delay + flt_pt_get_addsub_delay(addsub_usage, fw);
        delay := delay + normalize_data.norm_stage;
        delay := delay + renorm_and_rnd.stages;
        delay := delay + 1;             -- Output stage

      when FLT_PT_IMP_DSP48 =>
        if supports_dsp48e1(family) > 0 then
          delay := 12;
        else
          delay := 16;
        end if;

      when others =>
        report "Internal error : flt_pt_add_delay does not support requested add_type.";
        delay := 0;
    end case;

    return delay;
  end function flt_pt_get_add_delay;

  --------------------------------------------------------------------------------
  -- Multiply
  --------------------------------------------------------------------------------

  -- Determines which variant of multiplier to use
  function flt_pt_get_fix_mult_variant(family                          : string;
                                       optimization, mult_usage, w, fw : integer)
    return flt_pt_fix_mult_type is

    variable variant : flt_pt_fix_mult_type;
  begin
    if (mult_usage = FLT_PT_NO_USAGE) then
      variant := FLT_PT_FIX_MULT_QQ;    -- Use enhanced radix-8 multiplier
    else
      -- For DSP48-based multipliers use Xilinx mult_gen
      if (supports_dsp48e1(family) > 0 and
          w = 64 and fw = 53 and
          MULT_USAGE /= FLT_PT_NO_USAGE) then
        if (optimization = FLT_PT_LOW_LATENCY) then
          variant := FLT_PT_FIX_MULT_DSP48E1_LAT_DBL;
        elsif (optimization = FLT_PT_SPEED_OPTIMIZED) then
          variant := FLT_PT_FIX_MULT_DSP48E1_SPD_DBL;
        else
          variant := FLT_PT_FIX_MULT_GEN;
        end if;
      elsif (supports_dsp48e1(family) > 0 and
             w = 32 and fw = 24 and
             MULT_USAGE = FLT_PT_MAX_USAGE and
             optimization = FLT_PT_SPEED_OPTIMIZED) then
        variant := FLT_PT_FIX_MULT_DSP48E1_SPD_SGL;
      else
        variant := FLT_PT_FIX_MULT_GEN;
      end if;
    end if;
    return(variant);
  end function flt_pt_get_fix_mult_variant;

  -- Determines type of the QinetiQ multiplier
  function flt_pt_get_xmult_type(fw : integer; family : string; mult_usage : integer) return integer is
  begin
    case mult_usage is
      when FLT_PT_NO_USAGE =>
        return(1);
      when FLT_PT_MEDIUM_USAGE =>
        if fw = 53 then
          -- DSP48 + logic
          return(7);
        else
          -- DSP48 only
          return(6);
        end if;
      when FLT_PT_FULL_USAGE | FLT_PT_MAX_USAGE => return(6);
      when others =>
        assert false
          report "ERROR in flt_pt_get_xmult_type: mult_usage value not supported"
          severity error;
        return(0);                      -- dummy
    end case;
  end function flt_pt_get_xmult_type;

  -- Determines type of fixed-point multiplier, taking into account mult_usage
  function flt_pt_get_mult_gen_imp_type(mult_usage : integer) return flt_pt_imp_type is
    variable fix_mult_type : flt_pt_imp_type;
  begin
    if mult_usage = FLT_PT_NO_USAGE then
      fix_mult_type := FLT_PT_IMP_LOGIC;
    else
      fix_mult_type := FLT_PT_IMP_DSP48;
    end if;
    return(fix_mult_type);
  end function flt_pt_get_mult_gen_imp_type;

  -- Determines the number of bits from cascade output of fixed-point multiplier
  function flt_pt_get_fix_mult_top_width(fw : integer; family : string) return integer is
    variable top_width : integer;
  begin
    if fw > 68 then
      assert (false)
        report "ERROR in flt_pt_get_fix_mult_top_width: Multiplier size too large. " &
        "Please contact Xilinx technical support."
        severity error;
      top_width := 0;
    else
      if supports_dsp48e1(family) > 0 then
        if fw <= 17 then
          top_width := 2 * FW;
        elsif fw <= 24 then
          top_width := 2 * FW - 17;
        elsif fw <= 41 then
          top_width := 2 * FW - 34;
        elsif fw <= 58 then
          top_width := 2 * FW - 68;
        elsif fw <= 68 then
          top_width := 2 * FW - 102;
        end if;
      else                              -- 18 by 18 mults
        if FW <= 17 then
          top_width := 2 * FW;
        elsif FW <= 34 then
          top_width := 2 * FW - 34;
        elsif FW <= 51 then
          top_width := 2 * FW - 68;
        else
          top_width := 2 * FW - 102;
        end if;
      end if;
    end if;
    return(top_width);
  end function flt_pt_get_fix_mult_top_width;

  -- Purpose: Provides delay of fixed-point multiplier
  function flt_pt_get_fix_mult_delay(w, fw                    : integer;
                                     family                   : string;
                                     optimization, mult_usage : integer) return integer is
    variable fix_mult : fix_mult_type;
  begin
    fix_mult := flt_pt_get_fix_mult(family       => family,
                                    optimization => optimization,
                                    mult_usage   => mult_usage,
                                    w            => w,
                                    fw           => fw);
    return (fix_mult.stages);
  end function flt_pt_get_fix_mult_delay;

  -- Purpose: Selects a fixed-point multiplier
  function flt_pt_get_fix_mult(family                          : string;
                               optimization, mult_usage, w, fw : integer) return fix_mult_type is
    variable fix_mult : fix_mult_type;
    variable delay    : integer;
    variable op_reg   : boolean;
  begin
    -- Get the multiplier variant
    fix_mult.variant := flt_pt_get_fix_mult_variant(family         => family,
                                                      optimization => optimization,
                                                      mult_usage   => mult_usage,
                                                      w            => w,
                                                      fw           => fw);
    if fix_mult.variant = FLT_PT_FIX_MULT_QQ then
      fix_mult.qq_imp_type := flt_pt_get_xmult_type(family     => family,
                                                    fw         => fw,
                                                    mult_usage => mult_usage);
    elsif fix_mult.variant = FLT_PT_FIX_MULT_GEN then
      fix_mult.xx_imp_type := flt_pt_get_mult_gen_imp_type(mult_usage => mult_usage);
    end if;

    -- The default is to not to add an output register to the basic multiplier.
    -- Note that some variants will always have an output register and some will not.
    fix_mult.op_reg := false;

    -- In general the multipliers do not support result from DSP48 cascade (for optimized rounding)
    fix_mult.cascade := false;

    case fix_mult.variant is
      when FLT_PT_FIX_MULT_QQ =>
        -- Fall back to QQ multiplier
        fix_mult.op_reg  := false;
        fix_mult.cascade := false;
        case fix_mult.qq_imp_type is  -- special encoding values for QQ multiplier: only 1, 6 and 7 are used
          when 1 =>                     -- logic
            if fw <= 5 then             -- 3 + 2
              fix_mult.stages := 3;
            elsif fw <= 11 then         -- 6 + 5
              fix_mult.stages := 4;
            elsif fw <= 23 then         -- 12 + 11
              fix_mult.stages := 5;
            elsif fw <= 47 then         -- 24 + 23
              fix_mult.stages := 6;
            elsif fw <= 95 then         -- 48 + 47
              fix_mult.stages := 7;
            elsif fw <= 191 then        -- 96 + 95
              fix_mult.stages := 8;
            else
              assert (false)
                report "ERROR in flt_pt_get_fix_mult: Unsupported logic multiplier size."
                severity error;
              fix_mult.stages := 0;
            end if;
          when 7 =>
            -- DSP48 + logic
            if fw = 53 then
              fix_mult.stages := 15;
            else
              assert (false)
                report "ERROR in flt_pt_get_fix_mult: FLT_PT_MED_USAGE not supported " &
                "by QQ multiplier for chosen wordlength."
                severity error;
              fix_mult.stages := 0;
            end if;
          when others =>
            report "ERROR in flt_pt_get_fix_mult : Multiplier type not supported (QQ).";
            fix_mult.stages := 0;
        end case;
      when FLT_PT_FIX_MULT_GEN =>
        fix_mult.op_reg := true;        -- Include, unless otherwise specified
        case fix_mult.xx_imp_type is
          when FLT_PT_IMP_LOGIC =>
            -- Use Xilinx logic multiplier
            if fw <= 4 then
              fix_mult.stages := 3;     -- Extra cycle for zero detect
            elsif fw <= 8 then
              fix_mult.stages := 4;
            elsif fw <= 16 then
              fix_mult.stages := 5;
            elsif fw <= 32 then
              fix_mult.stages := 6;
            elsif fw <= 64 then
              fix_mult.stages := 7;
            elsif fw <= 128 then
              fix_mult.stages := 8;
            else
              assert (false)
                report "ERROR in flt_pt_get_fix_mult: Unsupported logic multiplier size."
                severity error;
              fix_mult.stages := 0;
            end if;
          when FLT_PT_IMP_DSP48 =>
            if supports_dsp48a1(family) > 0 then
              if mult_usage = FLT_PT_MEDIUM_USAGE then
                if fw = 24 then
                  fix_mult.stages := 7;  -- with input register and zero detect
                else
                  assert (false)
                    report "ERROR in flt_pt_get_fix_mult: For DSP48A architecture FLT_PT_MEDIUM_USAGE not supported " &
                    "by Xilinx multiplier for chosen wordlength."
                    severity error;
                  fix_mult.stages := 0;
                end if;
              elsif mult_usage = FLT_PT_FULL_USAGE then
                fix_mult.op_reg  := false;
                fix_mult.cascade := true;
                if fw            <= 17 then
                  -- In this case we need a register
                  fix_mult.op_reg := true;
                  fix_mult.stages := 4;
                elsif fw <= 34 then
                  fix_mult.stages := 8;
                elsif fw <= 51 then
                  fix_mult.stages := 15;
                elsif fw <= 68 then
                  fix_mult.stages := 24;
                else
                  assert (false)
                    report "ERROR in flt_pt_get_fix_mult: For DSP48A architecture " &
                    "FLT_PT_FULL_USAGE not supported " &
                    "by Xilinx multiplier for chosen wordlength."
                    severity error;
                  fix_mult.stages := 0;
                end if;
              elsif mult_usage = FLT_PT_MAX_USAGE then
                fix_mult.op_reg  := false;
                fix_mult.cascade := true;
                if fw            <= 17 then
                  fix_mult.stages := 3;
                elsif fw <= 34 then
                  fix_mult.stages := 8;
                elsif fw <= 51 then
                  fix_mult.stages := 15;
                elsif fw <= 68 then
                  fix_mult.stages := 24;
                else
                  assert (false)
                    report "ERROR in flt_pt_get_fix_mult: For DSP48A architecture " &
                    "FLT_PT_MAX_USAGE not supported " &
                    "by Xilinx multiplier for chosen wordlength."
                    severity error;
                  fix_mult.stages := 0;
                end if;
              end if;
            elsif supports_dsp48e1(family) > 0 then
              if (mult_usage = FLT_PT_FULL_USAGE or
                  mult_usage = FLT_PT_MAX_USAGE) then
                if fw <= 17 then
                  fix_mult.stages := 2 + 1 + 1;
                elsif fw <= 24 then
                  fix_mult.stages := 2 + 2 + 1;
                elsif fw <= 34 then
                  fix_mult.stages := 2 + 4 + 1;
                elsif fw <= 41 then
                  fix_mult.stages := 2 + 6 + 1;
                elsif fw <= 51 then
                  fix_mult.stages := 2 + 9 + 1;
                elsif fw <= 58 then
                  fix_mult.stages := 2 + 12 + 1;
                elsif fw <= 68 then
                  fix_mult.stages := 2 + 16 + 1;
                else
                  assert (false)
                    report "ERROR in flt_pt_get_fix_mult: For DSP48E architecture multiplier size too large " &
                    "for Xilinx multiplier."
                    severity error;
                  fix_mult.stages := 0;
                end if;
              else
                if fw = 24 then
                  fix_mult.stages := 6;  -- input register
                else
                  assert (false)
                    report "ERROR in flt_pt_get_fix_mult: For DSP48E architecture FLT_PT_MED_USAGE not supported."
                    severity error;
                  fix_mult.stages := 0;
                end if;
              end if;
            else
              report "ERROR in flt_pt_get_fix_mult: could not identify type of DSP48 (MULT_GEN)."
                severity error;
            end if;
          when others =>
            assert (false)
              report "ERROR in flt_pt_get_fix_mult: For chosen architecture multiplier type not supported (MULT_GEN)."
              severity error;
        end case;  -- implementation type
      when FLT_PT_FIX_MULT_DSP48E1_LAT_DBL =>
        fix_mult.stages := 8;
      when FLT_PT_FIX_MULT_DSP48E1_SPD_DBL =>
        fix_mult.stages := 12;
      when FLT_PT_FIX_MULT_DSP48E1_SPD_SGL =>
        fix_mult.stages := 4;
      when others =>
        assert (false)
          report "ERROR in flt_pt_get_fix_mult : Multiplier type not supported."
          severity error;
        fix_mult.stages := 0;
    end case;  --variant
    return(fix_mult);

  end function flt_pt_get_fix_mult;

  -- Provides type of float-point multiplier type
  function flt_pt_get_mult_type(family                          : string;
                                optimization, mult_usage, w, fw : integer)
    return flt_pt_mult_type is
    variable mult_type : flt_pt_mult_type;
  begin
    if (optimization = FLT_PT_SPEED_OPTIMIZED and
        supports_dsp48e1(family) > 0 and
        w = 64 and fw = 53 and
        mult_usage /= FLT_PT_NO_USAGE) then
      mult_type := FLT_PT_MULT_DSP48E1_SPD_DBL;
    elsif (optimization = FLT_PT_LOW_LATENCY and
           supports_dsp48e1(family) > 0 and
           w = 64 and fw = 53 and
           mult_usage /= FLT_PT_NO_USAGE) then
      mult_type := FLT_PT_MULT_DSP48E1_LAT_DBL;
    elsif (optimization = FLT_PT_SPEED_OPTIMIZED and
           supports_dsp48e1(family) > 0 and
           w = 32 and fw = 24 and
           mult_usage = FLT_PT_MAX_USAGE) then
      mult_type := FLT_PT_MULT_DSP48E1_SPD_SGL;
    elsif supports_dsp48e1(family) > 0 then
      mult_type := FLT_PT_MULT_DSP48E1;
    elsif supports_dsp48a1(family) > 0 then
      mult_type := FLT_PT_MULT_DSP48A1;
    else
      mult_type := FLT_PT_MULT_LOGIC;
    end if;
    return(mult_type);
  end function;

  -- Provides fully-pipelined delay of floating-point multiplier
  function flt_pt_get_flt_mult_delay(width, fraction_width    : integer; family : string;
                                     optimization, mult_usage : integer) return integer is

    variable mult : flt_mult_type;
  begin
    -- Multiplier
    mult := flt_pt_get_mult(optimization => optimization,
                            family       => family,
                            mult_usage   => mult_usage,
                            w            => width,
                            fw           => fraction_width);
    return mult.stages;
  end function;

  -- Provides configuration for floating-point multiplier
  function flt_pt_get_mult(
    family       : string;
    optimization : integer;
    mult_usage   : integer;
    w            : integer;
    fw           : integer)
    return flt_mult_type is

    variable mult_config : flt_mult_type;
  begin

    mult_config.exp_speed := flt_pt_fast_family(family);

    -- Get the multiplier variant
    mult_config.fix_mult_config := flt_pt_get_fix_mult(family       => family,
                                                       optimization => optimization,
                                                       mult_usage   => mult_usage,
                                                       w            => w,
                                                       fw           => fw);


    mult_config.round_config := flt_pt_get_renorm_and_round(has_multiply => FLT_PT_YES,
                                                            optimization => optimization,
                                                            family       => family,
                                                            mult_usage   => mult_usage,
                                                            w            => w,
                                                            fw           => fw);

    if (mult_config.round_config.optimized) then
      -- normalization distance added in output stage
      mult_config.exp_op_stage := mult_config.fix_mult_config.stages + mult_config.round_config.exp_stage;
    else
      mult_config.exp_op_stage := mult_config.fix_mult_config.stages;
    end if;

    -- Total number of stages overall
    mult_config.stages := mult_config.round_config.stages + mult_config.fix_mult_config.stages + 1;

    return(mult_config);
  end function;

  --------------------------------------------------------------------------------
  -- Other operator functions
  --------------------------------------------------------------------------------
  -- Provides the fully pipelined delay of the floating point divider
  function flt_pt_get_div_delay(w, fw : integer) return integer is
  begin
    return fw + 4;
  end function flt_pt_get_div_delay;

  -- Provides the fully pipelined delay of the floating point square root
  function flt_pt_get_sqrt_delay(w, fw : integer) return integer is
  begin
    return fw + 4;
  end function flt_pt_get_sqrt_delay;

  -- Provides configuration of the floating-point adder
  function flt_pt_get_flt_add(
    C_XDEVICEFAMILY    : string;
    C_MULT_USAGE       : integer;
    C_HAS_ADD          : integer;
    C_HAS_SUBTRACT     : integer;
    C_HAS_FIX_TO_FLT   : integer;
    C_HAS_FLT_TO_FIX   : integer;
    C_A_WIDTH          : integer;
    C_A_FRACTION_WIDTH : integer)
    return flt_add_type is
    variable add_stage         : flt_add_type;
    variable align_stages      : alignment_type;
    variable norm_stages       : normalize_type;
    variable ab_extw           : integer;
    variable addmux_align_bits : integer;
    variable addsub_align_bits : integer;
  begin
    if (C_HAS_FIX_TO_FLT = FLT_PT_YES or C_HAS_FLT_TO_FIX = FLT_PT_YES) then
      ab_extw := C_A_WIDTH;
    else
      ab_extw := C_A_FRACTION_WIDTH;
    end if;

    add_stage.ab_extw := ab_extw;

    addmux_align_bits := flt_pt_get_addmux_bits(C_XDEVICEFAMILY);
    addsub_align_bits := flt_pt_get_addsub_bits(C_XDEVICEFAMILY);

    align_stages := flt_pt_get_alignment(ip_width       => ab_extw,
                                         det_width      => ab_extw + 2,
                                         op_width       => ab_extw + 2,
                                         poss_last_bits => addmux_align_bits + addsub_align_bits);

    norm_stages := flt_pt_get_normalize(data_width     => ab_extw + 1,
                                        poss_last_bits => 2);  -- for low_latency adder

    add_stage.round_config := flt_pt_get_renorm_and_round(optimization => FLT_PT_LOW_LATENCY,
                                                          family       => C_XDEVICEFAMILY,
                                                          mult_usage   => C_MULT_USAGE,
                                                          w            => C_A_WIDTH,
                                                          fw           => C_A_FRACTION_WIDTH);

    add_stage.last_stage         := norm_stages.last_stage;
    add_stage.last_bits          := norm_stages.last_bits;
    add_stage.mux_stage          := 1;
    add_stage.align_stage        := 2;
    add_stage.add_stage          := align_stages.stage + add_stage.align_stage;
    add_stage.align_add_op_stage := add_stage.add_stage + 1;
    add_stage.lod_stage          := 2;
    add_stage.can_stage          := add_stage.lod_stage + norm_stages.can_stage;
    add_stage.norm_op_stage      := norm_stages.norm_stage + 2;
    add_stage.dist_stage         := norm_stages.norm_stage + 2;
    add_stage.sel_stage          := flt_pt_max(add_stage.norm_op_stage, add_stage.align_add_op_stage);
    add_stage.rnd_stage          := add_stage.sel_stage + 1;
    add_stage.op_stage           := add_stage.rnd_stage + 1;
    add_stage.stages             := add_stage.op_stage + 1;

    return (add_stage);
  end function;

  --------------------------------------------------------------------------------
  -- Function to provide latency for the calculation of a particular operation
  -- This is the latency of the core excluding latency incurred by AXI flow control
  --------------------------------------------------------------------------------
  function flt_pt_calc_delay(family                : string;
                             op_code               : std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
                             a_width               : integer;
                             a_fraction_width      : integer;
                             b_width               : integer;
                             b_fraction_width      : integer;
                             result_width          : integer;
                             result_fraction_width : integer;
                             optimization          : integer;
                             mult_usage            : integer;
                             rate                  : integer;
                             throttle_scheme       : integer;
                             has_add               : integer := 0;
                             has_subtract          : integer := 0;
                             has_multiply          : integer := 0;
                             has_divide            : integer := 0;
                             has_sqrt              : integer := 0;
                             has_compare           : integer := 0;
                             has_fix_to_flt        : integer := 0;
                             has_flt_to_fix        : integer := 0;
                             has_flt_to_flt        : integer := 0;
                             has_recip             : integer := 0;
                             has_recip_sqrt        : integer := 0;
                             required              : integer := FLT_PT_MAX_LATENCY
                             )
    return integer is

    constant result_exponent_width : integer := result_width - result_fraction_width;
    variable del                   : integer;
    variable max_lat               : integer;
    variable mult_type             : integer;
    variable numb_ones             : integer;
    variable req_lat               : integer;
    variable add_stages            : flt_add_type;
  begin
    -- Determine maximum latency for particular parameters
    case op_code is
      when FLT_PT_ADD_OP_CODE_SLV | FLT_PT_SUBTRACT_OP_CODE_SLV =>
        if optimization = FLT_PT_LOW_LATENCY then
          add_stages := flt_pt_get_flt_add(C_XDEVICEFAMILY    => family,
                                           C_MULT_USAGE       => FLT_PT_NO_USAGE,  -- Logic only
                                           C_HAS_ADD          => has_add,
                                           C_HAS_SUBTRACT     => has_subtract,
                                           C_HAS_FIX_TO_FLT   => has_fix_to_flt,
                                           C_HAS_FLT_TO_FIX   => has_flt_to_fix,
                                           C_A_WIDTH          => a_width,
                                           C_A_FRACTION_WIDTH => a_fraction_width);
          max_lat := add_stages.stages;
        elsif optimization = FLT_PT_SPEED_OPTIMIZED then
          max_lat := flt_pt_get_add_delay(family,
                                          mult_usage,
                                          result_width,
                                          result_fraction_width);
          if (MULT_USAGE = FLT_PT_FULL_USAGE and
              a_width = 64 and a_fraction_width = 53) then
            -- if we have a double precision, max_usage variant, then reduce latency
            max_lat := max_lat - 1;
          elsif (supports_dsp48e1(family) > 0 and
                 MULT_USAGE = FLT_PT_FULL_USAGE and
                 a_width = 32 and a_fraction_width = 24) then
            -- if we have a single precision, DSP48E1-based, max_usage variant, then reduce latency
            max_lat := max_lat - 1;
          end if;
        end if;
      when FLT_PT_MULTIPLY_OP_CODE_SLV =>
        max_lat := flt_pt_get_flt_mult_delay(result_width,
                                             result_fraction_width,
                                             family,
                                             optimization,
                                             mult_usage);
      when FLT_PT_DIVIDE_OP_CODE_SLV =>
        max_lat := flt_pt_get_div_delay(result_width, result_fraction_width);

      when FLT_PT_SQRT_FTF_OP_CODE_SLV =>
        -- For extended operations, like float-to-float and reciprocal, the op
        -- code is always "111" because only 3 bits are permitted (for backwards-compatibility)
        -- So we refine the op_code value based on generics too
        -- REVISIT: This is not ideal; we should be able to do away with the opcodes completely
        if has_flt_to_flt = FLT_PT_YES then
          max_lat := flt_pt_flt_to_flt_delay(a_width,
                                             a_fraction_width,
                                             result_width,
                                             result_fraction_width);
        elsif has_recip = FLT_PT_YES then
          max_lat := flt_pt_get_recip_delay(C_XDEVICEFAMILY    => family,
                                            C_MULT_USAGE       => mult_usage,
                                            C_A_WIDTH          => a_width,
                                            C_A_FRACTION_WIDTH => a_fraction_width,
                                            C_OPERATION        => FLT_PT_RECIP_OP_CODE);
        elsif has_recip_sqrt = FLT_PT_YES then
          max_lat := flt_pt_get_recip_delay(C_XDEVICEFAMILY    => family,
                                            C_MULT_USAGE       => mult_usage,
                                            C_A_WIDTH          => a_width,
                                            C_A_FRACTION_WIDTH => a_fraction_width,
                                            C_OPERATION        => FLT_PT_RECIP_SQRT_OP_CODE);
        else
          max_lat := flt_pt_get_sqrt_delay(result_width, result_fraction_width);
        end if;
      when FLT_PT_FIX_TO_FLT_OP_CODE_SLV =>
        max_lat := flt_pt_fix_to_flt_delay(a_width,
                                            3);
      when FLT_PT_FLT_TO_FIX_OP_CODE_SLV =>
        max_lat := flt_pt_flt_to_fix_delay(a_width,
                                            a_fraction_width,
                                            result_width,
                                            result_fraction_width);
      when FLT_PT_COMPARE_OP_CODE_SLV =>
        max_lat := 2;
      when others =>
        max_lat := 0;
    end case;

    -- Determine delay based on type of request.
    -- Check for special bit string
    if required >= FLT_PT_LATENCY_BIAS then
      -- Registers given by bit pattern
      req_lat   := required - FLT_PT_LATENCY_BIAS;  -- remove bias
      -- Remove all bits that are out of bounds
      req_lat   := req_lat mod (2 ** max_lat);
      -- Count ones to establish latency
      numb_ones := 0;
      while req_lat > 0 loop
        numb_ones := req_lat mod 2 + numb_ones;
        req_lat   := req_lat / 2;
      end loop;
      del := numb_ones;

      -- Check is reduced latency is required
    elsif required /= FLT_PT_MAX_LATENCY then
      -- Required is less than maximum, so use required
      -- Subtract the latency incurred by AXI flow control first
      del := required - flt_pt_axi_ctrl_delay(throttle_scheme);
    else
      del := max_lat;
    end if;
    return(del);
  end function flt_pt_calc_delay;

  --------------------------------------------------------------------------------
  -- function to provide latency incurred by AXI flow control
  --------------------------------------------------------------------------------
  function flt_pt_axi_ctrl_delay(c_throttle_scheme : integer)
    return integer is
    constant COMBINER_LATENCY : integer := 1;
    constant FIFO_LATENCY     : integer := 2;
    variable latency          : integer := 0;
  begin
    case c_throttle_scheme is
      when CI_CE_THROTTLE =>
        latency := COMBINER_LATENCY;
      when CI_RFD_THROTTLE =>
        latency := COMBINER_LATENCY + FIFO_LATENCY;
      when CI_GEN_THROTTLE =>
        latency := COMBINER_LATENCY;
      when CI_AND_TVALID_THROTTLE =>
        latency := 0;
      when others =>
        null;
    end case;
    return latency;
  end function flt_pt_axi_ctrl_delay;

  --------------------------------------------------------------------------------
  -- Function to provide latency of the core
  --------------------------------------------------------------------------------
  function flt_pt_delay(family                : string;
                        op_code               : std_logic_vector(FLT_PT_OP_CODE_WIDTH-1 downto 0);
                        a_width               : integer;
                        a_fraction_width      : integer;
                        b_width               : integer;
                        b_fraction_width      : integer;
                        result_width          : integer;
                        result_fraction_width : integer;
                        optimization          : integer;
                        mult_usage            : integer;
                        rate                  : integer;
                        throttle_scheme       : integer;
                        has_add               : integer := 0;
                        has_subtract          : integer := 0;
                        has_multiply          : integer := 0;
                        has_divide            : integer := 0;
                        has_sqrt              : integer := 0;
                        has_compare           : integer := 0;
                        has_fix_to_flt        : integer := 0;
                        has_flt_to_fix        : integer := 0;
                        has_flt_to_flt        : integer := 0;
                        has_recip             : integer := 0;
                        has_recip_sqrt        : integer := 0;
                        required              : integer := FLT_PT_MAX_LATENCY
                        )
    return integer is
    variable latency : integer;
  begin
    -- Latency is the sum of AXI control latency and operator calculation latency
    latency := flt_pt_axi_ctrl_delay(c_throttle_scheme => throttle_scheme);
    latency := latency + flt_pt_calc_delay(family                => family,
                                           op_code               => op_code,
                                           a_width               => a_width,
                                           a_fraction_width      => a_fraction_width,
                                           b_width               => b_width,
                                           b_fraction_width      => b_fraction_width,
                                           result_width          => result_width,
                                           result_fraction_width => result_fraction_width,
                                           optimization          => optimization,
                                           mult_usage            => mult_usage,
                                           rate                  => rate,
                                           throttle_scheme       => throttle_scheme,
                                           has_add               => has_add,
                                           has_subtract          => has_subtract,
                                           has_multiply          => has_multiply,
                                           has_divide            => has_divide,
                                           has_sqrt              => has_sqrt,
                                           has_compare           => has_compare,
                                           has_fix_to_flt        => has_fix_to_flt,
                                           has_flt_to_fix        => has_flt_to_fix,
                                           has_flt_to_flt        => has_flt_to_flt,
                                           has_recip             => has_recip,
                                           has_recip_sqrt        => has_recip_sqrt,
                                           required              => required);
    return latency;
  end function flt_pt_delay;

  -- Minimum width of exponent field
  function flt_pt_get_min_exp(fw : integer) return integer is
  begin
    return(flt_pt_get_n_bits(fw + 2) + 1);
  end function;

  -- Check that a floating point exponent is large enough to handle a fixed point data format
  function flt_pt_exp_check(flt_w, flt_fw, fw : integer) return boolean is
  begin
    -- Check that the exponent is large enough to support the fraction
    return (flt_pt_get_min_exp(fw) <= flt_w - flt_fw);
  end function;

  -- Check fixed and floating point data formats are compatible for conversion
  function fixed_pt_exp_check(flt_w, flt_fw, fix_w, fix_fw : integer;
                              flt_name, fix_name           : string) return boolean is
    variable pass : boolean := true;
  begin
    if not (flt_pt_exp_check(flt_w, flt_fw, fix_w)) then
      report "ERROR: fixed_pt_exp_check:"
        & " The exponent of the floating-point number"
        & " which is " & integer'image(flt_w - flt_fw)
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small to support the fixed-point number"
        & " (as defined by C_" & fix_name & "_WIDTH and "
        & " C_" & fix_name & "_FRACTION_WIDTH)." & CR
        & " Increase the exponent width to "
        & integer'image(flt_pt_get_min_exp(fix_w)) & "." & CR
        & " Note that each bit of exponent doubles the number of "
        & " fraction bits supported. Or reduce the total width of"
        & " the fixed-point number.";
      pass := false;
    end if;
    return pass;
  end function;

  -- Check floating point data format
  function flt_pt_check(w, fw : integer; flt_name : string) return boolean is
    variable pass : boolean := true;
  begin
    if not (flt_pt_exp_check(w, fw, fw)) then
      report "ERROR: flt_pt_check:"
        & "The exponent width"
        & " which is " & integer'image(w - fw)
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small to support the chosen fraction width"
        & " C_" & flt_name & "_FRACTION_WIDTH."
        & " Increase the exponent width to "
        & integer'image(flt_pt_get_min_exp(fw)) & "." & CR
        & " Note that each extra bit of exponent doubles the number of "
        & " fraction bits supported.";
      pass := false;
    end if;

    -- Check exponent width larger than minimum
    if not (w - fw >= FLT_PT_MIN_EW) then
      report "ERROR: flt_pt_check:"
        & "The exponent width"
        & " which is " & integer'image(w - fw)
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value supported by the core is "
        & integer'image(FLT_PT_MIN_EW) & ".";
      pass := false;
    end if;

    -- Check exponent is not larger than maximum
    if not (w - fw <= FLT_PT_MAX_EW) then
      report "ERROR: flt_pt_check:"
        & "The exponent width"
        & " which is " & integer'image(w - fw)
        & " (as given by C_" & flt_name & "_WIDTH - C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too large. Maximum value supported by the core is "
        & integer'image(FLT_PT_MAX_EW) & ".";
      pass := false;
    end if;

    -- Check fraction width larger than minimum
    if not (fw >= FLT_PT_MIN_FW) then
      report "ERROR: flt_pt_check:"
        & "The fraction width"
        & " which is " & integer'image(fw)
        & " (as given by C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value supported by the core is "
        & integer'image(FLT_PT_MIN_FW) & ".";
      pass := false;
    end if;

    -- Check fraction width is not larger than maximum
    if not (fw <= FLT_PT_MAX_FW) then
      report "ERROR: flt_pt_check:"
        & "The fraction width"
        & " which is " & integer'image(fw)
        & " (as given by C_" & flt_name
        & "_FRACTION_WIDTH)" & CR
        & " is too large. Maximum value supported by the core is "
        & integer'image(FLT_PT_MAX_FW) & ".";
      pass := false;
    end if;
    return pass;
  end function;

  -- Check fixed point data format
  function fixed_pt_check(fix_w, fix_fw : integer; fix_name : string) return boolean is
    variable pass : boolean := true;
  begin
    -- Check fraction width larger than minimum
    if not (fix_fw >= FIX_PT_MIN_FW) then
      report "ERROR: fixed_pt_check:"
        & "The fraction width"
        & " which is " & integer'image(fix_fw)
        & " (as given by C_" & fix_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value is "
        & integer'image(FIX_PT_MIN_FW) & ".";
      pass := false;
    end if;

    -- Check fraction width is not larger than maximum
    if not (fix_fw <= FIX_PT_MAX_FW) then
      report "ERROR: fixed_pt_check:"
        & "The fraction width"
        & " which is " & integer'image(fix_fw)
        & " (as given by C_" & fix_name
        & "_FRACTION_WIDTH)" & CR
        & " is too large. Maximum value is "
        & integer'image(FIX_PT_MAX_FW) & ".";
      pass := false;
    end if;

    -- Check integer width larger than minimum
    if not (fix_w - fix_fw >= FIX_PT_MIN_IW) then
      report "ERROR: fixed_pt_check:"
        & "The integer width"
        & " which is " & integer'image(fix_w - fix_fw)
        & " (as given by C_" & fix_name
        & "_WIDTH - C_" & fix_name
        & "_FRACTION_WIDTH)" & CR
        & " is too small. Minimum value is "
        & integer'image(FIX_PT_MIN_IW) & ".";
      pass := false;
    end if;

    -- Check total width is not smaller than minimum
    if not ((fix_w) >= FIX_PT_MIN_W) then
      report "ERROR: fixed_pt_check:"
        & "The total width"
        & " which is " & integer'image(fix_w)
        & " (as given by C_" & fix_name
        & "_WIDTH)" & CR
        & " is too small. Maximum value is "
        & integer'image(FIX_PT_MIN_W) & ".";
      pass := false;
    end if;

    -- Check total width is not larger than maximum
    if not ((fix_w) <= FIX_PT_MAX_W) then
      report "ERROR: fixed_pt_check:"
        & "The total width"
        & " which is " & integer'image(fix_w)
        & " (as given by C_" & fix_name
        & "_WIDTH)" & CR
        & " is too large. Maximum value is "
        & integer'image(FIX_PT_MAX_W) & ".";
      pass := false;
    end if;
    return pass;
  end function;

  --------------------------------------------------------------------------------
  -- Function to check top level generics and pack them into the generics_type record
  --------------------------------------------------------------------------------
  function floating_point_v6_0_check_generics(
    C_XDEVICEFAMILY         : string;
    C_HAS_ADD               : integer;
    C_HAS_SUBTRACT          : integer;
    C_HAS_MULTIPLY          : integer;
    C_HAS_DIVIDE            : integer;
    C_HAS_SQRT              : integer;
    C_HAS_COMPARE           : integer;
    C_HAS_FIX_TO_FLT        : integer;
    C_HAS_FLT_TO_FIX        : integer;
    C_HAS_FLT_TO_FLT        : integer;
    C_HAS_RECIP             : integer;
    C_HAS_RECIP_SQRT        : integer;
    C_A_WIDTH               : integer;
    C_A_FRACTION_WIDTH      : integer;
    C_B_WIDTH               : integer;
    C_B_FRACTION_WIDTH      : integer;
    C_RESULT_WIDTH          : integer;
    C_RESULT_FRACTION_WIDTH : integer;
    C_COMPARE_OPERATION     : integer;
    C_LATENCY               : integer;
    C_OPTIMIZATION          : integer;
    C_MULT_USAGE            : integer;
    C_RATE                  : integer;
    C_HAS_UNDERFLOW         : integer;
    C_HAS_OVERFLOW          : integer;
    C_HAS_INVALID_OP        : integer;
    C_HAS_DIVIDE_BY_ZERO    : integer;
    C_HAS_ACLKEN            : integer;
    C_HAS_ARESETN           : integer;
    C_THROTTLE_SCHEME       : integer;
    C_HAS_A_TUSER           : integer;
    C_HAS_A_TLAST           : integer;
    C_HAS_B                 : integer;
    C_HAS_B_TUSER           : integer;
    C_HAS_B_TLAST           : integer;
    C_HAS_OPERATION         : integer;
    C_HAS_OPERATION_TUSER   : integer;
    C_HAS_OPERATION_TLAST   : integer;
    C_HAS_RESULT_TUSER      : integer;
    C_HAS_RESULT_TLAST      : integer;
    C_TLAST_RESOLUTION      : integer;
    C_A_TDATA_WIDTH         : integer;
    C_A_TUSER_WIDTH         : integer;
    C_B_TDATA_WIDTH         : integer;
    C_B_TUSER_WIDTH         : integer;
    C_OPERATION_TDATA_WIDTH : integer;
    C_OPERATION_TUSER_WIDTH : integer;
    C_RESULT_TDATA_WIDTH    : integer;
    C_RESULT_TUSER_WIDTH    : integer
    ) return generics_type is

    -- Record of generics' values
    variable generics : generics_type := GENERICS_TYPE_DEFAULT;

    variable tuser_width : integer;
    variable max_rate    : integer;
    type channels_type is array (1 to 3) of integer;
    variable channels    : channels_type;

    constant S_OP_NAME : string := "speed optimized";
    constant HEADER    : string := "ERROR: floating_point_v6_0_check_generics: ";
    constant N_OPS : integer := flt_pt_number_of_operations(C_HAS_ADD,
                                                            C_HAS_SUBTRACT,
                                                            C_HAS_MULTIPLY,
                                                            C_HAS_DIVIDE,
                                                            C_HAS_SQRT,
                                                            C_HAS_COMPARE,
                                                            C_HAS_FIX_TO_FLT,
                                                            C_HAS_FLT_TO_FIX,
                                                            C_HAS_FLT_TO_FLT,
                                                            C_HAS_RECIP,
                                                            C_HAS_RECIP_SQRT);
    variable pass : boolean := true;
  begin

    -------------------------------------------------------------------------------
    -- Check optimization (do this early as many other generics are affected by it)
    -------------------------------------------------------------------------------
    if not ((C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED) or
            (C_OPTIMIZATION = FLT_PT_LOW_LATENCY)) then
      report HEADER & "Illegal value for C_OPTIMIZATION, must be " &
        integer'image(FLT_PT_SPEED_OPTIMIZED) & " or " &
        integer'image(FLT_PT_LOW_LATENCY) & ".";
      pass := false;
    end if;
    generics.c_optimization := C_OPTIMIZATION;

    -------------------------------------------------------------------------------
    -- Check operations
    -------------------------------------------------------------------------------
    if C_HAS_ADD /= 0 and C_HAS_ADD /= 1 then
      report HEADER & "Illegal value for C_HAS_ADD: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_SUBTRACT /= 0 and C_HAS_SUBTRACT /= 1 then
      report HEADER & "Illegal value for C_HAS_SUBTRACT: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_MULTIPLY /= 0 and C_HAS_MULTIPLY /= 1 then
      report HEADER & "Illegal value for C_HAS_MULTIPLY: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_DIVIDE /= 0 and C_HAS_DIVIDE /= 1 then
      report HEADER & "Illegal value for C_HAS_DIVIDE: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_SQRT /= 0 and C_HAS_SQRT /= 1 then
      report HEADER & "Illegal value for C_HAS_SQRT: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_COMPARE /= 0 and C_HAS_COMPARE /= 1 then
      report HEADER & "Illegal value for C_HAS_COMPARE: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_FIX_TO_FLT /= 0 and C_HAS_FIX_TO_FLT /= 1 then
      report HEADER & "Illegal value for C_HAS_FIX_TO_FLT: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_FLT_TO_FIX /= 0 and C_HAS_FLT_TO_FIX /= 1 then
      report HEADER & "Illegal value for C_HAS_FLT_TO_FIX: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_FLT_TO_FLT /= 0 and C_HAS_FLT_TO_FLT /= 1 then
      report HEADER & "Illegal value for C_HAS_FLT_TO_FLT: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_RECIP /= 0 and C_HAS_RECIP /= 1 then
      report HEADER & "Illegal value for C_HAS_RECIP: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_RECIP_SQRT /= 0 and C_HAS_RECIP_SQRT /= 1 then
      report HEADER & "Illegal value for C_HAS_RECIP_SQRT: must be 0 or 1";
      pass := false;
    end if;

    if not (N_OPS < 2 or
            ((C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED or
              C_OPTIMIZATION = FLT_PT_LOW_LATENCY) and
             -- Check that only add and subtract are selected
             N_OPS = 2 and C_HAS_SUBTRACT = FLT_PT_YES and C_HAS_ADD = FLT_PT_YES)) then
      report HEADER &
        "Only add and subtract operations can be combined.";
      pass := false;
    end if;

    if not (N_OPS > 0) then
      report HEADER &
        "At least one operation must be enabled.";
      pass := false;
    end if;

    if (C_OPTIMIZATION = FLT_PT_LOW_LATENCY) then
      if not (C_HAS_SUBTRACT = FLT_PT_YES or C_HAS_ADD = FLT_PT_YES or
              C_HAS_MULTIPLY = FLT_PT_YES) then
        report HEADER &
          "Only addition, subtraction or multiplication operations supported"
          & " by low latency core."
          & " Change operation, or set C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED.";
        pass := false;
      end if;
      if (C_HAS_SUBTRACT = FLT_PT_YES or C_HAS_ADD = FLT_PT_YES) and
        not ((C_RESULT_WIDTH = 64 and C_A_FRACTION_WIDTH = 53) or
             (C_RESULT_WIDTH = 32 and C_A_FRACTION_WIDTH = 24)) then
        report HEADER &
          "Low latency add/subtract core only supports single or double precision."
          & " Change precision, or set C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED.";
        pass := false;
      end if;

      if (C_HAS_MULTIPLY = FLT_PT_YES) and
        not ((C_RESULT_WIDTH = 64 and C_A_FRACTION_WIDTH = 53)) then
        report HEADER &
          "Low latency multiplier core only supports double precision."
          & " Change precision, or set C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED.";
        pass := false;
      end if;
    end if;

    generics.c_has_add        := C_HAS_ADD;
    generics.c_has_subtract   := C_HAS_SUBTRACT;
    generics.c_has_multiply   := C_HAS_MULTIPLY;
    generics.c_has_divide     := C_HAS_DIVIDE;
    generics.c_has_sqrt       := C_HAS_SQRT;
    generics.c_has_compare    := C_HAS_COMPARE;
    generics.c_has_fix_to_flt := C_HAS_FIX_TO_FLT;
    generics.c_has_flt_to_fix := C_HAS_FLT_TO_FIX;
    generics.c_has_flt_to_flt := C_HAS_FLT_TO_FLT;

    -------------------------------------------------------------------------------
    -- Check wordlengths: width and fraction_width
    -------------------------------------------------------------------------------
    if C_OPTIMIZATION = FLT_PT_SPEED_OPTIMIZED then
      if C_HAS_FIX_TO_FLT = FLT_PT_YES then
        -- Need to check
        --   1) fixed-point input is within bounds
        --   2) fixed-point is supported by output exponent
        --   3) floating-point result is within bounds
        pass := fixed_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        pass := fixed_pt_exp_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH,
                                   C_A_WIDTH, C_A_FRACTION_WIDTH, "RESULT", "A") and pass;

        pass := flt_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;

      elsif C_HAS_FLT_TO_FIX = FLT_PT_YES then
        -- Need to check:
        --   1) floating-point input is within bounds
        --   2) fixed-point output is within bounds
        --   3) fixed-point output is supported by input exponent
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        pass := fixed_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;

        pass := fixed_pt_exp_check(C_A_WIDTH, C_A_FRACTION_WIDTH, C_RESULT_WIDTH,
                                   C_RESULT_FRACTION_WIDTH, "A", "RESULT") and pass;

      elsif C_HAS_SQRT = FLT_PT_YES or C_HAS_RECIP = FLT_PT_YES or C_HAS_RECIP_SQRT = FLT_PT_YES then
        -- Need to check:
        --   1) floating-point input A is within bounds
        --   2) input A is same as output
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        if not (C_A_WIDTH = C_RESULT_WIDTH and
                C_A_FRACTION_WIDTH = C_RESULT_FRACTION_WIDTH) then
          report HEADER
            & "The floating-point input and result formats must be the same." & CR
            & " Set C_A_WIDTH = C_RESULT_WIDTH and" & CR
            & " C_A_FRACTION_WIDTH = C_RESULT_FRACTION_WIDTH.";
          pass := false;
        end if;
      elsif C_HAS_FLT_TO_FLT = FLT_PT_YES then
        -- Need to check:
        --   1) floating-point input A is within bounds
        --   2) input A is same as B and result
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;
        pass := flt_pt_check(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH, "RESULT") and pass;
      elsif C_HAS_COMPARE = FLT_PT_YES then
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;
        -- Need to check:
        -- 1) Result width is 1 or 4 bits depending on type of comparison
        if C_COMPARE_OPERATION /= FLT_PT_CONDITION_CODE then
          if not(C_RESULT_WIDTH = 1) then
            report HEADER
              & "C_RESULT_WIDTH must be 1 for this comparison.";
            pass := false;
          end if;
        else
          if not(C_RESULT_WIDTH = 4) then
            report HEADER
              & "C_RESULT_WIDTH must be 4 for this comparison.";
            pass := false;
          end if;
        end if;
      else
        -- Otherwise need to check:
        --   1) floating-point A input is within bounds
        --   2) input B and result are the same widths as input A
        pass := flt_pt_check(C_A_WIDTH, C_A_FRACTION_WIDTH, "A") and pass;

        if not (C_A_WIDTH = C_RESULT_WIDTH and
                C_A_FRACTION_WIDTH = C_RESULT_FRACTION_WIDTH and
                C_A_WIDTH = C_B_WIDTH and
                C_A_FRACTION_WIDTH = C_B_FRACTION_WIDTH
                ) then
          report HEADER
            & "The width parameters of floating-point inputs and result"
            & " must be the same." & CR
            & " Set C_A_WIDTH = C_RESULT_WIDTH and"
            & " C_A_FRACTION_WIDTH = C_RESULT_FRACTION_WIDTH and" & CR
            & " C_B_WIDTH = C_RESULT_WIDTH and"
            & " C_B_FRACTION_WIDTH = C_RESULT_FRACTION_WIDTH.";
          pass := false;
        end if;
      end if;
    end if;

    generics.c_a_width               := C_A_WIDTH;
    generics.c_a_fraction_width      := C_A_FRACTION_WIDTH;
    generics.c_b_width               := C_B_WIDTH;
    generics.c_b_fraction_width      := C_B_FRACTION_WIDTH;
    generics.c_result_width          := C_RESULT_WIDTH;
    generics.c_result_fraction_width := C_RESULT_FRACTION_WIDTH;

    -------------------------------------------------------------------------------
    -- Check compare operation
    -------------------------------------------------------------------------------
    if C_HAS_COMPARE = FLT_PT_YES then
      if not ((C_COMPARE_OPERATION >= 0) and (C_COMPARE_OPERATION <= 8)) then
        report HEADER & "Compare operation is out of range. Current value"
          & " C_COMPARE_OPERATION= " & integer'image(C_COMPARE_OPERATION);
        pass := false;
      end if;
    end if;
    generics.c_compare_operation := C_COMPARE_OPERATION;

    -------------------------------------------------------------------------------
    -- Check multiplier usage
    -------------------------------------------------------------------------------
    if not ((C_MULT_USAGE >= FLT_PT_NO_USAGE) and
            (C_MULT_USAGE <= FLT_PT_MAX_USAGE)) then
      report HEADER & "Multiplier usage value is out of range. Requested value"
        & " C_MULT_USAGE= " & integer'image(C_MULT_USAGE);
      pass := false;
    end if;
    generics.c_mult_usage := C_MULT_USAGE;

    --------------------------------------------------------------------------------
    -- Check throttle scheme
    --------------------------------------------------------------------------------
    if (C_THROTTLE_SCHEME /= CI_CE_THROTTLE and
        C_THROTTLE_SCHEME /= CI_RFD_THROTTLE and
        C_THROTTLE_SCHEME /= CI_GEN_THROTTLE and
        C_THROTTLE_SCHEME /= CI_AND_TVALID_THROTTLE) then
      report HEADER & "Unknown value for C_THROTTLE_SCHEME";
      pass := false;
    end if;
    generics.c_throttle_scheme := C_THROTTLE_SCHEME;

    -------------------------------------------------------------------------------
    -- Check latency
    -------------------------------------------------------------------------------
    -- Minimum allowed latency depends on the throttle scheme
    case C_THROTTLE_SCHEME is
      when CI_CE_THROTTLE =>
        if C_LATENCY < 1 then
          report HEADER & "C_LATENCY must be 1 or greater with CE throttle (C_THROTTLE_SCHEME = " &
            integer'image(CI_CE_THROTTLE) & ")";
          pass := false;
        end if;
      when CI_RFD_THROTTLE =>
        if C_LATENCY < 3 then
          report HEADER & "C_LATENCY must be 3 or greater with RFD throttle (C_THROTTLE_SCHEME = " &
            integer'image(CI_RFD_THROTTLE) & ")";
          pass := false;
        end if;
      when CI_GEN_THROTTLE =>
        if C_LATENCY < 1 then
          report HEADER & "C_LATENCY must be 1 or greater with GEN throttle (C_THROTTLE_SCHEME = " &
            integer'image(CI_GEN_THROTTLE) & ")";
          pass := false;
        end if;
      when CI_AND_TVALID_THROTTLE =>
        if C_LATENCY < 0 then
          report HEADER & "C_LATENCY must be 0 or greater with AND_TVALID throttle (C_THROTTLE_SCHEME = " &
            integer'image(CI_AND_TVALID_THROTTLE) & ")";
          pass := false;
        end if;
      when others =>
        -- This case cannot happen as C_THROTTLE_SCHEME has already been checked
        report HEADER & "Fatal internal error, please contact Xilinx Support" severity failure;
    end case;
    if C_LATENCY > FLT_PT_MAX_LATENCY and C_LATENCY < FLT_PT_LATENCY_BIAS then
      -- FLT_PT_LATENCY_BIAS + bit pattern is not a customer-visible feature, so don't mention it in the message
      report HEADER & "C_LATENCY must be " & integer'image(FLT_PT_MAX_LATENCY)
        & " for fully pipelined, or a smaller value to specify the latency";
      pass := false;
    end if;
    generics.c_latency := C_LATENCY;

    -------------------------------------------------------------------------------
    -- Check rate (cycles per operation)
    -------------------------------------------------------------------------------
    if (C_RATE /= 1) then
      if not(C_HAS_DIVIDE = FLT_PT_YES or C_HAS_SQRT = FLT_PT_YES) then
        report HEADER & "C_RATE greater than 1 only supported by divide or"
          & " square-root on " & S_OP_NAME & " core.";
        pass := false;
      end if;
      if C_HAS_DIVIDE = FLT_PT_YES then
        max_rate := flt_pt_get_div_delay(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH);
        if C_RATE < 1 or C_RATE > max_rate then
          report HEADER & "C_RATE must be between 1 and " & integer'image(max_rate) & " for divide operation.";
          pass := false;
        end if;
      elsif C_HAS_SQRT = FLT_PT_YES then
        max_rate := flt_pt_get_sqrt_delay(C_RESULT_WIDTH, C_RESULT_FRACTION_WIDTH);
        if C_RATE < 1 or C_RATE > max_rate then
          report HEADER & "C_RATE must be between 1 and " & integer'image(max_rate) & " for square root operation.";
          pass := false;
        end if;
      end if;
    end if;
    generics.c_rate := C_RATE;

    --------------------------------------------------------------------------------
    -- Check clock enable and reset
    --------------------------------------------------------------------------------
    if C_HAS_ACLKEN /= 0 and C_HAS_ACLKEN /= 1 then
      report HEADER & "Illegal value for C_HAS_ACLKEN: must be 0 or 1";
      pass := false;
    end if;
    if C_LATENCY = 0 and C_HAS_ACLKEN = 1 then
      report HEADER & "C_HAS_ACLKEN must be 0 when C_LATENCY = 0";
      pass := false;
    end if;
    if C_HAS_ARESETN /= 0 and C_HAS_ARESETN /= 1 then
      report HEADER & "Illegal value for C_HAS_ARESETN: must be 0 or 1";
      pass := false;
    end if;
    if C_LATENCY = 0 and C_HAS_ARESETN = 1 then
      report HEADER & "C_HAS_ARESETN must be 0 when C_LATENCY = 0";
      pass := false;
    end if;
    generics.c_has_aclken  := C_HAS_ACLKEN;
    generics.c_has_aresetn := C_HAS_ARESETN;

    --------------------------------------------------------------------------------
    -- Check exceptions
    --------------------------------------------------------------------------------
    if C_HAS_UNDERFLOW /= 0 and C_HAS_UNDERFLOW /= 1 then
      report HEADER & "Illegal value for C_HAS_UNDERFLOW: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_OVERFLOW /= 0 and C_HAS_OVERFLOW /= 1 then
      report HEADER & "Illegal value for C_HAS_OVERFLOW: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_INVALID_OP /= 0 and C_HAS_INVALID_OP /= 1 then
      report HEADER & "Illegal value for C_HAS_INVALID_OP: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_DIVIDE_BY_ZERO /= 0 and C_HAS_DIVIDE_BY_ZERO /= 1 then
      report HEADER & "Illegal value for C_HAS_DIVIDE_BY_ZERO: must be 0 or 1";
      pass := false;
    end if;

    if (C_HAS_DIVIDE_BY_ZERO = FLT_PT_YES) and not (C_HAS_DIVIDE = FLT_PT_YES or C_HAS_RECIP = FLT_PT_YES or C_HAS_RECIP_SQRT = FLT_PT_YES) then
      report HEADER & "DIVIDE_BY_ZERO exception is only available with divide or reciprocal operations.";
      pass := false;
    end if;

    generics.c_has_underflow      := C_HAS_UNDERFLOW;
    generics.c_has_overflow       := C_HAS_OVERFLOW;
    generics.c_has_invalid_op     := C_HAS_INVALID_OP;
    generics.c_has_divide_by_zero := C_HAS_DIVIDE_BY_ZERO;

    --------------------------------------------------------------------------------
    -- Check A channel AXI generics
    --------------------------------------------------------------------------------
    if C_HAS_A_TUSER /= 0 and C_HAS_A_TUSER /= 1 then
      report HEADER & "Illegal value for C_HAS_A_TUSER: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_A_TLAST /= 0 and C_HAS_A_TLAST /= 1 then
      report HEADER & "Illegal value for C_HAS_A_TLAST: must be 0 or 1";
      pass := false;
    end if;
    if C_A_TDATA_WIDTH /= byte_roundup(C_A_WIDTH) then
      report HEADER & "Wrong value for C_A_TDATA_WIDTH, must be C_A_WIDTH " &
        "rounded up to the next byte boundary = " & integer'image(byte_roundup(C_A_WIDTH));
      pass := false;
    end if;
    generics.c_has_a_tuser   := C_HAS_A_TUSER;
    generics.c_has_a_tlast   := C_HAS_A_TLAST;
    generics.c_a_tdata_width := C_A_TDATA_WIDTH;
    if C_HAS_A_TUSER = 1 then
      generics.c_a_tuser_width := C_A_TUSER_WIDTH;
    else
      generics.c_a_tuser_width := 0;
    end if;

    --------------------------------------------------------------------------------
    -- Check B channel AXI generics
    --------------------------------------------------------------------------------
    if C_HAS_B /= 0 and C_HAS_B /= 1 then
      report HEADER & "Illegal value for C_HAS_B: must be 0 or 1";
      pass := false;
    end if;
    if (C_HAS_ADD = 1 or
        C_HAS_SUBTRACT = 1 or
        C_HAS_MULTIPLY = 1 or
        C_HAS_DIVIDE = 1 or
        C_HAS_COMPARE = 1) then
      if C_HAS_B = 0 then
        report HEADER & "Wrong value for C_HAS_B: must be 1 as operator is add, subtract, multiply, divide or compare";
        pass := false;
      end if;
    else
      if C_HAS_B = 1 then
        report HEADER & "Wrong value for C_HAS_B: must be 0 as operator is square root, " &
          "fixed-to-float, float-to-fixed, float-to-float, reciprocal or reciprocal square root";
        pass := false;
      end if;
    end if;

    if C_HAS_B = 1 then
      if C_HAS_B_TUSER /= 0 and C_HAS_B_TUSER /= 1 then
        report HEADER & "Illegal value for C_HAS_B_TUSER: must be 0 or 1";
        pass := false;
      end if;
      if C_HAS_B_TLAST /= 0 and C_HAS_B_TLAST /= 1 then
        report HEADER & "Illegal value for C_HAS_B_TLAST: must be 0 or 1";
        pass := false;
      end if;
      if C_B_TDATA_WIDTH /= byte_roundup(C_B_WIDTH) then
        report HEADER & "Wrong value for C_B_TDATA_WIDTH, must be C_B_WIDTH " &
          "rounded up to the next byte boundary = " & integer'image(byte_roundup(C_B_WIDTH));
        pass := false;
      end if;
    end if;
    generics.c_has_b := C_HAS_B;
    if C_HAS_B = 1 then
      generics.c_has_b_tuser   := C_HAS_B_TUSER;
      generics.c_has_b_tlast   := C_HAS_B_TLAST;
      generics.c_b_tdata_width := C_B_TDATA_WIDTH;
      if C_HAS_B_TUSER = 1 then
        generics.c_b_tuser_width := C_B_TUSER_WIDTH;
      else
        generics.c_b_tuser_width := 0;
      end if;
    else
      generics.c_has_b_tuser   := 0;
      generics.c_has_b_tlast   := 0;
      generics.c_b_tdata_width := 0;
      generics.c_b_tuser_width := 0;
    end if;

    --------------------------------------------------------------------------------
    -- Check OPERATION channel AXI generics
    --------------------------------------------------------------------------------
    if C_HAS_OPERATION /= 0 and C_HAS_OPERATION /= 1 then
      report HEADER & "Illegal value for C_HAS_OPERATION: must be 0 or 1";
      pass := false;
    end if;
    if ((C_HAS_ADD = 1 and C_HAS_SUBTRACT = 1) or
        (C_HAS_COMPARE = 1 and C_COMPARE_OPERATION = FLT_PT_PROGRAMMABLE)) then
      if C_HAS_OPERATION = 0 then
        report HEADER & "Wrong value for C_HAS_OPERATION: must be 1 " &
          "as operator is add/subtract or programmable compare";
        pass := false;
      end if;
    else
      if C_HAS_OPERATION = 1 then
        report HEADER & "Wrong value for C_HAS_OPERATION: must be 0 " &
          "as operator is add, subtract, (but not add/subtract), multiply, divide, square root, " &
          "non-programmable compare, fixed-to-float, float-to-fixed, float-to-float, reciprocal or reciprocal square root";
        pass := false;
      end if;
    end if;

    if C_HAS_OPERATION = 1 then
      if C_HAS_OPERATION_TUSER /= 0 and C_HAS_OPERATION_TUSER /= 1 then
        report HEADER & "Illegal value for C_HAS_OPERATION_TUSER: must be 0 or 1";
        pass := false;
      end if;
      if C_HAS_OPERATION_TLAST /= 0 and C_HAS_OPERATION_TLAST /= 1 then
        report HEADER & "Illegal value for C_HAS_OPERATION_TLAST: must be 0 or 1";
        pass := false;
      end if;
      if C_OPERATION_TDATA_WIDTH /= byte_roundup(FLT_PT_OPERATION_WIDTH) then
        report HEADER & "Wrong value for C_OPERATION_TDATA_WIDTH, must be " & integer'image(FLT_PT_OPERATION_WIDTH) &
          " rounded up to the next byte boundary = " & integer'image(byte_roundup(FLT_PT_OPERATION_WIDTH));
        pass := false;
      end if;
    end if;
    generics.c_has_operation := C_HAS_OPERATION;
    if C_HAS_OPERATION = 1 then
      generics.c_has_operation_tuser   := C_HAS_OPERATION_TUSER;
      generics.c_has_operation_tlast   := C_HAS_OPERATION_TLAST;
      generics.c_operation_tdata_width := C_OPERATION_TDATA_WIDTH;
      if C_HAS_OPERATION_TUSER = 1 then
        generics.c_operation_tuser_width := C_OPERATION_TUSER_WIDTH;
      else
        generics.c_operation_tuser_width := 0;
      end if;
    else
      generics.c_has_operation_tuser   := 0;
      generics.c_has_operation_tlast   := 0;
      generics.c_operation_tdata_width := 0;
      generics.c_operation_tuser_width := 0;
    end if;

    --------------------------------------------------------------------------------
    -- Check RESULT channel AXI generics
    --------------------------------------------------------------------------------
    if C_HAS_RESULT_TUSER /= 0 and C_HAS_RESULT_TUSER /= 1 then
      report HEADER & "Illegal value for C_HAS_RESULT_TUSER: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TLAST /= 0 and C_HAS_RESULT_TLAST /= 1 then
      report HEADER & "Illegal value for C_HAS_RESULT_TLAST: must be 0 or 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_a_tuser = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_A_TUSER = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_b_tuser = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_B_TUSER = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_operation_tuser = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_OPERATION_TUSER = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_underflow = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_UNDERFLOW = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_overflow = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_OVERFLOW = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_invalid_op = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_INVALID_OP = 1";
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 0 and generics.c_has_divide_by_zero = 1 then
      report HEADER & "C_HAS_RESULT_TUSER must be 1 because C_HAS_DIVIDE_BY_ZERO = 1";
      pass := false;
    end if;
    if C_RESULT_TDATA_WIDTH /= byte_roundup(C_RESULT_WIDTH) then
      report HEADER & "Wrong value for C_RESULT_TDATA_WIDTH, must be C_RESULT_WIDTH " &
        "rounded up to the next byte boundary = " & integer'image(byte_roundup(C_RESULT_WIDTH));
      pass := false;
    end if;
    if C_HAS_RESULT_TUSER = 1 then
      tuser_width := generics.c_a_tuser_width +
                     generics.c_b_tuser_width +
                     generics.c_operation_tuser_width +
                     generics.c_has_underflow +
                     generics.c_has_overflow +
                     generics.c_has_invalid_op +
                     generics.c_has_divide_by_zero;
      if C_RESULT_TUSER_WIDTH /= tuser_width then
        report HEADER & "Wrong value for C_RESULT_TUSER_WIDTH, must be sum of input TUSER widths " &
          "plus 1 for each exception = " & integer'image(tuser_width);
        pass := false;
      end if;
    end if;
    generics.c_has_result_tuser   := C_HAS_RESULT_TUSER;
    generics.c_has_result_tlast   := C_HAS_RESULT_TLAST;
    generics.c_result_tdata_width := C_RESULT_TDATA_WIDTH;
    if C_HAS_RESULT_TUSER = 1 then
      generics.c_result_tuser_width := C_RESULT_TUSER_WIDTH;
    else
      generics.c_result_tuser_width := 0;
    end if;

    -------------------------------------------------------------------------------
    -- Check TLAST resolution
    -------------------------------------------------------------------------------
    if (C_TLAST_RESOLUTION /= CI_TLAST_NULL and
        C_TLAST_RESOLUTION /= CI_TLAST_PASS_A and
        C_TLAST_RESOLUTION /= CI_TLAST_PASS_B and
        C_TLAST_RESOLUTION /= CI_TLAST_PASS_C and
        C_TLAST_RESOLUTION /= CI_TLAST_OR_ALL and
        C_TLAST_RESOLUTION /= CI_TLAST_AND_ALL) then
      report HEADER & "Unknown value for C_TLAST_RESOLUTION";
      pass := false;
    end if;
    if C_HAS_RESULT_TLAST = 1 then
      -- Permitted values of TLAST_RESOLUTION depend on which channels are present and have TLAST
      channels(1) := generics.c_has_a_tlast;
      channels(2) := generics.c_has_b_tlast;
      channels(3) := generics.c_has_operation_tlast;
      if channels = (0, 0, 0) then      -- no channels have TLAST
        -- TLAST resolution is ignored
      elsif channels = (1, 0, 0) then   -- Only A channel has TLAST
        if C_TLAST_RESOLUTION /= CI_TLAST_PASS_A then
          report HEADER & "C_TLAST_RESOLUTION must be " & integer'image(CI_TLAST_PASS_A) &
            " as only the A channel has TLAST";
          pass := false;
        end if;
      elsif channels = (0, 1, 0) then   -- Only B channel has TLAST
        if C_TLAST_RESOLUTION /= CI_TLAST_PASS_B then
          report HEADER & "C_TLAST_RESOLUTION must be " & integer'image(CI_TLAST_PASS_B) &
            " as only the B channel has TLAST";
          pass := false;
        end if;
      elsif channels = (0, 0, 1) then   -- Only OPERATION channel has TLAST
        if C_TLAST_RESOLUTION /= CI_TLAST_PASS_C then
          report HEADER & "C_TLAST_RESOLUTION must be " & integer'image(CI_TLAST_PASS_C) &
            " as only the OPERATION channel has TLAST";
          pass := false;
        end if;
      elsif channels = (1, 1, 0) then   -- A and B channels have TLAST
        if (C_TLAST_RESOLUTION /= CI_TLAST_PASS_A and
            C_TLAST_RESOLUTION /= CI_TLAST_PASS_B and
            C_TLAST_RESOLUTION /= CI_TLAST_OR_ALL and
            C_TLAST_RESOLUTION /= CI_TLAST_AND_ALL) then
          report HEADER & "C_TLAST_RESOLUTION must be " &
            integer'image(CI_TLAST_PASS_A) & " or " &
            integer'image(CI_TLAST_PASS_B) & " or " &
            integer'image(CI_TLAST_OR_ALL) & " or " &
            integer'image(CI_TLAST_AND_ALL) &
            " as only the A and B channels have TLAST";
          pass := false;
        end if;
      elsif channels = (1, 0, 1) then   -- A and OPERATION channels have TLAST
        if (C_TLAST_RESOLUTION /= CI_TLAST_PASS_A and
            C_TLAST_RESOLUTION /= CI_TLAST_PASS_C and
            C_TLAST_RESOLUTION /= CI_TLAST_OR_ALL and
            C_TLAST_RESOLUTION /= CI_TLAST_AND_ALL) then
          report HEADER & "C_TLAST_RESOLUTION must be " &
            integer'image(CI_TLAST_PASS_A) & " or " &
            integer'image(CI_TLAST_PASS_C) & " or " &
            integer'image(CI_TLAST_OR_ALL) & " or " &
            integer'image(CI_TLAST_AND_ALL) &
            " as only the A and OPERATION channels have TLAST";
          pass := false;
        end if;
      elsif channels = (0, 1, 1) then   -- B and OPERATION channels have TLAST
        if (C_TLAST_RESOLUTION /= CI_TLAST_PASS_B and
            C_TLAST_RESOLUTION /= CI_TLAST_PASS_C and
            C_TLAST_RESOLUTION /= CI_TLAST_OR_ALL and
            C_TLAST_RESOLUTION /= CI_TLAST_AND_ALL) then
          report HEADER & "C_TLAST_RESOLUTION must be " &
            integer'image(CI_TLAST_PASS_B) & " or " &
            integer'image(CI_TLAST_PASS_C) & " or " &
            integer'image(CI_TLAST_OR_ALL) & " or " &
            integer'image(CI_TLAST_AND_ALL) &
            " as only the B and OPERATION channels have TLAST";
          pass := false;
        end if;
      elsif channels = (1, 1, 1) then   -- All channels have TLAST
        if C_TLAST_RESOLUTION = CI_TLAST_NULL then
          report HEADER & "C_TLAST_RESOLUTION must be " &
            integer'image(CI_TLAST_PASS_A) & " or " &
            integer'image(CI_TLAST_PASS_B) & " or " &
            integer'image(CI_TLAST_PASS_C) & " or " &
            integer'image(CI_TLAST_OR_ALL) & " or " &
            integer'image(CI_TLAST_AND_ALL) &
            " as the A, B and OPERATION channels all have TLAST";
          pass := false;
        end if;
      else
        report HEADER & "Internal error: could not recognise combination of <channel>_has_tlast generics. " &
          "Please contact Xilinx Support.";
      end if;
      generics.c_tlast_resolution := C_TLAST_RESOLUTION;
    else                                -- not (if C_HAS_RESULT_TLAST = 1)
      generics.c_tlast_resolution := CI_TLAST_NULL;
    end if;

    -------------------------------------------------------------------------------
    -- Generate error if generics out of range. Message already contains function.
    -------------------------------------------------------------------------------
    assert(pass)
      report "ERROR in floating_point_v6_0 core: The generics are out of range."
      severity failure;

    -- Return the generics record
    return generics;
  end function;


  --------------------------------------------------------------------------------
  -- Functions to determine floating-point special cases
  --------------------------------------------------------------------------------
  -- Determines if a number is any NaN
  function flt_pt_is_nan(w, fw : integer; value : std_logic_vector)
    return boolean is
  begin
    return (flt_pt_is_quiet_nan(w, fw, value) or
            flt_pt_is_signalling_nan(w, fw, value));
  end function;

  -- Determines if a number is a quiet NaN
  function flt_pt_is_quiet_nan(w, fw : integer; value : std_logic_vector)
    return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    --             w-1 w-2 fw-1 fw-2  0
    -- Quiet NaN is <X><11...11><1X...XX>
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);

    return (mod_ip(w-2 downto fw-2) = FLT_PT_ONE(w-fw downto 0));
  end function;

  -- Determines if a number is a signalling NaN
  function flt_pt_is_signalling_nan(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    --                   w-1 w-2 fw-1 fw-2  0
    -- Signalling NaN is <X><11...11><0n...nn> where n is non zero
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);

    return ((mod_ip(w - 2 downto fw - 1) = FLT_PT_ONE(w - fw - 1 downto 0)) and
            (mod_ip(fw - 2) = '0') and
            (mod_ip(fw - 3 downto 0) /= FLT_PT_ZERO(fw - 3 downto 0)));
  end function;

  -- Determines if a floating-point number is zero
  function flt_pt_is_zero(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);
    --         w-1 w-2 fw-1 fw-2  0
    -- Zero is <X><00...00><00...00>
    return (mod_ip(w-2 downto 0) = FLT_PT_ZERO(w-2 downto 0));
  end function;

  -- Determines if a floating-point number is infinity
  function flt_pt_is_inf(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);
    --             w-1 w-2 fw-1 fw-2  0
    -- Infinity is <X><11...11><00...00>
    return ((mod_ip(w - 2 downto fw - 1) = FLT_PT_ONE(w - fw - 1 downto 0)) and
            (mod_ip(fw - 2 downto 0) = FLT_PT_ZERO(fw - 2 downto 0)));
  end function;
  -- Determines if a floating-point number is denormalized
  function flt_pt_is_denormalized(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    --                 w-1 w-2 fw-1 fw-2  0
    -- Denormalized is <X><00...00><nn...nnn> where n is non-zero
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);
    return ((mod_ip(w - 2 downto fw - 1) = FLT_PT_ZERO(w - fw - 1 downto 0)) and
            (mod_ip(fw - 2 downto 0) /= FLT_PT_ZERO(fw - 2 downto 0)));
  end function;

  -- Tests for positive or negative one
  function flt_pt_is_one(w, fw : integer; value : std_logic_vector) return boolean is
    variable ip     : std_logic_vector(value'length-1 downto 0);
    variable mod_ip : std_logic_vector(w-1 downto 0);
  begin
    --        w-1 w-2 fw-1 fw-2  0
    -- One is <X><01...11><00...00> where n is non zero
    ip     := value;
    mod_ip := ip(ip'left downto ip'left - w + 1);

    return ((mod_ip(w - 2 downto fw - 1) = '0' & FLT_PT_ONE(w - 3 downto fw - 1)) and
            (mod_ip(fw - 2 downto 0) = FLT_PT_ZERO(fw - 2 downto 0)));
  end function flt_pt_is_one;

  --------------------------------------------------------------------------------
  -- Functions to derive floating-point special values
  --------------------------------------------------------------------------------
  -- Provides a floating point number that represents a quiet NaN
  function flt_pt_get_quiet_nan(w, fw : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --             w-1 w-2 fw-1 fw-2  0
    -- Quiet NaN is <0><11...11><10...00>
    val(w-1)             := '0';
    val(w-2 downto fw-2) := (others => '1');
    val(fw-3 downto 0)   := (others => '0');
    return(val);
  end function;

  -- Provides a floating-point number that represents the appropriately signed
  -- infinity
  function flt_pt_get_inf(w, fw : integer; sign : std_logic)
    return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --              w-1 w-2 fw-1 fw-2  0
    -- Infinity is <sign><11...11><00...00>
    val(w-1)             := sign;
    val(w-2 downto fw-1) := (others => '1');
    val(fw-2 downto 0)   := (others => '0');
    return(val);
  end function;

  -- Provides a floating-point number representing a signalling NaN
  function flt_pt_get_signalling_nan(w, fw : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --                  w-1 w-2 fw-1 fw-2  0
    -- Signalling NaN is <0><11...11><01...11>
    val(w-1)             := '0';
    val(w-1 downto fw-1) := (others => '1');
    val(fw-2)            := '0';
    val(fw-3 downto 0)   := (others => '1');
    return(val);
  end function;

  -- Provides a floating-point number that represents an appropriately signed
  -- zero
  function flt_pt_get_zero(w, fw : integer; sign : std_logic)
    return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    --            w-1 w-2 fw-1 fw-2  0
    -- Zero is <sign><00...00><00...00>
    val(w-1)          := sign;
    val(w-2 downto 0) := (others => '0');
    return(val);
  end function;

  -- Provides the most negative fixed-point number
  function flt_pt_get_most_negative_fix(w : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    -- Most negative is <10...00>
    val(w-1) := '1';
    if w > 1 then                       -- for the day when width can be 1!
      val(w-2 downto 0) := (others => '0');
    end if;
    return(val);
  end function;

  -- Provides the most positive fixed-point number
  function flt_pt_get_most_positive_fix(w : integer) return std_logic_vector is
    variable val : std_logic_vector(w-1 downto 0);
  begin
    -- Most positive is <01...11>
    val(w-1) := '0';
    if w > 1 then                       -- for the day when width can be 1!
      val(w-2 downto 0) := (others => '1');
    end if;
    return(val);
  end function;

  -- Determines whether an operation has both add and subtract enabled
  function flt_pt_has_add_or_subtract(C_HAS_ADD, C_HAS_SUBTRACT : integer) return integer is
  begin
    if (C_HAS_ADD = FLT_PT_YES) or (C_HAS_SUBTRACT = FLT_PT_YES) then
      return(FLT_PT_YES);
    else
      return(FLT_PT_NO);
    end if;
  end function;

  -- Get the part of the operation code that indicates whether addition or
  -- subtraction should be performed
  function flt_pt_get_addsub_op(operation : std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0))
    return std_logic is
  begin
    return(operation(0));
  end function;

  -- Get the part of the operation code that provides the compare operation
  function flt_pt_get_compare_op(operation : std_logic_vector(FLT_PT_OPERATION_WIDTH-1 downto 0))
    return std_logic_vector is
  begin
    return operation(FLT_PT_OPERATION_WIDTH-1 downto FLT_PT_OPERATION_WIDTH - FLT_PT_COMPARE_OPERATION_WIDTH);
  end function;

  ------------------------------------------------------------------------
  -- Some implementation functions
  ------------------------------------------------------------------------
  -- Get the number of registers enabled from a part of the configuration array
  function get_reg_delay(reg : flt_pt_reg_type; start, length : integer) return integer is
    variable sum : integer := 0;
  begin
    for i in start to (start + length - 1) loop
      if reg(i) then
        sum := sum + 1;
      end if;
    end loop;
    return(sum);
  end function;

  -- Get the integer representation for a slice of the configuration array
  function get_reg_delay_pat(reg : flt_pt_reg_type; start, length : integer) return integer is
    variable sum : integer := 0;
    variable pow : integer := 1;
  begin
    for i in start to (start + length - 1) loop
      if reg(i) then
        sum := sum + pow;
      end if;
      pow := pow * 2;
    end loop;
    return(sum);
  end function;

  -- Extract a part of the register configuration array, by shifting it down to start of array
  function get_reg_blk(reg : flt_pt_reg_type; start : integer) return flt_pt_reg_type is
    variable reg_blk : flt_pt_reg_type := (others => false);
  begin
    for i in reg_blk'left to reg_blk'right - start - 1 loop
      reg_blk(i) := reg(start + i);
    end loop;
    return(reg_blk);
  end function;

  -- Convert register configuration array into an array of integers,
  -- where 1 = register enabled
  function conv_reg_to_reg_int(reg : flt_pt_reg_type) return int_array is
    variable reg_int : int_array(0 to flt_pt_reg_type'length - 1);
  begin
    for i in 0 to flt_pt_reg_type'length - 1 loop
      if reg(i) then
        reg_int(i) := 1;
      else
        reg_int(i) := 0;
      end if;
    end loop;
    return(reg_int);
  end function;

  -- Mask part of register array using a second array. Where stage_mask is true,
  -- register is disabled.
  function mask_reg(reg_in, stage_mask : flt_pt_reg_type) return flt_pt_reg_type is
    variable loc_reg : flt_pt_reg_type;
  begin
    for i in reg_in'left to reg_in'right loop
      if stage_mask(i) then
        loc_reg(i) := reg_in(i);
      else
        loc_reg(i) := false;
      end if;
    end loop;
    return(loc_reg);
  end function;

  -- Purpose: Provides register placement. For important configurations, the best
  -- placement has been determined by characterization of netlist. Otherwise, the
  -- registers are maximally spaced, ensuring that there is always one register on
  -- the output.
  -- It is possible to supply a custom placement by supplying a value of
  -- C_LATENCY that is binary encoded, with a bias (FLT_PT_LATENCY_BIAS) to signal
  -- that custom latency has been specified.

  function get_registers(
    a_width, a_fraction_width, b_width, b_fraction_width,
    result_width, result_fraction_width, req_latency, max_latency,
    op_code, mult_usage, optimization : integer; family : string) return flt_pt_reg_type is
    variable reg             : flt_pt_reg_type;
    variable reg_std         : std_logic_vector(flt_pt_reg_type'length-1 downto 0);
    variable adj_req_latency : integer;
    variable mod_req_latency : integer;
    variable i               : integer;
    variable defined         : boolean := false;
    constant R_EW            : integer := result_width - result_fraction_width;
    constant MULT_TYPE : flt_pt_mult_type := flt_pt_get_mult_type(family,
                                                                        optimization,
                                                                        mult_usage,
                                                                        result_width,
                                                                        result_fraction_width);
    constant ADDSUB_TYPE   : flt_pt_imp_type := flt_pt_get_addsub_type(mult_usage);
    variable operator_type : integer;
  begin
    if req_latency >= FLT_PT_LATENCY_BIAS then
      -- Custom latency, so remove bias, and convert remaining integer value to
      -- binary, where each bit determines whether a register is on (true) or off
      -- (false). The lsb is the register closest to the input of the operator.
      adj_req_latency := req_latency - FLT_PT_LATENCY_BIAS;
      adj_req_latency := adj_req_latency mod 2 ** max_latency;
      i               := 0;
      while adj_req_latency > 0 loop
        if (adj_req_latency mod 2) = 1 then
          reg(i) := true;
        else
          reg(i) := false;
        end if;
        adj_req_latency := adj_req_latency / 2;
        i               := i + 1;
      end loop;
    else
      -- Not custom latency
      if req_latency > max_latency then
        -- Limit latency to that which component can supply - extra delay added elsewhere
        mod_req_latency := max_latency;
      else
        mod_req_latency := req_latency;
      end if;
      -- Now check to see if a custom latency value is available
      case op_code is
        when FLT_PT_ADD_OP_CODE | FLT_PT_SUBTRACT_OP_CODE=>
          if optimization = FLT_PT_LOW_LATENCY then
            if ADDSUB_TYPE = FLT_PT_IMP_LOGIC then
              if (a_width = 32 and a_fraction_width = 24) then
                defined := true;
                case mod_req_latency is        -- max latency 8
                  when 4      => reg_std(7 downto 0) := "10101010";
                  when 5      => reg_std(7 downto 0) := "10110101";
                  when 6      => reg_std(7 downto 0) := "10111101";
                  when 7      => reg_std(7 downto 0) := "11111101";
                  when others => defined             := false;
                end case;
              elsif (a_width = 64 and a_fraction_width = 53) then
                defined := true;
                case mod_req_latency is        -- max latency 8
                  when 4      => reg_std(7 downto 0) := "10101010";
                  when 5      => reg_std(7 downto 0) := "10110101";
                  when 6      => reg_std(7 downto 0) := "10111101";
                  when 7      => reg_std(7 downto 0) := "10111111";
                  when others => defined             := false;
                end case;
              end if;
            end if;
          elsif optimization = FLT_PT_SPEED_OPTIMIZED then
            case ADDSUB_TYPE is
              when FLT_PT_IMP_LOGIC =>
                if (a_fraction_width <= 17) then
                  defined := false;
                elsif (a_fraction_width <= 61) then
                  defined := true;
                  case mod_req_latency is      -- max latency 12
                    when 7      => reg_std(11 downto 0) := "101010101011";
                    when 8      => reg_std(11 downto 0) := "110101101101";
                    when 9      => reg_std(11 downto 0) := "110101101111";
                    when 10     => reg_std(11 downto 0) := "110111101111";
                    when 11     => reg_std(11 downto 0) := "111111101111";
                    when others => defined              := false;
                  end case;
                end if;
              when FLT_PT_IMP_DSP48 =>
                -- These cases need a special pattern defined for every latency value
                -- because some of these have their maximum latency limited to 1 less than the values quoted here
                -- although internally every register location is still present.
                -- This is an optimization based on characterization results: the extra register adds no value.
                -- If a pattern is not defined for every value, the even distribution algorithm puts registers
                -- in too few locations, which can give incorrect implementations.
                if supports_dsp48a1(family) > 0 then
                  if (a_width = 32 and a_fraction_width = 24) then
                    defined := true;
                    case mod_req_latency is    -- max latency 16
                      when 0      => reg_std(15 downto 0) := "0000000000000000";
                      when 1      => reg_std(15 downto 0) := "0000000000000001";
                      when 2      => reg_std(15 downto 0) := "0000000100000001";
                      when 3      => reg_std(15 downto 0) := "0000100001000001";
                      when 4      => reg_std(15 downto 0) := "1000010000100001";
                      when 5      => reg_std(15 downto 0) := "1000100010010001";
                      when 6      => reg_std(15 downto 0) := "1001001001001001";
                      when 7      => reg_std(15 downto 0) := "1010101001001001";
                      when 8      => reg_std(15 downto 0) := "1001010101010101";
                      when 9      => reg_std(15 downto 0) := "1101010101010101";
                      when 10     => reg_std(15 downto 0) := "1010101101101011";  --14 251MHz
                      when 11     => reg_std(15 downto 0) := "1110101101101011";  --4  298MHz
                      when 12     => reg_std(15 downto 0) := "1110101101111011";  --12 302MHz
                      when 13     => reg_std(15 downto 0) := "1111101101111011";  --7  316MHz
                      when 14     => reg_std(15 downto 0) := "1111101111111011";  --2  336MHz
                      when 15     => reg_std(15 downto 0) := "1111101111111111";  --10 355MHz
                      when 16     => reg_std(15 downto 0) := "1111111111111111";
                      when others => defined              := false;
                    end case;
                  elsif (a_width = 64 and a_fraction_width = 53) then
                    defined := true;
                    case mod_req_latency is    -- max latency 16
                      when 0      => reg_std(15 downto 0) := "0000000000000000";
                      when 1      => reg_std(15 downto 0) := "0000000000000001";
                      when 2      => reg_std(15 downto 0) := "0000000100000001";
                      when 3      => reg_std(15 downto 0) := "0000100001000001";
                      when 4      => reg_std(15 downto 0) := "1000010000100001";
                      when 5      => reg_std(15 downto 0) := "1000100010010001";
                      when 6      => reg_std(15 downto 0) := "1001001001001001";
                      when 7      => reg_std(15 downto 0) := "1010101001001001";
                      when 8      => reg_std(15 downto 0) := "1010101010101010";
                      when 9      => reg_std(15 downto 0) := "1010101010101011";
                      when 10     => reg_std(15 downto 0) := "1101010101110101";
                      when 11     => reg_std(15 downto 0) := "1101010101110111";
                      when 12     => reg_std(15 downto 0) := "1101011101110111";
                      when 13     => reg_std(15 downto 0) := "1101011101111111";
                      when 14     => reg_std(15 downto 0) := "1111011101111111";
                      when 15     => reg_std(15 downto 0) := "1111011111111111";
                      when 16     => reg_std(15 downto 0) := "1111111111111111";
                      when others => defined              := false;
                    end case;
                  end if;
                elsif supports_dsp48e1(family) > 0 then
                  if (a_width = 32 and a_fraction_width = 24) then
                    defined := true;
                    case mod_req_latency is    -- max latency 12
                      when 0      => reg_std(11 downto 0) := "000000000000";
                      when 1      => reg_std(11 downto 0) := "000000000001";
                      when 2      => reg_std(11 downto 0) := "000001000001";
                      when 3      => reg_std(11 downto 0) := "000100010001";
                      when 4      => reg_std(11 downto 0) := "100100010001";
                      when 5      => reg_std(11 downto 0) := "100100100101";
                      when 6      => reg_std(11 downto 0) := "101010101001";
                      when 7      => reg_std(11 downto 0) := "101010101101";
                      when 8      => reg_std(11 downto 0) := "110101011011";
                      when 9      => reg_std(11 downto 0) := "111101011011";
                      when 10     => reg_std(11 downto 0) := "111111011011";
                      when 11     => reg_std(11 downto 0) := "111111011111";
                      when 12     => reg_std(11 downto 0) := "111111111111";
                      when others => defined              := false;
                    end case;
                  elsif (a_width = 64 and a_fraction_width = 53) then
                    defined := true;
                    case mod_req_latency is    -- max latency 15
                      when 0      => reg_std(14 downto 0) := "000000000000000";
                      when 1      => reg_std(14 downto 0) := "000000000000001";
                      when 2      => reg_std(14 downto 0) := "000000100000001";
                      when 3      => reg_std(14 downto 0) := "000010000100001";
                      when 4      => reg_std(14 downto 0) := "100010000100001";
                      when 5      => reg_std(14 downto 0) := "100010010001001";
                      when 6      => reg_std(14 downto 0) := "100100100100101";
                      when 7      => reg_std(14 downto 0) := "101001010100101";
                      when 8      => reg_std(14 downto 0) := "101010101010101";  --
                      when 9      => reg_std(14 downto 0) := "101010101110101";  --
                      when 10     => reg_std(14 downto 0) := "110101010111011";  --  282MHz
                      when 11     => reg_std(14 downto 0) := "110101010111111";  --  330MHz
                      when 12     => reg_std(14 downto 0) := "110101110111111";  --  346MHz
                      when 13     => reg_std(14 downto 0) := "111101110111111";  --  378MHz
                      when 14     => reg_std(14 downto 0) := "111101111111111";  --  386MHz
                      when 15     => reg_std(14 downto 0) := "111111111111111";
                      when others => defined              := false;
                    end case;
                  end if;
                else
                  defined := false;
                end if;
              when others =>
                defined := false;
            end case;
          end if;
        when FLT_PT_MULTIPLY_OP_CODE =>
          if optimization = FLT_PT_LOW_LATENCY then
            if MULT_TYPE = FLT_PT_MULT_DSP48E1 then
              if mult_usage = FLT_PT_FULL_USAGE then
                if (a_width = 64 and a_fraction_width = 53) then
                  defined := true;
                  case mod_req_latency is      -- max latency 9
                    when 5      => reg_std(9 downto 0) := "1010101010";
                    when 6      => reg_std(9 downto 0) := "1011010101";
                    when 7      => reg_std(9 downto 0) := "1011110101";
                    when 8      => reg_std(9 downto 0) := "1011111101";
                    when 9      => reg_std(9 downto 0) := "1111111101";
                    when others => defined             := false;
                  end case;
                end if;
              end if;
            end if;
          elsif optimization = FLT_PT_SPEED_OPTIMIZED then
            case MULT_TYPE is
              when FLT_PT_MULT_LOGIC =>
                defined := false;
              when FLT_PT_MULT_DSP48A1 =>
                defined := false;
              when FLT_PT_MULT_DSP48E1 =>
                case mult_usage is
                  when FLT_PT_MEDIUM_USAGE =>
                    if (a_width = 32 and a_fraction_width = 24) then
                      defined := true;
                      case mod_req_latency is  -- max latency 8
                        when 6      => reg_std(7 downto 0) := "10101111";
                        when 7      => reg_std(7 downto 0) := "10111111";
                        when others => defined             := false;
                      end case;
                    else                --
                      defined := false;
                    end if;
                  when FLT_PT_FULL_USAGE =>
                    defined              := false;
                    if (a_fraction_width <= 17) then
                      defined := false;
                    elsif (a_fraction_width <= 24) then
                      defined := true;
                      case mod_req_latency is  -- max latency 8
                        when 5      => reg_std(7 downto 0) := "10001111";
                        when 6      => reg_std(7 downto 0) := "10101111";
                        when 7      => reg_std(7 downto 0) := "11011111";
                        when others => defined             := false;
                      end case;
                    elsif (a_fraction_width <= 34) then
                      defined := false;
                    elsif (a_fraction_width <= 41) then
                      defined := false;
                    elsif (a_fraction_width <= 51) then
                      defined := false;
                    elsif (a_fraction_width <= 58) then
                      defined := true;
                      case mod_req_latency is  -- max latency 18
                        when 15     => reg_std(17 downto 0) := "100011111111111111";
                        when 16     => reg_std(17 downto 0) := "101011111111111111";
                        when 17     => reg_std(17 downto 0) := "110111111111111111";
                        when others => defined              := false;
                      end case;
                    elsif (a_fraction_width <= 68) then
                      defined := false;
                    else
                      defined := false;
                    end if;
                  when FLT_PT_MAX_USAGE =>
                    defined := false;
                    if (a_width = 32 and a_fraction_width = 24) then
                      defined := true;
                      case mod_req_latency is  -- max latency 6
                        when 3      => reg_std(5 downto 0) := "101010";
                        when 4      => reg_std(5 downto 0) := "101101";
                        when 5      => reg_std(5 downto 0) := "111101";
                        when others => defined             := false;
                      end case;
                    elsif (a_fraction_width <= 17) then
                      defined := false;
                    elsif (a_fraction_width <= 24) then
                      defined := true;
                      case mod_req_latency is  -- max latency 9
                        when 7      => reg_std(8 downto 0) := "111001111";
                        when 8      => reg_std(8 downto 0) := "111101111";
                        when others => defined             := false;
                      end case;
                    elsif (a_fraction_width <= 34) then
                      defined := false;
                    elsif (a_fraction_width <= 41) then
                      defined := false;
                    elsif (a_fraction_width <= 51) then
                      defined := true;
                      case mod_req_latency is  -- max latency 19
                        when 17     => reg_std(18 downto 0) := "1110011111111111111";
                        when 18     => reg_std(18 downto 0) := "1111011111111111111";
                        when others => defined              := false;
                      end case;
                    elsif (a_fraction_width <= 58) then
                      defined := false;
                    elsif (a_fraction_width <= 68) then
                      defined := false;
                    else
                      defined := false;
                    end if;
                  when others =>
                    defined := false;
                end case;
              when FLT_PT_MULT_DSP48E1_SPD_DBL =>
                case mult_usage is
                  when FLT_PT_MEDIUM_USAGE =>
                    defined := true;
                    case mod_req_latency is    -- max latency 15
                      when 8      => reg_std(14 downto 0) := "110101010101010";
                      when 9      => reg_std(14 downto 0) := "110101010101101";
                      when 10     => reg_std(14 downto 0) := "110101010111101";
                      when 11     => reg_std(14 downto 0) := "110101011111101";
                      when 12     => reg_std(14 downto 0) := "110101111111101";
                      when 13     => reg_std(14 downto 0) := "110111111111101";
                      when 14     => reg_std(14 downto 0) := "111111111111101";
                      when others => defined              := false;
                    end case;
                  when FLT_PT_FULL_USAGE =>
                    defined := true;
                    case mod_req_latency is    -- max latency 15
                      when 8      => reg_std(14 downto 0) := "110101010101010";
                      when 9      => reg_std(14 downto 0) := "110101010101101";
                      when 10     => reg_std(14 downto 0) := "110101010111101";
                      when 11     => reg_std(14 downto 0) := "110101011111101";
                      when 12     => reg_std(14 downto 0) := "110101111111101";
                      when 13     => reg_std(14 downto 0) := "110111111111101";
                      when 14     => reg_std(14 downto 0) := "111111111111101";
                      when others => defined              := false;
                    end case;
                  when FLT_PT_MAX_USAGE =>
                    defined := true;
                    case mod_req_latency is    -- max latency 15
                      when 9      => reg_std(15 downto 0) := "1101010101010101";
                      when 10     => reg_std(15 downto 0) := "1101010101110101";
                      when 11     => reg_std(15 downto 0) := "1101010111110101";
                      when 12     => reg_std(15 downto 0) := "1101011111110101";
                      when 13     => reg_std(15 downto 0) := "1101011111111101";
                      when 14     => reg_std(15 downto 0) := "1110111111111101";
                      when 15     => reg_std(15 downto 0) := "1110111111111111";
                      when others => defined              := false;
                    end case;
                  when others => defined := false;
                end case;
              when others => defined := false;
            end case;
          end if;
        when FLT_PT_FLT_TO_FIX_OP_CODE =>
          reg_std := (others => '1');
          if (max_latency = 6) then
            defined := true;
            case mod_req_latency is
              when 0      => reg_std(5 downto 0) := "000000";
              when 1      => reg_std(5 downto 0) := "100000";
              when 2      => reg_std(5 downto 0) := "100100";
              when 3      => reg_std(5 downto 0) := "101010";
              when 4      => reg_std(5 downto 0) := "111010";
              when 5      => reg_std(5 downto 0) := "111011";
              when others => defined             := false;
            end case;
          end if;
        when FLT_PT_FIX_TO_FLT_OP_CODE =>
          reg_std                        := (others => '1');
          if (A_WIDTH >= 9) and (A_WIDTH <= 32) then
            defined := true;
            case mod_req_latency is     -- max latency 6
              when 0      => reg_std(5 downto 0) := "000000";
              when 1      => reg_std(5 downto 0) := "100000";
              when 2      => reg_std(5 downto 0) := "100100";
              when 3      => reg_std(5 downto 0) := "101001";
              when 4      => reg_std(5 downto 0) := "101011";
              when 5      => reg_std(5 downto 0) := "111011";
              when others => defined             := false;
            end case;
          end if;
        when FLT_PT_DIVIDE_OP_CODE =>
          reg_std := (others => '1');
          if req_latency = max_latency - 1 then
            reg_std(max_latency - 4) := '0';
            defined                  := true;
          elsif req_latency = max_latency - 2 then
            reg_std(max_latency - 2) := '0';
            reg_std(max_latency - 4) := '0';
            defined                  := true;
          end if;
        when FLT_PT_SQRT_OP_CODE =>
          reg_std := (others => '1');
          if req_latency = max_latency - 1 then
            reg_std(max_latency - 2) := '0';
            defined                  := true;
          end if;
        when others =>
          defined := false;
      end case;

      -- Ensure that all 'unused' registers are true, so that we pick up any
      -- latency calculation issues.
      reg := (others => true);

      if defined then
        -- if defined then convert compact notation into actual representation
        for i in 0 to reg_std'length - 1 loop
          if reg_std(i) = '1' then
            reg(i) := true;
          else
            reg(i) := false;
          end if;
        end loop;
      else
        -- Set all relevant registers off, and then enable as necessary
        reg(0 to max_latency - 1) := (others => false);
        -- if not defined, then place a register at the end and evenly
        -- space the remainder
        if mod_req_latency > 0 then
          reg(max_latency - 1) := true;
        end if;
        if mod_req_latency > 1 then
          for i in 1 to mod_req_latency - 1 loop
            reg(((max_latency - 1) * i) / (mod_req_latency)) := true;
          end loop;
        end if;
      end if;
    end if;
    return(reg);
  end function get_registers;

  -- Function to work out what delay must be added to outputs in order to satisfy
  -- the latency required.
  function get_op_del_len(req_latency, act_latency : integer) return integer is
    variable del             : integer;
    variable mod_req_latency : integer;
    variable adj_req_latency : integer;
    variable numb_ones       : integer;
  begin
    if req_latency >= FLT_PT_LATENCY_BIAS then
      -- registers given by bit pattern
      adj_req_latency := req_latency - FLT_PT_LATENCY_BIAS;  -- remove bias
      numb_ones       := 0;
      -- count ones to establish latency
      while adj_req_latency > 0 loop
        numb_ones       := adj_req_latency mod 2 + numb_ones;
        adj_req_latency := adj_req_latency / 2;
      end loop;
      mod_req_latency := numb_ones;
    else
      mod_req_latency := req_latency;
    end if;
    if req_latency = FLT_PT_MAX_LATENCY then
      del := 0;
    elsif mod_req_latency > act_latency then
      del := mod_req_latency - act_latency;
    else
      del := 0;
    end if;
    return(del);
  end function;

  -- Determine when TREADY on input channels is required by the core
  function flt_pt_get_has_s_axis_tready(throttle_scheme, has_divide, has_sqrt, rate : integer) return integer is
    variable has_tready : integer := 0;
  begin
    if (throttle_scheme = CI_CE_THROTTLE or
        throttle_scheme = CI_RFD_THROTTLE or
        throttle_scheme = CI_GEN_THROTTLE) then
      has_tready := 1;
    elsif (has_divide = 1 or has_sqrt = 1) and rate > 1 then
      has_tready := 1;
    else
      has_tready := 0;
    end if;
    return has_tready;
  end function flt_pt_get_has_s_axis_tready;

  -- Determine latency of internal core after subtracting AXI interface latencies
  function fn_get_internal_core_latency (
    c_latency         : integer;
    c_throttle_scheme : integer)
    return integer is
    constant combiner_latency : integer := 1;
    constant fifo_latency     : integer := 2;
    variable latency          : integer := 0;
  begin
    latency := c_latency;
    case c_throttle_scheme is
      when CI_CE_THROTTLE =>
        latency := latency - combiner_latency;
      when CI_RFD_THROTTLE =>
        latency := latency - combiner_latency - fifo_latency;
      when CI_GEN_THROTTLE =>
        latency := latency - combiner_latency;
      when CI_AND_TVALID_THROTTLE =>
        null;
      when others =>
        null;
    end case;
    return latency;
  end function fn_get_internal_core_latency;

  -- Create internal clock enables to handle AXI dataflow
  procedure assign_clock_enables (
    constant c_throttle_scheme  : in  integer;
    constant internal_latency   : in  integer;
    signal aclken_i             : in  std_logic;
    signal combiner_data_valid  : in  std_logic;
    signal m_axis_result_tready : in  std_logic;
    signal rdy_interface        : in  std_logic;
    signal ce_internal_core     : out std_logic;
    signal ce_interface         : out std_logic) is
  begin
    -- If the internal core latency is zero, clock enable is not possible internally, only for interfaces
    if internal_latency = 0 then
      ce_internal_core <= '1';
    else
      case c_throttle_scheme is
        when CI_CE_THROTTLE =>
          -- Don't clock internal core when there is a backthrottle condition
          ce_internal_core <= aclken_i and not(not(m_axis_result_tready) and rdy_interface);
        when others =>
          ce_internal_core <= aclken_i;
      end case;
    end if;
    ce_interface <= aclken_i;
  end procedure assign_clock_enables;

  -- Calculate total width of TUSER payload from all slave channels
  function fn_calc_user_width (c_has_a_tuser, c_has_b_tuser, c_has_operation_tuser, c_a_tuser_width, c_b_tuser_width, c_operation_tuser_width : integer) return integer is
    variable width : integer := 0;
  begin
    if c_has_a_tuser /= 0 then
      width := width + c_a_tuser_width;
    end if;
    if c_has_b_tuser /= 0 then
      width := width + c_b_tuser_width;
    end if;
    if c_has_operation_tuser /= 0 then
      width := width + c_operation_tuser_width;
    end if;
    return width;
  end function fn_calc_user_width;

  -- Create payload for delay line carrying TUSER and TLAST data in lockstep with the internal core
  procedure build_user_in (
    constant user_width                                                 : in  integer;
    constant has_tlast                                                  : in  integer;
    constant c_has_a_tuser, c_has_b_tuser, c_has_operation_tuser        : in  integer;
    constant c_has_a_tlast, c_has_b_tlast, c_has_operation_tlast        : in  integer;
    constant c_tlast_resolution                                         : in  integer;
    signal m_axis_z_tuser_a, m_axis_z_tuser_b, m_axis_z_tuser_operation : in  std_logic_vector;
    signal m_axis_z_tlast_a, m_axis_z_tlast_b, m_axis_z_tlast_operation : in  std_logic;
    signal user                                                         : out std_logic_vector) is
    variable v_user                            : std_logic_vector(user_width+has_tlast-1 downto 0) := (others => '0');
    variable index                             : integer                                           := 0;
    variable a_tlast, b_tlast, operation_tlast : std_logic;
  begin
    if c_has_a_tuser /= 0 then
      v_user(m_axis_z_tuser_a'high downto m_axis_z_tuser_a'low) := m_axis_z_tuser_a;
      index                                                     := index + m_axis_z_tuser_a'length;
    end if;
    if c_has_b_tuser /= 0 then
      v_user(m_axis_z_tuser_b'high+index downto m_axis_z_tuser_b'low+index) := m_axis_z_tuser_b;
      index                                                                 := index + m_axis_z_tuser_b'length;
    end if;
    if c_has_operation_tuser /= 0 then
      v_user(m_axis_z_tuser_operation'high+index downto m_axis_z_tuser_operation'low+index) := m_axis_z_tuser_operation;
      index                                                                                 := index + m_axis_z_tuser_operation'length;
    end if;
    -- Need a TLAST, possibly combined
    if c_has_a_tlast /= 0 or c_has_b_tlast /= 0 or c_has_operation_tlast /= 0 then

      if C_TLAST_RESOLUTION = CI_TLAST_OR_ALL then
        a_tlast         := '0';
        b_tlast         := '0';
        operation_tlast := '0';
      elsif C_TLAST_RESOLUTION = CI_TLAST_AND_ALL then
        a_tlast         := '1';
        b_tlast         := '1';
        operation_tlast := '1';
      end if;

      if c_has_a_tlast /= 0 then
        a_tlast := m_axis_z_tlast_a;
      end if;
      if c_has_b_tlast /= 0 then
        b_tlast := m_axis_z_tlast_b;
      end if;
      if c_has_operation_tlast /= 0 then
        operation_tlast := m_axis_z_tlast_operation;
      end if;

      case C_TLAST_RESOLUTION is
        when CI_TLAST_PASS_A =>
          v_user(index) := a_tlast;
        when CI_TLAST_PASS_B =>
          v_user(index) := b_tlast;
        when CI_TLAST_PASS_C =>
          v_user(index) := operation_tlast;
        when CI_TLAST_OR_ALL =>
          v_user(index) := (a_tlast or b_tlast or operation_tlast);
        when CI_TLAST_AND_ALL =>
          v_user(index) := (a_tlast and b_tlast and operation_tlast);
        when others =>
          assert false
            report "ERROR: build_user_in: illegal c_tlast_resolution value " & integer'image(c_tlast_resolution)
            severity error;
      end case;
    end if;
    user <= v_user;
  end procedure build_user_in;

  -- Create payload for output FIFO, consisting of internal core result,
  -- exception flags, and any TUSER and TLAST data
  procedure build_m_axis_fifo_in (
    constant c_result_width       : in  integer;
    constant user_width           : in  integer;
    constant has_tlast            : in  integer;
    constant output_fifo_width    : in  integer;
    constant c_has_underflow      : in  integer;
    constant c_has_overflow       : in  integer;
    constant c_has_invalid_op     : in  integer;
    constant c_has_divide_by_zero : in  integer;
    signal result                 : in  std_logic_vector;
    signal underflow              : in  std_logic;
    signal overflow               : in  std_logic;
    signal invalid_op             : in  std_logic;
    signal divide_by_zero         : in  std_logic;
    signal user                   : in  std_logic_vector;
    signal m_axis_fifo_in         : out std_logic_vector) is
    variable fifo_in      : std_logic_vector(output_fifo_width-1 downto 0);
    variable field_lsb    : integer;
    constant status_width : integer := c_has_underflow + c_has_overflow + c_has_invalid_op + c_has_divide_by_zero;
    variable status_bits  : std_logic_vector(status_width-1 downto 0);
    variable status_lsb   : integer := 0;
  begin
    fifo_in(c_result_width-1 downto 0) := result;
    field_lsb                          := c_result_width;
    if status_width > 0 then
      if c_has_underflow /= 0 then
        status_bits(status_lsb) := underflow;
        status_lsb              := status_lsb + 1;
      end if;
      if c_has_overflow /= 0 then
        status_bits(status_lsb) := overflow;
        status_lsb              := status_lsb + 1;
      end if;
      if c_has_invalid_op /= 0 then
        status_bits(status_lsb) := invalid_op;
        status_lsb              := status_lsb + 1;
      end if;
      if c_has_divide_by_zero /= 0 then
        status_bits(status_lsb) := divide_by_zero;
        status_lsb              := status_lsb + 1;
      end if;
      fifo_in(field_lsb+status_width-1 downto field_lsb) := status_bits;
      field_lsb                                          := field_lsb+status_width;
    end if;
    if user_width+has_tlast > 0 then
      fifo_in(output_fifo_width-1 downto field_lsb) := user;
    end if;
    m_axis_fifo_in <= fifo_in;
  end procedure build_m_axis_fifo_in;

  -- Split output FIFO data into separate payload fields for result channel
  procedure decompose_m_axis_fifo_out (
    constant c_has_compare        : in  integer;
    constant c_compare_operation  : in  integer;
    constant c_result_width       : in  integer;
    constant c_has_underflow      : in  integer;
    constant c_has_overflow       : in  integer;
    constant c_has_invalid_op     : in  integer;
    constant c_has_divide_by_zero : in  integer;
    constant user_width           : in  integer;
    constant has_tlast            : in  integer;
    signal m_axis_fifo_out        : in  std_logic_vector;
    signal m_axis_result_tdata    : out std_logic_vector;
    signal m_axis_result_tuser    : out std_logic_vector;
    signal m_axis_result_tlast    : out std_logic) is
    constant tuser_plus_flag_width : integer := user_width+c_has_underflow+c_has_overflow+c_has_invalid_op+c_has_divide_by_zero;
    variable tuser_lsb             : integer;
    variable tlast_bit             : integer;
  begin
    -- Sort out TDATA
    if c_has_compare /= 0 then
      if c_compare_operation /= FLT_PT_CONDITION_CODE then
        -- Single bit
        m_axis_result_tdata <= std_logic_vector(resize(unsigned(m_axis_fifo_out(0 downto 0)), m_axis_result_tdata'length));
        tuser_lsb           := 1;
      else
        -- 4 bits
        m_axis_result_tdata <= std_logic_vector(resize(unsigned(m_axis_fifo_out(3 downto 0)), m_axis_result_tdata'length));
        tuser_lsb           := 4;
      end if;
    else
      -- regular numeric output
      m_axis_result_tdata <= std_logic_vector(resize(signed(m_axis_fifo_out(c_result_width-1 downto 0)), m_axis_result_tdata'length));
      tuser_lsb           := c_result_width;
    end if;
    -- Sort out TUSER
    if tuser_plus_flag_width > 0 then
      m_axis_result_tuser <= m_axis_fifo_out(tuser_plus_flag_width+tuser_lsb-1 downto tuser_lsb);
    end if;
    -- Sort out TLAST, if present
    -- Should always be MSB of the FIFO data
    if has_tlast /= 0 then
      m_axis_result_tlast <= m_axis_fifo_out(m_axis_fifo_out'high);
    end if;
  end procedure decompose_m_axis_fifo_out;

end package body floating_point_pkg_v6_0;
