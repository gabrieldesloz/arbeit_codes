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
-- $RCSfile: rs_encoder_v8_0_consts.vhd,v $ $Revision: 1.1 $ $Date: 2011/05/23 12:55:41 $
--
--------------------------------------------------------------------------------
--
-- Constants and functions for use in top level component statement.
--

library ieee;
use ieee.std_logic_1164.all;

package rs_encoder_v8_0_consts is


--------------------------------------------------------------------------------
--
-- Group: Top level component generic defaults
--
-- Constants:
--  
constant c_has_aclken_default                 : integer := 0;                   
constant c_has_aresetn_default                : integer := 0;                  
constant c_has_s_axis_ctrl_default            : integer := 0;           
constant c_has_s_axis_input_tuser_default     : integer := 0;       
constant c_has_m_axis_output_tuser_default    : integer := 0;       
constant c_has_m_axis_output_tready_default   : integer := 1;
constant c_s_axis_input_tdata_width_default   : integer := 8;     
constant c_s_axis_input_tuser_width_default   : integer := 1;     
constant c_s_axis_ctrl_tdata_width_default    : integer := 8;   
constant c_m_axis_output_tdata_width_default  : integer := 8;    
constant c_m_axis_output_tuser_width_default  : integer := 1;    
constant c_has_info_default                   : integer := 0;
constant c_has_r_in_default                   : integer := 0;
constant c_has_n_in_default                   : integer := 0;
constant c_gen_start_default                  : integer := 0;
constant c_h_default                          : integer := 1;
constant c_k_default                          : integer := 239;
constant c_n_default                          : integer := 255;
constant c_polynomial_default                 : integer := 0;
constant c_spec_default                       : integer := 0;
constant c_symbol_width_default               : integer := 8;
constant c_gen_poly_type_default              : integer := 0;
constant c_num_channels_default               : integer := 1;
constant c_memstyle_default                   : integer := 2; -- automatic
constant c_optimization_default               : integer := 2; -- optimize for speed
constant c_mem_init_prefix_default            : string  := "rse1";
constant c_elaboration_dir_default            : string  := "./";
constant c_xdevicefamily_default              : string  := "no_family";
constant c_family_default                     : string  := "no_family";


--------------------------------------------------------------------------------
--
-- Defaults for old top level - remove once switch to new AXI top level is complete!!!!!!!!!!!!!!!!!!!
--
--------------------------------------------------------------------------------
-- constant c_ce_default              : integer  := 0;
-- constant c_n_in_default            : integer  := 0;
-- constant c_r_in_default            : integer  := 0;
-- constant c_nd_default              : integer  := 0;
-- constant c_rdy_default             : integer  := 0;
-- constant c_rfd_default             : integer  := 0;
-- constant c_rffd_default            : integer  := 0;
-- constant c_sclr_default            : integer  := 0;
-- constant c_userpm_default          : integer  := 0; -- no longer used

--------------------------------------------------------------------------------
--
-- Group: General constants
--
-- Constants:
--
constant axi_field_factor : integer := 8; -- All sub-fields of tdata busses must be a multiple of this value


--------------------------------------------------------------------------------
--
-- Constants to define dual basis or normal basis
--
--------------------------------------------------------------------------------
constant c_spec_min : integer := 0;
constant c_spec_max : integer := 2;

subtype spec_type is integer range c_spec_min to c_spec_max;

constant j83_b_spec   : spec_type := 2;
constant ccsds_spec   : spec_type := 1;
constant custom_spec  : spec_type := 0;
constant default_spec : spec_type := custom_spec;

--------------------------------------------------------------------------------
--
-- min/max's
--
--------------------------------------------------------------------------------
constant min_s_axis_input_tdata_width  : integer := 8;
constant max_s_axis_input_tdata_width  : integer := 16;
constant min_s_axis_input_tuser_width  : integer := 1;
constant max_s_axis_input_tuser_width  : integer := 16;
constant min_s_axis_ctrl_tdata_width   : integer := 8;  -- r_in, n_in fields,
constant max_s_axis_ctrl_tdata_width   : integer := 40; --  each field rounded up to nearest multiple of 8
constant min_m_axis_output_tdata_width : integer := 8;  -- info, data_out fields,
constant max_m_axis_output_tdata_width : integer := 24; --  each field rounded up to nearest multiple of 8
constant min_m_axis_output_tuser_width : integer := min_s_axis_input_tuser_width;
constant max_m_axis_output_tuser_width : integer := max_s_axis_input_tuser_width;


constant min_symbol_width          : integer := 3;
constant max_symbol_width          : integer := 12;
constant max_symbol_width_minus_1  : integer := max_symbol_width - 1;
constant min_num_channels          : integer := 1;
constant max_num_channels          : integer := 128;
constant min_gen_start             : integer := 0;
constant max_gen_start             : integer := 1023;
constant encoder_min_n_minus_k     : integer := 2;
constant encoder_max_n_minus_k     : integer := 256;
constant encoder_min_n             : integer := 4;
constant encoder_max_n             : integer := (2**max_symbol_width) -1;
constant encoder_min_k             : integer := 2;
constant encoder_max_k             : integer := encoder_max_n - encoder_min_n_minus_k;
constant encoder_min_h             : integer := 1;
constant encoder_max_h             : integer := (2**16)-1;




--------------------------------------------------------------------------------
--
-- Function declarations
--
--------------------------------------------------------------------------------
function integer_width( integer_value : integer ) return integer;
      
end rs_encoder_v8_0_consts;
          
          
          
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
package body rs_encoder_v8_0_consts is

function integer_width( integer_value : integer ) return integer is
    variable width : integer := 1;
begin
  for i in 30 downto 0 loop
    if integer_value >= 2**i then
      width := i+1;
      exit;
    end if;
  end loop;

  return width;

end integer_width;
  



end rs_encoder_v8_0_consts;


