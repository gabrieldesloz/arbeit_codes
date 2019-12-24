-- $Id: axi_utils_pkg_v1_0.vhd,v 1.5 2011/01/25 14:58:44 ccleg Exp $
-------------------------------------------------------------------------------
--  (c) Copyright 2010 Xilinx, Inc. All rights reserved.
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

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

package axi_utils_pkg_v1_0 is

  --c_throttle_scheme values
  constant ci_no_throttle         : integer := 0;
  constant ci_ce_throttle         : integer := 1;
  constant ci_rfd_throttle        : integer := 2;
  constant ci_and_tvalid_throttle : integer := 3;
  constant ci_gen_throttle        : integer := 4;

  --c_aclken_scheme
  constant ci_aclken_ifandcore : integer := 0;
  constant ci_aclken_ifonly    : integer := 1;

  --c_tlast_resolution values
  constant ci_tlast_null    : integer := 0;
  constant ci_tlast_pass_a  : integer := 1;
  constant ci_tlast_pass_b  : integer := 2;
  constant ci_tlast_pass_c  : integer := 3;
  constant ci_tlast_pass_d  : integer := 4;
  constant ci_tlast_pass_e  : integer := 5;
  constant ci_tlast_pass_f  : integer := 6;
  constant ci_tlast_pass_g  : integer := 7;
  constant ci_tlast_pass_h  : integer := 8;
  constant ci_tlast_pass_i  : integer := 9;
  constant ci_tlast_pass_j  : integer := 10;
  constant ci_tlast_pass_k  : integer := 11;
  constant ci_tlast_pass_l  : integer := 12;
  constant ci_tlast_pass_m  : integer := 13;
  constant ci_tlast_pass_n  : integer := 14;
  constant ci_tlast_pass_o  : integer := 15;
  constant ci_tlast_or_all  : integer := 16;
  constant ci_tlast_and_all : integer := 17;

  function byte_roundup (width : integer) return integer;
  function four_byte_roundup (width : integer) return integer;

end axi_utils_pkg_v1_0;

package body axi_utils_pkg_v1_0 is
  function byte_roundup (
    width : integer
    ) return integer is
  begin
    return ((width+7)/8)*8;
  end;

  function four_byte_roundup (
    width : integer
    ) return integer is
  begin
    return ((width+31)/32)*32;
  end;


end axi_utils_pkg_v1_0;
