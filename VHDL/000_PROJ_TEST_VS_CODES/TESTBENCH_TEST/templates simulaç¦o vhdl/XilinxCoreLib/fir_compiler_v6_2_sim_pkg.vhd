--------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/O/fir_compiler_v6_2/simulation/fir_compiler_v6_2_sim_pkg.vhd,v 1.4 2011/02/14 14:22:28 julian Exp $
--------------------------------------------------------------------------------
--  (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
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
-- Author   : *********** Auto created - DO NOT MODIFIY BY HAND ***************
-------------------------------------------------------------------------------
-- Description:
--     This file is to be populated by the gen_package.pl script
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;

-------------------------------------------------------------------------------
package fir_compiler_v6_2_sim_pkg is

--------------------------------------------------------------------------------
--From:  ../../hdl/global_pkg.vhd

  type t_int_array   is array (integer range <>) of integer;

  type t_max_val is
  record
    val     : integer;
    i       : integer;
    min_val : integer; -- hyjacking fn_max_val to find min vals as well.
    min_i   : integer;
  end record;

  type t_cnfg_and_reload is
  record
    num_streams         : integer;
    cnfg_read_lat       : integer;
    latency             : integer;
  end record;

  type t_filt_cntrls is ( wrap_buff_sclr, sym_buff_sclr, buff_sclr, mem_we, buff_re, buff_we, sym_buff_we, sym_mem_we, wrap_buff_we, addsup, addsub);

  type t_filt_cntrls_sl is array (t_filt_cntrls range <>) of std_logic;

  type t_rounder_port is (use_c_port , use_pcin_port);

  type t_calc_carry_sel is (
                      FAB_CARRYIN,
                      PCIN_MSB,
                      PCIN_MSB_BAR,
                      P_MSB,
                      P_MSB_BAR,
                      A_XOR_B );

  type t_calc_func is (
                      PCIN,
                      PCIN_add_P,
                      PCIN_add_C,
                      NOP,
                      PCIN_add_A_mult_B,
                      A_mult_B,
                      P_add_A_mult_B,
                      C_add_A_mult_B,
                      P_add_CONCAT,
                      P_add_P,
                      C_add_C,
                      PCIN_add_CONCAT,
                      P_add_C,
                      CONCAT,
                      C_add_CONCAT,
                      C );

  type t_rounding_cnfg is
  record
    use_rounder         : boolean;
    use_spare_cycle     : boolean;
    use_pattern_match   : boolean;
    use_rnd_const       : boolean;  --need this to ensure don't add a constant or any associated function for truncate function
    latency             : integer;
    rounder_port        : t_rounder_port;
    carryin_sel         : t_calc_carry_sel;
    accum_function      : t_calc_func;
    rounder_carryin_sel : t_calc_carry_sel;
    
    -- -- gui trans_off
    -- rnd_const       : std_logic_vector(ci_p_width-1 downto 0);
    -- pattern         : std_logic_vector(ci_p_width-1 downto 0);
    -- mask            : std_logic_vector(ci_p_width-1 downto 0);
    -- -- gui trans_on
  end record;

--------------------------------------------------------------------------------
--From:  ../../hdl/global_pkg.vhd

  constant ci_max_paths       : integer := 32;

  constant ci_max_coeff_width : integer := 50;

  constant ci_max_dsp_columns : integer := 15;  --Maybe redundnat now

  constant ci_max_dsps        : integer := 2016;

  constant ci_non_symmetric : integer := 0;

  constant ci_symmetric     : integer := 1;

  constant ci_neg_symmetric : integer := 2;

  constant ci_single_rate                        : integer := 0;

  constant ci_polyphase_decimation               : integer := 1;

  constant ci_polyphase_interpolation            : integer := 2;

  constant ci_hilbert                            : integer := 4;

  constant ci_interpolated                       : integer := 5;

  constant ci_halfband                           : integer := 6;

  constant ci_halfband_decimation                : integer := 7;

  constant ci_halfband_interpolation             : integer := 8;

  constant ci_channelizer_receiver               : integer := 9;

  constant ci_channelizer_transmitter            : integer := 10;

  constant ci_transpose_single_rate              : integer := 11;

  constant ci_transpose_decimation               : integer := 12;

  constant ci_transpose_interpolation            : integer := 13;

  constant ci_decimation                         : integer := 16; -- replaces ci_polyphase_pq_decimation, also implements integer decimation

  constant ci_no_tlast          : integer := 0;

  constant ci_vector_tlast      : integer := 1;

  constant ci_pass_tlast        : integer := 2;

  constant ci_no_tuser          : integer := 0;

  constant ci_chanid_tuser      : integer := 1;

  constant ci_user_tuser        : integer := 2;

  constant ci_cnfg_vector_sync  : integer := 0;

  constant ci_cnfg_packet_sync  : integer := 1;

  constant ci_single_cnfg       : integer := 0;

  constant ci_chan_cnfg         : integer := 1;

  constant ci_default_axi_fifo_depth : integer := 16; -- Reduced to 16 in v6.1 from 32 in v6.0 as the LUT's (and FF) 

  constant ci_no_reset          : integer := 0;

  constant ci_data_vector_reset : integer := 1;

  constant ci_cntrl_only_reset  : integer := 2;

  constant ci_write_first: integer:=1;

  constant ci_read_first : integer:=0;

  constant ci_srl  :integer:=0;

  constant ci_bram   :integer:=1;

  constant ci_dram   :integer:=2;

  constant ci_regs   :integer:=3;

  constant ci_ma_data_coef      : integer:=0;

  constant ci_ma_datasym_coefadj: integer:=1;

  constant ci_ma_dataadj_coefadj: integer:=2;

  constant ci_ma_datasym_coefrld: integer:=3;

  constant ci_ma_dataadj_coefrld: integer:=4;

  constant ci_filt_cntrls_all_zero : t_filt_cntrls_sl(t_filt_cntrls'low to t_filt_cntrls'high) := (others=>'0');

  constant ci_mem_output : integer :=0;

  constant ci_mem_input  : integer :=1;

  constant ci_p_width     : integer := 48;

  constant ci_max_p_width : integer := 48 + (48/8) -1 ; --use generics to allow for split post adder

  constant ci_signed   : integer:=0;

  constant ci_unsigned : integer:=1;

  constant ci_area   : integer:=0;

  constant ci_speed  : integer:=1;

  constant ci_preadd_add         : integer:=0;

  constant ci_preadd_sub         : integer:=1;

  constant ci_preadd_addsub      : integer:=2;

  constant ci_preadd_subadd      : integer:=3;

  constant ci_preadd_add_swapped : integer:=4;--Currently only for Sandia sr halfband

  constant p_none       : integer:=0;

  constant p_C          : integer:=1;

  constant p_CONCAT     : integer:=2;

  constant ci_full_precision     : integer := 0;

  constant ci_truncate_lsbs      : integer := 1;

  constant ci_symmetric_zero     : integer := 2;

  constant ci_symmetric_inf      : integer := 3;

  constant ci_convergent_even    : integer := 4;

  constant ci_convergent_odd     : integer := 5;

  constant ci_non_symmetric_down : integer := 6;

  constant ci_non_symmetric_up   : integer := 7;

--------------------------------------------------------------------------------
--From:  ../../hdl/global_pkg.vhd

  function fn_select_integer ( i0  : integer; i1  : integer; sel : boolean) return integer;

  function fn_str_to_int_array(str:string;delimiter:character) return t_int_array;

  function fn_ext_bus(P_INPUT_BUS: std_logic_vector; 
                      P_WIDTH : integer; 
                      P_SIGN  : integer) return std_logic_vector;

  function fn_split_bus( P_INDEX     :integer; 
                         P_BUS_IN    :std_logic_vector; 
                         P_BUS_WIDTH :t_int_array) return std_logic_vector;

  function fn_sum_vals(in_array:t_int_array) return integer;

  function fn_str_cnt_delimiter(str:string;delimiter:character) return integer;

  function fn_str_to_posint(str:string) return integer;

  function fn_gen_cnt(len,step,start:integer) return t_int_array;

  function fn_str_compare(str1:string;str2:string) return boolean;

  function fn_str_get_delim_item(str:string;delimiter:character;index:integer) return string;

  function fn_get_channel_pat( P_FIXED_PAT: boolean; P_NUM_CHANNELS: integer; P_CHANNEL_PATTERN: string ) return t_int_array;

  function fn_max_val(in_array:t_int_array; backwards: boolean:=false) return t_max_val;

  function fn_gen_has_diff_bases( P_FIXED_PAT: boolean; 
                                  P_NUM_CHANNELS: integer; 
                                  P_CHANNEL_PATTERN: t_int_array ) return t_int_array;

  function fn_gen_addr_step( P_FIXED_PAT: boolean; 
                             P_NUM_CHANNELS, 
                             P_SINGLE_CHAN_STEP: integer; 
                             P_CHANNEL_PATTERN, 
                             P_CHAN_HAS_DIFF_BASE: t_int_array;
                             P_GEN_PERIOD_ONLY : boolean := false) return t_int_array;

  function fn_8bit_roundup        ( vals : t_int_array ) return t_int_array;

  function fn_running_accum(P_INT_ARRAY: t_int_array) return t_int_array;

  function fn_compress_axi_fields ( field_size : t_int_array ; bus_in : std_logic_vector ) return std_logic_vector;

  function fn_pad_axi_fields      ( field_size : t_int_array ; bus_in : std_logic_vector; signext : boolean ) return std_logic_vector;

  function fn_cnfg_and_reload( P_NUM_FILTS,
                               P_FILTS_PACKED,
                               P_COEF_MEM_LAT   : integer;
                               P_HAS_RELOAD,
                               P_FIXED_CHAN_PAT : boolean;
                               P_IS_HB          : boolean := false ) return t_cnfg_and_reload;

  function fn_mem_lat(P_XDEVICEFAMILY : string;P_MEM_TYPE, P_WRITE_MODE, P_NUM_PORTS:integer) return integer;

  function fn_select_int_array ( i0  : t_int_array; i1  : t_int_array; sel : boolean) return t_int_array;

  function fn_select_slv     ( i0  : std_logic_vector; i1  : std_logic_vector; sel : boolean) return std_logic_vector;

  function fn_get_rounding_cnfg( P_XDEVICEFAMILY : string; 
                                 P_ROUNDING_MODE : integer; 
                                 P_CAN_ADD_CONST, 
                                 P_HAS_SPARE_CYCLE: boolean) return t_rounding_cnfg;

  function fn_get_path_base_i (P_WIDTHS,P_SRC : t_int_array; index: integer) return integer;

  function fn_select_sl      ( i0  : std_logic; i1  : std_logic; sel : boolean) return std_logic;

  function fn_is_data_reset (P_HAS_ARESETn: integer) return integer;

  function fn_is_cntrl_reset(P_HAS_ARESETn: integer) return integer;

--------------------------------------------------------------------------------
--From:  ../../hdl/halfband_decimation.vhd

    function fn_gen_dec_hb_ipbuff_pat ( P_FIXED_PAT       : boolean;
                                 P_NUM_CHANNELS    : integer; 
                                 P_CHANNEL_PATTERN : t_int_array
                                 ) return t_int_array ;


end fir_compiler_v6_2_sim_pkg;

-------------------------------------------------------------------------------
package body fir_compiler_v6_2_sim_pkg is

--------------------------------------------------------------------------------
--From:  ../../hdl/global_pkg.vhd

  function fn_select_integer ( i0  : integer; i1  : integer; sel : boolean) return integer is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if; -- sel
  end fn_select_integer;

  function fn_str_to_int_array(str:string;delimiter:character) return t_int_array is
    variable ret_array:t_int_array(fn_str_cnt_delimiter(str,delimiter)-1 downto 0):=(others=>0);
    variable last_index:integer:=str'low;--1;
    variable array_index:integer:=0;
  begin
    for str_index in str'LOW to str'HIGH loop
      if str(str_index)=delimiter or str_index=str'HIGH then
        ret_array(array_index):=fn_str_to_posint(str(last_index to str_index-fn_select_integer(0,1,str(str_index)=',')));
        last_index:=str_index+1;
        array_index:=array_index+1;      
      end if;
    end loop;
    return ret_array;
  end fn_str_to_int_array;

  function fn_ext_bus(P_INPUT_BUS: std_logic_vector; 
                      P_WIDTH : integer; 
                      P_SIGN  : integer) return std_logic_vector is
    variable return_bus: std_logic_vector(P_WIDTH-1 downto 0);
    constant input_width:integer:=P_INPUT_BUS'LENGTH;
    variable input_bus_int: std_logic_vector(input_width-1 downto 0);
  begin
    input_bus_int:=P_INPUT_BUS;
    
    if ( input_width< P_WIDTH ) then
      --extend or pad
      return_bus(input_width-1 downto 0):=input_bus_int;
  
      if (P_SIGN=ci_signed) then --signed
        --extend remaing bits with sign
        return_bus((P_WIDTH-1) downto input_width) := (others=>input_bus_int(input_bus_int'high));
      else            --unsigned
        --pad remaing bits with 0
        return_bus((P_WIDTH-1) downto input_width) := (others=>'0');
      end if;
  
    elsif (input_width=P_WIDTH) then
      --same width
      return_bus := input_bus_int;
    else
      --larger
      return_bus := input_bus_int(P_WIDTH-1 downto 0);
    end if;
  
    return return_bus;
  end;

  function fn_split_bus( P_INDEX     :integer; 
                         P_BUS_IN    :std_logic_vector; 
                         P_BUS_WIDTH :t_int_array) return std_logic_vector is
    variable return_bus:std_logic_vector(P_BUS_WIDTH(P_INDEX+P_BUS_WIDTH'LOW)-1 downto 0);
    variable index_bottom:integer:=0;
  begin
    if (P_INDEX<=P_BUS_WIDTH'HIGH-P_BUS_WIDTH'LOW+1) then
  
      if (P_INDEX>0) then
        for i in 0 to P_INDEX-1 loop
          index_bottom:=index_bottom+P_BUS_WIDTH(i+P_BUS_WIDTH'LOW);
        end loop;
      end if;
  
      return_bus:=P_BUS_IN(P_BUS_WIDTH(P_INDEX+P_BUS_WIDTH'LOW)+index_bottom-1+P_BUS_IN'LOW downto index_bottom+P_BUS_IN'LOW);
  
    else
    end if;
  
    return return_bus;
  end;

  function fn_sum_vals(in_array:t_int_array) return integer is
    variable ret_val: integer:=0;
  begin
    for i in in_array'RANGE loop
      ret_val:=ret_val+in_array(i);
    end loop;
    return ret_val;
  end;

  function fn_str_cnt_delimiter(str:string;delimiter:character) return integer is
    variable cnt:integer:=0;
  begin
    if str'length>0 then
      for str_index in str'LOW to str'HIGH loop
        if str(str_index) = delimiter or str_index=str'HIGH then
          cnt:=cnt+1;
        end if;
      end loop;
    end if;
    return cnt;
  end fn_str_cnt_delimiter;

  function fn_str_to_posint(str:string) return integer is
    variable calc_integer: integer:=0;
    variable col_weight: integer:=1;
  begin
    for i in str'RIGHT downto str'LEFT loop
      --start in 1's column
      case str(i) is
      when '0' => calc_integer:=calc_integer;--unnecessary but in for completeness
      when '1' => calc_integer:=calc_integer+col_weight;
      when '2' => calc_integer:=calc_integer+(2*col_weight);
      when '3' => calc_integer:=calc_integer+(3*col_weight);
      when '4' => calc_integer:=calc_integer+(4*col_weight);
      when '5' => calc_integer:=calc_integer+(5*col_weight);
      when '6' => calc_integer:=calc_integer+(6*col_weight);
      when '7' => calc_integer:=calc_integer+(7*col_weight);
      when '8' => calc_integer:=calc_integer+(8*col_weight);
      when '9' => calc_integer:=calc_integer+(9*col_weight);
      when others => report "ERROR: FIR Compiler : fn_str_to_posint: Invalid character: "&str(i)& " in : "&str severity failure;
      end case;
      col_weight:=col_weight*10;
    end loop;
    return calc_integer;
  end;

  function fn_gen_cnt(len,step,start:integer) return t_int_array is
    variable cnt:t_int_array(len-1 downto 0);
    variable val:integer:=start;--0;
  begin
    for i in 0 to len-1 loop
      cnt(i):=val;
      val:=val+step;
    end loop;
    return cnt;
  end fn_gen_cnt;

  function fn_str_compare(str1:string;str2:string) return boolean is
    constant s1:string(1 to str1'length):=str1;--fn_str_trim(str1);
    constant s2:string(1 to str2'length):=str2;--fn_str_trim(str2);
    variable str_len:integer;
  begin
    if s1'length = s2'length then
      --safe guard
      str_len:=get_min(s1'length,s2'length);
      if lcase(s1(1 to str_len)) = lcase(s2(1 to str_len)) then
        return true;
      end if;
    end if;
    return false;
  end function fn_str_compare;

  function fn_str_get_delim_item(str:string;delimiter:character;index:integer) return string is
    variable index_cnt    : integer:=0;
    variable bottom_index : integer:=1;
  begin
    if str'LENGTH > 0 then
      for str_index in str'LOW to str'HIGH loop
        if str(str_index)=delimiter or str_index=str'HIGH then
          if index_cnt=index or str_index=str'HIGH then
            -- if str_index-1 < bottom_index then
              -- report "fn_str_get_delim_item: returned empty: "&str&" index "&integer'image(index);
              -- return "";
            -- else
              -- report "fn_str_get_delim_item: returned: "&str(bottom_index to str_index-fn_select_integer(1,0,str_index=str'HIGH));
              return str(bottom_index to str_index-fn_select_integer(1,0,str_index=str'HIGH));
            -- end if;
          else
            bottom_index:=str_index+1;
            index_cnt:=index_cnt+1;
          end if;
        end if;
      end loop;
    end if;
    return "";
  end fn_str_get_delim_item;

  function fn_get_channel_pat( P_FIXED_PAT: boolean; P_NUM_CHANNELS: integer; P_CHANNEL_PATTERN: string ) return t_int_array is
    constant ci_num_pat : integer := fn_select_integer(
                                        fn_str_cnt_delimiter(P_CHANNEL_PATTERN,';'),
                                        1,
                                        P_FIXED_PAT);
    variable ret_val    : t_int_array( 2**log2roundup(ci_num_pat*(2**log2roundup(P_NUM_CHANNELS)))-1 downto 0) := (others=>0);
    constant ci_roundup_num_pat : integer := ret_val'LENGTH / (2**log2roundup(P_NUM_CHANNELS));
    variable pat_offset,
             last_offset : integer := 0;
  begin
    if not P_FIXED_PAT then
      for pat in 0 to ci_num_pat-1 loop
        pat_offset:=pat*(2**log2roundup(P_NUM_CHANNELS));
        ret_val(pat_offset+P_NUM_CHANNELS-1 downto pat_offset) := fn_str_to_int_array(fn_str_get_delim_item(P_CHANNEL_PATTERN,';',pat),',');
      end loop;
      last_offset := pat_offset;
      for pat in ci_num_pat to ci_roundup_num_pat-1 loop
        -- duplicate last pattern. Can't use first as the core has a special case that it compares to 0 to activate.
        pat_offset:=pat*(2**log2roundup(P_NUM_CHANNELS));
        ret_val(pat_offset+P_NUM_CHANNELS-1 downto pat_offset) := ret_val(last_offset+P_NUM_CHANNELS-1 downto last_offset);
      end loop;
    end if;
    return ret_val;
  end function;

  function fn_max_val(in_array:t_int_array; backwards: boolean:=false) return t_max_val is
    constant start_i : integer := fn_select_integer(
                                    in_array'low,
                                    in_array'high,
                                    backwards);
    variable ret_val: t_max_val:=(val => in_array(start_i), 
                                  i => start_i,
                                  min_val => in_array(start_i), 
                                  min_i => start_i);
  begin
    if backwards then
      for i in in_array'high downto in_array'low loop
        if in_array(i)>ret_val.val then
          ret_val.val:=in_array(i);
          ret_val.i  :=i;
        end if;
        if in_array(i)<ret_val.min_val then
          ret_val.min_val:=in_array(i);
          ret_val.min_i  :=i;
        end if;
      end loop;
    else
      for i in in_array'low to in_array'high loop
        if in_array(i)>ret_val.val then
          ret_val.val:=in_array(i);
          ret_val.i  :=i;
        end if;
        if in_array(i)<ret_val.min_val then
          ret_val.min_val:=in_array(i);
          ret_val.min_i  :=i;
        end if;
      end loop;
    end if;
    return ret_val;
  end;

  function fn_gen_has_diff_bases( P_FIXED_PAT: boolean; 
                                  P_NUM_CHANNELS: integer; 
                                  P_CHANNEL_PATTERN: t_int_array ) return t_int_array is
                                 
    constant ci_num_pat : integer := P_CHANNEL_PATTERN'LENGTH / (2**log2roundup(P_NUM_CHANNELS));
    variable ret_val    : t_int_array( P_CHANNEL_PATTERN'RANGE ) := (others=>0);
    variable pat_offset : integer := 0;
    variable chan_cnt   : t_int_array(P_NUM_CHANNELS-1 downto 0) := (others=>0);
  begin
    if not P_FIXED_PAT then
      for pat in 0 to ci_num_pat-1 loop
        pat_offset:=pat*(2**log2roundup(P_NUM_CHANNELS));
        chan_cnt  :=(others=>0);
        --count the number of times each channel is processed in each pattern
        for i in 0 to P_NUM_CHANNELS-1 loop
          chan_cnt(P_CHANNEL_PATTERN(pat_offset+i)):=chan_cnt(P_CHANNEL_PATTERN(pat_offset+i))+1;
        end loop;
        -- Detemine which channels are at a higher rate/different base.
        for i in 0 to P_NUM_CHANNELS-1 loop
          if P_NUM_CHANNELS rem chan_cnt(P_CHANNEL_PATTERN(pat_offset+i)) > 0 then
            ret_val(pat_offset+i):=P_CHANNEL_PATTERN(pat_offset+i)+1;
          else
            ret_val(pat_offset+i):=-(P_CHANNEL_PATTERN(pat_offset+i)+1);
          end if;
        end loop;
      end loop;
    end if;
    return ret_val;
  end function;

  function fn_gen_addr_step( P_FIXED_PAT: boolean; 
                             P_NUM_CHANNELS, 
                             P_SINGLE_CHAN_STEP: integer; 
                             P_CHANNEL_PATTERN, 
                             P_CHAN_HAS_DIFF_BASE: t_int_array;
                             P_GEN_PERIOD_ONLY : boolean := false ) return t_int_array is
    constant ci_pat_len : integer := 2**log2roundup(P_NUM_CHANNELS);
    constant ci_num_pat : integer := P_CHANNEL_PATTERN'LENGTH / ci_pat_len;
    -- constant ci_num_pat : integer := P_CHANNEL_PATTERN'LENGTH / (2**log2roundup(P_NUM_CHANNELS));
    variable ret_val    : t_int_array( P_CHANNEL_PATTERN'range) := (others=>0);
    variable pat_offset,
             higher_rate_pat_len : integer := 0;
    variable chan_cnt   : t_int_array(P_NUM_CHANNELS-1 downto 0) := (others=>0);
    variable chan_base  : t_max_val;
  begin
    if not P_FIXED_PAT then
      for pat in 0 to ci_num_pat-1 loop
        pat_offset:=pat*(2**log2roundup(P_NUM_CHANNELS));
        chan_cnt  :=(others=>0);
        --Count the number of times each channel is processed in each pattern to determine step size
        for i in 0 to P_NUM_CHANNELS-1 loop
          chan_cnt(P_CHANNEL_PATTERN(pat_offset+i)):=chan_cnt(P_CHANNEL_PATTERN(pat_offset+i))+1;
        end loop;
        --Check if current pattern has a channel with a period thats a non integer multiple i.e. 0,0,0,1
        chan_base := fn_max_val(P_CHAN_HAS_DIFF_BASE(ci_pat_len+pat_offset-1 downto pat_offset));
        if chan_base.val > 0 then
          higher_rate_pat_len := fn_sum_vals(chan_cnt(chan_base.val-1 downto 0));
        end if;
        --For each sample in pattern set step size
        for i in 0 to P_NUM_CHANNELS-1 loop
          if chan_cnt(P_CHANNEL_PATTERN(pat_offset+i)) > 0 then
            if chan_base.val > 0 then -- Pattern contains channel(s) with a period thats a non int multiple
              if P_CHAN_HAS_DIFF_BASE(pat_offset+i) > 0 then
                -- Higher rate channels
                ret_val(pat_offset+i):=(higher_rate_pat_len*P_SINGLE_CHAN_STEP)/chan_cnt(P_CHANNEL_PATTERN(pat_offset+i));
                if not P_GEN_PERIOD_ONLY then
                  -- Insert empty phase
                  ret_val(pat_offset+i):=ret_val(pat_offset+i) * 2;
                end if;
              else
                -- Lower rate channels
                if not P_GEN_PERIOD_ONLY then
                  ret_val(pat_offset+i):=(higher_rate_pat_len*P_SINGLE_CHAN_STEP*2)/chan_cnt(P_CHANNEL_PATTERN(pat_offset+i));
                  
                  
                  -- Adding a special case here for patterns like 0 0 0 0 1 1
                  -- They way this functions work will generate a step size that assumes that the lower rate channel
                  -- is interleaved with another channel, or at least is no expecting it to repeat
                  -- the step used for the empty_address location will cause the 2nd instance of chan 1 to
                  -- miss the mem locations used for the first instance
                  -- if abs(chan_base.min_val)-chan_base.val = 1 then -- num slower rate channels
                    -- ret_val(pat_offset+i):= 2;
                  -- end if;
                  -- NOTE: This is wrong. This empty step needs to be modified to maintain the fixed step increment
                  -- otherwise on the next pattern repeat data is in the wrong place
                else
                  -- Treat like a normal pattern and use real pattern length
                  ret_val(pat_offset+i):=(P_NUM_CHANNELS*P_SINGLE_CHAN_STEP)/chan_cnt(P_CHANNEL_PATTERN(pat_offset+i));
                end if;
              end if;
            else -- Normal pattern
              ret_val(pat_offset+i):=(P_NUM_CHANNELS*P_SINGLE_CHAN_STEP)/chan_cnt(P_CHANNEL_PATTERN(pat_offset+i));
            end if;
          else
            ret_val(pat_offset+i):=0;
          end if;
        end loop;
      end loop;
    end if;
    return ret_val;
  end function;

  function fn_8bit_roundup        ( vals : t_int_array ) return t_int_array is
    variable ret_val : t_int_array(vals'range);
  begin
    for i in vals'range loop
      ret_val(i) := divroundup(vals(i),8)*8;
    end loop;
    return ret_val;
  end function;

  function fn_running_accum(P_INT_ARRAY: t_int_array) return t_int_array is
    variable ret_val: t_int_array(P_INT_ARRAY'high downto P_INT_ARRAY'low);
  begin
    ret_val(P_INT_ARRAY'low):=P_INT_ARRAY(P_INT_ARRAY'low);
    for i in P_INT_ARRAY'low+1 to P_INT_ARRAY'high loop
      ret_val(i):=ret_val(i-1)+P_INT_ARRAY(i);
    end loop;
    return ret_val;
  end function;

  function fn_compress_axi_fields ( field_size : t_int_array ; bus_in : std_logic_vector ) return std_logic_vector is
    constant ci_input_field_size : t_int_array := fn_8bit_roundup(field_size);
    constant ci_input_field_pos  : t_int_array := fn_running_accum(ci_input_field_size);
    constant ci_output_field_pos  : t_int_array := fn_running_accum(field_size);
    variable ret_val      : std_logic_vector(ci_output_field_pos(ci_output_field_pos'HIGH)-1 downto 0);
    variable ip_lower,
             op_lower     : integer := 0;
  begin
    for i in 0 to field_size'HIGH loop
      ret_val(ci_output_field_pos(i)-1 downto op_lower) := bus_in(field_size(i)+ip_lower-1 downto ip_lower);
      ip_lower := ci_input_field_pos(i);
      op_lower := ci_output_field_pos(i);
    end loop;
    return ret_val;
  end function;

  function fn_pad_axi_fields      ( field_size : t_int_array ; bus_in : std_logic_vector; signext : boolean ) return std_logic_vector is
    constant ci_output_field_size : t_int_array := fn_8bit_roundup(field_size);
    constant ci_input_field_pos  : t_int_array := fn_running_accum(field_size);
    constant ci_output_field_pos  : t_int_array := fn_running_accum(ci_output_field_size);
    variable ret_val      : std_logic_vector(ci_output_field_pos(ci_output_field_pos'HIGH)-1 downto 0):=(others=>'0'); -- default padded not sign extended
    variable ip_lower,
             op_lower     : integer := 0;
  begin
    -- report "fn_pad_axi_fields: ci_output_field_size: "&integer'image(ci_output_field_size(0));
    -- report "fn_pad_axi_fields: ret_val MSB: "&integer'image(ret_val'HIGH);
    for i in 0 to field_size'HIGH loop
      if signext then
        ret_val(ci_output_field_pos(i)-1 downto op_lower) := std_logic_vector(resize(signed(bus_in(ci_input_field_pos(i)-1 downto ip_lower)),ci_output_field_size(i)));
      else
        ret_val(field_size(i)+op_lower-1 downto op_lower) := bus_in(ci_input_field_pos(i)-1 downto ip_lower);
      end if;
      ip_lower := ci_input_field_pos(i);
      op_lower := ci_output_field_pos(i);
    end loop;
    return ret_val;
  end function;

  function fn_cnfg_and_reload( P_NUM_FILTS,
                               P_FILTS_PACKED,
                               P_COEF_MEM_LAT   : integer;
                               P_HAS_RELOAD,
                               P_FIXED_CHAN_PAT : boolean;
                               P_IS_HB          : boolean := false ) return t_cnfg_and_reload is
    variable ret_val : t_cnfg_and_reload;
  begin
    if P_COEF_MEM_LAT = 2 then
      ret_val.num_streams:=2;
    else
      ret_val.num_streams:=1;
    end if;
    ret_val.cnfg_read_lat := 1; --fixed val just now
    
    if P_NUM_FILTS = 1 and not P_HAS_RELOAD and P_FIXED_CHAN_PAT then
      -- This block serves no purpose
      ret_val.latency := 0;
    else
      ret_val.latency := 2;
      if (P_FILTS_PACKED = 1 and not P_IS_HB) or P_HAS_RELOAD or not P_FIXED_CHAN_PAT then
        ret_val.latency := ret_val.latency + 1;
      end if;
      if (P_FILTS_PACKED = 1 and P_IS_HB) then
        -- extra filt offset mem
        ret_val.latency := ret_val.latency + 1;
      end if;
      if P_HAS_RELOAD and P_NUM_FILTS>1 then
        -- Extra reg is used to blank the input to the lookup table so
        -- filter 0 can be forced after a reload
        -- Ideally this would be qualified by C_HAS_SCLR as well
        ret_val.latency := ret_val.latency + 1;
      end if;
    end if;
    return ret_val;
  end function;

  function fn_mem_lat(P_XDEVICEFAMILY : string;P_MEM_TYPE, P_WRITE_MODE, P_NUM_PORTS:integer) return integer is
  begin
    if P_MEM_TYPE = ci_srl then
      --srl16, from address to dataout but from we to data out is really 2 cycles
      return 1;
    elsif P_MEM_TYPE = ci_bram then
      if has_dsp(P_XDEVICEFAMILY) then
        return 2;
      else -- S3, S3A, S3E and V2
        return 1;
      end if;
    else --dram
      if P_NUM_PORTS = 2 then
        return 1;
      else
        if (P_WRITE_MODE=1) then
          return 2;
        else
          return 1;
        end if;
      end if;
    end if;
  end;

  function fn_select_int_array ( i0  : t_int_array; i1  : t_int_array; sel : boolean) return t_int_array is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if; -- sel
  end;

  function fn_select_slv     ( i0  : std_logic_vector; i1  : std_logic_vector; sel : boolean) return std_logic_vector is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if; -- sel
  end;

  function fn_get_rounding_cnfg( P_XDEVICEFAMILY : string; 
                                 P_ROUNDING_MODE : integer; 
                                 P_CAN_ADD_CONST, 
                                 P_HAS_SPARE_CYCLE : boolean) return t_rounding_cnfg is
    variable ret_val: t_rounding_cnfg;
  begin
    ret_val.carryin_sel         := FAB_CARRYIN;
    ret_val.rounder_carryin_sel := FAB_CARRYIN;
    
    case P_ROUNDING_MODE is
    when ci_full_precision | ci_truncate_lsbs =>
      ret_val.use_rounder       := false;
      ret_val.use_spare_cycle   := false;
      ret_val.use_pattern_match := false;
      ret_val.latency           := 0;
      ret_val.use_rnd_const     := false;
    when ci_symmetric_zero | ci_symmetric_inf =>
      -- If spare cycle rounding need to add the constant at the same time as the round cycle as the decision has to be
      -- made on the result unmodified by the rounding constant
      ret_val.use_pattern_match := false;
      
      if not P_CAN_ADD_CONST or
         has_dsp48(P_XDEVICEFAMILY) or
         supports_dsp48a(P_XDEVICEFAMILY)>0 or 
         not P_HAS_SPARE_CYCLE then
        ret_val.use_rounder       := true;
        ret_val.use_rnd_const     := false;
        ret_val.use_spare_cycle   := false;
        ret_val.rounder_port      := use_pcin_port;
        if supports_dsp48a(P_XDEVICEFAMILY)>0 or
           (has_dsp48(P_XDEVICEFAMILY) and P_ROUNDING_MODE=ci_symmetric_zero) then
          -- fabric carryin
          ret_val.rounder_port    := use_c_port;
          -- balance the carryin reg
          ret_val.latency         := 2;
        else
          if P_ROUNDING_MODE = ci_symmetric_zero then
            ret_val.rounder_carryin_sel := PCIN_MSB;
          else
            ret_val.rounder_carryin_sel := PCIN_MSB_BAR;
          end if;
          ret_val.latency         := 1;
        end if;
      else
        ret_val.use_rounder        := false;
        ret_val.use_rnd_const      := true;
        ret_val.use_spare_cycle    := true;
        if P_ROUNDING_MODE = ci_symmetric_zero then
          ret_val.carryin_sel      := P_MSB;
        else                       
          ret_val.carryin_sel      := P_MSB_BAR;
        end if;                    
        ret_val.latency            := 0;
        ret_val.accum_function     := P_add_C;--not sure this is usefull as each structure may need to get the constant in for the spare cycle different
      end if;
    when ci_convergent_even | ci_convergent_odd =>
      if supports_dsp48e(P_XDEVICEFAMILY) = 0 then
        --May add fabric compare for spartan families
        report "ERROR: FIR Compiler: fn_get_rounding_cnfg: invalid rounding mode. Convergent not supported on this family" severity error;
        return ret_val;
      end if;
      
      ret_val.use_spare_cycle   := false;
      ret_val.use_pattern_match := true;
      
      if P_CAN_ADD_CONST then
        ret_val.use_rounder       := false;
        ret_val.use_rnd_const     := true;
        ret_val.latency           := 0;
      else
        ret_val.use_rounder       := true;
        ret_val.use_rnd_const     := false;
        ret_val.latency           := 1;
        ret_val.rounder_port      := use_pcin_port;
      end if;
      
    when ci_non_symmetric_down | ci_non_symmetric_up =>
      ret_val.use_spare_cycle   := false;
      ret_val.use_pattern_match := false;
      
      if P_CAN_ADD_CONST then
        ret_val.use_rounder       := false;
        ret_val.use_rnd_const     := true;
        ret_val.latency           := 0;
      else
        ret_val.use_rounder       := true;
        ret_val.use_rnd_const     := false;
        ret_val.latency           := 1;
        ret_val.rounder_port      := use_pcin_port;
      end if;
      
    when others =>
      report "ERROR: FIR Compiler: fn_get_rounding_cnfg: invalid rounding value: "&integer'image(P_ROUNDING_MODE) severity error;
    end case;
    
    return ret_val;
  end function;

  function fn_get_path_base_i (P_WIDTHS,P_SRC : t_int_array; index: integer) return integer is
    variable cnt: integer:=0;
  begin
    for i in P_WIDTHS'LOW to P_WIDTHS'LOW+index-1 loop
      if P_SRC(i) = i then
        cnt := cnt + P_WIDTHS(i);
      end if;
    end loop;
    return cnt;
  end function fn_get_path_base_i;

  function fn_select_sl      ( i0  : std_logic; i1  : std_logic; sel : boolean) return std_logic is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if; -- sel
  end;

  function fn_is_data_reset(P_HAS_ARESETn: integer) return integer is
  begin
    if P_HAS_ARESETn = ci_data_vector_reset then
      return 1;
    else
      return 0;
    end if;
  end function fn_is_data_reset;

  function fn_is_cntrl_reset(P_HAS_ARESETn: integer) return integer is
  begin
    if P_HAS_ARESETn > ci_no_reset then
    -- i.e. control will be reset in both data_vector reset and control only
      return 1;
    else
      return 0;
    end if;
  end function fn_is_cntrl_reset;

--------------------------------------------------------------------------------
--From:  ../../hdl/halfband_decimation.vhd

    function fn_gen_dec_hb_ipbuff_pat ( P_FIXED_PAT       : boolean;
                                 P_NUM_CHANNELS    : integer; 
                                 P_CHANNEL_PATTERN : t_int_array
                                 ) return t_int_array is
      constant ci_pat_len         : integer := 2**log2roundup(P_NUM_CHANNELS);
      constant ci_num_pat         : integer := P_CHANNEL_PATTERN'LENGTH / ci_pat_len;
      constant ci_roundup_num_pat : integer := 2**log2roundup(ci_num_pat);
      -- constant ci_input_seq       : t_int_array(2*P_NUM_CHANNELS-1 downto 0) := P_CHANNEL_PATTERN(C_NUM_CHANNELS-1 downto 0)&P_CHANNEL_PATTERN(C_NUM_CHANNELS-1 downto 0);
      variable chan_i             : t_int_array(P_NUM_CHANNELS-1 downto 0) := (others=>-1);
      variable pat_offset,
               op_pat_offset,
               channel
               : integer := 0;
      variable ret_val            : t_int_array( ci_roundup_num_pat * 2 * ci_pat_len - 1 downto 0):=(others=>0);
    begin
      if not P_FIXED_PAT then
        for pat in 0 to ci_num_pat-1 loop
          pat_offset := pat*ci_pat_len;
          op_pat_offset := pat*ci_pat_len*2;
          chan_i     := (others=>-1);
          for i in 0 to P_NUM_CHANNELS-1 loop
            -- Output sequence
            channel := P_CHANNEL_PATTERN(pat_offset+i);
            
            -- 1st phase
            search: loop -- search for next occurance of the channel in the input sequence
              -- chan_i(channel) := (chan_i(channel) + 1) mod P_NUM_CHANNELS;
              chan_i(channel) := chan_i(channel) + 1;
              if P_CHANNEL_PATTERN(pat_offset+(chan_i(channel) mod P_NUM_CHANNELS)) = channel then
                exit search;
              end if;
            end loop search;
            ret_val(i+op_pat_offset) := chan_i(channel);
            --2nd phase
            search2: loop -- search for next occurance of the channel in the input sequence
              -- chan_i(channel) := (chan_i(channel) + 1) mod P_NUM_CHANNELS;
              chan_i(channel) := chan_i(channel) + 1;
              if P_CHANNEL_PATTERN(pat_offset+(chan_i(channel) mod P_NUM_CHANNELS)) = channel then
                exit search2;
              end if;
            end loop search2;
            -- 1st and 2nd phase are read sequentially but the lookup address is generated by concatenating chan_cnt and we_gen
            ret_val(i+op_pat_offset+ci_pat_len) := chan_i(channel);
          end loop;
        end loop;
      end if;
      return ret_val;
    end function;


end fir_compiler_v6_2_sim_pkg;
