-- $RCSfile $ $Date: 2009/12/04 11:46:24 $ $Revision: 1.4 $
--
-- (c) Copyright 2009 - 2009 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 

-------------------------------------------------------------------------------
-- Wrapper for behavioral model
-------------------------------------------------------------------------------
  
library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.cmpy_v3_0_comp.all;

--core_if on entity cmpy_v3_0_xst
  entity cmpy_v3_0_xst is
    generic (
      C_VERBOSITY         : integer := 0;
      C_XDEVICEFAMILY     : string  := "no_family";
      C_XDEVICE           : string  := "no_family";
      C_A_WIDTH           : integer := 16;
      C_B_WIDTH           : integer := 16;
      C_OUT_HIGH          : integer := 31;           -- MSB of product
      C_OUT_LOW           : integer := 0;            -- LSB of product
      C_LATENCY           : integer := -1;           -- Latency of CMPY (-1 = fully pipelined)
      C_MULT_TYPE         : integer := 1;            -- 0 = Use LUTs, 1 = Use MULT18X18x/DSP48x
      C_OPTIMIZE_GOAL     : integer := 0;            -- 0 = Minimise mult/DSP count, 1 = Performance
      C_HAS_CE            : integer := 0;            -- 0 = No clock enable, 1 = active-high clock enable
      C_HAS_SCLR          : integer := 0;            -- 0 = No sync. clear, 1 = active-high sync. clear
      C_CE_OVERRIDES_SCLR : integer := 0;            -- Self-explanatory
      HAS_NEGATE          : integer := 0;            -- 0=NEGATE_R/I disabled, 1=Apply negation to B inputs, 2=Apply negation to A inputs
      SINGLE_OUTPUT       : integer := 0;            -- Only generate real half of CMPY
      ROUND               : integer := 0;            -- Add rounding constant for better noise performance
      USE_DSP_CASCADES    : integer := 1             -- 0 = break cascades (S3A-DSP only), 1 = use cascades normally, 2 = chain all DSPs together
      );
    port (
      AR       : in  std_logic_vector(C_A_WIDTH-1 downto 0)          := (others => '0');
      AI       : in  std_logic_vector(C_A_WIDTH-1 downto 0)          := (others => '0');
      BR       : in  std_logic_vector(C_B_WIDTH-1 downto 0)          := (others => '0');
      BI       : in  std_logic_vector(C_B_WIDTH-1 downto 0)          := (others => '0');
      CLK      : in  std_logic                                       := '0';
      CE       : in  std_logic                                       := '1';
      SCLR     : in  std_logic                                       := '0';
      ROUND_CY : in  std_logic                                       := '0';
      NEGATE_R : in  std_logic                                       := '0';
      NEGATE_I : in  std_logic                                       := '0';
      SO_START : in  std_logic                                       := '0';
      PR       : out std_logic_vector(C_OUT_HIGH-C_OUT_LOW downto 0) := (others => '0');
      PI       : out std_logic_vector(C_OUT_HIGH-C_OUT_LOW downto 0) := (others => '0')
      );
--core_if off
end cmpy_v3_0_xst;


architecture behavioral of cmpy_v3_0_xst is

begin
  --core_if on instance i_behv cmpy_v3_0
  i_behv : cmpy_v3_0
    generic map (
      C_VERBOSITY         => C_VERBOSITY,
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_XDEVICE           => C_XDEVICE,
      C_A_WIDTH           => C_A_WIDTH,
      C_B_WIDTH           => C_B_WIDTH,
      C_OUT_HIGH          => C_OUT_HIGH,
      C_OUT_LOW           => C_OUT_LOW,
      C_LATENCY           => C_LATENCY,
      C_MULT_TYPE         => C_MULT_TYPE,
      C_OPTIMIZE_GOAL     => C_OPTIMIZE_GOAL,
      C_HAS_CE            => C_HAS_CE,
      C_HAS_SCLR          => C_HAS_SCLR,
      C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
      HAS_NEGATE          => HAS_NEGATE,
      SINGLE_OUTPUT       => SINGLE_OUTPUT,
      ROUND               => ROUND,
      USE_DSP_CASCADES    => USE_DSP_CASCADES
      )
    port map (
      AR       => AR,
      AI       => AI,
      BR       => BR,
      BI       => BI,
      CLK      => CLK,
      CE       => CE,
      SCLR     => SCLR,
      ROUND_CY => ROUND_CY,
      NEGATE_R => NEGATE_R,
      NEGATE_I => NEGATE_I,
      SO_START => SO_START,
      PR       => PR,
      PI       => PI
      );

  --core_if off
  
end behavioral;

