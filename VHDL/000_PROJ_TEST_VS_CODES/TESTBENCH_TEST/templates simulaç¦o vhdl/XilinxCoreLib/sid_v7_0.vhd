-- $RCSfile: sid_v7_0.vhd,v $
--
--  (c) Copyright 1995-2008, 2010 Xilinx, Inc. All rights reserved.
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
--
-------------------------------------------------------------------------------
-- Behavioural Model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library XilinxCoreLib;
use XilinxCoreLib.bip_utils_pkg_v2_0.all;


---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--                                                                          ---*
--                PACKAGE sid_const_pkg_behav_v7_0                          ---*
--                                                                          ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*


package sid_const_pkg_behav_v7_0 is

--Here are constants that may be used in the vhdl
--behavioral model.

-- Assign no_debug as false to enable display of debug info.
  constant no_debug : boolean := true;

  constant abs_max_bm_depth_vx2 : integer := 1048576;  -- Block mem for Vx2
  constant max_dm_depth_vx2     : integer := 131072;   -- Dist mem for Vx2

  constant min_symbol_width             : integer := 1;
  constant max_symbol_width             : integer := 256;
  constant abs_max_num_branches         : integer := 256;
  constant abs_min_num_branches         : integer := 2;
  constant min_branch_length_constant   : integer := 1;
  constant upper_branch_length_constant : integer :=
    2 * (abs_max_bm_depth_vx2 - abs_min_num_branches) /
    (abs_min_num_branches * (abs_min_num_branches-1));

  constant abs_max_num_configurations : integer := 64;
  constant abs_min_num_configurations : integer := 1;


-- c_type constants
  constant c_rectangular_block     : integer := 0;
  constant c_random_block          : integer := 1;
  constant c_relative_prime_block  : integer := 2;
  constant c_dvb_rcs_block         : integer := 3;
  constant c_umts_block            : integer := 4;
-- 5-19 are reserved for future block-based types
  constant c_forney_convolutional  : integer := 20;
  constant c_ramsey1_convolutional : integer := 21;
  constant c_ramsey2_convolutional : integer := 22;
  constant c_ramsey3_convolutional : integer := 23;
  constant c_ramsey4_convolutional : integer := 24;
-- 25-40 are reserved for future convolutional-based types
-- c_mode constants
  constant c_interleaver           : integer := 0;
  constant c_deinterleaver         : integer := 1;
-- c_row_type, c_col_type, c_block_size_type, and c_branch_length_type constants
  constant c_constant              : integer := 0;  -- c_row_type, c_col_type, c_block_size_type, c_branch_length_type
  constant c_variable              : integer := 1;  -- c_row_type, c_col_type, c_block_size_type
  constant c_selectable            : integer := 2;  -- c_row_type, c_col_type
  constant c_row_x_col             : integer := 3;  -- c_block_size_type
  constant c_file                  : integer := 4;  -- c_branch_length_type
-- c_memstyle constants
  constant c_distmem               : integer := 0;
  constant c_blockmem              : integer := 1;
  constant c_automatic             : integer := 2;
-- c_pipe_level constants
  constant c_minimum               : integer := 0;
  constant c_medium                : integer := 1;
  constant c_maximum               : integer := 2;

-- c_architecture constants
-- For Convolutional interleaver
  constant c_use_rom   : integer := 0;
  constant c_use_logic : integer := 1;


  constant DEFAULT_C_TYPE          : integer := c_forney_convolutional;
  constant DEFAULT_MEM_INIT_PREFIX : string  := "int_1";
  constant DEFAULT_MODE            : integer := c_interleaver;
  constant DEFAULT_SYMBOL_WIDTH    : integer := 8;


  constant new_line : string(1 to 1) := (1 => lf);  -- for assertion reports

  constant abs_min_num_rows : integer := 1;
  constant abs_min_num_cols : integer := 2;
  CONSTANT abs_min_block_size       : INTEGER := 6;

  constant c_sp_ram : integer := 1;
  constant c_dp_ram : integer := 2;

  constant SID_CONST_PKG_BEHAV_mif_width : integer := 32;

end sid_const_pkg_behav_v7_0;

---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--                                                                          ---*
--                PACKAGE sid_mif_pkg_behav_v7_0                            ---*
--                                                                          ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
library std;
use std.textio.all;
--
library ieee;
use ieee.std_logic_1164.all;
--  

-- This package contains functions to read and write Memory Initialization
-- Files into or from a memory stored as a single BIT_VECTOR

package sid_mif_pkg_behav_v7_0 is

  function read_meminit_file(
    filename : in string;
    depth    : in positive;
    width    : in positive;
    lines    : in positive
    ) return bit_vector;

end sid_mif_pkg_behav_v7_0;

package body sid_mif_pkg_behav_v7_0 is

  ------------------------------------------------------------------------------
  -- Function to read a MIF file and place the data in a BIT_VECTOR
  -- Takes parameters:
  --   filename : Name of the file from which to read data
  --   depth    : Depth of memory in words
  --   width    : Width of memory in bits
  --   lines    : Number of lines to be read from file
  --              If the file has fewer lines then only the available
  --              data is read. If lines > depth then the RETURN vector
  --              is padded with '0's.
  function read_meminit_file(
    filename : in string;
    depth    : in positive;
    width    : in positive;
    lines    : in positive
    ) return bit_vector is

    file meminitfile     : text is filename;  -- This works with '93 and '87
    variable bit         : integer;
    variable bitline     : line;
    variable bitchar     : character;
    variable bits_good   : boolean;
    variable offset      : integer;
    variable total_lines : integer;
    variable num_lines   : integer;
    variable mem_vector  : string(width downto 1);
    variable return_vect : bit_vector(width*lines-1 downto 0) := (others => '0');
  begin
    if (lines > 0 and lines <= depth) then
      total_lines := lines;
    else
      total_lines := depth;
    end if;

    num_lines := 0;
    offset    := 0;


    while (not(ENDFILE(meminitfile)) and (num_lines < total_lines)) loop
      READLINE(meminitfile, bitline);
      READ(bitline, mem_vector, bits_good);

      assert bits_good
        report "Error: problem reading memory initialization file, " & filename
        severity failure;
      
      for bit in 0 to width-1 loop
        bitchar := mem_vector(bit+1);
        if (bitchar = '1') then
          return_vect(offset+bit) := '1';
        else
          return_vect(offset+bit) := '0';
        end if;
      end loop;  -- FOR

      num_lines := num_lines+1;
      offset    := offset + width;
      
    end loop;  -- WHILE

    return return_vect;
    
  end read_meminit_file;
  
end sid_mif_pkg_behav_v7_0;

---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--                                                                          ---*
--                PACKAGE sid_pkg_behav                                     ---*
--                                                                          ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*


library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.sid_const_pkg_behav_v7_0.all;
use xilinxcorelib.sid_mif_pkg_behav_v7_0.all;

package sid_pkg_behav_v7_0 is


--------------------------------------------------------------------------------
--
-- AXI Procedure and funtion prototypes
--
--------------------------------------------------------------------------------


  -- Returns the with of the Data Output channel when there's no padding.  It's used to calculate the width of the FIFO
  --
  function calculate_dout_chan_width_no_padding(constant C_TYPE            : in integer;
                                                constant C_SYMBOL_WIDTH    : in integer;
                                                constant C_HAS_RDY         : in integer;
                                                constant C_HAS_BLOCK_START : in integer;
                                                constant C_HAS_BLOCK_END   : in integer;
                                                constant C_HAS_FDO         : in integer) return integer;

  -- Takes the TDATA and TLAST AXI inputs for the Data In channel and packages them
  -- into a single vector to get stored in the data in FIFO.  No padding is removed;
  -- we're relying on the synthesis tools top optimise away bits that aren't used.
  --
  procedure axi_chan_ctrl_convert_fifo_out_to_pe_in (constant fifo_vector           : in std_logic_vector;
                                                     signal   config_sel            : out std_logic_vector;
                                                     signal   row                   : out std_logic_vector;
                                                     signal   row_sel               : out std_logic_vector;
                                                     signal   col                   : out std_logic_vector;
                                                     signal   col_sel               : out std_logic_vector;
                                                     signal   block_size            : out std_logic_vector;
                                                     constant C_TYPE                : in integer;
                                                     constant C_NUM_CONFIGURATIONS  : in integer;
                                                     constant C_HAS_ROW             : in integer;
                                                     constant C_HAS_ROW_SEL         : in integer;
                                                     constant C_HAS_COL             : in integer;
                                                     constant C_HAS_COL_SEL         : in integer;
                                                     constant C_HAS_BLOCK_SIZE      : in integer;
                                                     constant C_ROW_WIDTH           : in integer;
                                                     constant C_NUM_SELECTABLE_ROWS : in integer;
                                                     constant C_COL_WIDTH           : in integer;
                                                     constant C_NUM_SELECTABLE_COLS : in integer;
                                                     constant C_BLOCK_SIZE_WIDTH    : in integer);

  -- Splits the Data Input Channel FIFO output into signals suitable for the PE and event interface
  --
  procedure axi_chan_din_convert_fifo_out_to_pe_in  (constant fifo_vector           : in std_logic_vector;
                                                     signal   data                  : out std_logic_vector;
                                                     signal   tlast                 : out std_logic;
                                                     constant C_SYMBOL_WIDTH        : in integer);


  -- Takes all of the (relevant) outputs of the core and packages them into a single vector to get stored in
  -- the data out FIFO.  It does not add padding as that isn't stored in the FIFO.
  --
  procedure axi_chan_dout_build_fifo_in_vector(signal tlast_in            : in std_logic;
                                               signal dout                : in std_logic_vector;
                                               signal ndo                 : in std_logic;
                                               signal fdo                 : in std_logic;
                                               signal rdy                 : in std_logic;
                                               signal block_start         : in std_logic;
                                               signal block_end           : in std_logic;
                                               signal out_vector          : out std_logic_vector;
                                               constant C_TYPE            : in integer;
                                               constant C_SYMBOL_WIDTH    : in integer;
                                               constant C_HAS_RDY         : in integer;
                                               constant C_HAS_BLOCK_START : in integer;
                                               constant C_HAS_BLOCK_END   : in integer;
                                               constant C_HAS_FDO         : in integer);


  -- Splits the Data Output Channel FIFO output into AXI signals, adding padding between
  -- the various fields where required by the AXI rules
  --
  procedure axi_chan_dout_convert_fifo_out_vector_to_axi (fifo_vector       : in std_logic_vector;
                                                          signal tdata      : out std_logic_vector;
                                                          signal tuser      : out std_logic_vector;
                                                          signal tlast      : out std_logic;
                                                          C_TYPE            : in integer;
                                                          C_SYMBOL_WIDTH    : in integer;
                                                          C_HAS_RDY         : in integer;
                                                          C_HAS_BLOCK_START : in integer;
                                                          C_HAS_BLOCK_END   : in integer;
                                                          C_HAS_FDO         : in integer);
  
  


  type integer_vector is array(natural range <>) of integer;


------------------------------------------------------------------------------
--
-- FUNCTION PROTOTYPES
--
------------------------------------------------------------------------------

  function get_max_block_size(max_rows              : integer;
                              max_cols              : integer;
                              c_block_size_constant : integer;
                              c_block_size_type     : integer;
                              c_block_size_width    : integer) return integer;

    function get_min(a : integer_vector) return integer;

  function get_max_dimension(dimension_type     : integer;
                             dimension_constant : integer;
                             dimension_width    : integer;
                             selectable_vector  : integer_vector) 
    return integer;

  function get_min_dimension(dimension_type     : integer;
                             dimension_constant : integer;
                             dimension_width    : integer;
                             dimension_min      : integer;
                             selectable_vector  : integer_vector) 
    return integer;

  
  function integer_to_string(int_value : integer) return string;

  function bits_needed_to_represent(a_value : natural) return natural;

  function select_integer(i0  : integer;
                          i1  : integer;
                          sel : boolean) return integer;

  function two_comp(vect : std_logic_vector) return std_logic_vector;

  function bit_vector_to_integer(bv : in bit_vector) return integer;

  function bit_vector_to_integer_vector(
    bv                : in bit_vector;
    bv_element_length : in integer)
    return integer_vector;

  function check_forney_generics(
    c1mode                   : integer;
    c1symbol_width           : integer;
    c1num_branches           : integer;
    c1branch_length_type     : integer;
    c1branch_length_constant : integer) return boolean;

  function get_integer_vector_from_mif(really_read_mif : boolean;
                                       mif_name        : string;
                                       mif_depth       : integer;
                                       mif_width       : integer)
    return integer_vector;

  function get_sum(a : integer_vector) return integer;

  function get_max(a : integer_vector) return integer;

  function get_branch_length_vector(ccmode                   : integer;
                                    ccnum_branches           : integer;
                                    ccbranch_length_constant : integer)
    return integer_vector;

  function calc_branch_start_vector(branch_length_vector : integer_vector)
    return integer_vector;

  function calc_branch_read_start_vector(branch_length_vector : integer_vector)
    return integer_vector;

  function calc_branch_end_vector(branch_length_vector : integer_vector)
    return integer_vector;

  function integer_to_std_logic_vector(
    value, bitwidth : integer) return std_logic_vector;

  function std_logic_vector_to_natural(
    in_val : in std_logic_vector) return natural;

  function select_val(i0  : integer;
                      i1  : integer;
                      sel : boolean) return integer;

  function calc_wss_delay(pruned          : boolean;
                          block_size_type : integer;
                          col_type        : integer;
                          row_type        : integer) return integer;

  function calc_xvalid_buffer_length(wss_delay       : integer;
                                     block_size_type : integer;
                                     col_type        : integer;
                                     row_type        : integer) return integer;

  function get_max_bm_depth(width    : integer) return integer;

  function get_mem_depth(required_depth : integer;
                         mem_style      : integer) return integer;

  function get_mem_depth_dp(reqd_depth : integer;
                            mem_style  : integer) return integer;

  function get_memstyle(depth    : integer;
                        width    : integer;
                        style    : integer;
                        mem_type : integer;
                        smart    : boolean) return integer;

------------------------------------------------------------------------------
-- calculate fdo latency, which is a FUNCTION of the length of branch 0
--
  function calc_fdo_proc_delay(
    numbranches   : integer;
    branchlength0 : integer) return integer;

  function get_max_num_branches(
    ccnum_configurations : integer;
    ccnum_branches       : integer;
    ccmif_width          : integer;
    ccbranch_length_file : string) return integer;


  function calc_wsip_delay(c_use_row_permute_file : integer;
                           c_use_col_permute_file : integer) return integer;

  function calc_wss_delay(c_block_size_type : integer;
                          c_col_type        : integer;
                          c_row_type        : integer) return integer;

  
  function get_latency(c_type                 : integer;
                       c_row_type             : integer;
                       c_use_row_permute_file : integer;
                       c_col_type             : integer;
                       c_use_col_permute_file : integer;
                       c_block_size_type      : integer;
                       c_pipe_level           : integer;
                       c_external_ram         : integer) return integer;


FUNCTION get_min_input_block_size(c_block_size_constant : INTEGER;
                                  min_num_rows          : INTEGER;
                                  min_num_cols          : INTEGER;
                                  c_row_type            : INTEGER;
                                  c_col_type            : INTEGER;
                                  block_size_type       : INTEGER)
  RETURN INTEGER;

  function power_of_2(x : integer) return boolean;

  FUNCTION max_of(i0, i1 : INTEGER) RETURN INTEGER;
  
end sid_pkg_behav_v7_0;

