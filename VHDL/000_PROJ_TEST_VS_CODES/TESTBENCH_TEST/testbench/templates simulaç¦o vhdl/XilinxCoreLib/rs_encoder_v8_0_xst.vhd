--------------------------------------------------------------------------------
--  (c) Copyright 1995-2010, 2012 Xilinx, Inc. All rights reserved.
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
--------------------------------------------------------------------------------
--
-- Behavorial simulation model for parallel Reed-Solomon encoder
-- This model is only for other cores that instantiate the RS Encoder. These
-- will instantiate the rs_encoder_v8_0_xst entity. This file is provided
-- for behavioral simulation of that entity. It is in fact a simple wrapper
-- for the rs_encoder_v8_0 behavioral model.
--
-- $RCSfile: rs_encoder_v8_0_xst.vhd,v $ $Revision: 1.2 $ $Date: 2011/10/19 12:55:09 $
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY xilinxcorelib;
USE xilinxcorelib.rs_encoder_v8_0_consts.ALL;
USE xilinxcorelib.rs_encoder_v8_0_comp.ALL;

--core_if on entity rs_encoder_v8_0_xst
  entity rs_encoder_v8_0_xst is
generic (
  -- AXI channel parameters
  C_HAS_ACLKEN                 : integer := c_has_aclken_default;                   
  C_HAS_ARESETN                : integer := c_has_aresetn_default;                  
  C_HAS_S_AXIS_CTRL            : integer := c_has_s_axis_ctrl_default;           
  C_HAS_S_AXIS_INPUT_TUSER     : integer := c_has_s_axis_input_tuser_default;       
  C_HAS_M_AXIS_OUTPUT_TUSER    : integer := c_has_m_axis_output_tuser_default;       
  C_HAS_M_AXIS_OUTPUT_TREADY   : integer := c_has_m_axis_output_tready_default;
  C_S_AXIS_INPUT_TDATA_WIDTH   : integer := c_s_axis_input_tdata_width_default;     
  C_S_AXIS_INPUT_TUSER_WIDTH   : integer := c_s_axis_input_tuser_width_default;     
  C_S_AXIS_CTRL_TDATA_WIDTH    : integer := c_s_axis_ctrl_tdata_width_default;   
  C_M_AXIS_OUTPUT_TDATA_WIDTH  : integer := c_m_axis_output_tdata_width_default;    
  C_M_AXIS_OUTPUT_TUSER_WIDTH  : integer := c_m_axis_output_tuser_width_default;    
    
  -- AXI channel sub-field parameters
  C_HAS_INFO                   : integer := c_has_info_default; 
  C_HAS_N_IN                   : integer := c_has_n_in_default;
  C_HAS_R_IN                   : integer := c_has_r_in_default;
  
  -- Reed-Solomon code word parameters
  C_GEN_START                  : integer := c_gen_start_default;
  C_H                          : integer := c_h_default;
  C_K                          : integer := c_k_default;
  C_N                          : integer := c_n_default;
  C_POLYNOMIAL                 : integer := c_polynomial_default;
  C_SPEC                       : integer := c_spec_default;
  C_SYMBOL_WIDTH               : integer := c_symbol_width_default;
  
  -- Implementation parameters
  C_GEN_POLY_TYPE              : integer := c_gen_poly_type_default;
  C_NUM_CHANNELS               : integer := c_num_channels_default;
  C_MEMSTYLE                   : integer := c_memstyle_default;
  C_OPTIMIZATION               : integer := c_optimization_default;
  
  -- Generation parameters
  C_MEM_INIT_PREFIX            : string  := c_mem_init_prefix_default;
  C_ELABORATION_DIR            : string  := c_elaboration_dir_default;
  C_XDEVICEFAMILY              : string  := c_xdevicefamily_default;
  C_FAMILY                     : string  := c_family_default
);
port (
  aclk                           : in  std_logic;                                                                 
  aclken                         : in  std_logic := '1';                                                          
  aresetn                        : in  std_logic := '1';                                                          
  
  s_axis_input_tdata             : in  std_logic_vector(C_S_AXIS_INPUT_TDATA_WIDTH-1 downto 0) := (others=>'0');                   
  s_axis_input_tuser             : in  std_logic_vector(C_S_AXIS_INPUT_TUSER_WIDTH-1 downto 0) := (others=>'0'); 
  s_axis_input_tvalid            : in  std_logic;                                                                 
  s_axis_input_tlast             : in  std_logic;                                                                 
  s_axis_input_tready            : out std_logic;                                                                 
    
  s_axis_ctrl_tdata              : in  std_logic_vector(C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0) := (others=>'1');
  s_axis_ctrl_tvalid             : in  std_logic := '0';                                                
  s_axis_ctrl_tready             : out std_logic;                                                                 
  
  m_axis_output_tdata            : out std_logic_vector(C_M_AXIS_OUTPUT_TDATA_WIDTH-1 downto 0);                  
  m_axis_output_tuser            : out std_logic_vector(C_M_AXIS_OUTPUT_TUSER_WIDTH-1 downto 0);                  
  m_axis_output_tvalid           : out std_logic;                                                                 
  m_axis_output_tready           : in  std_logic := '1';                                                          
  m_axis_output_tlast            : out std_logic;                                                                 

  event_s_input_tlast_missing    : out std_logic;
  event_s_input_tlast_unexpected : out std_logic;
  event_s_ctrl_tdata_invalid     : out std_logic
);
  --core_if off
