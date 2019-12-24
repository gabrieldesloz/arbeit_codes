-- $RCSfile: c_counter_binary_v11_0_xst_comp.vhd,v $ $Revision: 1.5 $ $Date: 2010/03/19 10:46:30 $
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

package c_counter_binary_v11_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component c_counter_binary_v11_0_xst
  component c_counter_binary_v11_0_xst
    GENERIC (
      C_IMPLEMENTATION      : integer := 0;
      C_VERBOSITY           : integer := 0;
      C_XDEVICEFAMILY       : string  := "nofamily";  -- must be set
      C_WIDTH               : integer := 16;
      C_HAS_CE              : integer := 0;
      C_HAS_SCLR            : integer := 0;
      C_RESTRICT_COUNT      : integer := 0;
      C_COUNT_TO            : string  := "1";
      C_COUNT_BY            : string  := "1";
      C_COUNT_MODE          : integer := 0;           -- 0=up, 1=down, 2=updown
      C_THRESH0_VALUE       : string  := "1";
      C_CE_OVERRIDES_SYNC   : integer := 0;           -- 0=override;
      C_HAS_THRESH0         : integer := 0;
      C_HAS_LOAD            : integer := 0;
      C_LOAD_LOW            : integer := 0;
      C_LATENCY             : integer := 1;
      C_FB_LATENCY          : integer := 0;
      C_AINIT_VAL           : string  := "0";
      C_SINIT_VAL           : string  := "0";
      C_SCLR_OVERRIDES_SSET : integer := 1;           -- 0=set, 1=clear;
      C_HAS_SSET            : integer := 0;
      C_HAS_SINIT           : integer := 0
      );
    PORT (
      CLK     : in  std_logic                            := '0';              -- optional clock
      CE      : in  std_logic                            := '1';              -- optional clock enable
      SCLR    : in  std_logic                            := '0';              -- synch init.
      SSET    : in  std_logic                            := '0';              -- optional synch set to '1'
      SINIT   : in  std_logic                            := '0';              -- optional synch reset to init_val
      UP      : in  std_logic                            := '1';              -- controls direction of count - '1' = up.
      LOAD    : in  std_logic                            := '0';              -- optional synch load trigger
      L       : in  std_logic_vector(C_WIDTH-1 downto 0) := (others => '0');  -- optional synch load value
      THRESH0 : out std_logic                            := '1';
      Q       : out std_logic_vector(C_WIDTH-1 downto 0)                      -- output value
      );
  --core_if off
  END COMPONENT;


end c_counter_binary_v11_0_xst_comp;

