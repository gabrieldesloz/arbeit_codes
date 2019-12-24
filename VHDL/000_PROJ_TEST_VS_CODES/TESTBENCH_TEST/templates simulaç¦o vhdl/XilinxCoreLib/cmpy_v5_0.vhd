-- $Id: cmpy_v5_0.vhd,v 1.8 2011/03/02 13:59:10 gordono Exp $
--
--  (c) Copyright 2009-2011 Xilinx, Inc. All rights reserved.
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
---------------------------------------------------------------
-- Synthesizable model
---------------------------------------------------------------

-------------------------------------------------------------------------------
-- Design Notes and Functional description
--
-- This file is the top level of the synthesizable HDL of the Complex Multiplier.
-- In this file there is a single entity which contains the AXI interface
-- circuitry and an instantiation of the legacy (v3.1) complex multiplier. This entity
-- performs the mapping of the new AXI4-Stream interfaces to the legacy interfaces.
-- The core has an input channel per complex operand and a single output
-- channel for the complex result. An optional control channel exists to allow
-- the input of the rounding bit. For a full description of the AXI interfaces
-- see the axi proposal document in the spec directory.
-- There are several modes of AXI behaviour and implementation. The selection
-- is controlled by the generic C_THROTTLE_SCHEME as follows.
--
-- 1. C_THROTTLE_SCHEME = 0 (ci_no_throttle). This is the non-blocking scheme
-- implemented in v4.0 which is now deprecated. The code has been left in place
-- because the customer reaction to AXI implementations is, as yet, unknown.
-- See the axi proposal for a detailed description. In terms of implementation,
-- this scheme requires a register and LUT per bit of channel payload (TDATA, TUSER, TLAST).
--
-- 2. C_THROTTLE_SCHEME = 1 (ci_ce_throttle). This is a full AXI implementation
-- with FIFO behaviour on all channels. Part of the implementation involves
-- gating the CE to the core to freeze data, so as not to spill the output fifo.
-- This gating compromises performance (fmax) for a small output FIFO (single
-- SRL deep).
--
-- 3. C_THROTTLE_SCHEME = 2 (ci_rfd_throttle). This is also a full AXI
-- implementation, but without CE gating. The output FIFO has to be able to
-- capture all data in transit, so has to be as deep as the latency of the core.
--
-- 4. C_THROTTLE_SCHEME = 3 (ci_and_tvalid_throttle). This mode's primary
-- purpose is to provide a zero delta over v3.1 in resources. The spirit of AXI
-- is compromized to achieve this.
-- This scheme replaces ci_no_throttle (the non-blocking scheme of v4.0) in v5.0.
-- Here, the input channel tvalids are AND'd to produce a single TVALID (as
-- though all inputs shared a single channel), which, after the latency of the
-- core, becomes  TVALID for the output. 
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Modification history (described major changes only, not bugfixes)
-- Author: see xcs log
-- Date Created: ~September 2010
--
-- Modification description (v3.1 to v4.0):
-- The v3.1 top level (cmpy_<version>__xst (3.1)) was moved to become cmpy_<version>_
-- synth (v4.0), because
-- this file was introduced as a wrapper to hold the new AXI interfaces.
--
-- Modification description (v4.0 to v5.0):
-- The Non-blocking scheme (C_THROTTLE_SCHEME = ci_no_throttle) has been
-- replaced with C_THROTTLE_SCHEME = ci_and_tvalid_throttle. The old scheme has
-- actually been left in place in the hdl code for the contingency that some customer
-- prefers it. See the spec/cmpy_v5_0_axi_proposal.docx file for a description
-- of the new scheme's behaviour.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

--AXI utils contains slave and master FIFOs.
library xilinxcorelib;
use xilinxcorelib.axi_utils_pkg_v1_0.all;
use xilinxcorelib.axi_utils_v1_0_comps.all;

--xbip_pipe is the one-size-fits-all wire-register-shiftreg/ram
--of any width and any latency from 0 to N
library xilinxcorelib;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;

library xilinxcorelib;
use xilinxcorelib.cmpy_v5_0_pkg.all;

--core_if on entity cmpy_v5_0
  entity cmpy_v5_0 is
  generic (
    C_VERBOSITY               : integer := 0;-- 0 = errors only, 1 = + -- warnings,2 = + notes
    C_XDEVICEFAMILY           : string  := "no_family";  -- e.g. virtex7
    C_XDEVICE                 : string  := "no_family";
    C_A_WIDTH                 : integer := 16;  --width of first multiplicant components (real and imaginary)
    C_B_WIDTH                 : integer := 16;  --width of second multiplicant components (real and imaginary)
    C_OUT_WIDTH               : integer := 33;  -- MSB of product
    C_LATENCY                 : integer := 15;  -- Latency of CMPY (-1 = fully pipelined)
    C_MULT_TYPE               : integer := 1;   -- 0 = Use LUTs, 1 = Use MULT18X18x/DSP48x
    C_OPTIMIZE_GOAL           : integer := 0;   -- 0 = Minimise mult/DSP count, 1 = Performance
    HAS_NEGATE                : integer := 0;   -- 0=NEGATE_R/I disabled, 1=Apply negation to B inputs, 2=Apply negation to A inputs
    SINGLE_OUTPUT             : integer := 0;   -- Only generate real half of CMPY
    ROUND                     : integer := 0;   -- Add rounding constant for better noise performance
    USE_DSP_CASCADES          : integer := 1;   -- 0 = break cascades (S3A-DSP only), 1 = use cascades normally, 2 = chain all DSPs together
    --AXI-S generics
    C_THROTTLE_SCHEME         : integer := 3;   -- 0 = no throttle (OR TVALID), 1=CE throttle (full handshake, low performance), 2=RFD (full handshake, full performance) 3= AND TVALID
    C_HAS_ACLKEN              : integer := 0;   -- 0 = No clock enable, 1 = active-high clock enable
    C_HAS_ARESETN             : integer := 0;   -- 0 = No ARESETN, 1 = active-low ARESETN pin present.
    C_HAS_S_AXIS_A_TUSER      : integer := 0; --determines A TUSER port presence
    C_HAS_S_AXIS_A_TLAST      : integer := 0; --determines A TLAST port presence
    C_HAS_S_AXIS_B_TUSER      : integer := 0; --determines B TUSER port presence
    C_HAS_S_AXIS_B_TLAST      : integer := 0; --determines B TLAST port presence
    C_HAS_S_AXIS_CTRL_TUSER   : integer := 0; --determines CTRL TUSER port presence
    C_HAS_S_AXIS_CTRL_TLAST   : integer := 0; --determines CTRL TLAST port presence
    C_TLAST_RESOLUTION        : integer := 0; --0= no TLAST, 1= pass A, 2 = pass B, 3= pass CTRL, 16 = OR TLASTs, 17 = AND TLASTS.
    C_S_AXIS_A_TDATA_WIDTH    : integer := 32;--width of A TDATA port
    C_S_AXIS_A_TUSER_WIDTH    : integer := 1; --width of A TUSER port
    C_S_AXIS_B_TDATA_WIDTH    : integer := 32;--width of B TDATA port
    C_S_AXIS_B_TUSER_WIDTH    : integer := 1; --width of B TUSER port
    C_S_AXIS_CTRL_TDATA_WIDTH : integer := 8; --width of CTRL TDATA port
    C_S_AXIS_CTRL_TUSER_WIDTH : integer := 1; --width of CTRL TUSER port
    C_M_AXIS_DOUT_TDATA_WIDTH : integer := 80;--width of output TDATA port
    C_M_AXIS_DOUT_TUSER_WIDTH : integer := 1  --width of output TUSER port
    );
  port (
    aclk                 : in  std_logic := '0';--the master clock
    aclken               : in  std_logic := '1';--clock enable
    aresetn              : in  std_logic := '1';--synchronous active low reset, overrides aclken
    s_axis_a_tvalid      : in  std_logic := '0';--TVALID for channel A
    s_axis_a_tready      : out std_logic := '0';--TREADY for channel A
    s_axis_a_tuser       : in  std_logic_vector(C_S_AXIS_A_TUSER_WIDTH-1 downto 0)          := (others => '0');--TUSER for channel A
    s_axis_a_tlast       : in  std_logic := '0';--TLAST for channel A
    s_axis_a_tdata       : in  std_logic_vector(C_S_AXIS_A_TDATA_WIDTH-1 downto 0)          := (others => '0');--TDATA for channel A
    s_axis_b_tvalid      : in  std_logic := '0';--TVALID for channel B
    s_axis_b_tready      : out std_logic := '0';--TREADY for channel B
    s_axis_b_tuser       : in  std_logic_vector(C_S_AXIS_B_TUSER_WIDTH-1 downto 0)          := (others => '0');--TUSER for channel B
    s_axis_b_tlast       : in  std_logic := '0';--TLAST for channel B
    s_axis_b_tdata       : in  std_logic_vector(C_S_AXIS_B_TDATA_WIDTH-1 downto 0)          := (others => '0');--TDATA for channel B
    s_axis_ctrl_tvalid   : in  std_logic := '0';--TVALID for channel CTRL
    s_axis_ctrl_tready   : out std_logic := '0';--TREADY for channel CTRL
    s_axis_ctrl_tuser    : in  std_logic_vector(C_S_AXIS_CTRL_TUSER_WIDTH-1 downto 0)          := (others => '0');--TUSER for channel CTRL
    s_axis_ctrl_tlast    : in  std_logic := '0';--TLAST for channel CTRL
    s_axis_ctrl_tdata    : in  std_logic_vector(C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0)          := (others => '0');--TDATA for channel CTRL
    m_axis_dout_tvalid   : out std_logic := '0';--TVALID for channel dout
    m_axis_dout_tready   : in  std_logic := '0';--TREADY for channel dout
    m_axis_dout_tuser    : out std_logic_vector(C_M_AXIS_DOUT_TUSER_WIDTH-1 downto 0) := (others => '0'); --TUSER for channel out (concat of inputs with A in LS position).
    m_axis_dout_tlast    : out std_logic := '0';--TLAST for channel dout (function determined by C_TLAST_RESOLUTION)
    m_axis_dout_tdata    : out std_logic_vector(C_M_AXIS_DOUT_TDATA_WIDTH-1 downto 0) := (others => '0')--TDATA for channel dout
    );
