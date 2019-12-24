-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 2.0
--  \   \        Filename: $RCSfile: lte_3gpp_mimo_decoder_v2_1_comp.vhd,v $
--  /   /        Date Last Modified: $Date: 2011/03/15 17:04:59 $
-- /___/   /\    Date Created: 2009
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : example_v2_0
-- Purpose : Component statement for behavioral model
-------------------------------------------------------------------------------
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

library ieee;
use ieee.std_logic_1164.all;

package lte_3gpp_mimo_decoder_v2_1_comp is

  --core_if on component lte_3gpp_mimo_decoder_v2_1
  component lte_3gpp_mimo_decoder_v2_1
    generic (
      c_elaboration_dir         :     string  := "./";
      c_family                  :     string  := "virtex6";
      c_xdevicefamily           :     string  := "virtex6";
      ntmax                     :     integer := 4;
      wmatrix                   :     integer := 1;
      memory_type               :     integer := 2
      );
    port (
      s_axis_ctrl_tdata_groupsc : in  std_logic;
      s_axis_ctrl_tdata_sthresh : in  std_logic_vector(7 downto 0);
      s_axis_ctrl_tvalid        : in  std_logic;
      s_axis_ctrl_tready        : out std_logic;
      s_axis_sigma_tdata        : in  std_logic_vector(15 downto 0);
      s_axis_sigma_tvalid       : in  std_logic;
      s_axis_sigma_tlast        : in  std_logic;
      s_axis_sigma_tready       : out std_logic;
      s_axis_y_tuser_size       : in  std_logic_vector(7 downto 0);
      s_axis_y_tdata_i          : in  std_logic_vector(15 downto 0);
      s_axis_y_tdata_q          : in  std_logic_vector(15 downto 0);
      s_axis_y_tvalid           : in  std_logic;
      s_axis_y_tlast            : in  std_logic;
      s_axis_y_tready           : out std_logic;
      s_axis_hx_tuser_size      : in  std_logic_vector(7 downto 0);
      s_axis_hx_tdata_i1        : in  std_logic_vector(15 downto 0);
      s_axis_hx_tdata_q1        : in  std_logic_vector(15 downto 0);
      s_axis_hx_tdata_i2        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tdata_q2        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tdata_i3        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tdata_q3        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tdata_i4        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tdata_q4        : in  std_logic_vector(15 downto 0) := (others => '0');
      s_axis_hx_tvalid          : in  std_logic;
      s_axis_hx_tlast           : in  std_logic;
      s_axis_hx_tready          : out std_logic;
      aclk                      : in  std_logic;
      aclken                    : in  std_logic;
      aresetn                   : in  std_logic;
      m_axis_xest_tuser_sflag   : out std_logic;
      m_axis_xest_tuser_size    : out std_logic_vector(7 downto 0);
      m_axis_xest_tdata_i       : out std_logic_vector(31 downto 0);
      m_axis_xest_tdata_q       : out std_logic_vector(31 downto 0);
      m_axis_xest_tvalid        : out std_logic;
      m_axis_xest_tlast         : out std_logic;
      m_axis_xest_tready        : in  std_logic;
      m_axis_wx_tuser_sflag     : out std_logic := '0';
      m_axis_wx_tuser_size      : out std_logic_vector(7 downto 0) := (others => '0');
      m_axis_wx_tdata_i1        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_q1        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_i2        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_q2        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_i3        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_q3        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_i4        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tdata_q4        : out std_logic_vector(31 downto 0) := (others => '0');
      m_axis_wx_tvalid          : out std_logic := '0';
      m_axis_wx_tlast           : out std_logic := '0';
      m_axis_wx_tready          : in  std_logic := '1'
      );
  --core_if off
  end component;
  -- the following tells xst that lte_3gpp_mimo_decoder_v2_1 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core

  -- xcc exclude
  ATTRIBUTE box_type : STRING;
  ATTRIBUTE generator_default : STRING;
  ATTRIBUTE box_type OF lte_3gpp_mimo_decoder_v2_1 : COMPONENT IS "black_box";
  ATTRIBUTE generator_default OF lte_3gpp_mimo_decoder_v2_1 : COMPONENT IS
    "generatecore com.xilinx.ip.lte_3gpp_mimo_decoder_v2_1.lte_3gpp_mimo_decoder_v2_1";
  -- xcc include

END lte_3gpp_mimo_decoder_v2_1_comp;