package body sid_pkg_behav_v7_0 is
  --------------------------------------------------------------------------------
  --
  -- AXI Functions and Procedures
  --
  --------------------------------------------------------------------------------

  -- How many padding bytes are there in this field
  --
  function how_much_padding(field_width : integer) return integer is
    variable padding_bits : integer := 0;
  begin
    if field_width mod 8 = 0 then
      padding_bits := 0;
    else
      padding_bits :=  8 - (field_width mod 8);
    end if;
    return padding_bits;
  end how_much_padding;


  
  
  -- Returns the with of the Data Output channel when there's no padding.  It's used to calculate the width of the FIFO
  --
  function calculate_dout_chan_width_no_padding(constant C_TYPE            : in integer;
                                                constant C_SYMBOL_WIDTH    : in integer;
                                                constant C_HAS_RDY         : in integer;
                                                constant C_HAS_BLOCK_START : in integer;
                                                constant C_HAS_BLOCK_END   : in integer;
                                                constant C_HAS_FDO         : in integer) return integer is
    variable width : integer := 0;
  begin

    -- The information to be transfered is:
    -- TLAST       (1 bit)
    -- TDATA       (c_symbol_width)
    --
    -- FDO         (1 bit).  Only in Forney mode and only if c_has_fdo = 1.
    -- RDY         (1 bit).  Only in Forney mode.  
    --
    -- BLOCK_START (1 bit).  Only in Rectangular mode and only if c_has_block_start = 1.
    -- BLOCK_END   (1 bit).  Only in Rectangular mode and only if c_has_block_end = 1.



    width := C_SYMBOL_WIDTH + 1;  -- Data + TLAST

    if C_TYPE = c_forney_convolutional then
      if C_HAS_FDO = 1 then
        width := width + 1;
      end if;
  
      if C_HAS_RDY = 1 then
        width := width + 1;
      end if;
    end if;

    if C_TYPE = c_rectangular_block then
      if C_HAS_BLOCK_START = 1 then
        width := width + 1;
      end if;

      if C_HAS_BLOCK_END = 1 then
        width := width + 1;
      end if;
    end if;

    return width; 
  end function;

    

  -- Split the output of the Control Channel FIFO into fields for the Processing Engine. 
  -- Padding has not been previously removed, so do that here.
  --  
  procedure axi_chan_ctrl_convert_fifo_out_to_pe_in (constant fifo_vector           : in std_logic_vector;
                                                     signal   config_sel            : out std_logic_vector;
                                                     signal   row                   : out std_logic_vector;
                                                     signal   row_sel               : out std_logic_vector;
                                                     signal   col                   : out std_logic_vector;
                                                     signal   col_sel               : out std_logic_vector;
                                                     signal   block_size            : out std_logic_vector;
                                                     constant C_TYPE                : in integer;
                                                     constant C_NUM_CONFIGURATIONS  : in integer;
                                                     constant C_HAS_ROW             : in integer;
                                                     constant C_HAS_ROW_SEL         : in integer;
                                                     constant C_HAS_COL             : in integer;
                                                     constant C_HAS_COL_SEL         : in integer;
                                                     constant C_HAS_BLOCK_SIZE      : in integer;
                                                     constant C_ROW_WIDTH           : in integer;
                                                     constant C_NUM_SELECTABLE_ROWS : in integer;
                                                     constant C_COL_WIDTH           : in integer;
                                                     constant C_NUM_SELECTABLE_COLS : in integer;
                                                     constant C_BLOCK_SIZE_WIDTH    : in integer) is

    variable in_ptr        : integer := 0; -- The position of the next field in the input (padded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
    variable padding_width : integer;      -- Holds the width of the padding for the field we're working on and makes the code more consistent
    
    
  begin


    -- The FIFO vector is packed from LSB to MSB as:
    --
    -- config_sel when c_type = c_forney_convolutional and c_num_configurations > 1
    -- ROW        when c_type = c_rectangular_block and c_has_row        = 1
    -- ROW_SEL    when c_type = c_rectangular_block and c_has_row_sel    = 1
    -- COL        when c_type = c_rectangular_block and c_has_col        = 1
    -- COL_SEL    when c_type = c_rectangular_block and c_has_col_sel    = 1
    -- BLOCK_SIZE when c_type = c_rectangular_block and c_has_block_size = 1
    
    
    if C_TYPE = c_forney_convolutional then
      
      if c_num_configurations > 1 then
        -- We have a config_sel field
        field_width := bits_needed_to_represent(c_num_configurations-1);
        
        config_sel <= fifo_vector(field_width-1 downto 0);
      end if;
    else
      -- We have a rectangular core
      
      -- ROW Field
      --
      if c_has_row = 1 then
        field_width   := c_row_width;
        padding_width := how_much_padding(field_width);
        
        row <= fifo_vector(in_ptr + field_width-1 downto in_ptr);
        
        -- Move the pointer to the start of the next field
        --
        in_ptr := in_ptr + field_width + padding_width; 
      end if;
      
      
      -- ROW_SEL Field
      --
      if c_has_row_sel = 1 then
        field_width   := bits_needed_to_represent(c_num_selectable_rows-1);
        padding_width := how_much_padding(field_width);
        
        row_sel <= fifo_vector(in_ptr + field_width-1 downto in_ptr);
        
        -- Move the pointer to the start of the next field
        --
        in_ptr := in_ptr + field_width + padding_width; 
      end if;
      
      
      
      -- COL Field
      --
      if c_has_col = 1 then
        field_width   := c_col_width;
        padding_width := how_much_padding(field_width);

        col <= fifo_vector(in_ptr + field_width-1 downto in_ptr);
        
        -- Move the pointer to the start of the next field
        --
        in_ptr := in_ptr + field_width + padding_width; 
      end if;
      
      
      -- COL_SEL Field
      --
      if c_has_col_sel = 1 then
        field_width   := bits_needed_to_represent(c_num_selectable_cols-1);
        padding_width := how_much_padding(field_width);
        
        col_sel <= fifo_vector(in_ptr + field_width-1 downto in_ptr);
        
        -- Move the pointer to the start of the next field
        --
        in_ptr := in_ptr + field_width + padding_width; 
      end if;
      
      
      
      -- BLOCK_SIZE Field
      --
      if c_has_block_size = 1 then
        field_width   := c_block_size_width;
        padding_width := how_much_padding(field_width);
        
        block_size <= fifo_vector(in_ptr + field_width-1 downto in_ptr);
        
        -- Move the pointer to the start of the next field
        --
        in_ptr := in_ptr + field_width + padding_width; 
      end if;
    end if;
  end procedure;
    
    
    
  procedure axi_chan_din_convert_fifo_out_to_pe_in  (constant fifo_vector           : in std_logic_vector;
                                                     signal   data                  : out std_logic_vector;
                                                     signal   tlast                 : out std_logic;
                                                     constant C_SYMBOL_WIDTH        : in integer) is
    variable in_ptr        : integer := 0; -- The position of the next field in the input (padded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
        
  begin

    -- The FIFO vector is packed from LSB to MSB as:
    -- TLAST (1 bit)
    -- TDATA (data = c_symbol_width + padding)
    --

    -- TLAST
    --
    field_width   := 1;
    tlast         <= fifo_vector(in_ptr);
    in_ptr        := in_ptr + field_width;


    -- Data in TDATA
    --
    field_width   := c_symbol_width;
    data          <= fifo_vector(in_ptr + c_symbol_width -1 downto in_ptr);
  end procedure;
    

  

  -- Takes all of the (relevant) outputs of the core and packages them into a single vector to get stored in
  -- the data out FIFO.  It does not add padding as that isn't stored in the FIFO.
  --
  procedure axi_chan_dout_build_fifo_in_vector(signal tlast_in            : in std_logic;
                                               signal dout                : in std_logic_vector;
                                               signal ndo                 : in std_logic;
                                               signal fdo                 : in std_logic;
                                               signal rdy                 : in std_logic;
                                               signal block_start         : in std_logic;
                                               signal block_end           : in std_logic;
                                               signal out_vector          : out std_logic_vector;
                                               constant C_TYPE            : in integer;
                                               constant C_SYMBOL_WIDTH    : in integer;
                                               constant C_HAS_RDY         : in integer;
                                               constant C_HAS_BLOCK_START : in integer;
                                               constant C_HAS_BLOCK_END   : in integer;
                                               constant C_HAS_FDO         : in integer) is
    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
  begin

    -- The output vector is packed from LSB to MSB as follows:
    -- TLAST       (1 bit)
    -- TDATA       (c_symbol_width)
    --
    -- FDO         (1 bit).  Only in Forney mode and only if c_has_fdo = 1.
    -- RDY         (1 bit).  Only in Forney mode.  
    --
    -- BLOCK_START (1 bit).  Only in Rectangular mode and only if c_has_block_start = 1.
    -- BLOCK_END   (1 bit).  Only in Rectangular mode and only if c_has_block_end = 1.


    --
    -- There is no padding, as this will get stored in a FIFO


    -- TLAST
    -- ------
    field_width                                       := 1;
    out_vector(out_ptr)                               <= tlast_in;
    out_ptr                                           := out_ptr + field_width;


    -- DATA
    field_width                                         := C_SYMBOL_WIDTH;
    out_vector(out_ptr + field_width -1 downto out_ptr) <= dout;
    out_ptr                                             := out_ptr + field_width;



    if C_TYPE = c_forney_convolutional then
      if C_HAS_FDO = 1 then
        field_width         := 1;
        out_vector(out_ptr) <= fdo;
        out_ptr             := out_ptr + field_width;
      end if;

      if C_HAS_RDY = 1 then
        field_width         := 1;
        out_vector(out_ptr) <= rdy;
        out_ptr             := out_ptr + field_width;
      end if;
    end if;

    if C_TYPE = c_rectangular_block then
      if C_HAS_BLOCK_START = 1 then
        field_width         := 1;
        out_vector(out_ptr) <= block_start;
        out_ptr             := out_ptr + field_width;
      end if;

      if C_HAS_BLOCK_END = 1 then
        field_width         := 1;
        out_vector(out_ptr) <= block_end;
        out_ptr             := out_ptr + field_width;
      end if;
    end if;
  end procedure;



  -- Splits the Data Output Channel FIFO output into AXI signals, adding padding between
  -- the various fields where required by the AXI rules
  --
  procedure axi_chan_dout_convert_fifo_out_vector_to_axi (fifo_vector       : in std_logic_vector;
                                                          signal tdata      : out std_logic_vector;
                                                          signal tuser      : out std_logic_vector;
                                                          signal tlast      : out std_logic;
                                                          C_TYPE            : in integer;
                                                          C_SYMBOL_WIDTH    : in integer;
                                                          C_HAS_RDY         : in integer;
                                                          C_HAS_BLOCK_START : in integer;
                                                          C_HAS_BLOCK_END   : in integer;
                                                          C_HAS_FDO         : in integer) is




    variable in_ptr        : integer := 0; -- The position of the next field in the input (padded) vector
    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
    variable padding_width : integer;      -- Holds the width of the padding we're working on and makes the code more consistent
    variable sign_bit      : std_logic;    -- The sign bit we're using to extend

  begin
    -- The FIFO vector is packed from LSB to MSB as:
    -- TLAST       (1 bit)
    -- TDATA       (c_symbol_width)
    --
    -- FDO         (1 bit).  Only in Forney mode and only if c_has_fdo = 1.
    -- RDY         (1 bit).  Only in Forney mode.  
    --
    -- BLOCK_START (1 bit).  Only in Rectangular mode and only if c_has_block_start = 1.
    -- BLOCK_END   (1 bit).  Only in Rectangular mode and only if c_has_block_end = 1.


    
    in_ptr        := 0;

    -- TLAST
    -- ------
    field_width := 1;
    tlast       <= fifo_vector(in_ptr);
    in_ptr      := in_ptr + field_width;

    
    -- TDATA
    -- -----
    -- The DOUT field needs to be sign extended to an 8 bit boundary
    -- The chan_out and chan_synch fields will be 0 extended to an 8 bit boundary
    
    field_width   := C_SYMBOL_WIDTH;
    padding_width := how_much_padding(field_width);
    out_ptr       := 0;
    
    -- Copy DOUT
    tdata(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
    out_ptr                                        := out_ptr + field_width;

    -- Add padding
    sign_bit := fifo_vector(in_ptr + field_width - 1);
    for p in 0 to padding_width - 1 loop
      tdata(out_ptr) <= sign_bit;
      out_ptr := out_ptr + 1;
    end loop; 

    in_ptr                                         := in_ptr + field_width;


    -- TUSER
    -- -----
    out_ptr       := 0;

    if C_TYPE = c_forney_convolutional then
      if C_HAS_FDO = 1 then
        field_width                                    := 1;
        tuser(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
        out_ptr                                        := out_ptr + field_width;
        in_ptr                                         := in_ptr  + field_width;
      end if;
  
      if C_HAS_RDY = 1 then
        field_width                                    := 1;
        tuser(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
        out_ptr                                        := out_ptr + field_width;
        in_ptr                                         := in_ptr  + field_width;
      end if;
    end if;

    if C_TYPE = c_rectangular_block then
      if C_HAS_BLOCK_START = 1 then
        field_width                                    := 1;
        tuser(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
        out_ptr                                        := out_ptr + field_width;
        in_ptr                                         := in_ptr  + field_width;
      end if;

      if C_HAS_BLOCK_END = 1 then
        field_width                                    := 1;
        tuser(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
        out_ptr                                        := out_ptr + field_width;
        in_ptr                                         := in_ptr  + field_width;
      end if;
    end if;
  end procedure;

--------------------------------------------------------------------------------
-- Gets the minimum value from an array of integers
--------------------------------------------------------------------------------
  function get_min(a : integer_vector) return integer is
    variable min : integer;
  begin
    min := a(a'low);
    for i in a'low to a'high loop
      if a(i) < min then
        min := a(i);
      end if;
    end loop;
    return min;
  end get_min;


--------------------------------------------------------------------------------
--
-- This function returns the maximum number of rows (or columns) for the 
-- rectangular block type for given values of c_x_type, c_x_constant,
-- c_x_width and selectable_x_vector, where x refers to row or col. 
-- The selectable_x_vector contains integers values corresponding to the
-- values read from a mif.
--
--------------------------------------------------------------------------------
  function get_max_dimension(dimension_type     : integer;
                             dimension_constant : integer;
                             dimension_width    : integer;
                             selectable_vector  : integer_vector) 
    return integer is
    variable result : integer;
  begin
    --
    -- Find which parameters are relevant for defining the maximum number of
    -- rows or columns
    --
    if (dimension_type = c_constant) then
      result := dimension_constant;
    elsif (dimension_type = c_variable) then
      result := 2**dimension_width - 1;
    elsif (dimension_type = c_selectable) then
      result := get_max(selectable_vector);
    else                                -- throw error
      assert false
        report "ERROR: sid_v7_0 - get_max_dimension(): dimension_type not supported!"
        severity failure;
    end if;

    return result;
  end get_max_dimension;

--------------------------------------------------------------------------------
--
-- This function returns the minimum number of rows (or columns) for the 
-- rectangular block type for given values of c_x_type, c_x_constant,
-- c_x_width and selectable_x_vector, where x refers to row or col. 
-- The selectable_x_vector contains integers values corresponding to the
-- values read from a mif.
--
--------------------------------------------------------------------------------
  function get_min_dimension(dimension_type     : integer;
                             dimension_constant : integer;
                             dimension_width    : integer;
                             dimension_min      : integer;
                             selectable_vector  : integer_vector) 
    return integer is
    variable result : integer;
  begin
    --
    -- Find which parameters are relevant for defining the minimum number of
    -- rows or columns
    --
    if (dimension_type = c_constant) then
      result := dimension_constant;
    elsif (dimension_type = c_variable) then
      result := dimension_min;
    elsif (dimension_type = c_selectable) then
      result := get_min(selectable_vector);
    else                                -- throw error
      assert false
        report "ERROR: sid - get_min_dimension(): dimension_type = " &
        integer'image(dimension_type) & " not supported!"
        severity failure;
    end if;

    return result;
  end function get_min_dimension;

  
--------------------------------------------------------------------------------
-- Return maximum number of symbols in a rectangular block
--
  function get_max_block_size(max_rows              : integer;
                              max_cols              : integer;
                              c_block_size_constant : integer;
                              c_block_size_type     : integer;
                              c_block_size_width    : integer) return integer is
    variable return_val : integer := 0;
  begin
    if c_block_size_type = c_row_x_col then
      return_val := max_rows * max_cols;
    elsif c_block_size_type = c_constant then
      return_val := c_block_size_constant;
    elsif c_block_size_type = c_variable then
      return_val := 2**c_block_size_width-1;
    else
      assert false
        report "ERROR: sid_v7_0 - get_max_block_size() Invalid block_size." & new_line
        severity failure;
    end if;

    return return_val;
  end get_max_block_size;

--------------------------------------------------------------------------------
-- Return minimum possible block size that may be input
--
FUNCTION get_min_input_block_size(c_block_size_constant : INTEGER;
                                  min_num_rows          : INTEGER;
                                  min_num_cols          : INTEGER;
                                  c_row_type            : INTEGER;
                                  c_col_type            : INTEGER;
                                  block_size_type       : INTEGER)
  RETURN INTEGER IS
BEGIN
  IF block_size_type = c_constant THEN
    RETURN c_block_size_constant;
  ELSIF block_size_type = c_row_x_col THEN
    -- Variable rows or columns may have 0's input
    IF c_row_type = c_variable OR c_col_type = c_variable THEN
      RETURN 0;
    ELSE
      -- rows and cols must be constant or selectable
      RETURN min_num_rows * min_num_cols;
    END IF; -- c_row_type ...
  ELSE
    -- block_size_type must be variable
    RETURN 0;
  END IF;
END get_min_input_block_size;


--------------------------------------------------------------------------------  
-- Return TRUE if x is a power of 2  
--------------------------------------------------------------------------------  
  function power_of_2(x : integer) return boolean is
    variable y : integer;
  begin

    if x <= 1 then
      return false;
    else
      
      y := x;
      while (y /= 1) loop
        
        if y mod 2 /= 0 then
          return false;
        end if;

        y := y/2;
        
      end loop;

      return true;
    end if;  -- x = 1
  end power_of_2;


--------------------------------------------------------------------------------
-- Return i0 if sel = 0, i1 if sel = 1
--------------------------------------------------------------------------------
FUNCTION max_of(i0, i1 : INTEGER) RETURN INTEGER IS
BEGIN
  IF (i0 > i1) THEN
    RETURN i0;
  ELSE
    RETURN i1;
  END IF;
END max_of;

--------------------------------------------------------------------------------
-- Convert INTEGER to STRING
--------------------------------------------------------------------------------
  function integer_to_string(int_value : integer) return string is

    variable digit        : integer;
    variable value        : integer;
    variable length       : integer         := 0;
    variable posn         : integer;
    variable start_length : integer;
    constant str          : string(1 to 10) := "0123456789";
    variable ret_value    : string(1 to 11);

  begin

    if int_value < 0 then
      -- Largest possible negative number
      if int_value < -2147483647 then
        return ("less than VHDL minimum INTEGER value");
      else
        value        := -1 * int_value;
        start_length := 1;
        ret_value(1) := '-';
      end if;
    else
      value        := int_value;
      start_length := 0;
    end if;

    if (value = 0) then
      return "0";
    elsif (value < 10) then
      length := 1 + start_length;
    elsif (value < 100) then
      length := 2 + start_length;
    elsif (value < 1000) then
      length := 3 + start_length;
    elsif (value < 10000) then
      length := 4 + start_length;
    elsif (value < 100000) then
      length := 5 + start_length;
    elsif (value < 1000000) then
      length := 6 + start_length;
    elsif (value < 10000000) then
      length := 7 + start_length;
    elsif (value < 100000000) then
      length := 8 + start_length;
    elsif (value < 1000000000) then
      length := 9 + start_length;
    else
      length := 10 + start_length;
    end if;

    if (length > 0) then  -- Required because Metamor bombs without it
      posn := length;
      while (value /= 0) loop
        digit           := value mod 10;
        ret_value(posn) := str(digit+1);
        value           := value/10;
        posn            := posn - 1;
      end loop;
    end if;

    return ret_value(1 to length);

  end integer_to_string;

--------------------------------------------------------------------------------
-- Return number of bits required to represent the supplied parameter
--------------------------------------------------------------------------------
  function bits_needed_to_represent(a_value : natural) return natural is
    variable return_value : natural := 1;
  begin

    for i in 30 downto 0 loop
      if a_value >= 2**i then
        return_value := i+1;
        exit;
      end if;
    end loop;

    return return_value;

  end bits_needed_to_represent;

--------------------------------------------------------------------------------
-- Return i0 if sel = FALSE, i1 if sel = TRUE
--------------------------------------------------------------------------------
  function select_integer(i0  : integer;
                          i1  : integer;
                          sel : boolean) return integer is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if;  -- sel
  end select_integer;


------------------------------------------------------------------------------
-- Gets the maximum value from an array of integers
------------------------------------------------------------------------------
  function get_max(a : integer_vector) return integer is
    variable max : integer;
  begin
    max := integer'low;
    for i in a'low to a'high loop
      if a(i) > max then
        max := a(i);
      end if;
    end loop;
    return max;
  end get_max;

--------------------------------------------------------------------------------
-- Return 2's complement of input vector
--------------------------------------------------------------------------------
  function two_comp(vect : std_logic_vector) return std_logic_vector is
    variable local_vect : std_logic_vector(vect'high downto 0);
    variable toggle     : integer := 0;
  begin

    for i in 0 to vect'high loop
      if (toggle = 1) then
        if (vect(i) = '0') then
          local_vect(i) := '1';
        else
          local_vect(i) := '0';
        end if;
      else
        local_vect(i) := vect(i);
        if (vect(i) = '1') then
          toggle := 1;
        end if;
      end if;
    end loop;

    return local_vect;
  end two_comp;


  ------------------------------------------------------------------------------
  --
  -- This FUNCTION checks the values entered for the forney_convolutional
  -- core's GENERICs
  --
  ------------------------------------------------------------------------------
  function check_forney_generics(
    c1mode                   : integer;
    c1symbol_width           : integer;
    c1num_branches           : integer;
    c1branch_length_type     : integer;
    c1branch_length_constant : integer) return boolean is

  begin
    assert (c1mode = c_interleaver or c1mode = c_deinterleaver)
      report "ERROR: sid_v7_0 - c_mode must be either " &
      integer_to_string(c_interleaver) & " or " &
      integer_to_string(c_deinterleaver) & new_line
      severity failure;
    
    assert (c1symbol_width >= min_symbol_width and
            c1symbol_width <= max_symbol_width)
      report "ERROR: sid_v7_0 - c_symbol_width must be in range " &
      integer_to_string(min_symbol_width) & " to " &
      integer_to_string(max_symbol_width) & new_line
      severity failure;
    
    assert (c1num_branches >= abs_min_num_branches and
            c1num_branches <= abs_max_num_branches)
      report "ERROR: sid_v7_0 - c_num_branches must be in range " &
      integer_to_string(abs_min_num_branches) & " to " &
      integer_to_string(abs_max_num_branches) & new_line
      severity failure;
    
    assert (c1branch_length_type = c_constant or c1branch_length_type = c_file)
      report "ERROR: c_branch_length_type = " &
      integer_to_string(c1branch_length_type) & " is not supported."
      severity failure;
    
    assert no_debug
      report new_line &
      "upper_branch_length_constant = " &
      integer_to_string(upper_branch_length_constant) & new_line
      severity note;

    assert (c1branch_length_constant >= min_branch_length_constant and
            c1branch_length_constant <= upper_branch_length_constant)
      report "ERROR: sid_v7_0 - c_branch_length_constant must be in range " &
      integer_to_string(min_branch_length_constant) & " to " &
      integer_to_string(upper_branch_length_constant) & new_line
      severity failure;
    
    return true;
  end check_forney_generics;

--------------------------------------------------------------------------------
-- Convert BIT_VECTOR to INTEGER
-- BIT_VECTOR must have a descending range and be in 2's complement notation
--------------------------------------------------------------------------------
  function bit_vector_to_integer(
    bv : in bit_vector) 
    return integer is
    variable found_msb       : boolean := false;
    variable msb             : integer := 0;
    variable unsigned_result : integer := 0;
  begin
    if bv'length > 32 then
      assert false
        report "bit_vector_to_integer FUNCTION doesn't support bv_element_length > 32"
        severity failure;
    end if;
    found_msb := false;
    for i in bv'range loop
      if found_msb = true then
        unsigned_result := unsigned_result * 2 + bit'pos(bv(i));
        msb             := msb*2;
      else
        if bit'pos(bv(i)) = 1 then
          msb := -1;
        end if;
        found_msb := true;
      end if;
    end loop;
    return msb + unsigned_result;
  end bit_vector_to_integer;

  --------------------------------------------------------------------------------
  --
  -- convert bit_vector to integer_vector
  --
  --------------------------------------------------------------------------------
  function bit_vector_to_integer_vector(
    bv                : in bit_vector;
    bv_element_length : in integer)
    return integer_vector is
    constant bv_length : integer := bv'length;
    constant iv_length : integer := bv_length/bv_element_length;

    constant num_bits   : natural                                    := iv_length*bv_element_length;
    variable bv_element : bit_vector(bv_element_length - 1 downto 0) := (others => '0');
    variable result     : integer_vector(0 to iv_length - 1);
  begin
    if bv_element_length > 32 then
      assert false
        report "bit_vector_to_integer_vector FUNCTION doesn't support bv_element_length > 32"
        severity failure;
    end if;
    for ai in 0 to (iv_length - 1) loop  -- ai = address index
      -- build up element bit_vector
      for bi in (bv_element_length - 1) downto 0 loop
        bv_element(bi) := bv(ai*bv_element_length + bi);
      end loop;  -- bi
      result(ai) := bit_vector_to_integer(bv_element);
    end loop;  -- ai
    return result;
  end bit_vector_to_integer_vector;

  function get_integer_vector_from_mif(
    really_read_mif : boolean;
    mif_name        : string;
    mif_depth       : integer;
    mif_width       : integer)
    return integer_vector is
    variable bv : bit_vector((mif_depth*mif_width - 1) downto 0);
    variable iv : integer_vector(0 to (mif_depth - 1));
  begin
    if (really_read_mif) then
      bv := read_meminit_file(mif_name, mif_depth, mif_width, mif_depth);
      iv := bit_vector_to_integer_vector(bv, mif_width);
    end if;
    return iv;
  end get_integer_vector_from_mif;

  --------------------------------------------------------------------------------
  -- Gets the sum of an array of integers
  --------------------------------------------------------------------------------
  function get_sum(a : integer_vector) return integer is
    variable sum : integer;
  begin
    sum := 0;
    for i in a'range loop
      sum := sum + a(i);
    end loop;
    return sum;
  end get_sum;

  --------------------------------------------------------------------------------
  function get_branch_length_vector(
    ccmode         : integer;
    ccnum_branches : integer;

    ccbranch_length_constant : integer)

    return integer_vector is
    variable result : INTEGER_VECTOR(0 to (ccnum_branches - 1));
    -- all mif files shall have mif_width bits per line

  begin

    if ccmode = c_interleaver then
      for bi in 0 to ccnum_branches - 1 loop
        --
        -- the extra 1 in the following equation takes account of the 
        -- extra level of pipelining added to each branch so that
        -- location zero can be used for the first branch.
        --
        result(bi) := bi*ccbranch_length_constant + 1;
      end loop;  -- bit
    elsif ccmode = c_deinterleaver then
      for bi in 0 to ccnum_branches - 1 loop
        result(bi) := (ccnum_branches - 1 - bi)*ccbranch_length_constant + 1;
      end loop;  -- bit
    else                                -- catch errant ccmode values
      assert false
        report "c_mode = " & integer_to_string(ccmode) & " is not supported!"
        severity failure;
    end if;

    return result;
  end get_branch_length_vector;

  --------------------------------------------------------------------------------
  function calc_branch_start_vector(
    branch_length_vector : integer_vector)
    return integer_vector is
    variable result : integer_vector(0 to branch_length_vector'high);
  begin
    result(0) := 0;
    for i in 0 to branch_length_vector'high - 1 loop
      result(i+1) := result(i) + branch_length_vector(i);
    end loop;
    return result;
  end calc_branch_start_vector;

  --------------------------------------------------------------------------------
  function calc_branch_end_vector(
    branch_length_vector : integer_vector)
    return integer_vector is
    variable result : integer_vector(0 to branch_length_vector'high);
  begin
    result(0) := branch_length_vector(0)-1;
    for i in 0 to branch_length_vector'high - 1 loop
      result(i+1) := result(i) + branch_length_vector(i+1);
    end loop;
    return result;
  end calc_branch_end_vector;

  --------------------------------------------------------------------------------
  function calc_branch_read_start_vector(
    branch_length_vector : integer_vector)
    return integer_vector is
    variable result              : integer_vector(0 to branch_length_vector'high);
    variable branch_start_vector : integer_vector(0 to branch_length_vector'high);
  begin
    branch_start_vector(0) := 0;
    for i in 0 to branch_length_vector'high - 1 loop
      branch_start_vector(i+1) := branch_start_vector(i) + branch_length_vector(i);
    end loop;
    for i in 0 to branch_length_vector'high loop
      if branch_length_vector(i) = 1 then
        result(i) := branch_start_vector(i);
      else
        result(i) := branch_start_vector(i) + 1;
      end if;
    end loop;
    return result;
  end calc_branch_read_start_vector;

  --------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Convert INTEGER to a STD_LOGIC_VECTOR
--------------------------------------------------------------------------------
  function integer_to_std_logic_vector(value, bitwidth : integer)
    return std_logic_vector is

    variable running_value  : integer := value;
    variable running_result : std_logic_vector(bitwidth-1 downto 0);
  begin

    if (value < 0) then
      running_value := -1 * value;
    end if;

    for i in 0 to bitwidth-1 loop

      if running_value mod 2 = 0 then
        running_result(i) := '0';
      else
        running_result(i) := '1';
      end if;
      running_value := running_value/2;
    end loop;

    if (value < 0) then                 -- find the 2s complement
      return two_comp(running_result);
    else
      return running_result;
    end if;

  end integer_to_std_logic_vector;

--------------------------------------------------------------------------------
-- Convert STD_LOGIC_VECTOR to NATURAL
--------------------------------------------------------------------------------
  function std_logic_vector_to_natural(in_val : in std_logic_vector) return natural is
    variable result  : natural := 0;
    variable failure : boolean := false;
  begin
    for i in in_val'range loop
      result := result * 2;

      if (in_val(i) = '1' or in_val(i) = 'H') then
        result := result + 1;
      elsif (in_val(i) /= '0' and in_val(i) /= 'L') then
        failure := true;
      end if;
    end loop;

    if failure then
      assert false
        report "ERROR: std_logic_vector_to_natural: There is a non-numeric bit in the argument."&
        " It has been converted to 0."
        severity warning;
    end if;

    return result;
  end std_logic_vector_to_natural;

  --------------------------------------------------------------------------------
  --
  -- calculate the variable part of the delay for rectangular block type
  --
  -- Function identical to that used in the structural code.
  --------------------------------------------------------------------------------
  function calc_wss_delay(pruned          : boolean;
                          block_size_type : integer;
                          col_type        : integer;
                          row_type        : integer) return integer is
    variable wss_delay_val : integer;
  begin
    if not(pruned) or block_size_type = c_constant then
      wss_delay_val := 1;
    elsif col_type = c_constant and row_type = c_constant then
      wss_delay_val := 3;
    else
      wss_delay_val := 6;
    end if;
    return wss_delay_val;
  end calc_wss_delay;


  --------------------------------------------------------------------------------
  --
  -- Function to calculate the (row_valid etc) buffer length
  --------------------------------------------------------------------------------
  function calc_xvalid_buffer_length(wss_delay       : integer;
                                     block_size_type : integer;
                                     col_type        : integer;
                                     row_type        : integer) return integer is

    variable valid_delay_val : integer;
  begin

    valid_delay_val := wss_delay+1;

    if block_size_type = c_row_x_col then
      
      if (row_type = c_selectable or col_type = c_selectable) then
        -- Possible 2 extra cycles required due to delay line on
        -- row_x_col_block_size enable in rfd generation circuit
        valid_delay_val := valid_delay_val+2;
      end if;
      
    end if;  -- c_block_size_type

    return valid_delay_val;
  end calc_xvalid_buffer_length;

--------------------------------------------------------------------------------
  function get_mem_depth(required_depth : integer;
                         mem_style      : integer) return integer is
    variable extra      : natural;
    variable addr_width : natural;
    variable result     : integer := 0;
  begin
    if mem_style = c_distmem then
      extra := required_depth mod 16;
      if (extra = 0) then
        result := required_depth;
      else
        result := (required_depth + 16 - extra);
      end if;
    elsif mem_style = c_blockmem then
      -- block mems must be 16, 32, 64, 128, 256 or n * 256 deep
      if required_depth <= 16 then
        result := 16;
      elsif required_depth <= 256 then
        result := 2**(bits_needed_to_represent(required_depth-1));
      else
        result := 256 + (256 * ((required_depth-1)/256));
      end if;  -- required_depth
    end if;  -- mem_style

    return result;
  end get_mem_depth;

--------------------------------------------------------------------------------
-- 
-- Dual-port block memory must be a multiple of 16 for dist mem and 256
-- for block mem.
--
--------------------------------------------------------------------------------
  function get_mem_depth_dp(reqd_depth : integer;
                            mem_style  : integer) return integer is
    variable extra  : natural;
    variable result : integer := 0;
  begin
    if mem_style = c_distmem then
      extra := reqd_depth mod 16;
      if (extra = 0) then
        result := reqd_depth;
      else
        result := (reqd_depth + 16 - extra);
      end if;
    elsif mem_style = c_blockmem then
      extra := reqd_depth mod 256;
      if (extra = 0) then
        result := reqd_depth;
      else
        result := (reqd_depth + 256 - extra);
      end if;
    end if;  -- mem_style

    return result;
  end get_mem_depth_dp;

--------------------------------------------------------------------------------
-- Return maximum depth of block memory for a given width
-- These numbers were obtained from the block mem GUIs.
--------------------------------------------------------------------------------
  function get_max_bm_depth(width    : integer) return integer is
    variable max_depth : integer;
  begin
    if width < 4 then
      max_depth := 262144;
    elsif width < 7 then
      max_depth := 131072;
    elsif width < 13 then
      max_depth := 65536;
    elsif width < 25 then
      max_depth := 32768;
    elsif width < 49 then
      max_depth := 16384;
    elsif width < 97 then
      max_depth := 8192;
    elsif width < 193 then
      max_depth := 4096;
    else
      max_depth := 2048;
    end if;

    return max_depth * 4;

    
  end get_max_bm_depth;

--------------------------------------------------------------------------------
  function get_memstyle(depth    : integer;
                        width    : integer;
                        style    : integer;
                        mem_type : integer;
                        smart    : boolean) return integer is
    variable max_bm_depth           : integer;
    variable mem_size               : integer;
    variable result                 : integer := c_distmem;
    variable actual_block_mem_depth : integer;
    variable actual_dist_mem_depth  : integer;
  begin
    max_bm_depth := get_max_bm_depth(width);

    -- Round up to actual depth required for each memory style
    actual_dist_mem_depth  := get_mem_depth(depth, c_distmem);
    actual_block_mem_depth := get_mem_depth(depth, c_blockmem);

    -- Check depth doesn't exceed limits
    if (actual_dist_mem_depth > max_dm_depth_vx2 and
        actual_block_mem_depth <= max_bm_depth) then
      result := c_blockmem;
      
    elsif (actual_block_mem_depth > max_bm_depth and
           actual_dist_mem_depth <= max_dm_depth_vx2) then

      result := c_distmem;
      
    else
      -- If depth didn't exceed max limits then determine style to use based
      -- on size and style parameter
      mem_size := actual_dist_mem_depth * width;
      -- Return value depends on memory size
      if mem_type = c_dp_ram then
        mem_size := mem_size * 2;       -- Only actually true for dist mem
      end if;

      if style = c_distmem then
        result := c_distmem;
        
      elsif style = c_blockmem then
        if smart then
          if mem_size <= 64 then
            result := c_distmem;
          else
            result := c_blockmem;
          end if;  -- mem_size
        else
          result := c_blockmem;
        end if;  -- smart
        
      elsif style = c_automatic then
        if mem_size <= 512 then
          result := c_distmem;
        else
          result := c_blockmem;
        end if;
      end if;  -- style
      
    end if;  
    return result;
  end get_memstyle;


--------------------------------------------------------------------------------
-- Return i0 if sel = FALSE, i1 if sel = TRUE
--------------------------------------------------------------------------------
  function select_val(i0 : integer; i1 : integer; sel : boolean) return integer is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if;  -- sel
  end select_val;


------------------------------------------------------------------------------
-- calculate fdo latency, which is a FUNCTION of the length of branch 0
--
  function calc_fdo_proc_delay(
    numbranches   : integer;
    branchlength0 : integer)
    return integer is

    variable result : integer := 999;
  begin
    if (branchlength0-1) = 0 then
      result := 1;
    else
      result := (branchlength0-1) * numbranches
                + 1;  --(The +1 is added for v3.1 because process fdo_proc is tidied up)  
    end if;
    return result;
  end calc_fdo_proc_delay;

--------------------------------------------------------------------------------
--Function to calculate the maximum number of branches
--------------------------------------------------------------------------------
  function get_max_num_branches(
    ccnum_configurations : integer;
    ccnum_branches       : integer;
    ccmif_width          : integer;
    ccbranch_length_file : string) return integer is

    variable num_branches_vector : INTEGER_VECTOR(0 to ccnum_configurations-1) := (others => 0);
    variable result              : integer                                     := 0;

  begin


    if ccnum_configurations = 1 then
      result := ccnum_branches;
    elsif ccnum_configurations > 1 then
      --The first ccnum_configurations entries are the number of branches vector.
      --If ccnum_configurations>1 and this constant is used to select
      --the number of branches, depending on the value on the config_sel port.
      --If ccnum_configurations>1 and ccbranch_length_type=c_file, this constant is
      --also used to find the total number of mif file values.
      num_branches_vector := get_integer_vector_from_mif(true,
                                                          ccbranch_length_file,
                                                          ccnum_configurations,
                                                          ccmif_width);

      result := 0;
      for cfg in 0 to ccnum_configurations-1 loop
        if num_branches_vector(cfg) > result then
          result := num_branches_vector(cfg);
        end if;
      end loop;
    else                                --ccnum_configurations<1 THEN
      --ERROR!    
      assert false
        report "c_num_configurations = " & integer_to_string(ccnum_configurations) & " is not supported!"
        severity failure;
    end if;
    return result;
  end get_max_num_branches;


  --------------------------------------------------------------------------------
-- wsip_delay is used in the rectangular block interleaver. It is the delay from
-- wsip to the symbol RAM write enable.
--
  function calc_wsip_delay(c_use_row_permute_file : integer;
                           c_use_col_permute_file : integer) return integer is
  begin

    -- Allow for extra delay of row/col permute ROM and select mux reg
    if c_use_col_permute_file /= 0 or c_use_row_permute_file /= 0 then
      return 3;
    else
      return 1;
    end if;
    
  end calc_wsip_delay;

--------------------------------------------------------------------------------
-- Calculate delay from first symbol flag to write sequence start
--
-- Note some of the code that calls this function relies on col and row
-- parameters being interchangable. i.e. int/de-int doesn't matter.
  function calc_wss_delay(c_block_size_type : integer;
                          c_col_type        : integer;
                          c_row_type        : integer) return integer is
    variable wss_delay_val : integer;
  begin

    if c_block_size_type = c_constant or c_block_size_type = c_row_x_col then
      wss_delay_val := 1;  -- cpl and rpl always compared to same values
    elsif c_col_type = c_constant and c_row_type = c_constant then
      -- If block_size_type = c_variable then block_size may change and
      -- affect cpl, but this happens within 1 cycle of fsf
      -- Allow extra cycles for block_size_hold to be sampled as this is
      -- used to check if block_size = 1
      wss_delay_val := 3;  -- cpl and rpl always compared to same values
    else
      wss_delay_val := 6;  -- Allow time for cpl and rpl to be calculated
    end if;

    return wss_delay_val;
  end calc_wss_delay;


--------------------------------------------------------------------------------
--
-- This function returns the latency for a given combination of the core's
-- GENERICs.
-- Currently only implemented for Forney Convolutional and Rectangular Block
-- int/deint
--
--------------------------------------------------------------------------------
  function get_latency(c_type                 : integer;
                       c_row_type             : integer;
                       c_use_row_permute_file : integer;
                       c_col_type             : integer;
                       c_use_col_permute_file : integer;
                       c_block_size_type      : integer;
                       c_pipe_level           : integer;
                       c_external_ram         : integer) return integer is

    variable result     : integer;
    variable wsip_delay : integer;
    variable wss_delay  : integer;
    
  begin
    if c_type = c_forney_convolutional then
      if c_pipe_level = c_minimum then
        result := 3;
      elsif c_pipe_level = c_medium then
        result := 4;
      else
        result := 5;                    -- Must be c_maximum
      end if;  -- c_pipe_level

      if c_external_ram /= 0 then
        result := result + 1;
      end if;  -- c_external_ram
      
    elsif c_type = c_rectangular_block then
      -- Latency is defined as number of +ve clock edges AFTER last sample has
      -- been taken before 1st output symbol appears.
      
      wss_delay := calc_wss_delay(c_block_size_type,
                                  c_col_type,
                                  c_row_type);

      wsip_delay := calc_wsip_delay(c_use_row_permute_file,
                                    c_use_col_permute_file);

      result := wss_delay + wsip_delay + 2;
    else
      result := 0;

      assert false
        report "ERROR : sid - c_type = " & integer_to_string(c_type) &
        " is unknown to get_latency function." & new_line
        severity failure;
    end if;  -- c_type

    return result;
  end get_latency;

  

end sid_pkg_behav_v7_0;




---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--                                                                          ---*
--                FORNEY INTERLEAVER / DEINTERLEAVER                        ---*
--                                                                          ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*

-- %%% Forney

library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

library xilinxcorelib;
use xilinxcorelib.sid_const_pkg_behav_v7_0.all;
use xilinxcorelib.sid_pkg_behav_v7_0.all;
use xilinxcorelib.sid_mif_pkg_behav_v7_0.all;


entity sid_bhv_forney_v7_0 is
  generic (
    c_mode                   : integer;
    c_symbol_width           : integer;
    -- Forney specific generics
    c_num_branches           : integer;
    c_branch_length_type     : integer;
    c_branch_length_constant : integer;
    c_branch_length_file     : string := "";
    c_has_fdo                : integer;
    c_has_ndo                : integer;
    -- Implementation generics
    c_pipe_level             : integer;
    -- Optional pin generics
    c_has_ce                 : integer;
    c_has_sclr               : integer;
    c_has_rdy                : integer;
    c_has_rffd               : integer;
    c_has_rfd                : integer;
    --New generics for v4_0
    c_external_ram           : integer;
    c_ext_addr_width         : integer;
    c_num_configurations     : integer);
  port (
    clk          : in  std_logic;
    fd           : in  std_logic;
    din          : in  std_logic_vector(c_symbol_width-1 downto 0);
    nd           : in  std_logic  := '1';

    first_sample : in  std_logic := '0';   -- Asserted on the first sample of a block.  This doesn't mean every FD
    last_branch  : out std_logic := '0';   -- Asserted when we read data for the last branch


    -- The core has been changed to have reset override CE.  The easy fix for the model was to just force CE to 1
    -- during reset.  However, some part aren't reset (e.g. external memory interface) so they need access to the
    -- unadulterated CE.
    --
    actual_ce : in  std_logic  := '1';

    
    ce           : in  std_logic  := '1';
    sclr         : in  std_logic  := '0';
    dout         : out std_logic_vector(c_symbol_width-1 downto 0);

    rdy          : out std_logic;
    rffd         : out std_logic;
    rfd          : out std_logic;
    fdo          : out std_logic;
    ndo          : out std_logic;

    new_config   : in  std_logic  := '0';
    config_sel   : in  std_logic_vector(
      select_val(
        bits_needed_to_represent(c_num_configurations-1),
        1, c_num_configurations <= 1) -1 downto 0);
    rd_data      : in  std_logic_vector(c_symbol_width-1 downto 0);  -- Read data from external RAM
    rd_en        : out std_logic;
    wr_en        : out std_logic;
    rd_addr      : out std_logic_vector(c_ext_addr_width-1 downto 0);
    wr_addr      : out std_logic_vector(c_ext_addr_width-1 downto 0);
    wr_data      : out std_logic_vector(c_symbol_width-1 downto 0));  -- Write data to external RAM
end sid_bhv_forney_v7_0;


architecture behavioral of sid_bhv_forney_v7_0 is


  constant cc_type : integer := c_forney_convolutional;


  constant max_num_branches : integer :=
    get_max_num_branches(c_num_configurations, c_num_branches, SID_CONST_PKG_BEHAV_mif_width, c_branch_length_file);

  subtype BVECTOR is INTEGER_VECTOR(0 to max_num_branches-1);

  type BLV_REC is record
    fld_num_branches             : natural range 0 to max_num_branches;
    fld_bl_vect                  : BVECTOR;
    fld_branch_start_vector      : BVECTOR;
    fld_branch_end_vector        : BVECTOR;
    fld_branch_read_start_vector : BVECTOR;
    fld_fdo_proc_delay           : integer;
  end record;

  type BVECTOR_ARRAY is array(natural range <>) of BLV_REC;


  --------------------------------------------------------------------------------
  --
  -- convert integer_vector to bvector (vector of branch lengths)
  --
  --------------------------------------------------------------------------------
  function integer_vector_to_bvector(
    iv : in integer_vector)
    return BVECTOR is
    variable result : BVECTOR;
  begin
    for ai in iv'low to iv'high loop    -- ai = address index
      result(ai) := iv(ai);
    end loop;  -- ai
    return result;
  end integer_vector_to_bvector;

  --------------------------------------------------------------------------------
  --Function to extract the array of selectable branch_vectors from a mif file vector
  --------------------------------------------------------------------------------
  function get_forney_params(
    ccnum_configurations     : integer;
    ccmode                   : integer;
    ccnum_branches           : integer;
    ccbranch_length_constant : integer;
    ccbranch_length_type     : integer;
    ccbranch_length_file     : string) return BVECTOR_ARRAY is


    constant max_mif_file_size : integer :=
      select_val(ccnum_configurations*(1+max_num_branches),
                 ccnum_branches,
                 ccnum_configurations = 1);

    variable fileptr                : integer                                     := 0;
    variable c2_num_branches_array  : INTEGER_VECTOR(0 to ccnum_configurations-1) := (others => 0);
    variable num_total_mif_values   : integer                                     := 0;
    variable num_branches           : integer                                     := 0;
    variable branch_length_constant : integer                                     := 0;
    variable total_mif_file_vector  : INTEGER_VECTOR(0 to max_mif_file_size-1)    := (others => 0);
    variable blvi                   : INTEGER_VECTOR(0 to max_num_branches-1)     := (others => 0);
    variable blv                    : BVECTOR                                     := (others => 0);
    variable result                 : BVECTOR_ARRAY(0 to ccnum_configurations-1);

  begin

    if ccnum_configurations = 1 then
      result(0).fld_num_branches := ccnum_branches;
      if ccbranch_length_type = c_constant then
        blvi := get_branch_length_vector(ccmode, ccnum_branches, ccbranch_length_constant);
        blv  := integer_vector_to_bvector(blvi);
      else
        blvi := get_integer_vector_from_mif(true,
                                             ccbranch_length_file,
                                             ccnum_branches,
                                             SID_CONST_PKG_BEHAV_mif_width);
        blv := integer_vector_to_bvector(blvi);
        for bi in 0 to ccnum_branches - 1 loop
          -- always add one to each branch length vector element.
          -- doing this ensures that zero length branches are automatically
          -- supported without affecting latency.
          blv(bi) := blv(bi) + 1;
        end loop;  -- bi
      end if;
      result(0).fld_bl_vect        := blv;
      result(0).fld_fdo_proc_delay := calc_fdo_proc_delay(ccnum_branches, blv(0));
      
    elsif ccnum_configurations > 1 then
      --The first ccnum_configurations entries are the number of branches vector.
      --If ccnum_configurations>1 and this constant is used to select
      --the number of branches, depending on the value on the config_sel port.
      --If ccnum_configurations>1 and ccbranch_length_type=c_file, this constant is
      --also used to find the total number of mif file values.
      c2_num_branches_array := get_integer_vector_from_mif(true,
                                                            ccbranch_length_file,
                                                            ccnum_configurations,
                                                            SID_CONST_PKG_BEHAV_mif_width);

      if ccbranch_length_type = c_constant then
        num_total_mif_values := 2*ccnum_configurations;
      else
        num_total_mif_values := ccnum_configurations+get_sum(c2_num_branches_array);
      end if;

      --Now read the whole mif_file
      total_mif_file_vector(0 to num_total_mif_values-1)
        := get_integer_vector_from_mif(true,
                                        ccbranch_length_file,
                                        num_total_mif_values,
                                        SID_CONST_PKG_BEHAV_mif_width);

      fileptr := ccnum_configurations;  --needed for parsing branch length vectors
      for cfg in 0 to ccnum_configurations-1 loop
        num_branches                 := total_mif_file_vector(cfg);
        result(cfg).fld_num_branches := num_branches;
        if ccbranch_length_type = c_constant then
          branch_length_constant    := total_mif_file_vector(cfg+ccnum_configurations);
          blvi(0 to num_branches-1) := get_branch_length_vector
                                       (ccmode,
                                        num_branches,
                                        branch_length_constant);
          blv := integer_vector_to_bvector(blvi);
        else
          --extract a branch_length_vector from the input vector
          for i in 0 to num_branches-1 loop
            blvi(i) := total_mif_file_vector(fileptr)
                       +1;              --Add 1 to each element!
            fileptr := fileptr+1;
          end loop;
          blv := integer_vector_to_bvector(blvi);
        end if;
        --store the extracted single branch_length_vector in the array
        result(cfg).fld_bl_vect        := blv;
        result(cfg).fld_fdo_proc_delay := calc_fdo_proc_delay(num_branches, blv(0));
      end loop;
    else                                --ccnum_configurations>1 THEN
      --ERROR!    
      assert false
        report "c_num_configurations = " & integer_to_string(ccnum_configurations) & " is not supported!"
        severity failure;
    end if;

    for cfg in 0 to ccnum_configurations-1 loop
      blvi                                := calc_branch_start_vector(result(cfg).fld_bl_vect);
      result(cfg).fld_branch_start_vector := integer_vector_to_bvector(blvi);

      blvi                                     := calc_branch_read_start_vector(result(cfg).fld_bl_vect);
      result(cfg).fld_branch_read_start_vector := integer_vector_to_bvector(blvi);

      blvi                              := calc_branch_end_vector(result(cfg).fld_bl_vect);
      result(cfg).fld_branch_end_vector := integer_vector_to_bvector(blvi);
    end loop;

    return result;
  end get_forney_params;


--------------------------------------------------------------------------------
  -- get the largest value in the branch length vector.
  -- ie the length of the longest branch +1.
  --
  function get_max_blv_value(
    num_configurations : integer;
    fparams            : BVECTOR_ARRAY)
    return integer is
    variable result : integer;
  begin
    result := 0;
    for cfg in 0 to num_configurations-1 loop
      for this_branch in 0 to fparams(cfg).fld_num_branches - 1 loop
        if fparams(cfg).fld_bl_vect(this_branch) > result then
          result := fparams(cfg).fld_bl_vect(this_branch);
        end if;
      end loop;
    end loop;
    return result;
  end get_max_blv_value;

--------------------------------------------------------------------------------
  function get_max_fdo_proc_delay(
    num_configurations : integer;
    fparams            : BVECTOR_ARRAY)
    return integer is
    variable result : integer;
  begin
    result := 0;
    for cfg in 0 to num_configurations-1 loop
      if fparams(cfg).fld_fdo_proc_delay > result then
        result := fparams(cfg).fld_fdo_proc_delay;
      end if;
    end loop;
    return result;
  end get_max_fdo_proc_delay;

--------------------------------------------------------------------------------
  --Extract an array of c_num_configurations branch length vectors from the total mif file vector
  constant forney_params : BVECTOR_ARRAY(0 to c_num_configurations-1)
    := get_forney_params(c_num_configurations,
                         c_mode,
                         c_num_branches,
                         c_branch_length_constant,
                         c_branch_length_type,
                         c_branch_length_file);

  constant max_blv_value : integer :=
    get_max_blv_value(c_num_configurations, forney_params);

  constant max_fdo_proc_delay : integer :=
    get_max_fdo_proc_delay(c_num_configurations, forney_params);

--Data types;

  subtype SID_SYMBOL is std_logic_vector(c_symbol_width-1 downto 0);

  subtype SID_FORNEY_SWITCH is integer range -1 to max_num_branches-1;

  constant do_check_generics : boolean :=
    check_forney_generics(c_mode, c_symbol_width, c_num_branches,
                          c_branch_length_type, c_branch_length_constant);

  constant ndo_delay : integer := select_val(3, 4, c_pipe_level = c_maximum);

  constant output_delay : time := 1 ns;

  type DATABUFFER is array (natural range <>) of SID_SYMBOL;



  type MEM is array (0 to (2**c_ext_addr_width)-1) of SID_SYMBOL;

  ------------------------------------------------------------------------------
  signal ce_int    : std_logic;
  signal sclr_int  : std_logic;
  signal power     : std_logic := '0';
  signal reset     : std_logic := '0';

  -- Inputs registered if c_pipe_level/=c_minimum, else unregistered
  signal din_r         : SID_SYMBOL := (others => '0');
  signal nd_r          : std_logic;
  signal v_fd_r        : std_logic;
  signal abort_r       : std_logic;
  signal fd_received_r : std_logic;


  
  signal fd_received : std_logic;
  signal rffd_int    : std_logic;

  signal sync_0       : std_logic;
  signal sync_1       : std_logic;
  signal sync_delayed : std_logic;

  signal f_sw            : SID_FORNEY_SWITCH;
  signal shiftbr_0       : SID_FORNEY_SWITCH;
  signal shiftbr_1       : SID_FORNEY_SWITCH;
  signal shiftbr_delayed : SID_FORNEY_SWITCH := -1;
  signal shiftbr_raddr_r : SID_FORNEY_SWITCH := -1;

  signal nd_0       : std_logic;
  signal nd_1       : std_logic := '0';
  signal nd_delayed : std_logic := '0';
  signal nd_raddr_r : std_logic := '0';

  signal fd_0       : std_logic;
  signal fd_1       : std_logic;
  signal fd_delayed : std_logic;

  signal first_sample_r       : std_logic := '0';  -- r= resolved or registered.  Take your pick.  It's first_sample directly when
                                                   -- minimum pipelining is used, or it registered by a cycle when medium or maximum
                                                   -- pipelining is used.
  signal first_sample_0       : std_logic;
  signal first_sample_1       : std_logic;
  signal first_sample_delayed : std_logic;

  
  signal ndo_vect : std_logic_vector(ndo_delay downto 0);
  signal ndo_d    : std_logic;
  signal ndo_int  : std_logic;

  signal rd_addr_nd_vect : std_logic_vector(ndo_delay downto 0);

  signal fdo_proc_vect : std_logic_vector(max_fdo_proc_delay downto 0);
  signal fdo_d         : std_logic;
  signal fdo_q         : std_logic;
  signal fdo_int       : std_logic;

  signal rdy_enable_d   : std_logic;
  signal rdy_enable_q   : std_logic;
  signal rdy_enable_int : std_logic;

  signal dout_int : SID_SYMBOL := (others => '-');

  signal rdy_int : std_logic;
  signal rfd_int : std_logic;           --not used in Forney

  signal rd_en_d   : std_logic := '1';
  signal rd_en_int : std_logic := '1';

  signal rd_addr_int : std_logic_vector(c_ext_addr_width-1 downto 0)  := (others => '0');
  signal wr_addr_int : std_logic_vector(c_ext_addr_width-1 downto 0)  := (others => '0');
  signal wr_data_int : std_logic_vector(c_symbol_width-1 downto 0);

  signal wr_en_d   : std_logic := '0';
  signal wr_en_int : std_logic := '0';

  signal smem : MEM := (others => (others => '-'));  -- internal symbol memory.


  --Signals for selecting parameters when c_num_configurations>1
  constant config_sel_width       : integer                                   := bits_needed_to_represent(c_num_configurations-1);
  signal config_sel_r             : std_logic_vector(config_sel_width-1 downto 0);
  signal config_sel_0             : natural range 0 to c_num_configurations-1 := 0;
  signal config_sel_1             : natural range 0 to c_num_configurations-1 := 0;
  signal config_sel_delayed       : natural range 0 to c_num_configurations-1 := 0;
  signal config_sel_raddr_r       : natural range 0 to c_num_configurations-1 := 0;
  signal config_sel_valid_0       : std_logic                                 := '0';
  signal config_sel_valid_1       : std_logic                                 := '0';
  signal config_sel_valid_delayed : std_logic                                 := '0';
  signal config_sel_valid_raddr_r : std_logic                                 := '0';
  signal new_config_0             : std_logic                                 := '0';
  signal new_config_1             : std_logic                                 := '0';
  signal new_config_delayed       : std_logic                                 := '0';
  signal new_config_raddr_r       : std_logic                                 := '0';
  signal sync_raddr_r             : std_logic                                 := '0';
  signal config_sel_valid_rffd    : std_logic                                 := '0';

  signal new_config_r   : std_logic;
  signal new_config_int : std_logic;

  constant HAS_CTRL_CHANNEL : boolean := C_NUM_CONFIGURATIONS > 1;

  signal num_branches   : integer := abs_min_num_branches;
  

  -- The write address vector used by the write_address_proc. The read_address_proc used to maintain
  -- its own version but that's non-atomic and can be split by a reset, putting the read andd write
  -- vectors out of sync.  
  --
  signal sig_write_addr_vect    : BVECTOR;

  
--------------------------------------------------------------------------------
-- START OF ARCHITECTURE -------------------------------------------------------
--------------------------------------------------------------------------------

begin


  -- Output delay process
  -- add setup delay to data output signal
--  output_t_proc : process(dout_int, rd_data, rdy_int, ndo_int)
  output_t_proc : process(dout_int, rd_data)
    variable dout_t : SID_SYMBOL;
  begin

    if c_external_ram /= 0 then
      dout_t := rd_data;
    else
      dout_t := dout_int;
    end if;
    
    dout <= dout_t after output_delay;
  end process;

  --ce process
  ce_proc : process(ce)
  begin
    if c_has_ce /= 0 then
      ce_int <= ce;
    else
      ce_int <= '1';
    end if;
  end process;

  --sclr process
  sclr_proc : process(sclr)
  begin
    if c_has_sclr /= 0 then
      sclr_int <= sclr;
    else
      sclr_int <= '0';
    end if;
  end process;

  --new_config process
  new_config_proc : process(new_config)
  begin
    if c_num_configurations > 1 then
      new_config_int <= new_config;
    else
      new_config_int <= '0';
    end if;
  end process;


  --Powerup process - runs once only
  powerup : process
  begin
    power <= '1' after 1 ns;
    wait;
  end process;  --powerup   

  --reset process
  reset_proc : process(power)
  begin
    reset <= not power;
  end process;  --reset_proc   

  --Optional rdy process
  optional_rdy : process(rdy_int)
  begin
    if c_has_rdy /= 0 then rdy <= rdy_int after output_delay;
    else rdy                   <= 'U';
    end if;
  end process;

  --Optional rffd process
  optional_rffd : process(rffd_int)
  begin
    if c_has_rffd /= 0 then rffd <= rffd_int after output_delay;
    else rffd                    <= 'U';
    end if;
  end process;

  rfd_int <= '0';                       --not used in Forney
  --Optional rfd process
  optional_rfd : process(rfd_int)
  begin
    if c_has_rfd = 0 then
      rfd <= 'U';
    elsif cc_type = c_forney_convolutional then
      rfd <= '1';
    else
      rfd <= rfd_int after output_delay;
    end if;
  end process;



  --config_sel process
  config_sel_proc : process(clk, reset)

    variable config_sel_nat : natural range 0 to 2**config_sel_width-1;

  begin
    if c_num_configurations = 1 then
      config_sel_valid_0 <= '1';
      config_sel_0       <= 0;
    elsif reset = '1' then
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          config_sel_valid_0 <= '0';
          config_sel_0       <= 0;
        elsif new_config_r = '1' then
          config_sel_nat := std_logic_vector_to_natural(config_sel_r);
          if config_sel_nat > c_num_configurations-1 then
            config_sel_valid_0 <= '0';
            config_sel_0       <= 0;
          else
            config_sel_valid_0 <= '1';
            config_sel_0       <= config_sel_nat;
          end if;
        end if;
      end if;
    end if;
  end process;


  --Register inputs
  reg_inputs : process(clk, reset, nd, fd, din, fd_received, first_sample)
  begin
    if c_pipe_level /= c_minimum then
      if reset = '1' then
        nd_r          <= '0';
        v_fd_r        <= '0';
        fd_received_r <= '0';
        first_sample_r <= '0';
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' then
            nd_r          <= '0';
            v_fd_r        <= '0';
            fd_received_r <= '0';
            first_sample_r <= '0';
          else
            nd_r          <= nd;
            v_fd_r        <= fd and nd;
            fd_received_r <= fd_received;
            first_sample_r <= first_sample;

          end if;
          din_r <= din;
        end if;
      end if;
    else
      nd_r          <= nd;
      v_fd_r        <= fd and nd;
      din_r         <= din;
      fd_received_r <= fd_received;
      first_sample_r <= first_sample;
    end if;
  end process;

  --Register inputs (for c_num_configurations>1)
  reg_config_inputs : process(clk, reset, nd, fd, new_config_int, config_sel)
  begin
    if c_pipe_level /= c_minimum then
      if reset = '1' then
        new_config_r <= '0';
        config_sel_r <= (others => '0');
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' then
            new_config_r <= '0';
            config_sel_r <= (others => '0');
          else
            new_config_r <= new_config_int and fd and nd;
            config_sel_r <= config_sel;
          end if;
        end if;
      end if;
    else
      new_config_r <= new_config_int and fd and nd;
      config_sel_r <= config_sel;
    end if;
  end process;

  --Register abort signal
  reg_abort : process(clk, reset, nd, fd, din, rffd_int, new_config_int, fd_received)
  begin
    if c_pipe_level /= c_minimum then
      if reset = '1' then
        abort_r <= '0';
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' then
            abort_r <= '0';
          else
            abort_r <= (fd and nd and not rffd_int) or (fd and nd and not fd_received);
          end if;
        end if;
      end if;
    else
      abort_r <= (fd and nd and not rffd_int) or (fd and nd and not fd_received);
    end if;
  end process;

  --Add pipelining to read address

  pipe_raddr : process(clk, reset, shiftbr_delayed, config_sel_delayed, config_sel_valid_delayed,
                      new_config_delayed, nd_delayed, sync_delayed)
  begin
    if c_pipe_level = c_maximum then
      if clk'event and clk = '1' then
        if ce_int = '1' then
          sync_raddr_r             <= sync_delayed;
          new_config_raddr_r       <= new_config_delayed;
          config_sel_raddr_r       <= config_sel_delayed;
          config_sel_valid_raddr_r <= config_sel_valid_delayed;
          if sclr_int = '1' or abort_r = '1' then
            shiftbr_raddr_r <= -1;
            nd_raddr_r      <= '0';
          else
            shiftbr_raddr_r <= shiftbr_delayed;  
            nd_raddr_r      <= nd_delayed;
          end if;
        end if;
      end if;
    else
      shiftbr_raddr_r          <= shiftbr_delayed;

      sync_raddr_r             <= sync_delayed;
      new_config_raddr_r       <= new_config_delayed;
      config_sel_raddr_r       <= config_sel_delayed;
      config_sel_valid_raddr_r <= config_sel_valid_delayed;
      nd_raddr_r               <= nd_delayed;
    end if;
  end process;

  --Register outputs

  reg_outputs : process(clk, reset, rdy_enable_d, fdo_d)
  begin
    if c_pipe_level = c_maximum then
      if reset = '1' then
        fdo_q        <= '0';
        rdy_enable_q <= '0';
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' or abort_r = '1' then
            fdo_q        <= '0';
            rdy_enable_q <= '0';
          else
            fdo_q        <= fdo_d;
            rdy_enable_q <= rdy_enable_d;
          end if;
        end if;
      end if;
    else
      fdo_q        <= fdo_d;
      rdy_enable_q <= rdy_enable_d;
    end if;
  end process;


  --Process that adds an extra stage of delay to fdo for ext ram
  fdo_adjust : process(clk, reset, fdo_q, rdy_enable_q)
  begin
    if c_external_ram /= 0 then
      if reset = '1' then
        fdo_int        <= '0';
        rdy_enable_int <= '0';
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' or abort_r = '1' then
            fdo_int        <= '0';
            rdy_enable_int <= '0';
          else
            fdo_int        <= fdo_q;
            rdy_enable_int <= rdy_enable_q;
          end if;
        end if;
      end if;
    else
      fdo_int        <= fdo_q;
      rdy_enable_int <= rdy_enable_q;
    end if;
  end process;

  --Process that adds an extra stage of delay to ndo for ext ram
  ndo_adjust : process(clk, reset, ndo_d)
  begin
    if c_external_ram /= 0 then
      if reset = '1' then
        ndo_int   <= '0';
        rd_en_int <= '0';
      elsif clk'event and clk = '1' then
        if ce_int = '1' then
          if sclr_int = '1' or (abort_r = '1') then
            ndo_int   <= '0';
            rd_en_int <= '0';
          else
            ndo_int   <= ndo_d;
            rd_en_int <= rd_en_d;
          end if;
        end if;
      end if;
    else
      ndo_int <= ndo_d;
    end if;
  end process;

  --Process that adds an extra stage of delay to wr_en for ext ram
  wr_en_adjust : process(clk, reset)
  begin
    if power /= '1' then
      wr_en_int <= '0';
    elsif reset = '1' then
      wr_en_int <= '0';
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' or (abort_r = '1') then
          wr_en_int <= '0';
        else
          wr_en_int <= wr_en_d;
        end if;
      end if;
    end if;
  end process;

  --Delayed signals process
  delsigs : process(clk, reset)
  begin
    if reset = '1' then
      if c_pipe_level = c_maximum then
        nd_delayed <= '0';
      end if;
      shiftbr_1          <= -1;
      nd_1               <= '0';
      nd_0               <= '0';
      fd_delayed         <= '0';
      fd_1               <= '0';
      fd_0               <= '0';
      first_sample_delayed <= '0';
      first_sample_1       <= '0';
      first_sample_0       <= '0';
      new_config_delayed <= '0';
      new_config_1       <= '0';
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          shiftbr_1                <= -1;
          fd_delayed               <= '0';
          fd_1                     <= '0';
          fd_0                     <= '0';
          first_sample_delayed               <= '0';
          first_sample_1                     <= '0';
          first_sample_0                     <= '0';
          config_sel_delayed       <= 0;
          config_sel_1             <= 0;
          config_sel_valid_delayed <= '0';
          config_sel_valid_1       <= '0';
          new_config_delayed       <= '0';
          new_config_1             <= '0';
          nd_delayed               <= '0';   
          nd_1                     <= '0';   
          nd_0                     <= '0';   
          
        else
          if c_external_ram = 0 and abort_r = '1' then
            shiftbr_1 <= -1;
          else
            shiftbr_1 <= shiftbr_0;
          end if;
          config_sel_delayed       <= config_sel_1;
          config_sel_1             <= config_sel_0;
          config_sel_valid_delayed <= config_sel_valid_1;
          config_sel_valid_1       <= config_sel_valid_0;
          if abort_r = '1' then
            --need to resync, therefore, abort by purging registers
            new_config_delayed <= '0';
            new_config_1       <= '0';
            new_config_0       <= new_config_r;
            fd_delayed         <= '0';
            fd_1               <= '0';
            fd_0               <= '1';

            first_sample_delayed         <= '0';
            first_sample_1               <= '0';
            first_sample_0               <= '1';

            nd_delayed         <= '0';
            nd_1               <= '0';
          else
            new_config_delayed <= new_config_1;
            new_config_1       <= new_config_0;
            new_config_0       <= new_config_r;
            --fd_delayed         <= fd_1;
            --fd_1               <= fd_0;
            --fd_0               <= v_fd_r;


            if first_sample_r = '1' then
              first_sample_delayed         <= '0';  
              first_sample_1               <= '0';
              first_sample_0               <= '1';

              fd_delayed         <= '0';
              fd_1               <= '0';
              fd_0               <= '1';
              
            else
              first_sample_delayed         <= first_sample_1;  
              first_sample_1               <= first_sample_0;
              first_sample_0               <= first_sample_r;

              fd_delayed         <= fd_1;
              fd_1               <= fd_0;
              fd_0               <= v_fd_r;

              
            end if;
            --first_sample_delayed         <= first_sample_1;  
            --first_sample_1               <= first_sample_0;
            --first_sample_0               <= first_sample_r;


            nd_delayed         <= nd_1;
            nd_1               <= nd_0;
          end if;
          if (fd_received_r = '1' or v_fd_r = '1') then
            nd_0 <= nd_r;
          end if;
        end if;
      end if;
    end if;
  end process;

  --shifbr_delayed process
  shifbr_delayed_proc : process(clk, reset)
  begin
    if reset = '1' and c_pipe_level = c_maximum then
      shiftbr_delayed <= -1;
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          shiftbr_delayed <= -1;
        else
          if c_external_ram = 0 and abort_r = '1' then
            shiftbr_delayed <= -1;
          else
            shiftbr_delayed <= shiftbr_1;
          end if;
        end if;
      end if;
    end if;
  end process;

  --FD received process
  --Indicates whether a valid fd has ever been received.
  fd_received_proc : process (clk, reset)
  begin  -- process register_output
    if reset = '1' then
      fd_received <= '0';
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        if sclr_int = '1' then
          fd_received <= '0';
        elsif fd = '1' and nd = '1' then
          fd_received <= '1';
        end if;
      end if;
    end if;
  end process fd_received_proc;

  --rffd_int process
  rffd_int_proc : process(f_sw, config_sel_valid_rffd, fd_received)
  begin
    if fd_received /= '1' then
      rffd_int <= '1';
    else
      if f_sw = 0 then
        rffd_int <= '1';
      else
        rffd_int <= '0';
      end if;
    end if;
  end process;


  -- Switch position process
  -- This process determines which one of the branches
  -- is active.
  switch_posn : process(clk, reset)

    variable config_sel_nat : natural range 0 to 2**config_sel_width-1;
    variable v_num_branches   : integer := abs_min_num_branches;
    variable fd_rx          : boolean := false;

    procedure park_switch is
    begin
      fd_rx := false;
      f_sw  <= 0;                       --clear all contacts
    end park_switch;

    procedure start_switch is
    begin
      fd_rx := true;
      f_sw  <= 1;                       --set position 1
      if c_num_configurations > 1 then
        if new_config_int = '1' then
          config_sel_nat := std_logic_vector_to_natural(config_sel);
          if config_sel_nat > c_num_configurations-1 then
            config_sel_valid_rffd <= '0';
            v_num_branches          := forney_params(0).fld_num_branches;
          else
            config_sel_valid_rffd <= '1';
            v_num_branches          := forney_params(config_sel_nat).fld_num_branches;
          end if;
        end if;
      else
        v_num_branches := c_num_branches;
      end if;

      num_branches <= v_num_branches;
    end start_switch;

    procedure rotate_switch(v_num_branches : in integer) is
    begin
      f_sw <= (f_sw + 1) mod v_num_branches;  --wrap position 0
    end rotate_switch;
    
  begin

    if reset = '1' then
      park_switch;
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          park_switch;
        elsif (fd = '1' and nd = '1' and not fd_rx) then             --first fd
          start_switch;
        elsif (fd = '1' and nd = '1' and rffd_int = '0') then        --abort
          start_switch;
        elsif (fd = '1' and nd = '1' and new_config_int = '1') then  --abort
          start_switch;
        elsif nd = '1' and fd_rx then                                --running
          rotate_switch(v_num_branches);
        end if;
      end if;
    end if;

  end process;


  last_branch <= '1' when f_sw = num_branches-1 else '0';
        

  
  -- shiftbr_0_proc process
  -- This process determines which one of the branches
  -- is to be shifted
  shiftbr_0_proc : process(clk, reset)

    variable config_sel_nat : natural range 0 to 2**config_sel_width-1;
    variable num_branches   : integer := abs_min_num_branches;
    variable fd_rx          : boolean := false;

    procedure clear_shiftbr is
    begin
      fd_rx     := false;
      shiftbr_0 <= -1;
    end clear_shiftbr;

    procedure reset_shiftbr is
    begin
      fd_rx     := true;
      shiftbr_0 <= 0;
      if c_num_configurations > 1 then
        if new_config_r = '1' then
          config_sel_nat := std_logic_vector_to_natural(config_sel_r);
          if config_sel_nat > c_num_configurations-1 then
            num_branches := forney_params(0).fld_num_branches;
          else
            num_branches := forney_params(config_sel_nat).fld_num_branches;
          end if;
        end if;
      else
        num_branches := c_num_branches;
      end if;
    end reset_shiftbr;

    procedure rotate_shiftbr(num_branches : in integer) is
    begin
      shiftbr_0 <= (shiftbr_0 + 1) mod num_branches;  --wrap position 0
    end rotate_shiftbr;
    
  begin

    if reset = '1' then
      clear_shiftbr;
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          clear_shiftbr;
        elsif nd_r = '1' then
          if v_fd_r = '1' then
            reset_shiftbr;
          elsif fd_rx then
            rotate_shiftbr(num_branches);
          end if;
        end if;
      end if;
    end if;

  end process;  --shiftbr_0_proc


  --Process to generate write data
  write_data_proc : process(clk, power)

    constant wr_data_buf_length : integer                             := select_val(1, 2, c_pipe_level = c_maximum)
    + select_val(1, 0, c_external_ram = 0);
    variable wr_data_buf        : DATABUFFER(0 to wr_data_buf_length) := (others => (others => '0'));

  begin

    if power /= '1' then
      wr_data_int <= (others => '0');
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        --wr_data is unaffected by sclr or nd
        wr_data_int <= wr_data_buf(wr_data_buf_length-1);
        for i in wr_data_buf_length-1 downto 0 loop
          wr_data_buf(i+1) := wr_data_buf(i);
        end loop;
        wr_data_buf(0) := din_r;
      end if;  --ce_int
    end if;  --power

  end process;


  --Process to generate write address
  write_address_proc : process(clk, power)

    variable write_addr_vect    : BVECTOR;
    variable wr_addr_nat        : natural range 0 to (2**c_ext_addr_width)-1;
    variable wr_addr_buf        : INTEGER_VECTOR(0 to 3);  --Use to adjust delay
    variable wshiftbr           : SID_FORNEY_SWITCH;
    variable nd_w               : std_logic;
    variable new_config_w       : std_logic                                 := '0';
    variable sync_w             : std_logic                                 := '0';
    variable config_sel_valid_w : std_logic                                 := '0';
    variable config_sel_w       : natural range 0 to c_num_configurations-1 := 0;
    variable config_sel_w_in    : natural range 0 to c_num_configurations-1 := 0;
    variable this_branch        : natural range 0 to max_num_branches-1     := 0;
    variable num_branches       : integer;
    variable firstrotation      : std_logic                                 := '0';  --'1' on first rotation of the switch

  begin

    if power /= '1' then
      wr_addr_int        <= (others => '0');
      wr_addr_nat        := 0;
      wr_addr_buf        := (others => 0);
      config_sel_w       := 0;
      config_sel_w_in    := 0;
      new_config_w       := '0';
      config_sel_valid_w := '0';
      write_addr_vect    := forney_params(0).fld_branch_end_vector;
      num_branches       := forney_params(0).fld_num_branches;
      wshiftbr           := -1;
      nd_w               := '0';
      sync_w             := '0';
      firstrotation      := '0';
 
    elsif (clk'event and clk = '1') then

     if sclr_int = '1' then
      smem <= (others => (others => '-'));
     end if;
      
      if ce_int = '1' then

        if c_pipe_level /= c_maximum then
          wshiftbr           := shiftbr_1;
          nd_w               := nd_1;
          sync_w             := sync_1;
          config_sel_w_in    := config_sel_1;
          new_config_w       := new_config_1;
          config_sel_valid_w := config_sel_valid_1;
        else
          wshiftbr           := shiftbr_delayed;
          nd_w               := nd_delayed;
          sync_w             := sync_delayed;
          config_sel_w_in    := config_sel_delayed;
          new_config_w       := new_config_delayed;
          config_sel_valid_w := config_sel_valid_delayed;
        end if;

        if new_config_w = '1' then
          firstrotation := '1';
          if config_sel_valid_w = '1' then
            config_sel_w := config_sel_w_in;
          else
            config_sel_w := 0;
          end if;
          write_addr_vect    := forney_params(config_sel_w).fld_branch_end_vector;
          write_addr_vect(0) := forney_params(config_sel_w).fld_branch_start_vector(0);
          num_branches       := forney_params(config_sel_w).fld_num_branches;
          wr_addr_buf(0)     := write_addr_vect(0);
        elsif firstrotation = '1' and sync_w = '1' then
          write_addr_vect    := forney_params(config_sel_w).fld_branch_end_vector;
          write_addr_vect(0) := forney_params(config_sel_w).fld_branch_start_vector(0);
          wr_addr_buf(0)     := write_addr_vect(0);
        elsif (sync_1 = '1' and c_pipe_level = c_maximum) or sync_0 = '1' or abort_r = '1' or sclr_int = '1' then
          --do nothing
        else
          if wshiftbr /= -1 and nd_w = '1' then
            if wshiftbr = 0 then
              firstrotation := '0';
            end if;
            this_branch := wshiftbr;
            --Shift the branch pointed to by the switch
            if (
              write_addr_vect(this_branch)=
              forney_params(config_sel_w).fld_branch_end_vector(this_branch)
              )then
              write_addr_vect(this_branch) :=
                forney_params(config_sel_w).fld_branch_start_vector(this_branch);  --reset
            else
              write_addr_vect(this_branch) :=
                write_addr_vect(this_branch)+1;  --add 1
            end if;
            --Select the write address pointed to by the switch
            wr_addr_buf(0) := write_addr_vect(this_branch);
          end if;  --wshiftbr
        end if;
        --Back end delay can be adjusted by changing the wr_addr_buf index
        wr_addr_nat := wr_addr_buf(0);
        wr_addr_int <= integer_to_std_logic_vector(wr_addr_buf(0), c_ext_addr_width);

        if wr_en_d = '1' then
          if abort_r /= '1' and sclr_int /= '1' then
            smem(wr_addr_nat) <= wr_data_int;
          end if;
        end if;

      end if;  --ce_int
    end if;  --power

    sig_write_addr_vect <= write_addr_vect;
  end process;


  --Process to generate read address --incorporating symbol memory
  read_address_proc : process(clk, reset)

    variable num_branches   : integer;
    variable config         : natural range 0 to c_num_configurations-1 := 0;
    variable this_branch    : natural range 0 to max_num_branches-1     := 0;
    variable firstrotation  : std_logic                                 := '0';  --'1' on first rotation of the switch.
    -- It's only used when we have multiple configurations., and then only to deal with FD aborts (now impossible).

    -- The read address to use.  It's unclear what the "_d" was meant to designate.
    variable rd_addr_d      : natural range 0 to (2**c_ext_addr_width)-1;
  begin

    if power /= '1' then
      num_branches   := forney_params(0).fld_num_branches;
      rd_addr_int    <= (others => '0');
      rd_addr_d      := 0;
      config         := 0;
      firstrotation  := '0';
    elsif (clk'event and clk = '1') then
    
      if actual_ce = '1' then
        if nd_raddr_r = '1' then
          if new_config_raddr_r = '1' then   -- new_config_delayed delayed again by 1 if maximum pipelining is used, and undelayed if not

            -- This branch is in play when a new configuration is loaded.
            --
            firstrotation := '1';
            config        := config_sel_raddr_r;

            num_branches   := forney_params(config).fld_num_branches;

            rd_addr_d := sig_write_addr_vect(0);

            if ( rd_addr_d = forney_params(config).fld_branch_end_vector(0) )then
              rd_addr_d := forney_params(config).fld_branch_start_vector(0);  --reset
            else
              rd_addr_d := rd_addr_d +1;
            end if;
            rd_addr_int <= integer_to_std_logic_vector (rd_addr_d, c_ext_addr_width);
          elsif firstrotation = '1' and sync_raddr_r = '1' then

            -- sync_addr_r is sync_delayed delayed again by 1 if maximum pipelining is used, and undelayed if not
            -- sync_delayed is abort_r delayed by 3 cycles.  As FD aborts are now impossible, this branch is now obsolete.
            
          else

            -- This is the main branch of operation.  i.e. the one called when we haven't just loaded a new configuration
            -- or had a (now impossible) FD abort


            -- shiftbr_raddr_r is shiftbr_delayed if maximum pipelining is used, and undelayed if not.
            -- shiftbr_delayed is a registered version of shiftbr_1.  It's set to -1 in reset/sclr.
            -- shiftbr_1 is a registered version of shiftbr_0
            -- shiftbr_0 "Determines which one of the branches is to be shifted".
            -- It's (shiftbr_0+1) mod num branches.  It looks like the branch counter, and it aligns with wr_en which
            -- leads rd_en by a cycle.  

            
            if shiftbr_raddr_r = 0 then
              firstrotation := '0';
            end if;
            
            if shiftbr_raddr_r /= -1 then
              this_branch := shiftbr_raddr_r;

              --Select one read address (Rotate the output switch)
              if abort_r /= '1' and sclr_int /= '1' then
                rd_addr_d := sig_write_addr_vect(this_branch);

                if ( rd_addr_d = forney_params(config).fld_branch_end_vector(this_branch) )then
                  rd_addr_d := forney_params(config).fld_branch_start_vector(this_branch);  --reset
                else
                  rd_addr_d := rd_addr_d +1;
                end if;
              end if;
              rd_addr_int <= integer_to_std_logic_vector (rd_addr_d, c_ext_addr_width);

            end if;
          end if;
        end if;  --nd_raddr_r
        if rd_en_d = '1' then
          if abort_r /= '1' then
            dout_int <= smem(rd_addr_d);
          end if;
        end if;
      end if;  --ce
    end if;  --power
  end process;


 
  --FDO port
  fdoport : process(fdo_int, ndo_int)   
  begin
    if c_has_fdo /= 0 then
      fdo <= (fdo_int and ndo_int) after output_delay;
    else
      fdo <= 'U';
    end if;
  end process;

  --NDO PORT process
  ndoport : process(ndo_int)
  begin
    if c_has_ndo /= 0 then
      ndo <= ndo_int after output_delay;
    else
      ndo <= 'U';
    end if;
  end process;

  --RD_EN PORT process
  rd_en_d <= ndo_vect(ndo_delay-1);

  rd_en_port : process(clk, reset, rd_en_int)
  begin
    if c_external_ram /= 0 then
      rd_en <= rd_en_int after output_delay;
    else
      rd_en <= 'U';
    end if;
  end process;  --rd_en_port

  --WR_EN PORT process
  wr_en_d <= ndo_vect(ndo_delay-2);
  wr_en_port : process(wr_en_int)
  begin
    if c_external_ram /= 0 then
      wr_en <= wr_en_int after output_delay;
    else
      wr_en <= 'U';
    end if;
  end process;

  --WR_DATA PORT process
  wr_data_port : process(wr_data_int)
  begin
    if c_external_ram /= 0 then
      wr_data <= wr_data_int after output_delay;
    else
      wr_data <= (others => 'U');
    end if;
  end process;

  --RD_ADDR PORT process (Forney)
  rd_addr_port : process(rd_addr_int, rd_en_int)
  begin
    if c_external_ram /= 0 then
      rd_addr <= rd_addr_int after output_delay;
    else
      rd_addr <= (others => 'U');
    end if;
  end process;

  --WR_ADDR PORT process
  wr_addr_port : process(wr_addr_int, wr_en_int)
  begin
    if c_external_ram /= 0 then
      wr_addr <= wr_addr_int after output_delay;
    else
      wr_addr <= (others => 'U');
    end if;
  end process;

  --RDY port
  --for when the length of branch 0 is 0, rdy is the same as ndo

  rdyport : process(ndo_int, rdy_enable_int)
    variable fdo_proc_delay : integer;
  begin
    rdy_int <= (ndo_int and (rdy_enable_int)) after output_delay;
  end process;


  -- FDO proc process


  fdo_proc : process (clk, reset)
    variable fdo_proc_delay : integer;
  begin
    fdo_proc_delay := forney_params(config_sel_delayed).fld_fdo_proc_delay;

    if reset = '1' then
      fdo_proc_vect <= (others => '0');
      fdo_d         <= '0';
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        if sclr_int = '1' then
          fdo_proc_vect <= (others => '0');
          fdo_d         <= '0';
        else
          if fdo_proc_delay > 1 then
            if first_sample_delayed = '1' then
              fdo_proc_vect    <= (others => '0');
              fdo_proc_vect(0) <= first_sample_delayed;
              fdo_d            <= '0';
            else
              fdo_d <= fdo_proc_vect(fdo_proc_delay-2);
              if nd_delayed = '1' then
                fdo_proc_vect(fdo_proc_delay downto 1) <= fdo_proc_vect((fdo_proc_delay -1) downto 0);
              
                fdo_proc_vect(0) <= first_sample_delayed;
              end if;
            end if;
          else
            if abort_r = '1'  then
              fdo_d <= '0';
            else
              fdo_d <= first_sample_delayed;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;


  --RDY_enable process
  --rdy is enabled when the first fdo is output
  rdy_enable_proc : process (clk, reset)
    
    variable fdo_proc_delay : integer;

  begin
    fdo_proc_delay := forney_params(config_sel_delayed).fld_fdo_proc_delay;

    if reset = '1' then
      rdy_enable_d <= '0';
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        if sclr_int = '1' then
          rdy_enable_d <= '0';
        else
          if fdo_proc_delay > 1 then
            if abort_r = '1' or first_sample_delayed = '1' then
              rdy_enable_d <= '0';
            elsif (fdo_proc_vect(fdo_proc_delay-2) = '1'
                   -- Redundant?  Previous branch used this = 1
                   --and first_sample_r /= '1'
                   and sync_0 /= '1'    -- because and abort occurred
                   and sync_1 /= '1'    -- because and abort occurred
                   and sync_delayed /= '1'  -- because and abort occurred
                   ) then
              rdy_enable_d <= '1';
            end if;
          else
            if abort_r = '1' then
              rdy_enable_d <= '0';
            elsif fd_delayed = '1' then
              rdy_enable_d <= '1';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

  sync_proc : process (clk, reset)

  begin  -- process register_output
    if reset = '1' then
      sync_delayed <= '0';
      sync_1       <= '0';
      sync_0       <= '0';
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        if sclr_int = '1' then
          sync_delayed <= '0';
          sync_1       <= '0';
          sync_0       <= '0';
        else
          sync_delayed <= sync_1;
          sync_1       <= sync_0;
          sync_0       <= abort_r;
        end if;
      end if;
    end if;
  end process;

  --NDO delay process
  --ndo is nd_r, delayed by (ndo_delay) clocks
  ndo_delay_proc : process (clk, reset)

  begin
    if reset = '1' then
      ndo_vect <= (others => '0');
      ndo_d    <= '0';
    elsif (clk'event and clk = '1') then
      if ce_int = '1' then
        if sclr_int = '1' or (fd_received_r = '0') then
          ndo_vect    <= (others => '0');
          ndo_d       <= '0';
          ndo_vect(0) <= v_fd_r;        --load a 1 if first fd
        else
          if abort_r = '1' then         --abort condition
            -- purge shift register
            ndo_vect    <= (others => '0');
            ndo_vect(0) <= nd_r;
            ndo_d       <= '0';
          else
            ndo_d       <= ndo_vect(ndo_delay-1);
            ndo_vect(0) <= nd_r;
            for n in 1 to (ndo_delay-1) loop
              ndo_vect(n) <= ndo_vect(n-1);
            end loop;  -- n
          end if;
        end if;
      end if;
    end if;
  end process;


end behavioral;



---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*

---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--            RECTANGULAR BLOCK INTERLEAVER / DEINTERLEAVER                 ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*


-- %%% Rectangular

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

library xilinxcorelib;
use xilinxcorelib.sid_const_pkg_behav_v7_0.all;
use xilinxcorelib.sid_pkg_behav_v7_0.all;
use xilinxcorelib.sid_mif_pkg_behav_v7_0.all;

entity sid_bhv_rectangular_block_v7_0 is
  generic (
    c_family               : string;
    c_mode                 : integer;
    c_symbol_width         : integer;
    -- Row specific generics
    c_row_type             : integer;
    c_row_constant         : integer;
    c_has_row              : integer;
    c_has_row_valid        : integer;
    c_min_num_rows         : integer;
    c_row_width            : integer;
    c_num_selectable_rows  : integer;
    c_row_select_file      : string := "";
    c_has_row_sel          : integer;
    c_has_row_sel_valid    : integer;
    c_use_row_permute_file : integer;
    c_row_permute_file     : string := "";
    -- Column specific generics
    c_col_type             : integer;
    c_col_constant         : integer;
    c_has_col              : integer;
    c_has_col_valid        : integer;
    c_min_num_cols         : integer;
    c_col_width            : integer;
    c_num_selectable_cols  : integer;
    c_col_select_file      : string := "";
    c_has_col_sel          : integer;
    c_has_col_sel_valid    : integer;
    c_use_col_permute_file : integer;
    c_col_permute_file     : string := "";
    -- Block size specific generics
    c_block_size_type      : integer;
    c_block_size_constant  : integer;
    c_has_block_size       : integer;
    c_block_size_width     : integer;
    c_has_block_size_valid : integer;
    -- Implementation generics
    c_memstyle             : integer;
    c_pipe_level           : integer;
    -- Optional pin generics
    c_has_ce               : integer;
    c_has_nd               : integer;
    c_has_sclr             : integer;
    c_has_rdy              : integer;
    c_has_rffd             : integer;
    c_has_rfd              : integer;
    c_has_block_start      : integer;
    c_has_block_end        : integer;

    --New for generics v4_0
    c_architecture   : integer;
    c_external_ram   : integer;
    c_ext_addr_width : integer);
  port (
    -- Mandatory pins
    clk              : in  std_logic;
    fd               : in  std_logic;
    din              : in  std_logic_vector(c_symbol_width-1 downto 0);
    -- Optional input pins
    ce               : in  std_logic;
    nd               : in  std_logic;
    sclr             : in  std_logic;
    row              : in  std_logic_vector(c_row_width-1 downto 0);
    row_sel          : in  std_logic_vector(
      bits_needed_to_represent(c_num_selectable_rows-1) - 1 downto 0);
    col              : in  std_logic_vector(c_col_width-1 downto 0);
    col_sel          : in  std_logic_vector(
      bits_needed_to_represent(c_num_selectable_cols-1) - 1 downto 0);
    block_size       : in  std_logic_vector(c_block_size_width-1 downto 0);
    -- Mandatory output pins
    dout             : out std_logic_vector(c_symbol_width-1 downto 0);
    -- optional output pins
    rfd              : out std_logic;
    rdy              : out std_logic;
    rffd             : out std_logic;
    row_valid        : out std_logic;
    col_valid        : out std_logic;
    row_sel_valid    : out std_logic;
    col_sel_valid    : out std_logic;
    block_size_valid : out std_logic;
    block_start      : out std_logic;
    block_end        : out std_logic;

    rd_data          : in  std_logic_vector(c_symbol_width-1 downto 0);  -- Read data from external RAM
    rd_en            : out std_logic;
    wr_en            : out std_logic;
    rd_addr          : out std_logic_vector(c_ext_addr_width-1 downto 0);
    wr_addr          : out std_logic_vector(c_ext_addr_width-1 downto 0);
    wr_data          : out std_logic_vector(c_symbol_width-1 downto 0));  -- Write data to external RAM

end sid_bhv_rectangular_block_v7_0;

architecture behavioral of sid_bhv_rectangular_block_v7_0 is

  constant output_delay : time := 1 ns;

  ------------------------------------------------------------------------------
  -- Return number of values in the total rcl permute vector
  --The number of values in the total_rcl_permute_vector equals the total of all
  --the values in the rcl select vector.
  --
  function get_num_total_permute_vals(rcl_type          : integer;
                                      num_rcls          : integer;
                                      rcl_select_vector : INTEGER_VECTOR
                                      ) return integer is
    variable return_val : integer := 0;
  begin
    if rcl_type = c_selectable then
      return_val := get_sum(rcl_select_vector);
    elsif rcl_type = c_constant then
      return_val := num_rcls;
    else
      return_val := 1;
    end if;

    return return_val;
  end get_num_total_permute_vals;

  ------------------------------------------------------------------------------
  constant max_num_selectable_rows : integer := 32;  --defined in spec
  constant max_num_selectable_cols : integer := 32;  --defined in spec
  constant max_num_selectable_rcls : integer := 32;  --where rcl is row or col


  constant row_sel_width : integer := bits_needed_to_represent(c_num_selectable_rows-1);
  constant col_sel_width : integer := bits_needed_to_represent(c_num_selectable_cols-1);

  constant really_read_row_select_mif : boolean := (c_row_type = c_selectable);

  constant row_select_vector : integer_vector(0 to c_num_selectable_rows-1)
    := get_integer_vector_from_mif(really_read_row_select_mif,
                                   c_row_select_file,
                                   c_num_selectable_rows,
                                   SID_CONST_PKG_BEHAV_mif_width);



  -- max_num_rows is the biggest value in row_select_vector, or is determined
  -- by 'row' generics
  constant max_num_rows : integer := get_max_dimension(c_row_type,
                                                       c_row_constant,
                                                       c_row_width,
                                                       row_select_vector);

  constant really_read_col_select_mif : boolean := (c_col_type = c_selectable);

  constant col_select_vector : integer_vector(0 to c_num_selectable_cols-1)
    := get_integer_vector_from_mif(really_read_col_select_mif,
                                   c_col_select_file,
                                   c_num_selectable_cols,
                                   SID_CONST_PKG_BEHAV_mif_width);

  -- max_num_cols is the biggest value in col_select_vector, or is determined
  -- by 'col' generics
  constant max_num_cols : integer := get_max_dimension(c_col_type,
                                                       c_col_constant,
                                                       c_col_width,
                                                       col_select_vector);


  constant max_block_size : integer :=
    get_max_block_size(max_num_rows, max_num_cols, c_block_size_constant,
                       c_block_size_type, c_block_size_width);

  constant max_num_symbol_ram_cells : integer := max_block_size;

  constant num_symbol_ram_cells : integer := max_block_size;

  -- Round up to nearest 16 prior to get_memstyle calculation
  constant symbol_ram_depth_tmp : integer :=
    get_mem_depth_dp(num_symbol_ram_cells, c_distmem);

  -- Select appropriate memstyle for symbol memory
  constant symbol_mem_style : integer := get_memstyle(
    depth     => symbol_ram_depth_tmp,
    width     => c_symbol_width,
    style     => c_memstyle,
    mem_type => c_sp_ram,
    smart     => true
    );


  constant rectangle_size : integer := max_num_rows * max_num_cols;

  constant pruned : boolean := max_block_size < rectangle_size or
                               c_block_size_type = c_variable;
  
  constant pruned_single_row : boolean :=
    pruned and c_row_type = c_constant and max_num_rows = 1;
  
  constant wss_delay : integer := calc_wss_delay(pruned,
                                                c_block_size_type,
                                                c_col_type,
                                                c_row_type);

  constant wsip_delay_val : integer :=
    select_val(1, 3, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0);


  constant output_buffer_length : integer := wss_delay
                                            + select_val(0, 2, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0)
                                            + 1;  
  
  constant input_buffer_length : integer := wss_delay + 1
                                           + select_val(0, 2, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0);
  
  constant addr_buffer_length : integer := wss_delay
                                          + select_val(0, 2, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0);

  constant wr_en_buffer_length : integer := wss_delay + 1
                                           + select_val(0, 2, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0);
  
  constant rd_en_buffer_length : integer := wss_delay + 1
                                           + select_val(0, 2, c_use_row_permute_file /= 0 or c_use_col_permute_file /= 0);

  --delay between fd and assertion of row_valid etc.
  constant xvalid_buffer_length : integer := calc_xvalid_buffer_length
                                             (wss_delay, c_block_size_type, c_col_type, c_row_type);

  --The number of values in the total permute vector is not
  --greater than largest value in the row/column select vector
  --times the number of selectable rows/columns.
  constant max_total_row_permute_vals : integer := max_num_rows * c_num_selectable_rows;
  constant max_total_col_permute_vals : integer := max_num_cols * c_num_selectable_cols;


  --The number of values in the total_row_permute_vector equals the total of all
  --the values in the row select vector.
  constant num_total_row_permute_values : natural := get_num_total_permute_vals
                                                     (c_row_type, c_row_constant, row_select_vector);
  
  constant really_read_total_row_permute_mif : boolean := (c_use_row_permute_file /= 0);

  constant initial_total_row_permute_vector : integer_vector(0 to (num_total_row_permute_values-1))
    := get_integer_vector_from_mif(really_read_total_row_permute_mif,
                                   c_row_permute_file,
                                   num_total_row_permute_values,
                                   SID_CONST_PKG_BEHAV_mif_width);

  --The number of values in the total_col_permute_vector equals the total of all
  --the values in the col select vector.
  constant num_total_col_permute_values : natural := get_num_total_permute_vals
                                                     (c_col_type, c_col_constant, col_select_vector);
  
  constant really_read_total_col_permute_mif : boolean := (c_use_col_permute_file /= 0);

  constant initial_total_col_permute_vector : integer_vector(0 to (num_total_col_permute_values-1))
    := get_integer_vector_from_mif(really_read_total_col_permute_mif,
                                   c_col_permute_file,
                                   num_total_col_permute_values,
                                   SID_CONST_PKG_BEHAV_mif_width);


  ------------------------------------------------------------------------------
  -- Make row or column permute offset vector
  --
  --The maximum number of selectable row/col permute vectors is given by the
  --max_num_selectable_rows/cols.(i.e 32)
  --create an array of row/col permute offsets to store the start addresses of the
  --possible selectable row/col permute vectors.
  --The number of values in a particular row/col permute vector equals the 
  --corresponding value in the row/col select vector.                                       
  function make_permute_offset_vector(rcl_type            : integer;
                                      num_selectable_rcls : integer;
                                      rcl_select_vector   : integer_vector)
    return integer_vector is

    variable offset : integer_vector(0 to num_selectable_rcls-1) := (others => 0);
  begin
    if rcl_type /= c_selectable then
      offset := (others => 0);
    else
      offset(0) := 0;
      for i in 1 to num_selectable_rcls-1 loop
        offset(i) := offset(i-1)+rcl_select_vector(i-1);
      end loop;
    end if;
    return offset;
  end make_permute_offset_vector;


  constant row_permute_offset_vector : integer_vector(0 to c_num_selectable_rows-1)
    := make_permute_offset_vector(c_row_type,
                                  c_num_selectable_rows, row_select_vector);

  constant col_permute_offset_vector : integer_vector(0 to c_num_selectable_cols-1)
    := make_permute_offset_vector(c_col_type,
                                  c_num_selectable_cols, col_select_vector);


  ------------------------------------------------------------------------------
  -- If interleaver, need to make inverse total row or column permute vector
  --
  function get_actual_total_permute_vector(mode                             : integer;
                                           initial_total_rcl_permute_vector : integer_vector;
                                           num_total_rcl_permute_values     : integer;
                                           rcl_type                         : integer;
                                           num_rcls                         : integer;
                                           num_selectable_rcls              : integer;
                                           rcl_select_vector                : integer_vector)
    return integer_vector is

    variable ivect  : integer_vector(0 to num_total_rcl_permute_values-1) := (others => 0);
    variable offset : integer;
  begin
    if mode = c_interleaver then
      if rcl_type = c_selectable then
        offset := 0;
        for s in 0 to num_selectable_rcls-1 loop
          for i in 0 to rcl_select_vector(s)-1 loop
            --sweep for target
            for j in 0 to rcl_select_vector(s)-1 loop
              if initial_total_rcl_permute_vector(offset+j) = i then
                ivect(i+offset) := j;
              end if;
            end loop;
          end loop;
          offset := offset + rcl_select_vector(s);
        end loop;
      elsif rcl_type = c_constant then
        for i in 0 to num_rcls-1 loop
          for j in 0 to num_rcls-1 loop
            --Search through the vector till i is found.
            --Put the location of it into the output
            --vector
            if initial_total_rcl_permute_vector(j) = i then
              ivect(i) := j;
            end if;
          end loop;
        end loop;
      else
        ivect := (others => 0);  --rcl_type = c_variable: permutations not allowed
      end if;
    else
      ivect := initial_total_rcl_permute_vector;
    end if;
    return ivect;
  end get_actual_total_permute_vector;


  constant total_row_permute_vector : integer_vector(0 to (num_total_row_permute_values-1))
    := get_actual_total_permute_vector(c_mode,
                                       initial_total_row_permute_vector,
                                       num_total_row_permute_values,
                                       c_row_type,
                                       c_row_constant,
                                       c_num_selectable_rows,
                                       row_select_vector);

  constant total_col_permute_vector : integer_vector(0 to (num_total_col_permute_values-1))
    := get_actual_total_permute_vector(c_mode,
                                       initial_total_col_permute_vector,
                                       num_total_col_permute_values,
                                       c_col_type,
                                       c_col_constant,
                                       c_num_selectable_cols,
                                       col_select_vector);

  -------------------------------------------------------------------------------
  --Data types;

  subtype SID_SYMBOL is std_logic_vector(c_symbol_width-1 downto 0);


  subtype MEM_ADDRESS is natural range 0 to max_num_symbol_ram_cells-1;

  type MEM is array (0 to max_num_symbol_ram_cells-1) of SID_SYMBOL;
  type OPBUF is array (0 to output_buffer_length) of SID_SYMBOL;
  type IPBUF is array (0 to input_buffer_length) of SID_SYMBOL;
  type MEM_ADDRESS_BUF is array (0 to addr_buffer_length) of MEM_ADDRESS;


  type FSM_STATE_TYPE is (IDLE, IDLE_1, START, WRITING, READING, READING_0, READING_1);

  -------------------------------------------------------------------------------
  function calc_col_length_vector (num_rows  : natural;
                                   num_cols  : natural;
                                   blocksize : natural)
    return INTEGER_VECTOR is

    variable result : INTEGER_VECTOR(0 to num_cols-1) := (others => 0);

  begin
    for ci in 0 to num_cols-1 loop
      if num_cols*(num_rows-1) + ci > blocksize-1 then
        result(ci) := num_rows - 1;     --pruned column
      else
        result(ci) := num_rows;         --unpruned column
      end if;
    end loop;
    return result;

  end calc_col_length_vector;

  ------------------------------------------------------------------------------


  signal ce_int    : std_logic;
  signal sclr_int  : std_logic;
  signal power     : std_logic := '0';
  signal reset : std_logic := '0';

  signal din_0   : SID_SYMBOL;
  signal din_1   : SID_SYMBOL;
  signal din_del : SID_SYMBOL;

  signal nd_int   : std_logic;
  signal nd_0     : std_logic;
  signal nd_del   : std_logic;
  signal v_fd_b   : std_logic;
  signal v_fd_0   : std_logic;
  signal v_fd_del : std_logic;
  signal abort_b  : std_logic;
  signal abort_0  : std_logic;

  signal row_0 : std_logic_vector(c_row_width-1 downto 0);
  signal row_sel_0 : std_logic_vector(
    bits_needed_to_represent(c_num_selectable_rows-1) - 1 downto 0);
  signal col_0 : std_logic_vector(c_col_width-1 downto 0);
  signal col_sel_0 : std_logic_vector(
    bits_needed_to_represent(c_num_selectable_cols-1) - 1 downto 0);
  signal block_size_0 : std_logic_vector(c_block_size_width-1 downto 0);

  signal row_valid_int        : std_logic;
  signal col_valid_int        : std_logic;
  signal row_sel_valid_int    : std_logic;
  signal col_sel_valid_int    : std_logic;
  signal block_size_valid_int : std_logic;

  signal rffd_int : std_logic;
  signal rfd_int  : std_logic;

  signal block_start_int : std_logic;
  signal block_end_int   : std_logic;
  signal rdy_int         : std_logic;

  signal dout_int : SID_SYMBOL;


  signal sram_raddr_int : std_logic_vector(c_ext_addr_width-1 downto 0)
    := (others => '0');
  signal sram_waddr_int : std_logic_vector(c_ext_addr_width-1 downto 0)
    := (others => '0');
  signal wr_data_int : std_logic_vector(c_symbol_width-1 downto 0)
    := (others => '0');
  signal wr_en_int : std_logic := '0';
  signal rd_en_int : std_logic := '1';


  CONSTANT latency : INTEGER := get_latency(c_rectangular_block,
                                            c_row_type,
                                            c_use_row_permute_file,
                                            c_col_type,
                                            c_use_col_permute_file,
                                            c_block_size_type,
                                            c_pipe_level,
                                            c_external_ram);
  

  

  --------------------------------------------------------------------------------
  -- START OF ARCHITECTURE behavioral OF sid_bhv_rectangular_block_v7_0
  --------------------------------------------------------------------------------
  
begin

--  -- Output delay process
--  -- add setup delay to data output signal
--  output_t_proc : process(dout_int, rdy_int, rd_data)
--    variable dout_t : SID_SYMBOL;
--  begin
--    if rdy_int = '1' then
--      if c_external_ram = 0 then
--        dout_t := dout_int;
--      else
--        dout_t := rd_data;
--      end if;
--    else
--      dout_t := (others => 'X');
--    end if;
--    dout <= dout_t after output_delay;
--  end process;

  -- Output delay process
  -- add setup delay to data output signal
  --output_t_proc : process(dout_int, rdy_int, rd_data)
  output_t_proc : process(dout_int, rd_data)
    variable dout_t : SID_SYMBOL;
  begin
    if c_external_ram = 0 then
      dout_t := dout_int;
    else
      dout_t := rd_data;
    end if;
    dout <= dout_t after output_delay;
  end process;



--ce process
  ce_proc : process(ce)
  begin
    if c_has_ce /= 0 then
      ce_int <= ce;
    else
      ce_int <= '1';
    end if;
  end process;

  --sclr process
  sclr_proc : process(sclr)
  begin
    if c_has_sclr /= 0 then
      sclr_int <= sclr;
    else
      sclr_int <= '0';
    end if;
  end process;

  --Powerup process - runs once only
  powerup : process
  begin
    power <= '1' after 1 ns;
    wait;
  end process;  --powerup   


  --reset process

  reset_proc : process(power)
  begin
    reset <= not power;
  end process;  --reset_proc   

  --Optional rdy process
  optional_rdy : process(rdy_int)
  begin
    if c_has_rdy /= 0 then rdy <= rdy_int after output_delay;
    else rdy                   <= 'U';
    end if;
  end process;

  --Optional rffd process
  optional_rffd : process(rffd_int)
  begin
    if c_has_rffd /= 0 then rffd <= rffd_int after output_delay;
    else rffd                    <= 'U';
    end if;
  end process;


  --Optional rfd process
  optional_rfd : process(rfd_int)
  begin
    if c_has_rfd /= 0 then rfd <= rfd_int after output_delay;
    else rfd                   <= 'U';
    end if;
  end process;

  --nd process
  nd_proc : process(nd)
  begin
    if c_has_nd /= 0 then
      nd_int <= nd;
    else
      nd_int <= '1';
    end if;
  end process;

  --Delay data and control inputs

  abort_b_proc : process(nd_int, fd, rffd_int)
  begin
    v_fd_b <= fd and nd_int;
    if c_has_rffd /= 0 then
      abort_b <= fd and nd_int and not rffd_int;
    else
      abort_b <= '0';
    end if;
  end process;


  --RD_EN port is always '1'
  rd_en <= '1';


  --WR_EN PORT process
  wr_en_port : process(wr_en_int)
  begin
    if c_external_ram /= 0 then
      wr_en <= wr_en_int after output_delay;
    else
      wr_en <= 'U';
    end if;
  end process;

  --WR_DATA PORT process
  wr_data_port : process(wr_data_int)
  begin
    if c_external_ram /= 0 then
      wr_data <= wr_data_int after output_delay;
    else
      wr_data <= (others => 'U');
    end if;
  end process;

  --RD_ADDR PORT process
  --Note - Memory is single port, so rd_addr is identical to wr_addr
  rd_addr_port : process(sram_raddr_int, sram_waddr_int, rd_en_int, wr_en_int)
  begin
    if c_external_ram /= 0 then
      
      if wr_en_int = '1' then
        rd_addr <= sram_waddr_int after output_delay;
      elsif rd_en_int = '1' then
        rd_addr <= sram_raddr_int after output_delay;
      else
        rd_addr <= (others => 'X') after output_delay;
      end if;

    else
      rd_addr <= (others => 'U');
    end if;
  end process;


  --WR_ADDR PORT process
  --Note - Memory is single port
  --Note - Memory is single port, so wr_addr is identical to rd_addr
  wr_addr_port : process(sram_raddr_int, sram_waddr_int, rd_en_int, wr_en_int)
  begin
    if c_external_ram /= 0 then

      if wr_en_int = '1' then
        wr_addr <= sram_waddr_int after output_delay;
      elsif rd_en_int = '1' then
        wr_addr <= sram_raddr_int after output_delay;
      else
        wr_addr <= (others => 'X') after output_delay;
      end if;

    else
      wr_addr <= (others => 'U');
    end if;
  end process;


  delsigs : process(clk, reset)
  begin
    if power /= '1' then
      nd_0         <= '0';
      nd_del       <= '0';
      din_0        <= (others => '0');
      din_del      <= (others => '0');
      din_0        <= (others => '0');
      din_1        <= (others => '0');
      v_fd_0       <= '0';
      v_fd_del     <= '0';
      row_0        <= (others => '0');
      row_sel_0    <= (others => '0');
      col_0        <= (others => '0');
      col_sel_0    <= (others => '0');
      block_size_0 <= (others => '0');
    elsif reset = '1' then
      v_fd_0   <= '0';
      v_fd_del <= '0';
      nd_del   <= '0';
      abort_0  <= '0';
    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        nd_del  <= nd_0;
        din_del <= din_0;
        din_1   <= din_0;
        if nd_int = '1' then
          din_0 <= din;
        end if;
        nd_0         <= nd_int;
        row_0        <= row;
        row_sel_0    <= row_sel;
        col_0        <= col;
        col_sel_0    <= col_sel;
        block_size_0 <= block_size;
        if sclr_int = '1' then
          v_fd_del <= '0';
          v_fd_0   <= '0';
          abort_0  <= '0';
        else
          v_fd_del <= v_fd_0;
          v_fd_0   <= v_fd_b;
          abort_0  <= abort_b;
        end if;
      end if;
    end if;
  end process;

  --Optional row_sel_valid process
  optional_row_sel_valid : process(row_sel_valid_int)
  begin
    if c_has_row_sel_valid /= 0 then row_sel_valid <= row_sel_valid_int after output_delay;
    else row_sel_valid                             <= 'U';
    end if;
  end process;

  --Optional col_sel_valid process
  optional_col_sel_valid : process(col_sel_valid_int)
  begin
    if c_has_col_sel_valid /= 0 then col_sel_valid <= col_sel_valid_int after output_delay;
    else col_sel_valid                             <= 'U';
    end if;
  end process;

  --Optional row_valid process
  optional_row_valid : process(row_valid_int)
  begin
    if c_has_row_valid /= 0 then row_valid <= row_valid_int after output_delay;
    else row_valid                         <= 'U';
    end if;
  end process;

  --Optional col_valid process
  optional_col_valid : process(col_valid_int)
  begin
    if c_has_col_valid /= 0 then col_valid <= col_valid_int after output_delay;
    else col_valid                         <= 'U';
    end if;
  end process;

  --Optional block_size_valid process
  optional_block_size_valid : process(block_size_valid_int)
  begin
    if c_has_block_size_valid /= 0 then block_size_valid <= block_size_valid_int after output_delay;
    else block_size_valid                                <= 'U';
    end if;
  end process;

  --Optional block_start process
  optional_block_start : process(block_start_int)
  begin
    if c_has_block_start /= 0 then block_start <= block_start_int after output_delay;
    else block_start                           <= 'U';
    end if;
  end process;

  --Optional block_end process
  optional_block_end : process(block_end_int)
  begin
    if c_has_block_end /= 0 then block_end <= block_end_int after output_delay;
    else block_end                         <= 'U';
    end if;
  end process;




  --Symbol Memory Process
  smem_proc : process(clk, reset, power)


    --delay between fd and rffd if inputs not valid.
    constant rffd_delay : natural := xvalid_buffer_length + 2;
    constant read       : boolean := true;
    constant write      : boolean := not read;

    variable fsm_state_rdy     : FSM_STATE_TYPE;
    variable fsm_state_rfd     : FSM_STATE_TYPE;
    variable smem              : MEM                                         := (others => (others => '0'));
    variable dout_buffer       : OPBUF;
    variable din_buffer        : IPBUF                                       := (others => (others => '0'));
    variable sram_raddr_buffer : MEM_ADDRESS_BUF                             := (others => 0);
    variable sram_waddr_buffer : MEM_ADDRESS_BUF                             := (others => 0);
    variable wr_en_buffer      : std_logic_vector (0 to wr_en_buffer_length) := (others => '0');
    variable rd_en_buffer      : std_logic_vector (0 to rd_en_buffer_length) := (others => '1');
    variable rdy_buffer        : std_logic_vector (0 to output_buffer_length);

    variable block_size_valid_buffer : std_logic_vector (0 to xvalid_buffer_length);
    variable row_valid_buffer        : std_logic_vector (0 to xvalid_buffer_length);
    variable v_fd_buffer             : std_logic_vector (0 to xvalid_buffer_length) := (others => '0');
    variable row_sel_valid_buffer    : std_logic_vector (0 to xvalid_buffer_length);
    variable col_valid_buffer        : std_logic_vector (0 to xvalid_buffer_length);
    variable col_sel_valid_buffer    : std_logic_vector (0 to xvalid_buffer_length);
    variable all_valid_buffer        : std_logic_vector (0 to xvalid_buffer_length);
    variable all_valid_buffer_rdy    : std_logic_vector (0 to xvalid_buffer_length);-- Noew for v7.0.  This is to keep all_valid aligned with v_fd_rdy
    


    variable v_fd_rdy : std_logic;
    variable nd_rdy   : std_logic;

    variable smem_block_end   : std_logic;
    variable write_done       : std_logic;
    variable read_done        : std_logic;
    variable rdy_set          : std_logic;
    variable rdy_clr          : std_logic;
    variable rdy_abort        : std_logic;
    variable rdy_valid        : std_logic;
    --variable rdy_valid_d        : std_logic; -- Change for v7.0 as part of the drive to remove X's from the model outputs.
                                               -- Overall it hasn't worked so I've removed the code for now
                                               -- 

    variable rdy_set_buffer   : std_logic_vector (0 to output_buffer_length);
    variable rdy_clr_buffer   : std_logic_vector (0 to output_buffer_length);
    variable rdy_abort_buffer : std_logic_vector (0 to output_buffer_length);
    variable rdy_valid_buffer : std_logic_vector (0 to output_buffer_length);
    variable block_end_buffer : std_logic_vector (0 to output_buffer_length);


    variable col_length_vector : INTEGER_VECTOR (0 to max_num_cols-1);
    variable i                 : natural;
    variable rfd_read          : std_logic;
    variable rfd_write         : std_logic;
    variable rfd_wcount        : natural;
    variable rfd_rcount        : natural;
    variable wcount            : natural := 0;
    variable wri, p_wri        : natural := 0;
    variable wci, p_wci        : natural := 0;
    variable rcount            : natural := 0;
    variable rri, p_rri        : natural := 0;
    variable rci, p_rci        : natural := 0;
    variable smem_waddr        : MEM_ADDRESS;
    variable smem_raddr        : MEM_ADDRESS;

    variable selected_num_rows          : natural range 0 to max_num_rows   := 1;
    variable selected_num_cols          : natural range 0 to max_num_cols   := 1;
    variable selected_block_size        : natural range 0 to max_block_size := 1;
    variable max_wcount                 : natural;
    variable max_rcount                 : natural;
    variable selected_row_pv_offset     : natural range 0 to max_total_row_permute_vals;
    variable selected_col_pv_offset     : natural range 0 to max_total_col_permute_vals;
    variable all_valid                  : std_logic;
    variable rdy_old                    : std_logic;
    variable all_valid_rfd              : std_logic;  --all_valid, delayed by xvalid_buffer_length
    variable abort_rfd                  : std_logic;
    variable rfd_valid                  : std_logic;
    variable sram_raddr_int_d           : MEM_ADDRESS                       := 0;
    variable sram_waddr_int_d           : MEM_ADDRESS                       := 0;
    variable selected_num_rows_rdy      : natural range 0 to max_num_rows   := 1;
    variable selected_num_cols_rdy      : natural range 0 to max_num_cols   := 1;
    variable selected_block_size_rdy    : natural range 0 to max_block_size := 1;
    variable max_wcount_rdy             : natural;
    variable max_rcount_rdy             : natural;
    variable selected_row_pv_offset_rdy : natural range 0 to max_total_row_permute_vals;
    variable selected_col_pv_offset_rdy : natural range 0 to max_total_col_permute_vals;
    variable all_valid_rdy              : std_logic;
    variable invalid_block_size         : boolean;
    variable smem_dout                  : SID_SYMBOL;

    variable row_nat             : natural range 0 to 2**c_row_width-1;
    variable row_is_valid        : std_logic;
    variable row_sel_nat         : natural range 0 to 2**row_sel_width-1;
    variable row_sel_is_valid    : std_logic;
    variable col_nat             : natural range 0 to 2**c_col_width-1;
    variable col_is_valid        : std_logic;
    variable col_sel_nat         : natural range 0 to 2**col_sel_width-1;
    variable col_sel_is_valid    : std_logic;
    variable block_size_nat      : natural range 0 to 2**c_block_size_width-1;
    variable block_size_is_valid : std_logic := '1';

    variable v_ext_mem_abort : std_logic_vector(latency-1 downto 0);

    -- Declared here so we an see them in waveform.


    CONSTANT nc_width : INTEGER := bits_needed_to_represent(max_num_cols);
    CONSTANT nr_width : INTEGER := bits_needed_to_represent(max_num_rows);
    CONSTANT rc_width : INTEGER := bits_needed_to_represent(max_num_rows - 1);
    CONSTANT cc_width : INTEGER := bits_needed_to_represent(max_num_cols - 1);


    CONSTANT rm1_x_cm1_width : INTEGER := bits_needed_to_represent((max_num_rows-1)*(max_num_cols-1));
    CONSTANT rm1_x_cm1_plus_r_width : INTEGER :=  bits_needed_to_represent((max_num_rows-1)*(max_num_cols-1) + max_num_rows);

    
    variable row_in_core_max : std_logic_vector(31 downto 0);
    variable col_in_core_max : std_logic_vector(31 downto 0);
    variable row_in_core : std_logic_vector(rc_width-1 downto 0);
    variable col_in_core : std_logic_vector(cc_width-1 downto 0);
    variable row_in_core_m1 : std_logic_vector(rc_width-1 downto 0);
    variable col_in_core_m1 : std_logic_vector(cc_width-1 downto 0);

   
    
    variable rm1_x_cm1_max         : std_logic_vector(31 downto 0);  -- Make it big enough to avoid truncation
    variable rm1_x_cm1             : std_logic_vector(rm1_x_cm1_width-1 downto 0);
    variable rm1_x_cm1_int         : integer;
    variable rm1_x_cm1_plus_r_max  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    variable rm1_x_cm1_plus_r      : STD_LOGIC_VECTOR(rm1_x_cm1_plus_r_width-1 DOWNTO 0);
    variable rm1_x_cm1_plus_r_int  : integer;
    
    CONSTANT min_num_rows : INTEGER := get_min_dimension(c_row_type,
                                                         c_row_constant,
                                                         c_row_width,
                                                         c_min_num_rows,
                                                         row_select_vector);
    
    CONSTANT min_num_cols : INTEGER := get_min_dimension(c_col_type,
                                                         c_col_constant,
                                                         c_col_width,
                                                         c_min_num_cols,
                                                         col_select_vector);
    
    
    CONSTANT max_block_size_input : INTEGER :=
                         select_integer(max_block_size, 2**c_block_size_width-1,
                                        c_block_size_type=c_variable);
    

    -- This can sometimes resolve to 0 which ends up as -1 in the bits_needed_to_represent() call below.
    -- That causes a fatal error, so make it 1
    CONSTANT cpl_value    : INTEGER := max_of(1, max_block_size_input - (min_num_rows-1)*min_num_cols -1);


    
    CONSTANT cpl_m1_width : INTEGER := 1 + bits_needed_to_represent(cpl_value-1);

    
    CONSTANT comp_width   : INTEGER := max_of(cc_width+1, cpl_m1_width);
    variable cpl_m1_wide  : STD_LOGIC_VECTOR(comp_width-1 DOWNTO 0);
    variable cpl_m1       : STD_LOGIC_VECTOR(cpl_m1_width-1 DOWNTO 0);

    CONSTANT cpl_sub2_s_width : INTEGER := select_integer(c_block_size_width,rm1_x_cm1_plus_r_width,
                                                 c_block_size_width < rm1_x_cm1_plus_r_width)+1;
    variable cpl_sub2_s  : signed(cpl_sub2_s_width-1 DOWNTO 0);
    variable cpl_sub_out : STD_LOGIC_VECTOR(c_block_size_width DOWNTO 0);

    
    
    variable selected_block_size_vec   : STD_LOGIC_VECTOR(c_block_size_width DOWNTO 0);
    variable rm1_x_cm1_plus_r_vec      : STD_LOGIC_VECTOR(rm1_x_cm1_plus_r_width DOWNTO 0);

    
    procedure init_vars is
    begin
      fsm_state_rdy := IDLE;
      fsm_state_rfd := IDLE;
      rffd_int      <= '1';
      rfd_int       <= '1';
      rfd_wcount    := 0;
      rfd_rcount    := 0;
      rfd_read      := '0';
      rfd_write     := '0';

      selected_num_rows       := max_num_rows;
      selected_num_cols       := max_num_cols;
      selected_block_size     := max_block_size;
      max_wcount              := selected_block_size-1;
      max_rcount              := selected_block_size-1;
      selected_row_pv_offset  := 0;
      selected_col_pv_offset  := 0;
      rdy_old                 := '0';
      all_valid               := '1';
      all_valid_rfd           := '1';
      abort_rfd               := '0';
      rfd_valid               := '1';
      row_nat                 := 0;
      row_sel_nat             := 0;
      col_nat                 := 0;
      col_sel_nat             := 0;
      block_size_nat          := 0;
      rdy_buffer              := (others => '0');
      rdy_int                 <= '0';
      row_is_valid            := '1';
      row_valid_int           <= '1';
      row_sel_is_valid        := '1';
      row_sel_valid_int       <= '1';
      block_size_valid_buffer := (others => '1');
      row_valid_buffer        := (others => '1');
      row_sel_valid_buffer    := (others => '1');
      col_valid_buffer        := (others => '1');
      col_sel_valid_buffer    := (others => '1');
      v_fd_buffer             := (others => '0');
      all_valid_buffer        := (others => '1');
      all_valid_buffer_rdy    := (others => '1');
      col_is_valid            := '1';
      col_valid_int           <= '1';
      col_sel_is_valid        := '1';
      col_sel_valid_int       <= '1';

      block_size_is_valid  := '1';
      block_size_valid_int <= '1';
      block_start_int      <= '0';
      block_end_int        <= '0';

      write_done       := '0';
      read_done        := '0';
      smem_block_end   := '0';
      rdy_set          := '0';
      rdy_clr          := '0';
      rdy_abort        := '0';
      rdy_set_buffer   := (others => '0');
      rdy_clr_buffer   := (others => '0');
      rdy_abort_buffer := (others => '0');
      rdy_valid_buffer := (others => '1');
      block_end_buffer := (others => '0');

      selected_num_rows_rdy      := selected_num_rows;
      selected_num_cols_rdy      := selected_num_cols;
      selected_block_size_rdy    := selected_block_size;
      all_valid_rdy              := '1';
      max_wcount_rdy             := max_wcount;
      max_rcount_rdy             := max_rcount;
      selected_row_pv_offset_rdy := selected_row_pv_offset;
      selected_col_pv_offset_rdy := selected_col_pv_offset;


    end init_vars;


    procedure load_sel_params is
      -- These are needed to calculate which (if any) corner case is in play
      CONSTANT rfd_gen : BOOLEAN := c_has_rfd /= 0 OR c_has_rffd /= 0;
      CONSTANT block_size_const : BOOLEAN := c_block_size_type = c_constant OR
                                             (c_block_size_type = c_row_x_col AND
                                              c_row_type = c_constant AND
                                              c_col_type = c_constant);
      

      CONSTANT max_num_rows : INTEGER := get_max_dimension(c_row_type,
                                                           c_row_constant,
                                                           c_row_width,
                                                           row_select_vector);
            
      CONSTANT min_input_block_size : INTEGER :=
        get_min_input_block_size(c_block_size_constant,
                                 min_num_rows,
                                 min_num_cols,
                                 c_row_type,
                                 c_col_type,
                                 c_block_size_type);

      CONSTANT rc_bs_can_be_too_small : BOOLEAN :=
        c_block_size_type = c_row_x_col AND
        NOT(block_size_const) AND min_input_block_size < abs_min_block_size;
            
            
      constant c_has_row_x_col_block_size : integer := BOOLEAN'POS(rc_bs_can_be_too_small AND c_has_block_size_valid/=0);
            
            
      CONSTANT compute_rfdc_thresh : BOOLEAN := c_has_row_x_col_block_size /= 0 OR
                                                    (rfd_gen AND c_block_size_type=c_row_x_col AND NOT(block_size_const));
            


      CONSTANT rom_depth_limit : INTEGER := 8;
      CONSTANT const_is_power_of_2 : BOOLEAN :=
        (c_row_type=c_constant AND power_of_2(c_row_constant)) OR
        (c_col_type=c_constant AND power_of_2(c_col_constant));
      
      CONSTANT single_partial_prod : BOOLEAN :=
        (c_row_type = c_constant AND nc_width <= 4) OR
        (c_col_type = c_constant AND nr_width <= 4);

      
        
      CONSTANT use_rom_instead_of_mult : BOOLEAN := NOT(single_partial_prod) AND (
        (c_row_type=c_selectable AND c_col_type=c_constant AND
         NOT(const_is_power_of_2) AND
         c_num_selectable_rows <= rom_depth_limit) OR
        (c_row_type=c_constant AND c_col_type=c_selectable AND
         NOT(const_is_power_of_2) AND
         c_num_selectable_cols <= rom_depth_limit) OR
        (c_row_type=c_selectable AND c_col_type=c_selectable AND
         c_num_selectable_rows * c_num_selectable_cols <= rom_depth_limit));
      

      variable v_rfdc_l : integer;
      variable v_mult_ce_delay : integer;

      
    begin
      --report "load_sel_params start" severity note;
      all_valid := '1';
      -- all_valid will go false if any one of the required input values is
      -- out of range.
      -- Note: is_x is in std_logic_1164. Returns TRUE if value is U|X|Z|W|-.
      -- This is required to cater for the case where the input is indeterminate.
      -- In which case all_valid must also go indeterminate.

      rfd_valid := '1';
      -- rfd_valid will go false if the conditions for rfd and rffd 
      -- being determinate are met.

      case c_row_type is
        when c_constant =>
          selected_num_rows := c_row_constant;      
          row_valid_int     <= 'X';     --Not relevant. Don't care.
        when c_variable =>
          if is_x(row) then
            all_valid    := 'X';
            row_is_valid := 'X';
          else
            row_nat := std_logic_vector_to_natural(row);
            if row_nat < c_min_num_rows then
              all_valid    := '0';
              row_is_valid := '0';
            else
              row_is_valid := '1';
            end if;
            selected_num_rows := row_nat;
          end if;
        when c_selectable =>
          if is_x(row_sel) then
            all_valid        := 'X';
            row_sel_is_valid := 'X';
          else
            row_sel_nat := std_logic_vector_to_natural(row_sel);
            if row_sel_nat > c_num_selectable_rows-1 then
              row_sel_is_valid  := '0';
              all_valid         := '0';
              --If not valid, default to row_select_vector(0)
              selected_num_rows := row_select_vector(0);
            else
              row_sel_is_valid  := '1';
              selected_num_rows := row_select_vector(row_sel_nat);
              if c_use_row_permute_file = 1 then
                selected_row_pv_offset := row_permute_offset_vector(row_sel_nat);
              end if;
            end if;
          end if;
        when others => null;
      end case;

      case c_col_type is
        when c_constant =>
          selected_num_cols := c_col_constant;
          col_valid_int     <= 'X';     --Not relevant. Don't care.
        when c_variable =>
          if is_x(col) then
            all_valid    := 'X';
            col_is_valid := 'X';
          else
            col_nat := std_logic_vector_to_natural(col);
            if col_nat < c_min_num_cols then
              all_valid    := '0';
              col_is_valid := '0';
            else
              col_is_valid := '1';
            end if;
            selected_num_cols := col_nat;
          end if;
        when c_selectable =>
          if is_x(col_sel) then
            all_valid        := 'X';
            col_sel_is_valid := 'X';
          else
            col_sel_nat := std_logic_vector_to_natural(col_sel);
            if col_sel_nat > c_num_selectable_cols-1 then
              col_sel_is_valid  := '0';
              all_valid         := '0';
              --If not valid, default to col_select_vector(0)
              selected_num_cols := col_select_vector(0);
            else
              col_sel_is_valid  := '1';
              selected_num_cols := col_select_vector(col_sel_nat);
              if c_use_col_permute_file = 1 then
                selected_col_pv_offset := col_permute_offset_vector(col_sel_nat);
              end if;
            end if;
          end if;
        when others => null;
      end case;


      invalid_block_size  := false;
      block_size_is_valid := '1';
      rfd_valid           := all_valid;


      case c_block_size_type is
        when c_constant =>
          selected_block_size := c_block_size_constant;
        when c_row_x_col =>
          selected_block_size := selected_num_rows * selected_num_cols;
          if selected_block_size < 6 then
            rfd_valid           := '0';
            invalid_block_size  := true;
          end if;
        
        when c_variable =>
          block_size_nat      := std_logic_vector_to_natural(block_size);
          selected_block_size := block_size_nat;
        
          invalid_block_size := false;
        
        
          -- The calculations in the core are all fixed widths, so we can get wraparound with invalid values.  For example, when row=0
          -- row-1 can = 3 rather than -1.  It depends on the row counter widths.  This section just recreates those calculations.
          --
        
          
          --report "Converting rows" severity note;
          row_in_core_max :=  std_logic_vector(to_unsigned(selected_num_rows, 32)); -- Convert to a big vector to prevent truncation warnings
          row_in_core     :=  row_in_core_max(rc_width-1 downto 0);                 -- Truncate
          row_in_core_m1  :=  row_in_core - "1";                                   -- Doing it this way avoids truncation warnings from numeric_std
                             
         
          --report "Converting cols - selected_num_cols = " & integer'image(selected_num_cols) severity note;
        
        
          col_in_core_max :=  std_logic_vector(to_unsigned(selected_num_cols, 32)); -- Convert to a big vector to prevent truncation warnings
          col_in_core     :=  col_in_core_max(cc_width-1 downto 0);                 -- Truncate
          col_in_core_m1  :=  col_in_core - "1";                                   -- Doing it this way avoids truncation warnings from numeric_std
                             
          -- col_in_core    :=  std_logic_vector(to_unsigned(selected_num_cols, cc_width));
          -- col_in_core_m1 :=  std_logic_vector(to_signed(selected_num_cols-1, cc_width));
        
          
          
          --report "Calc 1" severity note;
          rm1_x_cm1_int := to_integer(unsigned(row_in_core_m1))*to_integer(unsigned(col_in_core_m1));
          rm1_x_cm1_max := std_logic_vector(to_unsigned(rm1_x_cm1_int, 32));
          rm1_x_cm1     := rm1_x_cm1_max(rm1_x_cm1_width-1 downto 0);

          --report "Calc 2" severity note;
          rm1_x_cm1_plus_r_int := to_integer(unsigned(rm1_x_cm1)) + to_integer(unsigned(row_in_core_m1)) + 1;  
          rm1_x_cm1_plus_r_max := std_logic_vector(to_unsigned(rm1_x_cm1_plus_r_int, 32));
          rm1_x_cm1_plus_r     := rm1_x_cm1_plus_r_max(rm1_x_cm1_plus_r_width-1 downto 0);
          --report "Calc 2 done" severity note;
          
          
          -- Greater than min
          -- -----------------
          --      Check block_size > (r-1)c
          --      i.e. Block ends on last row of rectangle
        
        
          -- bsvg5 in code.
          -- block size >= rm1_x_cm1_plus_r
          -- Compared over rm1_x_cm1_plus_r_width bits.
          --
          --report "bsvg5" severity note;
        
          if selected_block_size >= to_integer(unsigned(rm1_x_cm1_plus_r)) then
            --block_size_gt_min <= '1';
          else
            -- block_size_gt_min <= '0';
            report "Invalid Block Size (1)" severity note;
        
            invalid_block_size := true;           
          end if;
        
          if selected_block_size >= abs_min_block_size then
            --block_size_gt_abs_min <= '1';
          else
            --block_size_gt_abs_min <= '0';
            report "Invalid Block Size (2)" severity note;
            invalid_block_size := true;
          end if;
        
          --report "bsvg5 done" severity note;
                  
          -- Less than max
          -- -------------
        
          
          -- bsvg2          
          if c_col_type = c_constant then
            --report "bsvg2" severity note;
        
            -- Constant Columns
            -- bsvg9 always returns a valid block for the upper bound
            
            if select_integer(max_block_size, 2**c_block_size_width-1, c_block_size_type=c_variable) > (min_num_rows * c_col_constant) then
              -- bsvg10
              --

              -- This one failed a lot due to the changes of widths and signs in the DUT which are a bit awkward to replicate.

              -- I'm using the integer versions and a signed result here because the calculation can end up being -ve which causes errors when
              -- to_unsigned is called.
              --cpl_m1_wide := std_logic_vector(to_signed(selected_block_size - rm1_x_cm1_plus_r_int - 1, cpl_m1_width));

              selected_block_size_vec := std_logic_vector(to_unsigned(selected_block_size, c_block_size_width+1));
              rm1_x_cm1_plus_r_vec    := '0' & rm1_x_cm1_plus_r;



              -- Code from sid_pruning vbg6.  Different code might be needed if vbg5 is in play
              cpl_sub2_s := signed(std_logic_vector(  unsigned(selected_block_size_vec)
                                                    - unsigned(rm1_x_cm1_plus_r_vec)
                                                    - to_unsigned(1, cpl_m1_width)
                ));

              cpl_sub_out(c_block_size_width downto 0) := std_logic_vector(cpl_sub2_s(c_block_size_width downto 0));

              for i IN 0 TO cpl_m1_width-1 loop
                if i <= c_block_size_width then
                  cpl_m1_wide(i) := cpl_sub_out(i);
                end if;
                if i > c_block_size_width then
                  cpl_m1_wide(i) := cpl_sub_out(c_block_size_width); -- Sign extend
                end if;
              end loop;

        
              --report "to_integer(unsigned(rm1_x_cm1_plus_r)) = "  &  integer'image(to_integer(unsigned(rm1_x_cm1_plus_r))) severity note;
              --report "to_integer(signed(cpl_m1_wide))   = "  &  integer'image(to_integer(signed(cpl_m1_wide))) severity note;

              -- Comparator in DUT is signed so must be signed here.
              if not(to_integer(signed(cpl_m1_wide)) < max_num_cols-1) then
                report "Invalid Block Size (3a)" severity note;
               -- report "selected_block_size - (to_integer(signed(rm1_x_cm1_plus_r))) - 1 = "  &  integer'image(to_integer(unsigned(cpl_m1_wide)))
               --   severity note;
                invalid_block_size := true;
              end if;
            end if;
        
            
          else
            -- Non Constant Columns
            -- The calculation here comes from the block valid generator bsvg4
            --
        
            -- Core extends both of these with 0 before doing the subtraction
            -- It then sign extends the result from block_size_width to cpl_m1_width
        
            cpl_m1 := std_logic_vector(to_signed(
              to_integer(signed('0' & std_logic_vector(to_unsigned(selected_block_size, c_block_size_width))))
              - (to_integer(signed('0' & rm1_x_cm1_plus_r))) - 1, cpl_m1_width));
              
        
        
            -- Sign extend
            cpl_m1_wide(cpl_m1_width-1 downto 0)          := cpl_m1(cpl_m1_width-1 downto 0);
            cpl_m1_wide(comp_width-1 downto cpl_m1_width) := (others => cpl_m1(cpl_m1_width-1));
            if not(to_integer(signed(cpl_m1_wide)) < to_integer(unsigned(col_in_core_m1))) then
              report "Invalid Block Size (3b)" severity note;
              --report "selected_block_size - (to_integer(signed(rm1_x_cm1_plus_r))) - 1 = "  &  integer'image(to_integer(signed(cpl_m1_wide)))
              --  severity note;
              invalid_block_size := true;
            end if;
        
          end if;
            
        
          if invalid_block_size = true then
            rfd_valid           := '0';
          end if;

        when others => null;

      end case;


      if invalid_block_size then
        block_size_is_valid := '0';
        all_valid           := '0';
      else
        block_size_is_valid := '1';
      end if;

      
      

      -- Row and col can be 0 which means any use of that -1 later gives a -ve number which can cause range errors.
      -- For the moment I'm setting row and col minimums again.  The DUT just subtracts 1 from the value, which is
      --   CONSTANT nc_width : INTEGER := bits_needed_to_represent(max_num_cols);
      -- bits wide.  
      --
      -- Rather than replicating that, I'll try the minimum bounds to see how they work.

      --constrain to be at least the minimum allowed.
      if selected_num_rows < abs_min_num_rows then
        selected_num_rows := abs_min_num_rows;
      end if;
      
      --constrain to be at least the minimum allowed.
      if selected_num_cols < abs_min_num_cols then
        selected_num_cols := abs_min_num_cols;
      end if;

      -- Special cases.

      if selected_block_size = 0 then
        -- When the block size is 0 the DUT uses that and thus bumbles on.  However, if we use it in the
        -- model and subtract 1 from it (which we do for max_wcount below) we get range errors from the compiler
        -- because the user defined types have a range starting at 0.  I'll set it to 1 just to avoid that.
        --
        selected_block_size := 1;
        
      elsif selected_block_size = 1 or selected_block_size = 2 then
        if c_pipe_level /= c_minimum then

          -- When the core is pipelined the RFD counter is loaded with 3 which means it starts above its terminal value
          -- (1 or 2).  The result is that RFD doesn't drop after 1 or 2 samples.
          --
          selected_block_size := abs_min_block_size; 
        else
          if selected_block_size = 1 then
           
            -- When the core is not pipelined the RFD counter is loaded with 2 which means it starts above its terminal value
            -- (1).  The result is that RFD doesn't drop after 1 sample.
            --
            selected_block_size := abs_min_block_size; 

          end if;

          if selected_block_size = 2 then
            if compute_rfdc_thresh = true then
              -- Threshold takes too long to arrive so RFD isn't dropped. Blocks of size 1 and 2 need to
              -- become abs_min_block_size
              selected_block_size := abs_min_block_size;
            else
              -- Threshold calculated quickly so blocks of size 2 are processed as being of size 2.  Don't do anything
            end if;
          end if;
        end if;
      elsif selected_block_size = 3 then
        -- This is an awkward size as RFD sometimes deasserts and sometimes doesn't.  There are several signals in play:
        -- rfdc_l: The value to RFDC Counter is loaded with
        --         rfdc_l = 3 if pipelined and non-constant block size
        --         rfdc_l = 2 if  not pipelined or constant block size

        -- mult_ce_delay: The delay taken to calculate the threshold value.  Teh threshold is available for use on the
        --                cycle after this.
        --                mult_ce_delay = 0: Row and cols not selectable and we're using a mult
        --                mult_ce_delay = 2: Row or cols  selectable or we're using a ROM

       
        if (NOT(block_size_const) AND c_pipe_level /= c_minimum) then
          v_rfdc_l := 3;
        else
          v_rfdc_l := 2;
        end if;
          
        -- Threshold:
        -- mult_ce_delay controls when the threshold is disabled.  That isn't affecting this case, although it might affect something later

        -- Threshold appears to be valid on cycle after bs_mu_ce is asserted.  This is  mult_ce_delay
        -- CONSTANT mult_ce_delay : INTEGER := select_integer(0, 2, (c_row_type = c_selectable OR c_col_type = c_selectable) AND NOT(use_rom_instead_of_mult));
        -- So:
        --  =0: Row and cols not selectable and we're using a mult
        --  =2: Row or cols  selectable or we're using a ROM

        if (c_row_type = c_selectable OR c_col_type = c_selectable) AND NOT(use_rom_instead_of_mult) then
          v_mult_ce_delay := 2;
        else
          v_mult_ce_delay := 0;
        end if;
        --report "v_rfdc_l = " & integer'image(v_rfdc_l) & ". v_mult_ce_delay = " & integer'image(v_mult_ce_delay) & ". selected_block_size = " & integer'image(selected_block_size) 
        --  severity note;

        if v_mult_ce_delay>0 and (v_rfdc_l + v_mult_ce_delay + 1> selected_block_size) then
          -- Threshold takes too long to arrive so RFD isn't dropped. Block needs to become larger to force RFD in the model to stay high
          selected_block_size := abs_min_block_size;
        else
          -- Threshold calculated quickly so block can stay this size
        end if;
      elsif selected_block_size = 4 or selected_block_size = 5 then
        if compute_rfdc_thresh = true then
          -- Threshold takes too long to arrive so RFD isn't dropped. Block needs to become larger to force RFD in the model to stay high
          selected_block_size := abs_min_block_size;  
        else
          -- Threshold calculated quickly so block can stay this size
        end if;
      end if;

      max_wcount := selected_block_size-1;
      max_rcount := selected_block_size-1;

      
      --report "load_sel_params end" severity note;
    end load_sel_params;


    procedure load_sel_params_rdy is
    begin
      selected_num_rows_rdy   := selected_num_rows;
      selected_num_cols_rdy   := selected_num_cols;
      selected_block_size_rdy := selected_block_size;
      --all_valid_rdy           := all_valid;
      all_valid_rdy           := all_valid_buffer_rdy(1); -- Change for V7.0.  A back-to-back FD will wipe all_valid so we need to use the one that actually corresponds to the FD & ND
                                                          -- that caused this to be called.
      
      if c_mode = c_interleaver then
        max_wcount_rdy := selected_block_size_rdy-1;
        max_rcount_rdy := selected_num_rows_rdy * selected_num_cols_rdy-1;
      else
        max_wcount_rdy := selected_num_rows_rdy * selected_num_cols_rdy-1;
        max_rcount_rdy := selected_block_size_rdy-1;
      end if;

      if all_valid_rdy = '1' then
        selected_row_pv_offset_rdy := selected_row_pv_offset;
        selected_col_pv_offset_rdy := selected_col_pv_offset;
        col_length_vector(0 to selected_num_cols_rdy-1) := calc_col_length_vector(
          selected_num_rows_rdy, selected_num_cols_rdy,
          selected_block_size_rdy);
      else
        selected_row_pv_offset_rdy := 0;
        selected_col_pv_offset_rdy := 0;
        col_length_vector          := (others => selected_num_rows_rdy);
      end if;


    end load_sel_params_rdy;


    procedure row_permute(a : in natural; pa : out natural) is
    begin
      if c_use_row_permute_file /= 0 then
        pa := total_row_permute_vector(a+selected_row_pv_offset_rdy);  --Apply permutation
      else
        pa := a;                        -- no permutation
      end if;
    end row_permute;

    procedure col_permute(a : in natural; pa : out natural) is
    begin
      if c_use_col_permute_file /= 0 then
        pa := total_col_permute_vector(a+selected_col_pv_offset_rdy);  --Apply permutation
      else
        pa := a;                        -- no permutation
      end if;
    end col_permute;


    procedure clear_wcount is
    begin
      wri        := 0;
      wci        := 0;
      wcount     := 0;
      smem_waddr := 0;
    end clear_wcount;


    procedure clear_rcount is
    begin
      rri    := 0;
      rci    := 0;
      rcount := 0;
      if c_mode = c_interleaver then
        row_permute(rri, p_rri);        --Apply row permutation
        col_permute(rci, p_rci);        --Apply col permutation
        smem_raddr := p_rri*selected_num_cols_rdy + p_rci;
      else
        if not pruned then
          col_permute(rri, p_rri);      --Apply col permutation
          row_permute(rci, p_rci);      --Apply row permutation
          smem_raddr := p_rri*selected_num_rows_rdy + p_rci;
        else
          smem_raddr := 0;
        end if;
      end if;
    end clear_rcount;


    procedure next_waddr is
    begin
      if wcount = selected_block_size_rdy-1 then
        clear_wcount;
        clear_rcount;
        fsm_state_rdy := READING_0;  --TBD this statement should be part of the fsm
        if all_valid_rdy = '1' then  --TBD this statement should be part of the fsm
          write_done := '1';  --only if all valid  --TBD this statement should be part of the fsm
        end if;
      elsif nd_rdy = '1' then
        wcount := wcount + 1;
      end if;
      smem_waddr := wcount;
    end next_waddr;


    procedure next_rcount is
    begin
      if rcount = selected_block_size_rdy-1 then
        clear_rcount;
        fsm_state_rdy  := IDLE;  --TBD this statement should be part of the fsm
       
        read_done      := '1';   --TBD this statement should be part of the fsm
        smem_block_end := '1';   --TBD this statement should be part of the fsm
      else
        if c_mode = c_interleaver then
          --read col-wise with pruning by column-length vector.
          --Apply permutation.
          if rri = col_length_vector(rci)-1 then
            rci := rci + 1;
            rri := 0;
          else
            rri := rri + 1;
          end if;
          row_permute(rri, p_rri);      --Apply row permutation
          col_permute(rci, p_rci);      --Apply col permutation
          smem_raddr := p_rri*selected_num_cols_rdy + p_rci;
        else
          --For deinterleaver,
          --read col-wise. With permutation. Only works if not pruned!
          if not pruned then
            if rri = selected_num_cols_rdy-1 then
              rci := rci + 1;
              rri := 0;
            else
              rri := rri + 1;
            end if;
            col_permute(rri, p_rri);    --Apply col permutation
            row_permute(rci, p_rci);    --Apply row permutation
            smem_raddr := p_rri*selected_num_rows_rdy + p_rci;
          else
            if rri = selected_num_cols_rdy-1 then
              rci        := rci + 1;
              rri        := 0;
              smem_raddr := rci;
            else
              smem_raddr := smem_raddr + col_length_vector(rri);
              rri        := rri + 1;
            end if;
          end if;
        end if;
        rcount := rcount + 1;
      end if;
    end next_rcount;

   
  begin

    if power /= '1' then
      init_vars;
      wr_en_int    <= '0';
      wr_en_buffer := (others => '0');
      wr_en_int    <= '0';
      rd_en_buffer := (others => '0');
      rd_en_int    <= '0';

    elsif clk'event and clk = '1' then
      if ce_int = '1' then
        if sclr_int = '1' then
          init_vars;

          wr_en_int    <= '0';
          wr_en_buffer := (others => '0');
          wr_en_int    <= '0';
          rd_en_buffer := (others => '0');
          rd_en_int    <= '0';
        else

          rdy_old := rdy_int;

          --Handle rfd and rffd.
          --Following a valid fd,
          --rffd goes to '1' after 'block-size' samples,
          --plus 'block-size' clocks.


          case fsm_state_rfd is
            when IDLE =>
              abort_rfd := '0';
            when IDLE_1 =>
              abort_rfd := v_fd_b;
            when WRITING =>
              abort_rfd := v_fd_b;
              if rfd_wcount = max_wcount-1 and nd_int = '1' then
                --the sample now on din will be the last,
                --after which, we are no longer ready for data
                rfd_int <= '0';
              end if;
              if rfd_wcount = max_wcount then
                --no need for nd, because last sample has now been written
                rfd_wcount    := 0;
                rfd_rcount    := 0;
                fsm_state_rfd := READING;
              elsif nd_int = '1' then
                rfd_wcount := rfd_wcount+1;
              end if;
              
            when READING =>
              abort_rfd := v_fd_b;
              if rfd_rcount = (selected_block_size-1)-1 then
                --the next value now on dout will be the last,
                --so we are ready for new data
                rfd_int  <= '1';
                rffd_int <= '1';
              end if;
              if rfd_rcount = (selected_block_size-1) then
                rfd_rcount    := 0;
                fsm_state_rfd := IDLE;
                abort_rfd     := '0';   --if here, a v_fd_b is not an abort
              else
                rfd_rcount := rfd_rcount + 1;
              end if;

            when others => null;
          end case;

          -- x_valid indicates when row_valid, col_valid, row_sel_valid, col_sel_valid
          --and block_size_valid are asserted. 



          --if something is invalid, assert rffd and rfd after rffd delay
          --one clock after all_valid_rfd is deasserted.
           if all_valid_rfd = '0' then
             if (c_has_row_valid = 1 and row_valid_int = '0') or
               (c_has_col_valid = 1 and col_valid_int = '0') or
               (c_has_row_sel_valid = 1 and row_sel_valid_int = '0') or
               (c_has_col_sel_valid = 1 and col_sel_valid_int = '0') or
               (c_has_block_size_valid = 1 and block_size_valid_int = '0') then
               rffd_int <= '1';
               rfd_int  <= '1';
             else  --if here, something is invalid, for which there is 
               -- no *valid pin, so rffd and rfd are undefined.
               rffd_int <= 'X';
               rfd_int  <= 'X';
             end if;
             fsm_state_rfd := IDLE_1;
           end if;

          
          --block_size_valid is updated a few clock cycles after the latest v_fd_b
          if v_fd_buffer(xvalid_buffer_length-1) = '1' then
            block_size_valid_int <= block_size_valid_buffer(xvalid_buffer_length-1);
          end if;
          for n in xvalid_buffer_length-1 downto 0 loop
            v_fd_buffer(n+1) := v_fd_buffer(n);
          end loop;

          if v_fd_b = '1' then
            
            load_sel_params;

            all_valid_buffer := (others => '1');
           
            rffd_int         <= '0';
            rfd_wcount       := 0;
            rfd_rcount       := 0;

            fsm_state_rfd := WRITING;
            rfd_int       <= '1';
          end if;

          
          v_fd_buffer(0) := v_fd_b;

          all_valid_rfd := all_valid_buffer(xvalid_buffer_length-1);
          for n in xvalid_buffer_length-1 downto 0 loop
            all_valid_buffer(n+1) := all_valid_buffer(n);
          end loop;
          all_valid_buffer(0) := all_valid;

          for n in all_valid_buffer_rdy'high-1 downto all_valid_buffer_rdy'low loop
            all_valid_buffer_rdy(n+1) := all_valid_buffer_rdy(n);
          end loop;
          all_valid_buffer_rdy(0) := all_valid;

          
          --Shift the xvalid FIFO.
          row_valid_int     <= row_valid_buffer(xvalid_buffer_length-1);
          row_sel_valid_int <= row_sel_valid_buffer(xvalid_buffer_length-1);
          col_valid_int     <= col_valid_buffer(xvalid_buffer_length-1);
          col_sel_valid_int <= col_sel_valid_buffer(xvalid_buffer_length-1);
          for n in xvalid_buffer_length-1 downto 0 loop
            block_size_valid_buffer(n+1) := block_size_valid_buffer(n);
            row_valid_buffer(n+1)        := row_valid_buffer(n);
            row_sel_valid_buffer(n+1)    := row_sel_valid_buffer(n);
            col_valid_buffer(n+1)        := col_valid_buffer(n);
            col_sel_valid_buffer(n+1)    := col_sel_valid_buffer(n);
          end loop;
          block_size_valid_buffer(0) := block_size_is_valid;
          row_valid_buffer(0)        := row_is_valid;
          row_sel_valid_buffer(0)    := row_sel_is_valid;
          col_valid_buffer(0)        := col_is_valid;
          col_sel_valid_buffer(0)    := col_sel_is_valid;



          smem_dout := smem(smem_raddr);

          v_fd_rdy := v_fd_0;
          nd_rdy   := nd_0;
      
          
          if fsm_state_rdy = IDLE then
            read_done      := '0';
            smem_block_end := '0';

            if v_fd_rdy = '1' then
              load_sel_params_rdy;

              if all_valid_rdy = '1' then
              
                clear_wcount;
                clear_rcount;
                fsm_state_rdy := WRITING;
              end if;
            end if;

          elsif fsm_state_rdy = START then
            read_done      := '0';
            smem_block_end := '0';

            if symbol_mem_style = c_distmem then
              --read before write
              smem_dout        := smem(smem_waddr);
              smem(smem_waddr) := din_del;
            else
              --write before read
              smem_dout        := din_del;
              smem(smem_waddr) := din_del;
            end if;

            if v_fd_rdy = '1' then
              load_sel_params_rdy;
              clear_wcount;

              if all_valid_rdy = '1' then
                fsm_state_rdy := WRITING;
              else
                fsm_state_rdy := IDLE;
              end if;
            else
              --update the write address
              next_waddr;
              if nd_rdy = '1' then  --nothing happens unless nd_rdy is asserted
                fsm_state_rdy := WRITING;
              end if;  --nd_rdy 
            end if;

          elsif fsm_state_rdy = WRITING then
            read_done      := '0';
            smem_block_end := '0';

            if symbol_mem_style = c_distmem then
              --read before write
              smem_dout        := smem(smem_waddr);
              smem(smem_waddr) := din_del;
            else
              --write before read
              smem_dout        := din_del;
              smem(smem_waddr) := din_del;
            end if;

            if v_fd_rdy = '1' then
              load_sel_params_rdy;
              write_done    := '0';
              clear_wcount;
             
              if all_valid_rdy = '1' then
                fsm_state_rdy := WRITING;
              else
                fsm_state_rdy := IDLE;
              end if;

            else
              next_waddr;
            end if;


          elsif fsm_state_rdy = READING_0 then
            write_done := '0';
            if v_fd_rdy = '1' then
              load_sel_params_rdy;
              clear_wcount;
              clear_rcount;
              read_done     := '1';
              if all_valid_rdy = '1' then
                fsm_state_rdy := START;
              else
                fsm_state_rdy := IDLE;
              end if;
             
            else
              next_rcount;
              fsm_state_rdy := READING_1;
            end if;

          elsif fsm_state_rdy = READING_1 then
            if v_fd_rdy = '1' then
              next_rcount;
              if rcount = 0 then
                load_sel_params_rdy;
                clear_wcount;
                clear_rcount;

                if all_valid_rdy = '1' then
                  fsm_state_rdy := WRITING;
                else
                  fsm_state_rdy := IDLE;
                end if;
              else
                load_sel_params_rdy;
                clear_wcount;
                clear_rcount;

                if all_valid_rdy = '1' then
                  fsm_state_rdy := START;
                else
                  fsm_state_rdy := IDLE;
                end if;

              end if;

              read_done := '1';
            else
              next_rcount;
            end if;

          end if;  --fsm_state_rdy   

          if v_fd_rdy = '1' then
            rdy_abort_buffer := (others => '0');
          end if;

          if write_done = '1' then
            rdy_set_buffer := (others => '0');
          end if;

          if read_done = '1' then
            rdy_clr_buffer := (others => '0');
          end if;

          
          rdy_abort := rdy_abort_buffer(output_buffer_length-1);
          rdy_valid := rdy_valid_buffer(output_buffer_length-1);
          rdy_set   := rdy_set_buffer(output_buffer_length-1);
          rdy_clr   := rdy_clr_buffer(output_buffer_length-1);
          for n in output_buffer_length-1 downto 0 loop
            rdy_set_buffer(n+1)   := rdy_set_buffer(n);
            rdy_clr_buffer(n+1)   := rdy_clr_buffer(n);
            rdy_abort_buffer(n+1) := rdy_abort_buffer(n);
            rdy_valid_buffer(n+1) := rdy_valid_buffer(n);
            block_end_buffer(n+1) := block_end_buffer(n);
          end loop;
          rdy_set_buffer(0)   := write_done;
          rdy_clr_buffer(0)   := read_done;
          block_end_buffer(0) := smem_block_end;
          rdy_abort_buffer(0) := v_fd_rdy;
          rdy_valid_buffer(0) := all_valid_rdy;

          


          if rdy_valid /= '1' then
            rdy_int         <= 'X';
            block_end_int   <= 'X';
            block_start_int <= 'X';
          else
            if rdy_abort = '1' then
              rdy_int          <= '0';
              block_end_buffer := (others => '0');
            elsif rdy_set = '1' then
              rdy_int <= '1';
            elsif rdy_clr = '1' then
              rdy_int <= '0';
            end if;
            block_end_int   <= block_end_buffer(output_buffer_length-1);
            block_start_int <= rdy_set;
          end if;

          

          --Shift the output FIFO.
          dout_buffer(0) := smem_dout;
          dout_int       <= dout_buffer(output_buffer_length-1);
          for n in output_buffer_length-1 downto 0 loop
            dout_buffer(n+1) := dout_buffer(n);
          end loop;


        end if;  --sclr   

        if c_external_ram /= 0 then

          --Shift the input FIFO.
          wr_data_int <= din_buffer(input_buffer_length-1);
          for n in input_buffer_length-1 downto 0 loop
            din_buffer(n+1) := din_buffer(n);
          end loop;
          if nd_int = '1' then
            if all_valid = '1' then
              din_buffer(0) := din;
            else
              --if here, deliberately write garbage into the ram
              --to highlight an invalid block;
              din_buffer(0) := (others => '1');
            end if;
          end if;

          for n in addr_buffer_length-1 downto 0 loop
            sram_raddr_buffer(n+1) := sram_raddr_buffer(n);
          end loop;
          sram_raddr_buffer(0) := smem_raddr;
          sram_raddr_int       <= integer_to_std_logic_vector(sram_raddr_int_d, c_ext_addr_width);
          sram_raddr_int_d     := sram_raddr_buffer(addr_buffer_length-1);

          for n in addr_buffer_length-1 downto 0 loop
            sram_waddr_buffer(n+1) := sram_waddr_buffer(n);
          end loop;
          sram_waddr_buffer(0) := smem_waddr;
          sram_waddr_int       <= integer_to_std_logic_vector(sram_waddr_int_d, c_ext_addr_width);
          sram_waddr_int_d     := sram_waddr_buffer(addr_buffer_length-1);


          for n in wr_en_buffer_length-1 downto 0 loop
            wr_en_buffer(n+1) := wr_en_buffer(n);
          end loop;



          -- If something is invalid, the timing of 
          -- wr_en is indeterminate.
          --
          if all_valid_rdy /= '1' then
            wr_en_buffer(0) := 'X';
          elsif (fsm_state_rdy = WRITING) or (fsm_state_rdy = START) then
            wr_en_buffer(0) := '1';
          else
            wr_en_buffer(0) := '0';
          end if;

          -- Change for v7.0 as part of the drive to remove X's from the model outputs.
          -- Overall it hasn't worked so I've removed the code for now
          -- 
          --if (fsm_state_rdy = WRITING) or (fsm_state_rdy = START) then
          --  wr_en_buffer(0) := '1';
          --else
          --  wr_en_buffer(0) := '0';
          --end if;

          
          -- Change for v7.0 as part of the drive to remove X's from the model outputs.
          -- Overall it hasn't worked so I've removed the code for now
          -- 
          --
          -- This is new code and might not fully work
          -- We're aborting the transfer because the block is invalid.
          -- Start masking on the cycle after rdy_valid goes low and stop masking when the head of the wr_en buffer returns to 0.

          -- Look for a falling edge on rdy_valid.  Once the head of the wr_en buffer goes back to 0 rdy_valid will still be 0
          -- so we need to make sure this doesn't trigger again
          --

          -- This doesn't work because you don't always get a 0 in the wr_en buffer.
          -- I think the way to handle this is just to wait for latency - 1 cycles which is what
          -- we delay invalid_input_abort by in the DUT
          --
          -- It still doesn't work because invalid_input_abort stays asserted in the DUT which prolongs the maskinof the output.
          -- Maybe not - fsm_state_rdy has stayed in writing even though the block is invalid
          --if v_mask_ext_mem_because_of_invalid_block = '1' then
          --  v_ext_mem_abort(v_ext_mem_abort'HIGH downto 1) := v_ext_mem_abort(v_ext_mem_abort'HIGH-1 downto 0);
          --  v_ext_mem_abort(0) := '0';
          --end if;
          --
          --
          --if rdy_valid = '0' and rdy_valid_d = '1' and v_mask_ext_mem_because_of_invalid_block = '0' then
          --  v_ext_mem_abort(0) := '1';
          --  v_mask_ext_mem_because_of_invalid_block := '1';
          ----elsif wr_en_buffer(wr_en_buffer_length-1) = '0' and v_mask_ext_mem_because_of_invalid_block = '1' then
          --elsif v_ext_mem_abort(v_ext_mem_abort'HIGH) = '1' then
          --  v_mask_ext_mem_because_of_invalid_block := '0';
          --end if;
          --
          --if v_mask_ext_mem_because_of_invalid_block = '1' then
          --  wr_en_int <= '0';
          --else
          --  wr_en_int <= wr_en_buffer(wr_en_buffer_length-1);
          --end if;


          wr_en_int <= wr_en_buffer(wr_en_buffer_length-1);

          for n in rd_en_buffer_length-1 downto 0 loop
            rd_en_buffer(n+1) := rd_en_buffer(n);
          end loop;
          -- If something is invalid, the timing of 
          -- rd_en is indeterminate.
          if all_valid_rdy /= '1' then
            rd_en_buffer(0) := 'X';
          elsif (fsm_state_rdy = READING_0) or (fsm_state_rdy = READING_1) then
            rd_en_buffer(0) := '1';
          else
            rd_en_buffer(0) := '0';
          end if;
          rd_en_int <= rd_en_buffer(rd_en_buffer_length-1);

        end if;
      else
        --This statement is needed because the write enable to distributed memory
        --is not gated with ce_int. The contents of the current address will
        --change even if ce_int is '0'.
        if (fsm_state_rdy = WRITING) or (fsm_state_rdy = START) then
          smem(smem_waddr) := din_del;
        end if;

      end if;  --ce_int   

    end if;  -- clk

  end process;

end behavioral;



---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
--                                                                          ---*
--        TOP LEVEL ENTITY FOR FORNEY INTERLEAVER / DEINTERLEAVER           ---*
--                                                                          ---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*
---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*

library ieee;
use ieee.std_logic_1164.all;

library xilinxcorelib;
use xilinxcorelib.sid_const_pkg_behav_v7_0.all;
use xilinxcorelib.sid_pkg_behav_v7_0.all;

use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- %%%

--core_if on entity sid_v7_0
  entity sid_v7_0 is
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
end sid_v7_0;


library xilinxcorelib;
use xilinxcorelib.axi_utils_pkg_v1_1.all;
use xilinxcorelib.axi_utils_v1_1_comps.all;

architecture behavioral of sid_v7_0 is

--Components
  component sid_bhv_forney_v7_0
    generic (
      c_mode                   : integer;
      c_symbol_width           : integer;
      -- Forney specific generics
      c_num_branches           : integer;
      c_branch_length_type     : integer;
      c_branch_length_constant : integer;
      c_branch_length_file     : string := "";
      c_has_fdo                : integer;
      c_has_ndo                : integer;
      -- Implementation generics
      c_pipe_level             : integer;
      -- Optional pin generics
      c_has_ce                 : integer;
      c_has_sclr               : integer;
      c_has_rdy                : integer;
      c_has_rffd               : integer;
      c_has_rfd                : integer;
      --New generics for v4_0
      c_external_ram           : integer;
      c_ext_addr_width         : integer;
      c_num_configurations     : integer);
    port (
      -- Mandatory pins
      clk          : in  std_logic;
      fd           : in  std_logic;
      nd           : in  std_logic;
      din          : in  std_logic_vector(c_symbol_width-1 downto 0);
      first_sample : in  std_logic := '0';   -- Asserted on the first sample of a block.  This doesn't mean every FD
      last_branch  : out std_logic := '0';   -- Asserted when we read data for the last branch


      -- The core has been changed to have reset override CE.  The easy fix for the model was to just force CE to 1
      -- during reset.  However, some part aren't reset (e.g. external memory interface) so they need access to the
      -- unadulterated CE.
      --
      actual_ce : in  std_logic  := '1';

      ce           : in  std_logic;
      sclr         : in  std_logic;
      dout         : out std_logic_vector(c_symbol_width-1 downto 0);
      rdy          : out std_logic;
      rffd         : out std_logic;
      rfd          : out std_logic;
      fdo          : out std_logic;
      ndo          : out std_logic;
      new_config   : in  std_logic;
      config_sel   : in  std_logic_vector(
        select_val(
          bits_needed_to_represent(c_num_configurations-1),
          1, c_num_configurations <= 1) -1 downto 0);
      rd_data      : in  std_logic_vector(c_symbol_width-1 downto 0);  -- Read data from external RAM
      rd_en        : out std_logic;
      wr_en        : out std_logic;
      rd_addr      : out std_logic_vector(c_ext_addr_width-1 downto 0);
      wr_addr      : out std_logic_vector(c_ext_addr_width-1 downto 0);
      wr_data      : out std_logic_vector(c_symbol_width-1 downto 0));  -- Write data to external RAM
  end component;

  component sid_bhv_rectangular_block_v7_0
    generic (
      c_family               : string;
      c_mode                 : integer;
      c_symbol_width         : integer;
      -- Row specific generics
      c_row_type             : integer;
      c_row_constant         : integer;
      c_has_row              : integer;
      c_has_row_valid        : integer;
      c_min_num_rows         : integer;
      c_row_width            : integer;
      c_num_selectable_rows  : integer;
      c_row_select_file      : string := "";
      c_has_row_sel          : integer;
      c_has_row_sel_valid    : integer;
      c_use_row_permute_file : integer;
      c_row_permute_file     : string := "";
      -- Column specific generics
      c_col_type             : integer;
      c_col_constant         : integer;
      c_has_col              : integer;
      c_has_col_valid        : integer;
      c_min_num_cols         : integer;
      c_col_width            : integer;
      c_num_selectable_cols  : integer;
      c_col_select_file      : string := "";
      c_has_col_sel          : integer;
      c_has_col_sel_valid    : integer;
      c_use_col_permute_file : integer;
      c_col_permute_file     : string := "";
      -- Block size specific generics
      c_block_size_type      : integer;
      c_block_size_constant  : integer;
      c_has_block_size       : integer;
      c_block_size_width     : integer;
      c_has_block_size_valid : integer;
      -- Implementation generics
      c_memstyle             : integer;
      c_pipe_level           : integer;
      -- Optional pin generics
      c_has_ce               : integer;
      c_has_nd               : integer;
      c_has_sclr             : integer;
      c_has_rdy              : integer;
      c_has_rffd             : integer;
      c_has_rfd              : integer;
      c_has_block_start      : integer;
      c_has_block_end        : integer;
      --New for generics v4_0
      c_architecture         : integer;
      c_external_ram         : integer;
      c_ext_addr_width       : integer);
    port (
      -- Mandatory pins
      clk              : in  std_logic;
      fd               : in  std_logic;
      din              : in  std_logic_vector(c_symbol_width-1 downto 0);
      -- Optional input pins
      ce               : in  std_logic;
      nd               : in  std_logic;
      sclr             : in  std_logic;
      row              : in  std_logic_vector(c_row_width-1 downto 0);
      row_sel          : in  std_logic_vector(
        bits_needed_to_represent(c_num_selectable_rows-1) - 1 downto 0);
      col              : in  std_logic_vector(c_col_width-1 downto 0);
      col_sel          : in  std_logic_vector(
        bits_needed_to_represent(c_num_selectable_cols-1) - 1 downto 0);
      block_size       : in  std_logic_vector(c_block_size_width-1 downto 0);
      -- Mandatory output pins
      dout             : out std_logic_vector(c_symbol_width-1 downto 0);
      -- optional output pins
      rfd              : out std_logic;
      rdy              : out std_logic;
      rffd             : out std_logic;
      row_valid        : out std_logic;
      col_valid        : out std_logic;
      row_sel_valid    : out std_logic;
      col_sel_valid    : out std_logic;
      block_size_valid : out std_logic;
      block_start      : out std_logic;
      block_end        : out std_logic;
      --New ports for v4_0
      rd_data          : in  std_logic_vector(c_symbol_width-1 downto 0);  -- Read data from external RAM
      rd_en            : out std_logic;
      wr_en            : out std_logic;
      rd_addr          : out std_logic_vector(c_ext_addr_width-1 downto 0);
      wr_addr          : out std_logic_vector(c_ext_addr_width-1 downto 0);
      wr_data          : out std_logic_vector(c_symbol_width-1 downto 0));  -- Write data to external RAM
  end component;  -- sid_bhv_rectangular_block_v7_0


  --If we don't have an external memory, the latency must be set to 0.
  -- c_ext_mem_latency should not be used after this point
  --
  constant R_ext_mem_latency  : integer := select_integer(0, c_ext_mem_latency, c_external_ram /= 0);




  -- Function used to get the C_HAS_CE generic value 
  -- ------------------------------------------------------------------------
  --
  function get_ce_generic (constant C_TYPE            : integer;
                           constant C_HAS_DOUT_TREADY : integer;
                           constant C_HAS_ACLKEN      : integer)
    return integer is
  begin


    if C_TYPE = c_forney_convolutional then
      return C_HAS_ACLKEN;
    else
      -- Rectangular mode
      -- When C_HAS_DOUT_TREADY = 0 C_HAS_CE is optional
      -- When C_HAS_DOUT_TREADY = 1 we MUST have CE.
      if C_HAS_DOUT_TREADY = 0 then
        return C_HAS_ACLKEN;
      else
        return 1;
      end if;
    end if;
    
  end get_ce_generic;
  -- --------------------------------------------------------------------


  function bool_to_std_logic (constant val : boolean)
    return std_logic is
  begin
    if val then
      return '1';
    end if;
    return '0';
  end bool_to_std_logic;
  
  

  signal aclken_i                    : std_logic := '1';
  signal reset                       : std_logic := '0'; -- Start off deasserted

  signal one      : std_logic := '1';

  
  constant config_sel_width : integer :=
    select_integer(bits_needed_to_represent(c_num_configurations-1),
                   1, c_num_configurations <= 1);




  -- Control Channel Signals
  -- ------------------------
  signal read_from_ctrl_fifo  : std_logic := '0';  -- The command to read from the CTRL fifo
  signal ctrl_fifo_has_data   : std_logic := '0'; -- Status saying the read happened
  signal ctrl_fifo_out        : std_logic_vector(C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0);
  signal s_axis_ctrl_tready_i : std_logic := '1';
  

  constant HAS_CTRL_CHANNEL : boolean := (C_TYPE = c_forney_convolutional and C_NUM_CONFIGURATIONS > 1) or
                                         (C_TYPE = c_rectangular_block and C_HAS_ROW = 1) or
                                         (C_TYPE = c_rectangular_block and C_HAS_ROW_SEL = 1) or
                                         (C_TYPE = c_rectangular_block and C_HAS_COL = 1) or
                                         (C_TYPE = c_rectangular_block and C_HAS_COL_SEL = 1) or
                                         (C_TYPE = c_rectangular_block and C_HAS_BLOCK_SIZE = 1);


  

  -- Data Input Channel Signals
  -- --------------------------
  signal read_from_din_fifo   : std_logic := '0';  -- The command to read from the Data In fifo
  signal din_fifo_has_data    : std_logic := '0';  -- Status saying the DIN fifo has data available
  signal din_fifo_in          : std_logic_vector(C_S_AXIS_DATA_TDATA_WIDTH +1 -1 downto 0);  -- TDATA + TLAST
  signal din_fifo_out         : std_logic_vector(C_S_AXIS_DATA_TDATA_WIDTH +1 -1 downto 0);  -- TDATA + TLAST
  signal din_tlast            : std_logic;
  signal din_tlast_unresolved : std_logic;   -- din_tlast from the AXI channel
  signal s_axis_data_tready_i : std_logic := '1';


  -- Data Output Channel Signals
  -- ----------------------------

  constant DOUT_CHAN_WIDTH : integer := calculate_dout_chan_width_no_padding(C_TYPE            => C_TYPE,
                                                                             C_SYMBOL_WIDTH    => C_SYMBOL_WIDTH,
                                                                             C_HAS_RDY         => C_HAS_RDY,
                                                                             C_HAS_BLOCK_START => C_HAS_BLOCK_START,
                                                                             C_HAS_BLOCK_END   => C_HAS_BLOCK_END,
                                                                             C_HAS_FDO         => C_HAS_FDO);
  
  signal dout_fifo_in         : std_logic_vector(DOUT_CHAN_WIDTH-1 downto 0);
  signal dout_fifo_out        : std_logic_vector(DOUT_CHAN_WIDTH-1 downto 0);
  signal dout_tlast           : std_logic;
  signal dout_channel_full    : std_logic := '0';
  signal write_to_dout_fifo   : std_logic := '0';


  

  -- Signals connecting to Processing Engine (PE)
  -- ---------------------------------------------
  signal din              : std_logic_vector(C_SYMBOL_WIDTH-1 downto 0);
  signal nd               : std_logic;
  signal fd               : std_logic; 
  signal rfd              : std_logic;
  signal rfd_raw          : std_logic;
  signal rffd             : std_logic;
  signal config_sel       : std_logic_vector(config_sel_width-1 downto 0);

  signal ndo_from_pe              : std_logic;
  signal fdo_from_pe              : std_logic;
  signal rdy_from_pe              : std_logic;
  signal rdy_raw          : std_logic;

    
  signal row              : std_logic_vector(c_row_width-1 downto 0);
  signal row_sel          : std_logic_vector((bits_needed_to_represent(c_num_selectable_rows-1) -1) downto 0);
  signal col              : std_logic_vector(c_col_width-1 downto 0);
  signal col_sel          : std_logic_vector((bits_needed_to_represent(c_num_selectable_cols-1) -1) downto 0);
  signal block_size       : std_logic_vector(c_block_size_width-1 downto 0);

  signal row_valid        : std_logic;
  signal row_sel_valid    : std_logic;
  signal col_valid        : std_logic;
  signal col_sel_valid    : std_logic;
  signal block_size_valid : std_logic;
  signal block_start_from_pe      : std_logic;
  signal block_end_from_pe        : std_logic;

  signal dout             : std_logic_vector(c_symbol_width-1 downto 0); -- Data from PE after external memory is considered


  signal ce_to_pe         : std_logic := '1';
  signal ce_to_pe_d       : std_logic := '1';

  -- The legacy core was designed to have CE override reset.  i.e. if a reset happened while ce was low, the reset would
  -- be ignored.  That is changing in v8.0 of the core.  To fix the simulation model, we always force CE = 1 when reset
  -- is asserted. That means we need a ce_to_pe that actually goes to the processing engine, and another that mimicks
  -- the one in the RTL AXI interface.
  --
  signal ce_to_pe_cr613301 : std_logic := '1';


  signal last_data_in     : std_logic := '0';  -- Used in rectangular mode when to work out if TLAST is correct

  -- Event Signals
  -- -------------- 
 
  signal halt                          : std_logic := '0';
  signal event_halted_i                : std_logic := '0';
  signal din_tlast_d                   : std_logic := '0'; -- din_tlast delayed by one cycle
  signal rffd_d                        : std_logic := '0'; -- rffd delayed by one cycle
  signal rfd_d                         : std_logic := '0'; -- rfd delayed by one cycle
  signal nd_d                          : std_logic := '0'; -- nd delayed by one cycle

  signal expected_end_of_block : std_logic := '0';
  

  signal first_sample_seen_after_reset : std_logic := '0'; -- Asserted when the first sample is consumed after reset.  
                                                           -- It remains asserted until a new reset is seen.  It's
                                                           -- used in the generation of event_tlast_missing.

  signal frame_started : std_logic := '0';  -- Asserted when the first sample is consumed after reset or after
                                            -- a tlast.  

  
  signal tlast_seen : std_logic := '1';  -- Set when a sample with TLAST asserted has been seen, and cleared when a
                                         -- sample without TLAST asserted has been seen
  

  signal last_branch : std_logic := '0';  -- Asserted by teh Forney PE when a sample will be for the last branch.

  signal first_sample : std_logic := '0'; -- Asserted when the first sample of a block is passed to the core.
                                          -- It's set on reset or on a new configuration and cleared when that
                                          -- sample is sent.  In forney mode it will only be asserted once per reset
                                          -- if there is no configuration channel.  If there is, it will be asserted every
                                          -- time a configuration is applied

  -- These two are "resolved" with ce_to_pe.  i.e. they are anded with it when appropriate, or just
  -- aliased to the original signal when resolving with ce is not appropriate.
  --
  
  signal ndo_resolved : std_logic := '0';
  signal rdy_resolved : std_logic := '0';


  -- "Aligned" signals.  When we have an external memory with a latency, the DOUT signal from memory
  -- becomes unaligned with the other output signals.  That is, the DOUT signal has a user defined latency
  -- that the other signals don't.  We add that latency back in before passing everything to the output FIFO.
  --
  -- The inputs to the delay lines are the outputs of the PE and the outputs of the delay lines are those signals
  -- with _aligned added.  

  signal dout_tlast_aligned       : std_logic;
  signal ndo_aligned              : std_logic;
  signal fdo_aligned              : std_logic;
  signal rdy_aligned              : std_logic;
  signal block_start_aligned      : std_logic;
  signal block_end_aligned        : std_logic;

  
  -- Used in Forney TREADY mode to reduce the threshold on the output FIFO
  CONSTANT latency : INTEGER := get_latency(c_type,
                                            c_row_type,
                                            c_use_row_permute_file,
                                            c_col_type,
                                            c_use_col_permute_file,
                                            c_block_size_type,
                                            c_pipe_level,
                                            c_external_ram);
  
  -- Delay RFFD to get TLAST on the output channel
  signal rffd_vec : std_logic_vector(latency-1 downto 0);

 
begin




  -- AXI Reset
  -- ---------

  has_no_aclken : if (C_HAS_ACLKEN = 0) generate aclken_i <= '1'; end generate;
  has_aclken    : if (C_HAS_ACLKEN = 1) generate aclken_i <= aclken; end generate;

  has_no_aresetn : if (C_HAS_ARESETN = 0) generate
    reset     <= '0';
  end generate;
  
  has_aresetn    : if (C_HAS_ARESETN = 1) generate
    -- Register and invert reset
    p_generate_reset : process (aclk)
    begin
      if rising_edge(aclk) then
        reset <= not aresetn;
      end if;
    end process p_generate_reset;
  end generate;



  -- --------------------------------------------------------------------------
  -- Control AXI Channel
  -- --------------------------------------------------------------------------
  -- The channel consists of a 2 entry skid buffer.  It is written to by the AXI bus.
  -- It is read from (assuming it has data) when new data (ND) is written to the PE
  -- with the FD flag asserted.
  --
  -- Note that clock enables are not shown in this diagram.  In Forney mode the AXI bus and the PE
  -- will run on the same clock enable.  In rectangular mode, they may be different, so will have to be
  -- taken into account on the PE side of the FIFO.
  --
  -- For simplicity, we will always use ce_to_pe in the equations, with that being driven differently
  -- as required.
  --
  -- Read from the control FIFO when we write the FD to the Processing Engine and it is clock enabled.
  -- In Forney mode, also wait until we have seen a TLAST from the previous frame (set to 1 on reset to
  -- automagically create a previsou frame)
  -- 
  --  read_from_ctrl_fifo <= nd and fd and ce_to_pe
  --  
  -- new_config needs to be driven by read_from_ctrl_fifo as we don't want new_config driven high
  -- until the previous frame actually completes.


  --
  -- Padding is not removed.        This block spilts the vector into signals 
  -- We rely on the synthesis       suitable for the Processing Engine (PE)                                        
  -- tool removing bits that                     |                         \
  -- aren't connected on the                     |                          \ 
  -- output side of the FIFO                     |                           \
  --                                             |                            \          
  --           |                                 v                             \ 
  --           |          _____                  _                              ,----------------              
  --           |         |     |                | |--- CONFIG_SEL   ----------> | config_sel               
  --           |         |     | ctrl_fifo_out  | |--- ROW, ROW_SEL ----------> | row, row_sel                
  --           |         |     |--------------->|2|--- COL, COL_SEL ----------> | col, col_sel
  --           v         |     |                |_|--- BLOCK_SIZE   ----------> | block_size                 
  --                     |     |                                                |
  -- TDATA ------------->|  1  |--- read_from_ctrl_fifo ----------------------> | new_config                 
  --                     |     |                                                |     
  --                     |     |                                                |
  -- TVALID ------------>|     |<-- read_from_ctrl_fifo -- << (ND && FD)        |     
  -- TREADY <------------|     |                                         .----->| FD                           
  --                     |_____|                                         |  .-->| ND         
  --               ________/                                             |  |   `----------------                  
  --              /                                                      |  |      
  --   A two element skid buffer which is used to allow,              From Data Input Channel
  --   a registered TREADY and reduce the number of                 
  --   logic levels required for some calculations                  
  --
  -- 


  gen_no_ctrl_chan: if HAS_CTRL_CHANNEL = false generate
    ctrl_fifo_has_data <= '1';  --This prevents the DIN channel stalling when there's no CTRL channel
  end generate gen_no_ctrl_chan;

  gen_ctrl_chan: if HAS_CTRL_CHANNEL = true generate

    gen_rect: if C_TYPE = c_rectangular_block generate
      read_from_ctrl_fifo  <= nd       -- Data is being read from the DIN FIFO.
                              and fd;  -- It's the first data.
    end generate;
    
    gen_forney: if C_TYPE = c_forney_convolutional generate
      read_from_ctrl_fifo  <= nd              -- Data is being read from the DIN FIFO.
                              and fd          -- It's the first data.
                              and tlast_seen; -- And we've seen a TLAST (or reset). This stops us reading when we have a FD
                                              -- but no previous TLAST
    end generate;



    -- The skid buffer asserts TVALID when ACLKEN is 0, so we have to qualify the TVALID with ACLKEN so that we don't pass
    -- data to the DUT when the buffer is disabled because of ACLKEN.
    --
    ctrl_fifo : axi_slave_2to1_v1_1
      generic map (
        C_A_TDATA_WIDTH => C_S_AXIS_CTRL_TDATA_WIDTH,   -- Store the padding as well - it will get optimised away
        C_HAS_A_TUSER   => false,
        C_A_TUSER_WIDTH => 1,
        C_HAS_A_TLAST   => false,
        C_B_TDATA_WIDTH => 1,
        C_HAS_B_TUSER   => false,
        C_B_TUSER_WIDTH => 1,
        C_HAS_B_TLAST   => false,
        C_HAS_Z_TREADY  => true
        )
      port map(
        aclk   => aclk,
        aclken => aclken_i,
        sclr   => reset,
          
        -- AXI slave interface A
        s_axis_a_tready => s_axis_ctrl_tready_i,
        s_axis_a_tvalid => s_axis_ctrl_tvalid,
        s_axis_a_tdata  => s_axis_ctrl_tdata,
        s_axis_a_tuser  => open,
        s_axis_a_tlast  => open,
        
        -- AXI slave interface B
        s_axis_b_tready => open,
        s_axis_b_tvalid => one,
        s_axis_b_tdata  => open,
        s_axis_b_tuser  => open,
        s_axis_b_tlast  => open,
        
        -- Read interface to core
        m_axis_z_tready  => read_from_ctrl_fifo, 
        m_axis_z_tvalid  => ctrl_fifo_has_data,
        m_axis_z_tdata_a => ctrl_fifo_out,
        m_axis_z_tuser_a => open,
        m_axis_z_tlast_a => open,  
        m_axis_z_tdata_b => open, 
        m_axis_z_tuser_b => open,  
        m_axis_z_tlast_b => open
        );
    
    axi_chan_ctrl_convert_fifo_out_to_pe_in (fifo_vector           => ctrl_fifo_out,
                                             config_sel            => config_sel,
                                             row                   => row,
                                             row_sel               => row_sel,
                                             col                   => col,
                                             col_sel               => col_sel,
                                             block_size            => block_size,
                                             C_TYPE                => C_TYPE,
                                             C_NUM_CONFIGURATIONS  => C_NUM_CONFIGURATIONS,
                                             C_HAS_ROW             => C_HAS_ROW,
                                             C_HAS_ROW_SEL         => C_HAS_ROW_SEL,
                                             C_HAS_COL             => C_HAS_COL,
                                             C_HAS_COL_SEL         => C_HAS_COL_SEL,
                                             C_HAS_BLOCK_SIZE      => C_HAS_BLOCK_SIZE,
                                             C_ROW_WIDTH           => C_ROW_WIDTH,
                                             C_NUM_SELECTABLE_ROWS => C_NUM_SELECTABLE_ROWS,
                                             C_COL_WIDTH           => C_COL_WIDTH,
                                             C_NUM_SELECTABLE_COLS => C_NUM_SELECTABLE_COLS,
                                             C_BLOCK_SIZE_WIDTH    => C_BLOCK_SIZE_WIDTH
                                             );

    s_axis_ctrl_tready  <= s_axis_ctrl_tready_i;
  end generate gen_ctrl_chan;



  -- --------------------------------------------------------------------------
  -- Data In AXI Channel
  -- --------------------------------------------------------------------------
  -- The channel consists of a two element skid buffer.  It is written to by the AXI bus.
  -- It is read from (assuming it has data) when the PE requests data.  That is, when the PE
  -- asserts RFD.  However, if the FD flag is asserted, it won't be read until
  -- the core requests data AND the control channel also has data.  This is because the control
  -- channel is blocking.
  --
  --
  -- Padding is not removed.        This block spilts the vector into signals 
  -- We rely on the synthesis       suitable for the Processing Engine (PE)                                        
  -- tool removing bits that                     |                         \
  -- aren't connected on the                     |                          \ 
  -- output side of the FIFO                     |                           \
  --                                             |      Event Generator       \          
  --           |                                 |            ^                \ 
  --           |          _____                  v            |        ,----------------              
  --           |         |     |                 _            |        | 
  --           |         |     | din_fifo_out   | |--- TLAST--'
  --           |         |     |--------------->|2|                    |
  --           |         |     |                |_|--- DATA ---------->| DIN 
  --           |         |     |                                       |
  --           |         |     |                                       |
  --           |         |     |                  FD Generator ------->| FD                    |
  --           |         |  1  |                                       |
  --           v         |     |                                       |
  -- TDATA ------------->|     |<---------------------   ------------->| ND  
  --                     |     |                      \ /              |   
  --                     |     |                       |               | 
  -- TVALID ------------>|     |    .------>  read_from_din_fifo       |
  -- TREADY <------------|     |    |                                  |                           
  --                     |_____|- din_fifo_has_data                    |         
  --               ________/                                           `----------------                  
  --              /                       
  --             /               
  --   A two element skid buffer which is used to allow,                                     
  --   a registered TREADY and reduce the number of                 
  --   logic levels required for some calculations                  
  --
  -- 

  din_fifo_in <= s_axis_data_tdata & s_axis_data_tlast; -- Concatenate TDATA and TLAST
                                                        -- to store them in the FIFO.

  -- The control signals between the DIN FIFO and the CTRL FIFO are intertwined, so we need to be careful we don't get deadlock.
  -- There are also two clock enable domains in play at times.
  --
  -- We read from the DIN FIFO when the PE wants data (RFD) and it's not the first data, or if it is, only when the CTRL FIFO also
  -- has data.  We don't wait for the read of that data to happen - that is triggered by the read from the DIN FIFO.
  --
  -- NOTE: The skid buffer asserts TVALID when ACLKEN is 0, so we have to qualify the TVALID with ACLKEN so that
  -- we don't pass data to the DUT when the buffer is disabled because of ACLKEN.
  --
  -- NOTE: This really says don't assert TREADY to the skid buffer until we are ready AND it has data.  The "and it has data" is
  --       only needed because we use read_from_din_fifo as a command (do the read) and as status (the read occurred).
  --

  -- In forney mode I want ce_to_pe to be the same as aclken and use halt to disable the core.  This will happen by
  -- blocking reads from the FIFO.  Therefore, ce_to_pe in the following equation can be replaced with halt='0' in forney mode.

  -- So basically, we read the fifo and assert ND when
  --        1) The PE wants data and is enabled
  --        2) The DIN channel has data and it's enabled
  --        3) The control channel has data and we're waiting on the first FD
  --
  
  gen_forney_nd: if C_TYPE = c_forney_convolutional generate
    read_from_din_fifo <=

      -- 1) The PE wants data and is enabled
      --
      (rfd and (not halt))

      -- 2) The DIN channel has data and it's enabled
      --
      and (din_fifo_has_data and aclken_i)
      

      -- 3) The control channel has data and we're waiting on the first FD of a frame,
      --    or we've already had the first
      --    FD, in which case we can ignore the control channel.
      --
      and (ctrl_fifo_has_data or frame_started);
  end generate gen_forney_nd;

  gen_rectangular_nd: if C_TYPE = c_rectangular_block generate
    read_from_din_fifo <= 
      -- 1) The PE wants data and is enabled
      --
      (rfd and ce_to_pe)
      
      -- 2) The DIN channel has data and it's enabled
      --
      and (din_fifo_has_data and aclken_i)
      
      -- 3) The control channel has data and we're waiting on the first FD, or we've already had the first
      --    FD
      --
      and (ctrl_fifo_has_data or (not fd));
  end generate gen_rectangular_nd;


  fd <= rffd;   -- FD only takes effect when ND is asserrted, so don't complicate things by including the FIFO status in here.  Just
                      -- let FD assert for as long as is necessary.
  nd <= read_from_din_fifo; 


  
  din_fifo : axi_slave_2to1_v1_1
        generic map (
          C_A_TDATA_WIDTH => C_S_AXIS_DATA_TDATA_WIDTH + 1,   -- Store the padding as well - it will get optimised away
          C_HAS_A_TUSER   => false,
          C_A_TUSER_WIDTH => 1,
          C_HAS_A_TLAST   => false,
          C_B_TDATA_WIDTH => 1,
          C_HAS_B_TUSER   => false,
          C_B_TUSER_WIDTH => 1,
          C_HAS_B_TLAST   => false,
          C_HAS_Z_TREADY  => true
          )
        port map(
          aclk   => aclk,
          aclken => aclken_i,
          sclr   => reset,
          
          -- AXI slave interface A
          s_axis_a_tready => s_axis_data_tready_i,
          s_axis_a_tvalid => s_axis_data_tvalid,
          s_axis_a_tdata  => din_fifo_in,
          s_axis_a_tuser  => open,
          s_axis_a_tlast  => open,

          -- AXI slave interface B
          s_axis_b_tready => open,
          s_axis_b_tvalid => one,
          s_axis_b_tdata  => open,
          s_axis_b_tuser  => open,
          s_axis_b_tlast  => open,

          -- Read interface to core
          m_axis_z_tready  => read_from_din_fifo, 
          m_axis_z_tvalid  => din_fifo_has_data,
          m_axis_z_tdata_a => din_fifo_out,
          m_axis_z_tuser_a => open,
          m_axis_z_tlast_a => open,  
          m_axis_z_tdata_b => open, 
          m_axis_z_tuser_b => open,  
          m_axis_z_tlast_b => open
          );


  axi_chan_din_convert_fifo_out_to_pe_in  (fifo_vector           => din_fifo_out,
                                           data                  => din,
                                           tlast                 => din_tlast_unresolved,
                                           C_SYMBOL_WIDTH        => C_SYMBOL_WIDTH);
  
  din_tlast <= din_tlast_unresolved and nd;  
  s_axis_data_tready  <= s_axis_data_tready_i;


  -- --------------------------------------------------------------------------
  -- Data Out AXI Channel
  -- --------------------------------------------------------------------------
  --
  -- This block concatenates the signals into a single vector which
  -- can be stored in a FIFO if required.  No padding is added.
  --            \______________________  
  --   ______                          \                    _____                 _
  --         |                          \                  |     |               | | TDATA    
  --         |                           \_                |     |               | |-------
  --         |                           | |               |     |               | | 
  --         |---dout------------------->| |               |     |               | |
  --     P   |                           | |  dout_fifo_in |     | dout_fifo_out | | TUSER    
  --     E   |---ndo, fdo, rdy --------->|1|-------------->|  2  |---------------|3|-------
  --         |                           | |               |     |               | |     
  --         |---block_start, block_end->| |               |     |               | |
  --         |                           | |               |     |               | | TLAST
  --         |    rffd_del/block_end---->|_|               |     |               | |-------     
  --   ______|                                             |_____|               |_|     
  --               __________________________________________/         __________/ 
  --              /                                                   /   
  --   This block is a FIFO when C_HAS_DOUT_TREADY = 1,         This block spilts the vector and merges the individual 
  --   and is just some aliasing when it is 0.                  signals into TDATA and TUSER.  Padding is added where required.
  --
  
  
  -- In Forney mode, NDO is asserted when there's data coming out and RDY is just a TUSER status flag.
  -- In rectangular mode, NDO doesn't exist and RDY specifies when data comes out of the PE.

  -- Generating TLAST.  In forney mode, I want tlast asserted when the commutator reaches the last branch.
  --                    In rectangular mode, it's when the last symbol comes out.



    -- Generating TLAST.  In forney mode, I want tlast asserted when the commutator reaches the last branch.
    --                          In rectangular mode, it's when the last symbol comes out.


    gen_forney_tlast: if C_TYPE = c_forney_convolutional generate
      -- RFFD is asserted when the commutator leaves the last branch and moves to the first.  If we delay it by latency,
      -- then we see it asserted when the last sample comes out.
      -- RFFD can stay high and it's the it's the pulse we care about, so do some edge detection

      p_delay_line: process (aclk)
      begin
        if rising_edge(aclk) then
          if reset = '1' then
            rffd_vec <= (others => '0');
          elsif ce_to_pe = '1' then
            if rffd = '1' and rffd_d = '0' and first_sample_seen_after_reset = '1' then
              rffd_vec(0) <= '1';
            else
              rffd_vec(0) <= '0';
            end if;

            rffd_vec(rffd_vec'high downto rffd_vec'low +1) <= rffd_vec(rffd_vec'high-1 downto rffd_vec'low);
          end if;
        end if;
        dout_tlast <= rffd_vec(rffd_vec'high);
       
      end process p_delay_line;
    end generate gen_forney_tlast;

    gen_rectangular_tlast: if C_TYPE = c_rectangular_block generate
      dout_tlast <= block_end_from_pe;
    end generate gen_rectangular_tlast;


  
  -- Step 1: Merge PE outputs into single vector
  -- --------------------------------------------------
  --
  axi_chan_dout_build_fifo_in_vector(tlast_in         => dout_tlast_aligned,
                                     dout             => dout,
                                     ndo              => ndo_aligned,
                                     fdo              => fdo_aligned,
                                     rdy              => rdy_aligned,
                                     block_start      => block_start_aligned,
                                     block_end        => block_end_aligned,
                                     out_vector       => dout_fifo_in,
                                     C_TYPE           => C_TYPE,
                                     C_SYMBOL_WIDTH   => C_SYMBOL_WIDTH,
                                     C_HAS_RDY        => C_HAS_RDY,
                                     C_HAS_BLOCK_START=> C_HAS_BLOCK_START,
                                     C_HAS_BLOCK_END  => C_HAS_BLOCK_END,
                                     C_HAS_FDO        => C_HAS_FDO
                                   );


  dout_channel_has_no_dout_tready : if (C_HAS_DOUT_TREADY = 0) generate
    -- No output FIFO so just pass vector
    dout_fifo_out  <= dout_fifo_in;
    halt                  <= '0';

    ce_to_pe              <= aclken_i;
    ce_to_pe_cr613301     <= aclken_i or reset;

    --m_axis_data_tvalid    <= ndo_from_pe when C_TYPE = c_forney_convolutional else
    --                         rdy_from_pe;  -- When rectangular 

    m_axis_data_tvalid    <= ndo_aligned when C_TYPE = c_forney_convolutional else
                             rdy_aligned;  -- When rectangular 
   
  end generate;

  dout_channel_has_dout_tready : if (C_HAS_DOUT_TREADY = 1) generate

    -- This decides how full the FIFO can get before we stall the core.  That depends on several factors.
    -- In forney mode we stall by blocking ND, so we have to accomodate the samples that may be in the core, and samples that
    -- may be in the external memory delay lines.
    --
    -- In rect mode we halt the core by deasserting CE, so we only have to store samples that may be in the external memory delay lines.
    --

    -- Max Rectangular thresh = 6
    -- Max Forney thresh = 6 (latency) + 6 (ext mem)

    constant THRESH_ADJUSTMENT : integer:= select_integer(0, latency, c_type = c_forney_convolutional) + R_ext_mem_latency;


    -- If the threshold adjustment is > 8 (i.e. we're going to be halting the core at less than half its depth), then
    -- use a bigger FIFO to maintain elasticity.  8 comes from the max latency of 6 due to the c_pipe_level parameter and
    -- allows the user 2 registers to help external mem performance without increasing resources too much.  This means the FIFO
    -- can have 6 elements in it before stalling the core.  
    -- 
    constant FIFO_DEPTH : integer := select_integer(16, 32, THRESH_ADJUSTMENT > 8 );

  begin
    -- Has output FIFO.
    --
    write_to_dout_fifo <= '1' when ((ndo_aligned = '1' and C_TYPE = c_forney_convolutional) or
                                    (rdy_aligned = '1' and C_TYPE = c_rectangular_block)) and aclken_i = '1'
                          else '0';



    fifo : glb_ifx_master_v1_1
      generic map (
        WIDTH         => DOUT_CHAN_WIDTH,
        DEPTH         => FIFO_DEPTH,
        AFULL_THRESH1 => FIFO_DEPTH - 2 - THRESH_ADJUSTMENT,
        AFULL_THRESH0 => FIFO_DEPTH - 2 - THRESH_ADJUSTMENT
        )
      port map (
        aclk   => aclk,
        aclken => aclken_i,
        areset => reset,

        wr_enable => write_to_dout_fifo,
        wr_data   => dout_fifo_in,

        ifx_valid => m_axis_data_tvalid,
        ifx_ready => m_axis_data_tready,
        ifx_data  => dout_fifo_out,

        afull     => dout_channel_full,
        full      => open,
        not_full  => open,
        not_afull => open,
        add       => open);


    -- Disable the core (drive CE = 0) when the FIFO is full.  
    halt <= dout_channel_full;

    -- In forney node we can just stop it reading the FIFO rather than messing with PE.
    --
    gen_forney: if C_TYPE = c_forney_convolutional generate
      ce_to_pe          <= aclken_i;
      ce_to_pe_cr613301 <= aclken_i or reset;

    end generate gen_forney;

    gen_rectangular: if C_TYPE = c_rectangular_block generate
      --p_ce_to_pe: process (aclk)
      --begin
      --  if rising_edge(aclk) then
      --    if reset = '1' then
      --      ce_to_pe <= '1';
      --    else
      --      ce_to_pe <= aclken_i and (not halt);
      --    end if;
      --  end if;
      --end process p_ce_to_pe;

      ce_to_pe          <= aclken_i and (not halt);
      ce_to_pe_cr613301 <= ce_to_pe or reset;
      
    end generate gen_rectangular;
  end generate;

 

 axi_chan_dout_convert_fifo_out_vector_to_axi (fifo_vector      => dout_fifo_out,
                                               tdata            => m_axis_data_tdata,
                                               tuser            => m_axis_data_tuser,
                                               tlast            => m_axis_data_tlast,
                                               C_TYPE           => C_TYPE,
                                               C_SYMBOL_WIDTH   => C_SYMBOL_WIDTH,
                                               C_HAS_RDY        => C_HAS_RDY,
                                               C_HAS_BLOCK_START=> C_HAS_BLOCK_START,
                                               C_HAS_BLOCK_END  => C_HAS_BLOCK_END,
                                               C_HAS_FDO        => C_HAS_FDO
                                               );
  


  -- AXI Event Interface
  -- -------------------

  -- Clock-enable domain crossing
  --
  -- Any event that lasts for a single clock cycle can be lost if we don't
  -- handle domain crossing properly.
  --
  --              _   _   _   _   _   _   _   _   _   _   _
  -- aclk       _/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
  --            __                     ____________________
  -- aclken       |___________________|
  --            ______                     ________________
  -- ce_to_pe         |___________________|
  --               ___                                          
  -- event     ___|   |_____________________________________
  --
  --                1                    
  --
  -- 1 is lost because system is clock "disabled" but PE isn't
  --
  -- Longer events are not a problem so don't need to be handled specially.  The
  -- following example is for a 2 cycle event that's stretched because of clock enable:
  --              _   _   _   _   _   _   _   _   _   _   _
  -- aclk       _/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
  --            __                     ____________________
  -- aclken       |___________________|
  --            ______                     ________________
  -- ce_to_pe         |___________________|
  --               ____________________________                                         
  -- event     ___|                            |____________
  --
  --                1                    2   3            
  --
  -- 1 is lost because system is clock "disabled" but PE isn't
  -- 2 is seen by system while PE is still disabled. This compensated for 1
  -- 3 is seen by system

  -- The following events are multi-cycle so don't need special treatment
  --
  -- event_row_valid        
  -- event_col_valid        
  -- event_row_sel_valid    
  -- event_col_sel_valid    
  -- event_block_size_valid 
  --
  -- Don't register them as they come from registers in the next level of hierarchy down.
  
  event_row_valid        <= row_valid;
  event_col_valid        <= col_valid;
  event_row_sel_valid    <= row_sel_valid;
  event_col_sel_valid    <= col_sel_valid;
  event_block_size_valid <= block_size_valid;

  
  -- The following events are single so need to be handled properly.  Take the code from the FFT and turn it into a component:

  -- event_tlast_missing
  -- event_tlast_unexpected.  These can occur back to back and if that happens and the first overlaps with aclken going low, then
  --                          a special clockenable domain crosser is needed.  The simple FSM one will merge the events

  
  -- event_halted.   There's no need to synchronise as the event is not generated in the ce_to_pe domain (in fact, it generates the ce_to_pe domain)

  
  -- Event Halted
  -- --------------------
  -- event_halted  :  Asserted when the core is halted due to the output data channel being full
  --
  -- It will take 1 cycle for the external event to be seen by anything using it on a rising clock edge.  

  gen_event_halted: if C_HAS_DOUT_TREADY = 1 generate
    p_event_halted : process (aclk)
    begin
      if rising_edge(aclk) then
        if reset = '1' then
          event_halted_i  <= '0';
        else
          event_halted_i  <= halt;
        end if;
      end if;
    end process p_event_halted;
    
    event_halted  <= event_halted_i;
  end generate gen_event_halted;




  -- TLAST events
  -- ------------

  p_delay_signals: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset = '1' then
        din_tlast_d <= '0';
        rffd_d      <= '0';
        rfd_d       <= '0';
        nd_d        <= '0';
      elsif ce_to_pe = '1' then
        din_tlast_d <= din_tlast;
        rffd_d      <= rffd;
        rfd_d       <= rfd;
        nd_d        <= nd;
      end if;
    end if;
  end process p_delay_signals;


  expected_end_of_block  <= '1' when
                            (rfd = '0' and rfd_d = '1') or                              -- Falling edge on RFD
                            (rfd = '1' and rfd_d = '1' and rffd = '1' and rffd_d = '0') -- No falling edge on RFD but rising edge on RFFD.
                                                                                        -- This is an abort dure to an invalid block
                            else '0';
                            

  
  p_first_sample_after_reset: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset = '1' then
        first_sample_seen_after_reset <= '0';
      elsif ce_to_pe = '1' then
        if fd = '1' and nd = '1' then
          first_sample_seen_after_reset <= '1';
        end if;
      end if;
    end if;
  end process p_first_sample_after_reset;




  -- frame_started is set to mark the fact that we've seen the first sample of a block, so we shouldn't block reads from the
  -- DIN channel because the control channel is empty.
  --
  -- It needs to be set when we pass the first sample to the core.
  -- It needs to be cleared when we pass the last sample to the core.  
  --
  
  p_frame_started: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset = '1' then
        frame_started <= '0';
      elsif ce_to_pe = '1' then

        -- Deassert frame starts if we see the end of a frame (RFFD asserting and TLAST set) and we didn't start a new frame at the same time.
        -- If we do see a frame start, then keep the flag asserted.
        -- This didn't work.

        -- Ok.
        -- Frame Starts is asserted to tell us a frame has started.
        -- TLAST Seen tells us we've seen a TLAST
        -- Question is when to stop consuming data 
        

        if nd = '1' and (din_tlast = '1' or tlast_seen = '1') and last_branch = '1' then
          frame_started <= '0'; 
        elsif fd = '1' and nd = '1' then
          frame_started <= '1';
        end if;
      end if;
    end if;
  end process p_frame_started;


  -- TLAST seen is used to block reads from the Control Channel.  We can only read from it when it's the first data (FD && ND) AND we have finished the previous
  -- frame (tlast_seen = 1)
  p_tlast_seen: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset = '1' then
        tlast_seen <= '1';  -- Make RESET look like a tlast
      elsif ce_to_pe = '1' then
        if nd = '1' and din_tlast = '1' then
          tlast_seen <= '1';
        elsif fd = '1' and nd = '1' then
          tlast_seen <= '0';
        end if;
      end if;
    end if;
  end process p_tlast_seen;
  



  

  -- I need to mark the first sample to the core so it knows when a block is starting (Forney only).
  --
  first_sample <= '1' when fd = '1' and nd = '1' and tlast_seen = '1' and (
                                 (HAS_CTRL_CHANNEL = false) or 
                                 (read_from_ctrl_fifo = '1' and HAS_CTRL_CHANNEL = true)
                                 )
                  else '0';

  

  -- Event TLAST Missing
  -- --------------------
  -- Asserted on the last sample of an incoming block if s_axis_data_tlast is not seen asserted within an incoming block
  -- of data. The meaning of "Last Sample" varies between Forney and Rectangular mode:
  --   * Forney     : the sample corresponding to the last branch.
  --   * Rectangular: the final sample loaded for a block
  --                                                                                                                         
  -- This event is asserted some time after TLAST actually occurred on the AXI channel, as the check only runs when the
  -- data is fed into the PE.  In addition to that, it will take 1 cycle for the external event to be seen by anything using it
  -- on a rising clock edge.  This event it only really useful to say that something has gone wrong, but there's no real way to
  -- isolate which clock cycle TLAST was wrong on.
  --

  blk_event_tlast_missing: block

    signal event_tlast_missing_i     : std_logic; 
   
  begin

    gen_events_forney: if C_TYPE = c_forney_convolutional generate
      -- As we only get a TLAST when the user wants to end a frame of unspecified length, we
      -- have no idea when it should arrive.  Therefore, it can't be missing
      event_tlast_missing_i    <= '0';
    end generate;


    gen_events_rectangular: if C_TYPE = c_rectangular_block generate
      event_tlast_missing_i  <= '1' when din_tlast_d = '0' and expected_end_of_block = '1' and ce_to_pe = '1'  else '0';
    end generate;
    
    process (aclk)
    begin
      if rising_edge(aclk) then        
        if reset = '1' then
          event_tlast_missing <= '0';
        else
          if aclken_i = '1' then
            event_tlast_missing <= event_tlast_missing_i;
          end if;
        end if;
      end if;
    end process;
  end block blk_event_tlast_missing;

  
  -- Events TLAST Unexpected
  -- -----------------------
  -- Asserted onevery clock cycle where s_axis_data_tlast is unexpectedly seen asserted.  i.e. asserted on a sample
  -- that isn't the last sample.  The meaning of "Last Sample" varies between Forney and Rectangular mode:
  --   * Forney     : the sample corresponding to the last branch.
  --   * Rectangular: the final sample loaded for a block
  --                                                                                                                         
  -- This event is asserted some time after TLAST actually occurred on the AXI channel, as the check only runs when the
  -- data is fed into the PE.  In addition to that, it will take 1 cycle for the external event to be seen by anything using it
  -- on a rising clock edge.  This event it only really useful to say that something has gone wrong, but there's no real way to
  -- isolate which clock cycle TLAST was wrong on.
  --

  blk_event_tlast_unexpected: block
    signal event_tlast_unexpected_i : std_logic := '0';
  begin 

    gen_events_forney: if C_TYPE = c_forney_convolutional generate

      -- If nd = 0 (for example, if we're waiting for a configuration word) then don't keep generating the event
      --
      event_tlast_unexpected_i <= '1' when din_tlast_d = '1' and rffd = '0' else '0';
    end generate;
    
    gen_events_rectangular: if C_TYPE = c_rectangular_block generate
      event_tlast_unexpected_i <= '1' when din_tlast_d = '1' and nd_d = '1' and expected_end_of_block = '0' and ce_to_pe = '1' else '0';
    end generate;
    
    process (aclk)
    begin
      if rising_edge(aclk) then        
        if reset = '1' then
          event_tlast_unexpected <= '0';
        else
          if aclken_i = '1' then
            event_tlast_unexpected <= event_tlast_unexpected_i;
          end if;
        end if;
      end if;
    end process;
  end block blk_event_tlast_unexpected;

  

  
  --  When the configuration is invalid (at least in rectangular mode) RFD becomes X.  As that's used to generate ND, the X stays in the system.
  rfd <= '0' when rfd_raw = '0' else '1';

  --  When the configuration is invalid (at least in rectangular mode) RDY becomes X.  As that's used to generate the FIFO write enable, the legacy
  --  FIFO gets out of synch with the new data FIFO.
  
  rdy_from_pe <= '1' when rdy_raw = '1' else '0';



  ----------------------------------------------------------------------------
  -- Forney Convolutional
  --
  gen_forney : if c_type = c_forney_convolutional generate
  begin
    
    fc1 : sid_bhv_forney_v7_0
      generic map (
        c_mode                   => c_mode,
        c_symbol_width           => c_symbol_width,
        c_num_branches           => c_num_branches,
        c_branch_length_type     => c_branch_length_type,
        c_branch_length_constant => c_branch_length_constant,
        c_branch_length_file     => c_branch_length_file,
        c_num_configurations     => c_num_configurations,
        c_external_ram           => c_external_ram,
        c_ext_addr_width         => c_ext_addr_width,
        c_pipe_level             => c_pipe_level,
        c_has_ce                 => get_ce_generic (C_TYPE => C_TYPE, C_HAS_DOUT_TREADY => C_HAS_DOUT_TREADY, C_HAS_ACLKEN => C_HAS_ACLKEN),
        c_has_sclr               => c_has_aresetn,
        c_has_rdy                => c_has_rdy,
        c_has_rfd                => 1,                        -- Always needed with AXI
        c_has_rffd               => 1,                        -- Always needed with AXI
        c_has_fdo                => c_has_fdo,
        c_has_ndo                => 1                         -- Always needed with AXI
        )                       
      port map (
        clk        => aclk,
        din        => din,
        dout       => dout,
        fd         => fd,
        nd         => nd,

        actual_ce => ce_to_pe,
        
        ce         => ce_to_pe_cr613301,
        sclr       => reset,
        config_sel => config_sel,
        new_config => read_from_ctrl_fifo,

        first_sample      => first_sample,
        last_branch       => last_branch,
  
        rd_data    => rd_data,
        rd_en      => rd_en,
        wr_en      => wr_en,
        rd_addr    => rd_addr,
        wr_addr    => wr_addr,
        wr_data    => wr_data,
        fdo        => fdo_from_pe,
        ndo        => ndo_from_pe,
        rdy        => rdy_raw,
        rfd        => rfd_raw,
        rffd       => rffd);
  end generate;  


  ----------------------------------------------------------------------------
  -- Rectangular Block
  --
  gen_rect : if c_type = c_rectangular_block generate
    signal rdwr_addr : std_logic_vector(c_ext_addr_width-1 downto 0);
    constant has_block_size_valid : integer := select_integer(0, 1, c_block_size_type /= c_constant);
  begin
    rb1 :  sid_bhv_rectangular_block_v7_0
      generic map(
        c_family               => c_family,
        c_mode                 => c_mode,
        c_symbol_width         => c_symbol_width,
        c_row_type             => c_row_type,
        c_row_constant         => c_row_constant,
        c_has_row              => c_has_row,
        c_has_row_valid        => c_has_row,  -- Always have the valid signal now if we have variable rows
        c_min_num_rows         => c_min_num_rows,
        c_row_width            => c_row_width,
        c_num_selectable_rows  => c_num_selectable_rows,
        c_row_select_file      => c_row_select_file,
        c_has_row_sel          => c_has_row_sel,
        c_has_row_sel_valid    => c_has_row_sel, -- Always have the valid signal now if we have selectable rows
        c_use_row_permute_file => c_use_row_permute_file,
        c_row_permute_file     => c_row_permute_file,
        c_col_type             => c_col_type,
        c_col_constant         => c_col_constant,
        c_has_col              => c_has_col,
        c_has_col_valid        => c_has_col,  -- Always have the valid signal now if we have variable cols
        c_min_num_cols         => c_min_num_cols,
        c_col_width            => c_col_width,
        c_num_selectable_cols  => c_num_selectable_cols,
        c_col_select_file      => c_col_select_file,
        c_has_col_sel          => c_has_col_sel,
        c_has_col_sel_valid    => c_has_col_sel, -- Always have the valid signal now if we have selectable cols
        c_use_col_permute_file => c_use_col_permute_file,
        c_col_permute_file     => c_col_permute_file,
        c_block_size_type      => c_block_size_type,
        c_block_size_constant  => c_block_size_constant,
        c_has_block_size       => c_has_block_size,
        c_block_size_width     => c_block_size_width,
        c_has_block_size_valid => has_block_size_valid,  -- Always have the valid signal now if we have non-constant block
        c_external_ram         => c_external_ram,
        c_ext_addr_width       => c_ext_addr_width,
        c_memstyle             => c_memstyle,
        c_pipe_level           => c_pipe_level,

        c_architecture         => c_architecture, -- Not actually used by the model
       
        c_has_ce               => get_ce_generic (C_TYPE => C_TYPE, C_HAS_DOUT_TREADY => C_HAS_DOUT_TREADY, C_HAS_ACLKEN => C_HAS_ACLKEN),
        c_has_nd               => 1,                   -- Always needed with AXI
        c_has_sclr             => c_has_aresetn,
        c_has_rfd              => 1,                   -- Always needed with AXI
        c_has_rdy              => 1,                   -- Always needed with AXI
        c_has_rffd             => 1,                   -- Always needed with AXI
        c_has_block_start      => c_has_block_start,
        c_has_block_end        =>1)  -- Always have block end.  I use it for TLAST
      port map(
        clk              => aclk,
        fd               => fd,
        nd               => nd,
        din              => din,
        ce               => ce_to_pe_cr613301,
        sclr             => reset,
        row              => row,
        row_sel          => row_sel,
        col              => col,
        col_sel          => col_sel,
        block_size       => block_size,
        rfd              => rfd_raw,
        dout             => dout,
        rdy              => rdy_raw,
        rffd             => rffd,
        row_valid        => row_valid,
        col_valid        => col_valid,
        row_sel_valid    => row_sel_valid,
        col_sel_valid    => col_sel_valid,
        block_size_valid => block_size_valid,
        block_start      => block_start_from_pe,
        block_end        => block_end_from_pe,
        rd_data          => rd_data, 
        rd_en            => rd_en,
        wr_en            => wr_en,
        rd_addr          => rd_addr,
        wr_addr          => wr_addr,
        wr_data          => wr_data);
       

  end generate;  -- gen_rect

 
  -- NDO (forney) or RDY (rect)  become the write_to_fifo signal in the DOUT channel when c_has_dout_tready = 1.
  -- In this case, the appropriate signal must be resolved with ce_to_pe to prevent multiple writes happening to the FIFO.
  --
  p_ce_to_pe_d: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset = '1' then
        ce_to_pe_d <= '1';
      else
        -- This is clock enabled because the pipes that this is used to feed are clock enabled as well.
        -- Basically, we only want this to be 0 when ce_to_pe is 0 but aclken isn't
        --
        if aclken_i = '1' then
          ce_to_pe_d <= ce_to_pe;
        end if;
      end if;
    end if;
  end process p_ce_to_pe_d;
  
  
  -- Using the "_d" version to account for the fact that the read from memory takes an extra cycle to appear, so if we
  -- block rdy/ndo immediately on ce_to_pe = 0, the read data will be lost
  --
  ndo_resolved <= ndo_from_pe and ce_to_pe_d when (c_type = c_forney_convolutional and c_has_dout_tready /= 0) else
                  ndo_from_pe;
  rdy_resolved <= rdy_from_pe and ce_to_pe_d when (c_type = c_rectangular_block and c_has_dout_tready /= 0) else
                  rdy_from_pe;


  -- If we have external ram then we may have to delay the control signals to match the
  -- delay on the data.  If we don't have to delay it, just rename the signals.  This lets
  -- the rest of the file use consistent names

  gen_int_mem : if c_external_ram = 0 generate
    dout_tlast_aligned  <= dout_tlast;
    ndo_aligned         <= ndo_resolved;
    rdy_aligned         <= rdy_resolved;
    fdo_aligned         <= fdo_from_pe;
    block_start_aligned <= block_start_from_pe;
    block_end_aligned   <= block_end_from_pe;
        
  end generate;  -- gen_int_mem

  -- If we have external ram then we may have to delay the control signals to match the delay on the data.
  --
  gen_ext_mem : if c_external_ram /= 0 generate
    gen_delay_eq_0 : if R_ext_mem_latency = 0 generate
      dout_tlast_aligned  <= dout_tlast;
      ndo_aligned         <= ndo_resolved;
      rdy_aligned         <= rdy_resolved;
      fdo_aligned         <= fdo_from_pe;
      block_start_aligned <= block_start_from_pe;
      block_end_aligned   <= block_end_from_pe;
    end generate;

    gen_delay_eq_1 : if R_ext_mem_latency = 1 generate
      -- Need to delay all signals by 1 clock cycle
    begin
      p_delay: process (aclk)
      begin
        if rising_edge(aclk) then
          if reset = '1' then
            dout_tlast_aligned  <= '0';
            ndo_aligned         <= '0';
            fdo_aligned         <= '0';
            rdy_aligned         <= '0';
            block_start_aligned <= '0';
            block_end_aligned   <= '0';
          else
            if aclken_i = '1' then
              dout_tlast_aligned  <= dout_tlast;
              ndo_aligned         <= ndo_resolved;
              rdy_aligned         <= rdy_resolved;
              fdo_aligned         <= fdo_from_pe;
              block_start_aligned <= block_start_from_pe;
              block_end_aligned   <= block_end_from_pe;
            end if;
          end if;
        end if;
      end process p_delay;
    end generate;

    
    gen_delay_gt_1 : if R_ext_mem_latency > 1 generate
      -- Need to delay all signals by R_ext_mem_latency
      signal dout_tlast_pipe  : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
      signal ndo_pipe         : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
      signal fdo_pipe         : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
      signal rdy_pipe         : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
      signal block_start_pipe : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
      signal block_end_pipe   : std_logic_vector(R_ext_mem_latency -1 downto 0) := (others => '0');
    begin


      p_delays: process (aclk)
      begin
        if rising_edge(aclk) then
          if reset = '1' then
            dout_tlast_pipe  <= (others => '0');
            ndo_pipe         <= (others => '0');
            fdo_pipe         <= (others => '0');
            rdy_pipe         <= (others => '0');
            block_start_pipe <= (others => '0');
            block_end_pipe   <= (others => '0');
           
          else
            if aclken_i = '1' then
              dout_tlast_pipe  <= dout_tlast_pipe (R_ext_mem_latency-2 downto 0) & dout_tlast;
              ndo_pipe         <= ndo_pipe        (R_ext_mem_latency-2 downto 0) & ndo_resolved;  
              rdy_pipe         <= rdy_pipe        (R_ext_mem_latency-2 downto 0) & rdy_resolved;
              fdo_pipe         <= fdo_pipe        (R_ext_mem_latency-2 downto 0) & fdo_from_pe;
              block_start_pipe <= block_start_pipe(R_ext_mem_latency-2 downto 0) & block_start_from_pe;
              block_end_pipe   <= block_end_pipe  (R_ext_mem_latency-2 downto 0) & block_end_from_pe;
            end if;
          end if;
        end if;
      end process p_delays;

      dout_tlast_aligned  <= dout_tlast_pipe (R_ext_mem_latency-1);
      ndo_aligned         <= ndo_pipe        (R_ext_mem_latency-1);
      fdo_aligned         <= fdo_pipe        (R_ext_mem_latency-1);
      rdy_aligned         <= rdy_pipe        (R_ext_mem_latency-1);
      block_start_aligned <= block_start_pipe(R_ext_mem_latency-1);
      block_end_aligned   <= block_end_pipe  (R_ext_mem_latency-1);


    end generate;
  end generate;  -- gen_ext_mem



  
end behavioral;