--core_if off
end cmpy_v5_0;

architecture behavioral of cmpy_v5_0 is

  --the 'diplomatic bag' is a tube of latency equal to the latency of the cmpy
  --which conveys fields not used by this core, but which may contain system info.
  --the required width of the bag is the sum of present TUSERs plus one for
  --TLAST, if present. 
  type t_bag_widths is record
                        a_user    : integer; 
                        b_user    : integer;
                        ctrl_user : integer;
                        last      : integer;
                        total     : integer;
                      end record;
  function fn_calc_bag_width(           --calcs the required diplomatic bag width
    p_has_s_axis_a_tuser      : integer;
    p_has_s_axis_b_tuser      : integer;
    p_has_s_axis_ctrl_tuser   : integer;
    p_has_s_axis_a_tlast      : integer;
    p_has_s_axis_b_tlast      : integer;
    p_has_s_axis_ctrl_tlast   : integer;
    p_s_axis_a_tuser_width    : integer;
    p_s_axis_b_tuser_width    : integer;
    p_s_axis_ctrl_tuser_width : integer
    )
    return t_bag_widths is
    variable v_tally : t_bag_widths;
  begin  -- fn_calc_bag_width
    v_tally := (0,0,0,0,0);
    if p_has_s_axis_a_tuser /= 0 then
      v_tally.a_user := p_s_axis_a_tuser_width;
    end if;
    if p_has_s_axis_b_tuser /= 0 then
      v_tally.b_user := p_s_axis_b_tuser_width;
    end if;
    if p_has_s_axis_ctrl_tuser /= 0 then
      v_tally.ctrl_user := p_s_axis_ctrl_tuser_width;
    end if;
    if (p_has_s_axis_a_tlast /= 0) or (p_has_s_axis_b_tlast /= 0) or (p_has_s_axis_ctrl_tlast /= 0) then
      v_tally.last := 1;
    end if;
    v_tally.total := v_tally.a_user +
                     v_tally.b_user +
                     v_tally.ctrl_user +
                     v_tally.last;
    return v_tally;
  end fn_calc_bag_width;
  constant ci_diplomatic_bag_width : t_bag_widths := fn_calc_bag_width(
    p_has_s_axis_a_tuser      => C_HAS_S_AXIS_A_TUSER,
    p_has_s_axis_b_tuser      => C_HAS_S_AXIS_B_TUSER,
    p_has_s_axis_ctrl_tuser   => C_HAS_S_AXIS_CTRL_TUSER,
    p_has_s_axis_a_tlast      => C_HAS_S_AXIS_A_TLAST,
    p_has_s_axis_b_tlast      => C_HAS_S_AXIS_B_TLAST,
    p_has_s_axis_ctrl_tlast   => C_HAS_S_AXIS_CTRL_TLAST,
    p_s_axis_a_tuser_width    => C_S_AXIS_A_TUSER_WIDTH,
    p_s_axis_b_tuser_width    => C_S_AXIS_B_TUSER_WIDTH,
    p_s_axis_ctrl_tuser_width => C_S_AXIS_CTRL_TUSER_WIDTH
    );
  signal diag_diplomatic_bag_width : t_bag_widths := ci_diplomatic_bag_width;

  --Each channel may have a FIFO which is controled by TVALID and TREADY. All
  --the other fields are concatenated to make a payload. Its width is calced here.
  constant ci_chan_a_width    : integer := ci_diplomatic_bag_width.a_user + -- The TUSER field
                                           C_HAS_S_AXIS_A_TLAST +  -- The TLAST field
                                           C_A_WIDTH*2;  --Both real and imaginary are concatenated to the TDATA field.
  constant ci_chan_b_width    : integer := ci_diplomatic_bag_width.b_user + -- The TUSER field
                                           C_HAS_S_AXIS_B_TLAST + -- The TLAST field
                                           C_B_WIDTH*2;   --Both real and imaginary are concatenated to the TDATA field.
  constant ci_chan_ctrl_width : integer := ci_diplomatic_bag_width.ctrl_user +-- The TUSER field
                                           C_HAS_S_AXIS_CTRL_TLAST +-- The TLAST field
                                           1;  --the rounding bit.
  constant ci_chan_dout_width : integer := ci_diplomatic_bag_width.total + -- holds TUSER and TLAST 
                                           C_OUT_WIDTH*2; --Both real and imaginary are concatenated to the TDATA field.

  constant ci_has_ctrl_channel : boolean := boolean(ROUND = 1);
  
  --check legality of parameter values
  constant generics : R_GENERICS := check_and_resolve_generics(
    C_VERBOSITY               => C_VERBOSITY,
    C_XDEVICEFAMILY           => C_XDEVICEFAMILY,
    C_XDEVICE                 => C_XDEVICE,
    C_A_WIDTH                 => C_A_WIDTH,
    C_B_WIDTH                 => C_B_WIDTH,
    C_OUT_WIDTH               => C_OUT_WIDTH,
    C_LATENCY                 => C_LATENCY,
    C_MULT_TYPE               => C_MULT_TYPE,
    C_OPTIMIZE_GOAL           => C_OPTIMIZE_GOAL,
    HAS_NEGATE                => HAS_NEGATE,
    SINGLE_OUTPUT             => SINGLE_OUTPUT,
    ROUND                     => ROUND,
    USE_DSP_CASCADES          => USE_DSP_CASCADES,
    C_THROTTLE_SCHEME         => C_THROTTLE_SCHEME,  --  0=no throttle, 1=CE throttle, 2=RFD Throttle is it ok to overload like this?
    C_HAS_ACLKEN              => C_HAS_ACLKEN,  --  0 = No clock enable, 1 = active-high clock enable
    C_HAS_ARESETN             => C_HAS_ARESETN,  --  0 = No clock enable, 1 = active-high clock enable
    C_HAS_S_AXIS_A_TUSER      => C_HAS_S_AXIS_A_TUSER,
    C_HAS_S_AXIS_A_TLAST      => C_HAS_S_AXIS_A_TLAST,
    C_HAS_S_AXIS_B_TUSER      => C_HAS_S_AXIS_B_TUSER,
    C_HAS_S_AXIS_B_TLAST      => C_HAS_S_AXIS_B_TLAST,
    C_HAS_S_AXIS_CTRL_TUSER   => C_HAS_S_AXIS_CTRL_TUSER,
    C_HAS_S_AXIS_CTRL_TLAST   => C_HAS_S_AXIS_CTRL_TLAST,
    C_TLAST_RESOLUTION        => C_TLAST_RESOLUTION,  -- 0= pass A, 1 = pass B, 2= pass CTRL, 16 = OR TLASTs, 17 = AND TLASTS.   
    C_S_AXIS_A_TDATA_WIDTH    => C_S_AXIS_A_TDATA_WIDTH,
    C_S_AXIS_A_TUSER_WIDTH    => C_S_AXIS_A_TUSER_WIDTH,
    C_S_AXIS_B_TDATA_WIDTH    => C_S_AXIS_B_TDATA_WIDTH,
    C_S_AXIS_B_TUSER_WIDTH    => C_S_AXIS_B_TUSER_WIDTH,
    C_S_AXIS_CTRL_TDATA_WIDTH => C_S_AXIS_CTRL_TDATA_WIDTH,
    C_S_AXIS_CTRL_TUSER_WIDTH => C_S_AXIS_CTRL_TUSER_WIDTH,
    C_M_AXIS_DOUT_TDATA_WIDTH => C_M_AXIS_DOUT_TDATA_WIDTH,
    C_M_AXIS_DOUT_TUSER_WIDTH => C_M_AXIS_DOUT_TUSER_WIDTH
    );
  signal diag_generics : R_GENERICS := generics;

  --make various implementation decisions
  constant real_cmpy_arch : T_CMPY_ARCH := select_cmpy_arch(
    XDEVICEFAMILY   => C_XDEVICEFAMILY,
    A_WIDTH         => generics.R_A_WIDTH,
    B_WIDTH         => generics.R_B_WIDTH,
    MULT_TYPE       => generics.R_MULT_TYPE,
    OPTIMIZE_GOAL   => generics.R_OPTIMIZE_GOAL,
    SINGLE_OUTPUT   => generics.R_SINGLE_OUTPUT
    );
  signal diag_real_cmpy_arch : T_CMPY_ARCH := real_cmpy_arch;

  
  constant ci_lat_min_axififo : integer := 3;  --minimum latency of AXI FIFOs (
  -- 1 from slave combiner, 2 from output)

  --record to hold latency of AXI wrapper and internal core.
  type t_axi_latency is record
    wrap_lat : integer;
    core_lat : integer;
  end record;
  -- purpose: splits latency into latency for core and latency for AXI
  function fn_alloc_axi_latency (
    LATENCY       : integer;
    THROTTLE_SCHEME : integer;
    p_lat_min_axififo : integer
    )
    return t_axi_latency is
    variable ret_val : t_axi_latency;
  begin  -- fn_alloc_axi_latency
    if THROTTLE_SCHEME = 3 then
      if LATENCY = 0 then
        ret_val.core_lat := 0;
        ret_val.wrap_lat := 0;
      elsif LATENCY > 0 then
        ret_val.core_lat := LATENCY;
        ret_val.wrap_lat := 0;
        -- coverage off
      else
        --for characterization only - allows LATENCY to be set to -1
        assert false
          report "WARNING: cmpy_v5_0_xst: This clause should only be accessed in characterization"
          severity warning;
        assert LATENCY = -1
          report "ERROR: cmpy_v5_0_xst: negative latency can only be -1. Got "&integer'image(LATENCY)
          severity error;
        ret_val.core_lat := -1;
        ret_val.wrap_lat := 0;
        -- coverage on
      end if;
      -- coverage off
      --throttle_scheme = 0 is OR TVALIDS, kept in v5.0 until we know AND TVALID is preferred
    elsif THROTTLE_SCHEME = 0 then
      if LATENCY = 0 then
        ret_val.core_lat := 0;
        ret_val.wrap_lat := 0;
      elsif LATENCY > 0 then
        ret_val.core_lat := LATENCY-1;
        ret_val.wrap_lat := 1;
      else
        --for characterization only - allows LATENCY to be set to -1
        assert false
          report "WARNING: cmpy_v5_0_xst: This clause should only be accessed in characterization"
          severity warning;
        assert LATENCY = -1
          report "ERROR: cmpy_v5_0_xst: negative latency can only be -1. Got "&integer'image(LATENCY)
          severity error;
        ret_val.core_lat := -1;
        ret_val.wrap_lat := 1;
      end if;
      -- coverage on
    else
      ret_val.wrap_lat := p_lat_min_axififo;
      -- coverage off
      -- Latency = -1 is never passed by GUI, it's a shorthand for local testing
      if LATENCY = -1 then
        ret_val.core_lat := -1;
        -- coverage on
      else
        ret_val.core_lat := LATENCY-p_lat_min_axififo;
        assert ret_val.core_lat >0
          report "ERROR: cmpy_v5_0_xst: invalid latency detected in fn_alloc_axi_latency"
          severity error;
      end if;
    end if;
    return ret_val;
  end fn_alloc_axi_latency;
  constant ci_axi_latency : t_axi_latency := fn_alloc_axi_latency(
    LATENCY           => C_LATENCY,
    THROTTLE_SCHEME   => C_THROTTLE_SCHEME,
    p_lat_min_axififo => ci_lat_min_axififo
    );

  --Resolve actual latency of internal core (minus AXI wrapper)
  constant ci_cmpy_latency : integer := cmpy_v5_0_latency_internal(
    XDEVICEFAMILY => C_XDEVICEFAMILY,
    ARCH          => real_cmpy_arch,
    A_WIDTH       => generics.R_A_WIDTH,
    B_WIDTH       => generics.R_B_WIDTH,
    OUT_HIGH      => generics.R_OUT_HIGH,
    OUT_LOW       => generics.R_OUT_LOW,
    LATENCY       => ci_axi_latency.core_lat,
    MULT_TYPE     => generics.R_MULT_TYPE,
    OPTIMIZE_GOAL => generics.R_OPTIMIZE_GOAL,
    SINGLE_OUTPUT => generics.R_SINGLE_OUTPUT,
    HAS_NEGATE    => generics.R_HAS_NEGATE,
    ROUND         => generics.R_ROUND
    );


  --CE to core may be user requested, or used to implement AXI throttling
  function fn_core_has_ce (
    p_has_aclken      : integer;
    p_throttle_scheme : integer;
    p_latency         : integer)
    return integer is
  begin  -- fn_core_has_ce
    if p_latency > 0 and (p_has_aclken = 1 or C_THROTTLE_SCHEME = ci_ce_throttle) then
      return 1;
    end if;
    return 0;
  end fn_core_has_ce;
  constant ci_core_has_ce : integer := fn_core_has_ce(
    p_has_aclken      => C_HAS_ACLKEN,
    p_throttle_scheme => C_THROTTLE_SCHEME,
    p_latency         => ci_cmpy_latency
    );

  function fn_core_has_aresetn (
    p_latency     : integer;
    p_has_aresetn : integer)
    return integer is
  begin  -- fn_core_has_aresetn
    if p_latency = 0 then
      return 0;
    end if;
    return p_has_aresetn;
  end fn_core_has_aresetn;
  constant ci_core_has_aresetn : integer := fn_core_has_aresetn(
    p_latency     => ci_cmpy_latency,
    p_has_aresetn => C_HAS_ARESETN
    );

  --Check_generics, architecture selection and latency calculations
  --are executed in the cmpy_v5_0_synth entity.
  
  signal ce_if      : std_logic := '1';  --ce to AXI fifos
  signal core_ce    : std_logic := '1';  --ce to internal (legacy) core
  signal sclr_d     : std_logic := '0';  --combinatorial reset ...
  signal sclr_i     : std_logic := '0';  --...then registered
  signal rdy_if     : std_logic := '0';  --indicates data from core should be valid.

  signal outfifo_has_room        : std_logic := '0'; 

  --the following 2 signals indicate a valid transfer into the core (like ND),
  --but differ by 
  signal valid_access_in         : std_logic := '0';  --ND
  signal valid_access_in_delayed : std_logic := '0';  --ND delayed by core latency (RFD, but in core_ce domain)
  signal ok_to_pull_data : std_logic := '0';  -- CE signal to core used in CE throttling scheme.
                                              -- Indicates that output fifo has room to accommodate data.
                                              -- Cannot use valid_data_in because then data propagation would rely on following data

  -----------------------------------------------------------------------------
  -- The AXI channels have many optional fields (TUSER and TLAST) which are
  -- concatenated to make a channel message and further concatenated to create
  -- a message to the core (an operation). Some of that message is split off to
  -- make a payload for the diplomatic bag. Hence a lot of splicing and dicing
  -----------------------------------------------------------------------------
  --x_skid_in is the message of the channel (user, last, and data)
  --x_out_pre is in, registered (gated by tvalid and CE)
  --x_out is either in registered (non-zero latency, or zero latency when invalid
  --inputs) or pre-register for the zero latency case.

  --the following signals are for OR_tvalid, i.e. C_THROTTLE_SCHEME = ci_no_throttle
                                      
  -- signal chan_a_skid_in         : std_logic_vector(ci_chan_a_width-1 downto 0)   := (others => '0');
  -- signal chan_a_skid_out_pre    : std_logic_vector(ci_chan_a_width-1 downto 0)   := (others => '0');
  -- signal chan_a_skid_out        : std_logic_vector(ci_chan_a_width-1 downto 0)   := (others => '0');
  -- signal chan_b_skid_in         : std_logic_vector(ci_chan_b_width-1 downto 0)   := (others => '0');
  -- signal chan_b_skid_out_pre    : std_logic_vector(ci_chan_b_width-1 downto 0)   := (others => '0');
  -- signal chan_b_skid_out        : std_logic_vector(ci_chan_b_width-1 downto 0)   := (others => '0');
  -- signal chan_ctrl_skid_in      : std_logic_vector(ci_chan_ctrl_width-1 downto 0) := (others => '0');
  -- signal chan_ctrl_skid_out_pre : std_logic_vector(ci_chan_ctrl_width-1 downto 0) := (others => '0');
  -- signal chan_ctrl_skid_out     : std_logic_vector(ci_chan_ctrl_width-1 downto 0) := (others => '0');
                                        
  signal chan_dout_fifo_in      : std_logic_vector(ci_chan_dout_width-1 downto 0) := (others => '0');
  signal chan_dout_fifo_out     : std_logic_vector(ci_chan_dout_width-1 downto 0) := (others => '0');

  -- signal chan_a_skid_user            : std_logic_vector(C_S_AXIS_A_TUSER_WIDTH-1 DOWNTO 0)                                      := (others => '0');
  -- signal chan_a_skid_last            : std_logic                                                                                := '0';
  -- signal chan_a_skid_and_last        : std_logic                                                                                := '1';
  -- signal chan_b_skid_user            : std_logic_vector(C_S_AXIS_B_TUSER_WIDTH-1 DOWNTO 0)                                      := (others => '0');
  -- signal chan_b_skid_last            : std_logic                                                                                := '0';
  -- signal chan_b_skid_and_last        : std_logic                                                                                := '1';
  -- signal chan_ctrl_skid_user         : std_logic_vector(C_S_AXIS_CTRL_TUSER_WIDTH-1 downto 0)                                   := (others => '0');
  -- signal chan_ctrl_skid_last         : std_logic                                                                                := '0';
  -- signal chan_ctrl_skid_and_last     : std_logic                                                                                := '1';

  signal dip_in_tlast : std_logic := '0';  -- dip means diplomatic bag
  signal dip_in_tuser : std_logic_vector(ci_diplomatic_bag_width.a_user + ci_diplomatic_bag_width.b_user + ci_diplomatic_bag_width.ctrl_user-1  downto 0) := (others => '0');

  --slave fifo to combiner control signals
  -- signal chan_a_skid_avail_out        : std_logic := '0';
  -- signal chan_b_skid_avail_out        : std_logic := '0';
  -- signal chan_ctrl_skid_avail_out     : std_logic := '0';
  -- signal chan_a_skid_not_empty_out    : std_logic := '0';
  -- signal chan_b_skid_not_empty_out    : std_logic := '0';
  -- signal chan_ctrl_skid_not_empty_out : std_logic := '0';


  --The output FIFO is as deep as the 'stopping distance' of the core.
  --In other words, will absorb transfers until any throttling can be
  --propogated back to the inputs. Where the core is choked using CE, the FIFO
  --is small because the effect is fast, but gating CE prevents full fmax.
  --For full performance, data into the core is choked, so the FIFO has to be
  --able to absorb all data already in the core - i.e. the latency of the core.
  function fn_outfifo_depth (
    p_latency : integer;
    p_scheme  : integer)
    return integer is
    variable ret_val : integer := 0;
    variable v_req_depth : integer := 0;
  begin  -- fn_outwidth_depth
    case p_scheme is
      -- coverage off
      --ci_no_throttle (old code) kept in place till AND TVALID is accepted by customers
