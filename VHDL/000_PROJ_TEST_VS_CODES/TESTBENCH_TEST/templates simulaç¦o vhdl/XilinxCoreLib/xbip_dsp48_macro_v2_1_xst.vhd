-- $RCSfile: xbip_dsp48_macro_v2_1_xst.vhd,v $ $Date: 2011/05/26 11:57:25 $ $Revision: 1.5 $
--
--  (c) Copyright 2008, 2011 Xilinx, Inc. All rights reserved.
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

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.xbip_dsp48_macro_v2_1_comp.all;

--core_if on entity xbip_dsp48_macro_v2_1_xst
  entity xbip_dsp48_macro_v2_1_xst is
    generic (
      C_VERBOSITY        : integer := 0;  -- 0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_MODEL_TYPE       : integer := 0;  -- 0 = synth, 1 = RTL
      C_XDEVICEFAMILY    : string  := "virtex5"; -- Target device
      C_HAS_CE           : integer := 0; -- 0=No CEs, 1=Has any type of CE (global, ganged, per-register)
      C_HAS_INDEP_CE     : integer := 0; -- 0=Global CE, 1=Ganged CE for each input path, 2=Unique CE for every register
      C_HAS_CED          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(2 downto 0) enables individual CEs
      C_HAS_CEA          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(3 downto 0) enables individual CEs
      C_HAS_CEB          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(3 downto 0) enables individual CEs
      C_HAS_CEC          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(4 downto 0) enables individual CEs
      C_HAS_CECONCAT     : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(4 downto 2) enables individual CEs
      C_HAS_CEM          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(0 downto 0) enables individual CEs
      C_HAS_CEP          : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(0 downto 0) enables individual CEs
      C_HAS_CESEL        : integer := 0; -- If C_HAS_INDEP_CE=2, to_integer(4 downto 0) enables individual CEs
      C_HAS_SCLR         : integer := 0; -- 0=No SCLRs, 1=Has any type of SCLR (global, ganged)
      C_HAS_INDEP_SCLR   : integer := 0; -- 0=Global CE, 1=Ganged SCLR for each input path
      C_HAS_SCLRD        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables D SCLR pin
      C_HAS_SCLRA        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables A SCLR pin
      C_HAS_SCLRB        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables B SCLR pin
      C_HAS_SCLRC        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables C SCLR pin
      C_HAS_SCLRM        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables M SCLR pin
      C_HAS_SCLRP        : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables P SCLR pin
      C_HAS_SCLRCONCAT   : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables CONCAT SCLR pin
      C_HAS_SCLRSEL      : integer := 0; -- If C_HAS_INDEP_SCLR=1, 1 enables SEL SCLR pin
      C_HAS_CARRYCASCIN  : integer := 0; -- 0=No CARRYCASCIN input, 1=Has CARRYCASCIN input (must be reflected in instructions)
      C_HAS_CARRYIN      : integer := 0; -- 0=No CARRYIN input, 1=Has CARRYIN input (must be reflected in instructions)
      C_HAS_ACIN         : integer := 0; -- 0=No ACIN input, 1=Has ACIN input (must be reflected in instructions)
      C_HAS_BCIN         : integer := 0; -- 0=No BCIN input, 1=Has BCIN input (must be reflected in instructions)
      C_HAS_PCIN         : integer := 0; -- 0=No PCIN input, 1=Has PCIN input (must be reflected in instructions)
      C_HAS_A            : integer := 1; -- 0=No A input, 1=Has A input (must be reflected in instructions)
      C_HAS_B            : integer := 1; -- 0=No B input, 1=Has B input (must be reflected in instructions)
      C_HAS_D            : integer := 1; -- 0=No D input, 1=Has D input (must be reflected in instructions)
      C_HAS_CONCAT       : integer := 0; -- 0=No CONCAT input, 1=Has CONCAT input (must be reflected in instructions)
      C_HAS_C            : integer := 0; -- 0=No C input, 1=Has C input (must be reflected in instructions)
      C_A_WIDTH          : integer := ci_dsp48_b_width; -- Width of A input bus (if present)
      C_B_WIDTH          : integer := ci_dsp48_b_width; -- Width of B input bus (if present)
      C_C_WIDTH          : integer := ci_dsp48_c_width; -- Width of C input bus (if present)
      C_D_WIDTH          : integer := 0; -- Width of D input bus (if present)
      C_CONCAT_WIDTH     : integer := 0; -- Width of CONCAT input bus (if present)
      C_P_MSB            : integer := ci_dsp48_p_width-1; -- MSB of P output
      C_P_LSB            : integer := 0; -- LSB of P output
      C_SEL_WIDTH        : integer := 5; -- Width of instruction ROM select port (0 to 6, based on C_OPMODES)
      C_HAS_ACOUT        : integer := 0; -- 0=No ACOUT port, 1=Has ACOUT cascade port
      C_HAS_BCOUT        : integer := 0; -- 0=No BCOUT port, 1=Has BCOUT cascade port
      C_HAS_CARRYCASCOUT : integer := 0; -- 0=No CARRYCASCOUT port, 1=Has CARRYCASCOUT cascade port
      C_HAS_CARRYOUT     : integer := 0; -- 0=No CARRYOUT port, 1=Has CARRYOUT port
      C_HAS_PCOUT        : integer := 0; -- 0=No PCOUT port, 1=Has PCOUT cascade port
      C_CONSTANT_1       : integer := 1; -- Constant to allow A to pass through multiplier with no B input
      C_LATENCY          : integer := -1; -- Core latency and register allocation; -1=Automatic, 0 to 127=Tiered, 128=Expert
      C_OPMODES          : string  := "0000000000000000000"; -- Instruction opmodes to implement (comma-separated string)
      C_REG_CONFIG       : string  := "00000000000000000000000000000000"; -- Register configuration string (ignored unless C_LATENCY=128)
      C_TEST_CORE        : integer := 0 -- 0 = normal release core behavour 1 = generate a test core
      );
    port (
      CLK          : in  std_logic                                                           := '1'; -- Rising-edge clock
      CE           : in  std_logic                                                           := '1'; -- Active-high global clock enable
      SCLR         : in  std_logic                                                           := '0'; -- Active-high global synchronous reset
      SEL          : in  std_logic_vector(C_SEL_WIDTH+boolean'pos(C_SEL_WIDTH=0)-1 downto 0) := (others => '0'); --Guard against -1 to 0 when C_SEL_WIDTH=0
      CARRYCASCIN  : in  std_logic                                                           := '0';
      CARRYIN      : in  std_logic                                                           := '0';
      PCIN         : in  std_logic_vector(ci_dsp48_p_width-1 downto 0)                       := (others => '0');
      ACIN         : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0)      := (others => '0');
      BCIN         : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                       := (others => '0');
      A            : in  std_logic_vector(C_A_WIDTH-1 downto 0)                              := (others => '0');
      B            : in  std_logic_vector(C_B_WIDTH-1 downto 0)                              := (others => '0');
      C            : in  std_logic_vector(C_C_WIDTH-1 downto 0)                              := (others => '0');
      D            : in  std_logic_vector(C_D_WIDTH-1 downto 0)                              := (others => '0');
      CONCAT       : in  std_logic_vector(C_CONCAT_WIDTH-1 downto 0)                         := (others => '0');
      ACOUT        : out std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0)      := (others => '0');
      BCOUT        : out std_logic_vector(ci_dsp48_b_width-1 downto 0)                       := (others => '0');
      CARRYOUT     : out std_logic                                                           := '0';
      CARRYCASCOUT : out std_logic                                                           := '0';
      PCOUT        : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                       := (others => '0');
      P            : out std_logic_vector(C_P_MSB-C_P_LSB downto 0)                          := (others => '0');
      CED          : in  std_logic                                                           := '1'; -- Ganged CE for D (Spartan)
      CED1         : in  std_logic                                                           := '1';
      CED2         : in  std_logic                                                           := '1';
      CED3         : in  std_logic                                                           := '1';
      CEA          : in  std_logic                                                           := '1'; -- Ganged CE for A (Spartan)
      CEA1         : in  std_logic                                                           := '1';
      CEA2         : in  std_logic                                                           := '1';
      CEA3         : in  std_logic                                                           := '1';
      CEA4         : in  std_logic                                                           := '1';
      CEB          : in  std_logic                                                           := '1'; -- Ganged CE for B (Spartan)
      CEB1         : in  std_logic                                                           := '1';
      CEB2         : in  std_logic                                                           := '1';
      CEB3         : in  std_logic                                                           := '1';
      CEB4         : in  std_logic                                                           := '1';
      CECONCAT     : in  std_logic                                                           := '1'; -- Ganged CE for CONCAT (Spartan)
      CECONCAT3    : in  std_logic                                                           := '1';
      CECONCAT4    : in  std_logic                                                           := '1';
      CECONCAT5    : in  std_logic                                                           := '1';
      CEC          : in  std_logic                                                           := '1'; -- Ganged CE for C (Spartan)
      CEC1         : in  std_logic                                                           := '1';
      CEC2         : in  std_logic                                                           := '1';
      CEC3         : in  std_logic                                                           := '1';
      CEC4         : in  std_logic                                                           := '1';
      CEC5         : in  std_logic                                                           := '1';
      CEM          : in  std_logic                                                           := '1';
      CEP          : in  std_logic                                                           := '1';
      CESEL        : in  std_logic                                                           := '1'; -- Ganged CE for SEL (Spartan)
      CESEL1       : in  std_logic                                                           := '1';
      CESEL2       : in  std_logic                                                           := '1';
      CESEL3       : in  std_logic                                                           := '1';
      CESEL4       : in  std_logic                                                           := '1';
      CESEL5       : in  std_logic                                                           := '1';
      SCLRD        : in  std_logic                                                           := '0';
      SCLRA        : in  std_logic                                                           := '0';
      SCLRB        : in  std_logic                                                           := '0';
      SCLRCONCAT   : in  std_logic                                                           := '0';
      SCLRC        : in  std_logic                                                           := '0';
      SCLRM        : in  std_logic                                                           := '0';
      SCLRP        : in  std_logic                                                           := '0';
      SCLRSEL      : in  std_logic                                                           := '0'
      );
