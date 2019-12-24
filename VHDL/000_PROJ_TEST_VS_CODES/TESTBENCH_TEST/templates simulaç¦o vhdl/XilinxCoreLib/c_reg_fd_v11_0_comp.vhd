-- $RCSfile: c_reg_fd_v11_0_comp.vhd,v $ $Revision: 1.3 $ $Date: 2009/09/08 15:24:14 $
--------------------------------------------------------------------------------

--  (c) Copyright 1995-2005 Xilinx, Inc. All rights reserved.
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

--
-- Filename - c_reg_fd_v11_0_comp.vhd
-- Author - Xilinx
-- Creation - 25 Feb 1999
--
-- Description - This file contains the component declaration for
--                               the c_reg_fd_v11_0 core

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE c_reg_fd_v11_0_comp IS

----- Component c_reg_fd_v11_0 -----
-- Short Description
--
-- Wide register
--

  COMPONENT c_reg_fd_v11_0
    GENERIC (
      c_width         : INTEGER := 16;
      c_ainit_val     : STRING  := "0";
      c_sinit_val     : STRING  := "0";
      c_sync_priority : INTEGER := 1;--c_clear;
      c_sync_enable   : INTEGER := 0;--c_override;
      c_has_ce        : INTEGER := 0;
      c_has_aclr      : INTEGER := 0;
      c_has_aset      : INTEGER := 0;
      c_has_ainit     : INTEGER := 0;
      c_has_sclr      : INTEGER := 0;
      c_has_sset      : INTEGER := 0;
      c_has_sinit     : INTEGER := 0;
      c_enable_rlocs  : INTEGER := 0
      ); 

    PORT (
      d     : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0) := (OTHERS => '0');  -- input value
      clk   : IN  STD_LOGIC                            := '0';  -- clock
      ce    : IN  STD_LOGIC                            := '1';  -- clock enable
      aclr  : IN  STD_LOGIC                            := '0';  -- asynch clear.
      aset  : IN  STD_LOGIC                            := '0';  -- asynch set.
      ainit : IN  STD_LOGIC                            := '0';  -- asynch init.
      sclr  : IN  STD_LOGIC                            := '0';  -- synch clear.
      sset  : IN  STD_LOGIC                            := '0';  -- synch set.
      sinit : IN  STD_LOGIC                            := '0';  -- synch init.
      q     : OUT STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)  -- output value
      );
  END COMPONENT;
  -- The following tells XST that c_reg_fd_v11_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  ATTRIBUTE box_type : STRING;
  ATTRIBUTE generator_default : STRING;
  ATTRIBUTE box_type OF c_reg_fd_v11_0 : COMPONENT IS "black_box";
  ATTRIBUTE generator_default OF c_reg_fd_v11_0 : COMPONENT IS
    "generatecore com.xilinx.ip.c_reg_fd_v11_0.c_reg_fd_v11_0";
  -- xcc include

END c_reg_fd_v11_0_comp;