--      when ci_no_throttle =>
--        null;
        -- coverage on
      when ci_and_tvalid_throttle =>  
        v_req_depth := 0;             
      when ci_ce_throttle =>  -- no need to be accurate so long as its
        v_req_depth := 3;             -- <16, since that's the point at which resources grow.
      when ci_rfd_throttle =>
        v_req_depth := p_latency + 3;
        -- coverage off
        --error trap code. Never expected to be called.
      when others =>
        assert false
          report "ERROR: unknown throttle scheme in fn_outfifo_depth"
          severity error;
        -- coverage on
    end case;
    ret_val := 2**log2roundup(v_req_depth);
    return ret_val;
  end fn_outfifo_depth;
  constant ci_outfifo_depth : integer := fn_outfifo_depth(
    p_latency => ci_cmpy_latency,
    p_scheme  => c_throttle_scheme
    );

  --input combiner signals (wire-thru for AND-tvalid)
    signal m_axis_z_tdata_a : std_logic_vector(c_s_axis_a_tdata_width-1 downto 0) := (others => '0');
    signal m_axis_z_tuser_a : std_logic_vector(c_s_axis_a_tuser_width-1 downto 0) := (others => '0');
    signal m_axis_z_tlast_a : std_logic := '0';
    signal m_axis_z_tdata_b : std_logic_vector(c_s_axis_b_tdata_width-1 downto 0) := (others => '0');
    signal m_axis_z_tuser_b : std_logic_vector(c_s_axis_b_tuser_width-1 downto 0) := (others => '0');
    signal m_axis_z_tlast_b : std_logic := '0';
    signal m_axis_z_tdata_ctrl : std_logic_vector(c_s_axis_ctrl_tdata_width-1 downto 0) := (others => '0');
    signal m_axis_z_tuser_ctrl : std_logic_vector(c_s_axis_ctrl_tuser_width-1 downto 0) := (others => '0');
    signal m_axis_z_tlast_ctrl : std_logic := '0';
  --The combiner FIFO performs the 'blocking' function of input channels, i.e.
  --data must be available from all before the core is asked to perform.
  signal combiner_data_out_valid : std_logic := '0';

  signal sround : std_logic := '0';     --the rounding bit

  --the following signals used to be the legacy core interface prior to AXI.
  --AXI TDATAs are spliced to form these signals which are then fed to the
  --internal entity which is, surprise surprise, the legacy core.
  --Note that the input FIFOs only pipe the used portion of the AXI TDATA, not
  --the padding too.
  --  signal ar_in : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  --  signal ai_in : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  --  signal br_in : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  --  signal bi_in : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  signal ar : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  signal ai : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  signal br : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  signal bi : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  signal pr : std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0');
  signal pi : std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0');

