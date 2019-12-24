-- $Id: bip_dsp48_multadd_pkg_v2_0.vhd,v 1.3 2009/09/08 16:46:33 akennedy Exp $
-------------------------------------------------------------------------------
--  (c) Copyright 2008 Xilinx, Inc. All rights reserved.
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

-- ### WARNING!!!  DO NOT EDIT THIS FILE BY HAND!  USE cp_to_sim.sh IN hdl/ INSTEAD! ###

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

library xilinxcorelib;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.bip_utils_pkg_v2_0.all;


-------------------------------------------------------------------------------
-- Designer note!!
-- This file is for the top level component declaration and any types and functions
-- which calling cores may require. Internal functions, types and component declarations
-- should be in the dsp48_multadd_hdl_pkg file.
-------------------------------------------------------------------------------

package bip_dsp48_multadd_pkg_v2_0 is

  -- purpose: sets DSP48 A MULT port in according to family
  function fn_a_width (
    p_xdevicefamily : string)
    return integer;
  
  function fn_dsp48_multadd_check_generics (
    P_VERBOSITY     : integer := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
    P_MODEL_TYPE    : integer := 0;          -- 0 = synth, 1 = RTL
    P_XDEVICEFAMILY : string  := "virtex4";
    P_LATENCY       : integer := 1;
    P_USE_PCIN      : integer := 0;
    P_USE_ACIN      : integer := 0;
    P_USE_BCIN      : integer := 0
    ) return integer;

  --core_if on component bip_dsp48_multadd_synth
  component bip_dsp48_multadd_synth
    generic (
      C_VERBOSITY       : integer := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_MODEL_TYPE      : integer := 0;          -- 0 = synth, 1 = RTL
      C_XDEVICEFAMILY   : string  := "virtex4";
      C_LATENCY         : integer := -1;
      C_USE_PCIN        : integer := 0;
      C_USE_ACIN        : integer := 0;
      C_USE_BCIN        : integer := 0
      );
    port (
      CLK          : in  std_logic                                                      := '1';
      CE           : in  std_logic                                                      := '1';
      SCLR         : in  std_logic                                                      := '0';
      SUBTRACT     : in  std_logic                                                      := '0';
      CARRYIN      : in  std_logic                                                      := '0';
      PCIN         : in  std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0');
      ACIN         : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      BCIN         : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      A            : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      B            : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      C            : in  std_logic_vector(ci_dsp48_c_width-1 downto 0)                  := (others => '0');
      ACOUT        : out std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      BCOUT        : out std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      CARRYOUT     : out std_logic                                                      := '0';
      PCOUT        : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0');
      P            : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0')
      );
  end component;
  --core_if off

  --core_if on component bip_dsp48_multadd_rtl
  component bip_dsp48_multadd_rtl
    generic (
      C_VERBOSITY       : integer := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_MODEL_TYPE      : integer := 0;          -- 0 = synth, 1 = RTL
      C_XDEVICEFAMILY   : string  := "virtex4";
      C_LATENCY         : integer := -1;
      C_USE_PCIN        : integer := 0;
      C_USE_ACIN        : integer := 0;
      C_USE_BCIN        : integer := 0
      );
    port (
      CLK          : in  std_logic                                                      := '1';
      CE           : in  std_logic                                                      := '1';
      SCLR         : in  std_logic                                                      := '0';
      SUBTRACT     : in  std_logic                                                      := '0';
      CARRYIN      : in  std_logic                                                      := '0';
      PCIN         : in  std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0');
      ACIN         : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      BCIN         : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      A            : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      B            : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      C            : in  std_logic_vector(ci_dsp48_c_width-1 downto 0)                  := (others => '0');
      ACOUT        : out std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      BCOUT        : out std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      CARRYOUT     : out std_logic                                                      := '0';
      PCOUT        : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0');
      P            : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0')
      );
  end component;
  --core_if off

  constant ci_max_latency       : integer := 4;
  type t_dsp48_multadd_pipe is array (0 to ci_max_latency) of integer;
  type t_dsp48_multadd_latency is record
                                 used : integer;
                                 pipe : t_dsp48_multadd_pipe;
                               end record;

  constant ci_stage1 : integer := 1;
  constant ci_stage2 : integer := 2;
  constant ci_stage3 : integer := 3;
  constant ci_stage4 : integer := 4;
  
  function fn_dsp48_multadd_latency (
    P_LATENCY       : integer;
    P_XDEVICEFAMILY : string)
    return t_dsp48_multadd_latency;

end package bip_dsp48_multadd_pkg_v2_0;

