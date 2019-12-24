-------------------------------------------------------------------------------
--  (c) Copyright 2002-2010, 2012 Xilinx, Inc. All rights reserved.
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
-- 
--
--------------------------------------------------------------------------------
-- Must keep following line blank for NaturalDocs to distinguish the header

-- Object: rs_encoder_axi_wrapper
--  Translate between AXI channels in top level to individual busses and control
--  signals required by <rs_encoder_v8_0_legacy>.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Generics and ports are defined in the file for <rs_encoder_v8_0>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

library xilinxcorelib;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;

-- AXI utils contains slave and master FIFOs
library xilinxcorelib;
use xilinxcorelib.axi_utils_pkg_v1_1.all;
use xilinxcorelib.axi_utils_v1_1_comps.all;
use xilinxcorelib.global_util_pkg_v1_1.all;

--library xilinxcorelib;
--use xilinxcorelib.util_xcc.all;
--use xilinxcorelib.ul_utils.all;
--use xilinxcorelib.toolbox_comps.all;

library xilinxcorelib;
use xilinxcorelib.rs_encoder_v8_0_consts.all;
use xilinxcorelib.rs_encoder_v8_0_pkg.all;


entity rs_encoder_v8_0 is
generic (
  -- AXI channel parameters
  C_HAS_ACLKEN                 : integer := 0;                   
  C_HAS_ARESETN                : integer := 0;                  
  C_HAS_S_AXIS_CTRL            : integer := 0;           
  C_HAS_S_AXIS_INPUT_TUSER     : integer := 0;       
  C_HAS_M_AXIS_OUTPUT_TUSER    : integer := 0;       
  C_HAS_M_AXIS_OUTPUT_TREADY   : integer := 1;
  C_S_AXIS_INPUT_TDATA_WIDTH   : integer := 8;     
  C_S_AXIS_INPUT_TUSER_WIDTH   : integer := 1;     
  C_S_AXIS_CTRL_TDATA_WIDTH    : integer := 8;   
  C_M_AXIS_OUTPUT_TDATA_WIDTH  : integer := 8;    
  C_M_AXIS_OUTPUT_TUSER_WIDTH  : integer := 1;    
    
  -- AXI channel sub-field parameters
  C_HAS_INFO                   : integer := 0; 
  C_HAS_N_IN                   : integer := 0;
  C_HAS_R_IN                   : integer := 0;
  
  -- Reed-Solomon code word parameters
  C_GEN_START                  : integer := 0;
  C_H                          : integer := 1;
  C_K                          : integer := 239;
  C_N                          : integer := 255;
  C_POLYNOMIAL                 : integer := 0;
  C_SPEC                       : integer := 0;
  C_SYMBOL_WIDTH               : integer := 8;
  
  -- Implementation parameters
  C_GEN_POLY_TYPE              : integer := 0;
  C_NUM_CHANNELS               : integer := 1;
  C_MEMSTYLE                   : integer := 2;
  C_OPTIMIZATION               : integer := 2;
  
  -- Generation parameters
  C_MEM_INIT_PREFIX            : string := "rsel";
  C_ELABORATION_DIR            : string := "./";
  --C_EVALUATION                 : integer;
  C_XDEVICEFAMILY              : string := "no_family";
  C_FAMILY                     : string := "no_family"
  );
port (
  aclk                  : in  std_logic := '0';                                                                 
  aclken                : in  std_logic := '1';                                                          
  aresetn               : in  std_logic := '1';                                                          
  
  s_axis_input_tdata    : in  std_logic_vector(C_S_AXIS_INPUT_TDATA_WIDTH-1 downto 0) := (others=>'0');                   
  s_axis_input_tuser    : in  std_logic_vector(C_S_AXIS_INPUT_TUSER_WIDTH-1 downto 0) := (others=>'0'); 
  s_axis_input_tvalid   : in  std_logic := '0';                                                                 
  s_axis_input_tready   : out std_logic := '0';                                                                 
  s_axis_input_tlast    : in  std_logic := '0';                                                                 
    
  s_axis_ctrl_tdata     : in  std_logic_vector(C_S_AXIS_CTRL_TDATA_WIDTH-1 downto 0) := (others=>'1');
  s_axis_ctrl_tvalid    : in  std_logic := '0';
  s_axis_ctrl_tready    : out std_logic := '0';
  
  m_axis_output_tdata   : out std_logic_vector(C_M_AXIS_OUTPUT_TDATA_WIDTH-1 downto 0);                  
  m_axis_output_tuser   : out std_logic_vector(C_M_AXIS_OUTPUT_TUSER_WIDTH-1 downto 0);                  
  m_axis_output_tvalid  : out std_logic := '0';                                                                 
  m_axis_output_tready  : in  std_logic := '0';                                                          
  m_axis_output_tlast   : out std_logic := '0';                                                                 

  event_s_input_tlast_missing    : out std_logic := '0';
  event_s_input_tlast_unexpected : out std_logic := '0';
  event_s_ctrl_tdata_invalid     : out std_logic := '0'
  
);

end rs_encoder_v8_0;



