-------------------------------------------------------------------------------
--  (c) Copyright 2006-2009 Xilinx, Inc. All rights reserved.
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
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE Xilinxcorelib.cic_compiler_v3_0_pkg.all;
use Xilinxcorelib.bip_utils_pkg_v2_0.get_max;

package cic_compiler_v3_0_xst_comp is

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component cic_compiler_v3_0_xst
  component cic_compiler_v3_0_xst
    GENERIC (
      C_COMPONENT_NAME  : string := "cic_compiler_v3_0";
      C_FILTER_TYPE     : integer := 1;
      C_NUM_STAGES      : integer := 3;
      C_DIFF_DELAY      : integer := 1;
      C_RATE            : integer := 4;
      C_INPUT_WIDTH     : integer := 18;
      C_OUTPUT_WIDTH    : integer := 22;
      C_USE_DSP         : integer := 0;
      C_HAS_ROUNDING    : integer := 0;
      C_NUM_CHANNELS    : integer := 1;
      C_RATE_TYPE       : integer := 0;
      C_MIN_RATE        : integer := 4;
      C_MAX_RATE        : integer := 4;
      C_SAMPLE_FREQ     : integer := 1;
      C_CLK_FREQ        : integer := 4;
      C_USE_STREAMING_INTERFACE : integer:= 0;
      C_FAMILY          : string  := "virtex6";
      C_XDEVICEFAMILY   : string  := "virtex6";
      C_C1    : integer := 19;
      C_C2    : integer := 20;
      C_C3    : integer := 20;
      C_C4    : integer := 0;
      C_C5    : integer := 0;
      C_C6    : integer := 0;
      C_I1    : integer := 20;
      C_I2    : integer := 21;
      C_I3    : integer := 22;
      C_I4    : integer := 0;
      C_I5    : integer := 0;
      C_I6    : integer := 0;

      -- The width of the configuration channel's TDATA
      C_S_AXIS_CONFIG_TDATA_WIDTH : integer := 32;

      -- The width of the input data channel's TDATA
      C_S_AXIS_DATA_TDATA_WIDTH : integer := 32;

      -- The width of the output data channel's TDATA
      C_M_AXIS_DATA_TDATA_WIDTH : integer := 32;

      -- The width of the output data channel's TUSER
      C_M_AXIS_DATA_TUSER_WIDTH : integer := 32;
      -- 0 = no m_axis_data_tready
      -- 1 = has m_axis_data_tready
      --
      C_HAS_DOUT_TREADY: integer := 0;
      -- 0 = No clock enable
      -- 1 = active-high clock enable
      --
      C_HAS_ACLKEN : integer := 0;
      -- 0 = No reset
      -- 1 = Active-low reset
      --
      C_HAS_ARESETN : integer := 1
      );
    PORT (
        aclk    : in std_logic := '1';
        aclken  : in std_logic := '1';
        aresetn : in std_logic := '1';



--        -- Debug signals - only here to aid dspIP debugging
--        debug_DIN       : out std_logic_vector (C_INPUT_WIDTH-1 downto 0):=(others=>'0');
--        debug_ND        : out std_logic:= '0';
--        debug_RATE      : out std_logic_vector (number_of_digits(C_MAX_RATE,2)-1 downto 0):=(others=>'0');
--        debug_RATE_WE   : out std_logic:= '0';
--        debug_CE        : out std_logic:= '0';
--        debug_SCLR      : out std_logic:= '0';
--        debug_CLK       : out std_logic:= '0';
--        debug_DOUT      : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0):=(others=>'0');
--        debug_RDY       : out std_logic:='0';
--        debug_RFD       : out std_logic:= '0';
--        debug_CHAN_SYNC : out std_logic:='0';
--        debug_CHAN_OUT  : out std_logic_vector (get_max(1,number_of_digits(C_NUM_CHANNELS-1,2))-1 downto 0):=(others=>'0');


        -- Configuration Channel (Optional)
        -- --------------------------------
        --

        s_axis_config_tdata  : in std_logic_vector (C_S_AXIS_CONFIG_TDATA_WIDTH-1 downto 0) := (others => '0');
        s_axis_config_tvalid : in std_logic := '0';
        s_axis_config_tready : out std_logic := '0';

        -- Data In Channel
        ------------------
        --
        s_axis_data_tdata  : in std_logic_vector (C_S_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
        s_axis_data_tvalid : in std_logic                                               := '0';
        s_axis_data_tready : out std_logic                                              := '0';
        s_axis_data_tlast  : in  std_logic                                              := '0';

        -- Data Out Channel
        -- ----------------
        --
        m_axis_data_tdata  : out std_logic_vector (C_M_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
        m_axis_data_tuser  : out std_logic_vector (C_M_AXIS_DATA_TUSER_WIDTH-1 downto 0) := (others => '0');
        m_axis_data_tvalid : out std_logic                                               := '0';
        m_axis_data_tready : in std_logic                                                := '0';
        m_axis_data_tlast  : out  std_logic                                              := '0';

        event_tlast_unexpected : out std_logic := '0';   
        event_tlast_missing    : out std_logic := '0';   
        event_halted           : out std_logic := '0'   
      );
  --core_if off
  END COMPONENT;


end cic_compiler_v3_0_xst_comp;

