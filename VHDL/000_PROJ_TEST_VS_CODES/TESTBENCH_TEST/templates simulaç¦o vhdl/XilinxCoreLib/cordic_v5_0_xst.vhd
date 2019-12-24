-------------------------------------------------------------------------------
-- $Id: cordic_v5_0_xst.vhd,v 1.5 2011/06/15 09:51:28 gordono Exp $
-------------------------------------------------------------------------------
--  (c) Copyright 2006-2008, 2011 Xilinx, Inc. All rights reserved.
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
-- Function :  Top level of CORDIC Module 
--------------------------------------------------------------------------------
-- In this version, the previous top level cordic_v4_0_xst has become
-- xilinxcorelib_synth. This file, xilinxcorelib_xst is now a wrapper for the old
-- core so as to contain and map the new AXI4-Stream interfaces to the legacy
-- pins. See spec/xilinxcorelib_axi_proposal.docx for a full description
-- of the AXI4 Stream interface channels, fields, subfields and behaviours.
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.cordic_v5_0_comp.all;

--core_if on entity cordic_v5_0_xst
  entity cordic_v5_0_xst is
  generic (
    c_architecture                 : integer := 1;
    c_cordic_function              : integer := 0;
    c_coarse_rotate                : integer := 1;
    c_data_format                  : integer := 0;
    c_xdevicefamily                : string  := "virtex6";
    c_has_aclken                   : integer := 0;
    c_has_aclk                     : integer := 1;
    c_has_s_axis_cartesian         : integer := 1;
    c_has_s_axis_phase             : integer := 1;
    c_has_aresetn                  : integer := 0;
    c_input_width                  : integer := 32;
    c_iterations                   : integer := 32;
    c_output_width                 : integer := 32;
    c_phase_format                 : integer := 0;
    c_pipeline_mode                : integer := -2;
    c_precision                    : integer := 0;
    c_round_mode                   : integer := 2;
    c_scale_comp                   : integer := 0;
    c_throttle_scheme              : integer := 0;
    c_tlast_resolution             : integer := 0;
    c_has_s_axis_phase_tuser       : integer := 0;
    c_has_s_axis_phase_tlast       : integer := 0;
    c_s_axis_phase_tdata_width     : integer := 32;
    c_s_axis_phase_tuser_width     : integer := 1;
    c_has_s_axis_cartesian_tuser   : integer := 0;
    c_has_s_axis_cartesian_tlast   : integer := 0;
    c_s_axis_cartesian_tdata_width : integer := 64;
    c_s_axis_cartesian_tuser_width : integer := 1;
    c_m_axis_dout_tdata_width      : integer := 64;
    c_m_axis_dout_tuser_width      : integer := 1
    );
  port (
    aclk                           : in  std_logic                                                     := '1';
    aclken                         : in  std_logic                                                     := '1';
    aresetn                        : in  std_logic                                                     := '1';
    s_axis_phase_tvalid            : in  std_logic                                                     := '0';
    s_axis_phase_tready            : out std_logic                                                     := '0';
    s_axis_phase_tuser             : in  std_logic_vector(c_s_axis_phase_tuser_width - 1 downto 0)     := ( others => '0' );
    s_axis_phase_tlast             : in  std_logic                                                     := '0';
    s_axis_phase_tdata             : in  std_logic_vector(c_s_axis_phase_tdata_width - 1 downto 0)     := ( others => '0' );
    s_axis_cartesian_tvalid        : in  std_logic                                                     := '0';
    s_axis_cartesian_tready        : out std_logic                                                     := '0';
    s_axis_cartesian_tuser         : in  std_logic_vector(c_s_axis_cartesian_tuser_width - 1 downto 0) := ( others => '0' );
    s_axis_cartesian_tlast         : in  std_logic                                                     := '0';
    s_axis_cartesian_tdata         : in  std_logic_vector(c_s_axis_cartesian_tdata_width - 1 downto 0) := ( others => '0' );
    m_axis_dout_tvalid             : out std_logic                                                     := '0';
    m_axis_dout_tready             : in  std_logic                                                     := '0';
    m_axis_dout_tuser              : out std_logic_vector(c_m_axis_dout_tuser_width - 1 downto 0)      := ( others => '0' );
    m_axis_dout_tlast              : out std_logic                                                     := '0';
    m_axis_dout_tdata              : out std_logic_vector(c_m_axis_dout_tdata_width - 1 downto 0)      := ( others =>'0' )
    );