begin
  -----------------------------------------------------------------------------
  -- AXI wrappings
  -----------------------------------------------------------------------------
  --ARESETN is active low, so is inverted to make an SCLR, but is also
  --registered for speed, as the SCLR port on many primitives is slow.
  i_has_aresetn: if C_HAS_ARESETN = 1 generate
    sclr_d <= not (ARESETN);
    i_reg_reset : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => 1,
        C_HAS_CE   => 0,
        C_HAS_SCLR => 0,                  --! as if.
        C_WIDTH    => 1
        )
      port map(
        CLK  => ACLK,
        D(0) => sclr_d,
        Q(0) => sclr_i
        );
  end generate i_has_aresetn;
  i_no_aresetn: if C_HAS_ARESETN = 0 generate
    sclr_i <= '0';
  end generate i_no_aresetn;
  
  --Need to create bypass ND -> RDY, as legacy core doesn't have ND/RFD/RDY.
  i_nd_to_rdy : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_cmpy_latency,
      C_HAS_CE   => 1,
      C_HAS_SCLR => C_HAS_ARESETN,
      C_WIDTH    => 1
      )
    port map(
      CLK  => ACLK,
      CE   => core_ce,
      SCLR => sclr_i,
      D(0) => valid_access_in,          --equivalent to ND.
      Q(0) => valid_access_in_delayed   --equivalent to RDY
      );

  --De-CE-domain to make a single clock wide rdy pulse.
  rdy_if <= core_ce and valid_access_in_delayed;

  -----------------------------------------------------------------------------
  --diplomatic bag: carriage of signals on input channels to output channels
  --which the core has no interest in, but may be of significance in a system context.
  -----------------------------------------------------------------------------
  i_has_diplomatic_bag : if ci_diplomatic_bag_width.total > 0 generate
    signal diplomatic_in  : std_logic_vector(ci_diplomatic_bag_width.total-1 downto 0) := (others => '0');
    signal diplomatic_out : std_logic_vector(ci_diplomatic_bag_width.total-1 downto 0) := (others => '0');
  begin
    i_tlast_dip : if (C_HAS_S_AXIS_A_TLAST /= 0) or (C_HAS_S_AXIS_B_TLAST /= 0) or (C_HAS_S_AXIS_CTRL_TLAST /= 0) generate
      i_tuser_dip : if (C_HAS_S_AXIS_A_TUSER /= 0) or (C_HAS_S_AXIS_B_TUSER /= 0) or (C_HAS_S_AXIS_CTRL_TUSER /= 0) generate
        diplomatic_in <= dip_in_tuser & dip_in_tlast;
      end generate i_tuser_dip;
      i_no_tuser_dip : if (C_HAS_S_AXIS_A_TUSER = 0) and (C_HAS_S_AXIS_B_TUSER = 0) and (C_HAS_S_AXIS_CTRL_TUSER = 0) generate
        diplomatic_in(0) <= dip_in_tlast;
      end generate i_no_tuser_dip;
    end generate i_tlast_dip;
    i_no_tlast_dip : if (C_HAS_S_AXIS_A_TLAST = 0) and (C_HAS_S_AXIS_B_TLAST = 0) and (C_HAS_S_AXIS_CTRL_TLAST = 0) generate
      i_tuser_dip : if (C_HAS_S_AXIS_A_TUSER /= 0) or (C_HAS_S_AXIS_B_TUSER /= 0) or (C_HAS_S_AXIS_CTRL_TUSER /= 0) generate
        diplomatic_in <= dip_in_tuser;
      end generate i_tuser_dip;
      -- no need to handle case where all 3 TUSERS and all 3 TLASTS are off -
      -- there will be no diplomatic bag in that case
    end generate i_no_tlast_dip;

    i_diplomatic_bag : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_cmpy_latency,
        C_HAS_CE   => 1,
        C_HAS_SCLR => C_HAS_ARESETN,
        C_WIDTH    => ci_diplomatic_bag_width.total
        )
      port map(
        CLK  => ACLK,
        CE   => core_ce,
        SCLR => sclr_i,
        D    => diplomatic_in,
        Q    => diplomatic_out
        );

    chan_dout_fifo_in <= diplomatic_out & pi & pr;

  end generate i_has_diplomatic_bag;

  i_has_no_diplomatic_bag: if ci_diplomatic_bag_width.total = 0 generate
    chan_dout_fifo_in <= pi & pr;
  end generate i_has_no_diplomatic_bag;

  --end of diplomatic bag.


  i_tlast_res : if (C_HAS_S_AXIS_A_TLAST /= 0) or (C_HAS_S_AXIS_B_TLAST /= 0) or (C_HAS_S_AXIS_CTRL_TLAST /= 0) generate
    signal a_tlast : std_logic := '0';
    signal b_tlast : std_logic := '0';
    signal ctrl_tlast : std_logic := '0';
  begin
    i_pass_a : if (C_TLAST_RESOLUTION = ci_tlast_res_pass_a) generate
      dip_in_tlast <= m_axis_z_tlast_a;
    end generate i_pass_a;
    i_pass_b : if (C_TLAST_RESOLUTION = ci_tlast_res_pass_b) generate
      dip_in_tlast <= m_axis_z_tlast_b;      
    end generate i_pass_b;
    i_pass_ctrl : if (C_TLAST_RESOLUTION = ci_tlast_res_pass_ctrl) generate
      dip_in_tlast <= m_axis_z_tlast_ctrl;      
    end generate i_pass_ctrl;
    i_or_all : if C_TLAST_RESOLUTION = ci_tlast_res_or_all generate
    begin
      a_tlast      <= m_axis_z_tlast_a when C_HAS_S_AXIS_A_TLAST = 1 else '0';
      b_tlast      <= m_axis_z_tlast_b when C_HAS_S_AXIS_B_TLAST = 1 else '0';
      ctrl_tlast   <= m_axis_z_tlast_ctrl when C_HAS_S_AXIS_CTRL_TLAST = 1 else '0';
      dip_in_tlast <= '1' when a_tlast = '1' or b_tlast = '1' or ctrl_tlast = '1' else '0';
    end generate i_or_all;
    i_and_all : if C_TLAST_RESOLUTION = ci_tlast_res_and_all generate
    begin
      a_tlast      <= '1' when C_HAS_S_AXIS_A_TLAST = 0 else m_axis_z_tlast_a;
      b_tlast      <= '1' when C_HAS_S_AXIS_B_TLAST = 0 else m_axis_z_tlast_b;
      ctrl_tlast   <= '1' when C_HAS_S_AXIS_CTRL_TLAST = 0 else m_axis_z_tlast_ctrl;
      dip_in_tlast <= '1' when a_tlast = '1' and b_tlast = '1' and ctrl_tlast = '1' else '0';
    end generate i_and_all;
  end generate i_tlast_res;

  i_user_res_a : if C_HAS_S_AXIS_A_TUSER = 1 generate
    i_user_res_b : if C_HAS_S_AXIS_B_TUSER = 1 generate
      i_user_res_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 1 generate
        dip_in_tuser <= m_axis_z_tuser_ctrl & m_axis_z_tuser_b & m_axis_z_tuser_a;
      end generate i_user_res_ctrl;
      i_user_res_no_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 0 generate
        dip_in_tuser <= m_axis_z_tuser_b & m_axis_z_tuser_a;
      end generate i_user_res_no_ctrl;
    end generate i_user_res_b;
    i_user_res_no_b : if C_HAS_S_AXIS_B_TUSER = 0 generate
      i_user_res_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 1 generate
        dip_in_tuser <= m_axis_z_tuser_ctrl & m_axis_z_tuser_a;
      end generate i_user_res_ctrl;
      i_user_res_no_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 0 generate
        dip_in_tuser <= m_axis_z_tuser_a;
      end generate i_user_res_no_ctrl;
    end generate i_user_res_no_b;
  end generate i_user_res_a;
  i_user_res_no_a : if C_HAS_S_AXIS_A_TUSER = 0 generate
    i_user_res_b : if C_HAS_S_AXIS_B_TUSER = 1 generate
      i_user_res_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 1 generate
        dip_in_tuser <= m_axis_z_tuser_ctrl & m_axis_z_tuser_b;
      end generate i_user_res_ctrl;
      i_user_res_no_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 0 generate
        dip_in_tuser <=  m_axis_z_tuser_b;
      end generate i_user_res_no_ctrl;
    end generate i_user_res_b;
    i_user_res_no_b : if C_HAS_S_AXIS_B_TUSER = 0 generate
      i_user_res_ctrl : if C_HAS_S_AXIS_CTRL_TUSER = 1 generate
        dip_in_tuser <= m_axis_z_tuser_ctrl;
      end generate i_user_res_ctrl;
      --no need for 'else generate' as there are no signals to do anything to!
    end generate i_user_res_no_b;
  end generate i_user_res_no_a;


  -----------------------------------------------------------------------------
  -- Start of datapath elements
  -- The splicing and dicing is the same regardless of delays, protocol or
  -- handshaking. It's all just a case of where bits sit in a bus.
  -- Now to consider the other dimension - the delays and control.
  -----------------------------------------------------------------------------

  --With throttling, FIFOs are required.
  i_with_throttle : if C_THROTTLE_SCHEME = ci_ce_throttle or C_THROTTLE_SCHEME = ci_rfd_throttle generate

    
    begin
    ---------------------------------------------------------------------------
    -- reset and clock enable shenanigins 
    ---------------------------------------------------------------------------

    i_ce_if : if C_HAS_ACLKEN = 1 generate
      ce_if <= ACLKEN;                  --else defaults to '1'
    end generate i_ce_if;

    i_core_ce1 : if C_HAS_ACLKEN = 0 generate  --no ce to core
      -- coverage off
