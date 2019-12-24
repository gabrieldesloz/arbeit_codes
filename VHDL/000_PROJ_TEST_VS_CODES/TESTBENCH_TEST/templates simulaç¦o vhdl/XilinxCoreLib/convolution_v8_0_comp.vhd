--
--  (c) Copyright 1995-2005, 2009 Xilinx, Inc. All rights reserved.
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
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


PACKAGE convolution_v8_0_comp IS

------------------------------------------------------------
-- Default values
------------------------------------------------------------
  -- axi
  constant   c_has_m_axis_data_tready_default   : integer := 0;
  constant   c_has_aclken_default               : integer := 0;
  constant   c_xdevicefamily_default            : string  := "no_family";

  -- encoding
  constant   c_s_axis_data_tdata_width_default : integer := 8; 
  constant   c_m_axis_data_tdata_width_default: integer := 8; 
  constant   c_din_width                        : integer := 1;
  constant   c_dout_width_max                   : integer := 2;
  constant   c_output_rate_default              : integer := 2; 
  constant   c_constraint_length_default        : integer := 7; 
  constant   c_punctured_default                : integer := 0;
  constant   c_dual_channel_default             : integer := 0;
  constant   c_punc_input_rate_default          : integer := 3; 
  constant   c_punc_output_rate_default         : integer := 4;
  constant   c_convolution_code0_default        : integer := 121;
  constant   c_convolution_code1_default        : integer := 91;
  constant   c_convolution_code2_default        : integer := 5;
  constant   c_convolution_code3_default        : integer := 7;
  constant   c_convolution_code4_default        : integer := 5;
  constant   c_convolution_code5_default        : integer := 7;
  constant   c_convolution_code6_default        : integer := 5;
  constant   c_punc_code0_default               : integer := 0;
  constant   c_punc_code1_default               : integer := 0;

------------------------------------------------------------
-- Component definition
------------------------------------------------------------

  component convolution_v8_0
  generic ( 
    -- AXI channel parameters
    C_HAS_ACLKEN                 : integer := c_has_aclken_default;
    C_HAS_M_AXIS_DATA_TREADY     : integer := c_has_m_axis_data_tready_default;
    -- Convolutional encoder parameters
    C_OUTPUT_RATE                : integer := c_output_rate_default;       
    C_CONSTRAINT_LENGTH          : integer := c_constraint_length_default; 
    -- punctured option 
    C_PUNCTURED                  : integer := c_punctured_default;
    --  puncture input rate
    C_DUAL_CHANNEL               : integer := c_dual_channel_default;           
    C_PUNC_INPUT_RATE            : integer := c_punc_input_rate_default;        
    C_PUNC_OUTPUT_RATE           : integer := c_punc_output_rate_default;       
    --                                       
    C_CONVOLUTION_CODE0          : integer := c_convolution_code0_default;      
    C_CONVOLUTION_CODE1          : integer := c_convolution_code1_default;      
    C_CONVOLUTION_CODE2          : integer := c_convolution_code2_default;      
    C_CONVOLUTION_CODE3          : integer := c_convolution_code3_default;      
    C_CONVOLUTION_CODE4          : integer := c_convolution_code4_default;      
    C_CONVOLUTION_CODE5          : integer := c_convolution_code5_default;      
    C_CONVOLUTION_CODE6          : integer := c_convolution_code6_default;      
    -- puncture codes                        
    C_PUNC_CODE0                 : integer := c_punc_code0_default;             
    C_PUNC_CODE1                 : integer := c_punc_code1_default;             
    -- Generation parameters
    C_XDEVICEFAMILY              : string  := c_xdevicefamily_default
  );
  port (
    aclk                           : in  std_logic;                                                                 
    aclken                         : in  std_logic := '1';
    aresetn                        : in  std_logic := '1';                                                          

    s_axis_data_tdata             : in  std_logic_vector(C_S_AXIS_DATA_TDATA_WIDTH_DEFAULT-1 downto 0) := (others=>'0');                   
    s_axis_data_tvalid            : in  std_logic := '0';                                                                 
    s_axis_data_tlast             : in  std_logic := '0';                                                                 
    s_axis_data_tready            : out std_logic;                                                                 
  
    m_axis_data_tdata            : out std_logic_vector(C_M_AXIS_DATA_TDATA_WIDTH_DEFAULT-1 downto 0);                  
    m_axis_data_tvalid           : out std_logic;                                                                 
    m_axis_data_tlast            : out std_logic;                                                                 
    m_axis_data_tready           : in  std_logic := '1';                                                          

    event_s_data_tlast_missing    : out std_logic;
    event_s_data_tlast_unexpected : out std_logic
  );
  end component;
   
   
-- the following tells xst that convolution_v8_0 is a black box which  
-- should be generated command given by the value of this attribute 
-- note the fully qualified sim (java class) name that forms the 
-- basis of the core 
attribute box_type : string; 
attribute box_type of convolution_v8_0 : component is "black_box"; 
attribute GENERATOR_DEFAULT : string; 
attribute GENERATOR_DEFAULT of convolution_v8_0 : component is 
          "generatecore com.xilinx.ip.convolution_v8_0.convolution_v8_0"; 
   
END convolution_v8_0_comp;
