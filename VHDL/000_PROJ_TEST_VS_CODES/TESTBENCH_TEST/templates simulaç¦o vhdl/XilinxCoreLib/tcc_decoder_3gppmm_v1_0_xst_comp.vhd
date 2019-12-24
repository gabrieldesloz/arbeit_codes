------------------------------------------------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/L/tcc_decoder_3gppmm_v1_0/simulation/tcc_decoder_3gppmm_v1_0_xst_comp.vhd,v 1.3 2009/09/08 16:13:40 akennedy Exp $
------------------------------------------------------------------------------------------------------------------------
--
--  (c) Copyright 2009, 2012 Xilinx, Inc. All rights reserved.
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
-------------------------------------------------------------------------------
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package tcc_decoder_3gppmm_v1_0_xst_comp is

----------------------------------------------------------
-- insert component declaration of top level xst file here
----------------------------------------------------------
	--core_if on entity tcc_decoder_3gppmm_v1_0_xst
	component tcc_decoder_3gppmm_v1_0_xst
	generic (
		C_XDEVICEFAMILY:                    string:="no_family";
		C_ELABORATION_DIR:                  string:="./";
		C_COMPONENT_NAME:                   string:="tcc_decoder_3gppmm_v1_0";
		--AXI Parameters
		C_S_AXIS_CTRL_TDATA_WIDTH:          integer:=32;
		C_S_AXIS_DATA_TDATA_WIDTH:          integer:=24;
		C_M_AXIS_DEBUG_TDATA_WIDTH:         integer:=32;
		C_M_AXIS_HSTAT_TDATA_WIDTH:         integer:=32;
		C_M_AXIS_HDATA_TDATA_WIDTH:         integer:=8;
		--Core Parameters
		C_NUM_DU:                           integer:=1;
		C_STANDARD_TYPE:                    integer:=3;
		C_ALGORITHM_TYPE:                   integer:=0;
		C_TAG_WIDTH:                        integer:=0;
		C_STATE_INT_WIDTH:                  integer:=9;
		C_STATE_FRAC_WIDTH:                 integer:=3;
		C_SOFT_INT_WIDTH:                   integer:=5;
		C_SOFT_FRAC_WIDTH:                  integer:=3;
		C_NUM_PAR_HARD_WORDS:               integer:=1;
		C_NUM_DSP:                          integer:=0;
		C_OPT_GOAL:                         integer:=1
	);
	port (
		aclk:                           in  std_logic;
		aresetn:                        in  std_logic;

		s_axis_ctrl_tvalid:             in  std_logic;
		s_axis_ctrl_tready:             out std_logic;
		s_axis_ctrl_tdata:              in  std_logic_vector(C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0);
		event_block_pending:            out std_logic;

		s_axis_data_tvalid:             in  std_logic;
		s_axis_data_tready:             out std_logic;
		s_axis_data_tlast:              in  std_logic;
		s_axis_data_tdata:              in  std_logic_vector(C_S_AXIS_DATA_TDATA_WIDTH-1 downto 0);
		event_data_tlast_missing:       out std_logic;
		event_data_tlast_unexpected:    out std_logic;

		m_axis_debug_tvalid:            out std_logic;
		m_axis_debug_tready:            in  std_logic;
		m_axis_debug_tdata:             out std_logic_vector(C_M_AXIS_DEBUG_TDATA_WIDTH-1 downto 0);

		m_axis_hstat_tvalid:            out std_logic;
		m_axis_hstat_tready:            in  std_logic;
		m_axis_hstat_tdata:             out std_logic_vector(C_M_AXIS_HSTAT_TDATA_WIDTH-1 downto 0);

		m_axis_hdata_tvalid:            out std_logic;
		m_axis_hdata_tready:            in  std_logic;
		m_axis_hdata_tlast:             out std_logic;
		m_axis_hdata_tdata:             out std_logic_vector(C_M_AXIS_HDATA_TDATA_WIDTH-1 downto 0)
	);
--core_if off
  end component;


end tcc_decoder_3gppmm_v1_0_xst_comp;


package body tcc_decoder_3gppmm_v1_0_xst_comp is

end package body tcc_decoder_3gppmm_v1_0_xst_comp;