--      i_no_throttle : if C_THROTTLE_SCHEME = ci_no_throttle generate
--        core_ce <= '1';
--      end generate i_no_throttle;
      -- coverage on
      i_throttle_ce : if C_THROTTLE_SCHEME = ci_ce_throttle generate
--        core_ce <= valid_access_in;     --&&& - nocando - must be self-
                                                --propagating rather than rely
                                                --on following data - CR565774
        core_ce <= ok_to_pull_data;
      end generate i_throttle_ce;
      i_throttle_nd : if C_THROTTLE_SCHEME = ci_rfd_throttle generate
        core_ce <= '1';
      end generate i_throttle_nd;
    end generate i_core_ce1;
    i_core_ce2 : if C_HAS_ACLKEN = 1 generate  --external ce to core
      -- coverage off
--      i_no_throttle : if C_THROTTLE_SCHEME = ci_no_throttle generate
--        core_ce <= ACLKEN;
--      end generate i_no_throttle;
      -- coverage on
      i_throttle_ce : if C_THROTTLE_SCHEME = ci_ce_throttle generate
        --the following comment is to highlight a gotcha, not commented out
        --code as such. The next line used to read:
        --core_ce <= valid_access_in and ACLKEN;
        --This fails because the data must be self-propagating rather than rely
        --on following data - CR565774
        core_ce <= ok_to_pull_data and ACLKEN;
      end generate i_throttle_ce;
      i_throttle_nd : if C_THROTTLE_SCHEME = ci_rfd_throttle generate
        core_ce <= ACLKEN;
      end generate i_throttle_nd;
    end generate i_core_ce2;

    ---------------------------------------------------------------------------
    -- Skid buffers (input buffers) also known as FIFOs.
    ---------------------------------------------------------------------------
    -- real is considered LS of TDATA concatenation to
    -- simplify complex to real translation.     

    --the new, smaller, multichannel input skid-buffer.
    i_has_2to1 : if not(ci_has_ctrl_channel) generate
      i_2to1 : axi_slave_2to1_v1_0
        generic map(
          C_A_TDATA_WIDTH => c_s_axis_a_tdata_width,      
          C_HAS_A_TUSER   => (c_has_s_axis_a_tuser = 1),  
          C_A_TUSER_WIDTH => c_s_axis_a_tuser_width,      
          C_HAS_A_TLAST   => (c_has_s_axis_a_tlast = 1),  
          C_B_TDATA_WIDTH => c_s_axis_b_tdata_width,      
          C_HAS_B_TUSER   => (c_has_s_axis_b_tuser = 1),  
          C_B_TUSER_WIDTH => c_s_axis_b_tuser_width,      
          C_HAS_B_TLAST   => (c_has_s_axis_b_tlast = 1),  
          C_HAS_Z_TREADY  => true                         
          )
        port map(
          aclk   => aclk,               
          aclken => ce_if,              
          sclr   => sclr_i,             

          -- AXI slave interface A
          s_axis_a_tready => s_axis_a_tready,  
          s_axis_a_tvalid => s_axis_a_tvalid,  
          s_axis_a_tdata  => s_axis_a_tdata,   
          s_axis_a_tuser  => s_axis_a_tuser,   
          s_axis_a_tlast  => s_axis_a_tlast,   

          -- AXI slave interface B
          s_axis_b_tready => s_axis_b_tready,  
          s_axis_b_tvalid => s_axis_b_tvalid,  
          s_axis_b_tdata  => s_axis_b_tdata,   
          s_axis_b_tuser  => s_axis_b_tuser,   
          s_axis_b_tlast  => s_axis_b_tlast,   

          -- Read interface to core
          m_axis_z_tready  => ok_to_pull_data,        
          m_axis_z_tvalid  => combiner_data_out_valid,
          m_axis_z_tdata_a => m_axis_z_tdata_a,       
          m_axis_z_tuser_a => m_axis_z_tuser_a,       
          m_axis_z_tlast_a => m_axis_z_tlast_a,       
          m_axis_z_tdata_b => m_axis_z_tdata_b,       
          m_axis_z_tuser_b => m_axis_z_tuser_b,       
          m_axis_z_tlast_b => m_axis_z_tlast_b        
          );
    end generate i_has_2to1;
    
    i_has_3to1: if ci_has_ctrl_channel generate
      i_3to1 : axi_slave_3to1_v1_0
        generic map(
          C_A_TDATA_WIDTH => c_s_axis_a_tdata_width,         
          C_HAS_A_TUSER   => (c_has_s_axis_a_tuser = 1),     
          C_A_TUSER_WIDTH => c_s_axis_a_tuser_width,         
          C_HAS_A_TLAST   => (c_has_s_axis_a_tlast = 1),     
          C_B_TDATA_WIDTH => c_s_axis_b_tdata_width,         
          C_HAS_B_TUSER   => (c_has_s_axis_b_tuser = 1),     
          C_B_TUSER_WIDTH => c_s_axis_b_tuser_width,         
          C_HAS_B_TLAST   => (c_has_s_axis_b_tlast = 1),     
          C_C_TDATA_WIDTH => c_s_axis_ctrl_tdata_width,      
          C_HAS_C_TUSER   => (c_has_s_axis_ctrl_tuser = 1),  
          C_C_TUSER_WIDTH => c_s_axis_ctrl_tuser_width,      
          C_HAS_C_TLAST   => (c_has_s_axis_ctrl_tlast = 1),  
          C_HAS_Z_TREADY  => true                            
          )
        port map(
          aclk   => aclk,               
          aclken => ce_if,              
          sclr   => sclr_i,             

          -- AXI slave interface A
          s_axis_a_tready => s_axis_a_tready,  
          s_axis_a_tvalid => s_axis_a_tvalid,  
          s_axis_a_tdata  => s_axis_a_tdata,   
          s_axis_a_tuser  => s_axis_a_tuser,   
          s_axis_a_tlast  => s_axis_a_tlast,   

          -- AXI slave interface B
          s_axis_b_tready => s_axis_b_tready,  
          s_axis_b_tvalid => s_axis_b_tvalid,  
          s_axis_b_tdata  => s_axis_b_tdata,   
          s_axis_b_tuser  => s_axis_b_tuser,   
          s_axis_b_tlast  => s_axis_b_tlast,    

          -- AXI slave interface C
          s_axis_c_tready => s_axis_ctrl_tready,  
          s_axis_c_tvalid => s_axis_ctrl_tvalid,  
          s_axis_c_tdata  => s_axis_ctrl_tdata,   
          s_axis_c_tuser  => s_axis_ctrl_tuser,   
          s_axis_c_tlast  => s_axis_ctrl_tlast,    

          -- Read interface to core
          m_axis_z_tready  => ok_to_pull_data,         
          m_axis_z_tvalid  => combiner_data_out_valid, 
          m_axis_z_tdata_a => m_axis_z_tdata_a,        
          m_axis_z_tuser_a => m_axis_z_tuser_a,        
          m_axis_z_tlast_a => m_axis_z_tlast_a,        
          m_axis_z_tdata_b => m_axis_z_tdata_b,        
          m_axis_z_tuser_b => m_axis_z_tuser_b,        
          m_axis_z_tlast_b => m_axis_z_tlast_b,        
          m_axis_z_tdata_c => m_axis_z_tdata_ctrl,     
          m_axis_z_tuser_c => m_axis_z_tuser_ctrl,     
          m_axis_z_tlast_c => m_axis_z_tlast_ctrl      
          );
      
    end generate i_has_3to1;
    

    --Create valid_access_in signal. This means a valid transfer is occurring,
    valid_access_in <= combiner_data_out_valid and
                       outfifo_has_room and
                       ce_if;

    ok_to_pull_data <= outfifo_has_room and ce_if;


    --output fifo

    i_output_fifo : glb_ifx_master_v1_0
      generic map(
        width         => ci_chan_dout_width,
        depth         => ci_outfifo_depth,
        afull_thresh1 => 1,
        afull_thresh0 => 1
        )
      port map(
        aclk      => aclk,
        aclken    => ce_if,
        areset    => sclr_i,
        wr_enable => rdy_if,
        wr_data   => chan_dout_fifo_in,
        ifx_valid => m_axis_dout_tvalid,
        ifx_ready => m_axis_dout_tready,
        ifx_data  => chan_dout_fifo_out,
        not_afull => outfifo_has_room
        );

  end generate i_with_throttle;

  -----------------------------------------------------------------------------
  -- Non-blocking.
  -- This is the world without TREADYs anywhere. Pressure is entirely forwards.
  -- A TVALID on any input will force an operation. 
  -----------------------------------------------------------------------------
  i_without_throttle : if C_THROTTLE_SCHEME = ci_no_throttle or C_THROTTLE_SCHEME = ci_and_tvalid_throttle generate
    signal a_ce    : std_logic := '0';
    signal b_ce    : std_logic := '0';
    signal ctrl_ce : std_logic := '0';
    signal pre_valid : std_logic := '0';
    signal pre_valid_d : std_logic := '0';
  begin
    -- in v5.0 the GUI will never select this scheme. The code is kept in place
    -- as a contingency in case a customer demands this behaviour (it's easy to
    -- patch the tcl)
    -- coverage off
    --this is old code left in place in case AND TVALID proves to be unpopular.
