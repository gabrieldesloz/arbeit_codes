-- $RCSfile: sid_v7_0_xst.vhd,v $
--
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

-------------------------------------------------------------------------------
-- Wrapper for behavioral model
-------------------------------------------------------------------------------
  
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--USE XilinxCoreLib.prims_constants_v9_0.ALL;
--library xbip_utils_v2_0;

LIBRARY XilinxCoreLib;
USE Xilinxcorelib.sid_v7_0_comp_pkg.ALL;
USE Xilinxcorelib.sid_v7_0_comp.ALL;
use Xilinxcorelib.bip_utils_pkg_v2_0.all;



-- (A)synchronous multi-input gate
--
--core_if on entity sid_v7_0_xst
  entity sid_v7_0_xst is
    generic (
      c_xdevicefamily           : string  := "virtex6"         ;  --     specifies target Xilinx FPGA family
      c_family                  : string  := "virtex6";
      c_architecture            : integer := 0;
      c_mem_init_prefix         : string  := "sid1";
      c_elaboration_dir         : string  := "./";
      c_type                    : integer := 0;
      c_mode                    : integer := 0;
      c_symbol_width            : integer := 1;
      c_row_type                : integer := 0;
      c_row_constant            : integer := 16;
      c_has_row                 : integer := 0;
      c_has_row_valid           : integer := 0;
      c_min_num_rows            : integer := 2;
      c_row_width               : integer := 4;
      c_num_selectable_rows     : integer := 4;
      c_row_select_file         : string  := "null.mif";
      c_has_row_sel             : integer := 0;
      c_has_row_sel_valid       : integer := 0;
      c_use_row_permute_file    : integer := 0;
      c_row_permute_file        : string  := "null.mif";
      c_col_type                : integer := 0;
      c_col_constant            : integer := 16;
      c_has_col                 : integer := 0;
      c_has_col_valid           : integer := 0;
      c_min_num_cols            : integer := 2;
      c_col_width               : integer := 4;
      c_num_selectable_cols     : integer := 4;
      c_col_select_file         : string  := "null.mif";
      c_has_col_sel             : integer := 0;
      c_has_col_sel_valid       : integer := 0;
      c_use_col_permute_file    : integer := 0;
      c_col_permute_file        : string  := "null.mif";
      c_block_size_type         : integer := 0;
      c_block_size_constant     : integer := 256;
      c_has_block_size          : integer := 0;
      c_block_size_width        : integer := 8;
      c_has_block_size_valid    : integer := 0;
      c_num_branches            : integer := 16;
      c_branch_length_type      : integer := 0;
      c_branch_length_constant  : integer := 1;
      c_branch_length_file      : string  := "null.mif";
      c_num_configurations      : integer := 1;
      c_external_ram            : integer := 0;
      c_ext_mem_latency         : integer := 0;
      c_ext_addr_width          : integer := 700;
      c_memstyle                : integer := 0;
      c_pipe_level              : integer := 0;
      c_throughput_mode         : integer := 0;
      c_has_aclken              : integer := 0;
      c_has_aresetn             : integer := 0;
      c_has_rdy                 : integer := 0;
      c_has_block_start         : integer := 0;
      c_has_block_end           : integer := 0;
      c_has_fdo                 : integer := 0;
      c_s_axis_ctrl_tdata_width : integer := 32;
      c_s_axis_data_tdata_width : integer := 32;
      c_m_axis_data_tdata_width : integer := 32;
      c_m_axis_data_tuser_width : integer := 32;
      c_has_dout_tready         : integer := 0
      );
    port (
      aclk                   : in  std_logic;
      aclken                 : in  std_logic                                               := '1';
      aresetn                : in  std_logic                                               := '1';
      s_axis_ctrl_tdata      : in  std_logic_vector (C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0) := (others => '0');
      s_axis_ctrl_tvalid     : in  std_logic                                               := '1';
      s_axis_ctrl_tready     : out std_logic                                               := '1';
      s_axis_data_tdata      : in  std_logic_vector (C_S_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
      s_axis_data_tvalid     : in  std_logic                                               := '1';
      s_axis_data_tlast      : in  std_logic                                               := '0';
      s_axis_data_tready     : out std_logic                                               := '1';
      m_axis_data_tdata      : out std_logic_vector (C_M_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
      m_axis_data_tuser      : out std_logic_vector (C_M_AXIS_DATA_TUSER_WIDTH-1 downto 0) := (others => '0');
      m_axis_data_tvalid     : out std_logic                                               := '1';
      m_axis_data_tlast      : out std_logic                                               := '0';
      m_axis_data_tready     : in  std_logic                                               := '1';
      rd_data                : in  std_logic_vector(c_symbol_width-1 downto 0)             := (others => '0');
      rd_en                  : out std_logic                                               := '0';
      wr_en                  : out std_logic                                               := '0';
      rd_addr                : out std_logic_vector(c_ext_addr_width-1 downto 0)           := (others => '0');
      wr_addr                : out std_logic_vector(c_ext_addr_width-1 downto 0)           := (others => '0');
      wr_data                : out std_logic_vector(c_symbol_width-1 downto 0)             := (others => '0');
      event_tlast_unexpected : out std_logic                                               := '0';
      event_tlast_missing    : out std_logic                                               := '0';
      event_halted           : out std_logic                                               := '0';
      event_row_valid        : out std_logic                                               := '0';
      event_col_valid        : out std_logic                                               := '0';
      event_row_sel_valid    : out std_logic                                               := '0';
      event_col_sel_valid    : out std_logic                                               := '0';
      event_block_size_valid : out std_logic                                               := '0'
      );
--core_if off
END sid_v7_0_xst;


ARCHITECTURE behavioral OF sid_v7_0_xst IS

BEGIN
  --core_if on instance i_behv sid_v7_0
  i_behv : sid_v7_0
    generic map (
      c_xdevicefamily           => c_xdevicefamily,
      c_family                  => c_family,
      c_architecture            => c_architecture,
      c_mem_init_prefix         => c_mem_init_prefix,
      c_elaboration_dir         => c_elaboration_dir,
      c_type                    => c_type,
      c_mode                    => c_mode,
      c_symbol_width            => c_symbol_width,
      c_row_type                => c_row_type,
      c_row_constant            => c_row_constant,
      c_has_row                 => c_has_row,
      c_has_row_valid           => c_has_row_valid,
      c_min_num_rows            => c_min_num_rows,
      c_row_width               => c_row_width,
      c_num_selectable_rows     => c_num_selectable_rows,
      c_row_select_file         => c_row_select_file,
      c_has_row_sel             => c_has_row_sel,
      c_has_row_sel_valid       => c_has_row_sel_valid,
      c_use_row_permute_file    => c_use_row_permute_file,
      c_row_permute_file        => c_row_permute_file,
      c_col_type                => c_col_type,
      c_col_constant            => c_col_constant,
      c_has_col                 => c_has_col,
      c_has_col_valid           => c_has_col_valid,
      c_min_num_cols            => c_min_num_cols,
      c_col_width               => c_col_width,
      c_num_selectable_cols     => c_num_selectable_cols,
      c_col_select_file         => c_col_select_file,
      c_has_col_sel             => c_has_col_sel,
      c_has_col_sel_valid       => c_has_col_sel_valid,
      c_use_col_permute_file    => c_use_col_permute_file,
      c_col_permute_file        => c_col_permute_file,
      c_block_size_type         => c_block_size_type,
      c_block_size_constant     => c_block_size_constant,
      c_has_block_size          => c_has_block_size,
      c_block_size_width        => c_block_size_width,
      c_has_block_size_valid    => c_has_block_size_valid,
      c_num_branches            => c_num_branches,
      c_branch_length_type      => c_branch_length_type,
      c_branch_length_constant  => c_branch_length_constant,
      c_branch_length_file      => c_branch_length_file,
      c_num_configurations      => c_num_configurations,
      c_external_ram            => c_external_ram,
      c_ext_mem_latency         => c_ext_mem_latency,
      c_ext_addr_width          => c_ext_addr_width,
      c_memstyle                => c_memstyle,
      c_pipe_level              => c_pipe_level,
      c_throughput_mode         => c_throughput_mode,
      c_has_aclken              => c_has_aclken,
      c_has_aresetn             => c_has_aresetn,
      c_has_rdy                 => c_has_rdy,
      c_has_block_start         => c_has_block_start,
      c_has_block_end           => c_has_block_end,
      c_has_fdo                 => c_has_fdo,
      c_s_axis_ctrl_tdata_width => c_s_axis_ctrl_tdata_width,
      c_s_axis_data_tdata_width => c_s_axis_data_tdata_width,
      c_m_axis_data_tdata_width => c_m_axis_data_tdata_width,
      c_m_axis_data_tuser_width => c_m_axis_data_tuser_width,
      c_has_dout_tready         => c_has_dout_tready
      )
    port map (
      aclk                   => aclk,
      aclken                 => aclken,
      aresetn                => aresetn,
      s_axis_ctrl_tdata      => s_axis_ctrl_tdata,
      s_axis_ctrl_tvalid     => s_axis_ctrl_tvalid,
      s_axis_ctrl_tready     => s_axis_ctrl_tready,
      s_axis_data_tdata      => s_axis_data_tdata,
      s_axis_data_tvalid     => s_axis_data_tvalid,
      s_axis_data_tlast      => s_axis_data_tlast,
      s_axis_data_tready     => s_axis_data_tready,
      m_axis_data_tdata      => m_axis_data_tdata,
      m_axis_data_tuser      => m_axis_data_tuser,
      m_axis_data_tvalid     => m_axis_data_tvalid,
      m_axis_data_tlast      => m_axis_data_tlast,
      m_axis_data_tready     => m_axis_data_tready,
      rd_data                => rd_data,
      rd_en                  => rd_en,
      wr_en                  => wr_en,
      rd_addr                => rd_addr,
      wr_addr                => wr_addr,
      wr_data                => wr_data,
      event_tlast_unexpected => event_tlast_unexpected,
      event_tlast_missing    => event_tlast_missing,
      event_halted           => event_halted,
      event_row_valid        => event_row_valid,
      event_col_valid        => event_col_valid,
      event_row_sel_valid    => event_row_sel_valid,
      event_col_sel_valid    => event_col_sel_valid,
      event_block_size_valid => event_block_size_valid
      );

  --core_if off
  
END behavioral;

