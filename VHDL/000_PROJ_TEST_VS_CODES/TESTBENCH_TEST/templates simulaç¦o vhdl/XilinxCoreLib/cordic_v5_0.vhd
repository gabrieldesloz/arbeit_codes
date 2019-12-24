-------------------------------------------------------------------------------
-- $Id: cordic_v5_0_xst.vhd,v 1.9 2011/06/15 09:51:28 gordono Exp $
-------------------------------------------------------------------------------
--  (c) Copyright 2006-2008, 2011 Xilinx, Inc. All rights reserved.
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
-- Function :  Top level of CORDIC Module 
--------------------------------------------------------------------------------
-- In this version, the previous top level cordic_v4_0_xst has become
-- cordic_v5_0_synth. This file, cordic_v5_0_xst is now a wrapper for the old
-- core so as to contain and map the new AXI4-Stream interfaces to the legacy
-- pins. See spec/cordic_v5_0_axi_proposal.docx for a full description
-- of the AXI4 Stream interface channels, fields, subfields and behaviours.
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

--xbip_pipe is the one-size-fits-all wire-register-shiftreg/ram
--of any width and any latency from 0 to N
library xilinxcorelib;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;

library xilinxcorelib;
use xilinxcorelib.axi_utils_pkg_v1_1.all;
use xilinxcorelib.axi_utils_v1_1_comps.all;

library xilinxcorelib;
use xilinxcorelib.cordic_v5_0_pack.all;
use xilinxcorelib.cordic_v5_0_comps.all;

--core_if on entity cordic_v5_0
  entity cordic_v5_0 is
  generic (
    c_architecture                 : integer := 1;
    c_cordic_function              : integer := 0;
    c_coarse_rotate                : integer := 1;
    c_data_format                  : integer := 0;
    c_xdevicefamily                : string  := "virtex6";
    c_has_aclken                   : integer := 0;
    c_has_aclk                     : integer := 1;
    c_has_s_axis_cartesian         : integer := 1;
    c_has_s_axis_phase             : integer := 1;
    c_has_aresetn                  : integer := 0;
    c_input_width                  : integer := 32;
    c_iterations                   : integer := 32;
    c_output_width                 : integer := 32;
    c_phase_format                 : integer := 0;
    c_pipeline_mode                : integer := -2;
    c_precision                    : integer := 0;
    c_round_mode                   : integer := 2;
    c_scale_comp                   : integer := 0;
    c_throttle_scheme              : integer := 0;
    c_tlast_resolution             : integer := 0;
    c_has_s_axis_phase_tuser       : integer := 0;
    c_has_s_axis_phase_tlast       : integer := 0;
    c_s_axis_phase_tdata_width     : integer := 32;
    c_s_axis_phase_tuser_width     : integer := 1;
    c_has_s_axis_cartesian_tuser   : integer := 0;
    c_has_s_axis_cartesian_tlast   : integer := 0;
    c_s_axis_cartesian_tdata_width : integer := 64;
    c_s_axis_cartesian_tuser_width : integer := 1;
    c_m_axis_dout_tdata_width      : integer := 64;
    c_m_axis_dout_tuser_width      : integer := 1
    );
  port (
    aclk                           : in  std_logic                                                     := '1';
    aclken                         : in  std_logic                                                     := '1';
    aresetn                        : in  std_logic                                                     := '1';
    s_axis_phase_tvalid            : in  std_logic                                                     := '0';
    s_axis_phase_tready            : out std_logic                                                     := '0';
    s_axis_phase_tuser             : in  std_logic_vector(c_s_axis_phase_tuser_width - 1 downto 0)     := ( others => '0' );
    s_axis_phase_tlast             : in  std_logic                                                     := '0';
    s_axis_phase_tdata             : in  std_logic_vector(c_s_axis_phase_tdata_width - 1 downto 0)     := ( others => '0' );
    s_axis_cartesian_tvalid        : in  std_logic                                                     := '0';
    s_axis_cartesian_tready        : out std_logic                                                     := '0';
    s_axis_cartesian_tuser         : in  std_logic_vector(c_s_axis_cartesian_tuser_width - 1 downto 0) := ( others => '0' );
    s_axis_cartesian_tlast         : in  std_logic                                                     := '0';
    s_axis_cartesian_tdata         : in  std_logic_vector(c_s_axis_cartesian_tdata_width - 1 downto 0) := ( others => '0' );
    m_axis_dout_tvalid             : out std_logic                                                     := '0';
    m_axis_dout_tready             : in  std_logic                                                     := '0';
    m_axis_dout_tuser              : out std_logic_vector(c_m_axis_dout_tuser_width - 1 downto 0)      := ( others => '0' );
    m_axis_dout_tlast              : out std_logic                                                     := '0';
    m_axis_dout_tdata              : out std_logic_vector(c_m_axis_dout_tdata_width - 1 downto 0)      := ( others =>'0' )
    );
