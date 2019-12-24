-- $RCSfile $ $Date: 2010/09/08 10:40:24 $ $Revision: 1.5 $
--
--  (c) Copyright 2009-2010 Xilinx, Inc. All rights reserved.
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
use xilinxcorelib.axi_utils_pkg_v1_0.all;
use xilinxcorelib.cmpy_v4_0_comp.all;

--core_if on entity cmpy_v4_0_xst
  entity cmpy_v4_0_xst is
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
    C_THROTTLE_SCHEME         : integer := 0;   -- 0=no throttle (half handshake), 1=CE throttle (full handshake, low performance), 2=RFD (full handshake, full performance)
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
end cmpy_v4_0_xst;


architecture behavioral of cmpy_v4_0_xst is

begin
  --core_if on instance i_behv cmpy_v4_0
  i_behv : cmpy_v4_0
    generic map (
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
      C_THROTTLE_SCHEME         => C_THROTTLE_SCHEME,
      C_HAS_ACLKEN              => C_HAS_ACLKEN,
      C_HAS_ARESETN             => C_HAS_ARESETN,
      C_HAS_S_AXIS_A_TUSER      => C_HAS_S_AXIS_A_TUSER,
      C_HAS_S_AXIS_A_TLAST      => C_HAS_S_AXIS_A_TLAST,
      C_HAS_S_AXIS_B_TUSER      => C_HAS_S_AXIS_B_TUSER,
      C_HAS_S_AXIS_B_TLAST      => C_HAS_S_AXIS_B_TLAST,
      C_HAS_S_AXIS_CTRL_TUSER   => C_HAS_S_AXIS_CTRL_TUSER,
      C_HAS_S_AXIS_CTRL_TLAST   => C_HAS_S_AXIS_CTRL_TLAST,
      C_TLAST_RESOLUTION        => C_TLAST_RESOLUTION,
      C_S_AXIS_A_TDATA_WIDTH    => C_S_AXIS_A_TDATA_WIDTH,
      C_S_AXIS_A_TUSER_WIDTH    => C_S_AXIS_A_TUSER_WIDTH,
      C_S_AXIS_B_TDATA_WIDTH    => C_S_AXIS_B_TDATA_WIDTH,
      C_S_AXIS_B_TUSER_WIDTH    => C_S_AXIS_B_TUSER_WIDTH,
      C_S_AXIS_CTRL_TDATA_WIDTH => C_S_AXIS_CTRL_TDATA_WIDTH,
      C_S_AXIS_CTRL_TUSER_WIDTH => C_S_AXIS_CTRL_TUSER_WIDTH,
      C_M_AXIS_DOUT_TDATA_WIDTH => C_M_AXIS_DOUT_TDATA_WIDTH,
      C_M_AXIS_DOUT_TUSER_WIDTH => C_M_AXIS_DOUT_TUSER_WIDTH
      )
    port map (
      aclk               => aclk,
      aclken             => aclken,
      aresetn            => aresetn,
      s_axis_a_tvalid    => s_axis_a_tvalid,
      s_axis_a_tready    => s_axis_a_tready,
      s_axis_a_tuser     => s_axis_a_tuser,
      s_axis_a_tlast     => s_axis_a_tlast,
      s_axis_a_tdata     => s_axis_a_tdata,
      s_axis_b_tvalid    => s_axis_b_tvalid,
      s_axis_b_tready    => s_axis_b_tready,
      s_axis_b_tuser     => s_axis_b_tuser,
      s_axis_b_tlast     => s_axis_b_tlast,
      s_axis_b_tdata     => s_axis_b_tdata,
      s_axis_ctrl_tvalid => s_axis_ctrl_tvalid,
      s_axis_ctrl_tready => s_axis_ctrl_tready,
      s_axis_ctrl_tuser  => s_axis_ctrl_tuser,
      s_axis_ctrl_tlast  => s_axis_ctrl_tlast,
      s_axis_ctrl_tdata  => s_axis_ctrl_tdata,
      m_axis_dout_tvalid => m_axis_dout_tvalid,
      m_axis_dout_tready => m_axis_dout_tready,
      m_axis_dout_tuser  => m_axis_dout_tuser,
      m_axis_dout_tlast  => m_axis_dout_tlast,
      m_axis_dout_tdata  => m_axis_dout_tdata
      );

  --core_if off
  
end behavioral;