--core_if off
end cordic_v5_0_xst;

architecture behv of cordic_v5_0_xst is

begin
  -----------------------------------------------------------------------------
  -- The core itself
  -----------------------------------------------------------------------------
  --core_if on instance i_behv cordic_v5_0
  i_behv : cordic_v5_0
    generic map (
      c_architecture                 => c_architecture,
      c_cordic_function              => c_cordic_function,
      c_coarse_rotate                => c_coarse_rotate,
      c_data_format                  => c_data_format,
      c_xdevicefamily                => c_xdevicefamily,
      c_has_aclken                   => c_has_aclken,
      c_has_aclk                     => c_has_aclk,
      c_has_s_axis_cartesian         => c_has_s_axis_cartesian,
      c_has_s_axis_phase             => c_has_s_axis_phase,
      c_has_aresetn                  => c_has_aresetn,
      c_input_width                  => c_input_width,
      c_iterations                   => c_iterations,
      c_output_width                 => c_output_width,
      c_phase_format                 => c_phase_format,
      c_pipeline_mode                => c_pipeline_mode,
      c_precision                    => c_precision,
      c_round_mode                   => c_round_mode,
      c_scale_comp                   => c_scale_comp,
      c_throttle_scheme              => c_throttle_scheme,
      c_tlast_resolution             => c_tlast_resolution,
      c_has_s_axis_phase_tuser       => c_has_s_axis_phase_tuser,
      c_has_s_axis_phase_tlast       => c_has_s_axis_phase_tlast,
      c_s_axis_phase_tdata_width     => c_s_axis_phase_tdata_width,
      c_s_axis_phase_tuser_width     => c_s_axis_phase_tuser_width,
      c_has_s_axis_cartesian_tuser   => c_has_s_axis_cartesian_tuser,
      c_has_s_axis_cartesian_tlast   => c_has_s_axis_cartesian_tlast,
      c_s_axis_cartesian_tdata_width => c_s_axis_cartesian_tdata_width,
      c_s_axis_cartesian_tuser_width => c_s_axis_cartesian_tuser_width,
      c_m_axis_dout_tdata_width      => c_m_axis_dout_tdata_width,
      c_m_axis_dout_tuser_width      => c_m_axis_dout_tuser_width
      )
    port map (
      aclk                    => aclk,
      aclken                  => aclken,
      aresetn                 => aresetn,
      s_axis_phase_tvalid     => s_axis_phase_tvalid,
      s_axis_phase_tready     => s_axis_phase_tready,
      s_axis_phase_tuser      => s_axis_phase_tuser,
      s_axis_phase_tlast      => s_axis_phase_tlast,
      s_axis_phase_tdata      => s_axis_phase_tdata,
      s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
      s_axis_cartesian_tready => s_axis_cartesian_tready,
      s_axis_cartesian_tuser  => s_axis_cartesian_tuser,
      s_axis_cartesian_tlast  => s_axis_cartesian_tlast,
      s_axis_cartesian_tdata  => s_axis_cartesian_tdata,
      m_axis_dout_tvalid      => m_axis_dout_tvalid,
      m_axis_dout_tready      => m_axis_dout_tready,
      m_axis_dout_tuser       => m_axis_dout_tuser,
      m_axis_dout_tlast       => m_axis_dout_tlast,
      m_axis_dout_tdata       => m_axis_dout_tdata
      );

--core_if off
end behv;
  
