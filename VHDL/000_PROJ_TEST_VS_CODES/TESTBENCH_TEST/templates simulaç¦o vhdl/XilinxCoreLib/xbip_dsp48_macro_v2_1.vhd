-- $RCSfile: xbip_dsp48_macro_v2_1.vhd,v $ $Date: 2011/05/26 11:57:25 $ $Revision: 1.7 $
-------------------------------------------------------------------------------
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
---------------------------------------------------------------
-- This is the Synthesizable RTL model (aka 'soft instantiation')
-- This model is intended to be synthesized using only RTL and sub-blocks which
-- ultimately use only RTL. The purpose is to test XST inference QoR, but also
-- allow delivery of RTL-only source code.
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

library xilinxcorelib;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;

library xilinxcorelib;
use xilinxcorelib.bip_dsp48_macro_pkg_v2_1.all;

--core_if on entity xbip_dsp48_macro_v2_1
entity xbip_dsp48_macro_v2_1 is
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
end entity xbip_dsp48_macro_v2_1;


architecture behavioral of xbip_dsp48_macro_v2_1 is

  constant dsp48_macro_latency : t_dsp48_macro_latency := fn_dsp48_macro_v2_1_latency(
    P_VERBOSITY       => C_VERBOSITY,
    P_MODEL_TYPE      => C_MODEL_TYPE,
    P_XDEVICEFAMILY   => C_XDEVICEFAMILY,
    P_HAS_CE          => C_HAS_CE,
    P_HAS_SCLR        => C_HAS_SCLR,
    P_HAS_CARRYCASCIN => C_HAS_CARRYCASCIN,
    P_HAS_CARRYIN     => C_HAS_CARRYIN,
    P_HAS_ACIN        => C_HAS_ACIN,
    P_HAS_BCIN        => C_HAS_BCIN,
    P_HAS_ACOUT       => C_HAS_ACOUT,
    P_HAS_BCOUT       => C_HAS_BCOUT,
    P_HAS_A           => C_HAS_A,
    P_HAS_B           => C_HAS_B,
    P_HAS_D           => C_HAS_D,
    P_HAS_CONCAT      => C_HAS_CONCAT,
    P_A_WIDTH         => C_A_WIDTH,
    P_B_WIDTH         => C_B_WIDTH,
    P_C_WIDTH         => C_C_WIDTH,
    P_D_WIDTH         => C_D_WIDTH,
    P_CONCAT_WIDTH    => C_CONCAT_WIDTH,
    P_SEL_WIDTH       => C_SEL_WIDTH,
    P_LATENCY         => C_LATENCY,
    P_OPMODES         => C_OPMODES,
    P_REG_CONFIG      => C_REG_CONFIG
    );

  signal diag_latency : t_dsp48_macro_latency := dsp48_macro_latency;
  constant ci_pipe    : t_dsp48_macro_pipe    := dsp48_macro_latency.reg_config;  --.pipe;
  -- Use reg config, this is the value fedback to the GUI and show from a simplistic point of view which registers are enabled rather than actual implementation

  type t_opmode_rom is array (0 to 2**C_SEL_WIDTH-1) of std_logic_vector(ci_opmode_width-1 downto 0);
  function fn_opmodes_to_rom(
    p_opmodes : string
    ) return t_opmode_rom is
    variable v_val     : string(1 to p_opmodes'length);
    variable temp_str  : string(1 to p_opmodes'length);
    variable clear_str : string(1 to p_opmodes'length);
    variable opmode    : std_logic_vector(ci_opmode_width-1 downto 0);
    variable len       : integer;
    variable start     : integer;
    variable cursor    : integer;
    variable ret_val   : t_opmode_rom := (others => (others => '0'));  -- give all locations a default;
    variable rom_addr  : integer;
  begin
    --find the first non-space character
    start    := 0;
    rom_addr := 0;
    v_val    := p_opmodes;
    len      := p_opmodes'length;
    for i in 1 to len loop
      if v_val(i) = '0' or v_val(i) = '1' then
        start := i;
        exit;
      end if;
    end loop;  -- i

    if start = 0 then
      -- coverage off
      assert false
        report "ERROR: xbip_dsp48_macro_v2_1: no 0/1's detected in OPMODE string"
        severity error;
      return ret_val;                   --return default  invalid
      -- coverage on
    end if;

    for w in temp_str'range loop
      clear_str(w) := '0';              --used to clear temp_str
    end loop;

    temp_str := clear_str;
    cursor   := 0;

    --will this loop detect the last opmode? &&&
    for j in start to len loop
      if v_val(j) = '1' or v_val(j) = '0' then
        cursor           := cursor +1;  --keep track of its length
        temp_str(cursor) := v_val(j);   --construct element string
      else
        --next word
        opmode            := str_to_bound_slv_0(str_to_bound_str(temp_str(1 to cursor), ci_opmode_width, "0"), ci_opmode_width);
        ret_val(rom_addr) := opmode;
        rom_addr          := rom_addr +1;
        temp_str          := clear_str;
        cursor            := 0;
      end if;
      if j = len and (v_val(j) = '1' or v_val(j) = '0') then
        --next word
        opmode            := str_to_bound_slv_0(str_to_bound_str(temp_str(1 to cursor), ci_opmode_width, "0"), ci_opmode_width);
        ret_val(rom_addr) := opmode;
        rom_addr          := rom_addr +1;
      end if;

    end loop;  -- j

    return ret_val;

  end function fn_opmodes_to_rom;
  constant ci_opmode_rom : t_opmode_rom := fn_opmodes_to_rom(C_OPMODES);
  signal diag_opmode_rom : t_opmode_rom;

  constant ci_macro_config : t_macro_config := fn_get_macro_config(C_OPMODES);
  signal diag_macro_config : t_macro_config;

  --resolve calls to xbip_utils now to save multiple calls later.
  constant ci_dsp48_concat_width : integer := fn_dsp48_concat_width(C_XDEVICEFAMILY);
  constant ci_dsp48_a_width      : integer := fn_dsp48_a_width(C_XDEVICEFAMILY);
  constant ci_dsp48_amult_width  : integer := fn_dsp48_amult_width(C_XDEVICEFAMILY);
  constant ci_dsp48_d_width      : integer := fn_dsp48_d_width(C_XDEVICEFAMILY);
  constant supports_dsp48a       : integer := supports_dsp48a(C_XDEVICEFAMILY);
  constant supports_dsp48a1      : integer := supports_dsp48a1(C_XDEVICEFAMILY);
  constant supports_dsp48e       : integer := supports_dsp48e(C_XDEVICEFAMILY);
  constant supports_dsp48e1      : integer := supports_dsp48e1(C_XDEVICEFAMILY);
  constant has_dsp48             : boolean := has_dsp48(C_XDEVICEFAMILY);
  constant has_dsp               : boolean := has_dsp(C_XDEVICEFAMILY);

  constant ci_round_const : std_logic_vector(ci_dsp48_c_width-1 downto 0) := fn_get_round_const(C_P_LSB);

  -- signals section
  -----------------------------------------------------------------------------
  -- Naming convention
  -- Many of the signal names follow the form X_YZ where X and Y are letters
  -- and Z is a number.
  -- X refers to the input port. Y is 'i' or 'r'. Although these started life
  -- as 'internal' and 'resized', think of them as post-register and pre-next-register.
  -- Hence the code is broken into registers and logic, with the register described
  -- by an xbip_pipe and the logic converting X_iZ signals into X_rZ signals.
  -----------------------------------------------------------------------------

  signal ce_i,
    ce_src : std_logic_vector(ci_num_registers downto 0) := (others => '1');
  signal sclr_i,
    sclr_src : std_logic_vector(ci_num_registers downto 0) := (others => '0');

  signal a_i1 : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  signal b_i1 : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  signal c_i1 : std_logic_vector(C_C_WIDTH-1 downto 0) := (others => '0');
  signal d_i1 : std_logic_vector(C_D_WIDTH-1 downto 0) := (others => '0');

  constant ci_b_one : std_logic_vector(C_B_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(C_CONSTANT_1, C_B_WIDTH));
  signal a_mux1     : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  signal b_mux1     : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');


  signal a_i2 : std_logic_vector(C_A_WIDTH-1 downto 0) := (others => '0');
  signal b_i2 : std_logic_vector(C_B_WIDTH-1 downto 0) := (others => '0');
  signal c_i2 : std_logic_vector(C_C_WIDTH-1 downto 0) := (others => '0');
  signal d_i2 : std_logic_vector(C_D_WIDTH-1 downto 0) := (others => '0');

  --these signals are the output of the mux between direct inputs and concat
  signal a_p2 : std_logic_vector(ci_dsp48_a_width-1 downto 0) := (others => '0');
  signal b_p2 : std_logic_vector(ci_dsp48_b_width-1 downto 0) := (others => '0');

  --these signals are the output of the mux between fabric inputs and cascade.
  signal a_r2 : std_logic_vector(ci_dsp48_a_width-1 downto 0) := (others => '0');
  signal b_r2 : std_logic_vector(ci_dsp48_b_width-1 downto 0) := (others => '0');
  signal d_r2 : std_logic_vector(ci_dsp48_d_width-1 downto 0) := (others => '0');

  signal a_i3 : std_logic_vector(ci_dsp48_a_width-1 downto 0) := (others => '0');
  signal b_i3 : std_logic_vector(ci_dsp48_b_width-1 downto 0) := (others => '0');
  signal c_i3 : std_logic_vector(C_C_WIDTH-1 downto 0)        := (others => '0');
  signal d_i3 : std_logic_vector(ci_dsp48_d_width-1 downto 0) := (others => '0');

  signal a_r3 : std_logic_vector(ci_dsp48_a_width-1 downto 0) := (others => '0');
  signal b_r3 : std_logic_vector(ci_dsp48_b_width-1 downto 0) := (others => '0');
  signal c_r3 : std_logic_vector(ci_dsp48_c_width-1 downto 0) := (others => '0');

  signal concat_i2 : std_logic_vector(ci_dsp48_concat_width-1 downto 0) := (others => '0');
  signal concat_i3 : std_logic_vector(ci_dsp48_concat_width-1 downto 0) := (others => '0');
  signal concat_i4 : std_logic_vector(ci_dsp48_concat_width-1 downto 0) := (others => '0');
  signal concat_i5 : std_logic_vector(ci_dsp48_concat_width-1 downto 0) := (others => '0');

  signal a_i4 : std_logic_vector(ci_dsp48_a_width-1 downto 0)                      := (others => '0');
  signal b_i4 : std_logic_vector(ci_dsp48_b_width-1 downto 0)                      := (others => '0');
  signal c_i4 : std_logic_vector(ci_dsp48_c_width-1 downto 0)                      := (others => '0');
  signal m_r4 : std_logic_vector(ci_dsp48_amult_width+ci_dsp48_b_width-1 downto 0) := (others => '0');

  signal c_i5 : std_logic_vector(ci_dsp48_c_width-1 downto 0)                      := (others => '0');
  signal m_i5 : std_logic_vector(ci_dsp48_amult_width+ci_dsp48_b_width-1 downto 0) := (others => '0');

  signal op_i0 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');
  signal op_i1 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');
  signal op_i2 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');
  signal op_i3 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');
  signal op_i4 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');
  signal op_i5 : std_logic_vector(ci_opmode_width-1 downto 0) := (others => '0');

  -- Ensure LUTRAM is inferred, not BRAM
  attribute rom_style          : string;
  attribute rom_style of op_i0 : signal is "distributed";

  signal carryin_i1 : std_logic := '0';
  signal carryin_i2 : std_logic := '0';
  signal carryin_i3 : std_logic := '0';
  signal carryin_i4 : std_logic := '0';
  signal carryin_i5 : std_logic := '0';

  signal carryin_r3 : std_logic := '0';
  signal carryin_r5 : std_logic := '0';

  signal subtract_i : std_logic := '0';

  signal pcin_i      : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal shift_pcin  : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal shift_preg  : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal x_i5        : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal y_i5        : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal z_i5        : std_logic_vector(ci_dsp48_p_width-1 downto 0)   := (others => '0');
  signal p_r5        : std_logic_vector(ci_dsp48_p_width+1-1 downto 0) := (others => '0');
  signal p_i6        : std_logic_vector(ci_dsp48_p_width+1-1 downto 0) := (others => '0');
  signal carryout_i6 : std_logic                                       := '0';

  function get_mult_style (C_XDEVICEFAMILY : string) return string is
  begin
    if supports_mult18x18(C_XDEVICEFAMILY) > 0 then
      return "block";
    else
      -- Devices with a DSP48
      return "lut";
    end if;
  end function get_mult_style;

  attribute use_dsp48          : string;
  attribute use_dsp48 of p_i6  : signal is "no";
  attribute use_dsp48 of m_i5  : signal is "no";
  attribute mult_style         : string;
  attribute mult_style of m_i5 : signal is get_mult_style(C_XDEVICEFAMILY);

  function bit_set(val, div : integer) return boolean is
  begin

    return (((val/div) mod 2) = 1);

  end function bit_set;

  signal ced_i, ced1_i, ced2_i, ced3_i                             : std_logic := '1';
  signal cea_i, cea1_i, cea2_i, cea3_i, cea4_i                     : std_logic := '1';
  signal ceb_i, ceb1_i, ceb2_i, ceb3_i, ceb4_i                     : std_logic := '1';
  signal ceconcat_i, ceconcat3_i, ceconcat4_i, ceconcat5_i         : std_logic := '1';
  signal ceconcat3_tmp, ceconcat4_tmp, ceconcat5_tmp               : std_logic := '1';
  signal cec_i, cec1_i, cec2_i, cec3_i, cec4_i, cec5_i             : std_logic := '1';
  signal cem_i                                                     : std_logic := '1';
  signal cep_i                                                     : std_logic := '1';
  signal cesel_i, cesel1_i, cesel2_i, cesel3_i, cesel4_i, cesel5_i : std_logic := '1';

  signal sclrd_i, sclra_i, sclrb_i, sclrconcat_i, sclrc_i, sclrm_i, sclrp_i, sclrsel_i : std_logic := '0';

begin

  -----------------------------------------------------------------------------
  -- Diagnostics
  -----------------------------------------------------------------------------
  -- Comment-in if necessary.  Commented-out to avoid SysGen/ISim issues.
--  diag_opmode_rom <= ci_opmode_rom;
--  diag_macro_config <= ci_macro_config;

  --see bip_utils_v2_0 for 'simulating'. Basically, this code will only operate
  --when simulating, not for synthesis.
  i_runtime_checks : if simulating = 1 generate
    i_proc : process (clk)
      variable opmode_str : string(1 to 50);
      variable opmode     : std_logic_vector(ci_opmode_width-1 downto 0);
    begin
      --yes, deliberately falling edge clock. Since tools 'snoop' code I dare
      --not write an unsynthesizable 'wait'.
      if falling_edge(clk) then
        opmode     := op_i0;  -- i.e. ci_opmode_rom(to_integer(unsigned(SEL)));
        opmode_str := fn_interpret_opmode(opmode).disassembled;
        --Insert check for SUBTRACT with rounding here.
        assert C_VERBOSITY < 2 report "opmode is "&opmode_str severity note;
        assert C_VERBOSITY < 2 report "opmode = "&slv_to_str(opmode) severity note;
      end if;
    end process i_proc;
  end generate i_runtime_checks;

  -----------------------------------------------------------------------------
  -- Start of rtl code.
  -----------------------------------------------------------------------------
  i_has_global_ce : if C_HAS_CE = 1 and C_HAS_INDEP_CE = 0 generate
    ce_i <= (others => CE);
  end generate i_has_global_ce;
  i_has_global_sclr : if C_HAS_SCLR = 1 and C_HAS_INDEP_SCLR = 0 generate
    sclr_i <= (others => SCLR);
  end generate i_has_global_sclr;

  ced_i  <= CED  when C_HAS_CED /= 0 and C_HAS_INDEP_CE = 1                           else '1';
  ced1_i <= CED1 when C_HAS_CED /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CED, 1) else '1';
  ced2_i <= CED2 when C_HAS_CED /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CED, 2) else '1';
  ced3_i <= CED3 when C_HAS_CED /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CED, 4) else '1';

  cea_i  <= CEA  when C_HAS_CEA /= 0 and C_HAS_INDEP_CE = 1                           else '1';
  cea1_i <= CEA1 when C_HAS_CEA /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEA, 1) else '1';
  cea2_i <= CEA2 when C_HAS_CEA /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEA, 2) else '1';
  cea3_i <= CEA3 when C_HAS_CEA /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEA, 4) else '1';
  cea4_i <= CEA4 when C_HAS_CEA /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEA, 8) else '1';

  ceb_i  <= CEB  when C_HAS_CEB /= 0 and C_HAS_INDEP_CE = 1                           else '1';
  ceb1_i <= CEB1 when C_HAS_CEB /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEB, 1) else '1';
  ceb2_i <= CEB2 when C_HAS_CEB /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEB, 2) else '1';
  ceb3_i <= CEB3 when C_HAS_CEB /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEB, 4) else '1';
  ceb4_i <= CEB4 when C_HAS_CEB /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEB, 8) else '1';

  ceconcat_i  <= CECONCAT  when C_HAS_CECONCAT /= 0 and C_HAS_INDEP_CE = 1                                 else '1';
  ceconcat3_i <= CECONCAT3 when C_HAS_CECONCAT /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CECONCAT, 4)  else '1';
  ceconcat4_i <= CECONCAT4 when C_HAS_CECONCAT /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CECONCAT, 8)  else '1';
  ceconcat5_i <= CECONCAT5 when C_HAS_CECONCAT /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CECONCAT, 16) else '1';

  -- Note no remapping CEs based on register movements in latency function -
  -- this applies to the instantiation (synth) model only

  cec_i  <= CEC  when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 1                            else '1';
  cec1_i <= CEC1 when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEC, 1)  else '1';
  cec2_i <= CEC2 when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEC, 2)  else '1';
  cec3_i <= CEC3 when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEC, 4)  else '1';
  cec4_i <= CEC4 when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEC, 8)  else '1';
  cec5_i <= CEC5 when C_HAS_CEC /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CEC, 16) else '1';

  cem_i <= CEM when C_HAS_CEM /= 0 and C_HAS_INDEP_CE /= 0 else '1';

  cep_i <= CEP when C_HAS_CEP /= 0 and C_HAS_INDEP_CE /= 0 else '1';

  cesel_i  <= CESEL  when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 1                              else '1';
  cesel1_i <= CESEL1 when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CESEL, 1)  else '1';
  cesel2_i <= CESEL2 when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CESEL, 2)  else '1';
  cesel3_i <= CESEL3 when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CESEL, 4)  else '1';
  cesel4_i <= CESEL4 when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CESEL, 8)  else '1';
  cesel5_i <= CESEL5 when C_HAS_CESEL /= 0 and C_HAS_INDEP_CE = 2 and bit_set(C_HAS_CESEL, 16) else '1';

  sclrd_i      <= SCLRD      when C_HAS_SCLRD /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclra_i      <= SCLRA      when C_HAS_SCLRA /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclrb_i      <= SCLRB      when C_HAS_SCLRB /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclrconcat_i <= SCLRCONCAT when C_HAS_SCLRCONCAT /= 0 and C_HAS_INDEP_SCLR /= 0 else '0';
  sclrc_i      <= SCLRC      when C_HAS_SCLRC /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclrm_i      <= SCLRM      when C_HAS_SCLRM /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclrp_i      <= SCLRP      when C_HAS_SCLRP /= 0 and C_HAS_INDEP_SCLR /= 0      else '0';
  sclrsel_i    <= SCLRSEL    when C_HAS_SCLRSEL /= 0 and C_HAS_INDEP_SCLR /= 0    else '0';

  ce_src(ci_d1) <= CED1_i when C_HAS_INDEP_CE = 2 else CED_i;
  ce_src(ci_d2) <= CED2_i when C_HAS_INDEP_CE = 2 else CED_i;
  ce_src(ci_d3) <= CED3_i when C_HAS_INDEP_CE = 2 and C_HAS_CONCAT = 0 else
                   CED_i       when C_HAS_CONCAT = 0 else
                   CECONCAT3_i when C_HAS_INDEP_CE = 2 else
                   CECONCAT_i;
  ce_src(ci_a1) <= CEA1_i when C_HAS_INDEP_CE = 2 else CEA_i;
  ce_src(ci_a2) <= CEA2_i when C_HAS_INDEP_CE = 2 else CEA_i;
  ce_src(ci_a3) <= CEA3_i when C_HAS_INDEP_CE = 2 and C_HAS_CONCAT = 0 else
                   CEA_i       when C_HAS_CONCAT = 0 else
                   CECONCAT3_i when C_HAS_INDEP_CE = 2 else
                   CECONCAT_i;
  ce_src(ci_a4) <= CEA4_i when C_HAS_INDEP_CE = 2 and C_HAS_CONCAT = 0 else
                   CEA_i       when C_HAS_CONCAT = 0 else
                   CECONCAT4_i when C_HAS_INDEP_CE = 2 else
                   CECONCAT_i;
  ce_src(ci_b1) <= CEB1_i when C_HAS_INDEP_CE = 2 else CEB_i;
  ce_src(ci_b2) <= CEB2_i when C_HAS_INDEP_CE = 2 else CEB_i;
  ce_src(ci_b3) <= CEB3_i when C_HAS_INDEP_CE = 2 and C_HAS_CONCAT = 0 else
                   CEB_i       when C_HAS_CONCAT = 0 else
                   CECONCAT3_i when C_HAS_INDEP_CE = 2 else
                   CECONCAT_i;
  ce_src(ci_b4) <= CEB4_i when C_HAS_INDEP_CE = 2 and C_HAS_CONCAT = 0 else
                   CEB_i       when C_HAS_CONCAT = 0 else
                   CECONCAT4_i when C_HAS_INDEP_CE = 2 else
                   CECONCAT_i;
  -- ce_src(ci_concat3) <= CECONCAT3 when C_HAS_INDEP_CE = 2 else CEA; -- Doesn't actually exist
  ce_src(ci_concat4) <= CECONCAT4_i when C_HAS_INDEP_CE = 2 else CECONCAT_i;
  ce_src(ci_concat5) <= CECONCAT5_i when C_HAS_INDEP_CE = 2 else CECONCAT_i;
  ce_src(ci_c1)      <= CEC1_i      when C_HAS_INDEP_CE = 2 else CEC_i;
  ce_src(ci_c2)      <= CEC2_i      when C_HAS_INDEP_CE = 2 else CEC_i;
  ce_src(ci_c3)      <= CEC3_i      when C_HAS_INDEP_CE = 2 else CEC_i;
  ce_src(ci_c4)      <= CEC4_i      when C_HAS_INDEP_CE = 2 else CEC_i;
  ce_src(ci_c5)      <= CEC5_i      when C_HAS_INDEP_CE = 2 else CEC_i;
  ce_src(ci_m5)      <= CEM_i;
  ce_src(ci_p6)      <= CEP_i;
  ce_src(ci_op1)     <= CESEL1_i    when C_HAS_INDEP_CE = 2 else CESEL_i;
  ce_src(ci_op2)     <= CESEL2_i    when C_HAS_INDEP_CE = 2 else CESEL_i;
  ce_src(ci_op3)     <= CESEL3_i    when C_HAS_INDEP_CE = 2 else CESEL_i;
  ce_src(ci_op4)     <= CESEL4_i    when C_HAS_INDEP_CE = 2 else CESEL_i;
  ce_src(ci_op5)     <= CESEL5_i    when C_HAS_INDEP_CE = 2 else CESEL_i;

  sclr_src(ci_d1) <= SCLRD_i;
  sclr_src(ci_d2) <= SCLRD_i;
  sclr_src(ci_d3) <= SCLRD_i when C_HAS_CONCAT = 0 else SCLRCONCAT_i;
  sclr_src(ci_a1) <= SCLRA_i;
  sclr_src(ci_a2) <= SCLRA_i;
  sclr_src(ci_a3) <= SCLRA_i when C_HAS_CONCAT = 0 else SCLRCONCAT_i;
  sclr_src(ci_a4) <= SCLRD_i when supports_dsp48e1 > 0 and C_HAS_D = 1 else
                     -- unfortunate side effect of mapping A4 to ADREG of DSP48E1. It is reset by RSTD but has an
                     -- independant enable
                     SCLRA_i when C_HAS_CONCAT = 0 else SCLRCONCAT_i;
  sclr_src(ci_b1) <= SCLRB_i;
  sclr_src(ci_b2) <= SCLRB_i;
  sclr_src(ci_b3) <= SCLRB_i when C_HAS_CONCAT = 0 else SCLRCONCAT_i;
  sclr_src(ci_b4) <= SCLRB_i when C_HAS_CONCAT = 0 else SCLRCONCAT_i;

  sclr_src(ci_concat4) <= SCLRCONCAT_i;
  sclr_src(ci_concat5) <= SCLRCONCAT_i;
  sclr_src(ci_c1)      <= SCLRC_i;
  sclr_src(ci_c2)      <= SCLRC_i;
  sclr_src(ci_c3)      <= SCLRC_i;
  sclr_src(ci_c4)      <= SCLRC_i;
  sclr_src(ci_c5)      <= SCLRC_i;
  sclr_src(ci_m5)      <= SCLRM_i;
  sclr_src(ci_p6)      <= SCLRP_i;
  sclr_src(ci_op1)     <= SCLRSEL_i;
  sclr_src(ci_op2)     <= SCLRSEL_i;
  sclr_src(ci_op3)     <= SCLRSEL_i;
  sclr_src(ci_op4)     <= SCLRSEL_i;
  sclr_src(ci_op5)     <= SCLRSEL_i;

  i_has_indep_ce : if C_HAS_CE = 1 and C_HAS_INDEP_CE /= 0 generate
    ce_i <= ce_src;
  end generate i_has_indep_ce;

  i_has_indep_sclr : if C_HAS_SCLR = 1 and C_HAS_INDEP_SCLR /= 0 generate
    sclr_i <= sclr_src;
  end generate i_has_indep_sclr;

  -----------------------------------------------------------------------------
  -- Tier 1 (Mult path)
  -----------------------------------------------------------------------------
  i_has_a : if C_HAS_A /= 0 generate
    i_a1 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_a1),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_A_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_a1),
        SCLR => sclr_i(ci_a1),
        D    => A,
        Q    => a_i1
        );
  end generate i_has_a;

  i_has_b : if C_HAS_B = 1 generate
    i_b1 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_b1),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_B_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_b1),
        SCLR => sclr_i(ci_b1),
        D    => B,
        Q    => b_i1
        );
  end generate i_has_b;

  i_has_d : if C_HAS_D = 1 generate
    i_d1 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_d1),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_D_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_d1),
        SCLR => sclr_i(ci_d1),
        D    => D,
        Q    => d_i1
        );
  end generate i_has_d;

  a_mux1 <= a_i1;
  b_mux1 <= b_i1 when op_i1(ci_opfield_abmux) = '0' else ci_b_one;

  -----------------------------------------------------------------------------
  -- Tier 2 (Mult path)
  -----------------------------------------------------------------------------
  i_a2 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_a2),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => C_A_WIDTH
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_a2),
      SCLR => sclr_i(ci_a2),
      D    => a_mux1,
      Q    => a_i2
      );
  i_b2 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_b2),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => C_B_WIDTH
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_b2),
      SCLR => sclr_i(ci_b2),
      D    => b_mux1,
      Q    => b_i2
      );
  i_d2 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_d2),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => C_D_WIDTH
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_d2),
      SCLR => sclr_i(ci_d2),
      D    => d_i1,
      Q    => d_i2
      );

  i_mux_concat : if C_HAS_CONCAT = 1 generate
    concat_i2 <= std_logic_vector(resize(signed(CONCAT), ci_dsp48_concat_width));
    a_p2      <= concat_i2(ci_dsp48_a_width + ci_dsp48_b_width-1 downto ci_dsp48_b_width);
    b_p2      <= concat_i2(ci_dsp48_b_width-1 downto 0);
    i_has_d : if supports_dsp48a > 0 or supports_dsp48e1 > 0 generate
      d_r2 <= std_logic_vector(resize(signed(concat_i2(concat_i2'left downto ci_dsp48_a_width + ci_dsp48_b_width)), ci_dsp48_d_width));
    end generate i_has_d;
  end generate i_mux_concat;
  i_mux_no_concat : if C_HAS_CONCAT = 0 generate
    a_p2 <= std_logic_vector(resize(signed(a_i2), ci_dsp48_a_width));
    b_p2 <= std_logic_vector(resize(signed(b_i2), ci_dsp48_b_width));
    d_r2 <= std_logic_vector(resize(signed(d_i2), ci_dsp48_d_width));
  end generate i_mux_no_concat;

  i_acin : if C_HAS_ACIN /= 0 generate
    a_r2 <= ACIN;
  end generate i_acin;
  i_no_acin : if C_HAS_ACIN = 0 generate
    a_r2 <= std_logic_vector(resize(signed(a_p2), ci_dsp48_a_width));
  end generate i_no_acin;
  i_bcin : if C_HAS_BCIN /= 0 generate
    b_r2 <= BCIN;
  end generate i_bcin;
  i_no_bcin : if C_HAS_BCIN = 0 generate
    b_r2 <= std_logic_vector(resize(signed(b_p2), ci_dsp48_b_width));
  end generate i_no_bcin;

  -----------------------------------------------------------------------------
  -- Tier3 Mult path
  -----------------------------------------------------------------------------
  i_a3 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_a3),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_a_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_a3),
      SCLR => sclr_i(ci_a3),
      D    => a_r2,
      Q    => a_i3
      );
  i_b3 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_b3),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_b_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_b3),
      SCLR => sclr_i(ci_b3),
      D    => b_r2,
      Q    => b_i3
      );
  i_has_d3 : if C_HAS_D = 1 or (C_HAS_CONCAT = 1 and supports_dsp48a > 0) generate
    i_d3 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_d3),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => ci_dsp48_d_width
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_d3),
        SCLR => sclr_i(ci_d3),
        D    => d_r2,
        Q    => d_i3
        );
  end generate i_has_d3;

  -----------------------------------------------------------------------------
  -- pre-adder (tier 3 of Mult path)
  -----------------------------------------------------------------------------
  i_v6_preadder : if supports_DSP48E1 > 0 generate
    a_r3 <= a_i3 when op_i3(ti_opfield_preadd) = "00000" else
            std_logic_vector(resize(signed(d_i3), ci_dsp48_a_width)) + a_i3 when op_i3(ti_opfield_preadd) = "00100" else
            std_logic_vector(resize(signed(d_i3), ci_dsp48_a_width)) - a_i3 when op_i3(ti_opfield_preadd) = "01100" else
            - a_i3                                                          when op_i3(ti_opfield_preadd) = "01000" else
            std_logic_vector(resize(signed(d_i3), ci_dsp48_a_width));
    b_r3 <= b_i3;
  end generate i_v6_preadder;
  i_spartan_preadder : if supports_dsp48a > 0 generate
    a_r3 <= a_i3 when op_i3(ti_opfield_preadd) = "00000" else
            d_i3 + a_i3 when op_i3(ti_opfield_preadd) = "00001" else
            d_i3 - a_i3;
    b_r3 <= b_i3;
  end generate i_spartan_preadder;
  i_no_preadder : if supports_dsp48a = 0 and supports_dsp48e1 = 0 generate
    a_r3 <= a_i3;
    b_r3 <= b_i3;
  end generate i_no_preadder;

  -----------------------------------------------------------------------------
  -- Concat bus (tier 3 of Mult path)
  -----------------------------------------------------------------------------
  i_spartan_concat : if supports_dsp48a > 0 generate
    signal concat_temp : std_logic_vector(ci_dsp48_d_width+ci_dsp48_a_width+ci_dsp48_b_width-1 downto 0) := (others => '0');
  begin
    concat_temp <= d_i3&a_i3&b_i3;
    concat_i3   <= concat_temp(ci_dsp48_concat_width-1 downto 0);
  end generate i_spartan_concat;
  i_virtex_concat : if not(supports_dsp48a > 0) generate
    signal concat_temp : std_logic_vector(ci_dsp48_a_width+ci_dsp48_b_width-1 downto 0) := (others => '0');
  begin
    concat_temp <= a_i3&b_i3;
    concat_i3   <= concat_temp(ci_dsp48_concat_width-1 downto 0);
  end generate i_virtex_concat;

  -----------------------------------------------------------------------------
  -- Tier 4 and 5 (Concat path)
  -- These registers are unusual. They are to balance C4 and C5. Since they
  -- don't exist in the primitive, they are invented. In the synth model, they
  -- precede the A, B, D ports.
  -----------------------------------------------------------------------------
  i_concat4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_concat4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_concat_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_concat4),
      SCLR => sclr_i(ci_concat4),
      D    => concat_i3,
      Q    => concat_i4
      );
  i_concat5 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_concat5),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_concat_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_concat5),
      SCLR => sclr_i(ci_concat5),
      D    => concat_i4,
      Q    => concat_i5
      );



  -----------------------------------------------------------------------------
  -- Tier 4 (Mult path)
  -----------------------------------------------------------------------------

  i_a4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_a4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_a_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_a4),
      SCLR => sclr_i(ci_a4),
      D    => a_r3,
      Q    => a_i4
      );
  i_b4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_b4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_b_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_b4),
      SCLR => sclr_i(ci_b4),
      D    => b_r3,
      Q    => b_i4
      );
  BCOUT <= b_i4;

  -- Note: On DSP48A the a(b)cout is taken from after the preadder, when DSP48E1 it is taken from the a path but will
  -- always have A2 (normally ci_a4) set to zero but ADreg will be set for ci_a4 instead to keep the pipeline OK, can't use
  -- A1 as the input to the pre-adder as it can't be disabled for 0 lat but if A2 is used then can have 0 lat.
  ACOUT <= a_i4 when not(C_HAS_D = 1 and supports_dsp48e1 > 0) else a_i3;

  m_r4 <= a_i4(ci_dsp48_amult_width-1 downto 0) * b_i4;

  -----------------------------------------------------------------------------
  -- Tier 5 (Mult path)
  -----------------------------------------------------------------------------
  i_m5 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_m5),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_amult_width+ci_dsp48_b_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_m5),
      SCLR => sclr_i(ci_m5),
      D    => m_r4,
      Q    => m_i5
      );

  -----------------------------------------------------------------------------
  -- Tier 0, 1, 2 and 3 (C Path)
  -----------------------------------------------------------------------------
  i_has_c : if C_HAS_C /= 0 generate
    i_c1 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_c1),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_C_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_c1),
        SCLR => sclr_i(ci_c1),
        D    => C,
        Q    => c_i1
        );
    i_c2 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_c2),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_C_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_c2),
        SCLR => sclr_i(ci_c2),
        D    => c_i1,
        Q    => c_i2
        );
    i_c3 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_c3),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => C_C_WIDTH
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_c3),
        SCLR => sclr_i(ci_c3),
        D    => c_i2,
        Q    => c_i3
        );
  end generate i_has_c;
  c_r3 <= std_logic_vector(resize(signed(c_i3), ci_dsp48_c_width)) when op_i3(ci_opfield_cmux) = '0' else
          ci_round_const;

  -----------------------------------------------------------------------------
  -- Tier 4 (C Path)
  -----------------------------------------------------------------------------
  i_c4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_c4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_c_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_c4),
      SCLR => sclr_i(ci_c4),
      D    => c_r3,
      Q    => c_i4
      );
  i_c5 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_c5),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_c_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_c5),
      SCLR => sclr_i(ci_c5),
      D    => c_i4,
      Q    => c_i5
      );

  -----------------------------------------------------------------------------
  -- OPMODE
  -----------------------------------------------------------------------------

  op_i0 <= ci_opmode_rom(to_integer(unsigned(SEL))) when C_SEL_WIDTH > 0 else
           ci_opmode_rom(0);

  i_op1 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_op1),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_opmode_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op1),
      SCLR => sclr_i(ci_op1),
      D    => op_i0,
      Q    => op_i1
      );
  i_op2 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_op2),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_opmode_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op2),
      SCLR => sclr_i(ci_op2),
      D    => op_i1,
      Q    => op_i2
      );
  i_op3 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_op3),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_opmode_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op3),
      SCLR => sclr_i(ci_op3),
      D    => op_i2,
      Q    => op_i3
      );
  i_op4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_op4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_opmode_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op4),
      SCLR => sclr_i(ci_op4),
      D    => op_i3,
      Q    => op_i4
      );
  i_op5 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_op5),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_opmode_width
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op5),
      SCLR => sclr_i(ci_op5),
      D    => op_i4,
      Q    => op_i5
      );

  -----------------------------------------------------------------------------
  -- Carryin
  -----------------------------------------------------------------------------
  i_carryin1 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_carryin1),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => 1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op1),
      SCLR => sclr_i(ci_op1),
      D(0) => CARRYIN,
      Q(0) => carryin_i1
      );
  i_carryin2 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_carryin2),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => 1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op2),
      SCLR => sclr_i(ci_op2),
      D(0) => carryin_i1,
      Q(0) => carryin_i2
      );
  i_carryin3 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_carryin3),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => 1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op3),
      SCLR => sclr_i(ci_op3),
      D(0) => carryin_i2,
      Q(0) => carryin_i3
      );

  carryin_r3 <= '0' when op_i3(ci_opfield_carryin) = '0' else
                carryin_i3;

  i_carryin4 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_carryin4),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => 1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op4),
      SCLR => sclr_i(ci_op4),
      D(0) => carryin_r3,
      Q(0) => carryin_i4
      );
  i_carryin5 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_carryin5),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => 1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_op5),
      SCLR => sclr_i(ci_op5),
      D(0) => carryin_i4,
      Q(0) => carryin_i5
      );

  --Spartan
  i_spartan_carryin : if supports_dsp48a > 0 generate
    i_use_carrycascin : if C_HAS_CARRYCASCIN = 1 generate
      i_carrycascin5 : xbip_pipe_v2_0_xst
        generic map(
          C_LATENCY  => ci_pipe(ci_carryin5),
          C_HAS_CE   => C_HAS_CE,
          C_HAS_SCLR => C_HAS_SCLR,
          C_WIDTH    => 1
          )
        port map(
          CLK  => CLK,
          CE   => ce_i(ci_op5),
          SCLR => sclr_i(ci_op5),
          D(0) => CARRYCASCIN,
          Q(0) => carryin_r5
          );
    end generate i_use_carrycascin;
    i_no_use_carrycascin : if C_HAS_CARRYCASCIN = 0 generate
      carryin_r5 <= carryin_i5;
    end generate i_no_use_carrycascin;
  end generate i_spartan_carryin;

  --V4 and non-dsp48 families
  i_v4_and_non_dsp_carryin : if has_dsp48 or not (has_dsp) generate
    signal carry_rnd_i4 : std_logic := '0';
    signal carry_rnd_i5 : std_logic := '0';
  begin
    carry_rnd_i4 <= not(a_i4(ci_dsp48_amult_width-1)) when op_i5(ti_opfield_xmux) = "11" else
                    a_i4(ci_dsp48_amult_width-1) xnor b_i4(b_i4'left);
    i_carryrnd5 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => 1,  -- always present if carry used (Mreg present)
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_op5),
        SCLR => sclr_i(ci_op5),
        D(0) => carry_rnd_i4,
        Q(0) => carry_rnd_i5
        );

    carryin_r5 <= carryin_i5 when op_i5(ti_opfield_carrysel) = "000" else
                  not(z_i5(ci_dsp48_p_width-1)) when op_i5(ti_opfield_carrysel) = "001" else
                  carry_rnd_i4                  when op_i5(ti_opfield_carrysel) = "010" else
                  carry_rnd_i5                  when op_i5(ti_opfield_carrysel) = "011" else
                  'X';                  --opmode out of range

  end generate i_v4_and_non_dsp_carryin;

  --V5, V6 and beyoooond
  i_v5on_carryin : if supports_dsp48e > 0 generate
    signal carry_rnd_i4  : std_logic := '0';
    signal carry_rnd_i5  : std_logic := '0';
    signal carrycascin_i : std_logic := '0';
  begin
    carry_rnd_i4 <= a_i4(ci_dsp48_amult_width-1) xnor b_i4(b_i4'left);
    i_carryrnd5 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_m5),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_m5),
        SCLR => sclr_i(ci_op5),
        D(0) => carry_rnd_i4,
        Q(0) => carry_rnd_i5
        );

    carrycascin_i <= CARRYCASCIN when C_HAS_CARRYCASCIN = 1 else '0';

    carryin_r5 <= carryin_i5 when op_i5(ti_opfield_carrysel) = "000" else
                  not (PCIN(PCIN'left))  when op_i5(ti_opfield_carrysel) = "001" else  -- round to infinity
                  carrycascin_i          when op_i5(ti_opfield_carrysel) = "010" else
                  (PCIN(PCIN'left))      when op_i5(ti_opfield_carrysel) = "011" else  -- round towards zero
                  p_i6(p_i6'left)        when op_i5(ti_opfield_carrysel) = "100" else  -- should be carrycascout (internal feedback for sequential accum) - never used
                  not(p_i6(p_i6'left-1)) when op_i5(ti_opfield_carrysel) = "101" else  -- round to infinity
                  carry_rnd_i5           when op_i5(ti_opfield_carrysel) = "110" else
                  p_i6(p_i6'left-1)      when op_i5(ti_opfield_carrysel) = "111" else  -- round towards zero
                  'X';  --opmode out of range, avoid latch errors
  end generate i_v5on_carryin;

  -----------------------------------------------------------------------------
  -- X, Y, Z Mux and postadder
  -----------------------------------------------------------------------------
  subtract_i <= op_i5(ci_opfield_subtract);
  pcin_i     <= PCIN when C_HAS_PCIN /= 0 else (others => '0');  -- required to avoid map errors on mux inputs being undriven
  shift_pcin <= std_logic_vector(resize(signed(pcin_i(pcin_i'left downto 17)), ci_dsp48_p_width));
  shift_preg <= std_logic_vector(resize(signed(p_i6(ci_dsp48_p_width-1 downto 17)), ci_dsp48_p_width));

  x_i5 <= (others => '0') when op_i5(ti_opfield_xmux) = "00" else
          std_logic_vector(resize(signed(m_i5), ci_dsp48_p_width))      when op_i5(ti_opfield_xmux) = "01" else
          p_i6(ci_dsp48_p_width-1 downto 0)                             when op_i5(ti_opfield_xmux) = "10" else
          std_logic_vector(resize(signed(concat_i5), ci_dsp48_p_width)) when op_i5(ti_opfield_xmux) = "11" else
          (others => 'X');
  y_i5 <= (others => '0') when op_i5(ti_opfield_ymux) = "00" else
          (others => '0')                   when op_i5(ti_opfield_ymux) = "01" else  -- only need to add the mult_result once!
          p_i6(ci_dsp48_p_width-1 downto 0) when op_i5(ti_opfield_ymux) = "10" else  -- Never used in DSP48E(1), because ALU is not supported, illegal in V4
          c_i5                              when op_i5(ti_opfield_ymux) = "11" else
          (others => 'X');
  z_i5 <= (others => '0') when op_i5(ti_opfield_zmux) = "000" else
          pcin_i                            when op_i5(ti_opfield_zmux) = "001" else
          p_i6(ci_dsp48_p_width-1 downto 0) when op_i5(ti_opfield_zmux) = "010" else
          c_i5                              when op_i5(ti_opfield_zmux) = "011" else
          shift_pcin                        when op_i5(ti_opfield_zmux) = "101" else
          shift_preg                        when op_i5(ti_opfield_zmux) = "110" else
          (others => 'X');
  p_r5 <= ('0'&z_i5) + (('0'&x_i5) + ('0'&y_i5) + carryin_r5) when subtract_i = '0' else
          ('0'&z_i5) - (('0'&x_i5) + ('0'&y_i5) + carryin_r5);

  i_p6 : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_pipe(ci_p6),
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => ci_dsp48_p_width+1
      )
    port map(
      CLK  => CLK,
      CE   => ce_i(ci_p6),
      SCLR => sclr_i(ci_p6),
      D    => p_r5,
      Q    => p_i6
      );

  i_s6_carryoutreg : if supports_dsp48a1 > 0 generate
    -- For some reason, the carryin reg's CE and SCLR control the carryout reg
    -- too, in Spartan-6 only.
    i_carryout6 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_carryout6),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_op5),
        SCLR => sclr_i(ci_op5),
        D(0) => p_r5(p_r5'left),
        Q(0) => carryout_i6
        );
  end generate i_s6_carryoutreg;
  i_other_carryoutreg : if not(supports_dsp48a1 > 0) generate
    i_carryout6 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_carryout6),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_p6),
        SCLR => sclr_i(ci_p6),
        D(0) => p_r5(p_r5'left),
        Q(0) => carryout_i6
        );
  end generate i_other_carryoutreg;

  --Only Vx5 has fabric carryout
  i_vx5_carryout : if supports_dsp48e > 0 generate
    signal carryout_r5     : std_logic;
    signal carrycascout_r5 : std_logic;
  begin
    --Need to duplicate X on CARRYOUT with multiplier is used
    --Invert for V5 when subtract, V6 produces a fabric compatible carryout
    carryout_r5 <= 'X' when op_i5(ti_opfield_xmux) = "01" and C_MODEL_TYPE = 0 else  -- when used for behavoural model for synth core to match unisim/simprim
                   '0' when op_i5(ti_opfield_xmux) = "01" and C_MODEL_TYPE = 1 else
                   not p_r5(p_i6'left) when op_i5(ci_opfield_subtract) = '1' and supports_dsp48e > 0 else
                   p_r5(p_i6'left);

    --When subtract carryout is inverted compared to normal/fabric carry chain implementation
    carrycascout_r5 <= p_r5(p_i6'left);

    i_carryout6 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_p6),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_p6),
        SCLR => sclr_i(ci_p6),
        D(0) => carryout_r5,
        Q(0) => CARRYOUT
        );

    i_carrycaseout6 : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_pipe(ci_p6),
        C_HAS_CE   => C_HAS_CE,
        C_HAS_SCLR => C_HAS_SCLR,
        C_WIDTH    => 1
        )
      port map(
        CLK  => CLK,
        CE   => ce_i(ci_p6),
        SCLR => sclr_i(ci_p6),
        D(0) => carrycascout_r5,
        Q(0) => CARRYCASCOUT
        );
  end generate i_vx5_carryout;
  i_sp3adsp_carryout : if supports_dsp48a = 1 generate
    --Bugfix note: the register of the carrycasc for sp3adsp is actually on the
    --input which differs from this description, but since it only applies when
    --dsps are cascaded, the fact that this model doesn't match the primitive
    --isn't a problem. However, the code is kept separate in case it becomes one.
    CARRYCASCOUT <= p_r5(p_r5'left);
  end generate i_sp3adsp_carryout;
  i_sp6_carryout : if supports_dsp48a1 > 0 generate
    CARRYCASCOUT <= carryout_i6;
    CARRYOUT     <= carryout_i6;
  end generate i_sp6_carryout;

  P <= p_i6(C_P_MSB downto C_P_LSB);

  PCOUT <= p_i6(ci_dsp48_p_width-1 downto 0);
end behavioral;