--core_if off
end xbip_dsp48_macro_v2_1_xst;


architecture behavioral of xbip_dsp48_macro_v2_1_xst is

begin
  --core_if on instance i_behv xbip_dsp48_macro_v2_1
  i_behv : xbip_dsp48_macro_v2_1
    generic map (
      C_VERBOSITY        => C_VERBOSITY,
      C_MODEL_TYPE       => C_MODEL_TYPE,
      C_XDEVICEFAMILY    => C_XDEVICEFAMILY,
      C_HAS_CE           => C_HAS_CE,
      C_HAS_INDEP_CE     => C_HAS_INDEP_CE,
      C_HAS_CED          => C_HAS_CED,
      C_HAS_CEA          => C_HAS_CEA,
      C_HAS_CEB          => C_HAS_CEB,
      C_HAS_CEC          => C_HAS_CEC,
      C_HAS_CECONCAT     => C_HAS_CECONCAT,
      C_HAS_CEM          => C_HAS_CEM,
      C_HAS_CEP          => C_HAS_CEP,
      C_HAS_CESEL        => C_HAS_CESEL,
      C_HAS_SCLR         => C_HAS_SCLR,
      C_HAS_INDEP_SCLR   => C_HAS_INDEP_SCLR,
      C_HAS_SCLRD        => C_HAS_SCLRD,
      C_HAS_SCLRA        => C_HAS_SCLRA,
      C_HAS_SCLRB        => C_HAS_SCLRB,
      C_HAS_SCLRC        => C_HAS_SCLRC,
      C_HAS_SCLRM        => C_HAS_SCLRM,
      C_HAS_SCLRP        => C_HAS_SCLRP,
      C_HAS_SCLRCONCAT   => C_HAS_SCLRCONCAT,
      C_HAS_SCLRSEL      => C_HAS_SCLRSEL,
      C_HAS_CARRYCASCIN  => C_HAS_CARRYCASCIN,
      C_HAS_CARRYIN      => C_HAS_CARRYIN,
      C_HAS_ACIN         => C_HAS_ACIN,
      C_HAS_BCIN         => C_HAS_BCIN,
      C_HAS_PCIN         => C_HAS_PCIN,
      C_HAS_A            => C_HAS_A,
      C_HAS_B            => C_HAS_B,
      C_HAS_D            => C_HAS_D,
      C_HAS_CONCAT       => C_HAS_CONCAT,
      C_HAS_C            => C_HAS_C,
      C_A_WIDTH          => C_A_WIDTH,
      C_B_WIDTH          => C_B_WIDTH,
      C_C_WIDTH          => C_C_WIDTH,
      C_D_WIDTH          => C_D_WIDTH,
      C_CONCAT_WIDTH     => C_CONCAT_WIDTH,
      C_P_MSB            => C_P_MSB,
      C_P_LSB            => C_P_LSB,
      C_SEL_WIDTH        => C_SEL_WIDTH,
      C_HAS_ACOUT        => C_HAS_ACOUT,
      C_HAS_BCOUT        => C_HAS_BCOUT,
      C_HAS_CARRYCASCOUT => C_HAS_CARRYCASCOUT,
      C_HAS_CARRYOUT     => C_HAS_CARRYOUT,
      C_HAS_PCOUT        => C_HAS_PCOUT,
      C_CONSTANT_1       => C_CONSTANT_1,
      C_LATENCY          => C_LATENCY,
      C_OPMODES          => C_OPMODES,
      C_REG_CONFIG       => C_REG_CONFIG,
      C_TEST_CORE        => C_TEST_CORE
      )
    port map (
      CLK          => CLK,
      CE           => CE,
      SCLR         => SCLR,
      SEL          => SEL,
      CARRYCASCIN  => CARRYCASCIN,
      CARRYIN      => CARRYIN,
      PCIN         => PCIN,
      ACIN         => ACIN,
      BCIN         => BCIN,
      A            => A,
      B            => B,
      C            => C,
      D            => D,
      CONCAT       => CONCAT,
      ACOUT        => ACOUT,
      BCOUT        => BCOUT,
      CARRYOUT     => CARRYOUT,
      CARRYCASCOUT => CARRYCASCOUT,
      PCOUT        => PCOUT,
      P            => P,
      CED          => CED,
      CED1         => CED1,
      CED2         => CED2,
      CED3         => CED3,
      CEA          => CEA,
      CEA1         => CEA1,
      CEA2         => CEA2,
      CEA3         => CEA3,
      CEA4         => CEA4,
      CEB          => CEB,
      CEB1         => CEB1,
      CEB2         => CEB2,
      CEB3         => CEB3,
      CEB4         => CEB4,
      CECONCAT     => CECONCAT,
      CECONCAT3    => CECONCAT3,
      CECONCAT4    => CECONCAT4,
      CECONCAT5    => CECONCAT5,
      CEC          => CEC,
      CEC1         => CEC1,
      CEC2         => CEC2,
      CEC3         => CEC3,
      CEC4         => CEC4,
      CEC5         => CEC5,
      CEM          => CEM,
      CEP          => CEP,
      CESEL        => CESEL,
      CESEL1       => CESEL1,
      CESEL2       => CESEL2,
      CESEL3       => CESEL3,
      CESEL4       => CESEL4,
      CESEL5       => CESEL5,
      SCLRD        => SCLRD,
      SCLRA        => SCLRA,
      SCLRB        => SCLRB,
      SCLRCONCAT   => SCLRCONCAT,
      SCLRC        => SCLRC,
      SCLRM        => SCLRM,
      SCLRP        => SCLRP,
      SCLRSEL      => SCLRSEL
      );

  --core_if off

end behavioral;