end rs_encoder_v8_0_xst;
  
ARCHITECTURE behavioral OF rs_encoder_v8_0_xst IS
BEGIN

  -- Instantiate the true behavioral model top level
  
  --core_if on instance enc rs_encoder_v8_0
  enc : rs_encoder_v8_0
    generic map (
      C_HAS_ACLKEN                => C_HAS_ACLKEN,
      C_HAS_ARESETN               => C_HAS_ARESETN,
      C_HAS_S_AXIS_CTRL           => C_HAS_S_AXIS_CTRL,
      C_HAS_S_AXIS_INPUT_TUSER    => C_HAS_S_AXIS_INPUT_TUSER,
      C_HAS_M_AXIS_OUTPUT_TUSER   => C_HAS_M_AXIS_OUTPUT_TUSER,
      C_HAS_M_AXIS_OUTPUT_TREADY  => C_HAS_M_AXIS_OUTPUT_TREADY,
      C_S_AXIS_INPUT_TDATA_WIDTH  => C_S_AXIS_INPUT_TDATA_WIDTH,
      C_S_AXIS_INPUT_TUSER_WIDTH  => C_S_AXIS_INPUT_TUSER_WIDTH,
      C_S_AXIS_CTRL_TDATA_WIDTH   => C_S_AXIS_CTRL_TDATA_WIDTH,
      C_M_AXIS_OUTPUT_TDATA_WIDTH => C_M_AXIS_OUTPUT_TDATA_WIDTH,
      C_M_AXIS_OUTPUT_TUSER_WIDTH => C_M_AXIS_OUTPUT_TUSER_WIDTH,
      C_HAS_INFO                  => C_HAS_INFO,
      C_HAS_N_IN                  => C_HAS_N_IN,
      C_HAS_R_IN                  => C_HAS_R_IN,
      C_GEN_START                 => C_GEN_START,
      C_H                         => C_H,
      C_K                         => C_K,
      C_N                         => C_N,
      C_POLYNOMIAL                => C_POLYNOMIAL,
      C_SPEC                      => C_SPEC,
      C_SYMBOL_WIDTH              => C_SYMBOL_WIDTH,
      C_GEN_POLY_TYPE             => C_GEN_POLY_TYPE,
      C_NUM_CHANNELS              => C_NUM_CHANNELS,
      C_MEMSTYLE                  => C_MEMSTYLE,
      C_OPTIMIZATION              => C_OPTIMIZATION,
      C_MEM_INIT_PREFIX           => C_MEM_INIT_PREFIX,
      C_ELABORATION_DIR           => C_ELABORATION_DIR,
      C_XDEVICEFAMILY             => C_XDEVICEFAMILY,
      C_FAMILY                    => C_FAMILY
      )
    port map (
      aclk                           => aclk,
      aclken                         => aclken,
      aresetn                        => aresetn,
      s_axis_input_tdata             => s_axis_input_tdata,
      s_axis_input_tuser             => s_axis_input_tuser,
      s_axis_input_tvalid            => s_axis_input_tvalid,
      s_axis_input_tlast             => s_axis_input_tlast,
      s_axis_input_tready            => s_axis_input_tready,
      s_axis_ctrl_tdata              => s_axis_ctrl_tdata,
      s_axis_ctrl_tvalid             => s_axis_ctrl_tvalid,
      s_axis_ctrl_tready             => s_axis_ctrl_tready,
      m_axis_output_tdata            => m_axis_output_tdata,
      m_axis_output_tuser            => m_axis_output_tuser,
      m_axis_output_tvalid           => m_axis_output_tvalid,
      m_axis_output_tready           => m_axis_output_tready,
      m_axis_output_tlast            => m_axis_output_tlast,
      event_s_input_tlast_missing    => event_s_input_tlast_missing,
      event_s_input_tlast_unexpected => event_s_input_tlast_unexpected,
      event_s_ctrl_tdata_invalid     => event_s_ctrl_tdata_invalid
      );

    --core_if off
      
END behavioral;

