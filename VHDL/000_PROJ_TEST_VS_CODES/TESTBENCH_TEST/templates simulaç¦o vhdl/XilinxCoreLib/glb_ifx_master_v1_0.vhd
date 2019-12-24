------------------------------------------------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/M/axi_utils_v1_0/simulation/glb_ifx_master_v1_0.vhd,v 1.3 2010/09/08 11:10:17 andreww Exp $
------------------------------------------------------------------------------------------------------------------------
--
--  (c) Copyright 2009 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------------------------------------------------------
--
--  Title: glb_ifx_master_v1_0.vhd
--  Author: David Andrews
--  Date  : August 2008
--  Description: Interface-X like master interface with SRL FIFO
--
--  Note that the aclken input *only* affects the IFX side of the interface (ifx_valid, ifx_data and ifx_ready)
--  The local interfaces run directly from the ungated aclk.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.global_util_pkg_v1_0.all;
use xilinxcorelib.axi_utils_v1_0_comps.all;

entity glb_ifx_master_v1_0 is

  generic (
    WIDTH : positive := 32;             --Width of FIFO in bits
    DEPTH : positive := 16;             --Depth of FIFO in words

    AFULL_THRESH1 : natural := 0;       --Almost full assertion threshold
    --  afull asserted as count goes from AFULL_THRESH1 to AFULL_THRESH1+1
    AFULL_THRESH0 : natural := 0        --Almost full deassertion threshold
    --  afull deasserted as count goes from AFULL_THRESH0 to AFULL_THRESH0-1
    --If AFULL_THRESH1 and AFULL_THRESH0 are both zero, afull/not_afull are disabled
    );
  port (
    aclk   : in std_logic;
    aclken : in std_logic := '1';  --Note that this *only* applies to the ifx_valid, ifx_ready and ifx_data ports
    areset : in std_logic;

    --Write interface
    wr_enable : in std_logic;                           --True to write data
    wr_data   : in std_logic_vector(WIDTH-1 downto 0);  --Write data

    --Interface X master interface
    ifx_valid : out std_logic;          --True when master is sending data
    ifx_ready : in  std_logic;          --True when slave is receiving data
    ifx_data  : out std_logic_vector(WIDTH-1 downto 0);  --Data from master (only valied when ifx_valid and ifx_ready asserted)

    --FIFO status
    full      : out std_logic;          --FIFO full
    afull     : out std_logic;          --FIFO almost full
    not_full  : out std_logic;  --FIFO not full (logical inverse of full)
    not_afull : out std_logic;  --FIFO not almost full (logical inverse of afull)
    add       : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
    );

end entity;

------------------------------------------------------------------------------------------------------------------------
architecture xilinx of glb_ifx_master_v1_0 is

  signal fifo_rd_enable : std_logic;
  signal fifo_rd_valid  : std_logic;
  signal fifo_rd_data   : std_logic_vector(WIDTH-1 downto 0);

  ------------------------------------------------------------------------------------------------------------------------
  --Keep hierarchy around this entity
  attribute keep_hierarchy of xilinx : architecture is "soft";

begin

  ------------------------------------------------------------------------------------------------------------------------
  assumptions : block
  begin
    assert DEPTH >= 4
      report "ERROR:DEPTH must be >=4"
      severity failure;
  end block;

  ------------------------------------------------------------------------------------------------------------------------
  io : block
  begin
    ifx_valid      <= fifo_rd_valid;
    ifx_data       <= fifo_rd_data;
    fifo_rd_enable <= aclken and (not fifo_rd_valid or ifx_ready);
  end block;

  ------------------------------------------------------------------------------------------------------------------------
  --FIFO instance
  fifo0 : glb_srl_fifo_v1_0
    generic map (
      WIDTH         => WIDTH, DEPTH => DEPTH, HAS_UVPROT => true, HAS_IFX => true,
      AFULL_THRESH1 => AFULL_THRESH1, AFULL_THRESH0 => AFULL_THRESH0,
      HAS_HIERARCHY => false  --Don't keep the hierarchy so that gates at this level can be absorbed into FIFO
      )
    port map (
      aclk      => aclk, areset => areset,
      wr_enable => wr_enable, wr_data => wr_data,
      rd_enable => fifo_rd_enable, rd_avail => open, rd_valid => fifo_rd_valid, rd_data => fifo_rd_data,
      full      => full, not_full => not_full,
      empty     => open, not_empty => open,
      afull     => afull, not_afull => not_afull,
      aempty    => open, not_aempty => open,
      add       => add
      );

end architecture;
