-- $RCSfile: c_mux_bus_v11_0_comp.vhd,v $ $Revision: 1.5 $ $Date: 2010/01/06 08:56:01 $
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

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE c_mux_bus_v11_0_comp IS

----- Component c_mux_bus_v11_0 -----
-- Short Description
--
-- (A)Synchronous N*M-to-M Mux
--
  COMPONENT c_mux_bus_v11_0
    GENERIC(
      c_family        : string  := "virtex6";
      c_xdevicefamily : string  := "virtex6";
      c_width         : INTEGER := 16;
      c_inputs        : INTEGER := 2;
      c_mux_type      : INTEGER := 0;
      c_sel_width     : INTEGER := 1;
      c_ainit_val     : STRING  := "0000000000000000";
      c_sinit_val     : STRING  := "0000000000000000";
      c_sync_priority : INTEGER := 1;
      c_sync_enable   : INTEGER := 0;
      c_latency       : INTEGER := 1;
      c_height        : INTEGER := 0;
      c_has_o         : INTEGER := 0;
      c_has_q         : INTEGER := 1;
      c_has_ce        : INTEGER := 0;
      c_has_en        : INTEGER := 0;
      c_has_aclr      : INTEGER := 0;
      c_has_aset      : INTEGER := 0;
      c_has_ainit     : INTEGER := 0;
      c_has_sclr      : INTEGER := 0;
      c_has_sset      : INTEGER := 0;
      c_has_sinit     : INTEGER := 0;
      c_enable_rlocs  : INTEGER := 0
      ); 

    PORT (
      ma    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mb    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mc    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      md    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      me    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mf    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mg    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mh    : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      maa   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mab   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mac   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mad   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mae   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      maf   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mag   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mah   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mba   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbb   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbc   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbd   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbe   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbf   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbg   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mbh   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mca   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mcb   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mcc   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mcd   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mce   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mcf   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mcg   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      mch   : IN  STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)     := (OTHERS => '0');  -- input vector
      s     : IN  STD_LOGIC_VECTOR(c_sel_width-1 DOWNTO 0) := (OTHERS => '0');  -- select pin
      clk   : IN  STD_LOGIC                                := '0';  -- optional clock
      ce    : IN  STD_LOGIC                                := '1';  -- optional clock enable
      en    : IN  STD_LOGIC                                := '0';  -- optional buft enable
      aset  : IN  STD_LOGIC                                := '0';  -- optional asynch set to '1'
      aclr  : IN  STD_LOGIC                                := '0';  -- asynch init.
      ainit : IN  STD_LOGIC                                := '0';  -- optional asynch reset to init_val
      sset  : IN  STD_LOGIC                                := '0';  -- optional synch set to '1'
      sclr  : IN  STD_LOGIC                                := '0';  -- synch init.
      sinit : IN  STD_LOGIC                                := '0';  -- optional synch reset to init_val
      o     : OUT STD_LOGIC_VECTOR(c_width-1 DOWNTO 0);  -- output value
      q     : OUT STD_LOGIC_VECTOR(c_width-1 DOWNTO 0)  -- registered output value
      );
  END COMPONENT;
  -- The following tells XST that c_mux_bus_v11_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  ATTRIBUTE box_type : STRING;
  ATTRIBUTE generator_default : STRING;
  ATTRIBUTE box_type OF c_mux_bus_v11_0 : COMPONENT IS "black_box";
  ATTRIBUTE generator_default OF c_mux_bus_v11_0 : COMPONENT IS
    "generatecore com.xilinx.ip.c_mux_bus_v11_0.c_mux_bus_v11_0";
  -- xcc include

END c_mux_bus_v11_0_comp;
