-- $Header: /devl/xcs/repo/env/Databases/ip/src2/L/xbip_bram18k_v2_0/simulation/xbip_bram18k_v2_0_xst_comp.vhd,v 1.3 2009/09/08 16:38:07 akennedy Exp $
--
--  (c) Copyright 1995-2008 Xilinx, Inc. All rights reserved.
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
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY XilinxCoreLib;
--USE XilinxCoreLib.bip_utils_pkg_v2_0.ALL;
USE Xilinxcorelib.bip_bram18k_v2_0_pkg.ALL;
USE Xilinxcorelib.xbip_bram18k_v2_0_comp.ALL;

package xbip_bram18k_v2_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component xbip_bram18k_v2_0_xst
  component xbip_bram18k_v2_0_xst
    GENERIC (
      C_XDEVICEFAMILY : string             := "virtex4";
      C_VERBOSITY     : integer            := 0;          -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_OPTIMIZE_GOAL : integer            := 0;          -- 0 = area,  1 = speed.
      C_MODEL_TYPE    : integer            := 0;          -- 0 = synth, 1 = RTL
      C_LATENCY       : integer            := 1;
      C_ADDR_WIDTH    : integer            := 10;
      C_DATA_WIDTH    : integer            := 18;
      C_INIT_VAL      : t_BRAM18k_init_val := (others => (others => '0'))
      );
    PORT (
      CLK      : in  std_logic                                 := '1';
      CE       : in  std_logic                                 := '1';
      SCLR     : in  std_logic                                 := '0';
      WE1      : in  std_logic                                 := '0';
      WE2      : in  std_logic                                 := '0';
      ADDR1    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      ADDR2    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
      DATAIN1  : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAIN2  : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAOUT1 : out std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
      DATAOUT2 : out std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0')
      );
  --core_if off
  END COMPONENT;


end xbip_bram18k_v2_0_xst_comp;