package body bip_dsp48_multadd_pkg_v2_0 is

  -- purpose: sets DSP48 A MULT port in according to family
  function fn_a_width (
    p_xdevicefamily : string)
    return integer is
  begin  -- fn_a_width
    if has_dsp48(p_xdevicefamily) or supports_dsp48a(p_xdevicefamily)>0 then
      return 18;
    elsif supports_dsp48e(p_xdevicefamily)>0 then
      return 25;
    else
      assert false
        report "ERROR: unsupported family in xbip_dsp48_multadd"
        severity error;
    end if;
    return 18;
  end fn_a_width;
  
  function fn_dsp48_multadd_check_generics (
    P_VERBOSITY     : integer := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
    P_MODEL_TYPE    : integer := 0;          -- 0 = synth, 1 = RTL
    P_XDEVICEFAMILY : string  := "virtex4";
    P_LATENCY       : integer := 1;
    P_USE_PCIN      : integer := 0;
    P_USE_ACIN      : integer := 0;
    P_USE_BCIN      : integer := 0
    ) return integer is
  begin
    assert P_USE_PCIN = 0 or P_USE_PCIN = 1
      report "ERROR: xbip_dsp48_multadd: C_USE_PCIN out of range"
      severity error;
    assert P_USE_ACIN = 0 or P_USE_ACIN = 1
      report "ERROR: xbip_dsp48_multadd: C_USE_ACIN out of range"
      severity error;
    assert P_USE_ACIN = 0 or supports_dsp48e(P_XDEVICEFAMILY)>0
      report "ERROR: xbip_dsp48_multadd: ACIN can only be used for Virtex 5"
      severity error;
    assert P_USE_BCIN = 0 or P_USE_BCIN = 1
      report "ERROR: xbip_dsp48_multadd: C_USE_BCIN out of range"
      severity error;
    assert (P_LATENCY >= -1 and P_LATENCY <= 4) or (P_LATENCY >= 16 and P_LATENCY <= 31)
      report "ERROR: xbip_dsp48_multadd: C_LATENCY out of range"
      severity ERROR;

    --warnings...
    if P_VERBOSITY > 0 then
      assert false
        report "WARNING: CARRYOUT is not driven in this usecase."
        severity warning;
      assert supports_DSP48E(p_xdevicefamily)>0
        report "WARNING: ACOUT is not driven for Vx4 or Sp3adsp"
        severity warning;
    end if;
    return 0;
  end function fn_dsp48_multadd_check_generics;

  function fn_dsp48_multadd_latency (
    P_LATENCY       : integer;
    P_XDEVICEFAMILY : string)
    return t_dsp48_multadd_latency is
    variable ret_val : t_dsp48_multadd_latency;
    variable v_latency_left : integer;
    variable v_slv_latency : std_logic_vector(5 downto 1) := (others => '0');
  begin
    --initialise all latency stages to 0.
    for i  in 0 to ci_max_latency loop
      ret_val.pipe(i) := 0;
    end loop;  -- i
    ret_val.used := 0;

    if p_latency >= 2**ci_max_latency and p_latency < 2**(ci_max_latency+1) then
      --hand-placed latency 'allocation'
      
      v_slv_latency(ci_max_latency+1 downto 1) := conv_std_logic_vector(p_latency,ci_max_latency+1);

      for i in 1 to ci_max_latency loop
        if v_slv_latency(i) = '1' then
          ret_val.pipe(i) := 1;
          ret_val.used := ret_val.used + 1;
        end if;
      end loop;  -- i
    else
      --conventional latency allocation.
      --deal out latency according to generics and architecture for optimal speed
      --and resource
      
      v_latency_left := p_latency;

      if v_latency_left /= 0 then
        v_latency_left          := v_latency_left-1;
        ret_val.pipe(ci_stage4) := ret_val.pipe(ci_stage4) +1;
        ret_val.used            := ret_val.used +1;
      end if;

      if v_latency_left /= 0 then
        v_latency_left          := v_latency_left-1;
        ret_val.pipe(ci_stage3) := ret_val.pipe(ci_stage3) +1;
        ret_val.used            := ret_val.used +1;
      end if;

      if v_latency_left /= 0 then
        v_latency_left          := v_latency_left-1;
        ret_val.pipe(ci_stage2) := ret_val.pipe(ci_stage2) +1;
        ret_val.used            := ret_val.used +1;
      end if;

      --Note latency = -1 will not use the first A:B regs.
      if v_latency_left > 0 then
        v_latency_left          := v_latency_left-1;
        ret_val.pipe(ci_stage1) := ret_val.pipe(ci_stage1) +1;
        ret_val.used            := ret_val.used +1;
      end if;
      
      --there should not be any latency left. If there is, flag error
      if v_latency_left > 0 then
        assert false
          report "ERROR: excess latency in xbip_dsp48_multadd."
          severity error;
      end if;

    end if;
    return ret_val;
    
  end function fn_dsp48_multadd_latency;

end package body bip_dsp48_multadd_pkg_v2_0;
