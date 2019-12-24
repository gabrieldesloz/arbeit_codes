--------------------------------------------------------------------------------
--  (c) Copyright 1995-2010 Xilinx, Inc. All rights reserved.
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
--------------------------------------------------------------------------------
--
-- Behavorial simulation model for parallel Reed-Solomon encoder
-- This model is only for other cores that instantiate the RS Encoder. These
-- will instantiate the g709_rs_encoder_v1_0_xst entity. This file is provided
-- for behavioral simulation of that entity. It is in fact a simple wrapper
-- for the g709_rs_encoder_v1_0 behavioral model.
--
-- $RCSfile: g709_rs_encoder_v1_0_xst.vhd,v $ $Revision: 1.3 $ $Date: 2011/05/23 10:17:45 $
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.g709_rs_encoder_v1_0_consts.all;
use xilinxcorelib.g709_rs_encoder_v1_0_comp.all;

--core_if on entity g709_rs_encoder_v1_0_xst
  entity g709_rs_encoder_v1_0_xst is
  GENERIC (
    c_family          : STRING  := c_family_default;
    c_xdevicefamily   : STRING  := c_xdevicefamily_default;
    c_has_ce          : INTEGER := c_ce_default;
    c_has_sclr        : INTEGER := c_sclr_default;
    c_mem_init_prefix : STRING  := c_mem_init_prefix_default;
    c_elaboration_dir : STRING  := c_elaboration_dir_default;
    c_memstyle        : INTEGER := c_memstyle_default;

    c_num_channels_sp : integer := 1;
    c_num_channels_ti : integer := 1;
    c_channel_width   : integer := 1
  );
  PORT (
    aresetn            : IN  STD_LOGIC := '0';
    aclken             : IN  STD_LOGIC := '1';
    aclk               : IN  STD_LOGIC;

    s_axis_input_tdata    : IN  STD_LOGIC_VECTOR(c_channel_width*c_num_channels_sp*8 - 1 DOWNTO 0);
    s_axis_input_tlast    : IN  STD_LOGIC;
    s_axis_input_tvalid   : IN  STD_LOGIC;
    s_axis_input_tready   : out  STD_LOGIC;

    m_axis_output_tdata    : OUT  STD_LOGIC_VECTOR(c_channel_width*c_num_channels_sp*8 - 1 DOWNTO 0);
    m_axis_output_tlast    : OUT  STD_LOGIC;
    m_axis_output_tvalid   : OUT  STD_LOGIC;
    m_axis_output_tready   : in  STD_LOGIC
  );
--core_if off
end g709_rs_encoder_v1_0_xst;

architecture behavioral of g709_rs_encoder_v1_0_xst is
begin

  -- Instantiate the true behavioral model top level
  enc : g709_rs_encoder_v1_0
    generic map (
      c_family          => c_family,
      c_xdevicefamily   => c_xdevicefamily,
      c_has_ce          => c_has_ce,
      c_mem_init_prefix => c_mem_init_prefix,
      c_elaboration_dir => c_elaboration_dir,
      c_memstyle        => c_memstyle,
      c_num_channels_sp => c_num_channels_sp,
      c_num_channels_ti => c_num_channels_ti,
      c_channel_width   => c_channel_width
      )
    port map (
    aresetn              =>aresetn,
    aclken               =>aclken,
    aclk                 =>aclk,

    s_axis_input_tdata   =>s_axis_input_tdata,
    s_axis_input_tlast   =>s_axis_input_tlast,
    s_axis_input_tvalid  =>s_axis_input_tvalid,
    s_axis_input_tready  =>s_axis_input_tready,

    m_axis_output_tdata  =>m_axis_output_tdata,
    m_axis_output_tlast  =>m_axis_output_tlast,
    m_axis_output_tvalid =>m_axis_output_tvalid,
    m_axis_output_tready =>m_axis_output_tready

      );

end behavioral;