-- i_or_tvalid : if C_THROTTLE_SCHEME = ci_no_throttle generate
      -------------------------------------------------------------------------
      -- For channels which dont have new valid data, the last valid data received will be used.
      -------------------------------------------------------------------------
      -- with no throttle, no fifos. With no fifos, just store last value (non blocking).
--      a_ce <= s_axis_a_tvalid and core_ce;
--      i_a_reg : xbip_pipe_v2_0_xst
--        generic map(
--          C_LATENCY  => 1,
--          C_HAS_CE   => 1,
--          C_HAS_SCLR => 1,
--          C_WIDTH    => ci_chan_a_width
--          )
--        port map(
--          CLK  => ACLK,
--          CE   => a_ce,
--          SCLR => sclr_i,
--          D    => chan_a_skid_in,
--          Q    => chan_a_skid_out_pre
--          );
--
--      b_ce <= s_axis_b_tvalid and core_ce;
--      i_b_reg : xbip_pipe_v2_0_xst
--        generic map(
--          C_LATENCY  => 1,
--          C_HAS_CE   => 1,
--          C_HAS_SCLR => 1,
--          C_WIDTH    => ci_chan_b_width
--          )
--        port map(
--          CLK  => ACLK,
--          CE   => b_ce,
--          SCLR => sclr_i,
--          D    => chan_b_skid_in,
--          Q    => chan_b_skid_out_pre
--          );
--
--      i_has_ctrl : if ci_has_ctrl_channel generate
--        ctrl_ce <= s_axis_ctrl_tvalid and core_ce;
--        i_ctrl_reg : xbip_pipe_v2_0_xst
--          generic map(
--            C_LATENCY  => 1,
--            C_HAS_CE   => 1,
--            C_HAS_SCLR => 1,
--            C_WIDTH    => ci_chan_ctrl_width
--            )
--          port map(
--            CLK  => ACLK,
--            CE   => ctrl_ce,
--            SCLR => sclr_i,
--            D    => chan_ctrl_skid_in,
--            Q    => chan_ctrl_skid_out_pre
--            );
--        pre_valid <= (s_axis_a_tvalid or s_axis_b_tvalid or s_axis_ctrl_tvalid);
--        i_non_block_zero_latency : if ci_axi_latency.wrap_lat = 0 generate
--          chan_ctrl_skid_out <= chan_ctrl_skid_out_pre when ctrl_ce = '0' else chan_ctrl_skid_in;
--        end generate i_non_block_zero_latency;
--        i_non_block_non_zero_latency : if ci_axi_latency.wrap_lat /= 0 generate
--          chan_ctrl_skid_out <= chan_ctrl_skid_out_pre;
--        end generate i_non_block_non_zero_latency;
--      end generate i_has_ctrl;
--      i_no_ctrl : if not(ci_has_ctrl_channel) generate
--        pre_valid <= (s_axis_a_tvalid or s_axis_b_tvalid);
--      end generate i_no_ctrl;
--
      --For zero latency, the register which allows access to the last valid data
      --lies in parallel to the combinatorial datapath. Its output feeds into a
      --mux which selects between input data (when TVALID is true) or the
      --register (when TVALID is false).
      --For non-zero latency, the register is in the datapath, because that
      --removes the mux which could otherwise be a combinatorial input to the
      --core and hence prevent full performance.
