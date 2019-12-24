-- $Id: axi_utils_v1_0_comps.vhd,v 1.5 2010/11/03 15:38:11 andreww Exp $
-------------------------------------------------------------------------------
--  (c) Copyright 2010 Xilinx, Inc. All rights reserved.
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
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.global_util_pkg_v1_0.all;

package axi_utils_v1_0_comps is

  component axi_utils_v1_0_skid_buffer
    generic (
      c_has_ce    : integer := 0;
      c_has_reset : integer := 0;
      c_width     : integer := 6
      );
    port (
      aclk      : in  std_logic                             := '0';
      ce        : in  std_logic                             := '0';
      areset    : in  std_logic                             := '0';
      rfd       : out std_logic                             := '0';
      din       : in  std_logic_vector(c_width -1 downto 0) := (others => '0');
      valid_in  : in  std_logic                             := '0';
      cts       : in  std_logic                             := '0';
      dout      : out std_logic_vector(c_width -1 downto 0) := (others => '0');
      valid_out : out std_logic                             := '0'
      );
  end component;

  component axi_fifo is
    generic(
      c_width           : integer;
      c_depth_w         : integer;
      c_reg             : integer;
      c_mem_type        : integer;
      c_family          : string;
      c_xdevicefamily   : string;
      c_elaboration_dir : string
      );
    port (
      aclk   : in  std_logic;
      din    : in  std_logic_vector(c_width-1 downto 0);
      rd_en  : in  std_logic;
      areset : in  std_logic;
      wr_en  : in  std_logic;
      dout   : out std_logic_vector(c_width-1 downto 0);
      empty  : out std_logic;
      full   : out std_logic;
      valid  : out std_logic);
  end component;

  component glb_ifx_master_v1_0 is

    generic (
      WIDTH : positive := 32;           --Width of FIFO in bits
      DEPTH : positive := 16;           --Depth of FIFO in words

      AFULL_THRESH1 : natural := 0;     --Almost full assertion threshold
      --  afull asserted as count goes from AFULL_THRESH1 to AFULL_THRESH1+1
      AFULL_THRESH0 : natural := 0      --Almost full deassertion threshold
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
      ifx_valid : out std_logic;        --True when master is sending data
      ifx_ready : in  std_logic;        --True when slave is receiving data
      ifx_data  : out std_logic_vector(WIDTH-1 downto 0);  --Data from master (only valied when ifx_valid and ifx_ready asserted)

      --FIFO status
      full      : out std_logic;        --FIFO full
      afull     : out std_logic;        --FIFO almost full
      not_full  : out std_logic;  --FIFO not full (logical inverse of full)
      not_afull : out std_logic;  --FIFO not almost full (logical inverse of afull)
      add       : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
      );
  end component;

  component glb_ifx_slave_v1_0 is
    generic (
      WIDTH : positive := 8;            --Width of FIFO in bits
      DEPTH : positive := 16;           --Depth of FIFO in words

      HAS_UVPROT : boolean := false;  --True if FIFO has underflow protection (i.e. rd_enable to an empty FIFO is safe)
      HAS_IFX    : boolean := false;  --True if FIFO has Interface-X compatible output (note that this also sets HAS_UVPROT=true).

      AEMPTY_THRESH0 : natural := 0;    --Almost empty deassertion threshold
      --  aempty deasserted as count goes from AEMPTY_THRESH0 to AEMPTY_THRESH0+1
      AEMPTY_THRESH1 : natural := 0     --Almost empty assertion threshold
      --  aempty asserted as count goes from AEMPTY_THRESH1 to AEMPTY_THRESH1-1
      --If AEMPTY_THRESH1 and AEMPTY_THRESH0 are both zero, aempty/not_aempty are disabled
      );
    port (
      aclk   : in std_logic;
      aclken : in std_logic := '1';  --Note that this *only* applies to the ifx_valid, ifx_ready and ifx_data ports
      areset : in std_logic;

      --Interface X slave interface
      ifx_valid : in  std_logic;        --True when master is sending data
      ifx_ready : out std_logic;        --True when slave is receiving data
      ifx_data  : in  std_logic_vector(WIDTH-1 downto 0);  --Data from master (only valied when ifx_valid and ifx_ready asserted)

      --Read interface
      rd_enable : in  std_logic;        --True to read data
      rd_avail  : out std_logic;        --True when rd_data is available
      rd_valid  : out std_logic;  --True when rd_data is available and valid (i.e. has been read)
      rd_data   : out std_logic_vector(WIDTH-1 downto 0);  --Read data (only valid when rd_avail asserted)

      --FIFO status
      full       : out std_logic;       --FIFO full
      empty      : out std_logic;       --FIFO empty
      aempty     : out std_logic;       --FIFO almost empty
      not_full   : out std_logic;  --FIFO not full (logical inverse of full)
      not_empty  : out std_logic;  --FIFO not empty (logical inverse of empty)
      not_aempty : out std_logic;  --FIFO not almost empty (logical inverse of aempty)
      add        : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
      );
  end component;

  component glb_srl_fifo_v1_0 is

    generic (
      WIDTH : positive := 32;           --Width of FIFO in bits
      DEPTH : positive := 16;  --Depth of FIFO in words (must be a power of 2)

      HAS_UVPROT : boolean := false;  --True if FIFO has underflow protection (i.e. rd_enable to an empty FIFO is safe)
      HAS_IFX    : boolean := false;  --True if FIFO has Interface-X compatible output (note that this also sets HAS_UVPROT=true)

      AFULL_THRESH1 : natural := 0;     --Almost full assertion threshold
                                        --  afull asserted as count goes from AFULL_THRESH1 to AFULL_THRESH1+1
      AFULL_THRESH0 : natural := 0;     --Almost full deassertion threshold
                                        --  afull deasserted as count goes from AFULL_THRESH0 to AFULL_THRESH0-1
                                        --If AFULL_THRESH1 and AFULL_THRESH0 are both zero, afull/not_afull are disabled

      AEMPTY_THRESH0 : natural := 0;    --Almost empty deassertion threshold
                                        --  aempty deasserted as count goes from AEMPTY_THRESH0 to AEMPTY_THRESH0+1
      AEMPTY_THRESH1 : natural := 0;    --Almost empty assertion threshold
                                        --  aempty asserted as count goes from AEMPTY_THRESH1 to AEMPTY_THRESH1-1
                                        --If AEMPTY_THRESH1 and AEMPTY_THRESH0 are both zero, aempty/not_aempty are disabled

      HAS_HIERARCHY : boolean := true  --True to apply KEEP_HIERARCHY="soft" to FIFO, false to apply KEEP_HIERARCHY="no"
      );
    port (
      aclk   : in std_logic;
      areset : in std_logic;

      --Write interface
      wr_enable : in std_logic;                           --True to write data
      wr_data   : in std_logic_vector(WIDTH-1 downto 0);  --Write data

      --Read interface
      rd_enable : in  std_logic;        --True to read data
      rd_avail  : out std_logic;        --True when rd_data is available
      rd_valid  : out std_logic;  --True when rd_data is available and valid (i.e. has been read)
      rd_data   : out std_logic_vector(WIDTH-1 downto 0);  --Read data (only valid when rd_avail asserted)

      --FIFO status
      full       : out std_logic;       --FIFO full
      not_full   : out std_logic;  --FIFO not full (logical inverse of full)
      empty      : out std_logic;       --FIFO empty
      not_empty  : out std_logic;  --FIFO not empty (logical inverse of empty)
      afull      : out std_logic;       --FIFO almost full
      not_afull  : out std_logic;  --FIFO not almost full (logical inverse of afull)
      aempty     : out std_logic;       --FIFO almost empty
      not_aempty : out std_logic;  --FIFO not almost empty (logical inverse of aempty)
      add        : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
      );
  end component;

  component axi_slave_2to1_v1_0
    generic (
      C_A_TDATA_WIDTH : positive := 8;      -- Width of s_axis_a_tdata in bits
      C_HAS_A_TUSER   : boolean  := false;  -- Indicates if s_axis_a_tuser signal is used
      C_A_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_a_tuser in bits (if C_HAS_A_TUSER = true)
      C_HAS_A_TLAST   : boolean  := false;  -- Indicates if s_axis_a_tlast signal is used
      C_B_TDATA_WIDTH : positive := 8;      -- Width of s_axis_b_tdata in bits
      C_HAS_B_TUSER   : boolean  := false;  -- Indicates if s_axis_b_tuser signal is used
      C_B_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_b_tuser in bits (if C_HAS_B_TUSER = true)
      C_HAS_B_TLAST   : boolean  := false;  -- Indicates if s_axis_b_tlast signal is used
      C_HAS_Z_TREADY  : boolean  := true    -- Indicates if m_axis_z_tready signal is used
      );
    port (
      aclk   : in std_logic := '0';       -- Clock
      aclken : in std_logic := '1';       -- Clock enable
      sclr   : in std_logic := '0';       -- Reset, active HIGH

      -- AXI slave interface A
      s_axis_a_tready : out std_logic                                    := '0';              -- TREADY for channel A
      s_axis_a_tvalid : in  std_logic                                    := '0';              -- TVALID for channel A
      s_axis_a_tdata  : in  std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel A
      s_axis_a_tuser  : in  std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel A
      s_axis_a_tlast  : in  std_logic                                    := '0';              -- TLAST for channel A

      -- AXI slave interface B
      s_axis_b_tready : out std_logic                                    := '0';              -- TREADY for channel B
      s_axis_b_tvalid : in  std_logic                                    := '0';              -- TVALID for channel B
      s_axis_b_tdata  : in  std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel B
      s_axis_b_tuser  : in  std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel B
      s_axis_b_tlast  : in  std_logic                                    := '0';              -- TLAST for channel B

      -- Read interface to core
      m_axis_z_tready  : in  std_logic                                    := '1';              -- TREADY for channel Z
      m_axis_z_tvalid  : out std_logic                                    := '0';              -- TVALID for channel Z
      m_axis_z_tdata_a : out std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from A
      m_axis_z_tuser_a : out std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from A
      m_axis_z_tlast_a : out std_logic                                    := '0';              -- Channel Z TLAST from A
      m_axis_z_tdata_b : out std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from B
      m_axis_z_tuser_b : out std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from B
      m_axis_z_tlast_b : out std_logic                                    := '0'               -- Channel Z TLAST from B
      );

  end component;

  component axi_slave_3to1_v1_0
    generic (
      C_A_TDATA_WIDTH : positive := 8;      -- Width of s_axis_a_tdata in bits
      C_HAS_A_TUSER   : boolean  := false;  -- Indicates if s_axis_a_tuser signal is used
      C_A_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_a_tuser in bits (if C_HAS_A_TUSER = true)
      C_HAS_A_TLAST   : boolean  := false;  -- Indicates if s_axis_a_tlast signal is used
      C_B_TDATA_WIDTH : positive := 8;      -- Width of s_axis_b_tdata in bits
      C_HAS_B_TUSER   : boolean  := false;  -- Indicates if s_axis_b_tuser signal is used
      C_B_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_b_tuser in bits (if C_HAS_B_TUSER = true)
      C_HAS_B_TLAST   : boolean  := false;  -- Indicates if s_axis_b_tlast signal is used
      C_C_TDATA_WIDTH : positive := 8;      -- Width of s_axis_c_tdata in bits
      C_HAS_C_TUSER   : boolean  := false;  -- Indicates if s_axis_c_tuser signal is used
      C_C_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_c_tuser in bits (if C_HAS_C_TUSER = true)
      C_HAS_C_TLAST   : boolean  := false;  -- Indicates if s_axis_c_tlast signal is used
      C_HAS_Z_TREADY  : boolean  := true    -- Indicates if m_axis_z_tready signal is used
      );
    port (
      aclk   : in std_logic := '0';       -- Clock
      aclken : in std_logic := '1';       -- Clock enable
      sclr   : in std_logic := '0';       -- Reset, active HIGH

      -- AXI slave interface A
      s_axis_a_tready : out std_logic                                    := '0';              -- TREADY for channel A
      s_axis_a_tvalid : in  std_logic                                    := '0';              -- TVALID for channel A
      s_axis_a_tdata  : in  std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel A
      s_axis_a_tuser  : in  std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel A
      s_axis_a_tlast  : in  std_logic                                    := '0';              -- TLAST for channel A

      -- AXI slave interface B
      s_axis_b_tready : out std_logic                                    := '0';              -- TREADY for channel B
      s_axis_b_tvalid : in  std_logic                                    := '0';              -- TVALID for channel B
      s_axis_b_tdata  : in  std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel B
      s_axis_b_tuser  : in  std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel B
      s_axis_b_tlast  : in  std_logic                                    := '0';              -- TLAST for channel B

      -- AXI slave interface C
      s_axis_c_tready : out std_logic                                    := '0';              -- TREADY for channel C
      s_axis_c_tvalid : in  std_logic                                    := '0';              -- TVALID for channel C
      s_axis_c_tdata  : in  std_logic_vector(C_C_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel C
      s_axis_c_tuser  : in  std_logic_vector(C_C_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel C
      s_axis_c_tlast  : in  std_logic                                    := '0';              -- TLAST for channel C

      -- Read interface to core
      m_axis_z_tready  : in  std_logic                                    := '1';              -- TREADY for channel Z
      m_axis_z_tvalid  : out std_logic                                    := '0';              -- TVALID for channel Z
      m_axis_z_tdata_a : out std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from A
      m_axis_z_tuser_a : out std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from A
      m_axis_z_tlast_a : out std_logic                                    := '0';              -- Channel Z TLAST from A
      m_axis_z_tdata_b : out std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from B
      m_axis_z_tuser_b : out std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from B
      m_axis_z_tlast_b : out std_logic                                    := '0';              -- Channel Z TLAST from B
      m_axis_z_tdata_c : out std_logic_vector(C_C_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from C
      m_axis_z_tuser_c : out std_logic_vector(C_C_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from C
      m_axis_z_tlast_c : out std_logic                                    := '0'               -- Channel Z TLAST from C
      );

  end component;

end axi_utils_v1_0_comps;

package body axi_utils_v1_0_comps is

end axi_utils_v1_0_comps;