--core_if off
end cordic_v5_0;

architecture behavioral of cordic_v5_0 is

  constant c_family : string := c_xdevicefamily_to_c_family(c_xdevicefamily);
  
  --reg_inputs and reg_outputs are no longer individually selectable, but
  --instead inferred from pipeline mode and axi_mode
  --The registers will not be used if the core datapath goes to an AXI component.
  --They will exist otherwise according to this mapping:
  -- pipeline mode = none    => neither set
  -- pipeline mode = optimal => output set
  -- pipeline mode = max     => both set
  constant c_reg_inputs  : integer := fn_get_reg_inputs(
    p_throttle_scheme => C_THROTTLE_SCHEME,
    p_pipeline_mode   => C_PIPELINE_MODE
    );
  constant c_reg_outputs  : integer := fn_get_reg_outputs(
    p_throttle_scheme => C_THROTTLE_SCHEME,
    p_pipeline_mode   => C_PIPELINE_MODE
    );
  constant c_has_nd  : integer := boolean'pos(C_ARCHITECTURE = CORDIC_PACK_wser_arch);
  constant c_has_rdy : integer := boolean'pos(C_ARCHITECTURE = CORDIC_PACK_wser_arch);
  constant c_has_rfd : integer := boolean'pos(C_ARCHITECTURE = CORDIC_PACK_wser_arch);

  constant c_has_phase_in : integer := boolean'pos(C_HAS_S_AXIS_PHASE = 1);
  constant c_has_phase_out : integer := boolean'pos(C_CORDIC_FUNCTION = CORDIC_PACK_f_translate or
                                                     C_CORDIC_FUNCTION = CORDIC_PACK_f_atan or
                                                     C_CORDIC_FUNCTION = CORDIC_PACK_f_atanh);
  constant c_has_x_in  : integer := boolean'pos(C_HAS_S_AXIS_CARTESIAN = 1);
  constant c_has_x_out : integer := boolean'pos(C_CORDIC_FUNCTION /= CORDIC_PACK_f_atan and C_CORDIC_FUNCTION /= CORDIC_PACK_f_atanh);
  constant c_has_y_in  : integer := boolean'pos(C_HAS_S_AXIS_CARTESIAN = 1 and not (C_CORDIC_FUNCTION = CORDIC_PACK_f_sqrt));
  constant c_has_y_out : integer := boolean'pos(C_CORDIC_FUNCTION = CORDIC_PACK_f_rotate or
                                                C_CORDIC_FUNCTION = CORDIC_PACK_f_sin_cos or
                                                C_CORDIC_FUNCTION = CORDIC_PACK_f_sinh_cosh);
 
  --the legacy core will check the CORDIC generics. All that need be checked
  --here are the new generics and any interdependency
  constant c_generics_ok : boolean := check_axi_generics(
    p_throttle_scheme              => c_throttle_scheme,
    p_tlast_resolution             => c_tlast_resolution,
    p_has_s_axis_phase_tuser       => c_has_s_axis_phase_tuser,
    p_has_s_axis_phase_tlast       => c_has_s_axis_phase_tlast,
    p_s_axis_phase_tdata_width     => c_s_axis_phase_tdata_width,
    p_s_axis_phase_tuser_width     => c_s_axis_phase_tuser_width,
    p_has_s_axis_cartesian_tuser   => c_has_s_axis_cartesian_tuser,
    p_has_s_axis_cartesian_tlast   => c_has_s_axis_cartesian_tlast,
    p_s_axis_cartesian_tdata_width => c_s_axis_cartesian_tdata_width,
    p_s_axis_cartesian_tuser_width => c_s_axis_cartesian_tuser_width,
    p_m_axis_dout_tdata_width      => c_m_axis_dout_tdata_width,
    p_m_axis_dout_tuser_width      => c_m_axis_dout_tuser_width ,
    p_input_width                  => c_input_width,
    p_output_width                 => c_output_width,
    p_cordic_function              => c_cordic_function
    );


   type t_cordic_widths is record
    data_out      : integer;
    chan_dout     : integer;
    dip_bag       : integer;
    dip_bag_tuser : integer;
    dip_bag_tlast : integer;
    has_x_in      : integer;
    has_y_in      : integer;
    has_phase_in  : integer;
    has_x_out     : integer;
    has_y_out     : integer;    
    has_phase_out : integer;
  end record;

  function fn_get_cordic_widths (
    p_cordic_function        : integer;
    p_output_width           : integer;
    p_has_phase_tuser        : integer;
    p_has_phase_tlast        : integer;
    p_phase_tuser_width      : integer;
    p_has_cartesian_tuser    : integer;
    p_has_cartesian_tlast    : integer;
    p_cartesian_tuser_width  : integer
    ) return t_cordic_widths is
    variable ret_val       : t_cordic_widths;
  begin
    ret_val := (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    --no need to handle 'others' as check_generics does this.
    case p_cordic_function is
      when CORDIC_PACK_f_rotate    =>
        ret_val := (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0);
        ret_val.data_out      := p_output_width*2;
      when CORDIC_PACK_f_sin_cos   =>
        ret_val := (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0);
        ret_val.data_out      := p_output_width*2;
      when CORDIC_PACK_f_sinh_cosh =>
        ret_val := (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0);
        ret_val.data_out      := p_output_width*2;
      when CORDIC_PACK_f_translate =>
        ret_val := (0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1);
        ret_val.data_out      := p_output_width*2;
      when CORDIC_PACK_f_sqrt      =>
        ret_val := (0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0);
        ret_val.data_out      := p_output_width;
      when CORDIC_PACK_f_atan      =>
        ret_val := (0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1);
        ret_val.data_out      := p_output_width;
      when CORDIC_PACK_f_atanh     =>
        ret_val := (0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1);
        ret_val.data_out      := p_output_width;
      when others =>
        assert false
          report "ERROR: cordic_v5_0_xst : unrecognised value of c_cordic_function"
          severity ERROR;
    end case;
    
    if p_has_cartesian_tlast = 1 or p_has_phase_tlast = 1 then
      ret_val.dip_bag_tlast := 1;
    end if;
    if p_has_cartesian_tuser = 1 then
      ret_val.dip_bag_tuser := ret_val.dip_bag_tuser+ p_cartesian_tuser_width;
    end if;
    if p_has_phase_tuser = 1 then
      ret_val.dip_bag_tuser := ret_val.dip_bag_tuser+ p_phase_tuser_width;
    end if;
    
    ret_val.dip_bag := ret_val.dip_bag_tuser + ret_val.dip_bag_tlast;
     
    ret_val.chan_dout := ret_val.dip_bag + ret_val.data_out; 

    return ret_val;
  end fn_get_cordic_widths;
  constant ci_widths : t_cordic_widths := fn_get_cordic_widths(
    p_cordic_function        => C_CORDIC_FUNCTION,
    p_output_width           => C_OUTPUT_WIDTH,
    p_has_phase_tuser        => C_HAS_S_AXIS_PHASE_TUSER,
    p_has_phase_tlast        => C_HAS_S_AXIS_PHASE_TLAST,
    p_phase_tuser_width      => C_S_AXIS_PHASE_TUSER_WIDTH,
    p_has_cartesian_tuser    => C_HAS_S_AXIS_CARTESIAN_TUSER,
    p_has_cartesian_tlast    => C_HAS_S_AXIS_CARTESIAN_TLAST,
    p_cartesian_tuser_width  => C_S_AXIS_CARTESIAN_TUSER_WIDTH
    );
  signal diag_cordic_widths : t_cordic_widths := ci_widths;

  constant ci_core_latency : integer := getLatency(
    architecture_sel   => c_architecture,
    coarse_rotate      => c_coarse_rotate,
    cordic_function    => c_cordic_function,
    data_format        => c_data_format,
    family             => c_xdevicefamily,
    input_width        => c_input_width,
    iterations         => c_iterations,
    output_width       => c_output_width,
    pipeline_mode      => c_pipeline_mode,
    precision          => c_precision,
    reg_inputs         => c_reg_inputs,
    reg_outputs        => c_reg_outputs,
    round_mode         => c_round_mode,
    scale_comp         => c_scale_comp
    );

  constant ci_axi_latency : integer := fn_axi_latency(
    p_throttle_scheme => c_throttle_scheme
    );

  constant ci_all_latency : integer := ci_core_latency + ci_axi_latency;

  function fn_outfifo_depth (
    p_throttle_scheme : integer;
    p_latency         : integer)
    return integer is
    variable ret_val : integer := 0;
    variable v_req_depth : integer := 0;
  begin  -- fn_outfifo_depth
    assert p_throttle_scheme = ci_ce_throttle or p_throttle_scheme = ci_rfd_throttle
      report "ERROR: fn_outfifo_depth: Unexpected value of c_throttle_scheme"
      severity error;
    if p_throttle_scheme = ci_ce_throttle  then
      v_req_depth := 5;                     --adequate depth for CE braking distance
    else
      v_req_depth := 4 + p_latency;         --3 is enough to accomodate latency of control
    end if;
    ret_val := 2**log2roundup(v_req_depth);
    return ret_val;
  end fn_outfifo_depth;
 
  
  signal s_axis_cartesian_tvalid_skid : std_logic := '0';
  signal s_axis_phase_tvalid_skid : std_logic := '0';
  
  signal m_axis_z_tdata_phase : std_logic_vector(c_s_axis_phase_tdata_width-1 downto 0) := (others => '0');
  signal m_axis_z_tuser_phase : std_logic_vector(c_s_axis_phase_tuser_width-1 downto 0) := (others => '0');
  signal m_axis_z_tlast_phase : std_logic := '0';
  signal m_axis_z_tdata_cartesian  : std_logic_vector(c_s_axis_cartesian_tdata_width-1 downto 0) := (others => '0');
  signal m_axis_z_tuser_cartesian  : std_logic_vector(c_s_axis_cartesian_tuser_width-1 downto 0) := (others => '0');
  signal m_axis_z_tlast_cartesian  : std_logic := '0';
  
  signal chan_dout_fifo_in      : std_logic_vector(ci_widths.chan_dout-1 downto 0)     := (others => '0');
  signal chan_dout_fifo_out     : std_logic_vector(ci_widths.chan_dout-1 downto 0)     := (others => '0');

  signal diplomatic_in  : std_logic_vector(ci_widths.dip_bag-1 downto 0) := (others => '0');
  signal diplomatic_out : std_logic_vector(ci_widths.dip_bag-1 downto 0) := (others => '0');
  
  signal valid_access_in : std_logic := '0';
  signal valid_access_in_delayed : std_logic := '0';
  signal dip_in_tuser : std_logic_vector(ci_widths.dip_bag_tuser-1 downto 0) := (others => '0');
  signal dip_in_tlast : std_logic := '0';
  signal ok_to_pull_data : std_logic := '0';  -- CE signal to core used in CE throttling scheme.
                                              -- Indicates that output fifo has room to accommodate data.
                                              -- Cannot use valid_data_in because then data propagation would rely on following data

  constant ci_has_ce : integer := boolean'pos(C_THROTTLE_SCHEME = ci_ce_throttle or C_HAS_ACLKEN = 1);  --i.e. logical OR
  signal sclr_d  : std_logic := '0';
  signal sclr_i  : std_logic := '0';
  signal ce_if   : std_logic := '1';
  signal ce_core : std_logic := '1';
  signal rdy_i   : std_logic := '0';
  signal rfd_i   : std_logic := '0';
  signal rfd_core: std_logic := '0';

  signal nd_if   : std_logic := '0';
  signal rdy_if  : std_logic := '0';
  
  signal x_in      : std_logic_vector(c_input_width-1 downto 0) := (others => '0');
  signal y_in      : std_logic_vector(c_input_width-1 downto 0) := (others => '0');
  signal phase_in  : std_logic_vector(c_input_width-1 downto 0) := (others => '0');
  signal x_out     : std_logic_vector(c_output_width-1 downto 0) := (others => '0');
  signal y_out     : std_logic_vector(c_output_width-1 downto 0) := (others => '0');
  signal phase_out : std_logic_vector(c_output_width-1 downto 0) := (others => '0');

  signal outfifo_has_room         : std_logic := '1';  
  signal chan_dout_fifo_in_data : std_logic_vector(ci_widths.data_out-1 downto 0) := (others => '0');
  signal fifo_dip_out : std_logic_vector(ci_widths.dip_bag-1 downto 0) := (others => '0');
begin
  
  --ARESETN is active low, so is inverted to make an SCLR, but is also
  --registered for speed, as the SCLR port on many primitives is slow.
  i_has_aresetn: if C_HAS_ARESETN = 1 generate
    sclr_d <= not (ARESETN);
    i_reg_reset : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => 1,
        C_HAS_CE   => 0,
        C_HAS_SCLR => 0,                  --! as if.
        C_WIDTH    => 1
        )
      port map(
        CLK  => aclk,
        D(0) => sclr_d,
        Q(0) => sclr_i
        );
  end generate i_has_aresetn;
  i_no_aresetn: if C_HAS_ARESETN = 0 generate
    sclr_i <= '0';
  end generate i_no_aresetn;

  --ACLKEN becomes CE in most cases. This is complicated if the data flow is
  --throttled using CE, as then the core ce is gated.
  i_has_aclken: if C_HAS_ACLKEN = 1 generate
    ce_if <= ACLKEN;
    i_ce_throttle: if C_THROTTLE_SCHEME = ci_ce_throttle generate
      ce_core <= '1' when ACLKEN = '1' and outfifo_has_room = '1' else '0';
    end generate i_ce_throttle;
    i_no_ce_throttle: if C_THROTTLE_SCHEME /= ci_ce_throttle generate
      ce_core <= ACLKEN;
    end generate i_no_ce_throttle;
  end generate i_has_aclken;
  i_no_aclken: if C_HAS_ACLKEN = 0 generate
    ce_if <= '1';
    i_ce_throttle: if C_THROTTLE_SCHEME = ci_ce_throttle generate
      ce_core <= outfifo_has_room;
    end generate i_ce_throttle;
    i_no_ce_throttle: if C_THROTTLE_SCHEME /= ci_ce_throttle generate
      ce_core <= '1';
    end generate i_no_ce_throttle;
  end generate i_no_aclken;

  -----------------------------------------------------------------------------
  -- Input buffers (single channel solution)
  -----------------------------------------------------------------------------

  i_has_rfd: if c_has_rfd = 1 generate
    rfd_i <= rfd_core;
  end generate i_has_rfd;
  i_has_no_rfd: if c_has_rfd /= 1 generate
    rfd_i <= '1';
  end generate i_has_no_rfd;
  
  i_has_cartesian :if C_HAS_S_AXIS_CARTESIAN = 1 generate
    s_axis_cartesian_tvalid_skid <= s_axis_cartesian_tvalid;
  end generate i_has_cartesian;
  i_has_no_cartesian :if C_HAS_S_AXIS_CARTESIAN = 0 generate
    s_axis_cartesian_tvalid_skid <= '1';
  end generate i_has_no_cartesian;
  i_has_phase :if C_HAS_S_AXIS_PHASE = 1 generate
    s_axis_phase_tvalid_skid <= s_axis_phase_tvalid;
  end generate i_has_phase;
  i_has_no_phase :if C_HAS_S_AXIS_PHASE = 0 generate
    s_axis_phase_tvalid_skid <= '1';
  end generate i_has_no_phase;
    
  i_has_no_input_skid: if C_THROTTLE_SCHEME = ci_and_tvalid_throttle generate
    m_axis_z_tdata_phase      <= s_axis_phase_tdata;
    m_axis_z_tuser_phase      <= s_axis_phase_tuser;
    m_axis_z_tlast_phase      <= s_axis_phase_tlast;
    m_axis_z_tdata_cartesian  <= s_axis_cartesian_tdata;
    m_axis_z_tuser_cartesian  <= s_axis_cartesian_tuser;
    m_axis_z_tlast_cartesian  <= s_axis_cartesian_tlast;
    valid_access_in <= '1' when (c_architecture = CORDIC_PACK_para_arch or rfd_i = '1') and s_axis_phase_tvalid_skid = '1' and s_axis_cartesian_tvalid_skid = '1' and (C_HAS_ACLKEN = 0 or ACLKEN = '1') else
                       '0';
    nd_if <= valid_access_in;

    s_axis_phase_tready     <= rfd_i;
    s_axis_cartesian_tready <= rfd_i;

  end generate i_has_no_input_skid;

  i_has_input_skid : if C_THROTTLE_SCHEME = ci_ce_throttle or C_THROTTLE_SCHEME = ci_rfd_throttle or C_THROTTLE_SCHEME = ci_gen_throttle generate
    signal combiner_data_out_valid           : std_logic := '0';
    signal combiner_has_room                 : std_logic := '0';
    signal chan_cartesian_skid_valid_out     : std_logic := '0';
    signal chan_phase_skid_valid_out         : std_logic := '0';
    signal chan_cartesian_skid_avail_out     : std_logic := '0';
    signal chan_phase_skid_avail_out         : std_logic := '0';
    signal chan_cartesian_skid_not_empty_out : std_logic := '0';
    signal chan_phase_skid_not_empty_out     : std_logic := '0';
  begin

    i_2to1 : axi_slave_2to1_v1_1
      generic map(
        C_A_TDATA_WIDTH => c_s_axis_cartesian_tdata_width,
        C_HAS_A_TUSER   => (c_has_s_axis_cartesian_tuser = 1),
        C_A_TUSER_WIDTH => c_s_axis_cartesian_tuser_width,
        C_HAS_A_TLAST   => (c_has_s_axis_cartesian_tlast = 1),
        C_B_TDATA_WIDTH => c_s_axis_phase_tdata_width,
        C_HAS_B_TUSER   => (c_has_s_axis_phase_tuser = 1),
        C_B_TUSER_WIDTH => c_s_axis_phase_tuser_width,
        C_HAS_B_TLAST   => (c_has_s_axis_phase_tlast = 1),
        C_HAS_Z_TREADY  => true
        )
      port map(
        aclk   => aclk,
        aclken => ce_if,
        sclr   => sclr_i,

        -- AXI slave interface A
        s_axis_a_tready => s_axis_cartesian_tready,
        s_axis_a_tvalid => s_axis_cartesian_tvalid_skid,
        s_axis_a_tdata  => s_axis_cartesian_tdata,
        s_axis_a_tuser  => s_axis_cartesian_tuser,
        s_axis_a_tlast  => s_axis_cartesian_tlast,

        -- AXI slave interface B
        s_axis_b_tready => s_axis_phase_tready,
        s_axis_b_tvalid => s_axis_phase_tvalid_skid,
        s_axis_b_tdata  => s_axis_phase_tdata,
        s_axis_b_tuser  => s_axis_phase_tuser,
        s_axis_b_tlast  => s_axis_phase_tlast,

        -- Read interface to core
        m_axis_z_tready  => ok_to_pull_data,
        m_axis_z_tvalid  => combiner_data_out_valid,
        m_axis_z_tdata_a => m_axis_z_tdata_cartesian,
        m_axis_z_tuser_a => m_axis_z_tuser_cartesian,
        m_axis_z_tlast_a => m_axis_z_tlast_cartesian,
        m_axis_z_tdata_b => m_axis_z_tdata_phase,
        m_axis_z_tuser_b => m_axis_z_tuser_phase,
        m_axis_z_tlast_b => m_axis_z_tlast_phase
        );
    ok_to_pull_data <= '1' when rfd_i = '1' and outfifo_has_room = '1' and ce_if = '1' else '0';

  
    valid_access_in <= combiner_data_out_valid and
                       outfifo_has_room and
                       rfd_i and
                       ce_if;

    nd_if <= valid_access_in;    
  end generate i_has_input_skid;

  
  x_in     <= m_axis_z_tdata_cartesian(C_INPUT_WIDTH-1 downto 0);
  i_has_y_in : if c_cordic_function = CORDIC_PACK_f_rotate or
                 c_cordic_function = CORDIC_PACK_f_translate or
                 c_cordic_function = CORDIC_PACK_f_atan or
                 c_cordic_function = CORDIC_PACK_f_atanh generate
  begin
    y_in     <= m_axis_z_tdata_cartesian(C_INPUT_WIDTH+byte_roundup(C_INPUT_WIDTH)-1 downto byte_roundup(C_INPUT_WIDTH));
  end generate i_has_y_in;
  phase_in <= m_axis_z_tdata_phase(C_INPUT_WIDTH-1 downto 0);
  
  --Need to create bypass ND -> RDY, as legacy core doesn't have ND/RFD/RDY.
  i_nd_to_rdy : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => ci_core_latency,
      C_HAS_CE   => 1,
      C_HAS_SCLR => C_HAS_ARESETN,
      C_WIDTH    => 1
      )
    port map(
      CLK  => aclk,
      CE   => ce_core,
      SCLR => sclr_i,
      D(0) => valid_access_in,          --equivalent to ND.
      Q(0) => valid_access_in_delayed   --equivalent to RDY
      );
  --De-CE-domain to make a single clock wide rdy pulse.
  --may be possible to use rdy_i if rdy_i is always present.
  rdy_if <= ce_core and valid_access_in_delayed;

  i_has_diplomatic_bag : if ci_widths.dip_bag > 0 generate
  begin
    --tuser
    i_phase_tuser: if C_HAS_S_AXIS_PHASE_TUSER /= 0 generate
      i_cartesian_tuser: if C_HAS_S_AXIS_CARTESIAN_TUSER /=0 generate
        dip_in_tuser <= m_axis_z_tuser_phase & m_axis_z_tuser_cartesian;
      end generate i_cartesian_tuser;
      i_no_cartesian_tuser: if C_HAS_S_AXIS_CARTESIAN_TUSER =0 generate
        dip_in_tuser <= m_axis_z_tuser_phase;
      end generate i_no_cartesian_tuser;
    end generate i_phase_tuser;
    i_no_phase_tuser: if C_HAS_S_AXIS_PHASE_TUSER = 0 generate
      i_cartesian_tuser: if C_HAS_S_AXIS_CARTESIAN_TUSER /=0 generate
        dip_in_tuser <= m_axis_z_tuser_cartesian;
      end generate i_cartesian_tuser;
      --no tuser, so no clause.
    end generate i_no_phase_tuser;

    i_dip_tlast: if C_HAS_S_AXIS_PHASE_TLAST = 1 or C_HAS_S_AXIS_CARTESIAN_TLAST = 1 generate
      i_pass_cartesian: if C_TLAST_RESOLUTION = ci_tlast_pass_a generate
        dip_in_tlast <= m_axis_z_tlast_cartesian;
      end generate i_pass_cartesian;
      i_pass_phase: if C_TLAST_RESOLUTION = ci_tlast_pass_b generate
        dip_in_tlast <= m_axis_z_tlast_phase;
      end generate i_pass_phase;
      i_or_all: if C_TLAST_RESOLUTION = ci_tlast_or_all generate
        dip_in_tlast <= '1' when m_axis_z_tlast_cartesian = '1' or m_axis_z_tlast_phase = '1' else
          '0';
      end generate i_or_all;
      i_and_all: if C_TLAST_RESOLUTION = ci_tlast_and_all generate
        dip_in_tlast <= '1' when m_axis_z_tlast_cartesian = '1' and m_axis_z_tlast_phase = '1' else
          '0';
      end generate i_and_all;
    end generate i_dip_tlast;

    --combine dip_in_tuser and dip_in_tlast
    i_tlast_for_dip: if C_HAS_S_AXIS_PHASE_TLAST = 1 or C_HAS_S_AXIS_CARTESIAN_TLAST = 1  generate
      i_tuser_for_dip: if  C_HAS_S_AXIS_PHASE_TUSER = 1 or C_HAS_S_AXIS_CARTESIAN_TUSER = 1 generate
        diplomatic_in <= dip_in_tuser & dip_in_tlast;
      end generate i_tuser_for_dip;
      i_no_tuser_for_dip: if  C_HAS_S_AXIS_PHASE_TUSER = 0 and C_HAS_S_AXIS_CARTESIAN_TUSER = 0 generate
        diplomatic_in(0) <= dip_in_tlast;
      end generate i_no_tuser_for_dip;
    end generate i_tlast_for_dip;
    i_no_tlast_for_dip: if C_HAS_S_AXIS_PHASE_TLAST = 0 and C_HAS_S_AXIS_CARTESIAN_TLAST = 0  generate
      i_tuser_for_dip: if  C_HAS_S_AXIS_PHASE_TUSER = 1 or C_HAS_S_AXIS_CARTESIAN_TUSER = 1 generate
        diplomatic_in <= dip_in_tuser;
      end generate i_tuser_for_dip;
      --no diplomatic bag for 4th case where neither has tuser nor tlast.
    end generate i_no_tlast_for_dip;
    
    i_diplomatic_bag : xbip_pipe_v2_0_xst
      generic map(
        C_LATENCY  => ci_core_latency,
        C_HAS_CE   => 1,
        C_HAS_SCLR => 0,
        C_WIDTH    => ci_widths.dip_bag
        )
      port map(
        CLK  => aclk,
        CE   => ce_core,
        SCLR => '0',--sclr_i unnecessary - (dis)qualified by valid.,
        D    => diplomatic_in,
        Q    => diplomatic_out
        );
  end generate i_has_diplomatic_bag;
  -----------------------------------------------------------------------------
  -- The core itself
  -----------------------------------------------------------------------------
  i_behv : cordic_v5_0_behv
    generic map (
      c_architecture    => c_architecture,
      c_cordic_function => c_cordic_function,
      c_coarse_rotate   => c_coarse_rotate,
      c_data_format     => c_data_format,
      c_family          => c_family,
      c_xdevicefamily   => c_xdevicefamily,
      c_has_ce          => ci_has_ce,
      c_has_clk         => c_has_aclk,
      c_has_nd          => c_has_nd,
      c_has_phase_in    => ci_widths.has_phase_in,
      c_has_phase_out   => ci_widths.has_phase_out,
      c_has_rdy         => c_has_rdy,
      c_has_rfd         => c_has_rfd,
      c_has_sclr        => c_has_aresetn,
      c_has_x_in        => ci_widths.has_x_in,
      c_has_x_out       => ci_widths.has_x_out,
      c_has_y_in        => ci_widths.has_y_in,
      c_has_y_out       => ci_widths.has_y_out,
      c_input_width     => c_input_width,
      c_iterations      => c_iterations,
      c_output_width    => c_output_width,
      c_phase_format    => c_phase_format,
      c_pipeline_mode   => c_pipeline_mode,
      c_precision       => c_precision,
      c_reg_inputs      => c_reg_inputs,
      c_reg_outputs     => c_reg_outputs,
      c_round_mode      => c_round_mode,
      c_scale_comp      => c_scale_comp
      )
    port map (
      X_IN              => x_in,
      Y_IN              => y_in,
      PHASE_IN          => phase_in,
      ND                => nd_if,
      X_OUT             => x_out,
      Y_OUT             => y_out,
      PHASE_OUT         => phase_out,
      RDY               => rdy_i,
      RFD               => rfd_core,
      CLK               => aclk,
      CE                => ce_core,
      SCLR              => sclr_i
      );

  ---------------------------------------------------------
  -- Map legacy outputs and diplomatic bag to output FIFO
  ---------------------------------------------------------
  --First, map the X, Y, PHASE OUT ports to a TDATA

  i_cartesian_out: if C_CORDIC_FUNCTION = CORDIC_PACK_f_rotate or
                      C_CORDIC_FUNCTION = CORDIC_PACK_f_sin_cos or
                      C_CORDIC_FUNCTION = CORDIC_PACK_f_sinh_cosh generate
    chan_dout_fifo_in_data <= Y_OUT & X_OUT;
  end generate i_cartesian_out;
  i_realonly_integer_out: if c_cordic_function = CORDIC_PACK_f_sqrt generate
    chan_dout_fifo_in_data <= X_OUT;
    
  end generate i_realonly_integer_out;
  i_phase_integer_out: if c_cordic_function = CORDIC_PACK_f_atan or
                          c_cordic_function = CORDIC_PACK_f_atanh generate
    chan_dout_fifo_in_data <= PHASE_OUT;
  end generate i_phase_integer_out;
  i_polar_out: if c_cordic_function = CORDIC_PACK_f_translate generate
    chan_dout_fifo_in_data <= PHASE_OUT & X_OUT;
  end generate i_polar_out;


  -----------------------------------------------------------------------------
  -- Create chan_dout_fifo_in
  -----------------------------------------------------------------------------
  i_outfifo_has_no_diplomatic_bag: if ci_widths.dip_bag = 0 generate
    chan_dout_fifo_in <= chan_dout_fifo_in_data;
  end generate i_outfifo_has_no_diplomatic_bag;

  i_outfifo_has_diplomatic_bag: if ci_widths.dip_bag /= 0 generate
    chan_dout_fifo_in <= diplomatic_out & chan_dout_fifo_in_data;
    fifo_dip_out <= chan_dout_fifo_out(chan_dout_fifo_out'LEFT downto ci_widths.data_out);
    i_has_tlast: if C_HAS_S_AXIS_CARTESIAN_TLAST = 1 or C_HAS_S_AXIS_PHASE_TLAST = 1 generate
      m_axis_dout_tlast <= fifo_dip_out(0);
      i_has_tuser: if C_HAS_S_AXIS_CARTESIAN_TUSER = 1 or C_HAS_S_AXIS_PHASE_TUSER = 1 generate
        m_axis_dout_tuser <= fifo_dip_out(fifo_dip_out'LEFT downto 1);
      end generate i_has_tuser;
    end generate i_has_tlast;
    i_no_tlast: if C_HAS_S_AXIS_CARTESIAN_TLAST = 0 and C_HAS_S_AXIS_PHASE_TLAST = 0 generate
      i_has_tuser: if C_HAS_S_AXIS_CARTESIAN_TUSER = 1 or C_HAS_S_AXIS_PHASE_TUSER = 1 generate
        m_axis_dout_tuser <= fifo_dip_out;
      end generate i_has_tuser;
    end generate i_no_tlast;
  end generate i_outfifo_has_diplomatic_bag;

  -----------------------------------------------------------------------------
  -- The output FIFO, or not
  -----------------------------------------------------------------------------
  i_no_outfifo: if C_THROTTLE_SCHEME = ci_and_tvalid_throttle or C_THROTTLE_SCHEME = ci_gen_throttle generate
    chan_dout_fifo_out <= chan_dout_fifo_in;
    --190911 G.Old experiment to use CE domain valid_access_in_delayed rather
    --than single clock pulse wide signal.
--    m_axis_dout_tvalid <= rdy_if;
    m_axis_dout_tvalid <= valid_access_in_delayed;
  end generate i_no_outfifo;
  i_outfifo: if C_THROTTLE_SCHEME = ci_ce_throttle or C_THROTTLE_SCHEME = ci_rfd_throttle generate
    constant ci_outfifo_depth : integer := fn_outfifo_depth(
      p_throttle_scheme => C_THROTTLE_SCHEME,
      p_latency         => ci_core_latency
      );
    signal diag_outfifo_depth : integer := ci_outfifo_depth;
  begin
    i_output_fifo : glb_ifx_master_v1_1
      generic map(
        width         => ci_widths.chan_dout,
        depth         => ci_outfifo_depth,
        afull_thresh1 => 1,
        afull_thresh0 => 1
        )
      port map(
        aclk      => aclk,
        aclken    => ce_if,
        areset    => sclr_i,
        wr_enable => rdy_if,
        wr_data   => chan_dout_fifo_in,
        ifx_valid => m_axis_dout_tvalid,
        ifx_ready => m_axis_dout_tready,
        ifx_data  => chan_dout_fifo_out,
        not_afull => outfifo_has_room
        );    
  end generate i_outfifo;
  
  -----------------------------------------------------------
  -- Map output FIFO payload to various outputs
  -----------------------------------------------------------
  i_complex_out: if ci_widths.data_out = 2*C_OUTPUT_WIDTH generate
    m_axis_dout_tdata <= std_logic_vector(resize(signed(chan_dout_fifo_out(c_output_width*2-1 downto c_output_width)),byte_roundup(c_output_width))) &
                         std_logic_vector(resize(signed(chan_dout_fifo_out(c_output_width-1 downto 0)),byte_roundup(c_output_width)));    
  end generate i_complex_out;
  i_integer_out: if ci_widths.data_out = c_output_width generate
    m_axis_dout_tdata <= std_logic_vector(resize(signed(chan_dout_fifo_out(c_output_width-1 downto 0)),byte_roundup(c_output_width)));    
  end generate i_integer_out;

end behavioral;