--------------------------------------------------------------------------------
architecture behavioral of rs_encoder_v8_0 is

  -- Group: architecture
  
  ------------------------------------------------------------------------------
  -- Group: constants

  constant new_line : string(1 to 1) := (1 => lf); -- for assertion reports
  
  -- boolean: multi_channel
  -- true if there is more than one input channel
  constant multi_channel : boolean := C_NUM_CHANNELS > 1;
  
  -- boolean: enc_can_be_stalled
  -- true if <rs_encoder_v8_0_legacy> can be stalled because AXI output channel is stalled
  constant enc_can_be_stalled : boolean := C_HAS_M_AXIS_OUTPUT_TREADY /= 0;
  
  -- integer: enc_has_ce
  -- 1 if <rs_encoder_v8_0_legacy> required a clock enable
  constant enc_has_ce : integer := boolean'pos(C_HAS_ACLKEN /= 0 or enc_can_be_stalled);
  
  
  ------------------------------------------------------------------------------
  -- Fields within AXI busses
  
  -- integer: data_in_field_width
  -- Size of data_in field in <s_axis_input_tdata>
  constant data_in_field_width : integer := byte_roundup(C_SYMBOL_WIDTH);
  
  -- integer: data_out_field_width
  -- Size of data_out field in <m_axis_output_tdata>
  constant data_out_field_width : integer := data_in_field_width;
  
  -- integer: n_in_field_width
  -- Size of n_in field in <s_axis_ctrl_tdata>
  constant n_in_field_width : integer :=
    GLB_if(C_HAS_N_IN>0, byte_roundup(C_SYMBOL_WIDTH), 0);
    --select_val(0, roundup_to_multiple(C_SYMBOL_WIDTH, axi_field_factor), C_HAS_N_IN);
  
             
  -- integer: r_constant
  -- Number of check symbols, R=N-K
  constant r_constant : integer := C_N - C_K;
  -- integer: r_in_width
  -- Optional r_in port needs enough bits to represent the largest N-K value
  constant r_in_width : integer := integer_width(r_constant);
  
  
  -- integer: r_in_lsb_index
  -- r_in field of input data starts after n_in field
  constant r_in_lsb_index : integer := n_in_field_width;
  -- integer: r_in_msb_index
  -- Index of r_in field MSB in <s_axis_ctrl_tdata>
  constant r_in_msb_index : integer := r_in_lsb_index + r_in_width - 1;
    
  -- integer: s_axis_ctrl_fifo_r_in_lsb
  -- r_in is placed immediately after n_in if n_in is present, else it is the least significant
  -- field in the ctrl FIFO input.
  --constant s_axis_ctrl_fifo_r_in_lsb : integer := select_val(0, C_SYMBOL_WIDTH, C_HAS_N_IN);
  constant s_axis_ctrl_fifo_r_in_lsb : integer := GLB_if(C_HAS_N_IN>0, C_SYMBOL_WIDTH, 0);
  
  -- integer: s_axis_ctrl_fifo_r_in_msb
  -- Index of r_in field MSB in <s_axis_ctrl_fifo_in>
  constant s_axis_ctrl_fifo_r_in_msb : integer := s_axis_ctrl_fifo_r_in_lsb + r_in_width - 1;
    
    
  -- integer: symbol_width_minus_1
  --  Define this to save repeated re-calculation. Used to define <symbol_type>
  constant symbol_width_minus_1 : integer := C_SYMBOL_WIDTH-1;
  
  
  ------------------------------------------------------------------------------
  -- FIFO constants
  --
  
  -- integer: min_ifx_fifo_depth 
  -- The glb_ifx_* components used for AXI FIFOs have a minimum depth of 4.
  constant min_ifx_fifo_depth : integer := 4;
  
  ------------------------------------------------------------------------------
  -- s_axis_input FIFO constants
  -- FIFO bus is composed of (mark_in, data_in)
  
  -- integer: s_axis_input_fifo_mark_in_lsb
  -- LSB bit position of <mark_in> within s_axis_input_fifo input and output
  constant s_axis_input_fifo_mark_in_lsb : integer := C_SYMBOL_WIDTH;
                                                                 
  -- integer: s_axis_input_fifo_mark_in_msb
  -- MSB bit position of <mark_in> within s_axis_output_fifo data input and output
  constant s_axis_input_fifo_mark_in_msb : integer := s_axis_input_fifo_mark_in_lsb + C_S_AXIS_INPUT_TUSER_WIDTH - 1;
  
  -- integer: s_axis_input_fifo_width 
  -- Combined width of all the elements of s_axis_input_tdata and s_axis_input_tuser (if present)
  -- and s_axis_input_tlast, not including any padding bits (as we don't want to waste resources
  -- storing those in a FIFO).
  -- s_axis_input_tlast will be the MSB of the FIFO data bus
  constant s_axis_input_fifo_width : integer :=
    GLB_if(C_HAS_S_AXIS_INPUT_TUSER>0,
             s_axis_input_fifo_mark_in_lsb+C_S_AXIS_INPUT_TUSER_WIDTH+1,
             s_axis_input_fifo_mark_in_lsb+1
          );
    --select_val(s_axis_input_fifo_mark_in_lsb+1,
    --           s_axis_input_fifo_mark_in_lsb+C_S_AXIS_INPUT_TUSER_WIDTH+1,
    --           C_HAS_S_AXIS_INPUT_TUSER);
               
  -- integer: s_axis_input_fifo_depth
  -- Depth of AXI input FIFO. Set to 16, as this has minimal cost when SRL16 is used.
  -- Allow an additional 5 symbols in multi-channel case as FIFO can become full earlier
  -- than expected because of internal pipelining.
  -- Depth must be a power of 2 for <glb_srl_fifo_v1_1> component.
  constant s_axis_input_fifo_depth : integer := GLB_max(GLB_next_pow2(C_NUM_CHANNELS+5), 16);
  
  
  ------------------------------------------------------------------------------
  -- s_axis_ctrl FIFO constants
  
  -- integer: s_axis_ctrl_fifo_width_tmp
  -- Combined width of all the elements of s_axis_ctrl_tdata, not including any padding bits
  -- (as we don't want to waste resources storing those in a FIFO).
  --constant s_axis_ctrl_fifo_width_tmp : integer := select_val(0, C_SYMBOL_WIDTH, C_HAS_N_IN) +
  --                                                 select_val(0, r_in_width, C_HAS_R_IN);
  constant s_axis_ctrl_fifo_width_tmp : integer := GLB_if(C_HAS_N_IN>0, C_SYMBOL_WIDTH, 0) +
                                                   GLB_if(C_HAS_R_IN>0, r_in_width,     0);
   
  -- integer: s_axis_ctrl_fifo_width
  -- Don't let width go below 1 to avoid compiler warnings if C_HAS_S_AXIS_CTRL=0
  constant s_axis_ctrl_fifo_width : integer := GLB_max(1, s_axis_ctrl_fifo_width_tmp);
               
  
  -- integer: s_axis_ctrl_fifo_depth 
  -- Depth of AXI ctrl FIFO. 
  -- FIFO holds up to 16 control values. 16 costs the same as 2 if an SRL16 is used, so always set to 16.
  constant s_axis_ctrl_fifo_depth : integer := GLB_max(min_ifx_fifo_depth, 16);
    
  
  ------------------------------------------------------------------------------
  -- m_axis_output FIFO constants
  -- FIFO bus is composed of (mark_out, info, data_out)
  
  -- integer: m_axis_output_fifo_info_lsb
  -- LSB bit position of <info> within m_axis_output_fifo data input and output
  constant m_axis_output_fifo_info_lsb : integer := C_SYMBOL_WIDTH;
  
  -- integer: m_axis_output_fifo_mark_out_lsb
  -- LSB bit position of <mark_out> within m_axis_output_fifo data input and output
  --constant m_axis_output_fifo_mark_out_lsb : integer := select_val(m_axis_output_fifo_info_lsb,
  --                                                                 m_axis_output_fifo_info_lsb + 1,
  --                                                                 C_HAS_INFO);
  constant m_axis_output_fifo_mark_out_lsb : integer := GLB_if(C_HAS_INFO>0,
                                                               m_axis_output_fifo_info_lsb + 1,
                                                               m_axis_output_fifo_info_lsb
                                                               );
  -- integer: m_axis_output_fifo_width 
  -- Combined width of all the elements of m_axis_output_tdata and m_axis_output_tuser (if present)
  -- not including any padding bits (as we don't want to waste resources storing those in a FIFO).
  -- Add 1 for <last_data_out> signal to be passed through to generate m_axis_output_tlast
  constant m_axis_output_fifo_width : integer :=
    GLB_if(C_HAS_S_AXIS_INPUT_TUSER>0,
           m_axis_output_fifo_mark_out_lsb+1+C_S_AXIS_INPUT_TUSER_WIDTH,
           m_axis_output_fifo_mark_out_lsb+1
           );
    --select_val(m_axis_output_fifo_mark_out_lsb+1,
    --           m_axis_output_fifo_mark_out_lsb+1+C_S_AXIS_INPUT_TUSER_WIDTH,
    --           C_HAS_S_AXIS_INPUT_TUSER);
               
  -- integer: m_axis_output_fifo_depth 
  -- Depth of AXI output FIFO. The glb_ifx_master_v1_1 component used for this FIFO has a minimum depth of 4,
  -- although we only actually need a depth of 2 in order to retime tready and switch off the
  -- clock enable for the Forney unit. Allow an additional 3 cycles to be sure almost full output works
  -- correctly.
  --constant m_axis_output_fifo_depth : integer := min_ifx_fifo_depth + 3;
--  constant m_axis_output_fifo_depth : integer := GLB_max(GLB_next_pow2(min_ifx_fifo_depth + 3), 16);
  constant m_axis_output_fifo_depth : integer := 16;
  
  
  ------------------------------------------------------------------------------
  -- Latency calculation
  -- Required to set delay for TUSER signal in parallel to main core
  -----------------------------------------------------------------------------
  -- Get latency function
  -- Latency is defined as number of rising clock edges from sampling DATA_IN
  -- to outputting on DATA_OUT.
  -- Used by GUI so place in this package that will be processed by XCC.
  -----------------------------------------------------------------------------
  function get_latency(num_channels : integer;
                       spec         : integer) return integer is
  variable latency: integer;
  begin
  latency := 2 + num_channels;
  
  -- optimization parameter removed from version 4.1 on.
  --if optimization = 2 then        -- speed
  --  latency := 3; 
  --elsif optimization = 1 then     --area
  --  latency:=2;
  --else
  --    assert false
  --        report "Invalid optimization value" severity failure;
  --end if;
    
  if spec = ccsds_spec then -- CCSDS standard
    latency := latency + 2;
  elsif spec = j83_b_spec then
    latency := latency + 1;
  end if;
  
  assert false
    report " Reed-Solomon Encoder: " & new_line &
           " latency = " & integer'image(latency) & new_line &
           new_line
    severity note;
    
  return latency;
  end get_latency;


  constant core_latency : integer := get_latency(C_NUM_CHANNELS, C_SPEC);
    
  ------------------------------------------------------------------------------
  -- Group: types
  
  -- type: symbol_type
  -- Standard vector type for data symbols
  subtype symbol_type is std_logic_vector(symbol_width_minus_1 downto 0);
  
  ------------------------------------------------------------------------------
  -- Group: signals
  
  -- Group: Signals to drive <rs_encoder_v8_0_legacy> inputs
  --  data_in     - Data to be encoded 
  --  enc_ce      - Clock enable for <rs_encoder_v8_0_legacy>
  --  nd_in       - New Data input (equivalent of tvalid for <rs_encoder_v8_0_legacy>
  --  n_in        - Optional variable N input
  --  r_in        - Optional variable R
  --  mark_in     - tuser bits, passed from <rs_encoder_v8_0_legacy> mark_in to mark_out
  --  sr_smpld    - <aresetn> is inverted and retimed to produce active high synchronous reset
  --  start_enc   - Assert high at same time as first data symbol of a new block is provided
  --                to <rs_encoder_v8_0_legacy>
  signal data_in      : symbol_type;
  signal enc_ce       : std_logic;
  signal nd_in        : std_logic;
  signal n_in         : symbol_type;
  signal r_in         : std_logic_vector(r_in_width-1 downto 0);
  signal mark_in      : std_logic_vector(C_S_AXIS_INPUT_TUSER_WIDTH-1 downto 0);
  signal sr_smpld     : std_logic := '0';
  signal start_enc    : std_logic := '0';
  
  -- Group: Signals to receive <rs_encoder_v8_0_legacy> outputs
  --  data_out    - Output corrected data from encoder
  --  info        - Output high when information symbols on data_out, low for check symbols
  --  mark_out    - tuser bits, passed from <rs_encoder_v8_0_legacy> mark_in to mark_out
  --  rdy_out     - asserted high when <rs_encoder_v8_0_legacy> has output data ready
  --  rfd_din     - Input to rfd register in <rs_encoder_v8_0_legacy>
--  --  rfd_out     - <rs_encoder_v8_0_legacy> ready for data output
  --  rffd_din    - Input to rffd register in <rs_encoder_v8_0_legacy>
  --  rffd_out    - <rs_encoder_v8_0_legacy> ready for first data output
  signal data_out    : symbol_type;
  signal info        : std_logic;
  signal mark_out    : std_logic_vector(C_S_AXIS_INPUT_TUSER_WIDTH-1 downto 0);
  signal rdy_out     : std_logic;
  signal rfd_din     : std_logic;
--  signal rfd_out     : std_logic;
  signal rffd_din    : std_logic;
  signal rffd_out    : std_logic;

  -- Group: Other signals
  --  aclken_int  - Internal clock enable, tied high if <C_HAS_ACLKEN> = 0
--  --  s_axis_input_fifo_in - Input bus for AXI input FIFO, concatenation of all the input channel information
--  --  s_axis_input_fifo_out - Output bus for AXI output FIFO
  --  s_axis_ctrl_fifo_in - Input bus for AXI ctrl FIFO, concatenation of all the ctrl channel information
  --  s_axi_ctrl_fifo_out - Output bus for AXI ctrl FIFO
  --  m_axis_output_fifo_in - Input bus for AXI output FIFO, concatenation of all the output channel information
  --  m_axis_output_fifo_out - Output bus for AXI output FIFO
  --  m_axis_output_tdata_tmp - Used to give default assignment of zeroes to unused bits in <m_axis_output_tdata>
  --  last_data_out - High when last symbol is on data_out bus from <rs_encoder_v8_0_legacy> component
  --  output_fifo_has_room - Low when o/p FIFO full - used to stop processing
  --  output_fifo_has_room_del - Delayed version of <output_fifo_has_room>
  --  output_fifo_wr_en - Write enable for AXI output FIFO
  --  ctrl_fifo_rd_en - read enable for ctrl FIFO
  --  ctrl_fifo_not_empty - asserted when ctrl FIFO contains data to be read
  --  input_fifo_rd_en - read enable for input FIFO
  --  input_tready - tready signal signalling core is ready to receive input data
  --  input_tvalid - tvalid signal signalling valid data on data_in
  --  input_tlast - tlast pulse to inner core
  signal aclken_int               : std_logic;
  --signal s_axis_input_fifo_in     : std_logic_vector(s_axis_input_fifo_width-1 downto 0);
  --signal s_axis_input_fifo_out    : std_logic_vector(s_axis_input_fifo_width-1 downto 0);
  signal s_axis_ctrl_fifo_in      : std_logic_vector(s_axis_ctrl_fifo_width-1 downto 0);
  signal s_axis_ctrl_fifo_out     : std_logic_vector(s_axis_ctrl_fifo_width-1 downto 0);
  signal m_axis_output_fifo_in    : std_logic_vector(m_axis_output_fifo_width-1 downto 0);
  signal m_axis_output_fifo_out   : std_logic_vector(m_axis_output_fifo_width-1 downto 0);
  signal m_axis_output_tdata_tmp  : std_logic_vector(C_M_AXIS_OUTPUT_TDATA_WIDTH-1 downto 0) := (others=>'0');
  signal last_data_out            : std_logic;
  signal output_fifo_has_room_pre : std_logic;
  signal output_fifo_has_room     : std_logic := '1';
  signal output_fifo_has_room_del : std_logic := '1';
  signal output_fifo_has_room_both: std_logic := '1';
  signal output_fifo_wr_en        : std_logic;
  signal ctrl_fifo_rd_en          : std_logic;
  signal ctrl_fifo_not_empty      : std_logic;
  signal input_fifo_rd_en         : std_logic;
  signal input_tready             : std_logic := '0';
  signal input_tvalid             : std_logic;
  signal input_tlast              : std_logic;
  signal in_tlast                 : std_logic; --qualified by tvalid. Fed to event checker in rs_encoder_v8_0_legacy
  signal tlast_missing            : std_logic;
  signal tlast_missing_qual       : std_logic;
  signal tlast_unexpected         : std_logic;
  signal tlast_unexpected_qual    : std_logic;
  signal ctrl_invalid             : std_logic;
  signal ctrl_invalid_qual        : std_logic;
  signal ctrl_invalid_event       : std_logic;
begin
  -- Group: architecture body

  
  
  ------------------------------------------------------------------------------
  -- Generate optional clock enable input
  ceg1: if C_HAS_ACLKEN /= 0 generate
  begin
    aclken_int <= aclken;
  end generate; -- ceg1
  
  ceg2: if C_HAS_ACLKEN = 0 generate
  begin
    aclken_int <= '1';
  end generate; -- ceg2
  
  ------------------------------------------------------------------------------
  -- Generate optional synchronous reset input
  arg1: if C_HAS_ARESETN /= 0 generate
  begin
    
    -- Invert and retime aresetn to produce an active high synchronous reset for <rs_encoder_v8_0_legacy>
    srp1 : process (aclk)
    begin
      if rising_edge(aclk) then
        sr_smpld <= not(aresetn);
      end if; -- clk
    end process; -- srp1
    
    
  end generate; -- arg1
  
  arg2: if C_HAS_ARESETN = 0 generate
  begin
    sr_smpld    <= '0';
  end generate; -- arg2
  

  
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  -- Extract fields from AXI ctrl channel and outputs from AXI ctrl FIFO
  --
  
  ------------------------------------------------------------------------------
  -- Generate optional n_in input
  nig1: if C_HAS_N_IN /= 0 generate
  begin
    s_axis_ctrl_fifo_in(symbol_width_minus_1 downto 0) <= s_axis_ctrl_tdata(symbol_width_minus_1 downto 0);
    n_in <= s_axis_ctrl_fifo_out(symbol_width_minus_1 downto 0);
  end generate; -- nig1
  
  nig2: if C_HAS_N_IN = 0 generate
  begin
    n_in <= std_logic_vector(to_unsigned(C_N, n_in'length)); -- force to fixed value
  end generate; -- nig2
  
  
  ------------------------------------------------------------------------------
  -- Generate optional r_in input
  rig1: if C_HAS_R_IN /= 0 generate
  begin
    s_axis_ctrl_fifo_in(s_axis_ctrl_fifo_r_in_msb downto s_axis_ctrl_fifo_r_in_lsb) <= 
                                                   s_axis_ctrl_tdata(r_in_msb_index downto r_in_lsb_index);
                                                   
    r_in <= s_axis_ctrl_fifo_out(s_axis_ctrl_fifo_r_in_msb downto s_axis_ctrl_fifo_r_in_lsb);
  end generate; -- rig1
  
  rig2: if C_HAS_R_IN = 0 generate
  begin
    r_in <= std_logic_vector(to_unsigned(r_constant, r_in'length)); -- force to fixed value
  end generate; -- rig2
  
  

  
  
  ------------------------------------------------------------------------------
  -- AXI interface components
  --
  
  ------------------------------------------------------------------------------
  -- AXI input channel
  --
  s_axis_input_tready <= input_tready; -- Primary output
  

  
  ------------------------------------------------------------------------------
  -- AXI ctrl channel FIFO
  --
  cfg1 : if C_HAS_S_AXIS_CTRL /= 0 generate
    signal start_enc_set : std_logic;
  begin
  
    ----------------------------------------------------------------------------
    -- Object: axi_ctrl_fifo
    -- This FIFO buffers incoming control data from the AXI s_axis_ctrl channel.
    -- This minimizes fan-in of AXI handshaking signals and allows control information
    -- for up to 16 blocks of input data to be set up in advance.
    -- If this FIFO is empty the s_axis_input channel will be stalled.
    -- The FIFO is read just as <rs_encoder_v8_0_legacy> is ready to accept a new block of input data.
    --axi_ctrl_fifo : rs_ifx_slave_v8_0
    axi_ctrl_fifo : glb_ifx_slave_v1_1
    generic map(
      WIDTH          => s_axis_ctrl_fifo_width,
      DEPTH          => s_axis_ctrl_fifo_depth,
      HAS_IFX        => true, -- for AXI compatible outputs
      AEMPTY_THRESH1 => 0,
      AEMPTY_THRESH0 => 0 )
    port map(
      aclk      => aclk,
      aclken    => aclken_int,
      areset    => sr_smpld,
      aresetn   => '1',
      ifx_valid => s_axis_ctrl_tvalid,
      ifx_ready => s_axis_ctrl_tready,
      ifx_data  => s_axis_ctrl_fifo_in,
      rd_enable => ctrl_fifo_rd_en,
      rd_valid  => open,
      rd_data   => s_axis_ctrl_fifo_out,
      not_empty => ctrl_fifo_not_empty );
      
    -- Registers enabled by <aclken>
    cfp1 : process (aclk)
    begin
      if rising_edge(aclk) then
        if sr_smpld = '1' then
          start_enc <= '0';
          
        --[GO] aclken replaced with aclken_int
        elsif aclken_int = '1' then
        
          -- Signal to start <rs_encoder_v8_0_legacy> with a new block
          --start_enc <= start_enc_set;
          if (start_enc_set = '1') then
            start_enc <= '1';
          elsif (rffd_out and nd_in) = '1' then
            start_enc <= '0';
          end if;

        end if; -- sr_smpld = '1'
      end if; -- rising_edge(aclk)
    end process; -- cfp1


    -- Start a new block on the next valid sample when rffd='1' and core is not stalled
    -- due to o/p FIFO being full and a ctrl value is available to be read.
    start_enc_set <= rffd_din and output_fifo_has_room and ctrl_fifo_not_empty;

    -- Read ctrl FIFO on cycle immediately before <rs_encoder_v8_0_legacy> is started with
    -- <start_enc>
    --[GO] aclken replaced with aclken_int
    ctrl_fifo_rd_en <= start_enc_set and not(start_enc) and aclken_int;



  end generate; -- cfg1

  cfg2 : if C_HAS_S_AXIS_CTRL = 0 generate
  begin
    ctrl_fifo_not_empty <= '1'; -- Set to '1' to prevent input channel from being blocked

    -- <rffd_out> goes high when <rs_encoder_v8_0_legacy> is ready for first data, i.e. it
    -- is ready to start a new block. If the <start> input is driven with this signal
    -- then a new block will be started on the first <nd> pulse after <rffd_out> goes
    -- high.
    -- Need to gate with <input_tready> to ensure <start_enc> is low during a reset.
    start_enc <= rffd_out and input_tready;

  end generate; -- cfg2
  
  
  
  ------------------------------------------------------------------------------
  -- AXI output channel FIFO
  --
  --
  -- Generate m_axis_output_tdata
  -- Undriven bits will be forced to '0' by signal declaration initialization
  m_axis_output_tdata <= m_axis_output_tdata_tmp;


  ofg1 : if C_HAS_M_AXIS_OUTPUT_TREADY /= 0 generate
  begin

    ----------------------------------------------------------------------------
    -- Object: axi_output_fifo
    -- This FIFO decouples the data output from the actual AXI m_axis_output channel.
    -- Without this FIFO the unregistered tready input would have to be used to
    -- disable the core as soon as it went low.
    -- in early v8.0 development the almost full flag was set such that the
    -- FIFO would almost fill in the worst case. Now, the threshold is set
    -- approx half way (8-3). 8 is half-way, 3 is the latency of feedback from
    -- the fifo to the core and back. To minimise OR logic in control and
    -- specifically in CE logic, the fifo almost full flag is delayed several
    -- times such that combinations can be OR'd then registered. This registering
    -- increases the latency and hysteresis to the FIFO operation. Whether this
    -- adds a genuine hazard of underflow is not clear, but that's why half-way is
    -- chosen.
    axi_output_fifo : glb_ifx_master_v1_1
    generic map(
      WIDTH         => m_axis_output_fifo_width,
      DEPTH         => m_axis_output_fifo_depth,
      AFULL_THRESH1 => 5,--see comments above.
      AFULL_THRESH0 => 5 
    )
    port map(
      aclk      => aclk,
      aclken    => aclken_int,
      areset    => sr_smpld, -- sampled active high sync reset
      wr_enable => output_fifo_wr_en,
      wr_data   => m_axis_output_fifo_in,
      ifx_valid => m_axis_output_tvalid,
      ifx_ready => m_axis_output_tready,
      ifx_data  => m_axis_output_fifo_out,
      not_afull => output_fifo_has_room_pre
      );

    -- Write to FIFO when there is valid data (<rdy_out> = '1') and inner core is enabled
    output_fifo_wr_en <= rdy_out and enc_ce;
      
      
    -- Registers enabled by <aclken>
    ofp1 : process (aclk)
    begin
      if rising_edge(aclk) then
        if sr_smpld = '1' then
          output_fifo_has_room      <= '1';
          output_fifo_has_room_del  <= '1';
          output_fifo_has_room_both <= '1';

        --[GO] aclken replaced with aclken_int
        elsif aclken_int = '1' then

          -- Delay <output_fifo_has_room> by the number of cycles it takes to de-assert rfd
          -- after <output_fifo_has_room> goes low (i.e. 1 cycle)
          output_fifo_has_room      <= output_fifo_has_room_pre;
          output_fifo_has_room_del  <= output_fifo_has_room;
          output_fifo_has_room_both <= output_fifo_has_room_pre or output_fifo_has_room;
          
        end if; -- sr_smpld = '1'
      end if; -- rising_edge(aclk)
    end process; -- ofp1
    
    
    -- Connect FIFO data inputs and outputs
    
    -- Include data_out
    m_axis_output_fifo_in(symbol_width_minus_1 downto 0) <= data_out;
    
    m_axis_output_tdata_tmp(symbol_width_minus_1 downto 0) <= m_axis_output_fifo_out(symbol_width_minus_1 downto 0);

    -- Pad data field with zeroes if required
    pdo: if (C_M_AXIS_OUTPUT_TDATA_WIDTH-(8*boolean'pos(C_HAS_INFO>0))) > C_SYMBOL_WIDTH generate
    begin
      m_axis_output_tdata_tmp(data_out_field_width-1 downto C_SYMBOL_WIDTH) <= (others => '0');
    end generate; -- ifg1

    -- Include info
    ifg1: if C_HAS_INFO /= 0 generate
    begin
      m_axis_output_fifo_in(m_axis_output_fifo_info_lsb) <= info;
   
      m_axis_output_tdata_tmp(data_out_field_width) <= m_axis_output_fifo_out(m_axis_output_fifo_info_lsb);
      
      -- Pad info field to byte boundary
      m_axis_output_tdata_tmp(C_M_AXIS_OUTPUT_TDATA_WIDTH-1 downto C_M_AXIS_OUTPUT_TDATA_WIDTH-7) <= (others => '0');
          
    end generate; -- ifg1
    
    
    ----------------------------------------------------------------------------
    -- Generate optional m_axis_output_tuser output from mark_out
    -- C_M_AXIS_OUTPUT_TUSER_WIDTH should equal C_S_AXIS_INPUT_TUSER width
    -- (=mark_out width), but it might not, so use ieee.numeric_std resize
    -- function to either pad with zeroes or strip off MSBs to match
    -- C_M_AXIS_OUTPUT_TUSER_WIDTH
    tug2: if C_HAS_M_AXIS_OUTPUT_TUSER /= 0 generate
    begin
      m_axis_output_fifo_in(mark_out'length+m_axis_output_fifo_mark_out_lsb-1 downto
                            m_axis_output_fifo_mark_out_lsb) <= mark_out;
        
      m_axis_output_tuser <= std_logic_vector(resize(unsigned(
        m_axis_output_fifo_out(mark_out'length+m_axis_output_fifo_mark_out_lsb-1 downto
                               m_axis_output_fifo_mark_out_lsb)), C_M_AXIS_OUTPUT_TUSER_WIDTH));
    end generate; -- tug2
   
   
   
    ----------------------------------------------------------------------------
    -- Generate m_axis_output_tlast signal by passing last_data_out through the
    -- AXI output FIFO on the MSB of the FIFO data bus.
    m_axis_output_fifo_in(m_axis_output_fifo_width-1) <= last_data_out;
    m_axis_output_tlast <= m_axis_output_fifo_out(m_axis_output_fifo_width-1);
  
  end generate; -- ofg1
  

  ofg2 : if C_HAS_M_AXIS_OUTPUT_TREADY = 0 generate
  begin
    output_fifo_has_room <= '1'; -- output never stalls core
    output_fifo_has_room_del <= '1';
    output_fifo_has_room_both <= '1';
    
    m_axis_output_tvalid <= rdy_out;

    --[GO] previous code    m_axis_output_tlast <= last_data_out;
    --3 cycle delay added to last_data_out because legacy core gives signal out
    --3 cycles early.
    m_axis_output_tlast <= last_data_out;
    
    -- Connect AXI data inputs and outputs
    
    -- Include data_out
    m_axis_output_tdata_tmp(symbol_width_minus_1 downto 0) <= data_out;
    
    -- Include info if required
    ifg1: if C_HAS_INFO /= 0 generate
    begin
      m_axis_output_tdata_tmp(data_out_field_width) <= info;
    end generate; -- ifg1
    
    -- Include optional m_axis_output_tuser output from mark_out
    -- C_M_AXIS_OUTPUT_TUSER_WIDTH should equal C_S_AXIS_INPUT_TUSER width (=mark_out width)
    tug2: if C_HAS_M_AXIS_OUTPUT_TUSER /= 0 generate
    begin
      m_axis_output_tuser <= mark_out;
    end generate; -- tug2
  
  end generate; -- ofg2

  ------------------------------------------------------------------------------
  -- Event signals
  -- Event signals are single cycle active high flags to indicate protocol error
  -- events occuring on either the input or output streaming interfaces.
  --The event signals have been implemented in the rs_encoder_v8_0_legacy entity
  --because that is where the symbol counters reside.
  ------------------------------------------------------------------------------
  -- <rs_encoder_v8_0_legacy> Connections
  
  -- Clock enable, inner core is disabled if there is no more room in output FIFO
  enc_ce <= aclken_int and (output_fifo_has_room_both);

  -- New Data (nd) input driven whenever there's a valid beat on the AXI interface
  nd_in <= s_axis_input_tvalid and input_tready and output_fifo_has_room_del;
  
  -- Generate incoming data bus
  data_in <= s_axis_input_tdata(symbol_width_minus_1 downto 0);
  
  -- Generate optional mark_in input from s_axis_input_tuser
  tug1: if C_HAS_S_AXIS_INPUT_TUSER /= 0 generate
  begin
    mark_in <= s_axis_input_tuser;
  end generate; -- tug1
 
  input_tlast <= s_axis_input_tlast;
  
  -- Registers enabled by <aclken>
  rgp1 : process (aclk)
  begin
    if rising_edge(aclk) then
      if sr_smpld = '1' then
        input_tready <= '0'; -- AXI standard requires tready to be low during reset
          
      --[GO] aclken replaced with aclken_int     
      elsif aclken_int = '1' then

        -- Input tready is high when <rs_encoder_v8_0_legacy> rfd output is high unless
        -- o/p FIFO is stalled or we are ready to start a new block but the ctrl FIFO is empty
        if C_HAS_S_AXIS_CTRL = 0 then
          -- Could just use rfd output from <rs_encoder_v8_0_legacy> directly in this case except
          -- it is reset to a '1', which violates the AXI standard.
          input_tready <= rfd_din and output_fifo_has_room;
        else
          input_tready <= rfd_din and output_fifo_has_room and (ctrl_fifo_not_empty or not(rffd_din));
        end if; -- C_HAS_S_AXIS_CTRL = 0

      end if; -- sr_smpld = '1'
    end if; -- rising_edge(aclk)
  end process; -- rgp1

  -- Register event outputs.

  tlast_missing_qual    <=  enc_ce and tlast_missing;
  tlast_unexpected_qual <=  enc_ce and tlast_unexpected;
  ctrl_invalid_qual     <= (enc_ce and ctrl_invalid) or ctrl_invalid_event; -- sticky

  i_event_reg  : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => 1,
      C_HAS_CE   => 1,
      C_HAS_SCLR => 1,
      C_WIDTH    => 3
      )
    port map(
      CLK     => aclk,
      CE      => aclken_int,
      SCLR    => sr_smpld,
      D(0)    => tlast_missing_qual,
      D(1)    => tlast_unexpected_qual,
      D(2)    => ctrl_invalid_qual,
      Q(0)    => event_s_input_tlast_missing,
      Q(1)    => event_s_input_tlast_unexpected,
      Q(2)    => ctrl_invalid_event
    );

  event_s_ctrl_tdata_invalid <= ctrl_invalid_event;

  ------------------------------------------------------------------------------
  -- Need to delay TUSER by number of cycles of latency within the main core
  ------------------------------------------------------------------------------
  i_marker_delay  : xbip_pipe_v2_0_xst
    generic map(
        C_LATENCY  => core_latency,
        C_HAS_CE   => 1,
        C_HAS_SCLR => 0,                --no need, allows SRL use.
        C_WIDTH    => C_S_AXIS_INPUT_TUSER_WIDTH
        )
      port map(
        CLK     => aclk,
        CE      => enc_ce,           --same ce as core
        D       => mark_in,
        Q       => mark_out
        );

  in_tlast <= s_axis_input_tlast and nd_in;
  ------------------------------------------------------------------------------
  -- Object: enc
  -- Instantiate the main encoder entity, <rs_encoder_v8_0_legacy>
  ------------------------------------------------------------------------------
  enc : rs_encoder_v8_0_legacy
    generic map (
      --C_EVALUATION                   => C_EVALUATION,
      C_FAMILY                       => C_FAMILY,
      C_XDEVICEFAMILY                => C_XDEVICEFAMILY,
      C_HAS_CE                       => enc_has_ce,
      C_HAS_N_IN                     => C_HAS_N_IN,
      C_HAS_ND                       => 1,  -- Top level always has tvalid
      C_HAS_R_IN                     => C_HAS_R_IN,
      C_HAS_RDY                      => 1,  -- Used to produce output tvalid
      C_HAS_RFD                      => 1,  -- Top level always has tready
      C_HAS_RFFD                     => 1,  -- Use RFFD to start a new block as soon as possible
      C_HAS_SCLR                     => C_HAS_ARESETN,
      C_MEM_INIT_PREFIX              => C_MEM_INIT_PREFIX,
      C_ELABORATION_DIR              => C_ELABORATION_DIR,
      C_SPEC                         => C_SPEC,
      C_GEN_POLY_TYPE                => C_GEN_POLY_TYPE,
      C_GEN_START                    => C_GEN_START,
      C_H                            => C_H,
      C_K                            => C_K,
      C_N                            => C_N,
      C_POLYNOMIAL                   => C_POLYNOMIAL,
      C_NUM_CHANNELS                 => C_NUM_CHANNELS,
      C_SYMBOL_WIDTH                 => C_SYMBOL_WIDTH,
      C_MEMSTYLE                     => C_MEMSTYLE
      )
    port map (
      data_in                        => data_in,
      n_in                           => n_in,
      r_in                           => r_in,
      start                          => start_enc,
      bypass                         => '0',  -- Not supported
      nd                             => nd_in,
      sclr                           => sr_smpld,
      in_tlast                       => in_tlast,
      data_out                       => data_out,
      info                           => info,
      rdy                            => rdy_out,
      rfd                            => open,
      rfd_din                        => rfd_din,
      rffd                           => rffd_out,
      rffd_din                       => rffd_din,
      last_data_tlast                => last_data_out,
      event_s_input_tlast_missing    => tlast_missing,
      event_s_input_tlast_unexpected => tlast_unexpected,
      event_s_ctrl_tdata_invalid     => ctrl_invalid,
      ce                             => enc_ce,
      clk                            => aclk
      );

end behavioral;



