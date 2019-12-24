-- $Header: /devl/xcs/repo/env/Databases/ip/src2/L/convolution_v7_0/simulation/convolution_v7_0_xst_comp.vhd,v 1.3 2009/09/08 15:11:47 akennedy Exp $
--
--  (c) Copyright 1995-2005, 2009 Xilinx, Inc. All rights reserved.
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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


PACKAGE convolution_v7_0_xst_comp IS

   COMPONENT convolution_v7_0_xst
      GENERIC ( 
         c_output_rate        : INTEGER:=3; 
         c_constraint_length  : INTEGER:=3; 
         c_punctured          : INTEGER:=0;
         c_dual_channel       : INTEGER:=0;
         c_punc_input_rate    : INTEGER:=3;
         c_punc_output_rate   : INTEGER:=4;

         c_convolution_code0  : INTEGER:=5;
         c_convolution_code1  : INTEGER:=7;
         c_convolution_code2  : INTEGER:=5;
         c_convolution_code3  : INTEGER:=7;
         c_convolution_code4  : INTEGER:=5;
         c_convolution_code5  : INTEGER:=7;
         c_convolution_code6  : INTEGER:=5;

         c_punc_code0         : INTEGER:=0;
         c_punc_code1         : INTEGER:=0;

         c_has_nd             : INTEGER:=0;
         c_has_rfd            : INTEGER:=0;
         c_has_rdy            : INTEGER:=0;
         c_has_fd             : INTEGER:=0;
         c_has_rffd           : INTEGER:=0;

         c_has_ce             : INTEGER:=1;  
         c_has_sclr           : INTEGER:=0;
         c_family             : STRING  := "virtex5";
         c_xdevicefamily      : STRING  := "virtex5"

      );
      PORT (
         data_in        : IN STD_LOGIC := '0';
         data_out_v     : OUT STD_LOGIC_VECTOR(c_output_rate-1 DOWNTO 0);
         data_out_s     : OUT STD_LOGIC;
         fd_in          : IN STD_LOGIC := '0';
         nd             : IN STD_LOGIC := '0';
         rfd            : OUT STD_LOGIC;
         rffd           : OUT STD_LOGIC;
         rdy            : OUT STD_LOGIC;
         ce             : IN STD_LOGIC := '0'; 
         sclr           : IN STD_LOGIC := '0';
         clk            : IN STD_LOGIC
      );
   END COMPONENT;
END convolution_v7_0_xst_comp;
