--------------------------------------------------------------------------------
--  (c) Copyright 2006, 2009 Xilinx, Inc. All rights reserved.
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
-- Description:
--     Package containing all core specific functions
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.divroundup;
use xilinxcorelib.bip_utils_pkg_v2_0.log2roundup;
use xilinxcorelib.bip_utils_pkg_v2_0.get_min;
use xilinxcorelib.bip_utils_pkg_v2_0.get_max;
use xilinxcorelib.cic_compiler_v3_0_fir_pkg.all;

package cic_compiler_v3_0_pkg is
        
  -- GLOBAL CONSTANTS --
  ----------------------
 
  ----------------------
  type stage_array is array(0 to 5) of integer;
  type LOG2_LUT_ARRAY is array (natural range <>) of integer;

  function number_of_digits(data_value : integer; radix : integer) return integer;
  function CICBMAX (INPUT_WIDTH : integer; RATE : integer; NUM_STAGES : integer; DIFF_DELAY : integer) return integer;
  function CHOOSE(n,k:integer) return integer;
  function VARERRGAIN(stage,RATE,NUM_STAGES,DIFF_DELAY : integer) return real;
  function BITSTOTRIM(stage,STAGE_TYPE,INPUT_WIDTH,OUTPUT_WIDTH,RATE,NUM_STAGES,DIFF_DELAY : integer) return integer;
  function MAX (LEFT, RIGHT: INTEGER) return INTEGER;
  function MIN (LEFT, RIGHT: INTEGER) return INTEGER;
  function INTERPSTAGEBITS (stage,STAGE_TYPE,INPUT_WIDTH,RATE,NUM_STAGES,DIFF_DELAY : integer) return integer;
  
  function DEC_SCALING_DELAY_CALC (RATE_TYPE, SCALE_BITS, BMAX, OUTPUT_WIDTH : integer) return integer;

  function SCALING_DELAY_CALC (RATE_TYPE, INT_BMAX, OUTPUT_WIDTH : integer) return integer;

  function W_comb(num_stages, rate, diff_delay, input_width, folding : integer) return stage_array;
  function W_integrator(num_stages, rate, diff_delay, input_width, folding : integer) return stage_array;
  function B_integrator(num_stages, min_rate, max_rate, diff_delay, input_width, output_width, folding : integer) return stage_array;
  function B_comb(num_stages, min_rate, max_rate, diff_delay, input_width, output_width, folding, rounding : integer) return stage_array;

  function CN1L2R_LUT (MIN_RATE,MAX_RATE,STAGES : integer) return LOG2_LUT_ARRAY;
  function DEC_SCALE_LUT_CALC (MIN_RATE,MAX_RATE,STAGES : integer) return LOG2_LUT_ARRAY;

  -- New functions and constants
  constant C_MAX_STAGES : integer:=6;
  
  constant C_INTEGRATOR : integer:=0;
  constant C_COMB       : integer:=1;
  
  constant C_FIXED_RATE : integer:=0;
  constant C_PROG_RATE  : integer:=1;
  
  constant C_MAX_STAGE_ADDSUBS : integer :=3;
  
  constant C_MAX_FABADD_WIDTH : integer := 12; --across all families just now ??
  
  type t_bool_array is array (integer range <>) of boolean;
  
  type t_int_comb_section_config is
  record
    latency : integer;
    
    num_physical_stages : integer;
    folded              : t_bool_array(C_MAX_STAGES-1 downto 0);
    stages              : t_int_array(C_MAX_STAGES-1 downto 0);
    split_accums        : t_int_array(C_MAX_STAGES-1 downto 0);--not needed for synth, resource est only
    split_fabric        : t_bool_array(C_MAX_STAGES-1 downto 0);--not needed for synth, resource est only
    actual_widths       : t_int_array(C_MAX_STAGES-1 downto 0);
    
    din_delay             : integer;
  end record;
  
  function get_int_comb_section_config(
                                  C_INT_OR_COMB : integer;  
                                  C_NUM_STAGES  : integer;
                                  C_DIFF_DELAY  : integer;
                                  C_NUM_CHANNELS: integer;  
                                  C_CLKS_PER_SAMP : integer;
                                  C_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);  
                                  C_FAMILY_INFO   : t_family;
                                  C_USE_DSP       : integer;
                                  C_HAS_SCLR      : integer ) return t_int_comb_section_config;
  
  constant c_carryout            : integer:=0;
  constant c_carrycascout        : integer:=1;
  constant c_dsp_to_fabric_carry : integer:=2;
  constant c_fabric_carry        : integer:=3;
  constant c_gated_msb_carry     : integer:=4;
  
  type t_int_comb_stage_folded_config is
  record
    latency : integer;
    num_split_accums : integer;
    split_accum_delay : t_int_array(C_MAX_STAGE_ADDSUBS downto 0);--integer;
    accum_widths      : t_int_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    carry_method      : t_int_array(C_MAX_STAGE_ADDSUBS-1 downto 0);--t_bool_array(C_MAX_STAGE_ADDSUBS-1 downto 0);--boolean;
    
    add_sub_cnfg : t_emb_calc_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    add_sub_dtls : t_emb_calc_details_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    sum_lat   : integer;
    
    mem_depth : integer;
    
    din_delay : integer;
    
  end record;
  
  function get_int_comb_stage_folded_config(
                                        C_INT_OR_COMB : integer;
                                        C_NUM_STAGES  : integer;
                                        C_DIFF_DELAY  : integer;
                                        C_NUM_CHANNELS: integer;
                                        C_FAMILY_INFO : t_family;
                                        C_USE_DSP       : integer;
                                        C_WIDTH         : integer;
                                        C_USE_RTL       : boolean;
                                        C_LAST_STAGE    : boolean;
                                        C_ALIGN_OPS     : boolean;
                                        C_IPS_ALIGNED   : boolean;
                                        C_PAD_TO_STAGES : integer;
                                        C_HAS_SCLR      : integer ) return t_int_comb_stage_folded_config;
  
  type t_int_comb_stage_unfolded_config is
  record
    latency : integer;
    num_split_accums : integer;
    -- split_accum_delay : integer;
    split_accum_delay : t_int_array(C_MAX_STAGE_ADDSUBS downto 0);--integer;
    accum_widths      : t_int_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    carry_method      : t_int_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    
    add_sub_cnfg : t_emb_calc_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    add_sub_dtls : t_emb_calc_details_array(C_MAX_STAGE_ADDSUBS-1 downto 0);
    sum_lat   : integer;
    
    mem_depth : integer;
    
    din_delay : integer;
    
  end record;
  
  function get_int_comb_stage_unfolded_config(
                                        C_INT_OR_COMB : integer;
                                        C_DIFF_DELAY  : integer;
                                        C_NUM_CHANNELS: integer;
                                        C_FAMILY_INFO : t_family;
                                        C_USE_DSP       : integer;
                                        C_WIDTH         : integer;
                                        C_USE_RTL       : boolean;
                                        C_ALIGN_OPS     : boolean;
                                        C_IPS_ALIGNED   : boolean;
                                        C_HAS_SCLR      : integer ) return t_int_comb_stage_unfolded_config;

  type t_interpolate_config is
  record
    latency : integer;
    family  : t_family;
    
    ip_rate_cnt : integer;
    px_cnt      : integer;
    
    integrator  : t_int_comb_section_config;
    comb        : t_int_comb_section_config;
    
    chan_buffer   : t_ram;
    chan_buffer_addr : t_twopage_address;
    
  end record;
  
  function get_interpolate_engine_config(
                            C_NUM_STAGES : integer;
                            C_DIFF_DELAY : integer;
                            C_RATE : integer;
                            C_INPUT_WIDTH : integer;
                            C_OUTPUT_WIDTH : integer;
                            C_USE_DSP : integer;
                            C_HAS_ROUNDING : integer;
                            C_NUM_CHANNELS  : integer;
                            C_RATE_TYPE : integer;
                            C_MIN_RATE : integer;
                            C_MAX_RATE : integer;
                            C_SAMPLE_FREQ : integer;
                            C_CLK_FREQ : integer;
                            C_HAS_SCLR : integer;
                            C_USE_STREAMING_INTERFACE : integer;
                            C_XDEVICEFAMILY : string ;
                            C_COMB_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);
                            C_INT_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0)) return t_interpolate_config;


  function get_interpolate_config(C_HAS_DOUT_TREADY         : integer;
                                  C_NUM_STAGES              : integer;
                                  C_DIFF_DELAY              : integer;
                                  C_RATE                    : integer;
                                  C_INPUT_WIDTH             : integer;
                                  C_OUTPUT_WIDTH            : integer;
                                  C_USE_DSP                 : integer;
                                  C_HAS_ROUNDING            : integer;
                                  C_NUM_CHANNELS            : integer;
                                  C_RATE_TYPE               : integer;
                                  C_MIN_RATE                : integer;
                                  C_MAX_RATE                : integer;
                                  C_SAMPLE_FREQ             : integer;
                                  C_CLK_FREQ                : integer;
                                  C_HAS_SCLR                : integer;
                                  C_USE_STREAMING_INTERFACE : integer;
                                  C_XDEVICEFAMILY           : string ;
                                  C_COMB_WIDTHS             : t_int_array(C_MAX_STAGES-1 downto 0);
                                  C_INT_WIDTHS              : t_int_array(C_MAX_STAGES-1 downto 0)) return t_interpolate_config;

  
  type t_decimate_config is
  record
    latency : integer;
    family  : t_family;
    
    ip_rate_cnt : integer;
    px_cnt      : integer;
    
    integrator  : t_int_comb_section_config;
    comb        : t_int_comb_section_config;
    
    chan_buffer   : t_ram;
    chan_buffer_addr : t_twopage_address;
    
  end record;
  
  function get_decimate_engine_config(
                            C_NUM_STAGES : integer;
                            C_DIFF_DELAY : integer;
                            C_RATE : integer;
                            C_INPUT_WIDTH : integer;
                            C_OUTPUT_WIDTH : integer;
                            C_USE_DSP : integer;
                            C_HAS_ROUNDING : integer;
                            C_NUM_CHANNELS  : integer;
                            C_RATE_TYPE : integer;
                            C_MIN_RATE : integer;
                            C_MAX_RATE : integer;
                            C_SAMPLE_FREQ : integer;
                            C_CLK_FREQ : integer;
                            C_HAS_SCLR : integer;
                            C_USE_STREAMING_INTERFACE : integer;
                            C_XDEVICEFAMILY : string ;
                            C_COMB_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);
                            C_INT_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0)) return t_decimate_config;


  function get_decimate_config(C_HAS_DOUT_TREADY         : integer;
                               C_NUM_STAGES              : integer;
                               C_DIFF_DELAY              : integer;
                               C_RATE                    : integer;
                               C_INPUT_WIDTH             : integer;
                               C_OUTPUT_WIDTH            : integer;
                               C_USE_DSP                 : integer;
                               C_HAS_ROUNDING            : integer;
                               C_NUM_CHANNELS            : integer;
                               C_RATE_TYPE               : integer;
                               C_MIN_RATE                : integer;
                               C_MAX_RATE                : integer;
                               C_SAMPLE_FREQ             : integer;
                               C_CLK_FREQ                : integer;
                               C_HAS_SCLR                : integer;
                               C_USE_STREAMING_INTERFACE : integer;
                               C_XDEVICEFAMILY           : string ;
                               C_COMB_WIDTHS             : t_int_array(C_MAX_STAGES-1 downto 0);
                               C_INT_WIDTHS              : t_int_array(C_MAX_STAGES-1 downto 0)) return t_decimate_config;

  


  -- gen_package.pl doesn't handle constants in proedures and functions properly, so I'm just telling ot to ignore the AXI ones.  
  -- gui trans_off

  -- How many padding bytes are there in a field
  --
  function how_much_padding           (field_width : integer) return integer;



  -- ---------------------------------------------------------------------------------------------------------------------
  -- Data Input Channel Functions
  -- ---------------------------------------------------------------------------------------------------------------------

  -- Returns the with of the Data Input channel when there's no padding.  It's used to calculate the width of the FIFO
  --



  function calculate_data_in_width_no_padding(constant C_INPUT_WIDTH: in integer
                                              ) return integer;



  -- Takes the TDATA and TLAST AXI inputs for the Data In channel and packages them
  -- into a single vector to get stored in the data in FIFO.  All padding is removed from TDATA,
  -- as that isn't stored in the FIFO.
  --
  procedure axi_din_chan_build_fifo_in_vector(signal   tdata          : in std_logic_vector;
                                              signal   out_vector     : out std_logic_vector;
                                              constant C_INPUT_WIDTH  : in integer
                                              );
  
  -- Splits the Data Input Channel FIFO output into signals suitable for the interpolator, decimator, and
  -- event interface
  --
  procedure axi_din_chan_convert_fifo_out_vector_to_cic_in (constant fifo_vector    : in  std_logic_vector;
                                                            signal   data           : out std_logic_vector;
                                                            constant C_INPUT_WIDTH  : in  integer
                                                           );

  -- ---------------------------------------------------------------------------------------------------------------------
  -- Data Output Channel Functions
  -- ---------------------------------------------------------------------------------------------------------------------

  -- Returns the with of the Data Output channel when there's no padding.  It's used to calculate the width of the FIFO
  --
  function calculate_data_out_width_no_padding(constant C_OUTPUT_WIDTH: in integer;
                                               constant C_NUM_CHANNELS: in integer
                                               ) return integer;


  -- Takes all of the (relevant) outputs of the core and packages them
  -- into a single vector to get stored in the data out FIFO.  It does not add padding as that
  -- isn't stored in the FIFO.
  --
  procedure axi_dout_chan_build_fifo_in_vector(signal last_channel_out : in std_logic;
                                               signal dout             : in std_logic_vector;
                                               signal chan_out         : in std_logic_vector;
                                               signal chan_sync        : in std_logic;
                                               signal out_vector       : out std_logic_vector;
                                               constant C_OUTPUT_WIDTH : in integer;
                                               constant C_NUM_CHANNELS : in integer
                                               );

  -- Splits the Data Output Channel FIFO output into AXI signals, adding padding between
  -- the various fields where required by the AXI rules
  --
  procedure axi_dout_chan_convert_fifo_out_vector_to_axi (constant fifo_vector    : in std_logic_vector;
                                                          signal   tdata          : out std_logic_vector;
                                                          signal   tuser          : out std_logic_vector;
                                                          signal   tlast          : out std_logic;
                                                          constant C_OUTPUT_WIDTH : in integer;
                                                          constant C_NUM_CHANNELS : in integer
                                                          );
  -- gui trans_on
  
