-------------------------------------------------------------------------------
--  (c) Copyright 2002-2010, 2012 Xilinx, Inc. All rights reserved.
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
--
--------------------------------------------------------------------------------
-- Package that provides the component definitions
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.rs_encoder_v8_0_consts.all;

package rs_encoder_v8_0_pkg is

  component rs_encoder_v8_0_legacy
    generic (
      C_EVALUATION      : integer := 0;
      C_FAMILY          : string  := "no_family";
      C_XDEVICEFAMILY   : string  := "no_family";
      C_HAS_CE          : integer := c_has_aclken_default;
      C_HAS_N_IN        : integer := c_has_n_in_default;
      C_HAS_ND          : integer := 1;
      C_HAS_R_IN        : integer := c_has_r_in_default;
      C_HAS_RDY         : integer := 1;
      C_HAS_RFD         : integer := 1;
      C_HAS_RFFD        : integer := 1;
      C_HAS_SCLR        : integer := c_has_aresetn_default;
      C_MEM_INIT_PREFIX : string  := c_mem_init_prefix_default;
      C_ELABORATION_DIR : string  := c_elaboration_dir_default;
      C_SPEC            : integer := c_spec_default;
      C_GEN_POLY_TYPE   : integer := c_gen_poly_type_default;
      C_GEN_START       : integer := c_gen_start_default;
      C_H               : integer := c_h_default;
      C_K               : integer := c_k_default;
      C_N               : integer := c_n_default;
      C_POLYNOMIAL      : integer := c_polynomial_default;
      C_NUM_CHANNELS    : integer := c_num_channels_default;
      C_SYMBOL_WIDTH    : integer := c_symbol_width_default;
      C_MEMSTYLE        : integer := c_memstyle_default

      );
    port (
      data_in         : in  std_logic_vector(C_SYMBOL_WIDTH - 1 downto 0)         := (others => '0');
      n_in            : in  std_logic_vector(C_SYMBOL_WIDTH - 1 downto 0)         := (others => '1');
      r_in            : in  std_logic_vector(integer_width(C_N-C_K) - 1 downto 0) := (others => '1');
      start           : in  std_logic                                             := '0';
      bypass          : in  std_logic                                             := '0';
      nd              : in  std_logic                                             := '1';
      sclr            : in  std_logic                                             := '0';
      in_tlast        : in  std_logic                                             := '0';
      data_out        : out std_logic_vector(C_SYMBOL_WIDTH - 1 downto 0);
      info            : out std_logic                                             := '0';
      rdy             : out std_logic                                             := '0';
      rfd             : out std_logic                                             := '0';
      rfd_din         : out std_logic                                             := '0';
      rffd            : out std_logic                                             := '0';
      rffd_din        : out std_logic                                             := '0';
      last_data       : out std_logic                                             := '0';
      last_data_tlast : out std_logic                                             := '0';
      event_s_input_tlast_missing    : out std_logic := '0';
      event_s_input_tlast_unexpected : out std_logic := '0';
      event_s_ctrl_tdata_invalid     : out std_logic := '0';
      ce              : in  std_logic                                             := '1';
      clk             : in  std_logic                                             := '0'
      );
  end component rs_encoder_v8_0_legacy;

  function get_latency(num_channels : integer;
                       spec         : integer) return integer;
end rs_encoder_v8_0_pkg;


package body rs_encoder_v8_0_pkg is
-----------------------------------------------------------------------------
-- Get latency function
-- Latency is defined as number of rising clock edges from sampling DATA_IN
-- to outputting on DATA_OUT.
-- Used by GUI so place in this package that will be processed by XCC.
-----------------------------------------------------------------------------

  ------------------------------------------------------
  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  -- HAZARD. THIS CODE IS CLONED FROM THE HDL DIRECTORY
  -- IT MUST BE MAINTAINED IN SYNC WITH THAT CODE.
  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ------------------------------------------------------
  function get_latency(num_channels : integer;
                       spec         : integer) return integer is
    variable latency                : integer;
  begin
    latency := 2 + num_channels;

    if spec = ccsds_spec then           -- CCSDS standard
      latency := latency + 2;
    elsif spec = j83_b_spec then
      latency := latency + 1;
    end if;

    assert false
      report " Reed-Solomon Encoder : latency = " & integer'image(latency)
      severity note;

    return latency;
  end get_latency;

end rs_encoder_v8_0_pkg;

