------------------------------------------------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/O/axi_utils_v1_1/simulation/glb_ifx_slave_v1_1.vhd,v 1.2 2011/02/03 13:13:53 drobins Exp $
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
--  Title: glb_ifx_slave_v1_1.vhd
--  Author: David Andrews
--  Date  : August 2008
--  Description: Interface-X like slave interface with SRL FIFO
--
--  Note that the aclken input *only* affects the IFX side of the interface (ifx_valid, ifx_data and ifx_ready)
--  The local interfaces run directly from the ungated aclk.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.global_util_pkg_v1_1.all;
use xilinxcorelib.axi_utils_v1_1_comps.all;

entity glb_ifx_slave_v1_1 is
  generic (
    WIDTH : positive := 8;              --Width of FIFO in bits
    DEPTH : positive := 16;             --Depth of FIFO in words
    
    HAS_UVPROT : boolean := false;  --True if FIFO has underflow protection (i.e. rd_enable to an empty FIFO is safe)
    HAS_IFX    : boolean := false;  --True if FIFO has Interface-X compatible output (note that this also sets HAS_UVPROT=true).  

    AEMPTY_THRESH0 : natural := 0;      --Almost empty deassertion threshold
    --  aempty deasserted as count goes from AEMPTY_THRESH0 to AEMPTY_THRESH0+1
    AEMPTY_THRESH1 : natural := 0       --Almost empty assertion threshold
    --  aempty asserted as count goes from AEMPTY_THRESH1 to AEMPTY_THRESH1-1
    --If AEMPTY_THRESH1 and AEMPTY_THRESH0 are both zero, aempty/not_aempty are disabled
    );
  port (
    aclk   : in std_logic;
    aclken : in std_logic := '1';  --Note that this *only* applies to the ifx_valid, ifx_ready and ifx_data ports
    areset : in std_logic; -- inverted, registered aresetn
    aresetn : in std_logic; --raw aresetn

    --Interface X slave interface
    ifx_valid : in  std_logic;          --True when master is sending data
    ifx_ready : out std_logic;          --True when slave is receiving data
    ifx_data  : in  std_logic_vector(WIDTH-1 downto 0);  --Data from master (only valied when ifx_valid and ifx_ready asserted)

    --Read interface
    rd_enable : in  std_logic;          --True to read data
    rd_avail  : out std_logic;          --True when rd_data is available
    rd_valid  : out std_logic;  --True when rd_data is available and valid (i.e. has been read)
    rd_data   : out std_logic_vector(WIDTH-1 downto 0);  --Read data (only valid when rd_avail asserted)

    --FIFO status
    full       : out std_logic;         --FIFO full
    empty      : out std_logic;         --FIFO empty
    aempty     : out std_logic;         --FIFO almost empty
    not_full   : out std_logic;  --FIFO not full (logical inverse of full)
    not_empty  : out std_logic;  --FIFO not empty (logical inverse of empty)
    not_aempty : out std_logic;  --FIFO not almost empty (logical inverse of aempty)
    add        : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
    );

end entity;

------------------------------------------------------------------------------------------------------------------------
architecture xilinx of glb_ifx_slave_v1_1 is

  signal not_afull : std_logic;
  signal mod_ready : std_logic;

  signal fifo_wr_enable_1 : std_logic                          := '0';
  signal fifo_wr_data_1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal ifx_ready_1      : std_logic                          := '0';

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
    ifx_ready <= ifx_ready_1;
  end block;

  ------------------------------------------------------------------------------------------------------------------------
  --FIFO instance (note that the afull flag thresholds are used by this instance)
  fifo0 : glb_srl_fifo_v1_1
    generic map (
      WIDTH          => WIDTH,
      DEPTH          => DEPTH,
      HAS_UVPROT     => HAS_UVPROT,
      HAS_IFX        => HAS_IFX,
      AFULL_THRESH1  => DEPTH-3,
      AFULL_THRESH0  => DEPTH-3,
      AEMPTY_THRESH1 => AEMPTY_THRESH1,
      AEMPTY_THRESH0 => AEMPTY_THRESH0
      )
    port map (
      aclk       => aclk,
      areset     => areset,
      wr_enable  => fifo_wr_enable_1,
      wr_data    => fifo_wr_data_1,
      rd_enable  => rd_enable,
      rd_avail   => rd_avail,
      rd_valid   => rd_valid,
      rd_data    => rd_data,
      full       => full,
      not_full   => not_full,
      empty      => empty,
      not_empty  => not_empty,
      afull      => open,
      not_afull  => not_afull,
      aempty     => aempty,
      not_aempty => not_aempty,
      add        => add
      );

  ------------------------------------------------------------------------------------------------------------------------
  --Slave engine
  mod_ready <= not_afull and aresetn;

  regProc : process (aclk)
  begin
    if rising_edge(aclk) then
      fifo_wr_enable_1 <= aclken and (ifx_valid and ifx_ready_1 and not areset);
      fifo_wr_data_1   <= ifx_data;
      --v1.0 code below, modified to squelch ready during reset.
--      ifx_ready_1      <= GLB_if(aclken, not_afull, ifx_ready_1);
      if areset = '1' then
        ifx_ready_1 <= '0';
      elsif aclken = '1' then
        ifx_ready_1 <= mod_ready;
      end if;
    end if;
  end process;

end architecture;