end cic_compiler_v3_0_pkg;

package body cic_compiler_v3_0_pkg is

  -- purpose: calculates the number of bits needed to represent the specified data_value
  -- based on the supplied radix
  function number_of_digits (data_value : integer; radix : integer) return integer is
    variable dwidth : integer := 0;
  begin
    while radix**dwidth-1 < data_value and data_value > 0 loop
      dwidth := dwidth + 1;
    end loop;
    return dwidth;
  end number_of_digits;

  -- function to compute the maximum bit-width based on input bit-width, rate, stages, 
  -- and diff delay; based on Hogenauer paper equation (11) without '-1' to yield width instead of MSB number
  function CICBMAX (INPUT_WIDTH : integer; RATE : integer; NUM_STAGES : integer; DIFF_DELAY : integer) RETURN integer is
          variable max_bit_width : integer := 1;
  begin
          max_bit_width := integer(ceil(real(NUM_STAGES) * LOG2(real(RATE*DIFF_DELAY)) + real(INPUT_WIDTH)));
          return(max_bit_width);
  end function CICBMAX;

  -- 'choose' function for bit trimming computations
  function CHOOSE(n,k:integer) return integer is
          variable num : real := 0.0;
          variable den : real := 0.0;
          variable result : integer := 0;
  begin
          num := 1.0;
          den := 1.0;
          if k < n then
                  for j in (k+1) to n loop
                          num := num * real(j);
                  end loop;
                  for i in 1 to (n-k) loop
                        den := den * real(i);
                  end loop;
          end if;
          result := integer(num/den);

          return result;
  end function CHOOSE;

  -- variance calculation for bit trimming
  function VARERRGAIN(stage,RATE,NUM_STAGES,DIFF_DELAY : integer) return real is
          variable posneg : real := 1.0;
          variable h_k,Fj,Fj2 : real := 0.0;
          variable result : real := 0.0;
  begin
          Fj2 := 0.0;
          if stage > NUM_STAGES then
                  posneg := 1.0;                  
                  for k in 0 to (2*NUM_STAGES + 1 - stage) loop
                          h_k := posneg * real(CHOOSE(2*NUM_STAGES + 1 - stage, k));
                          Fj2 := Fj2 + h_k * h_k;
                          posneg := posneg*(-1.0);
                  end loop;

          else
                  for k in 0 to ((RATE*DIFF_DELAY - 1)*NUM_STAGES + stage - 1) loop
                          posneg := 1.0;
                          h_k := 0.0;
                          for l in 0 to (k / (RATE * DIFF_DELAY)) loop
                                  h_k := h_k + posneg * real(CHOOSE(NUM_STAGES,l)) * real(CHOOSE((NUM_STAGES-stage+k) - (RATE*DIFF_DELAY*l),k - (RATE*DIFF_DELAY*l)));

                                  posneg := posneg*(-1.0);
                          end loop;
                          Fj2 := Fj2 + h_k * h_k;
                  end loop;
          end if;
          result := Fj2;
          return result;
  end function VARERRGAIN;

  -- calculation of number of bits to trim
  -- stage is stage number within integrators or comb sections; STAGE_TYPE indicates integrator (0) or comb (1)
  -- this is used to facilitate the definition of constants for bit trimming
  function BITSTOTRIM(stage,STAGE_TYPE,INPUT_WIDTH,OUTPUT_WIDTH,RATE,NUM_STAGES,DIFF_DELAY : integer) return integer is
          variable Bmax,Bmin,Bout,trim_bits,bits_tmp : real;
          variable Bj : real;
          variable Ej,sigma_sqrd_j,log2_sigma_j,Fj2 : real;
          
  begin
          Bmax := real(CICBMAX(INPUT_WIDTH,RATE,NUM_STAGES,DIFF_DELAY));

          Bj := Bmax - real(OUTPUT_WIDTH);

          if Bj > 0.0 then
                  Ej := 2.0**Bj;
                  sigma_sqrd_j := (1.0/12.0)* (Ej*Ej);
                  log2_sigma_j := (0.5)*LOG2(sigma_sqrd_j);
          else
                  Ej := 0.0;
                  sigma_sqrd_j := 0.0;
                  log2_sigma_j := 0.0;
          end if;

          if stage > NUM_STAGES then
                  if STAGE_TYPE = 0 then
                          trim_bits := 0.0; -- no trimming for integrator registers beyond number of actual stages
                  else
                          trim_bits := Bmax - real(OUTPUT_WIDTH); -- peg trimming to maximum for comb stages beyond actual number
                  end if;
          else
                  if STAGE_TYPE = 0 then
                          Fj2 := VARERRGAIN(stage,RATE,NUM_STAGES,DIFF_DELAY); -- integrator stage
                  else
                          Fj2 := VARERRGAIN((stage + NUM_STAGES),RATE,NUM_STAGES,DIFF_DELAY); -- comb stage - adjust stage number
                  end if;

                  -- if Fj2 > 0.0 then
                  if ((Fj2 > 0.0) and (Bj > 0.0)) then
                        --trim_bits := floor((-0.5)*LOG2(Fj2) + log2_sigma_j + 0.5*log2(6.0/real(NUM_STAGES)));
                        bits_tmp := floor((-0.5)*LOG2(Fj2) + log2_sigma_j + 0.5*log2(6.0/real(NUM_STAGES)));
                        if bits_tmp < 0.0 then
                                trim_bits := 0.0;
                        else
                                trim_bits := bits_tmp;
                        end if;
                  else
                        trim_bits := 0.0;
                  end if;
          end if;

          return integer(trim_bits);

  end function BITSTOTRIM;

  -- function to return max of two integers
  function MAX (LEFT, RIGHT: INTEGER) return INTEGER is
  begin
    if LEFT > RIGHT then return LEFT;
    else return RIGHT;
    end if;
  end MAX;

  -- function to return min of two integers
  function MIN (LEFT, RIGHT: INTEGER) return INTEGER is
  begin
    if LEFT < RIGHT then return LEFT;
    else return RIGHT;
    end if;
  end MIN;

  function INTERPSTAGEBITS (stage,STAGE_TYPE,INPUT_WIDTH,RATE,NUM_STAGES,DIFF_DELAY : integer) return integer is
          variable bitwidth : integer;
          variable tmp1 : real;
          variable tmp0_0 : real;
          variable tmp0_1 : real;
  begin

          if STAGE_TYPE = 0 then
                  -- integrator stages
                  if stage > NUM_STAGES then
                          tmp0_0 := 2.0**(real(2*NUM_STAGES - (NUM_STAGES + stage)));
                  else
                          tmp0_0 := round(2.0**(real(2*NUM_STAGES - (NUM_STAGES + stage))));
                  end if;
                  tmp0_1 := round(real(RATE * DIFF_DELAY) ** (real(stage)));
                  tmp1 := (tmp0_0 * tmp0_1)/real(RATE);
                  --tmp1 := (2.0**(real(2*NUM_STAGES - (NUM_STAGES + stage))) * real(RATE * DIFF_DELAY) ** (real(stage))) / real(RATE);
                  bitwidth := INPUT_WIDTH + integer(ceil(log2(tmp1)));

          else
                  -- comb stages
                  bitwidth := INPUT_WIDTH + stage;
                  -- special case for diff delay 1
                  if DIFF_DELAY = 1 then
                          if stage = NUM_STAGES then
                                  bitwidth := INPUT_WIDTH + NUM_STAGES - 1;
                          end if;
                  end if;

          end if;

          return bitwidth;

  end INTERPSTAGEBITS;

  -- calculate the maximum register growth for the comb section of an interpolation filter
  function W_comb(num_stages, rate, diff_delay, input_width, folding : integer) return stage_array is
    variable W : stage_array;
  begin
    for j in 1 to (num_stages) loop
        if folding = 0 then
                -- unfolded stages - use bit trimming register sizing
                W(j-1) := INTERPSTAGEBITS (j,1,input_width,rate,num_stages,diff_delay);
        else
                -- folded stages - use largest register size for all 
                W(j-1) := INTERPSTAGEBITS (num_stages,1,input_width,rate,num_stages,diff_delay);
        end if;
    end loop;

    for j in num_stages+1 to 6 loop
      W(j-1) := 0;
    end loop;

    return W;
  end W_comb;

  -- calculate the maximum register growth for the integrator section of an interpolation filter
  function W_integrator(num_stages, rate, diff_delay, input_width, folding : integer) return stage_array is
    variable W : stage_array;
  begin
    for k in 1 to (num_stages) loop
            if folding = 0 then
                    -- unfolded stages - use bit trimming register sizing
                    W(k-1) := INTERPSTAGEBITS (k,0,input_width,rate,num_stages,diff_delay);
            else
                    -- folded stages - use largets register size for all
                    W(k-1) := INTERPSTAGEBITS (num_stages,0,input_width,rate,num_stages,diff_delay);
            end if;
    end loop;

    for k in num_stages+1 to 6 loop
      W(k-1) := 0;
    end loop;

    return W;
  end W_integrator;
  
  -- calculate stage register sizing for decimator filter integrator stages
 function B_integrator(num_stages, min_rate, max_rate, diff_delay, input_width, output_width, folding : integer) return stage_array is
    variable Bmax : integer := 1;
    variable j : integer := 1;
    variable Btrim : integer := 1;
    variable B : stage_array;
  begin
    Bmax := CICBMAX(input_width, max_rate, num_stages, diff_delay );
    for i in 0 to num_stages-1 loop
      j := i + 1;

      if folding = 0 then
              -- no folding; set register sizes normally with possible bit trimming
              Btrim := BITSTOTRIM(j, 0, input_width, output_width, max_rate, num_stages, diff_delay);
      else
              -- folding; set register sizes all based on first stage
              Btrim := BITSTOTRIM(1, 0, input_width, output_width, max_rate, num_stages, diff_delay);
      end if;
      B(i) := Bmax - Btrim;
    end loop;

    for k in num_stages to 5 loop
      B(k) := 0;
    end loop;
    return B;
  end B_integrator;

  -- calculate stage register sizing for decimator filter comb stages
  function B_comb(num_stages, min_rate, max_rate, diff_delay, input_width, output_width, folding, rounding : integer) return stage_array is
    variable Bmax : integer := 1;
    variable j : integer := 1;
    variable Btrim, Bround : integer := 1;
    variable B : stage_array;
  begin

    Bmax := CICBMAX(input_width, max_rate, num_stages, diff_delay );

    for i in 0 to num_stages-1 loop
      j := i + 1;

      if folding = 0 then
              -- no folding, set register sizes normally with possible bit trimming
              Btrim := BITSTOTRIM(j, 1, input_width, output_width, max_rate, num_stages, diff_delay);
      else
              -- folding, set register sizes all based on first stage
              Btrim := BITSTOTRIM(1, 1, input_width, output_width, max_rate, num_stages, diff_delay);
      end if;
      B(i) := Bmax - Btrim;
    end loop;

    -- adjust register sizes for rounding if necessary
    if rounding = 1 then
            if ((folding = 0) and (B(num_stages-1) < Bmax)) then
                    -- no folding and limited precision; make size of last stage one more than that of previous stage to keep full precision in last comb
                    --B(num_stages-1) := B(num_stages-2) + 1;

            elsif ((folding = 1) and (B(num_stages-1) < Bmax)) then
                    -- folding and limited precision
                    Bround := MAX(B(1), (Bmax - BITSTOTRIM(num_stages-1, 1, input_width, output_width, max_rate, num_stages, diff_delay) + 1));
                    for i in 1 to num_stages loop
                --    B(i) := Bround;
                    end loop;
            end if;
    end if;

    for k in num_stages to 5 loop
      B(k) := 0;
    end loop;
    return B;
  end B_comb;

  -- function to compute delay due to dynamic scaling in interpolator
  function SCALING_DELAY_CALC (RATE_TYPE, INT_BMAX, OUTPUT_WIDTH : integer) return integer is
          variable scaling_latency : integer;
  begin
          scaling_latency := 0;

          if RATE_TYPE = 1 then
                if OUTPUT_WIDTH < INT_BMAX then
                          scaling_latency := 2;   
                end if;
          end if;

          return scaling_latency;

  end SCALING_DELAY_CALC;

  -- function to compute delay due to dynamic scaling in decimator
  function DEC_SCALING_DELAY_CALC (RATE_TYPE, SCALE_BITS, BMAX, OUTPUT_WIDTH : integer) return integer is
          variable scaling_latency : integer;
  begin
          scaling_latency := 0;

          if (RATE_TYPE = 1) and (SCALE_BITS > 0) and (OUTPUT_WIDTH < BMAX) then
                  scaling_latency := 2;
          end if;

          return scaling_latency;

  end DEC_SCALING_DELAY_CALC;

  -- function to compute ceil((N-1)log2(R)) table look-up values for dynamic scaling in CIC interpolator
  function CN1L2R_LUT (MIN_RATE,MAX_RATE,STAGES : integer) return LOG2_LUT_ARRAY is 
          variable lut_vals : LOG2_LUT_ARRAY (0 to MAX_RATE-MIN_RATE);
          variable i : integer := 0;
          variable tmp1,tmp2 : real;
  begin
          i := 0;
          for rate in MIN_RATE to MAX_RATE loop
                  tmp1 := ceil(real(STAGES-1)*log2(real(MAX_RATE)));
                  tmp2 := ceil(real(STAGES-1)*log2(real(rate)));
                  lut_vals(i) := integer(tmp1 - tmp2);
                  i := i + 1;
          end loop;

          return lut_vals;

  end CN1L2R_LUT;

  -- function to compute table look-up values for dynamic scaling in CIC decimator
  function DEC_SCALE_LUT_CALC (MIN_RATE,MAX_RATE,STAGES : integer) return LOG2_LUT_ARRAY is 
          variable lut_vals : LOG2_LUT_ARRAY (0 to MAX_RATE-MIN_RATE);
          variable i : integer := 0;
          variable tmp1,tmp2 : real;
  begin
          i := 0;
          for rate in MIN_RATE to MAX_RATE loop
                  tmp1 := ceil(real(STAGES)*log2(real(rate)));
                  tmp2 := ceil(real(STAGES)*log2(real(MIN_RATE)));
                  lut_vals(i) := integer(tmp1 - tmp2);
                  i := i + 1;
          end loop;

          return lut_vals;

  end DEC_SCALE_LUT_CALC;

  --New functions-----
  function get_int_comb_section_config(
                                  C_INT_OR_COMB : integer;  
                                  C_NUM_STAGES  : integer;
                                  C_DIFF_DELAY  : integer;
                                  C_NUM_CHANNELS: integer;  
                                  C_CLKS_PER_SAMP : integer;
                                  C_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);  
                                  C_FAMILY_INFO   : t_family;
                                  C_USE_DSP       : integer;
                                  C_HAS_SCLR      : integer ) return t_int_comb_section_config is
    variable config : t_int_comb_section_config;
    variable full_stages:integer;
    variable stage_config_unfolded: t_int_comb_stage_unfolded_config;
    variable stage_config_folded: t_int_comb_stage_folded_config;
    variable curr_stage,
             max_accum : integer:=0;
  begin
    
    config.num_physical_stages:=divroundup(C_NUM_STAGES,C_CLKS_PER_SAMP);
    
    --parallel
    config.folded:=(others=>false);
    config.stages:=(others=>1);
    
    if C_NUM_STAGES>1 and C_CLKS_PER_SAMP>1 then
      -- mdl trans_off
      report "Folding.....";
      -- mdl trans_on
      --folded
      if config.num_physical_stages=1 then
        config.stages(0):=get_min(C_NUM_STAGES,C_CLKS_PER_SAMP);
        config.folded(0):=true;
      else
        full_stages:=C_NUM_STAGES/C_CLKS_PER_SAMP;
        -- gui trans_off
        config.stages(full_stages-1 downto 0):=(others=>get_min(C_NUM_STAGES,C_CLKS_PER_SAMP));
        config.folded(full_stages-1 downto 0):=(others=>true);
        -- gui trans_on
        -- gui insert_on
        -- for i in 0 to full_stages-1 loop
          -- config.stages(i):=get_min(C_NUM_STAGES,C_CLKS_PER_SAMP);
          -- config.folded(i):=true;
        -- end loop;
        -- gui insert_off
        if C_NUM_STAGES rem C_CLKS_PER_SAMP > 0 then
          --final stage partially utilized
          config.stages(full_stages):=C_NUM_STAGES rem C_CLKS_PER_SAMP;
          if C_NUM_STAGES rem C_CLKS_PER_SAMP = 1 then
            --last stage unfolded
            config.folded(full_stages):=false;
          else
            config.folded(full_stages):=true;
          end if;
        end if;
      end if;
    end if;
    
    --Determine if the input data needs to be delayed. Although this is being retrived via a function
    --both the comb and integrator stages should be the same regardless if they are folded or not so slightly
    --redundant call
    
    config.latency:=0;
    curr_stage:=0;
    -- gui trans_off
    config.actual_widths:=(others=>0);
    -- gui trans_on
    for stage in 0 to config.num_physical_stages-1 loop
      max_accum:=0;
      for i in curr_stage to curr_stage+config.stages(stage)-1 loop
        if C_WIDTHS(i)>max_accum then
          max_accum:=C_WIDTHS(i);
        end if;
      end loop;
      for i in curr_stage to curr_stage+config.stages(stage)-1 loop
        config.actual_widths(i):=max_accum;
      end loop;
      curr_stage:=curr_stage+config.stages(stage);
      
      if config.folded(stage) then
        stage_config_folded:=get_int_comb_stage_folded_config(
                                            C_INT_OR_COMB,
                                            config.stages(stage),
                                            C_DIFF_DELAY,
                                            C_NUM_CHANNELS,
                                            C_FAMILY_INFO,
                                            C_USE_DSP,
                                            config.actual_widths(curr_stage-1),--C_WIDTHS(curr_stage-1),
                                            false,--default
                                            (stage=config.num_physical_stages-1),
                                            true, --temp values********
                                            true,
                                            config.stages(get_max(0,stage-1)),
                                            C_HAS_SCLR);
        if stage=0 then                                            
          config.din_delay:=stage_config_folded.din_delay;
        end if;
        config.latency:=config.latency+stage_config_folded.latency;
        --For resource estimate
        config.split_accums(stage):=stage_config_folded.num_split_accums;
        config.split_fabric(stage):=stage_config_folded.add_sub_cnfg(stage_config_folded.num_split_accums-1).family.has_fabric_dsp48 or
                                    stage_config_folded.add_sub_cnfg(0).family.has_fabric_dsp48;
      else
        stage_config_unfolded:=get_int_comb_stage_unfolded_config(
                                            C_INT_OR_COMB,
                                            C_DIFF_DELAY,
                                            C_NUM_CHANNELS,
                                            C_FAMILY_INFO,
                                            C_USE_DSP,
                                            config.actual_widths(curr_stage-1),--C_WIDTHS(curr_stage-1),
                                            false,--default
                                            true,--temp values********
                                            true,
                                            C_HAS_SCLR);
        if stage=0 then                                            
          config.din_delay:=stage_config_unfolded.din_delay;
        end if;
        config.latency:=config.latency+stage_config_unfolded.latency;
        --For resource estimate
        config.split_accums(stage):=stage_config_unfolded.num_split_accums;
        config.split_fabric(stage):=stage_config_unfolded.add_sub_cnfg(stage_config_unfolded.num_split_accums-1).family.has_fabric_dsp48 or
                                    stage_config_unfolded.add_sub_cnfg(0).family.has_fabric_dsp48;
      end if;
    end loop;
    
    return config;
  end get_int_comb_section_config;
  
  function get_int_comb_stage_folded_config(
                                        C_INT_OR_COMB : integer;
                                        C_NUM_STAGES  : integer;
                                        C_DIFF_DELAY  : integer;
                                        C_NUM_CHANNELS: integer;
                                        C_FAMILY_INFO : t_family;
                                        C_USE_DSP       : integer;
                                        C_WIDTH         : integer;
                                        C_USE_RTL       : boolean;
                                        C_LAST_STAGE    : boolean;
                                        C_ALIGN_OPS     : boolean;
                                        C_IPS_ALIGNED   : boolean;
                                        C_PAD_TO_STAGES : integer;
                                        C_HAS_SCLR      : integer ) return t_int_comb_stage_folded_config is
    variable config : t_int_comb_stage_folded_config;
    
    constant opcodes_used: t_calc_func_used := funcs_emb_calc(select_func_list(
                                                                (0=>C_add_A_concat_B,1=>P_add_A_concat_B,2=>NOP),
                                                                (0=>C_add_A_concat_B,1=>P_add_A_concat_B,2=>C,3=>NOP),
                                                                C_HAS_SCLR=1));
                                               
    variable remaining_width : integer:=C_WIDTH;
    variable accum_max,
             accum: integer;
  begin
    
    --Default configuration
    config.add_sub_cnfg(0):=(
      family         => C_FAMILY_INFO,
      implementation => 1,
      pre_add        => 0,
      pre_add_func   => c_preadd_add,
      pre_add_ipreg  => 0,
      pre_add_midreg => 0,
      a_delay        => select_integer(0,1,C_FAMILY_INFO.has_fabric_dsp48),--1 to balance opcode reg and 1 to balance opcode generation, 1 reg always enabled of dsp
      b_delay        => select_integer(0,1,C_FAMILY_INFO.has_fabric_dsp48),
      p_delay        => 0,--no extra p delay required
      a_src          => 0,--fabric
      a_sign         => c_signed,
      b_sign         => c_signed,
      d_sign         => c_signed,
      a_width        => 1,--only used for preadder calc
      b_width        => 1,
      reg_opcode     => select_integer(1,0,C_FAMILY_INFO.has_fabric_dsp48),
      enable_pat_det => false,
      pattern        => "000000000000000000000000000000000000000000000000",--gen_pattern(reqs.round_mode,reqs.path_reqs.accum_width(0),reqs.path_reqs.output_width(0),false,48),
      mask           => "000000000000000000000000000000000000000000000000",--gen_mask(reqs.path_reqs.accum_width(0),reqs.path_reqs.output_width(0),false,48),
      post_add_width => C_WIDTH,--config.accum_widths(0),
      calc_func_used => opcodes_used,
      split_post_adder => false,
      has_redundant => p_none
    );
    
    
    accum_max:=48;
    if C_FAMILY_INFO.emb_calc_prim=p_dsp48 then
      accum_max:=35;
    end if;
    
    config.num_split_accums:=0;
    config.split_accum_delay(0):=0;
    
    while remaining_width > 0 loop --accum_max loop
      --The structure arrays are indexes 0 to so use a local variable, rabassa wae unhappy with the sub -1 everywhere
      accum:=config.num_split_accums;
      config.num_split_accums:=config.num_split_accums+1;
      
      if C_FAMILY_INFO.has_fabric_dsp48 then
        --Don't split fabric implementation currently
        remaining_width:=0;
        config.carry_method(0):=c_carryout;
        config.accum_widths(0):=C_WIDTH;  
      elsif C_FAMILY_INFO.emb_calc_prim=p_dsp48 then
        config.accum_widths(accum):=get_min(35,remaining_width);
        remaining_width:=remaining_width-35;        
        config.carry_method(accum):=c_fabric_carry;
        if accum<C_MAX_STAGE_ADDSUBS then
          config.split_accum_delay(config.num_split_accums):=3;
        end if;
      else
        config.accum_widths(accum):=get_min(48,remaining_width);
        remaining_width:=remaining_width-48;
        --Use cascade carry by default
        config.carry_method(accum):=c_carrycascout;
        if accum<C_MAX_STAGE_ADDSUBS then
          if C_FAMILY_INFO.supports_dsp48e or C_FAMILY_INFO.emb_calc_prim=p_dsp48a then
            config.split_accum_delay(config.num_split_accums):=1;
          else
            config.split_accum_delay(config.num_split_accums):=2;
          end if;
        end if;
      end if;
      
      -- gui trans_off
      config.add_sub_cnfg(accum):=config.add_sub_cnfg(0);
      -- gui trans_on
      -- gui insert_on
      -- config.add_sub_cnfg(accum):=ret_emb_calc_dtls(config.add_sub_cnfg(0));
      -- gui insert_off
      config.add_sub_cnfg(accum).post_add_width:=config.accum_widths(accum);
      config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
      
    end loop;
    
    if config.accum_widths(accum) <= C_MAX_FABADD_WIDTH
       and config.num_split_accums > 1
       and not((C_FAMILY_INFO.emb_calc_prim=p_dsp48) and C_INT_OR_COMB=C_COMB) then
      
      if C_FAMILY_INFO.emb_calc_prim/=p_dsp48a then
        --Use a fabric adder for last adder
        config.add_sub_cnfg(accum).family.emb_calc_prim    :=p_mult18s;
        config.add_sub_cnfg(accum).family.treat_as_s3adsp  :=true;
        config.add_sub_cnfg(accum).family.has_fabric_dsp48 :=true;
        config.add_sub_cnfg(accum).a_delay:=1;
        config.add_sub_cnfg(accum).b_delay:=1;
      
        --Switch carry out method of previous adder, 2nd last
        if C_FAMILY_INFO.supports_dsp48e or (C_INT_OR_COMB=C_INTEGRATOR and C_FAMILY_INFO.emb_calc_prim/=p_dsp48) then
          --Carry out directly compatible with fabric
          config.carry_method(config.num_split_accums-2):=c_carryout;
          config.split_accum_delay(accum):=2;
        elsif C_FAMILY_INFO.emb_calc_prim/=p_dsp48 then
          --Spartan families need to have their dsp carry converted to a fabric format when subtract functionality, inversion (only S6 as can't drive fabric on s3adsp)
          config.carry_method(config.num_split_accums-2):=c_dsp_to_fabric_carry;
          config.split_accum_delay(accum):=3;
        end if;
        
        config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
      else
        --On Sandia put fabric adder on bottom
        
        --Swap accumulation widths
        config.add_sub_cnfg(accum).post_add_width:=config.accum_widths(0);
        config.add_sub_cnfg(0).post_add_width:=config.accum_widths(accum);
        config.accum_widths(0):=config.accum_widths(accum);
        config.accum_widths(accum):=config.add_sub_cnfg(accum).post_add_width;
        
        config.add_sub_cnfg(0).family.emb_calc_prim    :=p_mult18s;
        config.add_sub_cnfg(0).family.treat_as_s3adsp  :=true;
        config.add_sub_cnfg(0).family.has_fabric_dsp48 :=true;
        config.add_sub_cnfg(0).a_delay:=1;
        config.add_sub_cnfg(0).b_delay:=1;
        
        if C_INT_OR_COMB=C_COMB then
          config.split_accum_delay(1):=3;
          config.carry_method(0):=c_dsp_to_fabric_carry;
        else
          config.split_accum_delay(1):=2;
          config.carry_method(0):=c_carryout; --can use carry out directly as adding
        end if;
        
        config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
        config.add_sub_dtls(0):=dtls_emb_calc(config.add_sub_cnfg(0));
      
      end if;
      
    end if;
    
    
    if C_LAST_STAGE then
      if C_INT_OR_COMB = C_COMB then
        config.mem_depth := C_DIFF_DELAY * C_NUM_CHANNELS * C_PAD_TO_STAGES;
      else
        config.mem_depth := C_NUM_CHANNELS * C_PAD_TO_STAGES;
      end if;
    else
      if C_INT_OR_COMB = C_COMB then
        config.mem_depth := C_DIFF_DELAY * C_NUM_CHANNELS * C_NUM_STAGES;
      else
        config.mem_depth := C_NUM_CHANNELS * C_NUM_STAGES;
      end if;
    end if;
    
    if C_USE_RTL then
      config.sum_lat:=1;
      config.din_delay:=0;
    else
      config.sum_lat:=2;
      if C_FAMILY_INFO.has_fabric_dsp48 then
        config.din_delay:=0;
      else
        config.din_delay:=1;
      end if;
    end if;
    
    config.latency:=config.sum_lat+C_NUM_STAGES-1;
    
    if not C_USE_RTL and config.num_split_accums>1 then
      -- config.latency:=config.latency+((config.num_split_accums-1)*config.split_accum_delay);
      for i in 0 to config.num_split_accums-1 loop
        config.latency:=config.latency+config.split_accum_delay(i);
      end loop; 
    end if;
    
    return config;
  end get_int_comb_stage_folded_config;
  
  function get_int_comb_stage_unfolded_config(
                                        C_INT_OR_COMB : integer;
                                        C_DIFF_DELAY  : integer;
                                        C_NUM_CHANNELS: integer;
                                        C_FAMILY_INFO : t_family;
                                        C_USE_DSP       : integer;
                                        C_WIDTH         : integer;
                                        C_USE_RTL       : boolean;
                                        C_ALIGN_OPS     : boolean;
                                        C_IPS_ALIGNED   : boolean;
                                        C_HAS_SCLR     : integer) return t_int_comb_stage_unfolded_config is
    variable config : t_int_comb_stage_unfolded_config;
    
    variable opcodes_used: t_calc_func_used;-- := funcs_emb_calc((0=>C_add_A_concat_B,1=>P_add_C,2=>NOP));
    
    variable remaining_width: integer:=C_WIDTH;
    variable accum_max,
             accum      : integer;
  begin
    
    if C_INT_OR_COMB = C_COMB then
      config.mem_depth := C_DIFF_DELAY * C_NUM_CHANNELS;
    else
      config.mem_depth := C_NUM_CHANNELS;
    end if;
    
    if C_INT_OR_COMB=C_INTEGRATOR and config.mem_depth-2 <0 then
      opcodes_used:=funcs_emb_calc((0=>P_add_C,1=>NOP));
    else
      opcodes_used:=funcs_emb_calc((0=>C_add_A_concat_B,1=>NOP));
    end if;
    
    if C_HAS_SCLR=1 then
      opcodes_used(C):=true;
    end if;
    
    --Default configuration
    config.add_sub_cnfg(0):=(
      family         => C_FAMILY_INFO,
      implementation => 1,
      pre_add        => 0,
      pre_add_func   => c_preadd_add,
      pre_add_ipreg  => 0,
      pre_add_midreg => 0,
      a_delay        => select_integer(0,1,C_FAMILY_INFO.has_fabric_dsp48),--1 to balance opcode reg and 1 to balance opcode generation, 1 reg always enabled of dsp
      b_delay        => select_integer(0,1,C_FAMILY_INFO.has_fabric_dsp48),
      p_delay        => 0,--no extra p delay required
      a_src          => 0,--fabric
      a_sign         => c_signed,
      b_sign         => c_signed,
      d_sign         => c_signed,
      a_width        => 1,--only used for preadder calc
      b_width        => 1,
      reg_opcode     => select_integer(1,0,C_FAMILY_INFO.has_fabric_dsp48),
      enable_pat_det => false,
      pattern        => "000000000000000000000000000000000000000000000000",--gen_pattern(reqs.round_mode,reqs.path_reqs.accum_width(0),reqs.path_reqs.output_width(0),false,48),
      mask           => "000000000000000000000000000000000000000000000000",--gen_mask(reqs.path_reqs.accum_width(0),reqs.path_reqs.output_width(0),false,48),
      post_add_width => config.accum_widths(0),
      calc_func_used => opcodes_used,
      split_post_adder => false,
      has_redundant => p_none
    );
    
    accum_max:=48;
    if C_FAMILY_INFO.emb_calc_prim=p_dsp48 and opcodes_used(C_add_A_concat_B) then
      --fed back accum so need different boudary
      accum_max:=35;
    end if;
    
    config.num_split_accums:=0;
    config.split_accum_delay(0):=0;
    
    while remaining_width > 0 loop
      --The structure arrays are indexes 0 to so use a local variable, rabassa wae unhappy with the sub -1 everywhere
      accum:=config.num_split_accums;
      config.num_split_accums:=config.num_split_accums+1;
      
      if C_FAMILY_INFO.has_fabric_dsp48 then
        --Don't split fabric implementation currently
        remaining_width:=0;
        config.carry_method(0):=c_carryout;
        config.accum_widths(0):=C_WIDTH;  
      elsif C_FAMILY_INFO.emb_calc_prim=p_dsp48 then
        -- Note: V4 implementation will probably not work fro COMB(subtraction) but unfolded is not currently used. Would
        -- have to be for SIMO/MISO implementations
        config.accum_widths(accum):=get_min(35,remaining_width);
        remaining_width:=remaining_width-35;
        if opcodes_used(P_add_C) then
          --fabric carry
          config.carry_method(accum):=c_fabric_carry;
          if accum<C_MAX_STAGE_ADDSUBS then
            config.split_accum_delay(config.num_split_accums):=3;
          end if;
        else
          --use msb gated
          config.carry_method(accum):=c_gated_msb_carry;
          if accum<C_MAX_STAGE_ADDSUBS then
            config.split_accum_delay(config.num_split_accums):=3;--2;
          end if;
        end if;
      else
        config.accum_widths(accum):=get_min(48,remaining_width);
        remaining_width:=remaining_width-48;
        --Use cascade carry by default
        config.carry_method(accum):=c_carrycascout;
        if accum<C_MAX_STAGE_ADDSUBS then
          if C_FAMILY_INFO.supports_dsp48e or C_FAMILY_INFO.emb_calc_prim=p_dsp48a then
            config.split_accum_delay(config.num_split_accums):=1;
          else
            config.split_accum_delay(config.num_split_accums):=2;
          end if;
        end if;
      end if;
      
      -- gui trans_off
      config.add_sub_cnfg(accum):=config.add_sub_cnfg(0);
      -- gui trans_on
      -- gui insert_on
      -- config.add_sub_cnfg(accum):=ret_emb_calc_dtls(config.add_sub_cnfg(0));
      -- gui insert_off
      config.add_sub_cnfg(accum).post_add_width:=config.accum_widths(accum);
      config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
      
      
    end loop;
    
    if config.accum_widths(accum) <= C_MAX_FABADD_WIDTH
       and config.num_split_accums > 1
       and not((C_FAMILY_INFO.emb_calc_prim=p_dsp48) and C_INT_OR_COMB=C_COMB) then
      
      if C_FAMILY_INFO.emb_calc_prim/=p_dsp48a then
        --use a fabric adder for last adder
        config.add_sub_cnfg(accum).family.emb_calc_prim    :=p_mult18s;
        config.add_sub_cnfg(accum).family.treat_as_s3adsp  :=true;
        config.add_sub_cnfg(accum).family.has_fabric_dsp48 :=true;
        config.add_sub_cnfg(accum).a_delay:=1;
        config.add_sub_cnfg(accum).b_delay:=1;
        
        --Switch carry out method of previous adder
        if C_FAMILY_INFO.supports_dsp48e or (C_INT_OR_COMB=C_INTEGRATOR and C_FAMILY_INFO.emb_calc_prim/=p_dsp48) then
          --Carry out directly compatible with fabric
          config.carry_method(config.num_split_accums-2):=c_carryout;
          config.split_accum_delay(accum):=2;
        elsif C_FAMILY_INFO.emb_calc_prim/=p_dsp48 and C_INT_OR_COMB=C_COMB then
          --Spartan families need to have their dsp carry converted to a fabric format when subtract functionality, inversion
          config.carry_method(config.num_split_accums-2):=c_dsp_to_fabric_carry;
          config.split_accum_delay(accum):=3;
        end if;
        
        config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
      else
        --On Sandia put fabric adder on bottom
        
        --Swap accumulation widths
        config.add_sub_cnfg(accum).post_add_width:=config.accum_widths(0);
        config.add_sub_cnfg(0).post_add_width:=config.accum_widths(accum);
        config.accum_widths(0):=config.accum_widths(accum);
        config.accum_widths(accum):=config.add_sub_cnfg(accum).post_add_width;
        
        config.add_sub_cnfg(0).family.emb_calc_prim    :=p_mult18s;
        config.add_sub_cnfg(0).family.treat_as_s3adsp  :=true;
        config.add_sub_cnfg(0).family.has_fabric_dsp48 :=true;
        config.add_sub_cnfg(0).a_delay:=1;
        config.add_sub_cnfg(0).b_delay:=1;
        
        if C_INT_OR_COMB=C_COMB then
          config.split_accum_delay(1):=3;
          config.carry_method(0):=c_dsp_to_fabric_carry;
        else
          config.split_accum_delay(1):=2;
          config.carry_method(0):=c_carryout; --can use carry out directly as adding
        end if;
        
        config.add_sub_dtls(accum):=dtls_emb_calc(config.add_sub_cnfg(accum));
        config.add_sub_dtls(0):=dtls_emb_calc(config.add_sub_cnfg(0));
      
      end if;
      
    end if;
    
    if C_USE_RTL then
      config.sum_lat:=1;
      config.din_delay:=0;
    else
      config.sum_lat:=2;
      if C_FAMILY_INFO.has_fabric_dsp48 then
        config.din_delay:=0;
      else
        config.din_delay:=1;
      end if;
    end if;
    
    config.latency:=config.sum_lat;
    
    if not C_USE_RTL and config.num_split_accums>1 then
      -- config.latency:=config.latency+((config.num_split_accums-1)*config.split_accum_delay);
      for i in 0 to config.num_split_accums-1 loop
        config.latency:=config.latency+config.split_accum_delay(i);
      end loop;
    end if;
    
    return config;
  end get_int_comb_stage_unfolded_config;
  
  function get_interpolate_engine_config(
                            C_NUM_STAGES : integer;
                            C_DIFF_DELAY : integer;
                            C_RATE : integer;
                            C_INPUT_WIDTH : integer;
                            C_OUTPUT_WIDTH : integer;
                            C_USE_DSP : integer;
                            C_HAS_ROUNDING : integer;
                            C_NUM_CHANNELS  : integer;
                            C_RATE_TYPE : integer;
                            C_MIN_RATE : integer;
                            C_MAX_RATE : integer;
                            C_SAMPLE_FREQ : integer;
                            C_CLK_FREQ : integer;
                            C_HAS_SCLR : integer;
                            C_USE_STREAMING_INTERFACE : integer;
                            C_XDEVICEFAMILY : string ;
                            C_COMB_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);
                            C_INT_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0)) return t_interpolate_config is
    variable config: t_interpolate_config;
    constant family_info: t_family := family_val(C_XDEVICEFAMILY);
    variable family_info_qual: t_family;
    variable last_stage_width: integer;
  begin
    family_info_qual:=family_info;
    if C_USE_DSP=0 then
      family_info_qual.emb_calc_prim   :=p_mult18s; --this will be usused and not generated given opcodes
      family_info_qual.treat_as_s3adsp  :=true;
      family_info_qual.has_fabric_dsp48:=true; --ensures fabric adder
    end if;
    config.family:=family_info_qual;
    
    -- C_SAMPLE_FREQ defines the highest frequency for the lower upsample rate.
    -- To obtain the output oversampling rate ip_rate_cnt should be divided by 
    -- C_MIN_RATE.
    config.ip_rate_cnt:=(C_CLK_FREQ/C_SAMPLE_FREQ)/C_NUM_CHANNELS;
    if C_RATE_TYPE=C_PROG_RATE then
      config.ip_rate_cnt:=(config.ip_rate_cnt/C_MIN_RATE)*C_MIN_RATE;
    end if;
    
    config.comb:=get_int_comb_section_config(
                              C_COMB,
                              C_NUM_STAGES,
                              C_DIFF_DELAY,
                              C_NUM_CHANNELS,
                              config.ip_rate_cnt,
                              C_COMB_WIDTHS,
                              family_info_qual,
                              C_USE_DSP,
                              C_HAS_SCLR);
                              
    config.px_cnt:=config.comb.stages(0);
    
    config.integrator:=get_int_comb_section_config(
                              C_INTEGRATOR,
                              C_NUM_STAGES,
                              C_DIFF_DELAY,
                              C_NUM_CHANNELS,
                              config.ip_rate_cnt/C_MIN_RATE,
                              C_INT_WIDTHS,
                              family_info_qual,
                              C_USE_DSP,
                              C_HAS_SCLR);
    
    config.chan_buffer:=(
            family              => family_info_qual,
            implementation      => 1,
            mem_type            => c_dram,--force DRAM just now                                   
            write_mode          => 0,--read first
            has_ce              => 1,--obsolete
            use_mif             => 0,
            resource_opt        => c_area,
            is_rom              => false);
    
    config.chan_buffer_addr:=(
            family => family_info_qual,
            implementation => 1,
            addr_width => get_max(1,log2roundup(2*C_NUM_CHANNELS)),
            page_size => C_NUM_CHANNELS,
            num_enables => 2 );
    
    -- Calc latency
    config.latency:=config.comb.din_delay;
    
    config.latency:=config.latency+select_integer(0,1,C_HAS_SCLR=1 or C_RATE_TYPE=C_PROG_RATE);
    
    config.latency:=config.latency+select_integer(0,1,C_USE_STREAMING_INTERFACE=0 and C_NUM_CHANNELS>1);
    
    config.latency:=config.latency+config.comb.latency;
    
    if C_NUM_CHANNELS>1 then
      config.latency:=config.latency+4-config.integrator.din_delay;
    else
      config.latency:=config.latency+1;
    end if;
    
    config.latency:=config.latency+config.integrator.latency+config.integrator.din_delay;
    
    --Rabassa compatibility
    last_stage_width:=C_INT_WIDTHS(C_NUM_STAGES-1);
    
    if C_OUTPUT_WIDTH < last_stage_width and C_RATE_TYPE=C_PROG_RATE then
      --output scaling when prog rate
      config.latency:=config.latency+2;--fixed lat, should use function ****
    end if;
    
    config.latency:=config.latency+1;--output reg
    
    return config;
  end get_interpolate_engine_config;




  -- Return the config of the overall core (processing engine + AXI interface).
  -- This is really just a latency change - AXI adds 3 cycles to the latency when C_HAS_DOUT_TREADY = 1
  --  
  function get_interpolate_config(C_HAS_DOUT_TREADY         : integer;
                                  C_NUM_STAGES              : integer;
                                  C_DIFF_DELAY              : integer;
                                  C_RATE                    : integer;
                                  C_INPUT_WIDTH             : integer;
                                  C_OUTPUT_WIDTH            : integer;
                                  C_USE_DSP                 : integer;
                                  C_HAS_ROUNDING            : integer;
                                  C_NUM_CHANNELS            : integer;
                                  C_RATE_TYPE               : integer;
                                  C_MIN_RATE                : integer;
                                  C_MAX_RATE                : integer;
                                  C_SAMPLE_FREQ             : integer;
                                  C_CLK_FREQ                : integer;
                                  C_HAS_SCLR                : integer;
                                  C_USE_STREAMING_INTERFACE : integer;
                                  C_XDEVICEFAMILY           : string ;
                                  C_COMB_WIDTHS             : t_int_array(C_MAX_STAGES-1 downto 0);
                                  C_INT_WIDTHS              : t_int_array(C_MAX_STAGES-1 downto 0)) return t_interpolate_config is

    variable config: t_interpolate_config;
  begin
    config := get_interpolate_engine_config( C_NUM_STAGES              => C_NUM_STAGES              ,
                                             C_DIFF_DELAY              => C_DIFF_DELAY              ,
                                             C_RATE                    => C_RATE                    ,
                                             C_INPUT_WIDTH             => C_INPUT_WIDTH             ,
                                             C_OUTPUT_WIDTH            => C_OUTPUT_WIDTH            ,
                                             C_USE_DSP                 => C_USE_DSP                 ,
                                             C_HAS_ROUNDING            => C_HAS_ROUNDING            ,
                                             C_NUM_CHANNELS            => C_NUM_CHANNELS            ,
                                             C_RATE_TYPE               => C_RATE_TYPE               ,
                                             C_MIN_RATE                => C_MIN_RATE                ,
                                             C_MAX_RATE                => C_MAX_RATE                ,
                                             C_SAMPLE_FREQ             => C_SAMPLE_FREQ             ,
                                             C_CLK_FREQ                => C_CLK_FREQ                ,
                                             C_HAS_SCLR                => C_HAS_SCLR                ,
                                             C_USE_STREAMING_INTERFACE => C_USE_STREAMING_INTERFACE ,
                                             C_XDEVICEFAMILY           => C_XDEVICEFAMILY           ,
                                             C_COMB_WIDTHS             => C_COMB_WIDTHS             ,
                                             C_INT_WIDTHS              => C_INT_WIDTHS
                                             );
    
    
    if C_HAS_DOUT_TREADY = 1 then
      config.latency:=config.latency + 3;
    end if;
    
    return config;
 end get_interpolate_config;



    

    
  function get_decimate_engine_config(
                            C_NUM_STAGES : integer;
                            C_DIFF_DELAY : integer;
                            C_RATE : integer;
                            C_INPUT_WIDTH : integer;
                            C_OUTPUT_WIDTH : integer;
                            C_USE_DSP : integer;
                            C_HAS_ROUNDING : integer;
                            C_NUM_CHANNELS  : integer;
                            C_RATE_TYPE : integer;
                            C_MIN_RATE : integer;
                            C_MAX_RATE : integer;
                            C_SAMPLE_FREQ : integer;
                            C_CLK_FREQ : integer;
                            C_HAS_SCLR : integer;
                            C_USE_STREAMING_INTERFACE : integer;
                            C_XDEVICEFAMILY : string ;
                            C_COMB_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0);
                            C_INT_WIDTHS : t_int_array(C_MAX_STAGES-1 downto 0)) return t_decimate_config is
    variable config: t_decimate_config;
    constant family_info: t_family := family_val(C_XDEVICEFAMILY);
    variable family_info_qual: t_family;
    
    constant Bmax : integer := CICBMAX(C_INPUT_WIDTH, C_MAX_RATE, C_NUM_STAGES, C_DIFF_DELAY);
    constant DYN_SCALE_BITS : integer := Bmax - CICBMAX(C_INPUT_WIDTH,C_MIN_RATE,C_NUM_STAGES,C_DIFF_DELAY);
  
  begin
    family_info_qual:=family_info;
    if C_USE_DSP=0 then
      family_info_qual.emb_calc_prim   :=p_mult18s; --this will be usused and not generated given opcodes
      family_info_qual.treat_as_s3adsp  :=true;
      family_info_qual.has_fabric_dsp48:=true; --ensures fabric adder
    end if;
    config.family:=family_info_qual;
    
    config.ip_rate_cnt:=(C_CLK_FREQ/C_SAMPLE_FREQ)/C_NUM_CHANNELS;
    
    config.integrator:=get_int_comb_section_config(
                              C_INTEGRATOR,
                              C_NUM_STAGES,
                              C_DIFF_DELAY,
                              C_NUM_CHANNELS,
                              config.ip_rate_cnt,
                              C_INT_WIDTHS,
                              family_info_qual,
                              C_USE_DSP,
                              C_HAS_SCLR);
    
    config.px_cnt:=config.integrator.stages(0);
    
    config.comb:=get_int_comb_section_config(
                              C_COMB,
                              C_NUM_STAGES,
                              C_DIFF_DELAY,
                              C_NUM_CHANNELS,
                              config.ip_rate_cnt*C_MIN_RATE,
                              C_COMB_WIDTHS,
                              family_info_qual,
                              C_USE_DSP,
                              C_HAS_SCLR);
                              
    config.chan_buffer:=(
            family              => family_info_qual,
            implementation      => 1,
            mem_type            => c_dram,--force DRAM just now                                   
            write_mode          => 0,--read first
            has_ce              => 1,--obsolete
            use_mif             => 0,
            resource_opt        => c_area,
            is_rom              => false);
    
    config.chan_buffer_addr:=(
            family => family_info_qual,
            implementation => 1,
            addr_width => get_max(1,log2roundup(2*C_NUM_CHANNELS)),
            page_size => C_NUM_CHANNELS,
            num_enables => 2 );
    
    -- Calc latency
    config.latency:=config.integrator.din_delay;
    
    if not(C_RATE_TYPE=C_FIXED_RATE or DYN_SCALE_BITS = 0 or C_OUTPUT_WIDTH >= Bmax) then
      config.latency:=config.latency+2-config.integrator.din_delay;--fixed lat should use function***
    end if;
    
    config.latency:=config.latency+select_integer(0,1,C_RATE_TYPE=C_PROG_RATE);
    
    config.latency:=config.latency+config.integrator.latency;
    
    if C_NUM_CHANNELS>1 then
      config.latency:=config.latency+4-config.integrator.din_delay;--3;
    else
      config.latency:=config.latency+2;
    end if;
    
    config.latency:=config.latency+config.comb.latency+config.comb.din_delay;
    
    if C_USE_STREAMING_INTERFACE=0 and C_NUM_CHANNELS>1 then
      --output buffer
      config.latency:=config.latency+(C_NUM_CHANNELS-1)*config.comb.stages(0)
                                    +2;
    end if;
    
    config.latency:=config.latency+1;--output reg
    
    return config;
    
  end get_decimate_engine_config;


  -- Return the config of the overall core (processing engine + AXI interface).
  -- This is really just a latency change - AXI adds 3 cycles to the latency when C_HAS_DOUT_TREADY = 1
  --  
  function get_decimate_config(C_HAS_DOUT_TREADY         : integer;
                               C_NUM_STAGES              : integer;
                               C_DIFF_DELAY              : integer;
                               C_RATE                    : integer;
                               C_INPUT_WIDTH             : integer;
                               C_OUTPUT_WIDTH            : integer;
                               C_USE_DSP                 : integer;
                               C_HAS_ROUNDING            : integer;
                               C_NUM_CHANNELS            : integer;
                               C_RATE_TYPE               : integer;
                               C_MIN_RATE                : integer;
                               C_MAX_RATE                : integer;
                               C_SAMPLE_FREQ             : integer;
                               C_CLK_FREQ                : integer;
                               C_HAS_SCLR                : integer;
                               C_USE_STREAMING_INTERFACE : integer;
                               C_XDEVICEFAMILY           : string ;
                               C_COMB_WIDTHS             : t_int_array(C_MAX_STAGES-1 downto 0);
                               C_INT_WIDTHS              : t_int_array(C_MAX_STAGES-1 downto 0)) return t_decimate_config is

    variable config: t_decimate_config;
  begin
    config := get_decimate_engine_config( C_NUM_STAGES              => C_NUM_STAGES              ,
                                          C_DIFF_DELAY              => C_DIFF_DELAY              ,
                                          C_RATE                    => C_RATE                    ,
                                          C_INPUT_WIDTH             => C_INPUT_WIDTH             ,
                                          C_OUTPUT_WIDTH            => C_OUTPUT_WIDTH            ,
                                          C_USE_DSP                 => C_USE_DSP                 ,
                                          C_HAS_ROUNDING            => C_HAS_ROUNDING            ,
                                          C_NUM_CHANNELS            => C_NUM_CHANNELS            ,
                                          C_RATE_TYPE               => C_RATE_TYPE               ,
                                          C_MIN_RATE                => C_MIN_RATE                ,
                                          C_MAX_RATE                => C_MAX_RATE                ,
                                          C_SAMPLE_FREQ             => C_SAMPLE_FREQ             ,
                                          C_CLK_FREQ                => C_CLK_FREQ                ,
                                          C_HAS_SCLR                => C_HAS_SCLR                ,
                                          C_USE_STREAMING_INTERFACE => C_USE_STREAMING_INTERFACE ,
                                          C_XDEVICEFAMILY           => C_XDEVICEFAMILY           ,
                                          C_COMB_WIDTHS             => C_COMB_WIDTHS             ,
                                          C_INT_WIDTHS              => C_INT_WIDTHS
                                          );

    if C_HAS_DOUT_TREADY = 1 then
      config.latency:=config.latency + 3;
    end if;

    return config;
    
  end get_decimate_config;

  
  -- gui trans_off

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



  -- ---------------------------------------------------------------------------------------------------------------------
  -- Data Input Channel Functions
  -- ---------------------------------------------------------------------------------------------------------------------

  -- Returns the with of the Data Input channel when there's no padding.  It's used to calculate the width of the FIFO
  --
  function calculate_data_in_width_no_padding(constant C_INPUT_WIDTH: in integer) return integer is
    
    variable width : integer := 0;
  begin

    width := C_INPUT_WIDTH;

    return width;
    
  end function;
    
        


  -- Takes the TDATA AXI input for the Data In channel and packages it
  -- into a single vector to get stored in the data in FIFO.  All padding is removed from TDATA,
  -- as that isn't stored in the FIFO.
  --
  procedure axi_din_chan_build_fifo_in_vector(signal   tdata          : in std_logic_vector;
                                              signal   out_vector     : out std_logic_vector;
                                              constant C_INPUT_WIDTH  : in integer                                              
                                              ) is

    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
  begin

    -- The output vector is packed from LSB to MSB as follows:
    --   TDATA->DIN
    --

    field_width                                         := C_INPUT_WIDTH;
    out_vector(out_ptr + field_width -1 downto out_ptr) <= tdata(C_INPUT_WIDTH-1 downto 0);
  end procedure;


  -- Splits the Data Input Channel FIFO output into signals suitable for the interpolator, decimator, and
  -- event interface
  --
  procedure axi_din_chan_convert_fifo_out_vector_to_cic_in (constant fifo_vector    : in  std_logic_vector;
                                                            signal   data           : out std_logic_vector;
                                                            constant C_INPUT_WIDTH  : in  integer
                                                           ) is
    variable in_ptr        : integer := 0; -- The position of the next field in the input (padded) vector
    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
     
  begin
    -- The FIFO vector is packed from LSB to MSB as:
    --   tdata (no padding)

    -- TDATA
    -- -----
    field_width                   := C_INPUT_WIDTH;
    data(field_width -1 downto 0) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);

  end procedure;

    
  -- ---------------------------------------------------------------------------------------------------------------------
  -- Data Output Channel Functions
  -- ---------------------------------------------------------------------------------------------------------------------

  -- Returns the with of the Data Output channel when there's no padding.  It's used to calculate the width of the FIFO
  --
  function calculate_data_out_width_no_padding(constant C_OUTPUT_WIDTH: in integer;
                                               constant C_NUM_CHANNELS: in integer
                                               ) return integer is
    variable width : integer := 0;
  begin

    width := C_OUTPUT_WIDTH;

    if C_NUM_CHANNELS > 1 then

      -- TLAST signal
      -- ---------------
      width := width + 1;
      
      -- CHAN_OUT field
      -- ---------------
      width := width + get_max(1,number_of_digits(C_NUM_CHANNELS-1,2));
      
      -- CHAN_SYNC field
      -- ---------------
      width := width + 1;
    end if;

    return width;
    
  end function;
    
        


  -- Takes all of the (relevant) outputs of the core and packages them
  -- into a single vector to get stored in the data out FIFO.  It does not add padding as that
  -- isn't stored in the FIFO.
  --
  procedure axi_dout_chan_build_fifo_in_vector(signal   last_channel_out : in std_logic;
                                               signal   dout             : in std_logic_vector;
                                               signal   chan_out         : in std_logic_vector;
                                               signal   chan_sync        : in std_logic;
                                               signal   out_vector       : out std_logic_vector;
                                               constant C_OUTPUT_WIDTH   : in integer;
                                               constant C_NUM_CHANNELS   : in integer
                                               ) is

    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
  begin

    -- The output vector is packed from LSB to MSB as follows:
    --   last_channel_out
    --   dout
    --   chan_out
    --   chan_sync
    --
    -- There is no padding, as this will get stored in a FIFO

    if C_NUM_CHANNELS > 1 then
      field_width                                       := 1;
      out_vector(out_ptr)                               <= last_channel_out;
      out_ptr                                           := out_ptr + field_width;
    end if;

    field_width                                         := C_OUTPUT_WIDTH;
    out_vector(out_ptr + field_width -1 downto out_ptr) <= dout;
    out_ptr                                             := out_ptr + field_width;


    if C_NUM_CHANNELS > 1 then
      -- CHAN_OUT field
      -- ---------------
      field_width                                         := get_max(1,number_of_digits(C_NUM_CHANNELS-1,2));
      out_vector(out_ptr + field_width -1 downto out_ptr) <= chan_out;
      out_ptr                                             := out_ptr + field_width;

           
      -- CHAN_SYNC field
      -- ---------------
      field_width         := 1;
      out_vector(out_ptr) <= chan_sync;
      out_ptr             := out_ptr + field_width;

    end if;
  end procedure;

  -- Splits the Data Output Channel FIFO output into AXI signals, adding padding between
  -- the various fields where required by the AXI rules
  --
  procedure axi_dout_chan_convert_fifo_out_vector_to_axi (constant fifo_vector    : in std_logic_vector;
                                                          signal   tdata          : out std_logic_vector;
                                                          signal   tuser          : out std_logic_vector;
                                                          signal   tlast          : out std_logic;
                                                          constant C_OUTPUT_WIDTH : in integer;
                                                          constant C_NUM_CHANNELS : in integer
                                                           ) is
    variable in_ptr        : integer := 0; -- The position of the next field in the input (padded) vector
    variable out_ptr       : integer := 0; -- The position of the next field in the output (unpadded) vector
    variable field_width   : integer;      -- Holds the width of the field we're working on and makes the code more consistent
    variable padding_width : integer;      -- Holds the width of the padding we're working on and makes the code more consistent
    variable sign_bit      : std_logic;    -- The sign bit we're using to extend

     
  begin
    -- The FIFO vector is packed from LSB to MSB as:
    --   last_channel_out
    --   DOUT
    --   chan_out
    --   chan_sync

    in_ptr        := 0;

    if C_NUM_CHANNELS > 1 then
      -- Copy last_channel_out to tlast
      field_width := 1;
      tlast       <= fifo_vector(in_ptr);
      in_ptr      := in_ptr + field_width;
    end if;
      
    
    -- The DOUT field needs to be sign extended to an 8 bit boundary
    -- The chan_out and chan_synch fields will be 0 extended to an 8 bit boundary
    
    -- TDATA
    -- -----
    field_width   := C_OUTPUT_WIDTH;
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
      
    if C_NUM_CHANNELS > 1 then
      -- TUSER
      -- ------
      out_ptr       := 0;

      -- CHAN_OUT field
      -- ---------------
      field_width                                    := get_max(1,number_of_digits(C_NUM_CHANNELS-1,2));
      tuser(out_ptr + field_width -1 downto out_ptr) <= fifo_vector(in_ptr + field_width - 1 downto in_ptr);
      out_ptr                                        := out_ptr + field_width;
      in_ptr                                         := in_ptr  + field_width;

      -- CHAN_OUT field padding
      -- ----------------------
      padding_width                                     := how_much_padding(field_width);
      tuser(out_ptr + padding_width - 1 downto out_ptr) <= (others => '0'); 
      out_ptr                                           := out_ptr + padding_width;
           
      -- CHAN_SYNC field
      -- ---------------
      field_width    := 1;
      tuser(out_ptr) <= fifo_vector(in_ptr);
      out_ptr        := out_ptr + field_width;
    
      -- CHAN_SYNC field padding
      -- ----------------------
      padding_width := 7;
      tuser(out_ptr + padding_width - 1 downto out_ptr) <= (others => '0');
    end if;
  end procedure;
  -- gui trans_on
      
end cic_compiler_v3_0_pkg;