--      i_non_block_zero_latency : if ci_axi_latency.wrap_lat = 0 generate
--        chan_a_skid_out <= chan_a_skid_out_pre when a_ce = '0' else chan_a_skid_in;
--        chan_b_skid_out <= chan_b_skid_out_pre when b_ce = '0' else chan_b_skid_in;
--      end generate i_non_block_zero_latency;
--      i_non_block_non_zero_latency : if ci_axi_latency.wrap_lat /= 0 generate
--        chan_a_skid_out <= chan_a_skid_out_pre;
--        chan_b_skid_out <= chan_b_skid_out_pre;
--      end generate i_non_block_non_zero_latency;
--
--      i_valid_reg : xbip_pipe_v2_0_xst
--        generic map(
--          C_LATENCY  => ci_axi_latency.wrap_lat,  --boolean'POS(c_latency > 0),  --0 for 0 latency, 1 otherwise.
--          C_HAS_CE   => 1,
--          C_HAS_SCLR => 1,
--          C_WIDTH    => 1
--          )
--        port map(
--          CLK  => ACLK,
--          CE   => core_ce,
--          SCLR => sclr_i,
--          D(0) => pre_valid,
--          Q(0) => pre_valid_d           --valid_access_in
--          );
--      valid_access_in <= pre_valid_d and core_ce;
--
--    end generate i_or_tvalid;
    -- coverage on

    ---------------------------------------------------------------------------
    -- The new nonblocking scheme of v5.0. The intent of this scheme is to
    -- provide a zero resource migration from v3.1. The spirit of AXI has been
    -- compromised to achieve this. See the AXI proposal in the spec directory
    -- for a detailed description.
    ---------------------------------------------------------------------------
    i_and_tvalid: if C_THROTTLE_SCHEME = ci_and_tvalid_throttle generate
      m_axis_z_tdata_a <= s_axis_a_tdata;
      m_axis_z_tuser_a <= s_axis_a_tuser;
      m_axis_z_tlast_a <= s_axis_a_tlast;
      m_axis_z_tdata_b <= s_axis_b_tdata;
      m_axis_z_tuser_b <= s_axis_b_tuser;
      m_axis_z_tlast_b <= s_axis_b_tlast;
      m_axis_z_tdata_ctrl <= s_axis_ctrl_tdata;
      m_axis_z_tuser_ctrl <= s_axis_ctrl_tuser;
      m_axis_z_tlast_ctrl <= s_axis_ctrl_tlast;
      i_no_ctrl_chan: if not(ci_has_ctrl_channel) generate
        valid_access_in <= s_axis_a_tvalid and s_axis_b_tvalid and core_ce;
      end generate i_no_ctrl_chan;
      i_ctrl_chan: if ci_has_ctrl_channel generate
        valid_access_in <= s_axis_a_tvalid and s_axis_b_tvalid and s_axis_ctrl_tvalid and core_ce;
      end generate i_ctrl_chan;
    end generate i_and_tvalid;
    
    --Since this mode is non-blocking, there is no combiner (which zip-fastens the
    --channels together)

    --...nor is there an output FIFO.
    chan_dout_fifo_out <= chan_dout_fifo_in;
                          
    i_has_aclken : if C_HAS_ACLKEN = 1 generate
      core_ce <= ACLKEN;
      ce_if   <= ACLKEN;
    end generate i_has_aclken;

    m_axis_dout_tvalid <= valid_access_in_delayed;
  end generate i_without_throttle;

  ar <= m_axis_z_tdata_a(C_A_WIDTH-1 downto 0);
  ai <= m_axis_z_tdata_a(C_A_WIDTH+ c_s_axis_a_tdata_width/2 -1 downto c_s_axis_a_tdata_width/2);
  br <= m_axis_z_tdata_b(C_B_WIDTH-1 downto 0);
  bi <= m_axis_z_tdata_b(C_B_WIDTH+ c_s_axis_b_tdata_width/2 -1 downto c_s_axis_b_tdata_width/2);
  i_connect_round: if ci_has_ctrl_channel generate
    sround <= m_axis_z_tdata_ctrl(0);    
  end generate i_connect_round;

  
  i_tlast_out: if (C_HAS_S_AXIS_A_TLAST /= 0) or (C_HAS_S_AXIS_B_TLAST /= 0) or (C_HAS_S_AXIS_CTRL_TLAST /= 0) generate
    i_tuser_out : if (C_HAS_S_AXIS_A_TUSER = 1)  or (C_HAS_S_AXIS_B_TUSER = 1)  or (C_HAS_S_AXIS_CTRL_TUSER = 1) generate
      m_axis_dout_tuser <= chan_dout_fifo_out(chan_dout_fifo_out'LEFT downto C_OUT_WIDTH*2+1);
    end generate i_tuser_out;
    m_axis_dout_tlast <= chan_dout_fifo_out(C_OUT_WIDTH*2);  -- i.e. the bit above the complex data output.
  end generate i_tlast_out;
  i_no_tlast_out: if (C_HAS_S_AXIS_A_TLAST = 0) and (C_HAS_S_AXIS_B_TLAST = 0) and (C_HAS_S_AXIS_CTRL_TLAST = 0) and
                    ((C_HAS_S_AXIS_A_TUSER = 1)  or (C_HAS_S_AXIS_B_TUSER = 1)  or (C_HAS_S_AXIS_CTRL_TUSER = 1) ) generate
    m_axis_dout_tuser <= chan_dout_fifo_out(chan_dout_fifo_out'LEFT downto C_OUT_WIDTH*2);
  end generate i_no_tlast_out;
  m_axis_dout_tdata <= std_logic_vector(resize(signed(chan_dout_fifo_out(2*C_OUT_WIDTH-1 downto C_OUT_WIDTH )),C_M_AXIS_DOUT_TDATA_WIDTH/2)) &
                       std_logic_vector(resize(signed(chan_dout_fifo_out(  C_OUT_WIDTH-1 downto 0           )),C_M_AXIS_DOUT_TDATA_WIDTH/2));

  -----------------------------------------------------------------------------
  -- Run-time asserts
  -- If you are reading the hdl file, bear in mind that this file is copied
  -- to become the behavioural model.
  -----------------------------------------------------------------------------
  -- coverage off
  i_runtime_asserts: if simulating = 1 generate
    signal reset_history : std_logic_vector(2 downto 0) := (others => '0');  --3 cycles worth so can
    --check for single cycle pulses.
  begin
    i_reset: process(aclk)
    begin
      if rising_edge(aclk) then
        reset_history <= reset_history(1 downto 0) & ARESETN;
        assert not(reset_history = "010" or reset_history = "101" )
          report "Warning: ARESETN must be asserted or deasserted for a minimum of 2 cycles."
          severity warning;
      end if;
    end process;
  end generate i_runtime_asserts;
  -- coverage on
  
  -----------------------------------------------------------------------------
  -- The original (pre-AXI) core.
  -----------------------------------------------------------------------------
  i_behv : cmpy_v5_0_behv
    generic map(
      C_VERBOSITY         => C_VERBOSITY,
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_XDEVICE           => C_XDEVICE,
      C_A_WIDTH           => C_A_WIDTH,
      C_B_WIDTH           => C_B_WIDTH,
      C_OUT_HIGH          => C_A_WIDTH+C_B_WIDTH,
      C_OUT_LOW           => C_A_WIDTH+C_B_WIDTH - C_OUT_WIDTH+1,
      C_LATENCY           => ci_cmpy_latency,      
      C_MULT_TYPE         => C_MULT_TYPE,
      C_OPTIMIZE_GOAL     => C_OPTIMIZE_GOAL,
      C_HAS_CE            => ci_core_has_ce,  --may be ACLKEN, may be CE throttling.
      C_HAS_SCLR          => ci_core_has_aresetn,
      C_CE_OVERRIDES_SCLR => 0,
      HAS_NEGATE          => HAS_NEGATE,
      SINGLE_OUTPUT       => SINGLE_OUTPUT,
      ROUND               => ROUND,
      USE_DSP_CASCADES    => USE_DSP_CASCADES
      )
    port map(
      CLK      => ACLK,
      CE       => core_ce,
      SCLR     => sclr_i,
      AR       => ar,
      AI       => ai,
      BR       => br,
      BI       => bi,
      ROUND_CY => sround,
      PR       => pr,
      PI       => pi
      );
end architecture behavioral;
