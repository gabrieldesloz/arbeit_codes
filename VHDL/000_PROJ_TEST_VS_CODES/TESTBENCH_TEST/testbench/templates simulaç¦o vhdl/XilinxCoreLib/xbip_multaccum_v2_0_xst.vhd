-- $RCSfile: xbip_multaccum_v2_0_xst.vhd,v $ $Date: 2009/12/04 11:46:45 $ $Revision: 1.4 $
--
--  (c) Copyright 2008-2009 Xilinx, Inc. All rights reserved.
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
-- Wrapper for behavioral model
-------------------------------------------------------------------------------
  
library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.xbip_multaccum_v2_0_comp.all;

--core_if on entity xbip_multaccum_v2_0_xst
  entity xbip_multaccum_v2_0_xst is
    generic (
      C_VERBOSITY          : integer := 0;
      C_XDEVICEFAMILY      : string := "NO_FAMILY";
      C_USE_DSP48          : integer := 1;  -- 1:DSP48, this is the only option in this version
      C_LATENCY            : integer := -1; -- -1: corresponds to automatic latency
      C_ACCUM_WIDTH        : integer := 45;
      C_A_WIDTH            : integer := 16;
      C_B_WIDTH            : integer := 16;
      C_A_TYPE             : integer := 0;  -- 0:signed, 1:unsigned
      C_B_TYPE             : integer := 0;  -- 0:signed, 1:unsigned
      C_OUT_WIDTH          : integer := 45;
      C_ROUND_TYPE         : integer := 0;  -- 0:truncation (all that is supported in v1)
      C_HAS_BYPASS         : integer := 0;  -- 0:no BYPASS,  1:BYPASS
      C_BYPASS_LOW         : integer := 0;  -- 0:active High,  1:active Low
      C_ACCUM_MODE         : integer := 0;  -- 0:add,  1:subtract, 2:add/sub
      C_CE_OVERRIDES_SCLR  : integer := 0   -- 0:SCLR overrides CE,  1:CE overrides SCLR
      );
    port (
      CLK      : in std_logic := '0';
      CE       : in std_logic := '1';
      SCLR     : in std_logic := '0';
      BYPASS   : in std_logic := '0';
      SUBTRACT : in std_logic := '0';       -- used with accum_mode=2, 0=>add, 1=>sub
      A        : in std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
      B        : in std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
      S        : out std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0')
      );
--core_if off
end xbip_multaccum_v2_0_xst;


architecture behavioral of xbip_multaccum_v2_0_xst is

begin
  --core_if on instance i_behv xbip_multaccum_v2_0
  i_behv : xbip_multaccum_v2_0
    generic map (
      C_VERBOSITY         => C_VERBOSITY,
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_USE_DSP48         => C_USE_DSP48,
      C_LATENCY           => C_LATENCY,
      C_ACCUM_WIDTH       => C_ACCUM_WIDTH,
      C_A_WIDTH           => C_A_WIDTH,
      C_B_WIDTH           => C_B_WIDTH,
      C_A_TYPE            => C_A_TYPE,
      C_B_TYPE            => C_B_TYPE,
      C_OUT_WIDTH         => C_OUT_WIDTH,
      C_ROUND_TYPE        => C_ROUND_TYPE,
      C_HAS_BYPASS        => C_HAS_BYPASS,
      C_BYPASS_LOW        => C_BYPASS_LOW,
      C_ACCUM_MODE        => C_ACCUM_MODE,
      C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR
      )
    port map (
      CLK      => CLK,
      CE       => CE,
      SCLR     => SCLR,
      BYPASS   => BYPASS,
      SUBTRACT => SUBTRACT,
      A        => A,
      B        => B,
      S        => S
      );

  --core_if off
  
end behavioral;

