-- $RCSfile: xbip_multadd_v2_0_xst.vhd,v $ $Date: 2009/12/04 11:46:44 $ $Revision: 1.4 $
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

library IEEE;
use IEEE.std_logic_1164.all;

library XilinxCoreLib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use Xilinxcorelib.xbip_multadd_v2_0_comp.all;

--core_if on entity xbip_multadd_v2_0_xst
  entity xbip_multadd_v2_0_xst is
  generic (
    C_VERBOSITY         : integer := 0;
    C_XDEVICEFAMILY     : string  := "";
    C_A_WIDTH           : integer := 20;
    C_B_WIDTH           : integer := 20;
    C_C_WIDTH           : integer := 32;
    C_A_TYPE            : integer := 0; -- 0:signed, 1:unsigned
    C_B_TYPE            : integer := 0; -- 0:signed, 1:unsigned
    C_C_TYPE            : integer := 0; -- 0:signed, 1:unsigned
    C_CE_OVERRIDES_SCLR : integer := 0;
    C_AB_LATENCY        : integer := -1;
    C_C_LATENCY         : integer := -1;
    C_OUT_HIGH          : integer := 32;
    C_OUT_LOW           : integer := 0;
    C_USE_PCIN          : integer := 0;
    C_TEST_CORE         : integer := 0
    );
  port (
    CLK      : in  std_logic                                     := '0';
    CE       : in  std_logic                                     := '0';
    SCLR     : in  std_logic                                     := '0';
    A        : in  std_logic_vector(C_A_WIDTH-1 downto 0)        := (others => '0');
    B        : in  std_logic_vector(C_B_WIDTH-1 downto 0)        := (others => '0');
    C        : in  std_logic_vector(C_C_WIDTH-1 downto 0)        := (others => '0');
    PCIN     : in  std_logic_vector(ci_dsp48_c_width-1 downto 0) := (others => '0');
    SUBTRACT : in  std_logic                                     := '0';
    P        : out std_logic_vector(C_OUT_HIGH downto C_OUT_LOW) := (others => '0');
    PCOUT    : out  std_logic_vector(ci_dsp48_c_width-1 downto 0) := (others => '0')
    );
--core_if off
end xbip_multadd_v2_0_xst;


architecture behavioral of xbip_multadd_v2_0_xst is

begin
  --core_if on instance i_behv xbip_multadd_v2_0
  i_behv : xbip_multadd_v2_0
    generic map (
      C_VERBOSITY         => C_VERBOSITY,
      C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
      C_A_WIDTH           => C_A_WIDTH,
      C_B_WIDTH           => C_B_WIDTH,
      C_C_WIDTH           => C_C_WIDTH,
      C_A_TYPE            => C_A_TYPE,
      C_B_TYPE            => C_B_TYPE,
      C_C_TYPE            => C_C_TYPE,
      C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
      C_AB_LATENCY        => C_AB_LATENCY,
      C_C_LATENCY         => C_C_LATENCY,
      C_OUT_HIGH          => C_OUT_HIGH,
      C_OUT_LOW           => C_OUT_LOW,
      C_USE_PCIN          => C_USE_PCIN,
      C_TEST_CORE         => C_TEST_CORE
      )
    port map (
      CLK      => CLK,
      CE       => CE,
      SCLR     => SCLR,
      A        => A,
      B        => B,
      C        => C,
      PCIN     => PCIN,
      SUBTRACT => SUBTRACT,
      P        => P,
      PCOUT    => PCOUT
      );

  --core_if off
  
end behavioral;

