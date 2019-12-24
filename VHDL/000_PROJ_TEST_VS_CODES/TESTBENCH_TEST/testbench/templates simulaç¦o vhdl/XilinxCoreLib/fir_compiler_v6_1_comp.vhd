-------------------------------------------------------------------------------
-- $RCSfile: fir_compiler_v6_1_comp.vhd,v $ $Revision: 1.2 $ $Date: 2010/11/02 11:08:39 $
-------------------------------------------------------------------------------
--  (c) Copyright 2006-2008 Xilinx, Inc. All rights reserved.
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
-- Description:
--
-- Component declarations for the FIR Compiler core
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- library xilinxcorelib;
-- use xilinxcorelib.bip_utils_pkg_v2_0.all;


package fir_compiler_v6_1_comp is

  --core_if on component fir_compiler_v6_1
  component fir_compiler_v6_1
  generic (
    C_XDEVICEFAMILY     : string  := "virtex6";
    C_ELABORATION_DIR   : string  := "./";
    C_COMPONENT_NAME    : string  := "fir_compiler_v6_1_default";
    C_COEF_FILE         : string  := "fir_compiler_v6_1_default.mif";
    C_COEF_FILE_LINES   : integer := 11;

    C_FILTER_TYPE          : integer := 0;
    C_INTERP_RATE          : integer := 1;
    C_DECIM_RATE           : integer := 1;
    C_ZERO_PACKING_FACTOR  : integer := 1;
    C_SYMMETRY             : integer := 1;
    C_NUM_FILTS            : integer := 1;
    C_NUM_TAPS             : integer := 21;
    C_NUM_CHANNELS         : integer := 1;
    C_CHANNEL_PATTERN      : string  := "fixed";
    C_ROUND_MODE           : integer := 0;
    C_COEF_RELOAD          : integer := 0;
    C_NUM_RELOAD_SLOTS     : integer := 1;
    C_COL_MODE             : integer := 0;
    C_COL_PIPE_LEN         : integer := 4;
    C_COL_CONFIG           : string  := "1";
    C_OPTIMIZATION         : integer := 0;

    C_DATA_PATH_WIDTHS     : string  := "16";
    C_DATA_WIDTH           : integer := 16;
    C_COEF_PATH_WIDTHS     : string  := "16";
    C_COEF_WIDTH           : integer := 16;
    C_DATA_PATH_SRC        : string  := "0";
    C_COEF_PATH_SRC        : string  := "0";
    C_DATA_PATH_SIGN       : string  := "0";
    C_COEF_PATH_SIGN       : string  := "0";
    C_ACCUM_PATH_WIDTHS    : string  := "24";
    C_OUTPUT_WIDTH         : integer := 24;
    C_OUTPUT_PATH_WIDTHS   : string  := "24";
    C_ACCUM_OP_PATH_WIDTHS : string  := "24";
    C_EXT_MULT_CNFG        : string  := "none";

    C_NUM_MADDS            : integer := 1;
    C_OPT_MADDS            : string  := "none";
    C_OVERSAMPLING_RATE    : integer := 11;
    C_INPUT_RATE           : integer := 300000;
    C_OUTPUT_RATE          : integer := 300000;
    C_DATA_MEMTYPE         : integer := 0;
    C_COEF_MEMTYPE         : integer := 2;
    C_IPBUFF_MEMTYPE       : integer := 0;
    C_OPBUFF_MEMTYPE       : integer := 0;
    C_DATAPATH_MEMTYPE     : integer := 0;
    C_MEM_ARRANGEMENT      : integer := 1;
    C_DATA_MEM_PACKING     : integer := 0;
    C_COEF_MEM_PACKING     : integer := 0;
    C_FILTS_PACKED         : integer := 0;

    C_LATENCY              : integer := 18; -- Used by the behavoural model, not the core

    -- AXI channels generics
    C_HAS_ARESETn          : integer := 0;
    C_HAS_ACLKEN           : integer := 0;

    -- Common to both data channels
    C_DATA_HAS_TLAST     : integer := 0; -- 0=no 1=vector framing 2=pass through

    C_S_DATA_HAS_TUSER   : integer := 0; -- 0=no 1=chanid 2=user 3=both
    C_S_DATA_TDATA_WIDTH : integer := 16;
    C_S_DATA_TUSER_WIDTH : integer := 1;

    C_M_DATA_HAS_TREADY  : integer := 0; -- 0=no 1=yes
    C_M_DATA_HAS_TUSER   : integer := 0; -- 0=no 1=chanid 2=user 3=both
    C_M_DATA_TDATA_WIDTH : integer := 24;
    C_M_DATA_TUSER_WIDTH : integer := 1;

    C_HAS_CONFIG_CHANNEL : integer := 0;
    C_CONFIG_SYNC_MODE   : integer := 0; -- 0=vector 1=packet
    C_CONFIG_PACKET_SIZE : integer := 0; -- 0=single config all TDM channels 1= one config per TDM channel
    C_CONFIG_TDATA_WIDTH : integer := 1;

    C_RELOAD_TDATA_WIDTH : integer := 1
  );
  port (
    aresetn                          : in  std_logic:='1';
    aclk                             : in  std_logic;
    aclken                           : in  std_logic:='1';

    s_axis_data_tvalid               : in std_logic:='0';
    s_axis_data_tready               : out std_logic:='1';
    s_axis_data_tlast                : in std_logic:='0';
    s_axis_data_tuser                : in std_logic_vector(C_S_DATA_TUSER_WIDTH-1 downto 0):=(others=>'0');
    s_axis_data_tdata                : in std_logic_vector(C_S_DATA_TDATA_WIDTH-1 downto 0):=(others=>'0');

    s_axis_config_tvalid             : in  std_logic:='0';
    s_axis_config_tready             : out std_logic:='1';
    s_axis_config_tlast              : in  std_logic:='0';
    s_axis_config_tdata              : in  std_logic_vector(C_CONFIG_TDATA_WIDTH-1 downto 0):=(others=>'0');

    s_axis_reload_tvalid             : in  std_logic:='0';
    s_axis_reload_tready             : out std_logic:='1';
    s_axis_reload_tlast              : in  std_logic:='0';
    s_axis_reload_tdata              : in  std_logic_vector(C_RELOAD_TDATA_WIDTH-1 downto 0):=(others=>'0');

    m_axis_data_tvalid               : out std_logic:='0';
    m_axis_data_tready               : in std_logic:='1';
    m_axis_data_tlast                : out std_logic:='0';
    m_axis_data_tuser                : out std_logic_vector(C_M_DATA_TUSER_WIDTH-1 downto 0):=(others=>'0');
    m_axis_data_tdata                : out std_logic_vector(C_M_DATA_TDATA_WIDTH-1 downto 0):=(others=>'0');

    event_s_data_tlast_missing       : out std_logic := '0';
    event_s_data_tlast_unexpected    : out std_logic := '0';
    event_s_data_chanid_incorrect    : out std_logic := '0';
    event_s_config_tlast_missing     : out std_logic := '0';
    event_s_config_tlast_unexpected  : out std_logic := '0';
    event_s_reload_tlast_missing     : out std_logic := '0';
    event_s_reload_tlast_unexpected  : out std_logic := '0'
  );
  --core_if off
  end component;

  -----------------------------------------------------------------------------
  -- The following tells XST that this core is a black box which  
  -- should be generated with the command given by the value of this attribute.
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core.
  ATTRIBUTE box_type : STRING; 
  ATTRIBUTE box_type OF fir_compiler_v6_1 : COMPONENT IS "black_box"; 
  ATTRIBUTE GENERATOR_DEFAULT : STRING; 
  ATTRIBUTE GENERATOR_DEFAULT OF fir_compiler_v6_1 : COMPONENT IS 
            "generatecore com.xilinx.ip.fir_compiler_v6_1.fir_compiler_v6_1";


end fir_compiler_v6_1_comp;
