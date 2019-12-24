-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 4.0
--  \   \        Filename: $RCSfile: dds_compiler_v4_0_sim_comps.vhd,v $
--  /   /        Date Last Modified: $Date: 2010/03/19 10:54:09 $
-- /___/   /\    Date Created: 2006
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : dds_compiler_v4_0
-- Purpose : Simulation component declarations
-------------------------------------------------------------------------------
--  (c) Copyright 2006-2009 Xilinx, Inc. All rights reserved.
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
library std, ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.pkg_dds_compiler_v4_0.all;

package dds_compiler_v4_0_sim_comps IS

  component dds_compiler_v4_0_eff
    generic (
      C_XDEVICEFAMILY     : string;
      C_MODEL_TYPE        : integer := 0;          -- 0 = synth, 1 = RTL
      C_ACCUMULATOR_WIDTH : integer;
      CI_PIPE             : t_pipe_top;
      C_HAS_CE            : integer;
      C_OUTPUT_WIDTH      : integer;
      C_OPTIMISE_GOAL     : integer;
      CI_RAM_DATA_WIDTH   : integer;
      CI_RAM_ADDR_WIDTH   : integer;
      C_NEGATIVE_SINE     : integer;
      C_NEGATIVE_COSINE   : integer
      );
    port (
      clk              : in std_logic;
      ce_i             : in std_logic;
      mute_i           : in std_logic;
      sin_x            : in std_logic_vector(ci_ram_data_width-1 downto 0);
      cos_x            : in std_logic_vector(ci_ram_data_width-1 downto 0);
      acc_phase_to_lut : in std_logic_vector(C_ACCUMULATOR_WIDTH -1 downto 0);
      pre_final_sin    : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);
      pre_final_cos    : out std_logic_vector(C_OUTPUT_WIDTH-1 downto 0)
      );
  end component;

  component dds_compiler_v4_0_multadd_wrapper
    generic (
      --BaseIP modelling generics
      C_VERBOSITY     : integer := 0;  --0 = Errors 1 = +Warnings, 2 = +Notes and tips
      C_MODEL_TYPE    : integer := 0;   --0 = synth, 1 = RTL
      --BaseIP common generics
      C_XDEVICEFAMILY : string  := "virtex4";
      C_LATENCY       : integer := -1
      );
    port (
      CLK      : in  std_logic                                                      := '1';
      CE       : in  std_logic                                                      := '1';
      SCLR     : in  std_logic                                                      := '0';
      SUBTRACT : in  std_logic                                                      := '0';
      A        : in  std_logic_vector(fn_dsp48_a_width(C_XDEVICEFAMILY)-1 downto 0) := (others => '0');
      B        : in  std_logic_vector(ci_dsp48_b_width-1 downto 0)                  := (others => '0');
      C        : in  std_logic_vector(ci_dsp48_c_width-1 downto 0)                  := (others => '0');
      P        : out std_logic_vector(ci_dsp48_p_width-1 downto 0)                  := (others => '0')
      );
  end component;
  
  component dds_compiler_v4_0_eff_lut is
   generic (
      C_XDEVICEFAMILY   : string  := "virtex4";
      C_LATENCY         : integer := -1;
      C_MODEL_TYPE      : integer := 0          -- 0 = synth, 1 = RTL
      );
    port (
      CLK          : in  std_logic := '1';
      CE           : in  std_logic := '1';
      SCLR         : in  std_logic := '0';
      A            : in  std_logic_vector(9 downto 0) := (others => '0');
      D            : out std_logic_vector(17 downto 0) := (others => '0')
      );
  end component;

end package dds_compiler_v4_0_sim_comps;


