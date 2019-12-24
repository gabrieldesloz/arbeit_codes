-------------------------------------------------------------------------------
-- $RCSfile: fir_compiler_v6_0.vhd,v $ $Revision: 1.8 $ $Date: 2010/09/09 16:50:54 $
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
-- 
-- This behavioural model uses the basic FIR algorithm to predict the output
-- values which the core should produce.  For multi-rate cases, data is either
-- up-sampled at input or downsampled at the output in order to model the 
-- flow of data as a basic single rate filter for all cases - while this is
-- computationally less efficient, it should give a good alternative approach
-- compared to the hardware and ensures that the desired effect is achieved
-- regardless of any polyphase extraction methods.
-- For v6.0 the model has been re-writen. The core now supports AXI interfaces
-- and to ensure the TREADY of the i/p and the TVALID of the o/p behave correctly
-- the timing of read and writes must match the core. The computation still uses a 
-- simplified (non-optimized) filter implementation very similar to v5.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;
use xilinxcorelib.fir_compiler_v6_0_sim_pkg.all;

--core_if on entity fir_compiler_v6_0
  entity fir_compiler_v6_0 is
  generic (
    C_XDEVICEFAMILY     : string  := "virtex6";
    C_ELABORATION_DIR   : string  := "./";
    C_COMPONENT_NAME    : string  := "fir_v6_0_default";
    C_COEF_FILE         : string  := "fir_v6_0_default.mif";
    C_COEF_FILE_LINES   : integer := 11;
    
    C_FILTER_TYPE          : integer := 0;
    C_INTERP_RATE          : integer := 1;
    C_DECIM_RATE           : integer := 1;
    C_ZERO_PACKING_FACTOR  : integer := 1;
    C_SYMMETRY             : integer := 0;
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
    C_INPUT_RATE           : integer := 11; -- ?? Maybe redundant
    C_OUTPUT_RATE          : integer := 11;
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
    -- C_DATA_HAS_TUSER     : integer := 0; -- 0=no 1=yes -- 0=no 1=chanid only 2=user only 3=both
    
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
end fir_compiler_v6_0;

architecture behavioral of fir_compiler_v6_0 is
  
  -------------------------------------------------------------------------------
  -- FIR PROPERTIES -----------------------------------------------------------
  --   Type and function to derive or set some additional information, given the filter
  --   structure, from the core generics
  type t_fir_properties is
  record
    actual_taps         : integer;
    reload_taps         : integer;
    full_taps           : integer;
    madd_mem_depth      : integer;
    px_time             : integer; -- time need to generate an output
    op_px_time          : integer;
    ipbuff_size         : integer;
    ipbuff_thres        : integer;
    ipbuff_custom       : boolean; -- determines if the core has combined the AXI fifo and a paged buffer that is processing the sample sequnce
                                   -- paged functionality and page size will determine how the VALID (or READY) signal will behave. 
                                   -- i.e. some hysteresis, will require several sample before a read can start but once it has
                                   -- started it can continue until empty
    opbuff_size         : integer;
    opbuff_custom       : boolean;                               
    opbuff_thres        : integer;
    ipbuff_read_dly     : integer; -- internal dly from ip fifo full/not empty to the core reading the fifo
    cntrl_dly           : integer;
    data_dly            : integer;
    cnfg_read_dly       : integer;
    -- Legacy but easier to keep
    odd_symmetry        : integer;
    casc_mod            : integer; -- amount to modify C_LATENCY by for cascade depth
    flip_reload_order   : boolean; -- normally the model flips the order of the indexes contained in the mif file to 
                                   -- generate the reload order , but the new parallel symmetric structure flips the
                                   -- coefficient postion i.e the first tap is processed by the last DSP48 in a chain
                                   -- This is to minimize the buffering required to account for the -1 previously in the
                                   -- sym path but now moved to the non-sym path
                                   -- When this is set to TRUE the indexes will NOT be flipped
  end record;
  
  -------------------------------------------------------------------------------
  -- CONSTANTS ----------------------------------------------------------------
  
  -- Values derivied from input generates
  constant ci_data_path_signs : t_int_array:=fn_str_to_int_array(C_DATA_PATH_SIGN,',');
  constant ci_coef_path_widths: t_int_array:=fn_str_to_int_array(C_COEF_PATH_WIDTHS,',');
  constant ci_coef_path_signs : t_int_array:=fn_str_to_int_array(C_COEF_PATH_SIGN,',');
  constant ci_coef_path_src   : t_int_array:=fn_str_to_int_array(C_COEF_PATH_SRC,',');
  constant ci_op_accum_widths : t_int_array:=fn_str_to_int_array(C_ACCUM_OP_PATH_WIDTHS,',');
  constant ci_output_widths   : t_int_array:=fn_str_to_int_array(C_OUTPUT_PATH_WIDTHS,',');
  constant ci_num_paths       : integer := ci_op_accum_widths'LENGTH;
  -- C_COEF_WIDTH does not include the extra bits required to read in the symmetric pair
  -- coefficients. The path widths will sum to greater than the raw C_COEF_WIDTH values
  constant ci_coef_width_physical   : integer := fn_get_path_base_i(ci_coef_path_widths,ci_coef_path_src,ci_data_path_signs'LENGTH);
  
  -- Take last path sign as indication for what the sign of each path is.
  constant ci_data_sign   : integer := ci_data_path_signs(ci_data_path_signs'HIGH);
  constant ci_coef_sign   : integer := ci_coef_path_signs(ci_coef_path_signs'HIGH);
  constant ci_accum_width : integer := ci_op_accum_widths(ci_op_accum_widths'HIGH);
  
  constant ci_fixed_chan_pat : boolean := fn_str_compare(C_CHANNEL_PATTERN,"fixed");
  constant ci_chan_pat       : t_int_array := fn_get_channel_pat(ci_fixed_chan_pat,C_NUM_CHANNELS,C_CHANNEL_PATTERN);
  constant ci_pat_len        : integer := 2**log2roundup(C_NUM_CHANNELS);
  constant ci_num_pat        : integer := ci_chan_pat'LENGTH / ci_pat_len;
  constant ci_chan_base      : t_int_array := fn_gen_has_diff_bases(ci_fixed_chan_pat,C_NUM_CHANNELS,ci_chan_pat);
  constant ci_chan_pat_step  : t_int_array := fn_gen_addr_step(ci_fixed_chan_pat,C_NUM_CHANNELS,1,ci_chan_pat,ci_chan_base,true);
  
  -- Constants that fn_gen_fir_props needs
  -- Lat of cnfg and reload interface
  constant ci_cnfg_lat      : integer := fn_select_integer(0,3,C_HAS_CONFIG_CHANNEL=1);
  
  -------------------------------------------------------------------------------
  -- FIR Properties function
  function fn_gen_fir_properties return t_fir_properties is
    variable properties : t_fir_properties;
    variable cnfg_and_rld_lat : integer;
    variable rounding_cnfg : t_rounding_cnfg;
  begin
    properties.flip_reload_order := false;
    case C_FILTER_TYPE is
    when ci_single_rate =>
      properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE;
      properties.full_taps          :=C_NUM_MADDS * C_OVERSAMPLING_RATE * fn_select_integer(1,2,C_SYMMETRY/=ci_non_symmetric) 
                                      - fn_select_integer(0,(C_NUM_TAPS rem 2),C_SYMMETRY/=ci_non_symmetric);
      properties.reload_taps        :=properties.actual_taps;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE;
      rounding_cnfg := fn_get_rounding_cnfg(
                         C_XDEVICEFAMILY,
                         C_ROUND_MODE,
                         true,
                         C_INPUT_RATE > C_OVERSAMPLING_RATE and C_OVERSAMPLING_RATE>1);
      if rounding_cnfg.use_spare_cycle then
        properties.px_time            :=C_OVERSAMPLING_RATE+1;
      else
        properties.px_time            :=C_OVERSAMPLING_RATE;
      end if;
      properties.odd_symmetry       :=(C_NUM_TAPS rem 2);
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.ipbuff_thres       :=1;
      properties.ipbuff_custom      :=false;
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.ipbuff_read_dly    :=1; -- N/A ipbuff_read not used by this structure
      properties.cntrl_dly          := ci_cnfg_lat;
      if C_OVERSAMPLING_RATE = 1 then 
        properties.data_dly           := ci_cnfg_lat; -- not sure about this yet!
      else
        properties.data_dly           := ci_cnfg_lat-1;
      end if;
      properties.cnfg_read_dly      := 0;
      properties.casc_mod           := properties.cntrl_dly + properties.px_time + fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
      -- Further mods required for i/p and o/p fifo
      if C_OVERSAMPLING_RATE = 1 and C_SYMMETRY/=ci_non_symmetric then
        properties.flip_reload_order := true; -- see comments in properties type definition 
      end if;
    when ci_halfband_decimation => 
      if divroundup(divroundup(C_NUM_TAPS,2),2) + 1 = C_OVERSAMPLING_RATE then
        -- Single mac
        properties.actual_taps        :=(C_OVERSAMPLING_RATE-1) * 2;
        cnfg_and_rld_lat := fn_cnfg_and_reload(C_NUM_FILTS,
                                               C_FILTS_PACKED,
                                               1, -- N/A
                                               C_COEF_RELOAD=1,
                                               ci_fixed_chan_pat,
                                               false).latency;
      else
        properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE * 2;
        cnfg_and_rld_lat := fn_cnfg_and_reload(C_NUM_FILTS,
                                               C_FILTS_PACKED,
                                               1, -- N/A
                                               C_COEF_RELOAD=1,
                                               ci_fixed_chan_pat,
                                               true).latency;
      end if;
      if cnfg_and_rld_lat /= 0 then
        cnfg_and_rld_lat := cnfg_and_rld_lat +1; -- core add one more cycle
      end if;
      properties.full_taps          :=(properties.actual_taps * 2)-1;
      properties.reload_taps        :=properties.actual_taps/2 + 1;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE;
      if C_M_DATA_HAS_TREADY= 1 then
        properties.px_time            :=C_OVERSAMPLING_RATE;
      else
        properties.px_time            :=C_OUTPUT_RATE;
      end if;
      properties.odd_symmetry       :=1;
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;--2**log2roundup(get_max(16,4*C_NUM_CHANNELS+cnfg_and_rld_lat));
      properties.ipbuff_thres       :=1;--2*C_NUM_CHANNELS;
      properties.ipbuff_custom      :=false;--true;
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.cnfg_read_dly    := 0;
      if not ci_fixed_chan_pat then
        properties.ipbuff_read_dly    :=ci_cnfg_lat;--+2;
      else
        properties.ipbuff_read_dly    :=1;
      end if;
      if ci_fixed_chan_pat then
        if C_CONFIG_SYNC_MODE=ci_cnfg_packet_sync then
          -- The confg update needs to allign with the data being read out of the ipbuffer, specifically tlast
          properties.cnfg_read_dly    :=fn_mem_lat(C_XDEVICEFAMILY,C_IPBUFF_MEMTYPE,ci_write_first,2)+1+1;
          properties.cntrl_dly         := get_max(2,ci_cnfg_lat+properties.cnfg_read_dly+1);-- -1); -- ip buff lat -- 1 to gen read the other to fetch data
          properties.data_dly          := get_max(0,ci_cnfg_lat+properties.cnfg_read_dly);-- -1);-- -1);
        else
          properties.cntrl_dly         := get_max(2,ci_cnfg_lat); -- ip buff lat -- 1 to gen read the other to fetch data
          properties.data_dly          := get_max(0,ci_cnfg_lat-1);
        end if;
      else
        properties.cntrl_dly         := ci_cnfg_lat+1;--3;--1;--2; 
        properties.data_dly          := 0;
      end if;
      properties.casc_mod           := properties.cntrl_dly + properties.px_time + fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
    when ci_halfband_interpolation =>
      if divroundup(divroundup(C_NUM_TAPS,2),2) + 1 = C_OVERSAMPLING_RATE then
        properties.actual_taps        :=(C_OVERSAMPLING_RATE-1) * 2;
      else
        properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE * 2;
      end if;
      properties.full_taps          :=(properties.actual_taps * 2)-1;
      properties.reload_taps        :=properties.actual_taps/2 + 1;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE;
      properties.px_time            :=C_OVERSAMPLING_RATE;
      properties.odd_symmetry       :=1;
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.ipbuff_thres       :=1;
      properties.ipbuff_custom      :=false;
      properties.ipbuff_read_dly    :=1; -- N/A ipbuff_read not used by this structure
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;--get_max(16,2**log2roundup(C_NUM_CHANNELS));--
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.cntrl_dly          := ci_cnfg_lat;
      properties.data_dly           := ci_cnfg_lat-1;
      properties.cnfg_read_dly      := 0;
      -- if C_M_DATA_HAS_TREADY = 1 then
        -- properties.op_px_time       := 1;
        -- properties.casc_mod         := properties.cntrl_dly + properties.px_time + 1;--fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
        -- -- The model starts wrting to the output fifo than the core does so don't
        -- -- subtract any extra latency
      -- else
        properties.op_px_time       := C_OUTPUT_RATE;--C_OVERSAMPLING_RATE;
        properties.casc_mod         := properties.cntrl_dly + properties.px_time + C_OUTPUT_RATE + fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
      -- end if;
      -- report "fn_gen_fir_properties: properties.casc_mod: " & integer'image(properties.casc_mod);
      
    when ci_polyphase_decimation =>
      properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_DECIM_RATE;
      properties.full_taps          :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_DECIM_RATE * fn_select_integer(1,2,C_SYMMETRY/=ci_non_symmetric) 
                                      - fn_select_integer(0,(C_NUM_TAPS rem 2),C_SYMMETRY/=ci_non_symmetric);
      properties.reload_taps        :=properties.actual_taps;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE * C_DECIM_RATE;
      rounding_cnfg := fn_get_rounding_cnfg(
                         C_XDEVICEFAMILY,
                         C_ROUND_MODE,
                         true,
                         C_INPUT_RATE > C_OVERSAMPLING_RATE and C_OVERSAMPLING_RATE>1);
                         
      if C_INPUT_RATE > C_OVERSAMPLING_RATE and C_M_DATA_HAS_TREADY = 0 and C_NUM_CHANNELS>1 then
        properties.px_time            :=C_INPUT_RATE;
      elsif rounding_cnfg.use_spare_cycle then
        properties.px_time            :=C_OVERSAMPLING_RATE+1;
      else
        properties.px_time            :=C_OVERSAMPLING_RATE;
      end if;
      properties.odd_symmetry       :=(C_NUM_TAPS rem 2);
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.ipbuff_thres       :=1;
      properties.ipbuff_custom      :=false;
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.ipbuff_read_dly    :=1; -- N/A ipbuff_read not used by this structure
      properties.cntrl_dly          := ci_cnfg_lat;
      -- properties.data_dly           := ci_cnfg_lat-1;
      if C_OVERSAMPLING_RATE = 1 then  -- copied from single_rate
        properties.data_dly           := ci_cnfg_lat; 
      else
        properties.data_dly           := ci_cnfg_lat-1;
      end if;
      
      properties.cnfg_read_dly      := 0;
      properties.casc_mod           := properties.cntrl_dly + 
                                       properties.px_time + 
                                       fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1)+
                                       fn_select_integer(0,-1,C_M_DATA_HAS_TREADY=0 and C_NUM_CHANNELS>1)+
                                       fn_select_integer(0,-(C_INPUT_RATE-C_OVERSAMPLING_RATE),C_INPUT_RATE > C_OVERSAMPLING_RATE and C_M_DATA_HAS_TREADY = 0 and C_NUM_CHANNELS>1 ); 
                                       -- Need to add extra latency to account for the increased size of px_time
      if C_OVERSAMPLING_RATE = 1 and C_SYMMETRY/=ci_non_symmetric then
        properties.flip_reload_order := true; -- see comments in properties type definition 
      end if;
    when ci_decimation =>
      properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_INTERP_RATE;
      properties.full_taps          :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_INTERP_RATE * fn_select_integer(1,2,C_SYMMETRY/=ci_non_symmetric) 
                                      - fn_select_integer(0,(C_NUM_TAPS rem 2),C_SYMMETRY/=ci_non_symmetric);
      properties.reload_taps        :=properties.actual_taps;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE * C_INTERP_RATE;
      properties.px_time            :=C_OVERSAMPLING_RATE;
      properties.odd_symmetry       :=(C_NUM_TAPS rem 2);
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.ipbuff_thres       :=1;
      properties.ipbuff_custom      :=false;
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.ipbuff_read_dly    :=1; -- N/A ipbuff_read not used by this structure
      properties.cntrl_dly          := ci_cnfg_lat+1;
      properties.data_dly           := ci_cnfg_lat;-- -1;
      properties.cnfg_read_dly      := 1;--0; -- to allign with core
      properties.casc_mod           := properties.cntrl_dly + properties.px_time + fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
    when ci_polyphase_interpolation =>
      properties.actual_taps        :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_INTERP_RATE;
      properties.full_taps          :=C_NUM_MADDS * C_OVERSAMPLING_RATE * C_INTERP_RATE * fn_select_integer(1,2,C_SYMMETRY/=ci_non_symmetric) 
                                      - fn_select_integer(0,(C_NUM_TAPS rem 2),C_SYMMETRY/=ci_non_symmetric);
      -- if C_SYMMETRY/=ci_non_symmetric and C_INTERP_RATE rem 2 > 0 and C_NUM_TAPS rem 2>0 then
        -- -- ci_odd_phase_odd_sym
        -- --    - Need to correct for the shift of the cenre tap to the centre phase
        -- properties.full_taps := properties.full_taps - (2*divroundup(C_INTERP_RATE,2));
      -- end if;
      properties.reload_taps        :=properties.actual_taps;
      properties.madd_mem_depth     :=C_OVERSAMPLING_RATE * C_INTERP_RATE;
      properties.px_time            :=C_OVERSAMPLING_RATE;-- * C_INTERP_RATE;
      properties.odd_symmetry       :=(C_NUM_TAPS rem 2);
      properties.ipbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.ipbuff_thres       :=1;
      properties.ipbuff_custom      :=false;
      properties.opbuff_size        :=get_max(32,2**log2roundup(C_NUM_CHANNELS));--16;
      properties.opbuff_custom      :=false;
      properties.opbuff_thres       :=1;
      properties.ipbuff_read_dly    :=1; -- N/A ipbuff_read not used by this structure
      properties.cntrl_dly          := ci_cnfg_lat;
      if C_OVERSAMPLING_RATE = 1 then -- seen in single rate as well
        properties.data_dly           := ci_cnfg_lat; -- not sure about this yet!
      else
        properties.data_dly           := ci_cnfg_lat-1;
      end if;
      properties.cnfg_read_dly      := 0;
      properties.casc_mod           := properties.cntrl_dly + properties.px_time + fn_select_integer(0,1,C_M_DATA_HAS_TREADY=1);
      if C_OVERSAMPLING_RATE = 1 and C_SYMMETRY/=ci_non_symmetric then
        properties.flip_reload_order := true; -- see comments in properties type definition 
      end if;
    when others =>
      report "FAILURE: FIR Compiler: Invalid filter type." severity failure;
    end case;
    return properties;
  end function;
  
  constant ci_fir_properties : t_fir_properties := fn_gen_fir_properties;
  
  -------------------------------------------------------------------------------
  -- CONSTANTS continued.....  
  
  -- Constants to define internal data types
  
  -- Create integer overflow thresholds explicitly, as decisions are made based
  -- on the widths of these values
  constant ci_max_int_width : integer :=  31;
  constant ci_maxint        : integer :=    2**(ci_max_int_width-1) - 1;
  constant ci_minint        : integer := -1*2**(ci_max_int_width-1);
  
  --Determine if data needs to be split, in future could extend to >64 bits but leave as simple division
  constant ci_split_dwidth : integer := fn_select_integer(C_DATA_WIDTH,(C_DATA_WIDTH+1)/2,C_DATA_WIDTH+ci_data_sign>=ci_max_int_width);
  
  constant ci_dpages : integer:= fn_select_integer(1,2,C_DATA_WIDTH+ci_data_sign>=ci_max_int_width);
  
  -- Determine the coefficient split point based on the data width
  constant ci_split_cwidth : integer := get_min( (ci_max_int_width-ci_split_dwidth-fn_select_integer(ci_data_sign,1,ci_dpages>1)) , C_COEF_WIDTH );
  
  -- Determine required coefficient pages based on partial product split
  constant ci_cpages : integer := (C_COEF_WIDTH+ci_split_cwidth-1)/ci_split_cwidth;
  
  -- Determine if we need to split the accumulator into separate integers to avoid
  -- MAXINT overflow
  constant ci_split_accum : boolean :=  ci_accum_width >= ci_max_int_width
                                        or (C_DATA_WIDTH+fn_select_integer(ci_data_sign,1,ci_dpages>1)+C_COEF_WIDTH) >= ci_max_int_width
                                        or (ci_cpages>1); --add just to make sure if coefficient are split then the correct fir function is used
  
  -- Determine whether or not output is a signed value or not
  constant ci_signed_output : boolean := ((ci_coef_sign=0) or (ci_data_sign=0));
  
  -- Regressor depth
  constant ci_main_buffer_depth : integer := ci_fir_properties.full_taps+
                                             20--; -- ****TEMP is a fudge factor required? Different input and output rates??
                                             + fn_select_integer(0,2*C_NUM_CHANNELS,C_FILTER_TYPE = ci_halfband_interpolation)--;
                                             -- Paged re-ordering output buffer included in main buffer
                                             + fn_select_integer(0,C_DECIM_RATE*C_NUM_CHANNELS,C_FILTER_TYPE = ci_decimation or C_FILTER_TYPE = ci_polyphase_decimation)--;
                                             -- All data is pushed into the main buffer before processing starts
                                             + fn_select_integer(0,2 * C_INTERP_RATE*C_NUM_CHANNELS+ci_fir_properties.cntrl_dly+1+C_OUTPUT_RATE,C_FILTER_TYPE = ci_polyphase_interpolation);
                                             -- All interpolated values pushed into main buffer before processing starts. Significant issue
                                             -- when config channel patterns where you chan have C_NUM_CHANNELS (pat_len) * interpolation samples
                                             -- generated for 1 channel
                                             -- NOTE: need double the buffer overhead as may push next lot of samples before all of the
                                             -- previous outputs have been genereted
  
  -- AXI constants and type slices ------------------------------------------
  --  Duplication from ../hdl/single_rate.vhd
  constant ci_data_width_concat : integer := C_DATA_WIDTH * ci_num_paths;
  constant ci_output_width_concat : integer := C_OUTPUT_WIDTH * ci_num_paths;
  
  constant ci_tlast_width : integer := fn_select_integer(0,1,C_DATA_HAS_TLAST/=ci_no_tlast);
  
  constant ci_s_tuser_width     : integer := fn_select_integer(0,C_S_DATA_TUSER_WIDTH,C_S_DATA_HAS_TUSER/=ci_no_tuser);
  constant ci_s_tdata_fields    : t_int_array(ci_num_paths-1 downto 0):=(others=>C_DATA_WIDTH);
  subtype s_s_tdata is integer range ci_data_width_concat-1 downto 0;
  subtype s_s_tuser is integer range ci_s_tuser_width+s_s_tdata'HIGH downto s_s_tdata'HIGH+1;
  subtype s_s_tlast is integer range ci_tlast_width+s_s_tuser'HIGH downto s_s_tuser'HIGH+1;
  constant ci_s_tuser_chanid_width : integer := fn_select_integer(0,log2roundup(C_NUM_CHANNELS),C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser+ci_user_tuser);
  constant ci_s_tuser_user_width   : integer := fn_select_integer(0,C_S_DATA_TUSER_WIDTH-ci_s_tuser_chanid_width,C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser+ci_user_tuser);
  subtype s_s_tuser_chanid is integer range ci_s_tuser_chanid_width-1 downto 0;
  subtype s_s_tuser_user   is integer range ci_s_tuser_user_width+s_s_tuser_chanid'HIGH downto s_s_tuser_chanid'HIGH+1;
  
  constant ci_m_tuser_width : integer := fn_select_integer(0,C_M_DATA_TUSER_WIDTH,C_M_DATA_HAS_TUSER/=ci_no_tuser);
  subtype s_m_tdata is integer range ci_output_width_concat-1 downto 0;
  subtype s_m_tuser is integer range ci_m_tuser_width+s_m_tdata'HIGH downto s_m_tdata'HIGH+1;
  subtype s_m_tlast is integer range ci_tlast_width+s_m_tuser'HIGH downto s_m_tuser'HIGH+1;
  constant ci_m_tuser_chanid_width : integer := fn_select_integer(0,log2roundup(C_NUM_CHANNELS),C_M_DATA_HAS_TUSER = ci_chanid_tuser or C_M_DATA_HAS_TUSER = ci_chanid_tuser+ci_user_tuser);
  constant ci_m_tuser_user_width   : integer := fn_select_integer(0,C_M_DATA_TUSER_WIDTH-ci_m_tuser_chanid_width,C_M_DATA_HAS_TUSER = ci_user_tuser or C_M_DATA_HAS_TUSER = ci_chanid_tuser+ci_user_tuser);
  subtype s_m_tuser_chanid is integer range ci_m_tuser_chanid_width-1 downto 0;
  subtype s_m_tuser_user   is integer range ci_m_tuser_user_width+s_m_tuser_chanid'HIGH downto s_m_tuser_chanid'HIGH+1;
  
  constant ci_tuser_dly_width : integer := ci_s_tuser_user_width +
                                           fn_select_integer(0,1,C_DATA_HAS_TLAST = ci_pass_tlast);
  
  -- Define sub fields of CONFIG_TDATA
  constant ci_fsel_width      : integer := fn_select_integer(
                                              fn_select_integer(
                                                0,
                                                1, -- Need to set a minimum width. No FSEL or CHANPAT. The content will be null
                                                ci_fixed_chan_pat),
                                              log2roundup(C_NUM_FILTS),
                                              C_NUM_FILTS>1);
  constant ci_fsel_8bit_width : integer := fn_select_integer(
                                             divroundup(ci_fsel_width,8)*8,
                                             1,
                                             C_HAS_CONFIG_CHANNEL=0); -- to ensure the bus slice will match the default with of 1-bit
  constant ci_chanpat_width : integer := fn_select_integer(0,log2roundup(ci_num_pat),not ci_fixed_chan_pat);
  
  subtype s_fsel is integer range ci_fsel_width-1 downto 0;
  subtype s_chanpat is integer range ci_chanpat_width+ci_fsel_8bit_width-1 downto ci_fsel_8bit_width;
  
  -------------------------------------------------------------------------------
  -- TYPES --------------------------------------------------------------------
  type t_bool_array is array (integer range <>) of boolean;
  -- Coefficient storage types
  type t_coefficients     is array (0 to   ci_fir_properties.full_taps-1) of integer;
  -- type t_coeffs_array     is array (integer range <>) of std_logic_vector(C_COEF_WIDTH-1 downto 0);
  type t_coeffs_array     is array (integer range <>) of std_logic_vector(ci_coef_width_physical-1 downto 0);
  subtype t_coefficients_slv is t_coeffs_array(0 to   ci_fir_properties.full_taps-1);
  subtype t_reload_coeffs is t_coeffs_array(0 to ci_fir_properties.reload_taps-1);
  
  type t_split_coeff      is array (0 to ci_cpages-1) of integer;
  type t_coeff_pages      is array (0 to ci_cpages-1) of t_coefficients;
  type t_coeff_array      is array (0 to 
                                      fn_select_integer(
                                        2**log2roundup(C_NUM_FILTS+fn_select_integer(0,C_NUM_RELOAD_SLOTS,C_COEF_RELOAD=1)),
                                        C_NUM_CHANNELS,
                                        C_FILTER_TYPE=ci_channelizer_receiver or C_FILTER_TYPE=ci_channelizer_transmitter)-1) of t_coeff_pages;
  
  -- Data storage types
  type t_data_type        is array (0 to              ci_dpages-1) of integer;
  -- type t_data_paths       is array (0 to           ci_num_paths-1) of t_data_type;
  type t_data_array       is array (integer range <>) of t_data_type;
  subtype t_regressor     is t_data_array(0 to ci_fir_properties.full_taps-1);
  subtype t_data_buffer   is t_data_array(0 to ci_main_buffer_depth-1);
  type t_tuser_array      is array (integer range <>) of std_logic_vector(ci_tuser_dly_width-1 downto 0);
  type t_main_buffer is
  record
    data            : t_data_buffer;
    fsel            : t_int_array(0 to ci_main_buffer_depth-1);
    tuser           : t_tuser_array(0 to ci_main_buffer_depth-1);
    chanpat         : t_int_array(0 to ci_main_buffer_depth-1);
    chanpat_updated : t_bool_array(0 to ci_main_buffer_depth-1);
  end record;
  type t_main_buffer_array is array (0 to ci_num_paths-1,0 to C_NUM_CHANNELS-1) of t_main_buffer;
  
  -- Control types
  type t_pointers         is array (0 to           C_NUM_CHANNELS-1) of integer;
  
  --Multi-paths types
  type t_din_paths is array (0 to ci_num_paths-1) of std_logic_vector(C_DATA_WIDTH-1 downto 0);
  type t_result_paths is array (0 to ci_num_paths-1) of std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);
  
  -- Cascade delay
  -- type t_cascade_dly is array (0 to C_LATENCY-1) of t_result_paths;
  type t_cascade is
  record
    result  : t_result_paths;
    -- tuser   : std_logic_vector(ci_tuser_dly_width-1 downto 0);
    tuser   : std_logic_vector(s_m_tuser_user);
    tlast   : std_logic;--std_logic_vector(s_m_tlast'RANGE);
    chan_id : integer;
    valid   : boolean;
  end record;
  type t_cascade_dly is array (0 to C_LATENCY-ci_fir_properties.casc_mod-1) of t_cascade;
  
  -- Input and output buffer types
  -- type t_ipbuff is array (0 to ci_fir_properties.ipbuff_size-1) of std_logic_vector(s_s_tlast'HIGH downto 0);
  -- type t_opbuff is array (0 to ci_fir_properties.opbuff_size-1) of std_logic_vector(s_m_tlast'HIGH downto 0);
  constant ci_buffer_width : integer := get_max(
                                          s_s_tlast'HIGH,
                                          get_max(
                                            s_m_tlast'HIGH,
                                            s_chanpat'HIGH+1))+1;
  type t_buffer is array (integer range <>) of std_logic_vector(ci_buffer_width-1 downto 0);
  
  -------------------------------------------------------------------------------
  -- FUNCTIONS/PROCEDURES -------------------------------------------------------
  
  -- Type conversion functions
  function fn_slv_to_data_type ( slv_in: std_logic_vector) return t_data_type is
    variable ret_val : t_data_type;
  begin
    if ci_dpages=1 then
      if ci_data_sign=ci_signed then
        ret_val(0) := to_integer(signed(slv_in));
      else         
        ret_val(0) := to_integer(unsigned(slv_in));
      end if;
    else
      ret_val(0)   := to_integer(unsigned(slv_in(ci_split_dwidth-1 downto 0)));
      if ci_data_sign=ci_signed then
        ret_val(1) := to_integer(signed(slv_in(slv_in'HIGH downto ci_split_dwidth)));
      else         
        ret_val(1) := to_integer(unsigned(slv_in(slv_in'HIGH downto ci_split_dwidth)));
      end if;
    end if;
    return ret_val;
  end function fn_slv_to_data_type;
  
  procedure prc_dly( ip: in boolean; variable dly : inout t_bool_array; variable op : out boolean) is
  begin
    if dly'LENGTH > 0 then
      dly(dly'HIGH downto 1) := dly(dly'HIGH-1 downto 0);
      dly(0) := ip;
      op     := dly(dly'HIGH);
    else
      op := ip;
    end if;
  end procedure prc_dly;
  
  -- Signal variant
  -- procedure prc_dly( ip: in boolean; variable dly : inout t_bool_array; signal op : out boolean) is
    -- variable v_op : boolean;
  -- begin
    -- prc_dly(ip,dly,v_op);
    -- op<=v_op;
  -- end procedure prc_dly;
  
  procedure prc_dly( ip: in integer; variable dly : inout t_int_array; variable op : out integer) is
  begin
    if dly'LENGTH > 0 then
      dly(dly'HIGH downto 1) := dly(dly'HIGH-1 downto 0);
      dly(0) := ip;
      op     := dly(dly'HIGH);
    else
      op := ip;
    end if;
  end procedure prc_dly;
  
  procedure prc_dly( ip: in std_logic_vector; variable dly : inout t_buffer; variable op : out std_logic_vector) is
  begin
    if dly'LENGTH > 0 then
      dly(dly'HIGH downto 1) := dly(dly'HIGH-1 downto 0);
      dly(0)(ip'range) := ip;
      op     := dly(dly'HIGH)(op'range);
    else
      op := ip;
    end if;
  end procedure prc_dly;
  
  -- Basic FIFO implementation
  --  Behavour tries to match the axi_utils_v1_0 FIFOs, particularily when rdy_threshold is set to 1
  procedure prc_fifo( write, read     : in boolean;
                      data_in  : in std_logic_vector;
                      signal buff     : inout t_buffer;
                      signal ptr      : inout integer;
                      signal data_out : out std_logic_vector;
                      signal data_rdy  : inout boolean;
                      signal data_flag : inout boolean; -- extra threshold flag, used in some configurations
                      signal full     : out std_logic;
                      rdy_threshold   : integer;
                      full_threshold  : integer := -1;
                      flag_threshold  : integer := 0 ) is
    variable read_qual  : boolean;
    variable full_thres : integer := fn_select_integer(full_threshold,buff'HIGH,full_threshold=-1);
  begin
    read_qual := read and (ptr > -1 );--data_rdy;
    
    if write then
       buff(buff'HIGH downto 1) <= buff(buff'HIGH-1 downto 0);
       buff(0)(data_in'HIGH downto 0) <= data_in;
    end if;
    
    if read then --_qual then --or not data_rdy then -- so the valid data will be clk'ed out and then held 
      -- data_out <= buff(get_max(0,ptr))(data_out'HIGH downto 0);
      data_out <= buff( (ptr mod (buff'HIGH+1)) )(data_out'HIGH downto 0); 
      -- duplicate axi utils fifo and read last loc with addr -1 (empty)
    end if;
    
    if write and read_qual then           -- read and write
      -- no change in pointer state
      null;
    elsif write and not read_qual then    -- write and no read
      ptr <= ptr + 1;
      data_rdy <= false;
      if ptr >= rdy_threshold-2 then
        data_rdy <= true;
      end if;
      full <= '0';
      if ptr >= full_thres-1 then
        full <= '1';
      end if;
      data_flag <= false;
      if ptr >= flag_threshold-2 then
        data_flag <= true;
      end if;
    elsif not write and read_qual then    -- read and no write
      ptr <= ptr - 1;
      -- data_rdy <= false;
      data_rdy <= false;
      if ptr > rdy_threshold-1 then
        data_rdy <= true;
      end if;
      if full_threshold = -1 then
        -- Normal full behavour
        full <= '0';
      else
        -- Almost full behavour to match the axi utils fifo
        if ptr <= full_thres-1 then
          full <= '0';
        end if;
      end if;
      data_flag <= false;
      if ptr > flag_threshold-1 then
        data_flag <= true;
      end if;
    end if;
    
  end procedure prc_fifo;
  
  -- Main buffer shift
  procedure prc_push_main_buffer( chan               : integer;
                                 variable ptrs      : inout t_pointers;
                                 variable main_buff : inout t_main_buffer_array;
                                 data_in            : std_logic_vector;
                                 tuser_in           : std_logic_vector;
                                 fsel_in            : integer:=0;--??
                                 chanpat_in         : integer:=0;--??
                                 chanpat_upd_in     : boolean:=false ) is
  begin
    for path in 0 to ci_num_paths-1 loop
      main_buff(path,chan).data(1 to ci_main_buffer_depth-1) :=  main_buff(path,chan).data(0 to ci_main_buffer_depth-2);
      main_buff(path,chan).data(0)                           := fn_slv_to_data_type(fn_split_bus(path,data_in,ci_s_tdata_fields));
      
      main_buff(path,chan).tuser(1 to ci_main_buffer_depth-1) :=  main_buff(path,chan).tuser(0 to ci_main_buffer_depth-2);
      main_buff(path,chan).tuser(0)                           := tuser_in;
      
      main_buff(path,chan).fsel(1 to ci_main_buffer_depth-1) :=  main_buff(path,chan).fsel(0 to ci_main_buffer_depth-2);
      main_buff(path,chan).fsel(0)                           := fsel_in;
      
      main_buff(path,chan).chanpat(1 to ci_main_buffer_depth-1) :=  main_buff(path,chan).chanpat(0 to ci_main_buffer_depth-2);
      main_buff(path,chan).chanpat(0)                           := chanpat_in;
      
      main_buff(path,chan).chanpat_updated(1 to ci_main_buffer_depth-1) :=  main_buff(path,chan).chanpat_updated(0 to ci_main_buffer_depth-2);
      main_buff(path,chan).chanpat_updated(0)                           := chanpat_upd_in;
    end loop;
    ptrs(chan) := ptrs(chan) + 1;
  end procedure prc_push_main_buffer;
  
  -- Flush main buffer
  --   Used to flush the main buffer data following a pattern change, it keeps the most recent sample
  --   on every channel
  procedure prc_flush_main_buffer( variable ptrs      : inout t_pointers;
                                   variable main_buff : inout t_main_buffer_array) is
  begin
    for path in 0 to ci_num_paths-1 loop
      for chan in 0 to C_NUM_CHANNELS-1 loop
        main_buff(path,chan).data(ptrs(chan)+1 to ptrs(chan)+ci_fir_properties.full_taps-1) := (others=>(others=>0));
      end loop;
    end loop;
  end procedure prc_flush_main_buffer;
  
  -- Integer-based rounding function
  function rounding ( acc, accum_width, output_width, round_mode : integer
                    ) return integer is
  
    variable result       : integer := 0;
    variable midpoint     : boolean := false;
    constant half         : integer := 2**(get_max(0,(accum_width-output_width-1)));
    constant one          : integer := 2*half;
    variable decision_acc : integer := acc;
  begin
  
    --report "<ROUND> Accum              = " & integer'image(acc);
    --report "<ROUND> Accum/one          = " & integer'image(acc/one);
    --report "<ROUND> Accum/half         = " & integer'image(acc/half);
    --report "<ROUND> Accum/half rem 2   = " & integer'image((acc/half) rem 2);
    --report "<ROUND> (Accum+half)/one   = " & integer'image((acc+half)/one);
    case round_mode is
      when ci_full_precision      => result := acc;
      when ci_truncate_lsbs       => if ( acc < 0 ) then  result := (acc-one +1)/one ;
                                    else                 result := (acc       )/one ;
                                    end if;
      when ci_non_symmetric_down  => if ( acc < 0 ) then  result := (acc-half  )/one ;
                                    else                 result := (acc+half-1)/one ;
                                    end if;
      when ci_non_symmetric_up    => if ( acc < 0 ) then  result := (acc-half+1)/one ;
                                    else                 result := (acc+half  )/one ;
                                    end if;
      when ci_symmetric_zero      => if ( decision_acc < 0 ) then
                                      if ( acc < 0 ) then  result := (acc-half+1)/one ;
                                      else                 result := (acc+half  )/one ;
                                      end if;
                                    else
                                      if ( acc < 0 ) then  result := (acc-half  )/one ;
                                      else                 result := (acc+half-1)/one ;
                                      end if;
                                    end if;
      when ci_symmetric_inf       => if ( decision_acc < 0 ) then
                                      if ( acc < 0 ) then  result := (acc-half  )/one ;
                                      else                 result := (acc+half-1)/one ;
                                      end if;
                                    else
                                      if ( acc < 0 ) then  result := (acc-half+1)/one ;
                                      else                 result := (acc+half  )/one ;
                                      end if;
                                    end if;
      when ci_convergent_even     => midpoint := (acc mod one) = half;
                                    if ( acc < 0 ) then  result := (acc-half+1)/one ;
                                    else                 result := (acc+half  )/one ;
                                    end if;
                                    if midpoint and (result mod 2) = 1 then
                                      result := result-1;
                                    end if;
      when ci_convergent_odd      => midpoint := (acc mod one) = half;
                                    if ( acc < 0 ) then  result := (acc-half  )/one ;
                                    else                 result := (acc+half-1)/one ;
                                    end if;
                                    if midpoint and (result mod 2) = 0 then
                                      result := result+1;
                                    end if;
      when others                => report "WARNING: FIR Compiler: Unsupported rounding mode specified!" severity warning;
    end case;
    
    --report "<ROUND> Accum Rounded = " & integer'image(result);
    return result;
  
  end; -- round(integer)
  
  
  -- Unsigned rounding function
  function rounding ( acc : unsigned; 
                      accum_width, result_width, round_mode : integer
                    ) return unsigned is
  
    variable acc_temp     : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable result       : unsigned(result_width-1 downto 0) := (others=>'0');
    variable half         : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable one          : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable midpoint     : boolean := false;
    variable decision_acc : unsigned( accum_width-1 downto 0) := acc;
  begin
    
    if accum_width-result_width>0 then
      half(accum_width-result_width-1):='1';
      one (accum_width-result_width)  :='1';
    end if;
  
    --report "<ROUND> Accum         = " & int_to_string(to_integer(acc));
    case round_mode is
      when ci_full_precision      => result   := acc;
      when ci_truncate_lsbs       => result   := acc(accum_width-1 downto accum_width-result_width);
      when ci_non_symmetric_down  => acc_temp := acc + half - 1;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_non_symmetric_up    => acc_temp := acc + half ;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_symmetric_zero      => acc_temp := acc + half - 1;-- + fn_select_integer(0,1,decision_acc(accum_width-1)='1');
                                     -- when unsigned will always be a postive result. The core's MSB will never be set but
                                     -- in the model it is trimmmed to the minimum width but needs to be considered as +ve number
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_symmetric_inf       => acc_temp := acc + half - 1 + 1;-- fn_select_integer(0,1,decision_acc(accum_width-1)='0');
                                     -- As above when unsigned the cores MSB will always be 0. So in this rounding mode
                                     -- it will always generate the carry in
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_convergent_even     => midpoint := (acc mod one) = half;
                                    acc_temp := acc + half ;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
                                    if midpoint then
                                      result(0) := '0';
                                    end if;
      when ci_convergent_odd      => midpoint := (acc mod one) = half;
                                    acc_temp := acc + half -1;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
                                    if midpoint then
                                      result(0) := '1';
                                    end if;
      when others                => report "WARNING: FIR Compiler: Unsupported rounding mode specified!" severity warning;
    end case;
    
    --report "<ROUND> Rounded Accum = " & int_to_string(to_integer(result));
    return result;
    
  end; -- rounding(unsigned) 
  
  
  -- Signed rounding function
  function rounding ( acc : signed; 
                      accum_width, result_width, round_mode : integer
                    ) return signed is
  
    variable acc_temp     : signed( accum_width-1 downto 0) := acc;
    variable result       : signed(result_width-1 downto 0) := (others=>'0');
    variable half         : signed( accum_width-1 downto 0) := (others=>'0');
    variable one          : signed( accum_width-1 downto 0) := (others=>'0');
    variable midpoint     : boolean := false;
    variable decision_acc : signed( accum_width-1 downto 0) := acc;
  begin
    if accum_width-result_width>0 then
      half(accum_width-result_width-1):='1';
      one (accum_width-result_width)  :='1';
    end if;
  
    --report "<ROUND> Accum         = " & int_to_string(to_integer(acc));
    case round_mode is
      when ci_full_precision      => result   := acc_temp;
      when ci_truncate_lsbs       => result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_non_symmetric_down  => acc_temp := acc + half - 1;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_non_symmetric_up    => acc_temp := acc + half ;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_symmetric_zero      => acc_temp := acc + half - 1 + fn_select_integer(0,1,decision_acc(accum_width-1)='1');
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_symmetric_inf       => acc_temp := acc + half - 1 + fn_select_integer(0,1,decision_acc(accum_width-1)='0');
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
      when ci_convergent_even     => midpoint := (acc mod one) = half;
                                    acc_temp := acc + half ;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
                                    if midpoint then
                                      result(0) := '0';
                                    end if;
      when ci_convergent_odd      => midpoint := (acc mod one) = half;
                                    acc_temp := acc + half - 1 ;
                                    result   := acc_temp(accum_width-1 downto accum_width-result_width);
                                    if midpoint then
                                      result(0) := '1';
                                    end if;
      when others                => report "WARNING: FIR Compiler: Unsupported rounding mode specified!" severity warning;
    end case;
    
    --report "<ROUND> Rounded Accum = " & int_to_string(to_integer(result));
    return result;
  
  end; -- rounding(signed)
  
  -------------------------------------------------------------------------------
  -- BASIC FIR FUNCTION WITH INTEGER OUTPUT
  -- Used when result width is representable as an integer
  -------------------------------------------------------------------------------
  function fir ( c            : t_coefficients;
                 d            : t_regressor;
                 dpage        : integer;
                 taps,
                 zpf          : integer;
                 round        : boolean:=false
               ) return integer is
  
    variable acc         : integer := 0;
    variable temp        : integer := 0;
  begin
  
    for i in 0 to (taps-1) loop
      acc := acc + d(i*zpf)(dpage) * c(i); -- taps-1-  data vector now shifted in different direction
    end loop;
  
    if round then
      -- report "FIR MODEL: last accum input: "&integer'image(acc_last_ip);
      temp := rounding ( acc, ci_accum_width, C_OUTPUT_WIDTH, C_ROUND_MODE );
      -- report "FIR MODEL: final rounded output: "&integer'image(temp);
      return temp;
    else
      return acc;
    end if;
  
  end; -- fir 
  
  
  -------------------------------------------------------------------------------
  -- FIR FUNCTION WITH UNSIGNED OUTPUT & OVERFLOW
  -- Used when result width is larger than maximum representable integer width
  -- A positive overflow integer is used to track the total value
  -------------------------------------------------------------------------------
  function fir_ovfl_unsigned ( c            : t_coefficients;
                               d            : t_regressor;
                               dpage        : integer;
                               taps,
                               zpf,
                               accum_width : integer
                             ) return unsigned is
               
    variable inc      : natural  := 0;
    variable acc      : natural  := 0;
    variable acc_ovfl : natural  := 0;
    variable result   : unsigned(accum_width-1 downto 0) := (others=>'0');
  
  begin
  
    --report "ACCUM_WIDTH = " & integer'image(accum_width);
    --report "SHIFT_BY     = " & integer'image(shift_by);
    for i in 0 to (taps-1) loop

      inc := d(i*zpf)(dpage) * c(i); -- taps-1-  data vector now shifted in different direction

      if inc>(ci_maxint-acc) then   -- OVERFLOW
        acc      := acc+inc-(ci_maxint+1);
        acc_ovfl := acc_ovfl+1;
        --report "Accumulator Overflow!!!   acc_ovfl = " & int_to_string(acc_ovfl);

      else                       -- NORMAL ACC
        acc := acc+inc;
      end if;

    end loop;
  
    result((ci_max_int_width-1)-1 downto 0)           := to_unsigned(acc, (ci_max_int_width-1));
    result(accum_width-1 downto (ci_max_int_width-1)) := to_unsigned(acc_ovfl, accum_width-(ci_max_int_width-1));
  
    return result;
  
  end; -- fir_ovfl_unsigned
  
  
  -------------------------------------------------------------------------------
  -- FIR FUNCTION WITH SIGNED OUTPUT & OVERFLOW & UNDERFLOW
  -- Used when result width is larger than maximum representable integer width
  -- A signed overflow/underflow integer is used to track the total value
  -------------------------------------------------------------------------------
  function fir_ovfl_signed ( c            : t_coefficients;
                             d            : t_regressor;
                             dpage        : integer;
                             taps,
                             zpf,
                             accum_width : integer
                           ) return signed is
  
    variable inc      : integer  := 0;
    variable acc      : natural := 0;
    variable acc_ovfl : integer  := 0;
    variable result   : signed(accum_width-1 downto 0) := (others=>'0');
  
  begin
    
    --report "ACCUM_WIDTH = " & integer'image(accum_width);
    for i in 0 to (taps-1) loop
      --report "Data  = " & integer'image(d(i*zpf));
      --report "Coeff = " & integer'image(c(taps-1-i));
      inc  := d(i*zpf)(dpage) * c(i); -- taps-1-  data vector now shifted in different direction
      --report "PP    = " & integer'image(inc);
  
      if inc>(ci_maxint-acc) then   -- OVERFLOW
        acc      := acc+inc-(ci_maxint+1);
        acc_ovfl := acc_ovfl+1;
        -- report "Positive Overflow!!!   acc_ovfl = " & int_to_string(acc_ovfl);
  
      elsif (acc+inc)<0 then     -- UNDERFLOW
        acc      := acc+inc+(ci_maxint+1);
        acc_ovfl := acc_ovfl-1;
        -- report "Negative overflow!!!   acc_ovfl = " & int_to_string(acc_ovfl);
  
      else                       -- NORMAL ACC
        acc := acc+inc;
      end if;
  
    end loop;
  
    --report "Acc    = " & integer'image(acc);
    --report "ResW   = " & integer'image(result_width);
    --report "Shift  = " & integer'image(shift_by);
  
      result((ci_max_int_width-1)-1 downto 0)           := signed(to_unsigned(acc, (ci_max_int_width-1)));
      result(accum_width-1 downto (ci_max_int_width-1)) := to_signed(acc_ovfl, accum_width-(ci_max_int_width-1));
  
    return result;
  
  end; -- fir_ovfl_signed
  
  
  -------------------------------------------------------------------------------
  -- FIR FUNCTION WITH UNSIGNED OUTPUT & SPLIT COEFFICIENTS
  -- Used to wrap the fir or overflow fir functions.  Produces interim results from
  -- each of the coefficient pages and then adds these results in a weighted
  -- manner (as std_logic_vectors) such that the overall result is correct.
  -------------------------------------------------------------------------------
  function split_fir_unsigned ( c            : t_coeff_pages;
                                d            : t_regressor;
                                -- dpages,
                                -- cpages,
                                taps,
                                zpf,
                                coef_width,
                                -- split_cwidth,
                                -- split_dwidth,
                                accum_width,
                                result_width : integer;
                                round : boolean := false
                              ) return unsigned is
    
    variable inc1         : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable inc2         : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable acc          : unsigned( accum_width-1 downto 0) := (others=>'0');
    variable result       : unsigned(result_width-1 downto 0) := (others=>'0');
    variable read_width   : integer := ci_split_cwidth;
    variable remaining    : integer := coef_width;
    variable d_weighting  : integer:=0;
  begin
  
    for j in 0 to ci_dpages-1 loop
      read_width := ci_split_cwidth;
      remaining  := coef_width;
      for i in 0 to ci_cpages-1 loop
        --report "Calculating Split " & integer'image(i);
        read_width := get_min(ci_split_cwidth,remaining);
        --report "Shifting left by " & integer'image(coef_width-remaining) & " places.";
        if (accum_width>coef_width-remaining+ci_max_int_width-(ci_data_sign*ci_coef_sign)) then
          --report "Running split overflow unsigned FIR";
          inc1 := fir_ovfl_unsigned ( c(i), d, j, taps, zpf, accum_width); 
          inc2 := (others=>'0');
          inc2(accum_width-1 downto coef_width-remaining) := inc1(accum_width-1-(coef_width-remaining) downto 0) ;
          inc2(accum_width-1 downto d_weighting):=inc2(accum_width-1-d_weighting downto 0);
          inc2(d_weighting-1 downto 0):=(others=>'0');
        else
          --report "Running split integer unsigned FIR";
          inc1 := to_unsigned( fir( c(i), d, j, taps, zpf, false) , accum_width );
          inc2 := (others=>'0');
          inc2(accum_width-1 downto coef_width-remaining) := inc1(accum_width-1-(coef_width-remaining) downto 0) ;
          inc2(accum_width-1 downto d_weighting):=inc2(accum_width-1-d_weighting downto 0);
          inc2(d_weighting-1 downto 0):=(others=>'0');
        end if;
  --       report "Unshifted partial result for page " & integer'image(i) & " === " & slv_to_string(std_logic_vector(inc1),accum_width);
  --       report "  Shifted partial result for page " & integer'image(i) & " === " & slv_to_string(std_logic_vector(inc2),accum_width);
        acc := acc + inc2;
  --       report "Accumulated result                " & " "              & " === " & slv_to_string(std_logic_vector(acc),accum_width);
        remaining := remaining - read_width;
      end loop;
      d_weighting:=d_weighting+ci_split_dwidth;
    end loop;
  
    if round then
      result := rounding ( acc, accum_width, result_width, C_ROUND_MODE);
    else
      result := acc;
    end if;
    --report "Rounded result          " & " "              & " === " & UTILS_PKG_slv_to_string(std_logic_vector(result),result_width);
    
    return result;
  
  end; -- split_fir_unsigned 
  
  
  -------------------------------------------------------------------------------
  -- FIR FUNCTION WITH SIGNED OUTPUT & SPLIT COEFFICIENTS
  -- Used to wrap the fir or overflow fir functions.  Produces interim results from
  -- each of the coefficient pages and then adds these results in a weighted
  -- manner (as std_logic_vectors) such that the overall result is correct.
  -------------------------------------------------------------------------------
  function split_fir_signed ( c            : t_coeff_pages;
                              d            : t_regressor;
                              -- dpages,
                              -- cpages,
                              taps,
                              zpf,
                              coef_width,
                              -- split_cwidth,
                              -- split_dwidth,
                              accum_width,
                              result_width : integer;
                              round : boolean := false
                            ) return signed is
    
    variable inc1         : signed( accum_width-1 downto 0) := (others=>'0');
    variable inc2         : signed( accum_width-1 downto 0) := (others=>'0');
    variable acc          : signed( accum_width-1 downto 0) := (others=>'0');
    variable result       : signed(result_width-1 downto 0) := (others=>'0');
    variable read_width   : integer := ci_split_cwidth;
    variable remaining    : integer := coef_width;
    variable d_weighting  : integer:=0;
  begin
  
    for j in 0 to ci_dpages-1 loop
      read_width := ci_split_cwidth;
      remaining  := coef_width;
      for i in 0 to ci_cpages-1 loop
        --report "Calculating Split " & integer'image(i);
        read_width := get_min(ci_split_cwidth,remaining);
        --report "Shifting left by " & integer'image(coef_width-remaining) & " places.";
        if (accum_width>coef_width-remaining+ci_max_int_width-(ci_data_sign*ci_coef_sign)) then
  --         report "Running split overflow signed FIR";
          inc1 := fir_ovfl_signed ( c(i), d, j, taps, zpf, accum_width); 
          inc2 := (others=>'0');
          inc2(accum_width-1 downto coef_width-remaining) := inc1(accum_width-1-(coef_width-remaining) downto 0) ;
          inc2(accum_width-1 downto d_weighting):=inc2(accum_width-1-d_weighting downto 0);
          inc2(d_weighting-1 downto 0):=(others=>'0');
        else
  --         report "Running split integer signed FIR";
          inc1 := to_signed( fir( c(i), d, j, taps, zpf, false) , accum_width ); 
          inc2 := (others=>'0');
          inc2(accum_width-1 downto coef_width-remaining) := inc1(accum_width-1-(coef_width-remaining) downto 0) ;
          inc2(accum_width-1 downto d_weighting):=inc2(accum_width-1-d_weighting downto 0);
          inc2(d_weighting-1 downto 0):=(others=>'0');
        end if;
  --       report "Unshifted partial result for page " & integer'image(i) & " === " & slv_to_string(std_logic_vector(inc1),accum_width);
  --       report "  Shifted partial result for page " & integer'image(i) & " === " & slv_to_string(std_logic_vector(inc2),accum_width);
  --       report "Data weighting: "&int_to_str(d_weighting);
        acc := acc + inc2;
  --       report "Accumulated result                " & " "              & " === " & slv_to_string(std_logic_vector(acc),accum_width);
        remaining := remaining - read_width;
      end loop;
      d_weighting:=d_weighting+ci_split_dwidth;
    end loop;
  
    if round then
      result := rounding ( acc, accum_width, result_width, C_ROUND_MODE); 
    else
      result := acc;
    end if;
    --report "Rounded result          " & " "              & " === " & UTILS_PKG_slv_to_string(std_logic_vector(result),result_width);
  
    return result;
  
  end; -- split_fir_signed 
  
  function fir_select ( c            : t_coeff_pages;
                        d            : t_regressor;
                        taps,
                        zpf,
                        coef_width,
                        accum_width,
                        result_width : integer--;
                        -- round : boolean := false
                        ) return std_logic_vector is
   -- variable result : t_result_paths;
   -- variable result : std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);
  begin
    -- for path in 0 to ci_paths loop
      if not ci_split_accum and not ci_signed_output then
        return std_logic_vector(
                to_unsigned (
                  fir (
                    c(0),
                    d,
                    0,
                    taps,
                    zpf,
                    true),
                  result_width));
      elsif not ci_split_accum and ci_signed_output then
        return std_logic_vector(
                  to_signed (
                    fir (
                      c(0),
                      d,
                      0,
                      taps,
                      zpf,
                      true),
                    result_width));
      elsif ci_split_accum and not ci_signed_output then
        return std_logic_vector(
                  split_fir_unsigned(
                    c,
                    d,
                    taps,
                    zpf,
                    coef_width,
                    accum_width,
                    result_width,
                    true)); 
      elsif ci_split_accum and ci_signed_output then
        return  std_logic_vector(
                  split_fir_signed(
                    c,
                    d,
                    taps,
                    zpf,
                    coef_width,
                    accum_width,
                    result_width,
                    true));
      else
        report "FIR Compiler ERROR" severity failure;
        return "0";
      end if;
    -- end loop;
    -- return result;
  end function;
  
  -------------------------------------------------------------------------------
  -- Read in the MIF file
  --   Has been complicated in v6.0. The core no longer re-orders a flat mif file
  --   but the GUI generates a re-ordered mif file. But it does now contain the coefficient
  --   index so they can be re-ordered back to the original set.
  -------------------------------------------------------------------------------
  
  type t_reorder_info is  -- taken from v5.0 shared functions but now only needed here
  record
    combination : integer;
    index_1     : integer;
    index_2     : integer;
  end record;
  
  type t_reorder_info_array  is array (integer range <>) of t_reorder_info;
  
  constant ci_mif_num_filts : integer := fn_select_integer(
                                            C_NUM_FILTS,
                                            C_NUM_FILTS + C_NUM_RELOAD_SLOTS,
                                            C_COEF_RELOAD = 1);
  
  type t_mif_contents is
  record
    reorder_info : t_reorder_info_array(0 to ci_fir_properties.reload_taps-1);
    coeffs       : t_coeffs_array(0 to (ci_mif_num_filts * ci_fir_properties.reload_taps)-1);
    num_paths    : integer;
    coeff_cnt    : integer;
  end record;
  
  procedure prc_read_helper(line_in,line_out: inout line) is
    variable read_char : character;
    variable ignore_white_space : boolean := true;
  begin
    
    ignore_white_space := true;
    
    readchars : loop
      read(line_in,read_char);
      if read_char /= ' ' then --and read_char /= LF and read_char /= CR  then
        ignore_white_space := false;
        write(line_out,read_char);
      elsif not ignore_white_space then
        exit readchars;
      end if;
      if line_in'LENGTH = 0 then
        exit readchars;
      end if;
    end loop;
  end procedure;
  
  procedure prc_clr_line(line_in : inout line) is
    variable read_char : character;
  begin
    -- Clear the line_in for the benifit of isim
    if line_in'LENGTH > 0 then
      loop
        read(line_in,read_char);
        if line_in'LENGTH=0 then
          exit;
        end if;
      end loop;
    end if;
  end procedure;
  
  impure function fn_read_mif_file return t_mif_contents is
    constant read_width   : integer := 32;
    -- Read width is fixed by tcl behavour always printing neg number to the full precision, this can vary depending on platform but the GUI will always try to print to 32-bits
    variable coefficient  : std_logic_vector(read_width-1 downto 0);
    file     filepointer  : text;
    variable filestatus   : file_open_status;
    variable fileline     : line;
    variable linecnt,
             path,
             madd,
             filter,
             madd_i,
             coeff_i: integer :=0;
    variable mif_contents : t_mif_contents;
    variable read_line        : line;
  begin
    mif_contents.coeffs     :=(others=>(others=>'0'));
    mif_contents.num_paths  := 1;
    mif_contents.coeff_cnt  := 0;
    
    file_open(filestatus,filepointer,C_ELABORATION_DIR&C_COEF_FILE,read_mode);
    
    while not(endfile(filepointer)) and linecnt<C_COEF_FILE_LINES loop
      readline(filepointer, fileline);
      -- --Fetch coefficient
      -- hread(fileline, coefficient);
      -- --Fetch path number
      -- read(fileline, path);
      -- --Fetch madd unit number
      -- read(fileline, madd);
      -- --Fetch filter set
      -- read(fileline, filter);
      
      -- ISIM work around
      --Fetch coefficient
      prc_read_helper(fileline,read_line);
      hread(read_line, coefficient);
      prc_clr_line(read_line);
      
      --Fetch path number
      prc_read_helper(fileline,read_line);
      read(read_line, path);
      prc_clr_line(read_line);
      
      --Fetch madd unit number
      prc_read_helper(fileline,read_line);
      read(read_line, madd);
      prc_clr_line(read_line);
      
      --Fetch filter set
      prc_read_helper(fileline,read_line);
      read(read_line, filter);
      prc_clr_line(read_line);
      
      -- Generate index where to store data read in. The mif file order needs to be reversed to replicate the reload order
      -- this is so do_coeff_reorder can be re-used 
      if madd = -1 then
        -- Centre tap, not associated with a madd, goes on the end.
        coeff_i:=(filter*ci_fir_properties.reload_taps) + ((C_NUM_MADDS)*ci_fir_properties.madd_mem_depth)+madd_i;
      else
        if ci_fir_properties.flip_reload_order then
          -- Special case, order not flipped. See properties type defintion
          coeff_i:=(filter*ci_fir_properties.reload_taps) + ((madd)*ci_fir_properties.madd_mem_depth)+madd_i;
        else
          -- Normal implementation, indexes order flipped
          coeff_i:=(filter*ci_fir_properties.reload_taps) + ((C_NUM_MADDS-madd-1)*ci_fir_properties.madd_mem_depth)+madd_i;
        end if;
      end if;
      
      -- report ":"&integer'image(path)&":"&integer'image(madd)&":"&integer'image(filter)&":"&integer'image(coeff_i);
      
      --Populate reorder info
      if path = 0 and filter = 0 then
        -- mif_contents.reorder_info(madd_i).filter:=filter;
        -- --Fetch combination method
        -- read(fileline, mif_contents.reorder_info(coeff_i).combination);
        -- --Fetch index 1
        -- read(fileline, mif_contents.reorder_info(coeff_i).index_1);
        -- --Fetch index 2
        -- read(fileline, mif_contents.reorder_info(coeff_i).index_2);
        
        -- ISIM work around
        --Fetch combination method
        prc_read_helper(fileline,read_line);
        read(read_line, mif_contents.reorder_info(coeff_i).combination);
        prc_clr_line(read_line);
        --Fetch index 1
        prc_read_helper(fileline,read_line);
        read(read_line,  mif_contents.reorder_info(coeff_i).index_1);
        prc_clr_line(read_line);
        --Fetch index 2
        prc_read_helper(fileline,read_line);
        read(read_line, mif_contents.reorder_info(coeff_i).index_2);
        prc_clr_line(read_line);
        
        mif_contents.coeff_cnt := mif_contents.coeff_cnt + 1;
      end if;
      
      --Avoid incrementing when pad space
      if path /= -1 then
        madd_i := ( madd_i + 1 ) mod ci_fir_properties.madd_mem_depth;
        
        if madd = -1 then
          -- Special case that means need to skip centre tap when moving onto next path
          madd_i := 0;
        end if;
      end if;
      linecnt := linecnt + 1;
      
      -- --Populate data into coeff array.
      if path > 0 then
        -- only support 2 path implementation just now
        -- report "fn_read_mif_file: path: "&integer'image(path)&" coeff width: "&integer'image(ci_coef_path_widths(get_min(ci_num_paths-1,1)));
        mif_contents.num_paths  := 2;
        -- mif_contents.coeffs(coeff_i)(ci_coef_path_widths(0)+ci_coef_path_widths(get_min(ci_num_paths-1,1))-1 downto ci_coef_path_widths(0)) := coefficient(ci_coef_path_widths(get_min(ci_num_paths-1,1))-1 downto 0);
        mif_contents.coeffs(coeff_i)(ci_coef_path_widths(0)+ci_coef_path_widths(path)-1 downto ci_coef_path_widths(0)) := coefficient(ci_coef_path_widths(path)-1 downto 0);
      elsif path = 0 then
        -- report "fn_read_mif_file: path: "&integer'image(path);
        mif_contents.coeffs(coeff_i)(ci_coef_path_widths(0)-1 downto 0) := coefficient(ci_coef_path_widths(0)-1 downto 0);
      end if;
    end loop;
    return mif_contents;
  end fn_read_mif_file;
  
  constant mif_contents : t_mif_contents := fn_read_mif_file;
  
  -------------------------------------------------------------------------------
  -- Reorder the reloaded coefficients according to the reload order property
  -- Reload coefficients are put into their appropriate locations and then
  -- symmetry is restored.
  -------------------------------------------------------------------------------
  function do_coeff_reorder ( reloaded : t_reload_coeffs ) return t_coeff_pages is
  
    variable coeffs   : t_coefficients_slv:= (others=>(others=>'0'));
  
    type t_coefficients_slv_paths is array (0 to mif_contents.num_paths-1) of t_coefficients_slv;
    variable coeffs_paths   : t_coefficients_slv_paths := (others=>(others=>(others=>'0')));
    
    constant inter_sym_shift : integer:=fn_select_integer(0,C_INTERP_RATE/2,
                                                        C_FILTER_TYPE=ci_polyphase_interpolation and C_SYMMETRY /= ci_non_symmetric
                                                        and ci_fir_properties.odd_symmetry=1
                                                        and (C_INTERP_RATE rem 2 >0));
                                                        
    constant full_taps_adjusted : integer := ci_fir_properties.full_taps-2*inter_sym_shift;
    -- ci_fir_properties.full_taps as already been adjusted
    
    variable path_coef: signed(ci_coef_width_physical-1 downto 0);
    
    variable ret_coeffs : t_coeff_pages := (others=>(others=>0));
    
    variable upper_src : integer;
  begin
  
    for i in 0 to ci_fir_properties.reload_taps-1 loop  -- mif_contents.coeff_cnt - 1 loop --need to use this for when taps have been optimized
  
      if C_FILTER_TYPE=ci_polyphase_interpolation and C_SYMMETRY /= ci_non_symmetric and
         not (C_INTERP_RATE=2 and ci_fir_properties.odd_symmetry=1) then
        if mif_contents.reorder_info(i).index_1 > -1 then
          if mif_contents.num_paths=1 then
            coeffs(mif_contents.reorder_info(i).index_1) := std_logic_vector(signed(coeffs(mif_contents.reorder_info(i).index_1)) + signed(reloaded(i)));
            if mif_contents.reorder_info(i).combination=1 then
              coeffs(mif_contents.reorder_info(i).index_2) := std_logic_vector(signed(coeffs(mif_contents.reorder_info(i).index_2)) + signed(reloaded(i)));
            elsif mif_contents.reorder_info(i).combination=2 then
              coeffs(mif_contents.reorder_info(i).index_2) := std_logic_vector(signed(coeffs(mif_contents.reorder_info(i).index_2)) - signed(reloaded(i)));
            else -- unpaired self-symmetric central phase when P is odd
              -- Double up centre phase so that we can just half everything at the end
              coeffs(mif_contents.reorder_info(i).index_1) := std_logic_vector(signed(coeffs(mif_contents.reorder_info(i).index_1)) + signed(reloaded(i)));
            end if;
            -- report "do_coeff_reorder: reload_tap: "&integer'image(i)&
                   -- " i1: "&integer'image(mif_contents.reorder_info(i).index_1)&
                   -- " val: "&integer'image(to_integer(signed(coeffs(mif_contents.reorder_info(i).index_1))))&
                   -- " i2: "&integer'image(mif_contents.reorder_info(i).index_2)&
                   -- " val: "&integer'image(to_integer(signed(coeffs(mif_contents.reorder_info(i).index_2))));
          else
            for path in 0 to 1 loop --mif_contents.num_paths-1 loop
              if path=0 then
                path_coef:=signed(fn_ext_bus(reloaded(i)(ci_coef_path_widths(0)-1 downto 0),ci_coef_width_physical,c_signed));
              else
                path_coef:=signed(fn_ext_bus(reloaded(i)(fn_sum_vals(ci_coef_path_widths(path downto 0))-1 downto fn_sum_vals(ci_coef_path_widths(path-1 downto 0))),ci_coef_width_physical,c_signed));
              end if;
              --Keep the different path results seperate then concat together after
              coeffs_paths(path)(mif_contents.reorder_info(i).index_1) := std_logic_vector(signed(coeffs_paths(path)(mif_contents.reorder_info(i).index_1)) + path_coef);
              if mif_contents.reorder_info(i).combination=1 then
                coeffs_paths(path)(mif_contents.reorder_info(i).index_2) := std_logic_vector(signed(coeffs_paths(path)(mif_contents.reorder_info(i).index_2)) + path_coef);--reloaded(i);
              elsif mif_contents.reorder_info(i).combination=2 then
                coeffs_paths(path)(mif_contents.reorder_info(i).index_2) := std_logic_vector(signed(coeffs_paths(path)(mif_contents.reorder_info(i).index_2)) - path_coef);--reloaded(i);
              else -- unpaired self-symmetric central phase when P is odd
                -- Double up centre phase so that we can just half everything at the end
                coeffs_paths(path)(mif_contents.reorder_info(i).index_1) := std_logic_vector(signed(coeffs_paths(path)(mif_contents.reorder_info(i).index_1)) + path_coef);--reloaded(i);
              end if;
            end loop;
          end if;
        end if;
      else
        if mif_contents.reorder_info(i).index_1 > -1 then
          -- if optimized taps then the index of some will be set to a default value, in modelsim its always max neg
          coeffs(mif_contents.reorder_info(i).index_1) := std_logic_vector(unsigned(coeffs(mif_contents.reorder_info(i).index_1)) + unsigned(reloaded(i)));
        end if;
      end if;
    end loop;
  
    -- For interpolating symmetry, we finally divide the coefficient set by 2
    if C_FILTER_TYPE=ci_polyphase_interpolation and C_SYMMETRY /= ci_non_symmetric and
       not (C_INTERP_RATE=2 and ci_fir_properties.odd_symmetry=1) then
      if mif_contents.num_paths=1 then
        for i in 0 to ci_fir_properties.reload_taps-1 loop
          -- coeffs(i) := coeffs(i)(ci_coef_width_physical-1)&coeffs(i)(ci_coef_width_physical-1 downto 1);--div by 2
          
          if ci_coef_sign = ci_signed then
            coeffs(i) := std_logic_vector(resize(signed(coeffs(i)(ci_coef_width_physical-1 downto 1)),ci_coef_width_physical));
          else
            coeffs(i) := std_logic_vector(resize(unsigned(coeffs(i)(ci_coef_width_physical-1 downto 1)),ci_coef_width_physical));
          end if;
          
          -- report "do_coeff_reorder: div by 2";
          -- report "do_coeff_reorder: reload_tap: "&integer'image(i)&
                   -- " val: "&integer'image(to_integer(signed(coeffs(i))));
          
        end loop;
      else
  
        for i in 0 to ci_fir_properties.reload_taps-1 loop
          -- Previous passed via the reorder structure but not really necessary, always 2-bits less than full width
          upper_src := ci_coef_path_widths(0) - 2;
          -- upper_src := ci_coef_path_widths(0) - 1; -- ci_coef_path_widths only includes sym pair bit not unsigned bit as well
          
          --assume only two paths
          --Combine paths and div by 2
          
          coeffs(i)(upper_src-1 downto 0):=coeffs_paths(0)(i)(upper_src downto 1);
          
          coeffs(i)(C_COEF_WIDTH-1 downto upper_src):=--coeffs_paths(1)(i)(C_COEF_WIDTH-upper_src)& --extend by 1 bit
                                                      coeffs_paths(1)(i)(C_COEF_WIDTH-upper_src downto 1);
          if ci_coef_sign = ci_signed then
            coeffs(i)(ci_coef_width_physical-1 downto C_COEF_WIDTH) := (others=>coeffs(i)(C_COEF_WIDTH-1));
          else
            coeffs(i)(ci_coef_width_physical-1 downto C_COEF_WIDTH) := (others=>'0');
          end if;
        end loop;
  
      end if;
    end if;
    
    -- Restore symmetric half of filter response, which will not have been
    -- filled out by the above operation, other than a few around the centre tap
    -- in the case of interpolating symmetric filters.
    -- This should work for all filter types, as zero locations should also be
    -- echoes - it might be possible to reduce the number of operations for such
    -- filter responses, at the expense of additional complexity.
    if C_SYMMETRY/=ci_non_symmetric then
      for i in 1 to (full_taps_adjusted)/2 loop
        if C_SYMMETRY=ci_neg_symmetric then
          coeffs(full_taps_adjusted-i) := std_logic_vector( signed(not(coeffs(i-1)))+1 );
        else
          coeffs(full_taps_adjusted-i) := coeffs(i-1);
        end if;
      end loop;
    end if;
    -- if C_SYMMETRY/=ci_non_symmetric then
      -- for i in 1 to (ci_fir_properties.full_taps)/2 loop
        -- if C_SYMMETRY=ci_neg_symmetric then
          -- coeffs(ci_fir_properties.full_taps-i) := std_logic_vector( signed(not(coeffs(i-1)))+1 );
        -- else
          -- coeffs(ci_fir_properties.full_taps-i) := coeffs(i-1);
        -- end if;
      -- end loop;
    -- end if;
    
    -- Convert slv input into split integer representation. Was previously done using the split_reload_coeff function but
    -- now merged into this function.
    for tap in coeffs'range loop
      for k in 0 to ci_cpages-1 loop
        if k=ci_cpages-1 then
          if ci_coef_sign=ci_signed then
            ret_coeffs(k)(tap) := to_integer(signed(coeffs(tap)( get_min(((k+1)*ci_split_cwidth)-1,coeffs(tap)'HIGH) downto (k*ci_split_cwidth) )));
          else
            ret_coeffs(k)(tap) := to_integer(unsigned(coeffs(tap)( get_min(((k+1)*ci_split_cwidth)-1,coeffs(tap)'HIGH) downto (k*ci_split_cwidth) )));
          end if;
        else
          ret_coeffs(k)(tap) := to_integer(unsigned(coeffs(tap)( ((k+1)*ci_split_cwidth)-1 downto (k*ci_split_cwidth) )));
        end if;
      end loop;
    end loop;
    
    return ret_coeffs;
    
  end do_coeff_reorder;
  
  -------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------
  function fn_get_coefficients return t_coeff_array is
    variable reordered_coeffs : t_coeff_array := (others=>(others=>(others=>0)));
  begin
    if false then
      -- Channelizer re-ordering here?!
    else
      for filt in 0 to C_NUM_FILTS-1 loop
        reordered_coeffs(filt):=do_coeff_reorder(mif_contents.coeffs( filt * ci_fir_properties.reload_taps to ((filt+1) * ci_fir_properties.reload_taps) - 1 ));
      end loop;
    end if;
    return reordered_coeffs;
  end fn_get_coefficients;
  
  -------------------------------------------------------------------------------
  -- Coefficient declaration
  --   Signal rather than constant so reload can update values
  -------------------------------------------------------------------------------
  signal coeff_sets : t_coeff_array := fn_get_coefficients;
  
  -------------------------------------------------------------------------------
  -- Signals     ----------------------------------------------------------------
  
  signal clk,
         ce_int,
         ce_px,
         sclr_int,
         areset  : std_logic;
  
  -- I/P buffer
  signal ipbuff             : t_buffer(ci_fir_properties.ipbuff_size-1 downto 0) := (others=>(others=>'0'));
  signal ipbuff_out         : std_logic_vector(s_s_tlast'HIGH downto 0);
  signal ipbuff_ptr         : integer := fn_select_integer(-1,0,ci_fir_properties.ipbuff_custom);
  signal ipbuff_read_addr,
         ipbuff_write_addr  : integer := 0;
  signal ipbuff_ready,
         ipbuff_flag,
         ipbuff_read,
         ipbuff_page_read   : boolean   := false;
  signal ipbuff_full        : std_logic := '0';
  -- signal s_data_tready      : std_logic := '1';
  -- signal s_data_tready      : std_logic := '0'; -- AXI fifo transistions high on first cycle
  signal s_data_tready      : std_logic := fn_select_sl('0','1',ci_fir_properties.ipbuff_custom);
  signal ip_write           : boolean   := false;
  signal ipbuff_in          : std_logic_vector(s_s_tlast'HIGH downto 0);
         
  -- PX block
  signal ip_px_rdy          : boolean := true;
  signal ip_px_cnt,
         ip_chan_cnt,
         ip_phase_cnt,
         op_px_cnt,
         op_chan_cnt,
         op_phase_cnt,
         output_chan_pat,
         new_samples_for_op,
         new_samples_for_next_op
         : integer := 0;
  signal cascade_dly        : t_cascade_dly := (others=>(result=>(others=>(others=>'0')),
                                                         tuser=>(others=>'0'),
                                                         tlast=>'0',
                                                         chan_id=>0,
                                                         valid=>false));
  signal --gen_op,
         ip_px_cnt_en,
         --push_buffer,
         ip_px_cnt_max,
         op_px_cnt_max,
         op_px_cnt_en,
         get_new_data,
         -- get_new_data_2ndphase 
         get_fifo_data,
         ip_px_cnt_max_actual
         : boolean := false;
         
  -- O/P buffer
  signal opbuff             : t_buffer(ci_fir_properties.opbuff_size-1 downto 0) := (others=>(others=>'0'));
  signal opbuff_out         : std_logic_vector(s_m_tlast'HIGH downto 0):=(others=>'0');
  signal opbuff_ptr         : integer := -1;
  signal opbuff_rdy,
         opbuff_flag: boolean := false;
  signal back_throttle,
         m_data_tvalid      : std_logic := '0';
         
  -- Configuration and Reload interface
  signal cnfgbuff           : t_buffer(get_max(32,2**log2roundup(
                                                       fn_select_integer(
                                                         1,
                                                         C_NUM_CHANNELS,
                                                         C_CONFIG_PACKET_SIZE=ci_chan_cnfg)))-1 downto 0) := (others=>(others=>'0'));
  signal cnfgbuff_out,
         cnfgbuff_in        : std_logic_vector(s_chanpat'HIGH+1 downto 0);
  signal cnfgbuff_ptr       : integer := -1;
  signal cnfgbuff_ready,
         cnfgbuff_flag,
         cnfgbuff_read,
         cnfgbuff_read_dly,
         cnfgbuff_write     : boolean := false;    
  signal cnfgbuff_full      : std_logic := '0';
  signal s_cnfg_tready      : std_logic := '0'; -- AXI fifo starts low
  signal s_reload_tready    : std_logic := '1';
  signal --update_cnfg,
         updating_cnfg,
         next_cnfg,
         next_cnfg_dly,
         update_cnfg_first,
         update_cnfg_first_dly,
         check_tlast,
         tlast_ored,
         next_chan,
         next_chan_dly
                            : boolean := false;
  signal update_cnfg        : boolean := C_FILTER_TYPE=ci_polyphase_decimation;
  signal packet_end         : boolean := false;
  signal update_chan,
         update_chan_dly    : integer := 0;
  signal fsel               : integer := 0;
  signal get_reload_filt    : boolean := (C_NUM_FILTS > 1);
  signal update_fsel,
         update_fsel_dly    : boolean := false;
  signal rlded_filt,
         rlded_filt_slot    : t_int_array(C_NUM_RELOAD_SLOTS-1 downto 0) := (others=>0);
  signal rlded_cnt          : integer := -1;
  signal updated_fsel,
         updated_fsel_slot,
         freed_slot         : integer := 0;
  signal chanpat            : integer := 0;
  signal chanpat_updated    : boolean := false;
begin
  
  clk <= ACLK;
  ce_int <= ACLKEN when C_HAS_ACLKEN = 1 else '1';
  ce_px  <=  not back_throttle and ACLKEN when C_HAS_ACLKEN=1 and C_M_DATA_HAS_TREADY = 1 else
             not back_throttle when C_M_DATA_HAS_TREADY = 1 else
             ACLKEN  when C_HAS_ACLKEN=1 else '1';
  -- sclr_int <= not ARESETn when C_HAS_ARESETn = 1 else '0';
  areset <= not ARESETn when C_HAS_ARESETn = 1 else '0';
  
  g_sclr : if C_HAS_ARESETn=1 generate
    signal reset_history : std_logic_vector(2 downto 0) := (others => '0');
  begin
    i_sclr: process(CLK)
    begin
      if (rising_edge(CLK)) then
        sclr_int<= not ARESETn;
      end if;
    end process;
    -- Below nabbed from DDS v5.0
    check_reset: process (aclk) is
    begin
      if rising_edge(aclk) then
        reset_history <= reset_history(1 downto 0) & ARESETn;
        assert not(reset_history = "010" or reset_history = "101")
          report "WARNING: aresetn must be asserted or deasserted for a minimum of 2 cycles"
          severity warning;
      end if;
    end process check_reset;
  end generate g_sclr;
  
  g_no_sclr : if C_HAS_ARESETn/=1 generate
    sclr_int<= '0';
  end generate g_no_sclr;
  
  -- I/P buffer --------------------------------------------------------------------------------------------------------
  i_ipbuff : process(clk)
    variable v_write,
             v_read,
             v_writing_2nd_page: boolean := false;
    variable v_ipbuff_in : std_logic_vector(s_s_tlast'HIGH downto 0);
    variable v_phase     : integer:=0;
    variable v_ipbuff_read_addr : integer := 0;
    constant ci_chan_pat_seq : t_int_array := fn_gen_dec_hb_ipbuff_pat(ci_fixed_chan_pat,C_NUM_CHANNELS,ci_chan_pat);
    variable current_chan_pat : integer := 0;
  begin
    if (rising_edge(clk)) then
      -- if sclr_int='1' then
      if areset = '1' then
        ipbuff           <= (others=>(others=>'0'));
        ipbuff_full      <= '0';
        ipbuff_ptr       <= fn_select_integer(-1,0,ci_fir_properties.ipbuff_custom);
        ipbuff_ready     <= false;
        ipbuff_out       <= (others=>'0');
        ipbuff_read_addr <= 0;
        ipbuff_write_addr<= 0;
        -- s_data_tready    <= '1';
        -- s_data_tready    <= fn_select_sl('0','1',ci_fir_properties.ipbuff_custom);--'0'; -- not sure what the fifo does here *******
        
        -- THis is a bit funny but I don't want to completely structure the code, duplicates slave
        if not ci_fir_properties.ipbuff_custom then
          if ce_int = '1' then
            s_data_tready <= not ipbuff_full;
          end if;
        end if;
        
        v_phase          := 0;
        v_writing_2nd_page := false;
        ip_write         <= false;
      -- elsif ce_int='1' then
      else
        v_write := (S_AXIS_DATA_TVALID='1') and (s_data_tready='1') and (ce_int='1');
        
        -- Pack all input data into a signal bus
        v_ipbuff_in(s_s_tdata) := fn_compress_axi_fields(ci_s_tdata_fields,S_AXIS_DATA_TDATA);
        if C_S_DATA_HAS_TUSER/=ci_no_tuser then
          v_ipbuff_in(s_s_tuser) := S_AXIS_DATA_TUSER;
        end if;
        if C_DATA_HAS_TLAST/=ci_no_tlast then
          v_ipbuff_in(s_s_tlast) := (s_s_tlast'HIGH=>S_AXIS_DATA_TLAST);
        end if;
        
        if not ci_fir_properties.ipbuff_custom then
          -- Normal fifo operation
          --   Need to duplicate the slave implementation, this registers the write and input data.
          ipbuff_in <= v_ipbuff_in;
          ip_write  <= v_write;
          
          prc_fifo( ip_write,--v_write,
                    ip_px_rdy and ipbuff_ready and (ce_px='1'),--ipbuff_read,
                    ipbuff_in,--v_ipbuff_in,
                    ipbuff,
                    ipbuff_ptr,
                    ipbuff_out,
                    ipbuff_ready,
                    ipbuff_flag, -- unused
                    ipbuff_full,
                    ci_fir_properties.ipbuff_thres,
                    ipbuff'HIGH-2);
          if ce_int = '1' then
            s_data_tready <= not ipbuff_full;
          end if;
        else
          -- if C_FILTER_TYPE = ci_halfband_decimation then
            -- -- Buffer write
            -- if v_write then
              -- ipbuff(ipbuff_write_addr) <= v_ipbuff_in;
              -- ipbuff_write_addr <= (ipbuff_write_addr +1) mod ci_fir_properties.ipbuff_size;
            -- end if;
            -- 
            -- -- Buffer read
            -- ipbuff_out <=  ipbuff(ipbuff_read_addr);
            -- 
            -- if ce_px='1' then
              -- if ci_fixed_chan_pat then
                -- if ipbuff_read then
                  -- if v_phase = 2*C_NUM_CHANNELS-1 then
                    -- v_ipbuff_read_addr := ipbuff_read_addr + 1;
                    -- v_phase := 0;
                  -- elsif v_phase rem 2 = 0 then
                    -- v_ipbuff_read_addr := ipbuff_read_addr + C_NUM_CHANNELS;
                    -- v_phase := v_phase+1;
                  -- else
                    -- v_ipbuff_read_addr := ipbuff_read_addr - (C_NUM_CHANNELS-1);
                    -- v_phase := v_phase+1;
                  -- end if;
                -- end if;
                -- ipbuff_read_addr <= v_ipbuff_read_addr mod ci_fir_properties.ipbuff_size;
              -- else
                -- if chanpat_updated then
                  -- current_chan_pat := chanpat;
                -- end if;
                -- if ipbuff_read then
                  -- ipbuff_read_addr <= ( ci_chan_pat_seq(
                                          -- current_chan_pat*2*ci_pat_len + -- pattern offset
                                          -- v_phase * ci_pat_len +          -- phase offset
                                          -- (v_ipbuff_read_addr mod C_NUM_CHANNELS)) -- channel index
                                        -- + (v_ipbuff_read_addr/(C_NUM_CHANNELS))*(2*C_NUM_CHANNELS) ) -- address offset
                                       -- mod ci_fir_properties.ipbuff_size;
                  -- if v_phase = 1 then
                    -- v_ipbuff_read_addr := (v_ipbuff_read_addr + 1) mod ci_fir_properties.ipbuff_size; -- hijack v_ipbuff_read_addr as index for lookup
                  -- end if;
                  -- v_phase := (v_phase+1) mod 2;
                  -- 
                -- end if;
              -- end if;
            -- end if;
            -- 
            -- v_read := ipbuff_page_read and ce_px='1';
            -- -- Full & ready genertion
            -- if v_write and v_read then
              -- ipbuff_ptr <= ipbuff_ptr - (2*C_NUM_CHANNELS) + 1;
              -- ipbuff_full <= '0';
              -- s_data_tready <= '1';
              -- ipbuff_ready <= false;
              -- -- if ipbuff_ptr - (2*C_NUM_CHANNELS) >= (2*C_NUM_CHANNELS)-1 then
                -- -- ipbuff_ready <= true;
              -- -- end if;
              -- if ipbuff_ptr >= (4*C_NUM_CHANNELS)-1 then
                -- ipbuff_ready <= true;
              -- end if;
            -- elsif v_write and not v_read then
              -- ipbuff_ptr <= ipbuff_ptr + 1;
              -- if ipbuff_ptr = ci_fir_properties.ipbuff_size-1 then
                -- ipbuff_full <= '1';
                -- s_data_tready <= '0';
              -- end if;
              -- ipbuff_ready <= false;
              -- if not v_writing_2nd_page then 
                -- if ipbuff_ptr >= (2*C_NUM_CHANNELS)-1 then
                  -- ipbuff_ready <= true;
                -- end if;
              -- else
                -- if ipbuff_ptr >= (4*C_NUM_CHANNELS)-1 then
                  -- ipbuff_ready <= true;
                -- end if;
              -- end if;
            -- elsif not v_write and v_read then
              -- ipbuff_ptr <= ipbuff_ptr - (2*C_NUM_CHANNELS);
              -- ipbuff_full <= '0';
              -- s_data_tready <= '1';
              -- ipbuff_ready <= false;
              -- -- if ipbuff_ptr - (2*C_NUM_CHANNELS) >= (2*C_NUM_CHANNELS) then
                -- -- ipbuff_ready <= true;
              -- -- end if;
              -- if ipbuff_ptr >= (4*C_NUM_CHANNELS) then
                -- ipbuff_ready <= true;
              -- end if;
            -- end if;
            -- 
            -- v_writing_2nd_page := false;
            -- if ipbuff_ptr > (2*C_NUM_CHANNELS)-1 then
              -- v_writing_2nd_page := true;
            -- end if;
            -- -- s_data_tready <= not ipbuff_full;
          -- else
            -- null;
          -- end if;
        end if;
      end if;
    end if;
  end process i_ipbuff;
  
  S_AXIS_DATA_TREADY <= s_data_tready;
  
  -- Config and reload i/f ---------------------------------------------------------------------------------------------
  i_cnfgbuff: process(clk) -- uses non-throttled CE
  begin
    if (rising_edge(clk)) then
      if areset='1' then --sclr_int='1' then
        cnfgbuff <= (others=>(others=>'0'));
        cnfgbuff_full <= '0';
        -- s_cnfg_tready <= '1';
        if ce_int='1' then -- to dup slave fifo behaviour
          s_cnfg_tready  <= not cnfgbuff_full;
        end if;
        
        cnfgbuff_ptr  <= -1;
        cnfgbuff_ready <= false;
        cnfgbuff_write <= false;
        cnfgbuff_in    <= (others=>'0');
        cnfgbuff_out   <= (others=>'0');
      -- elsif ce_int='1' then
      else
        
        -- Input AXI fifo
        cnfgbuff_write <= (S_AXIS_CONFIG_TVALID='1') and (s_cnfg_tready = '1') and (ce_int='1');
        cnfgbuff_in    <= S_AXIS_CONFIG_TLAST & S_AXIS_CONFIG_TDATA(s_chanpat'HIGH downto 0);
        if ce_int='1' then
          s_cnfg_tready  <= not cnfgbuff_full;
        end if;
        
        prc_fifo( cnfgbuff_write,
                  cnfgbuff_read and (ce_px='1'),
                  cnfgbuff_in,
                  cnfgbuff,
                  cnfgbuff_ptr,
                  cnfgbuff_out,
                  cnfgbuff_ready,
                  cnfgbuff_flag,
                  cnfgbuff_full,
                  fn_select_integer(1,C_NUM_CHANNELS,C_CONFIG_PACKET_SIZE=ci_chan_cnfg),-- not empty thres
                  cnfgbuff'HIGH-2,
                  fn_select_integer(2,C_NUM_CHANNELS+1,C_CONFIG_PACKET_SIZE=ci_chan_cnfg)); -- Secondary flag only used for num_channels=1 single config
      end if;
    end if;
  end process i_cnfgbuff;
  
  S_AXIS_CONFIG_TREADY <= s_cnfg_tready;
  
  i_cnfg_and_reload : process(clk)
    -- A lot of the delays and latency in this process must match the cnfg_and_reload component to ensure the 
    -- channel interfaces behave and transition in the same way.
    -- variable fsel_lookup        : t_int_array(C_NUM_FILTS-1 downto 0) := fn_gen_cnt(C_NUM_FILTS,1,0); -- may need to be a signal
    constant ci_fsel_lookup      : t_int_array(C_NUM_FILTS-1 downto 0) := fn_gen_cnt(C_NUM_FILTS,1,0);
    constant ci_fsel_pad         : t_int_array(2**log2roundup(C_NUM_FILTS)-1 downto C_NUM_FILTS) := (others=>0);
    constant ci_fsel_full        : t_int_array(2**log2roundup(C_NUM_FILTS)-1 downto 0) := fn_gen_cnt(2**log2roundup(C_NUM_FILTS),1,0);
    variable fsel_lookup         : t_int_array(2**log2roundup(C_NUM_FILTS)-1 downto 0) := fn_select_int_array(
                                                                                            fn_select_int_array(
                                                                                              ci_fsel_lookup,
                                                                                              ci_fsel_pad&ci_fsel_lookup,
                                                                                              2**log2roundup(C_NUM_FILTS) > C_NUM_FILTS),
                                                                                            ci_fsel_full,
                                                                                            C_NUM_FILTS > 1 and C_FILTS_PACKED = 0 and C_COEF_RELOAD=0);
    variable fsel_current       : t_int_array(C_NUM_CHANNELS-1 downto 0) := (others=>0);
    variable rld_slots          : t_int_array(C_NUM_RELOAD_SLOTS-1 downto 0) := fn_gen_cnt(C_NUM_RELOAD_SLOTS,1,C_NUM_FILTS);
    variable rld_slot           : integer := 0;
    variable rld_slot_i         : integer := -1;
    variable rld_filt           : integer := 0;
    variable freed_slots        : t_int_array(C_NUM_RELOAD_SLOTS-1 downto 0) := (others=>0);
    variable freed_cnt          : integer := -1;
    variable rld_cnt            : integer := 0;
    variable rld_coeff          : t_reload_coeffs := (others=>(others=>'0'));
    -- variable rlded_slots        : t_int_array(C_NUM_RELOAD_SLOTS-1 downto 0) := (others=>0);
    -- variable rlded_cnt          : integer := 0;
    variable rld_complete       : boolean := false;
    variable rld_invalid_fsel   : boolean := false;
    variable get_next_cnfg      : boolean := false;
    variable get_next_cnfg_dly  : t_bool_array(ci_fir_properties.cnfg_read_dly downto 0) := (others=>false);
    variable ip_chan_cnt_dly    : integer := 0;
    variable chan_cnt_dly       : t_int_array(ci_fir_properties.cnfg_read_dly downto 0) := (others=>0);
    -- variable tlast_ored         : boolean:=false;
    variable tlast_sel          : boolean:=false;
    variable tlast_dly          : t_bool_array(ci_fir_properties.cnfg_read_dly downto 0) := (others=>false); 
  begin
    if (rising_edge(clk)) then
      if sclr_int='1' then
        cnfgbuff_read         <= false;
        cnfgbuff_read_dly     <= false;
        updating_cnfg         <= false;
        packet_end            <= false;
        next_cnfg             <= false;
        update_chan           <= 0;
        update_chan_dly       <= 0;
        s_reload_tready       <= '0';--'1';
        get_reload_filt       <= (C_NUM_FILTS > 1);
        update_cnfg_first     <= false;
        update_cnfg_first_dly <= false;
        if C_COEF_RELOAD = 0 then
          -- fsel_current          := (others => 0);
          fsel                  <= 0;
        end if;
        if C_COEF_RELOAD=1 then --and C_NUM_FILTS>1 then
          -- Set all channels to the filter 0
          fsel_current          := (others => fsel_lookup(0));
        else --if C_COEF_RELOAD = 0 then
          fsel_current          := (others => 0);
        end if;
        -- Current filter sel will not be cleared. If a reload filter is being implemented then could end up pointing
        -- at a partially reloaded location.
        next_cnfg             <= false;
        next_cnfg_dly         <= false;
        chanpat               <= 0;
        chanpat_updated       <= false;
        check_tlast           <= false;
        -- tlast_ored            <= false;
        rld_cnt               := 0;
        rld_invalid_fsel      := false;
        next_chan             <= false;
        next_chan_dly         <= false;
        
        -- Event i/f
        event_s_config_tlast_missing     <= '0';
        event_s_config_tlast_unexpected  <= '0';
        event_s_reload_tlast_missing     <= '0';
        event_s_reload_tlast_unexpected  <= '0';
      else
        if ce_px='1' then -- Internal CE
        
          -- Event i/f
          event_s_config_tlast_missing     <= '0';
          event_s_config_tlast_unexpected  <= '0';
          event_s_reload_tlast_missing     <= '0';
          event_s_reload_tlast_unexpected  <= '0';
          
          -- Generate get_next_cnfg to allign with core
          prc_dly(get_new_data,get_next_cnfg_dly,get_next_cnfg);
          -- prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          -- should probably include a delayed version of update_cnfg but not used by implemented structures yet
          
          if C_FILTER_TYPE = ci_decimation or C_FILTER_TYPE = ci_halfband_decimation then
            -- tlast_sel := tlast_ored;
            prc_dly(tlast_ored,tlast_dly(tlast_dly'HIGH-1 downto 0),tlast_sel);
            -- generated the cycle after get_new_data
            prc_dly(op_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          -- elsif C_FILTER_TYPE = ci_halfband_decimation then
            -- -- BROKEN, suspect will operate like ci_decimation
            -- -- check_tlast <= get_new_data or get_new_data_2ndphase;
            -- -- if check_tlast then
              -- -- if get_new_data_2ndphase then
                -- -- --clear
                -- -- tlast_ored <= (ipbuff_out(s_s_tlast)="1");
              -- -- else
                -- -- tlast_ored <= (ipbuff_out(s_s_tlast)="1") or tlast_ored;
              -- -- end if;
            -- -- end if;
            -- -- tlast_sel := tlast_ored; -- should tlast_sel be delayed?????? *******
          else
            tlast_sel := (ipbuff_out(s_s_tlast)="1");
            prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          end if;
          
          -- Start a config update
          --  The enabling signal, updating_cnfg, is required so the read is continued after the input buffer threshold has
          --  been de-asserted and to ensure only the correct number of configuration are read.
          if C_NUM_CHANNELS > 1 then
            
            cnfgbuff_read <= false; -- the latency of this must match that of the core for the input buffers to respond correctly
            if get_next_cnfg and update_cnfg and ( (ip_chan_cnt_dly=0 and cnfgbuff_ready and (C_CONFIG_SYNC_MODE=ci_cnfg_vector_sync or packet_end)) or
                                                   (updating_cnfg and C_CONFIG_PACKET_SIZE /= ci_single_cnfg) ) then
              cnfgbuff_read <= true;
            end if;
            
            update_cnfg_first <= false;
            if get_next_cnfg and update_cnfg and ip_chan_cnt_dly=0 and cnfgbuff_ready and (C_CONFIG_SYNC_MODE=ci_cnfg_vector_sync or packet_end) then
              updating_cnfg     <= true;
              update_cnfg_first <= true;
              packet_end        <= false;
            elsif (get_next_cnfg and update_cnfg and ip_chan_cnt_dly=C_NUM_CHANNELS-1) or C_CONFIG_PACKET_SIZE = ci_single_cnfg then
              updating_cnfg <= false;
            end if;
            
          else
            -- Need a special case due to the delay from generating cnfgbuff_read to cnfgbuff_ready being deasserted
            cnfgbuff_read     <= false;
            update_cnfg_first <= false;
            updating_cnfg     <= false;
            if cnfgbuff_read and get_next_cnfg and update_cnfg and cnfgbuff_ready and cnfgbuff_flag and (C_CONFIG_SYNC_MODE=ci_cnfg_vector_sync or packet_end)  then
              cnfgbuff_read     <= true;
              update_cnfg_first <= true;
              updating_cnfg     <= true;
              packet_end        <= false;
            elsif not cnfgbuff_read and get_next_cnfg and update_cnfg and cnfgbuff_ready and (C_CONFIG_SYNC_MODE=ci_cnfg_vector_sync or packet_end)  then
              cnfgbuff_read     <= true;
              update_cnfg_first <= true;
              updating_cnfg     <= true;
              packet_end        <= false;
            end if;
            
          end if;
          
          if get_next_cnfg and tlast_sel then --ipbuff_out(s_s_tlast)="1" then
            packet_end <= true;
          end if;
          
          -- Delay cntrl signal to allign with data read out of input fifo
          next_chan             <= get_next_cnfg;
          next_chan_dly         <= next_chan;
          next_cnfg             <= get_next_cnfg and update_cnfg;
          next_cnfg_dly         <= next_cnfg;
          cnfgbuff_read_dly     <= cnfgbuff_read;
          update_chan           <= ip_chan_cnt_dly;
          update_chan_dly       <= update_chan;
          update_cnfg_first_dly <= update_cnfg_first;
          
          -- Store and optionally update fsel for new calculation
          -- Check channel pattern
          if next_cnfg_dly then
            -- if C_NUM_FILTS > 1 then
              if cnfgbuff_read_dly then 
                -- store new config
                if C_CONFIG_PACKET_SIZE = ci_single_cnfg then
                  if C_NUM_FILTS > 1 then
                    fsel_current := (others=> fsel_lookup(to_integer(unsigned(cnfgbuff_out(s_fsel)))));
                  else           
                    fsel_current := (others=> fsel_lookup(0));
                  end if;
                else
                  if C_NUM_FILTS > 1 then                                               
                    fsel_current(update_chan_dly) := fsel_lookup(to_integer(unsigned(cnfgbuff_out(s_fsel))));
                  else
                    fsel_current(update_chan_dly) := fsel_lookup(0);
                  end if;
                  -- Event i/f
                  if update_chan_dly = C_NUM_CHANNELS - 1 and cnfgbuff_out(s_chanpat'HIGH+1) = '0' then -- compare where TLAST occurs
                    event_s_config_tlast_missing     <= '1';
                  end if;
                  if update_chan_dly /= C_NUM_CHANNELS - 1 and cnfgbuff_out(s_chanpat'HIGH+1) = '1' then -- compare where TLAST occurs
                    event_s_config_tlast_unexpected     <= '1';
                  end if;
                end if;
              end if;
              -- Moved to outside next_cnfg_dly clause. Needs to update for every channel
              -- fsel <= fsel_current(update_chan_dly);
            -- end if;
            
            if not ci_fixed_chan_pat then
              -- Clause added to avoid sim warnings
              chanpat_updated <= false;
              if chanpat /= to_integer(unsigned(cnfgbuff_out(s_chanpat))) and update_cnfg_first_dly then
                chanpat_updated <= true;
                chanpat         <= to_integer(unsigned(cnfgbuff_out(s_chanpat)));
              end if;
            end if;
          end if;
          
          -- Update fsel, to new or current value. Updated above
          if next_chan_dly then
            fsel <= fsel_current(update_chan_dly);
          end if;
          
        end if;
        
        if ce_int ='1' then -- External CE
        
          -- Reload interface --------------------------------------------------------
          if S_AXIS_RELOAD_TVALID='1' and s_reload_tready='1' and get_reload_filt then
            rld_filt        := to_integer(unsigned(S_AXIS_RELOAD_TDATA(s_fsel)));
            get_reload_filt <= false;
            
            if rld_filt > C_NUM_FILTS -1 then
              rld_invalid_fsel := true;
            else
              rld_invalid_fsel := false;
            end if;
          end if;
          
          -- if S_AXIS_RELOAD_TVALID='1' and s_reload_tready='1' and start_rld then
            -- start_rld   <= false;
            -- rld_cnt     := 0;
          -- end if;
          
          -- Event i/f
          --  Borrow rld_complete
          rld_complete := false;
          if S_AXIS_RELOAD_TVALID='1' and s_reload_tready='1' and rld_cnt = ci_fir_properties.reload_taps-1 then
            -- Note rld_cnt not increament until the core below
            rld_complete := true; 
          end if;
          
          if rld_complete and S_AXIS_RELOAD_TLAST = '0' then
            event_s_reload_tlast_missing <= '1';     
          end if;
          if (not rld_complete) and S_AXIS_RELOAD_TLAST = '1' then
            event_s_reload_tlast_unexpected <= '1';     
          end if;
          
          rld_complete := false;
          if S_AXIS_RELOAD_TVALID='1' and s_reload_tready='1' and not get_reload_filt and rld_cnt < ci_fir_properties.reload_taps then
            rld_coeff(rld_cnt) := S_AXIS_RELOAD_TDATA(ci_coef_width_physical-1 downto 0);--C_COEF_WIDTH-1 downto 0);
            rld_cnt            := rld_cnt + 1;
            
            if rld_cnt = ci_fir_properties.reload_taps then
              -- Reload finised
              rld_cnt               := 0;
              -- start_rld             <= true;
              get_reload_filt       <= (C_NUM_FILTS > 1);
              -- rld_slot              := rld_slots(rld_slot_i);
              -- rld_slot_i            := rld_slot_i + 1;
              -- Store reloaded filter
              -- coeff_sets(rld_slot)  <= do_coeff_reorder(reload_coeff);
              rld_complete := true; 
            end if;
            
            if rld_invalid_fsel then
              -- Clear rld_complete so filter is not stored
              rld_complete := false;
            end if;
            
          end if;
          
          -- Update Reload slots queue
          if (update_cnfg_first and ce_px='1') and rld_complete then -- read and write
            rld_slot_i := rld_slot_i - (freed_cnt+1) + 1;
          elsif (not update_cnfg_first and ce_px='1') and rld_complete then -- read and no write
            rld_slot_i := rld_slot_i +  1;
          elsif (update_cnfg_first and ce_px='1') and not rld_complete then -- no read and write
            rld_slot_i := rld_slot_i - (freed_cnt+1);
          end if;
          
          if update_cnfg_first and ce_px='1' then
            -- Add the freed slots to the reload queue
            rld_slots(rld_slots'HIGH-(freed_cnt+1) downto 0) := rld_slots(rld_slots'HIGH downto freed_cnt+1);
            rld_slots(rld_slots'HIGH downto rld_slots'HIGH-freed_cnt) := freed_slots(freed_cnt downto 0);
          end if;
          
          rld_slot := rld_slots(get_max(0,rld_slot_i));
          
          if rld_complete then
            -- Store reloaded filter
            coeff_sets(rld_slot)  <= do_coeff_reorder(rld_coeff);
          end if;
          
          if (update_cnfg_first and ce_px='1') or (rld_slot_i < C_NUM_RELOAD_SLOTS-1) then
            s_reload_tready <= '1';
          elsif rld_complete and rld_slot_i = C_NUM_RELOAD_SLOTS-1 then
            s_reload_tready <= '0';
          end if;
          
          -- Changed to match the core
          -- Need to reverse the priority. If a reload complete occurs and there are no more slots availble and 
          -- at the same time as a config update. The update will not take the new value so ready must be de-asserted
          -- if rld_complete and rld_slot_i = C_NUM_RELOAD_SLOTS-1 then
            -- s_reload_tready <= '0';
          -- elsif (update_cnfg_first and ce_px='1') or (rld_slot_i < C_NUM_RELOAD_SLOTS-1) then
            -- s_reload_tready <= '1';
          -- end if;
          
          -- Reloaded slots queue
          if rld_complete then
            rlded_filt(rlded_filt'HIGH downto 1) <= rlded_filt(rlded_filt'HIGH-1 downto 0);
            rlded_filt(0)                        <= rld_filt;
            rlded_filt_slot(rlded_filt'HIGH downto 1) <= rlded_filt_slot(rlded_filt'HIGH-1 downto 0);
            rlded_filt_slot(0)                        <= rld_slot;
          end if;
          
          update_fsel     <= (rlded_cnt /= -1) and not (updating_cnfg and ce_px='1');
          update_fsel_dly <= update_fsel;
          updated_fsel      <= rlded_filt(get_max(0,rlded_cnt));
          updated_fsel_slot <= rlded_filt_slot(get_max(0,rlded_cnt));
          
          if ((rlded_cnt /= -1) and not (updating_cnfg and ce_px='1')) and rld_complete then -- read and write
            null;
          elsif not((rlded_cnt /= -1) and not (updating_cnfg and ce_px='1')) and rld_complete then -- no read and write
            rlded_cnt <= rlded_cnt + 1;
          elsif ((rlded_cnt /= -1) and not (updating_cnfg and ce_px='1')) and not rld_complete then -- read and no write
            rlded_cnt <= rlded_cnt - 1;
          end if;
          
          -- Update fsel
          --   Follows update config i.e. lookup read so should exhibit the same behavour
          if update_fsel then
            freed_slot <= fsel_lookup(updated_fsel);
            fsel_lookup(updated_fsel) := updated_fsel_slot;
          end if;
          
          -- Available Slots queue
          if update_fsel_dly and (update_cnfg_first and ce_px='1') then -- read and write
            freed_cnt := 0;
          elsif update_fsel_dly and not (update_cnfg_first and ce_px='1') then -- no read and write
            freed_cnt := freed_cnt + 1;
          elsif not update_fsel_dly and (update_cnfg_first and ce_px='1') then -- read and not write
            -- All transfered into reload slots
            freed_cnt := - 1;
          end if;
          
          if update_fsel_dly then
            freed_slots(freed_slots'HIGH downto 1) := freed_slots(freed_slots'HIGH-1 downto 0);
            freed_slots(0) := freed_slot;
          end if;
          
          
        end if;
      end if;
    end if;
  end process i_cnfg_and_reload;
  
  S_AXIS_RELOAD_TREADY <= s_reload_tready;
  
  -- PX block ----------------------------------------------------------------------------------------------------------
  i_fir : process(clk)
    variable main_buffer  : t_main_buffer_array:= (others=>(others=>(data             => (others=>(others=>0)),
                                                                     tuser            => (others=>(others=>'0')),
                                                                     fsel             => (others=>0),
                                                                     chanpat          => (others=>0),
                                                                     chanpat_updated  => (others=>false) )));
                                                                     
    constant main_buffer_reset       : t_main_buffer_array := (others => (others => (data             => (others=>(others=>0)),
                                                                                     tuser            => (others=>(others=>'0')),
                                                                                     fsel             => (others=>0),
                                                                                     chanpat          => (others=>0),
                                                                                     chanpat_updated  => (others=>false))));
                                                                     
    variable main_buffer_ptrs : t_pointers := (others=>-1); -- minus 1 so first inc moves it to 0
    variable chan_id          : integer := 0;
    variable data_slice       : t_regressor;
    variable coeff_set        : t_coeff_pages;
    variable current_chan_pat,
             current_op_chan_pat  
             : integer := 0;
    variable ipbuff_tuser     : std_logic_vector(ci_s_tuser_width-1 downto 0);
    -- Cntrl delay variables
    variable gen_op_dly,
             start_op_dly,
             push_buffer_dly    : t_bool_array(ci_fir_properties.cntrl_dly downto 0):=(others=>false);
    variable chan_cnt_dly,
             op_chan_cnt_dly,
             op_phase_cnt_dly : t_int_array(ci_fir_properties.cntrl_dly downto 0):=(others=>0);
    variable buff_out_dly       : t_buffer(ci_fir_properties.data_dly downto 0) := (others=>(others=>'0'));
    variable ipbuff_read_dly,
             ipbuff_page_read_dly : t_bool_array(ci_fir_properties.ipbuff_read_dly-1 downto 0):=(others=>false);
    variable gen_op,
             start_op,
             push_buffer        : boolean := false;
    variable ip_chan_cnt_dly,
             push_chan_cnt,
             gen_op_chan_cnt,
             gen_op_chan_cnt_src,
             gen_op_phase_cnt : integer := 0;
    variable ipbuff_out_dly     : std_logic_vector(ipbuff_out'HIGH downto 0):= (others=>'0');
    variable v_ipbuff_read,
             v_ipbuff_page_read : boolean := false;
    variable v_tlast_ored       : std_logic := '0';
    -- Constants and variables specific to ci_decimation (integer and fractional) structure
    constant ci_deci_max_ips_per_op    : integer := divroundup(C_DECIM_RATE,C_INTERP_RATE);
    constant ci_deci_min_ips_per_op    : integer := (C_DECIM_RATE/C_INTERP_RATE);
    variable v_ip_write,
             v_ip_write_dly,--reg
             v_ip_read,
             v_op_start,
             v_get_new_data            : boolean := false;
    constant ci_deci_phase_cnt_init    : integer := (ci_deci_max_ips_per_op*C_INTERP_RATE) mod C_DECIM_RATE;
    -- variable v_phase_cnt               : integer := ci_phase_cnt_init;
    variable v_new_samples_for_op      : integer := ci_deci_max_ips_per_op;
    constant ci_new_samples_for_next_op_init : integer:= fn_select_integer(
                                                      ci_deci_min_ips_per_op,
                                                      ci_deci_max_ips_per_op,
                                                      C_INTERP_RATE=1 or
                                                      (2*ci_deci_max_ips_per_op-1)*C_INTERP_RATE+1 <= 2*C_DECIM_RATE); 
    variable v_new_samples_for_next_op : integer := ci_new_samples_for_next_op_init;
    variable buff_ptr_in,
             buff_ptr_out,
             buff_ptr_tlast,
             ptr_temp                  : integer := 0;
    constant ci_ip_store_depth         : integer :=(2*ci_deci_max_ips_per_op*C_NUM_CHANNELS) +  ci_fir_properties.cntrl_dly;
    variable ip_store                  : t_buffer(ci_ip_store_depth downto 0) := (others=>(others=>'0'));
    variable new_samples_for_op_dly,
             new_samples_for_next_op_dly : t_int_array(ci_fir_properties.cntrl_dly downto 0):=(others=>0);
    variable new_samples_for_op_out,
             new_samples_for_next_op_out : integer := 0;
    -- Constants and variables specific to ci_polyphase_interpolation (primarily for fractional)
    constant ci_inter_max_ops_per_ip : integer := divroundup(C_INTERP_RATE,C_DECIM_RATE);
    constant ci_inter_min_ops_per_ip : integer := (C_INTERP_RATE/C_DECIM_RATE);
    variable v_op_samples_for_ip      : integer := ci_inter_max_ops_per_ip;
    constant ci_op_samples_for_next_ip_init : integer := fn_select_integer(
                                                      ci_inter_min_ops_per_ip,
                                                      ci_inter_max_ops_per_ip,
                                                      C_DECIM_RATE=1 or
                                                      (2*ci_inter_max_ops_per_ip-1)*C_DECIM_RATE+1 <= 2*C_INTERP_RATE);
    variable v_op_samples_for_next_ip : integer := ci_op_samples_for_next_ip_init;
    constant ci_inter_phase_cnt_init    : integer := (ci_inter_max_ops_per_ip*C_DECIM_RATE) mod C_INTERP_RATE;
    variable v_op_samples_for_ip_out  : integer := 0;
    variable v_op_px_cnt_max_sel,
             v_gen_op_src       : boolean;
    variable ip_px_rdy_set,
             ip_px_rdy_set_src,
             ip_px_rdy_clr: boolean;
    variable ops_for_ip_dly : t_int_array(ci_fir_properties.cntrl_dly downto 0):=(others=>0);
    variable ops_for_ip,
             v_op_phase_cnt_sel,
             v_op_samples_for_ip_sel : integer;
    -- ci_halfband_decimation
    variable chan_buff_i : t_int_array(C_NUM_CHANNELS-1 downto 0) := (others=>0);
    
    -- Shared
    variable v_phase_cnt               : integer := fn_select_integer(
                                                      ci_deci_phase_cnt_init,
                                                      ci_inter_phase_cnt_init,
                                                      C_FILTER_TYPE = ci_polyphase_interpolation);
                                                      
    variable ip_px_rdy_dly            : t_bool_array(fn_select_integer(
                                                      2*C_OUTPUT_RATE-C_OVERSAMPLING_RATE, -- halfband interpolation
                                                      (C_OUTPUT_RATE-C_OVERSAMPLING_RATE)*C_INTERP_RATE,
                                                      C_FILTER_TYPE = ci_polyphase_interpolation) 
                                                      downto 0);
  begin            
    if (rising_edge(clk)) then
      if sclr_int='1' then
        ipbuff_read      <= false;
        ipbuff_page_read <= false;
        ip_px_rdy        <= true;
        ip_px_cnt        <= 0;
        ip_chan_cnt      <= 0;
        ip_phase_cnt     <= 0;
        main_buffer_ptrs := (others=>-1); 
        -- main_buffer      := (others=>(others=>(data             => (others=>(others=>0)),
                                               -- tuser            => (others=>(others=>'0')),
                                               -- fsel             => (others=>0),
                                               -- chanpat          => (others=>0),
                                               -- chanpat_updated  => (others=>false) )));
        main_buffer      := main_buffer_reset;
        cascade_dly      <= (others=>(result=>(others=>(others=>'0')),
                                      tuser=>(others=>'0'),
                                      tlast=>'0',
                                      chan_id=>0,
                                      valid=>false));
        gen_op           := false;
        ip_px_cnt_en     <= false;
        current_chan_pat := 0;
        output_chan_pat  <= 0;
        if C_FILTER_TYPE = ci_polyphase_decimation then
          update_cnfg      <= true;
        else
          update_cnfg      <= false;
        end if;
        push_buffer      := false;
        gen_op_dly       := (others=>false);
        push_buffer_dly  := (others=>false);
        ipbuff_read_dly  := (others=>false);
        ipbuff_page_read_dly := (others=>false);
        ip_px_cnt_max    <= false;
        chan_cnt_dly     := (others=>0);
        buff_out_dly     := (others=>(others=>'0'));
        ip_chan_cnt_dly  := 0;
        ipbuff_out_dly   := (others=>'0');
        get_new_data     <= false;
        -- get_new_data_2ndphase <= false;
        op_px_cnt_en     <= false;
        op_px_cnt        <= 0;
        op_chan_cnt      <= 0;
        op_px_cnt_max    <= false;
        buff_ptr_in      := 0;
        buff_ptr_out     := 0;
        buff_ptr_tlast   := 0;
        v_phase_cnt      := fn_select_integer(
                              ci_deci_phase_cnt_init,
                              ci_inter_phase_cnt_init,
                              C_FILTER_TYPE = ci_polyphase_interpolation);
        v_new_samples_for_op := ci_deci_max_ips_per_op;
        v_new_samples_for_next_op := ci_new_samples_for_next_op_init;
        ptr_temp         := 0;
        new_samples_for_op <= 0;--??
        new_samples_for_next_op <= 0; --??
        v_op_samples_for_ip := ci_inter_max_ops_per_ip;
        v_op_samples_for_next_ip := ci_op_samples_for_next_ip_init;
        op_phase_cnt     <= 0;
        start_op_dly     := (others=>false);
        start_op         := false;
        ip_store         := (others=>(others=>'0'));
        v_ip_write_dly   := false;
        ip_px_rdy_dly    := (others=> false);
      elsif ce_px='1' then
        
        -- Input read and data buffer update -------------------------------------------------
        --   Every filter structure may have its owm implementation to match the cores processing
        --   timing/sequencing
        case C_FILTER_TYPE is
        --------------------------------------------------------------------------------------
        when ci_single_rate => --| ci_halfband_decimation =>
        --------------------------------------------------------------------------------------
          -- Very similar processing so share code
          update_cnfg <= true;
          get_new_data <= false;
          
          -- if C_FILTER_TYPE = ci_single_rate then
          
            if ip_px_rdy and ipbuff_ready then
              get_new_data <= true;
              if ci_fir_properties.px_time > 1 then
                ip_px_rdy    <= false;
              end if;
              ip_px_cnt_en <= true;
            elsif ip_px_cnt = ci_fir_properties.px_time-1 then
              ip_px_cnt_en <= false;
            end if;
            
            if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
              ip_px_rdy    <= true;
            end if;
          
          -- else -- ci_halfband_decimation
            -- if (ip_px_rdy and ipbuff_ready) or 
               -- (ip_px_cnt_en and ip_px_cnt_max and ip_chan_cnt /= C_NUM_CHANNELS-1)  then
              -- get_new_data <= true;
            -- end if;
            -- get_new_data_2ndphase <= get_new_data;
            -- 
            -- if ip_px_rdy and ipbuff_ready then
              -- ip_px_cnt_en <= true;
            -- elsif ip_px_cnt = ci_fir_properties.px_time-1 and ip_chan_cnt = C_NUM_CHANNELS-1 then
              -- ip_px_cnt_en <= false;
            -- end if;
            -- 
            -- if ip_px_rdy and ipbuff_ready then
              -- ip_px_rdy    <= false;
            -- elsif ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en and ip_chan_cnt = C_NUM_CHANNELS-1 then
              -- ip_px_rdy    <= true;
            -- end if;
            -- 
          -- end if;
          
          ip_px_cnt_max <= false;
          if ci_fir_properties.px_time > 1 then
            if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
              ip_px_cnt_max <= true;
            end if;
          else
            ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          end if;
          
          if ip_px_cnt_en then
            if ip_px_cnt = ci_fir_properties.px_time-1 then
              ip_px_cnt    <= 0;
              if ip_chan_cnt = C_NUM_CHANNELS-1 then
                ip_chan_cnt <= 0;
              else
                ip_chan_cnt <= ip_chan_cnt +1;
              end if;
            else
              ip_px_cnt <= ip_px_cnt + 1;
            end if;
          end if;
          
          -- -- Generate ipbuff read----------------------------------------------
          -- --   Note, only used by ci_halfband_decimation structure
          -- --   Communicating with another process so uses signals
          -- if C_FILTER_TYPE = ci_halfband_decimation then
            -- -- 2 reads for both phases of data
            -- prc_dly(( (ip_px_rdy and ipbuff_ready) or (ip_px_cnt_en and ip_px_cnt_max and ip_chan_cnt /= C_NUM_CHANNELS-1)) or 
                      -- get_new_data,
                      -- ipbuff_read_dly,
                      -- v_ipbuff_read);
            -- ipbuff_read <= v_ipbuff_read;
            -- if C_NUM_CHANNELS > 1 then
              -- -- prc_dly(ip_px_cnt_max and ip_px_cnt_en and ip_chan_cnt = C_NUM_CHANNELS-2,
                      -- -- ipbuff_page_read_dly,
                      -- -- v_ipbuff_page_read);
              -- v_ipbuff_page_read := ip_px_cnt_max and ip_px_cnt_en and ip_chan_cnt = C_NUM_CHANNELS-2;
            -- else
              -- -- prc_dly(ip_px_rdy and ipbuff_ready,
                      -- -- ipbuff_page_read_dly,
                      -- -- v_ipbuff_page_read);
              -- v_ipbuff_page_read := ip_px_rdy and ipbuff_ready;
            -- end if;
            -- ipbuff_page_read <= v_ipbuff_page_read;
          -- end if;
          
          -- Delay the control ------------------------------------------------ 
          --   by the cnfg_and_reload latency to allign with fsel and chanpat
          -- if C_FILTER_TYPE = ci_single_rate then
            prc_dly(get_new_data,push_buffer_dly,push_buffer);
          -- else
            -- -- Need to push both phases(samples) of data that contribute to the output about to be
            -- -- generated
            -- prc_dly(get_new_data or get_new_data_2ndphase,push_buffer_dly,push_buffer);
          -- end if;
          prc_dly(ip_px_cnt_max,gen_op_dly,gen_op);
          prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(ipbuff_out,buff_out_dly,ipbuff_out_dly);
          
          -- Event i/f --------------------------------------------------------
          if get_new_data then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
          end if;
          
          -- Push main buffer -------------------------------------------------
          if push_buffer then
            
            if ip_chan_cnt_dly = 0 and chanpat_updated then
              current_chan_pat := chanpat;
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid                   <= false;
          
          if gen_op then
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; -- watch using chan_id here, should be a delay version of ip_chan_cnt allign with gen_op incase there is a difference
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_m_tuser_user_width-1 downto 0);
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
              -- if C_FILTER_TYPE = ci_halfband_decimation then
                -- -- Need to OR TLAST across decimation period
                -- cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1) or
                                        -- main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id)-1)(ci_tuser_dly_width-1);
              -- end if;
            elsif C_DATA_HAS_TLAST = ci_vector_tlast and C_NUM_CHANNELS>1 then
              cascade_dly(0).tlast <= '0';
              if ip_chan_cnt_dly = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            if not ci_fixed_chan_pat and chan_id=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then
              -- Need to clear regressor vector, pattern change
              prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            end if;
            
            -- if C_FILTER_TYPE = ci_halfband_decimation then
              -- -- Shift ptr to allign with correct phase.
              -- main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
            -- end if;
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
          end if;
        --------------------------------------------------------------------------------------
        when ci_halfband_decimation => 
        --------------------------------------------------------------------------------------
          update_cnfg <= true;
          get_new_data <= false;
          get_fifo_data <= false;
          
          if ip_px_rdy and ipbuff_ready then
            -- get_new_data <= true;
            get_fifo_data <= true;
            if C_INPUT_RATE > 1 then
              ip_px_rdy    <= false;
            end if;
            ip_px_cnt_en <= true;
          elsif ip_px_cnt = C_INPUT_RATE-1 then
            ip_px_cnt_en <= false;
          end if;
          
          if ip_px_cnt = C_INPUT_RATE-2 and ip_px_cnt_en then
            ip_px_rdy    <= true;
          end if;
          
          ip_px_cnt_max <= false;
          if C_INPUT_RATE > 1 then
            if ip_px_cnt = C_INPUT_RATE-2 and ip_px_cnt_en then
              ip_px_cnt_max <= true;
            end if;
          else
            ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          end if;
          
          if ip_px_cnt_en then
            if ip_px_cnt = C_INPUT_RATE-1 then
              ip_px_cnt    <= 0;
              if ip_chan_cnt = C_NUM_CHANNELS-1 then
                ip_chan_cnt <= 0;
                if ip_phase_cnt = 1 then
                  ip_phase_cnt <= 0;
                else
                  ip_phase_cnt <= ip_phase_cnt + 1;
                end if;
              else
                ip_chan_cnt <= ip_chan_cnt +1;
              end if;
            else
              ip_px_cnt <= ip_px_cnt + 1;
            end if;
          end if;
          
          -- Generate output control
          if get_fifo_data and --ip_px_cnt_max and
             ip_chan_cnt = C_NUM_CHANNELS-1 and 
             ip_phase_cnt = 1 then
            op_px_cnt_en <= true;
          elsif op_px_cnt = ci_fir_properties.px_time-1 and
                op_chan_cnt = C_NUM_CHANNELS-1 then
            op_px_cnt_en <= false;
          end if;
          
          get_new_data <= false;
          if (get_fifo_data and --ip_px_cnt_max and
              ip_chan_cnt = C_NUM_CHANNELS-1 and 
              ip_phase_cnt = 1) or
             (op_px_cnt_en and op_px_cnt = ci_fir_properties.px_time-1 and op_chan_cnt < C_NUM_CHANNELS - 1) 
             then
            get_new_data <= true;
          end if;
          
          if op_px_cnt_en then
            if op_px_cnt = ci_fir_properties.px_time-1 then
              op_px_cnt <= 0;
              if op_chan_cnt = C_NUM_CHANNELS-1 then
                op_chan_cnt <= 0;
              else
                op_chan_cnt <= op_chan_cnt + 1;
              end if;
            else
              op_px_cnt <= op_px_cnt + 1;
            end if;
          end if;
          
          -- Input buffer -----------------------------------------------------
          --   Addition input buffer to store data transferred from the fifo before
          --   it is written into data vector
          --  Originally used for ci_decimation, hyjack for this structure now
          if v_ip_write_dly then
            ip_store(buff_ptr_in)(ipbuff_out'RANGE) := ipbuff_out;
            buff_ptr_in := (buff_ptr_in + 1) mod ci_ip_store_depth;
          end if;
          v_ip_write_dly := ip_px_rdy and ipbuff_ready;--get_new_data;
          
          -- Generate TLAST ored for the output we're about to generate
          -- NOTE: Copied from ci_decimation
          tlast_ored <= false;
          if get_new_data and op_chan_cnt = 0 then
            for i in 0 to 2*C_NUM_CHANNELS-1 loop
              if ip_store((buff_ptr_tlast+i) mod ci_ip_store_depth)(s_s_tlast)="1" then
                tlast_ored <= true;
              end if;
            end loop;
            buff_ptr_tlast := (buff_ptr_tlast + v_new_samples_for_op*C_NUM_CHANNELS) mod ci_ip_store_depth;
          end if;
          
          -- Event i/f --------------------------------------------------------
          if get_new_data then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
          end if;
          
          -- Delay the control ------------------------------------------------
          prc_dly(get_new_data,push_buffer_dly,push_buffer);-- and op_chan_cnt=0
          prc_dly(op_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(op_px_cnt = ci_fir_properties.px_time-1,gen_op_dly,gen_op);
          
          -- Push main buffer -------------------------------------------------
          --  Push all data for next block of outputs
          if push_buffer then
            
            if ip_chan_cnt_dly = 0 and chanpat_updated then
              current_chan_pat := chanpat;
              chan_buff_i := (others=>0);
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            -- Fetch data from store
            if ci_fixed_chan_pat then
              ipbuff_out_dly := ip_store(buff_ptr_out)(ipbuff_out'RANGE);
            else
              loop
                if chan_id = ci_chan_pat(current_chan_pat*ci_pat_len + chan_buff_i(chan_id)) then
                  exit;
                else
                  chan_buff_i(chan_id) := chan_buff_i(chan_id) + 1;
                end if;
              end loop;
              ipbuff_out_dly := ip_store(buff_ptr_out+chan_buff_i(chan_id))(ipbuff_out'RANGE);
            end if;
              
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
            -- 2nd phase
            if ci_fixed_chan_pat then
              ipbuff_out_dly := ip_store((buff_ptr_out+C_NUM_CHANNELS) mod ci_ip_store_depth)(ipbuff_out'RANGE);
            else
              loop
                if chan_id = ci_chan_pat(current_chan_pat*ci_pat_len + chan_buff_i(chan_id)) then
                  exit;
                else
                  chan_buff_i(chan_id) := chan_buff_i(chan_id) + 1;
                end if;
              end loop;
              ipbuff_out_dly := ip_store(buff_ptr_out+chan_buff_i(chan_id))(ipbuff_out'RANGE);
            end if;
              
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
            
            if ci_fixed_chan_pat then
              if ip_chan_cnt_dly = C_NUM_CHANNELS-1 then
                buff_ptr_out := (buff_ptr_out + 1 + C_NUM_CHANNELS) mod ci_ip_store_depth;
              else
                buff_ptr_out := (buff_ptr_out + 1) mod ci_ip_store_depth;
              end if;
            else
              if ip_chan_cnt_dly = C_NUM_CHANNELS-1 then
                chan_buff_i := (others=>0);
                buff_ptr_out := (buff_ptr_out + C_NUM_CHANNELS) mod ci_ip_store_depth;
              end if;
            end if;
            
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid                   <= false;
          
          if gen_op then
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; -- watch using chan_id here, should be a delay version of ip_chan_cnt allign with gen_op incase there is a difference
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_m_tuser_user_width-1 downto 0);
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
              -- if C_FILTER_TYPE = ci_halfband_decimation then
                -- Need to OR TLAST across decimation period
                cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1) or
                                        main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id)-1)(ci_tuser_dly_width-1);
              -- end if;
            elsif C_DATA_HAS_TLAST = ci_vector_tlast and C_NUM_CHANNELS>1 then
              cascade_dly(0).tlast <= '0';
              if ip_chan_cnt_dly = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            if not ci_fixed_chan_pat and chan_id=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then
              -- Need to clear regressor vector, pattern change
              prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            end if;
            
            -- if C_FILTER_TYPE = ci_halfband_decimation then
              -- Shift ptr to allign with correct phase.
              main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
            -- end if;
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
          end if;
          
        --------------------------------------------------------------------------------------
        when ci_halfband_interpolation =>
        --------------------------------------------------------------------------------------
        
          update_cnfg <= true;
          get_new_data <= false;
          
          ip_px_rdy_set_src := false;
          ip_px_rdy_clr     := false;
          
          if ip_px_rdy and ipbuff_ready then
            get_new_data <= true;
            if ci_fir_properties.px_time > 1 then
              -- ip_px_rdy    <= false;
              ip_px_rdy_clr := true;
            end if;
            ip_px_cnt_en <= true;
          elsif ip_px_cnt = ci_fir_properties.px_time-1 then
            ip_px_cnt_en <= false;
          end if;
          
          if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
            -- ip_px_rdy    <= true;
            ip_px_rdy_set_src := true;
          end if;
          
          ip_px_cnt_max <= false;
          if ci_fir_properties.px_time > 1 then
            if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
              ip_px_cnt_max <= true;
            end if;
          else
            ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          end if;
          
          if ip_px_cnt_en then
            if ip_px_cnt = ci_fir_properties.px_time-1 then
              ip_px_cnt    <= 0;
              if ip_chan_cnt = C_NUM_CHANNELS-1 then
                ip_chan_cnt <= 0;
              else
                ip_chan_cnt <= ip_chan_cnt +1;
              end if;
            else
              ip_px_cnt <= ip_px_cnt + 1;
            end if;
          end if;
          
          -- Need to delay the assertion of ip_px_rdy
          prc_dly(ip_px_rdy_set_src,ip_px_rdy_dly,ip_px_rdy_set);
          
          if ip_px_rdy_set then
            ip_px_rdy    <= true;
          elsif ip_px_rdy_clr then
            ip_px_rdy    <= false;
          end if;
          
          -- Delay the control ------------------------------------------------ 
          --   by the cnfg_and_reload latency to allign with fsel and chanpat
          prc_dly(get_new_data,push_buffer_dly,push_buffer);
          prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(ipbuff_out,buff_out_dly,ipbuff_out_dly);
          prc_dly(ip_px_cnt = ci_fir_properties.px_time-1 and ip_chan_cnt = C_NUM_CHANNELS - 1,
                  start_op_dly,start_op);
          
          -- Event i/f --------------------------------------------------------
          if get_new_data then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
          end if;
          
          -- Push main buffer -------------------------------------------------
          if push_buffer then
            
            if ip_chan_cnt_dly = 0 and chanpat_updated then
              current_chan_pat := chanpat;
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  --ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                  std_logic_vector(to_unsigned(0,ci_tuser_dly_width)),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
            -- Insert interpolation 0
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  std_logic_vector(to_unsigned(0,ci_data_width_concat)),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  false);
          end if;
          
          -- Output control ---------------------------------------------------
          --  Simulates the effect of the re-ordering output buffer
          if start_op then
            output_chan_pat <= current_chan_pat;
            op_px_cnt_en <= true;
          elsif op_px_cnt_max and op_chan_cnt = 2 * C_NUM_CHANNELS - 1 then
            op_px_cnt_en <= false;
          end if;
          
          op_px_cnt_max <= false;
          if ci_fir_properties.op_px_time > 1 then
            if op_px_cnt = ci_fir_properties.op_px_time-2 and op_px_cnt_en then
              op_px_cnt_max <= true;
            end if;
          else
            op_px_cnt_max <= true;
          end if;
          
          if op_px_cnt_en then
            if op_px_cnt = ci_fir_properties.op_px_time-1 then
              op_px_cnt    <= 0;
              if op_chan_cnt = 2 * C_NUM_CHANNELS-1 then
                op_chan_cnt <= 0;
              else
                op_chan_cnt <= op_chan_cnt +1;
              end if;
            else
              op_px_cnt <= op_px_cnt + 1;
            end if;
          end if;
          
          if ci_fixed_chan_pat then
            chan_id := op_chan_cnt mod C_NUM_CHANNELS;
          else
            chan_id := ci_chan_pat(output_chan_pat*ci_pat_len + (op_chan_cnt mod C_NUM_CHANNELS));
          end if;
          
          if ci_fir_properties.op_px_time = 1 then
            gen_op := op_px_cnt_en;
          else
            gen_op := op_px_cnt_max;
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid               <= false;
          
          if gen_op then
            
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; 
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_m_tuser_user_width-1 downto 0);
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
            elsif C_DATA_HAS_TLAST = ci_vector_tlast then
              cascade_dly(0).tlast <= '0';
              if (op_chan_cnt mod C_NUM_CHANNELS) = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            if not ci_fixed_chan_pat and (op_chan_cnt mod C_NUM_CHANNELS)=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then -- chan_id
              -- Need to clear regressor vector, pattern change
              prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            end if;
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
          end if;
        
        --------------------------------------------------------------------------------------
        when ci_polyphase_decimation =>
        --------------------------------------------------------------------------------------
          -- update_cnfg <= true;
          get_new_data <= false;
          
          if ip_px_rdy and ipbuff_ready then
            get_new_data <= true;
            if ci_fir_properties.px_time > 1 then
              ip_px_rdy    <= false;
            end if;
            ip_px_cnt_en <= true;
          elsif ip_px_cnt = ci_fir_properties.px_time-1 then
            ip_px_cnt_en <= false;
          end if;
          
          if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
            ip_px_rdy    <= true;
          end if;
          
          ip_px_cnt_max <= false;
          if ci_fir_properties.px_time > 1 then
            if ip_px_cnt = ci_fir_properties.px_time-2 and ip_px_cnt_en then
              ip_px_cnt_max <= true;
            end if;
          else
            ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          end if;
          
          -- Only fetch configs on first phase
          -- update_cnfg <= false;
          if ip_px_cnt_max and ip_chan_cnt = C_NUM_CHANNELS-1 then
            update_cnfg <= false;
            if ip_phase_cnt = C_DECIM_RATE - 1 then
              update_cnfg <= true;
            end if;
          end if;
          
          if ip_px_cnt_en then
            if ip_px_cnt = ci_fir_properties.px_time-1 then
              ip_px_cnt    <= 0;
              if ip_chan_cnt = C_NUM_CHANNELS-1 then
                ip_chan_cnt <= 0;
                if ip_phase_cnt = C_DECIM_RATE - 1 then
                  ip_phase_cnt <= 0;
                else
                  ip_phase_cnt <= ip_phase_cnt + 1;
                end if;
              else
                ip_chan_cnt <= ip_chan_cnt +1;
              end if;
            else
              ip_px_cnt <= ip_px_cnt + 1;
            end if;
          end if;
          
          if C_M_DATA_HAS_TREADY = 0 and C_NUM_CHANNELS > 1 then
            
            -- Recreate ip_px_cnt_max for when C_OVERSAMPLING_RATE < ci_fir_properties.px_time
            -- but use the actual osr rate rate than input rate to reflect when the core will be
            -- generating base_max
            ip_px_cnt_max_actual <= false;
            if C_OVERSAMPLING_RATE > 1 then
              if ip_px_cnt = C_OVERSAMPLING_RATE-2 and ip_px_cnt_en then
                ip_px_cnt_max_actual <= true;
              end if;
            else
              ip_px_cnt_max_actual <= ip_px_rdy and ipbuff_ready;
            end if;
            
            -- Need to generate an output rate counter to produce evenly spaced outputs
            -- if ip_px_cnt_max and ip_phase_cnt = C_DECIM_RATE-1 and ip_chan_cnt=0 then
            -- if ((C_OVERSAMPLING_RATE < ci_fir_properties.px_time and ip_px_cnt_max_actual) or
                -- (C_OVERSAMPLING_RATE = ci_fir_properties.px_time and ip_px_cnt_max)) and
               -- ip_phase_cnt = C_DECIM_RATE-1 and ip_chan_cnt=0 then
              -- op_px_cnt_en <= true;
            -- elsif op_px_cnt = C_OUTPUT_RATE-1 and op_chan_cnt = C_NUM_CHANNELS -1 then
              -- op_px_cnt_en <= false;
            -- end if;
            
            -- Count the number of last phase samples that have to be output
            if ((C_OVERSAMPLING_RATE < ci_fir_properties.px_time and ip_px_cnt_max_actual) or
                (C_OVERSAMPLING_RATE = ci_fir_properties.px_time and ip_px_cnt_max)) and
               ip_phase_cnt = C_DECIM_RATE-1 then
              ptr_temp := ptr_temp + 1;
            end if;
            
            -- if (((C_OVERSAMPLING_RATE < ci_fir_properties.px_time and ip_px_cnt_max_actual) or
                -- (C_OVERSAMPLING_RATE = ci_fir_properties.px_time and ip_px_cnt_max)) and
               -- ip_phase_cnt = C_DECIM_RATE-1) or
               -- (op_px_cnt = C_OUTPUT_RATE-1 and ptr_temp > 0) then
            if (not op_px_cnt_en and ptr_temp > 0) or
               (op_px_cnt = C_OUTPUT_RATE-1 and ptr_temp > 0) then
              op_px_cnt_en <= true;
              ptr_temp := ptr_temp - 1;
            elsif op_px_cnt = C_OUTPUT_RATE-1 then
              op_px_cnt_en <= false;
            end if;
            
            if op_px_cnt_en then
              if op_px_cnt = C_OUTPUT_RATE-1 then
                op_px_cnt <= 0;
                if op_chan_cnt = C_NUM_CHANNELS-1 then
                  op_chan_cnt <= 0;
                else
                  op_chan_cnt <= op_chan_cnt + 1;
                end if;
              else
                op_px_cnt <= op_px_cnt + 1;
              end if;
            end if;
            
          end if;
          
          -- Delay the control ------------------------------------------------ 
          --   by the cnfg_and_reload latency to allign with fsel and chanpat
          prc_dly(get_new_data,push_buffer_dly,push_buffer);
          prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(ipbuff_out,buff_out_dly,ipbuff_out_dly);
          
          prc_dly(op_chan_cnt,op_chan_cnt_dly,gen_op_chan_cnt); -- hyjack variable
          
          if C_M_DATA_HAS_TREADY = 0 and C_NUM_CHANNELS > 1 then
            prc_dly(op_px_cnt=0 and op_px_cnt_en,gen_op_dly,gen_op);
          else
            prc_dly(ip_px_cnt_max and ip_phase_cnt = C_DECIM_RATE-1,gen_op_dly,gen_op);
          end if;
          
          -- Event i/f --------------------------------------------------------
          if get_new_data then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
          end if;
          
          -- Push main buffer -------------------------------------------------
          if push_buffer then
            -- report "i_fir: polyphase_decimation: push buffer";
            
            if ip_chan_cnt_dly = 0 and chanpat_updated then
              current_chan_pat := chanpat;
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid                   <= false;
          
          if gen_op then
            if C_M_DATA_HAS_TREADY = 0 and C_NUM_CHANNELS > 1 then
              chan_id := gen_op_chan_cnt;
            else
              chan_id := ip_chan_cnt_dly;
            end if;
            
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- report "i_fir: polyphase_decimation: gen op: main_buffer_ptrs(chan_id): "&integer'image(main_buffer_ptrs(chan_id));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; -- watch using chan_id here, should be a delay version of ip_chan_cnt allign with gen_op incase there is a difference
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_m_tuser_user_width-1 downto 0);
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              -- cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
              -- Need to OR TLAST across decimation period
              -- cascade_dly(0).tlast <= '0';
              v_tlast_ored := '0';
              for phase in 0 to C_DECIM_RATE-1 loop
                v_tlast_ored := v_tlast_ored or main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id)-phase)(ci_tuser_dly_width-1);
              end loop;
              cascade_dly(0).tlast <= v_tlast_ored;
              
            elsif C_DATA_HAS_TLAST = ci_vector_tlast then
              cascade_dly(0).tlast <= '0';
              if chan_id = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            -- if not ci_fixed_chan_pat and chan_id=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then
              -- -- Need to clear regressor vector, pattern change
              -- prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            -- end if;
            
            -- Shift ptr to allign with correct phase.
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - (C_DECIM_RATE-1);
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
          end if;
        
        --------------------------------------------------------------------------------------
        when ci_decimation =>
        --------------------------------------------------------------------------------------
          update_cnfg <= true;
          v_get_new_data := false;
          
          -- FIFO to data vector control
          -- if ip_px_rdy and ipbuff_ready then
            -- get_new_data <= true;
          -- end if;
          
          v_ip_write := ip_px_rdy and ipbuff_ready;
          v_ip_read  := op_chan_cnt=C_NUM_CHANNELS-1 and op_px_cnt=ci_fir_properties.px_time-1;
          
          if v_ip_write and v_ip_read then
            ip_px_cnt <= ip_px_cnt + 1 - (v_new_samples_for_next_op*C_NUM_CHANNELS);
            ip_px_rdy <= true;
          elsif v_ip_write and not v_ip_read then
            ip_px_cnt <= ip_px_cnt + 1; -- re-use variable to track how many samples transferred
            if ip_px_cnt = (2*ci_deci_max_ips_per_op*C_NUM_CHANNELS)-1 then
              ip_px_rdy <= false;
            else
              ip_px_rdy <= true;
            end if;
          elsif not v_ip_write and v_ip_read then
            ip_px_cnt <= ip_px_cnt - (v_new_samples_for_next_op*C_NUM_CHANNELS);
            ip_px_rdy <= true;
          end if;
          
          -- Generate output control
          v_get_new_data := false;
          if not op_px_cnt_en then -- start up from idle
            if v_ip_write and ip_px_cnt >=(v_new_samples_for_op*C_NUM_CHANNELS)-1 then
              op_px_cnt_en <= true;
              v_get_new_data := true;
            end if;
          else
            if v_ip_read then -- about to finish processing
              if v_ip_write and ip_px_cnt >=((v_new_samples_for_op+v_new_samples_for_next_op)*C_NUM_CHANNELS)-1 then
                op_px_cnt_en <= true;
                v_get_new_data := true;
              elsif ip_px_cnt >=((v_new_samples_for_op+v_new_samples_for_next_op)*C_NUM_CHANNELS) then
                op_px_cnt_en <= true;
                v_get_new_data := true;
              else
                op_px_cnt_en <= false;
              end if;
            end if;
          end if;
          get_new_data <= v_get_new_data or (op_px_cnt = ci_fir_properties.px_time-1 and op_chan_cnt /= C_NUM_CHANNELS-1); -- Only used to sync cnfg reads
          
          if op_px_cnt_en then
            if op_px_cnt = ci_fir_properties.px_time-1 then
              op_px_cnt <= 0;
              if op_chan_cnt = C_NUM_CHANNELS-1 then
                op_chan_cnt <= 0;
              else
                op_chan_cnt <= op_chan_cnt + 1;
              end if;
            else
              op_px_cnt <= op_px_cnt + 1;
            end if;
          end if;
          
          -- Generate v_new_samples_for_op
          if v_ip_read and C_INTERP_RATE> 1 then -- end of processing
            v_new_samples_for_op := v_new_samples_for_next_op;
            
            v_phase_cnt := (v_phase_cnt + (v_new_samples_for_next_op*C_INTERP_RATE)) mod C_DECIM_RATE;
            
            if v_phase_cnt+(ci_deci_min_ips_per_op*C_INTERP_RATE)>=C_DECIM_RATE then
              v_new_samples_for_next_op := ci_deci_min_ips_per_op;
            else
              v_new_samples_for_next_op := ci_deci_max_ips_per_op;
            end if;
          end if;
          
          -- Event i/f --------------------------------------------------------
          --   Use ip_chan_cnt for checking only, as it is not used by this structure
          if v_ip_write_dly then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
            if ip_chan_cnt = C_NUM_CHANNELS-1 then
              ip_chan_cnt <= 0;
            else
              ip_chan_cnt <= ip_chan_cnt + 1;
            end if;
          end if;
          
          -- Input buffer -----------------------------------------------------
          --   Addition input buffer to store data transferred from the fifo before
          --   it is written into data vector
          if v_ip_write_dly then
            ip_store(buff_ptr_in)(ipbuff_out'RANGE) := ipbuff_out;
            buff_ptr_in := (buff_ptr_in + 1) mod ci_ip_store_depth;
          end if;
          v_ip_write_dly := v_ip_write; -- allign with fifo output
          
          -- Generate TLAST ored for the output we're about to generate
          -- NOTE: Was seeing funny effects I think due to using a variable
          --       The variable was being set but tlast_ored wasn't taking it's
          --       value like it had been updated twice between clk cycles!
          -- v_tlast_ored := '0';
          -- if v_get_new_data then
          tlast_ored <= false;
          if get_new_data and op_chan_cnt = 0 then
            for i in 0 to v_new_samples_for_op*C_NUM_CHANNELS-1 loop
              if ip_store((buff_ptr_tlast+i) mod ci_ip_store_depth)(s_s_tlast)="1" then
                -- v_tlast_ored := '1';
                tlast_ored <= true;
              end if;
            end loop;
            buff_ptr_tlast := (buff_ptr_tlast + v_new_samples_for_op*C_NUM_CHANNELS) mod ci_ip_store_depth;
          end if;
          -- tlast_ored <= (v_tlast_ored='1');
          
          new_samples_for_op      <= v_new_samples_for_op;     
          new_samples_for_next_op <= v_new_samples_for_next_op;
          
          -- Delay the control ------------------------------------------------ 
          --   by the cnfg_and_reload latency to allign with fsel and chanpat
          prc_dly(get_new_data and op_chan_cnt=0,push_buffer_dly,push_buffer);
          prc_dly(op_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(op_px_cnt = ci_fir_properties.px_time-1,gen_op_dly,gen_op);
          prc_dly(new_samples_for_op,new_samples_for_op_dly,new_samples_for_op_out);
          prc_dly(new_samples_for_next_op,new_samples_for_next_op_dly,new_samples_for_next_op_out);
          
          -- Push main buffer -------------------------------------------------
          --   Push all the trasferred inputs into the data vector before procesing
          --   starts
          if push_buffer then
            
            for i in 0 to new_samples_for_op_out*C_NUM_CHANNELS-1 loop
              push_chan_cnt := i mod C_NUM_CHANNELS;
              
              -- Fetch data from store
              ipbuff_out_dly := ip_store(buff_ptr_out)(ipbuff_out'RANGE);
              buff_ptr_out := (buff_ptr_out + 1) mod ci_ip_store_depth;
              
              if push_chan_cnt = 0 and chanpat_updated then
                current_chan_pat := chanpat;
              end if;
              
              if ci_fixed_chan_pat then
                chan_id := push_chan_cnt;
              else
                chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + push_chan_cnt);
              end if;
              
              ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
              
              prc_push_main_buffer( chan_id,
                                    main_buffer_ptrs,
                                    main_buffer,
                                    ipbuff_out_dly(s_s_tdata),
                                    fn_select_slv(
                                      ipbuff_tuser(s_s_tuser_user),
                                      ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                      C_DATA_HAS_TLAST = ci_pass_tlast),
                                    fsel,
                                    current_chan_pat,
                                    chanpat_updated and i=0);
              if C_INTERP_RATE > 1 then
                -- Insert interpolation 0's
                for j in 0 to C_INTERP_RATE-2 loop
                  prc_push_main_buffer( chan_id,
                                        main_buffer_ptrs,
                                        main_buffer,
                                        std_logic_vector(to_unsigned(0,ci_data_width_concat)),
                                        -- ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                        -- '0'&ipbuff_tuser(s_s_tuser_user),
                                        fn_select_slv(
                                          ipbuff_tuser(s_s_tuser_user),
                                          '0'&ipbuff_tuser(s_s_tuser_user),
                                          C_DATA_HAS_TLAST = ci_pass_tlast),
                                        -- Don't want TLAST to contribute to multiple outputs
                                        fsel,
                                        current_chan_pat,
                                        false);
                end loop;
              end if;
            end loop;
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid                   <= false;
          
          if gen_op then
            
            -- push increments through all channels so need to generate a fresh chan_id
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; -- watch using chan_id here, should be a delay version of ip_chan_cnt allign with gen_op incase there is a difference
            ptr_temp := main_buffer_ptrs(chan_id);
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser( ptr_temp )(ci_m_tuser_user_width-1 downto 0);
            end if;
            -- Need to modify the value taken for TUSER when the first sample to be used for the next output
            -- is an interpolated value. TUSER is taken from the first new input sample that contributes to the
            -- next output.
            if C_INTERP_RATE > 1 then
              -- A bit unsure about this but try it out
              -- Trying to detect when the ptr is pointing to a interpolated value
              if (main_buffer_ptrs(chan_id) + 1) rem C_INTERP_RATE > 0 then
                ptr_temp := ((main_buffer_ptrs(chan_id)+1)/C_INTERP_RATE)*C_INTERP_RATE-1;
                cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(ptr_temp)(ci_m_tuser_user_width-1 downto 0);  
              end if;
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              -- cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
              -- Need to OR TLAST across decimation period
              -- cascade_dly(0).tlast <= '0';
              v_tlast_ored := '0';
              for phase in 0 to new_samples_for_op-1 loop
                v_tlast_ored := v_tlast_ored or main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id)-phase)(ci_tuser_dly_width-1);
              end loop;
              cascade_dly(0).tlast <= v_tlast_ored;
              
            elsif C_DATA_HAS_TLAST = ci_vector_tlast then
              cascade_dly(0).tlast <= '0';
              if ip_chan_cnt_dly = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            if not ci_fixed_chan_pat and chan_id=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then
              -- Need to clear regressor vector, pattern change
              prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            end if;
            
            -- Shift ptr to allign with correct phase.
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - (C_DECIM_RATE-1);
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - 1;
          end if;
        --------------------------------------------------------------------------------------
        when ci_polyphase_interpolation =>
        --------------------------------------------------------------------------------------
          update_cnfg <= true;
          get_new_data <= false;
          
          ip_px_rdy_set_src := false;
          ip_px_rdy_clr     := false;
          
          if ip_px_rdy and ipbuff_ready then
            get_new_data <= true;
            -- if (v_op_samples_for_ip*ci_fir_properties.px_time) > 1 and
               -- not(C_DECIM_RATE>1 and ( (ip_px_cnt_en and v_op_samples_for_next_ip*ci_fir_properties.px_time = 1) or
                                        -- (not ip_px_cnt_en and v_op_samples_for_ip*ci_fir_properties.px_time = 1 ) ))then
              -- -- ip_px_rdy    <= false;
              -- ip_px_rdy_clr := true;
            -- end if;
            if not(C_DECIM_RATE>1 and ( (ip_px_cnt_en and v_op_samples_for_next_ip*ci_fir_properties.px_time = 1) or
                                        (not ip_px_cnt_en and v_op_samples_for_ip*ci_fir_properties.px_time = 1 ) ))then
              ip_px_rdy_clr := true;
            end if;
            ip_px_cnt_en <= true;
          elsif ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-1 then
            ip_px_cnt_en <= false;
          end if;
          
          if ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-2 and ip_px_cnt_en then
            -- ip_px_rdy    <= true;
            ip_px_rdy_set_src := true;
          end if;
          
          -- if C_M_DATA_HAS_TREADY=1 then
            -- Need to delay processing rate
            -- NOTE: Need to always delay px rate
            prc_dly(ip_px_rdy_set_src,ip_px_rdy_dly,ip_px_rdy_set);
          -- else
            -- ip_px_rdy_set := ip_px_rdy_set_src;
          -- end if;
          
          if ip_px_rdy_set then
            ip_px_rdy    <= true;
          elsif ip_px_rdy_clr then
            ip_px_rdy    <= false;
          end if;
          
          -- ip_px_cnt_max <= false;
          -- if C_DECIM_RATE>1 and (v_op_samples_for_next_ip*ci_fir_properties.px_time = 1) then
            -- ip_px_cnt_max <= ip_px_cnt_en;
          -- else --if (v_op_samples_for_ip*ci_fir_properties.px_time) > 1 then -- NOT SURE ABOUT THIS ** ONLY AN ISSUE IN FRACTIONAL
            -- if ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-2 and ip_px_cnt_en then
              -- ip_px_cnt_max <= true;
            -- end if;
          -- end if;
          
          -- if ip_px_cnt_en then
            -- ip_px_cnt_max <= false;
            -- if C_DECIM_RATE>1 and (( (v_op_samples_for_next_ip*ci_fir_properties.px_time = 1) and ip_px_cnt_max and ip_chan_cnt = C_NUM_CHANNELS-1) or
                                    -- (v_op_samples_for_ip*ci_fir_properties.px_time =1 ) ) then
              -- -- ip_px_cnt_max <= true;
              -- ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
            -- elsif ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-2 and (v_op_samples_for_ip*ci_fir_properties.px_time) > 1 then
              -- ip_px_cnt_max <= true;
            -- end if;
          -- end if;
          ip_px_cnt_max <= false;
          if C_DECIM_RATE>1 and (( (v_op_samples_for_next_ip*ci_fir_properties.px_time = 1) and ip_px_cnt_max and ip_chan_cnt = C_NUM_CHANNELS-1) or
                                  (v_op_samples_for_ip*ci_fir_properties.px_time =1 ) ) then
            -- ip_px_cnt_max <= true;
            ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          elsif ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-2 and (v_op_samples_for_ip*ci_fir_properties.px_time) > 1  and ip_px_cnt_en then
            ip_px_cnt_max <= true;
          end if;
          
          -- else
            -- ip_px_cnt_max <= ip_px_rdy and ipbuff_ready;
          -- end if;
          
          if ip_px_cnt_en then
            if ip_px_cnt = (v_op_samples_for_ip*ci_fir_properties.px_time)-1 then
              ip_px_cnt    <= 0;
              if ip_chan_cnt = C_NUM_CHANNELS-1 then
                ip_chan_cnt <= 0;
              else
                ip_chan_cnt <= ip_chan_cnt +1;
              end if;
            else
              ip_px_cnt <= ip_px_cnt + 1;
            end if;
          end if;
          
          -- Generate output control
          --   Buffer for multi-channel
          if C_NUM_CHANNELS=1 and (C_SYMMETRY=ci_non_symmetric or (C_INTERP_RATE=2 and ci_fir_properties.odd_symmetry=1)) then
            -- v_op_px_cnt_max_sel := op_px_cnt_max;
            -- No buffer
            -- if (ip_px_cnt mod ci_fir_properties.px_time) = ci_fir_properties.px_time - 1 then
            -- if get_new_data then
              -- op_px_cnt_en <= true;
              -- v_op_samples_for_ip_out := v_op_samples_for_ip;
            -- elsif v_op_px_cnt_max_sel and op_phase_cnt = v_op_samples_for_ip_out -1 then
              -- op_px_cnt_en <= false;
            -- end if;
            v_gen_op_src :=false;
            if ci_fir_properties.px_time = 1 then
              v_gen_op_src := ip_px_cnt_en;
            elsif (ip_px_cnt mod ci_fir_properties.px_time) = ci_fir_properties.px_time - 1 then
              v_gen_op_src := true;
            end if;
            gen_op_chan_cnt_src     := ip_chan_cnt;
            v_op_samples_for_ip_sel := v_op_samples_for_ip;
            v_op_phase_cnt_sel      := (ip_px_cnt / ci_fir_properties.px_time);
          else
            -- Output buffer
            -- if C_M_DATA_HAS_TREADY = 1 then
              -- -- Output fifo, read op buffer at full speed
              -- v_op_px_cnt_max_sel := op_px_cnt_en;
            -- else
              -- Const rate output
              if ci_fir_properties.px_time = 1 then
                v_op_px_cnt_max_sel := op_px_cnt_en;
              else
                v_op_px_cnt_max_sel := op_px_cnt_max;
              end if;
            -- end if;
            -- See comments in core re ci_opbuff_oprate
            
            if ip_px_cnt_max and ip_chan_cnt = C_NUM_CHANNELS-1 then
             -- if get_new_data and ip_chan_cnt = C_NUM_CHANNELS-1 then 
              op_px_cnt_en <= true;
              v_op_samples_for_ip_out := v_op_samples_for_ip;
            elsif v_op_px_cnt_max_sel and op_chan_cnt = C_NUM_CHANNELS-1 and op_phase_cnt >= v_op_samples_for_ip_out -1 then
              op_px_cnt_en <= false;
            end if;
            
            if op_px_cnt_en  then
              if v_op_px_cnt_max_sel then
                op_px_cnt <= 0;
                if op_chan_cnt = C_NUM_CHANNELS-1 then
                  op_chan_cnt <= 0;
                  if op_phase_cnt >= v_op_samples_for_ip_out -1 then
                    -- Adding the greater than is a bit of a frig to get round
                    -- an issue with the fractional implementation where v_op_samples_for_ip_out
                    -- will change to the next set of output puts before the current output cnt
                    -- has completed
                    -- The same is done above for op_px_cnt_en
                    op_phase_cnt <= 0;
                  else
                    op_phase_cnt <= op_phase_cnt + 1;
                  end if;
                else
                  op_chan_cnt <= op_chan_cnt + 1;
                end if;
              else
                op_px_cnt <= op_px_cnt + 1;
              end if;
            end if;
            
            op_px_cnt_max <= false;
            if op_px_cnt = C_OUTPUT_RATE-2 and op_px_cnt_en then
              op_px_cnt_max <= true;
            end if;
            
            v_gen_op_src        := v_op_px_cnt_max_sel;
            gen_op_chan_cnt_src := op_chan_cnt;
            v_op_samples_for_ip_sel := v_op_samples_for_ip_out;
            v_op_phase_cnt_sel      := op_phase_cnt;
          end if;
          
          
          -- Calcuate the next op_samples_for_ip
          --   Taken from ci_decimation
          if ip_px_cnt_en and ip_px_cnt_max and ip_chan_cnt = C_NUM_CHANNELS-1 and C_DECIM_RATE>1 then
            v_op_samples_for_ip := v_op_samples_for_next_ip;
            
            v_phase_cnt := (v_phase_cnt + (v_op_samples_for_next_ip*C_DECIM_RATE)) mod C_INTERP_RATE;
            
            if v_phase_cnt+(ci_inter_min_ops_per_ip*C_DECIM_RATE)>=C_INTERP_RATE then
              v_op_samples_for_next_ip := ci_inter_min_ops_per_ip;
            else
              v_op_samples_for_next_ip := ci_inter_max_ops_per_ip;
            end if;
            
          end if;
          
          -- Delay the control ------------------------------------------------ 
          --   by the cnfg_and_reload latency to allign with fsel and chanpat
          -- prc_dly(ip_px_cnt_max,gen_op_dly,gen_op);
          prc_dly(get_new_data,push_buffer_dly,push_buffer);
          prc_dly(v_gen_op_src,gen_op_dly,gen_op);
          prc_dly(ip_chan_cnt,chan_cnt_dly,ip_chan_cnt_dly);
          prc_dly(ipbuff_out,buff_out_dly,ipbuff_out_dly);
          
          prc_dly(gen_op_chan_cnt_src,op_chan_cnt_dly,gen_op_chan_cnt);
          prc_dly(v_op_samples_for_ip_sel,ops_for_ip_dly,ops_for_ip);
          prc_dly(v_op_phase_cnt_sel,op_phase_cnt_dly,gen_op_phase_cnt);
          
          -- Event i/f --------------------------------------------------------
          if get_new_data then
            if C_DATA_HAS_TLAST = ci_vector_tlast then
              if ipbuff_out(s_s_tlast) = "1" and ip_chan_cnt /= C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '1';
              elsif ipbuff_out(s_s_tlast) = "0" and ip_chan_cnt = C_NUM_CHANNELS-1 then
                event_s_data_tlast_missing    <= '1';   
                event_s_data_tlast_unexpected <= '0';
              else
                event_s_data_tlast_missing    <= '0';   
                event_s_data_tlast_unexpected <= '0';
              end if;
            end if;
            if C_S_DATA_HAS_TUSER = ci_chanid_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              event_s_data_chanid_incorrect <= '0';
              ipbuff_tuser := ipbuff_out(s_s_tuser);
              if ip_chan_cnt /= to_integer(unsigned(ipbuff_tuser(s_s_tuser_chanid))) then
                event_s_data_chanid_incorrect <= '1';
              end if;
            end if;
          end if;
          
          -- Push main buffer -------------------------------------------------
          if push_buffer then
            
            if ip_chan_cnt_dly = 0 and chanpat_updated then
              current_chan_pat := chanpat;
              output_chan_pat <= chanpat; -- Use to pass chanpat to gen_op condition
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := ip_chan_cnt_dly;
            else
              chan_id := ci_chan_pat(current_chan_pat*ci_pat_len + ip_chan_cnt_dly);
            end if;
            
            ipbuff_tuser := ipbuff_out_dly(s_s_tuser);
            
            prc_push_main_buffer( chan_id,
                                  main_buffer_ptrs,
                                  main_buffer,
                                  ipbuff_out_dly(s_s_tdata),
                                  fn_select_slv(
                                    ipbuff_tuser(s_s_tuser_user),
                                    ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                    C_DATA_HAS_TLAST = ci_pass_tlast),
                                  fsel,
                                  current_chan_pat,
                                  chanpat_updated);
            -- Insert interpolation  zeros
            --   TUSER and TLAST are duplicated over interpolated results
            --   AXI interface specifies they will only be output of the sample
            --   sample of an interpolated block. This will be controlled at output
            --   generation. This is to support fractional interpolation where only 
            --   some of the interpolated values will be output, due to the decimation
            for i in 0 to C_INTERP_RATE-2 loop
              prc_push_main_buffer( chan_id,
                                        main_buffer_ptrs,
                                        main_buffer,
                                        std_logic_vector(to_unsigned(0,ci_data_width_concat)),
                                        fn_select_slv(
                                          ipbuff_tuser(s_s_tuser_user),
                                          ipbuff_out_dly(s_s_tlast)&ipbuff_tuser(s_s_tuser_user),
                                          C_DATA_HAS_TLAST = ci_pass_tlast),
                                        fsel,
                                        current_chan_pat,
                                        false);
            end loop;
          end if;
          
          -- Cascade dly ------------------------------------------------------
          cascade_dly(1 to cascade_dly'HIGH) <= cascade_dly(0 to cascade_dly'HIGH-1);
          cascade_dly(0).valid                   <= false;
          
          if gen_op then
            
            if gen_op_chan_cnt = 0 and gen_op_phase_cnt = 0 then
              current_op_chan_pat := output_chan_pat;--current_chan_pat;-- delayed verions to mot overwritten
            end if;
            
            if ci_fixed_chan_pat then
              chan_id := gen_op_chan_cnt;
            else
              chan_id := ci_chan_pat(current_op_chan_pat*ci_pat_len + gen_op_chan_cnt);
            end if;
            
            -- Fetch filter set
            coeff_set := coeff_sets(main_buffer(0,chan_id).fsel(main_buffer_ptrs(chan_id)));
            
            -- Generate side-band data
            cascade_dly(0).valid   <= true;
            cascade_dly(0).chan_id <= chan_id; -- watch using chan_id here, should be a delay version of ip_chan_cnt allign with gen_op incase there is a difference
            if C_S_DATA_HAS_TUSER = ci_user_tuser or C_S_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
              if gen_op_phase_cnt = ops_for_ip-1 then
                cascade_dly(0).tuser <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_m_tuser_user_width-1 downto 0);
              else
                cascade_dly(0).tuser <= (others=>'0');
              end if;
            end if;
            if C_DATA_HAS_TLAST = ci_pass_tlast then
              if gen_op_phase_cnt = ops_for_ip-1 then
                cascade_dly(0).tlast <= main_buffer(0,chan_id).tuser(main_buffer_ptrs(chan_id))(ci_tuser_dly_width-1);
              else
                cascade_dly(0).tlast <='0';
              end if;
            elsif C_DATA_HAS_TLAST = ci_vector_tlast then
              cascade_dly(0).tlast <= '0';
              if gen_op_chan_cnt = C_NUM_CHANNELS-1 then
                cascade_dly(0).tlast <= '1';
              end if;
            end if;
            
            if not ci_fixed_chan_pat and chan_id=0 and main_buffer(0,chan_id).chanpat_updated(main_buffer_ptrs(chan_id)) then
              -- Need to clear regressor vector, pattern change
              prc_flush_main_buffer(main_buffer_ptrs,main_buffer);
            end if;
            
            -- Filter calculation
            for path in 0 to ci_num_paths-1 loop
              data_slice := main_buffer(path,chan_id).data(main_buffer_ptrs(chan_id) to main_buffer_ptrs(chan_id)+ci_fir_properties.full_taps-1);
              
              cascade_dly(0).result(path) <= fir_select(
                                               coeff_set,
                                               data_slice,
                                               ci_fir_properties.full_taps,
                                               C_ZERO_PACKING_FACTOR,
                                               C_COEF_WIDTH,
                                               ci_accum_width,
                                               C_OUTPUT_WIDTH);
            end loop;
            main_buffer_ptrs(chan_id) := main_buffer_ptrs(chan_id) - C_DECIM_RATE;
          end if;
          
        when others =>
          report "FIR Compiler : Invalid filter type" severity failure;
        end case;
      end if;
    end if;
  end process i_fir;
  
  -- O/P buffer --------------------------------------------------------------------------------------------------------
  g_opbuff : if C_M_DATA_HAS_TREADY = 1 generate
    i_opbuff : process(clk)
      variable v_opbuff_in : std_logic_vector(s_m_tlast'HIGH downto 0);
      variable v_tuser     : std_logic_vector(ci_m_tuser_width-1 downto 0) := (others=>'0');
      variable v_read      : boolean;
    begin
      if (rising_edge(clk)) then
        -- if sclr_int='1' then
          -- opbuff_ptr    <= -1;
          -- -- opbuff_out    <= (others=>'0');
          -- opbuff_rdy    <= false;
          -- m_data_tvalid <= '0';
        -- -- elsif ce_int='1' then
        -- else
          
          -- Merge all signals into single bus
          for path in 0 to ci_num_paths-1 loop
            v_opbuff_in(s_m_tdata)((path+1)*C_OUTPUT_WIDTH-1 downto path*C_OUTPUT_WIDTH) := cascade_dly(cascade_dly'HIGH).result(path);
          end loop;
          if C_DATA_HAS_TLAST /= ci_no_tlast then
            v_opbuff_in(s_m_tlast)    := (0=> cascade_dly(cascade_dly'HIGH).tlast);
          end if;
          if C_M_DATA_HAS_TUSER = ci_chanid_tuser or
             C_M_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
             v_tuser(s_m_tuser_chanid) := std_logic_vector(to_unsigned(cascade_dly(cascade_dly'HIGH).chan_id,ci_m_tuser_chanid_width));
          end if;
          if C_M_DATA_HAS_TUSER = ci_user_tuser or
             C_M_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser then
             v_tuser(s_m_tuser_user)   := cascade_dly(cascade_dly'HIGH).tuser;
          end if;
          v_opbuff_in(s_m_tuser)    := v_tuser;
          
          if not ci_fir_properties.opbuff_custom then
            -- Normal fifo operation
            
            v_read:= ((M_AXIS_DATA_TREADY='1') or m_data_tvalid='0') and (ce_int='1');
            
            prc_fifo( cascade_dly(cascade_dly'HIGH).valid and (ce_px='1'),--(back_throttle='0'),
                      v_read,--(M_AXIS_DATA_TREADY='1') or not opbuff_rdy,-- needs to be selective if no TREADY selected and use counter instead
                      v_opbuff_in,
                      opbuff,
                      opbuff_ptr,
                      opbuff_out,
                      opbuff_rdy,--,
                      opbuff_flag, -- unused
                      back_throttle,
                      ci_fir_properties.opbuff_thres );
                      
            if v_read then
              if opbuff_rdy then
                -- not empty and read, duplicate AXI utils v1.0 master fifo
                m_data_tvalid <= '1';
              else
                m_data_tvalid <= '0';
              end if;
            end if;
          end if;
          
          if sclr_int='1' then  
            -- The AXI fifo doesn't include the assignment to data out in the reset clause
            --  - so need to let the proc operate then reset the control.
            opbuff_ptr    <= -1;
            opbuff_rdy    <= false;
            m_data_tvalid <= '0';
            back_throttle <= '0';
          end if;
        -- end if;
      end if;
    end process i_opbuff;
    
    M_AXIS_DATA_TVALID <= m_data_tvalid;--'1' when opbuff_rdy else '0';
    M_AXIS_DATA_TDATA       <= fn_pad_axi_fields(ci_output_widths,opbuff_out(s_m_tdata),true);
    g_m_tlast : if C_DATA_HAS_TLAST/=ci_no_tlast generate
      M_AXIS_DATA_TLAST       <= opbuff_out(s_m_tlast)(s_m_tlast'HIGH);
    end generate g_m_tlast;
    g_m_tuser : if C_M_DATA_HAS_TUSER/=ci_no_tuser generate
      M_AXIS_DATA_TUSER       <= opbuff_out(s_m_tuser);
    end generate g_m_tuser;
  
  end generate g_opbuff;
  
  g_no_opbuff: if C_M_DATA_HAS_TREADY = 0 generate
    signal data        : std_logic_vector(s_m_tdata);
  begin
    
    g_data_paths : for path in 0 to ci_num_paths-1 generate
      data(s_m_tdata)((path+1)*C_OUTPUT_WIDTH-1 downto path*C_OUTPUT_WIDTH) <= cascade_dly(cascade_dly'HIGH).result(path);
    end generate g_data_paths;
    
    M_AXIS_DATA_TDATA  <= fn_pad_axi_fields(ci_output_widths,data,true);
    M_AXIS_DATA_TVALID <= '1' when cascade_dly(cascade_dly'HIGH).valid else '0';
    
    g_m_tlast : if C_DATA_HAS_TLAST/=ci_no_tlast generate
      M_AXIS_DATA_TLAST       <= cascade_dly(cascade_dly'HIGH).tlast;
    end generate g_m_tlast;
    
    g_tuser_chanid: if C_M_DATA_HAS_TUSER = ci_chanid_tuser or
                       C_M_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser generate
       M_AXIS_DATA_TUSER(s_m_tuser_chanid) <= std_logic_vector(to_unsigned(cascade_dly(cascade_dly'HIGH).chan_id,ci_m_tuser_chanid_width));
    end generate g_tuser_chanid;
    g_tuser_user : if C_M_DATA_HAS_TUSER = ci_user_tuser or
                   C_M_DATA_HAS_TUSER = ci_chanid_tuser + ci_user_tuser generate
       M_AXIS_DATA_TUSER(s_m_tuser_user)   <= cascade_dly(cascade_dly'HIGH).tuser;
    end generate g_tuser_user;
    
  end generate g_no_opbuff;
  
  -- Event i/f ---------------------------------------------------------------------------------------------------------
  
  
end;

