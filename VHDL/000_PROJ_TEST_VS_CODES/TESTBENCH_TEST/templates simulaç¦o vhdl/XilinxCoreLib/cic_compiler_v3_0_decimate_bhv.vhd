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
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.cic_compiler_v3_0_pkg.all;
use Xilinxcorelib.bip_utils_pkg_v2_0.get_max;
use Xilinxcorelib.bip_utils_pkg_v2_0.int_to_slv;

library work;

entity cic_compiler_v3_0_decimate_bhv is
  generic (
    C_NUM_STAGES              : integer     := 4;
    C_DIFF_DELAY              : integer     := 1;
    C_RATE                    : integer     := 4;
    C_INPUT_WIDTH             : integer     := 18;
    C_OUTPUT_WIDTH            : integer     := 26;
    C_USE_DSP                 : integer     := 0;
    C_HAS_ROUNDING            : integer     := 0;
    C_NUM_CHANNELS            : integer     := 1;
    C_RATE_TYPE               : integer     := 0;
    C_MIN_RATE                : integer     := 4;
    C_MAX_RATE                : integer     := 4;
    C_SAMPLE_FREQ             : integer     := 100;
    C_CLK_FREQ                : integer     := 100;
    C_HAS_CE                  : integer     := 0;
    C_HAS_SCLR                : integer     := 0;
    C_HAS_ND                  : integer     := 1;
    C_USE_STREAMING_INTERFACE : integer     := 0;
    C_FAMILY                  : string      := "virtex6";
    C_COMB_WIDTHS             : stage_array := (others => 0);
    C_INT_WIDTHS              : stage_array := (others => 0)
    );
  port (
    DIN                : in  std_logic_vector (C_INPUT_WIDTH-1 downto 0);
    ND                 : in  std_logic;
    RATE               : in  std_logic_vector (number_of_digits(C_MAX_RATE, 2)-1 downto 0);
    RATE_WE            : in  std_logic;
    CE                 : in  std_logic;
    SCLR               : in  std_logic;
    CLK                : in  std_logic;
    DOUT               : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
    RDY                : out std_logic;
    RFD                : out std_logic;
    CHAN_SYNC          : out std_logic;
    CHAN_OUT           : out std_logic_vector (get_max(1, number_of_digits(C_NUM_CHANNELS-1, 2))-1 downto 0);
    halt               : in  std_logic;                     
    ready_for_new_rate : out std_logic;
    aresetn            : in  std_logic
    );
end cic_compiler_v3_0_decimate_bhv;

architecture behavioral of cic_compiler_v3_0_decimate_bhv is
  function select_integer (
    i0  : integer;
    i1  : integer;
    sel : boolean)
    return integer is
  begin
    if sel then
      return i1;
    else
      return i0;
    end if;  -- sel
  end select_integer;
  --
  
  constant core_config : t_decimate_config := get_decimate_engine_config(
    C_NUM_STAGES,
    C_DIFF_DELAY,
    C_RATE,
    C_INPUT_WIDTH,
    C_OUTPUT_WIDTH,
    C_USE_DSP,
    C_HAS_ROUNDING,
    C_NUM_CHANNELS,
    C_RATE_TYPE,
    C_MIN_RATE,
    C_MAX_RATE,
    C_SAMPLE_FREQ,
    C_CLK_FREQ,
    C_HAS_SCLR,
    C_USE_STREAMING_INTERFACE,
    C_FAMILY,
    (0 => C_COMB_WIDTHS(0), 1 => C_COMB_WIDTHS(1), 2 => C_COMB_WIDTHS(2), 3 => C_COMB_WIDTHS(3), 4 => C_COMB_WIDTHS(4), 5 => C_COMB_WIDTHS(5)),
    (0 => C_INT_WIDTHS(0), 1 => C_INT_WIDTHS(1), 2 => C_INT_WIDTHS(2), 3 => C_INT_WIDTHS(3), 4 => C_INT_WIDTHS(4), 5 => C_INT_WIDTHS(5)));

  constant LATENCY   : integer := core_config.latency;
  signal latency_ptr : integer := LATENCY - LATENCY + select_integer(0, 1, C_NUM_CHANNELS > 1);  -- investigate, repeated below ******

  -- define arrays for bit trimming
  type CIC_INT_I_ARRAY is array (1 to 6) of integer;
  type CIC_INT_C_ARRAY is array (1 to 7) of integer;

  -- define constants for register sizing
  constant BMAX           : integer := CICBMAX(C_INPUT_WIDTH, C_MAX_RATE, C_NUM_STAGES, C_DIFF_DELAY);
  constant DYN_SCALE_BITS : integer := BMAX - CICBMAX(C_INPUT_WIDTH, C_MIN_RATE, C_NUM_STAGES, C_DIFF_DELAY);

  -- constant I_REG_WIDTHS : CIC_INT_I_ARRAY := (MAX(C_INT_WIDTHS(0),1), MAX(C_INT_WIDTHS(1),1), MAX(C_INT_WIDTHS(2),1), MAX(C_INT_WIDTHS(3),1), MAX(C_INT_WIDTHS(4),1), MAX(C_INT_WIDTHS(5),1));
  constant I_REG_WIDTHS : CIC_INT_I_ARRAY := (MAX(core_config.integrator.actual_widths(0), 1), MAX(core_config.integrator.actual_widths(1), 1), MAX(core_config.integrator.actual_widths(2), 1), MAX(core_config.integrator.actual_widths(3), 1), MAX(core_config.integrator.actual_widths(4), 1), MAX(core_config.integrator.actual_widths(5), 1));

  constant I_REG_SHIFT : CIC_INT_I_ARRAY := ((BMAX-I_REG_WIDTHS(1)), (I_REG_WIDTHS(1)-I_REG_WIDTHS(2)), (I_REG_WIDTHS(2)-I_REG_WIDTHS(3)), (I_REG_WIDTHS(3)-I_REG_WIDTHS(4)), (I_REG_WIDTHS(4)-I_REG_WIDTHS(5)), (I_REG_WIDTHS(5)-I_REG_WIDTHS(6)));

  -- constant C_REG_WIDTHS : CIC_INT_C_ARRAY := (MAX(C_COMB_WIDTHS(0),C_OUTPUT_WIDTH),MAX(C_COMB_WIDTHS(1),C_OUTPUT_WIDTH),MAX(C_COMB_WIDTHS(2),C_OUTPUT_WIDTH),MAX(C_COMB_WIDTHS(3),C_OUTPUT_WIDTH),MAX(C_COMB_WIDTHS(4),C_OUTPUT_WIDTH),MAX(C_COMB_WIDTHS(5),C_OUTPUT_WIDTH), C_OUTPUT_WIDTH);
  constant C_REG_WIDTHS : CIC_INT_C_ARRAY := (MAX(core_config.comb.actual_widths(0), C_OUTPUT_WIDTH), MAX(core_config.comb.actual_widths(1), C_OUTPUT_WIDTH), MAX(core_config.comb.actual_widths(2), C_OUTPUT_WIDTH), MAX(core_config.comb.actual_widths(3), C_OUTPUT_WIDTH), MAX(core_config.comb.actual_widths(4), C_OUTPUT_WIDTH), MAX(core_config.comb.actual_widths(5), C_OUTPUT_WIDTH), C_OUTPUT_WIDTH);

  constant C_REG_SHIFT : CIC_INT_C_ARRAY := ((I_REG_WIDTHS(C_NUM_STAGES)-C_REG_WIDTHS(1)), (C_REG_WIDTHS(1)-C_REG_WIDTHS(2)), (C_REG_WIDTHS(2)-C_REG_WIDTHS(3)), (C_REG_WIDTHS(3)-C_REG_WIDTHS(4)), (C_REG_WIDTHS(4)-C_REG_WIDTHS(5)), (C_REG_WIDTHS(5)-C_REG_WIDTHS(6)), C_REG_WIDTHS(6)-C_REG_WIDTHS(7));


  -- define registers with appropriate sizes - model with zero latency
  -- Integrator sections
  type I_1_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(1)-1 downto 0);
  type I_2_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(2)-1 downto 0);
  type I_3_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(3)-1 downto 0);
  type I_4_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(4)-1 downto 0);
  type I_5_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(5)-1 downto 0);
  type I_6_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(I_REG_WIDTHS(6)-1 downto 0);
  signal I_1 : I_1_ARRAY := (others => to_signed(0, I_REG_WIDTHS(1)));
  signal I_2 : I_2_ARRAY := (others => to_signed(0, I_REG_WIDTHS(2)));
  signal I_3 : I_3_ARRAY := (others => to_signed(0, I_REG_WIDTHS(3)));
  signal I_4 : I_4_ARRAY := (others => to_signed(0, I_REG_WIDTHS(4)));
  signal I_5 : I_5_ARRAY := (others => to_signed(0, I_REG_WIDTHS(5)));
  signal I_6 : I_6_ARRAY := (others => to_signed(0, I_REG_WIDTHS(6)));


  -- Comb sections differential delay registers - as many as number of stage times diff delay
  type C_1_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(1)-1 downto 0);
  type C_2_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(2)-1 downto 0);
  type C_3_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(3)-1 downto 0);
  type C_4_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(4)-1 downto 0);
  type C_5_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(5)-1 downto 0);
  type C_6_ARRAY is array (0 to C_NUM_CHANNELS-1) of signed(C_REG_WIDTHS(6)-1 downto 0);

  signal CM1_1 : C_1_ARRAY := (others => to_signed(0, C_REG_WIDTHS(1)));
  signal CM1_2 : C_2_ARRAY := (others => to_signed(0, C_REG_WIDTHS(2)));
  signal CM1_3 : C_3_ARRAY := (others => to_signed(0, C_REG_WIDTHS(3)));
  signal CM1_4 : C_4_ARRAY := (others => to_signed(0, C_REG_WIDTHS(4)));
  signal CM1_5 : C_5_ARRAY := (others => to_signed(0, C_REG_WIDTHS(5)));
  signal CM1_6 : C_6_ARRAY := (others => to_signed(0, C_REG_WIDTHS(6)));

  signal CM2_1 : C_1_ARRAY := (others => to_signed(0, C_REG_WIDTHS(1)));
  signal CM2_2 : C_2_ARRAY := (others => to_signed(0, C_REG_WIDTHS(2)));
  signal CM2_3 : C_3_ARRAY := (others => to_signed(0, C_REG_WIDTHS(3)));
  signal CM2_4 : C_4_ARRAY := (others => to_signed(0, C_REG_WIDTHS(4)));
  signal CM2_5 : C_5_ARRAY := (others => to_signed(0, C_REG_WIDTHS(5)));
  signal CM2_6 : C_6_ARRAY := (others => to_signed(0, C_REG_WIDTHS(6)));

  type DEC_CNT_ARRAY is array (0 to C_NUM_CHANNELS-1) of integer;
  constant log2_rate : integer       := number_of_digits(C_MAX_RATE, 2);
  signal dec_cnt     : DEC_CNT_ARRAY := (others => 0);

  -- multi-channel related objects
  constant log2_num_chan : integer                             := get_max(1, number_of_digits(C_NUM_CHANNELS-1, 2));
  signal chan_cnt        : integer                             := 0;
  signal chan_sync_out   : std_logic_vector (LATENCY downto 0) := (others => '0');
  type CHAN_OUT_ARRAY is array (LATENCY downto 0) of std_logic_vector (log2_num_chan-1 downto 0);
  signal chan_out_out    : CHAN_OUT_ARRAY                      := (others => int_to_slv(0, log2_num_chan));

  signal rdy_out  : std_logic_vector (LATENCY downto 0) := (others => '0');
  type DOUT_ARRAY is array (LATENCY downto 0) of std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
  signal dout_out : DOUT_ARRAY                          := (others => int_to_slv(0, C_OUTPUT_WIDTH));

  --
  constant ip_rate : integer := (C_CLK_FREQ/C_SAMPLE_FREQ)/C_NUM_CHANNELS;

  signal rate_we_int, nd_int: std_logic;
  
  signal rfd_int  : std_logic := '0';
  
  signal rate_change, change_rate : std_logic := '0';
  
  type t_chan_buffer is array (2*C_NUM_CHANNELS downto 1) of std_logic_vector(C_OUTPUT_WIDTH-1 downto 0);
  signal chan_buffer_out : std_logic_vector (C_OUTPUT_WIDTH-1 downto 0) := (others => '0');
  signal chan_buffer_chan,
    chan_buffer_chan_src : std_logic_vector (log2_num_chan-1 downto 0) := (others => '0');
  signal chan_buffer_rdy,
    chan_buffer_chan_sync : std_logic := '0';

  signal ready_for_new_rate_i           : std_logic := '1';
  signal ready_for_new_rate_before_halt : std_logic := '0';
  signal halted                         : std_logic := '0';

  
begin

  -- decimator processing; handles ...
  -- single channel, multi-channel
  -- fixed rate, variable rate
  
  rate_we_int <= RATE_WE when C_RATE_TYPE = 1 else '0';

  RFD <= rfd_int;

  nd_int <= ND when C_HAS_ND = 1 else rfd_int;

  dout <= dout_out(latency_ptr) when C_NUM_CHANNELS = 1 else chan_buffer_out;

  dout_process : process(clk)
  begin
    if rising_edge(clk) then
      if change_rate = '1' then
        dout_out(LATENCY-1 downto 0) <= (others => (others => '0'));
        dout_out(LATENCY-1)          <= dout_out(LATENCY);
      elsif SCLR = '1' then
        dout_out(LATENCY-1 downto 0) <= (others => (others => '0'));
      elsif CE = '1' then
        if (LATENCY > 0) then
          dout_out(LATENCY-1 downto 0) <= dout_out(LATENCY downto 1);
        end if;
      end if;
    end if;
  end process;

  rdy <= rdy_out(latency_ptr) when C_NUM_CHANNELS = 1 else chan_buffer_rdy;

  rdy_processs : process(clk)
  begin
    if rising_edge(clk) then
      if change_rate = '1' then
        rdy_out(LATENCY-1 downto 0) <= (others => '0');
        rdy_out(LATENCY-1)          <= rdy_out(LATENCY);
      elsif SCLR = '1' then
        rdy_out(LATENCY-1 downto 0) <= (others => '0');
      elsif CE = '1' then
        if (LATENCY > 0) then
          rdy_out(LATENCY-1 downto 0) <= rdy_out(LATENCY downto 1);
        end if;
      end if;
    end if;
  end process;

  chan_sync <= chan_sync_out(latency_ptr) when C_NUM_CHANNELS = 1 else chan_buffer_chan_sync;

  ch_sync_processs : process(clk)
  begin
    if rising_edge(clk) then
      if change_rate = '1' then
        chan_sync_out(LATENCY-1 downto 0) <= (others => '0');
        chan_sync_out(LATENCY-1)          <= chan_sync_out(LATENCY);
      elsif SCLR = '1' then
        chan_sync_out(LATENCY-1 downto 0) <= (others => '0');
      elsif CE = '1' then
        if (LATENCY > 0) then
          chan_sync_out(LATENCY-1 downto 0) <= chan_sync_out(LATENCY downto 1);
        end if;
      end if;
    end if;
  end process;

  chan_out <= chan_out_out(latency_ptr) when C_NUM_CHANNELS = 1 else chan_buffer_chan;

  ch_out_processs : process(clk)
  begin
    if rising_edge(clk) then
      if SCLR = '1' or change_rate = '1' then
        chan_out_out(LATENCY-1 downto 0) <= (others => (others => '0'));
      elsif CE = '1' then
        if (LATENCY > 0) then
          chan_out_out(LATENCY-1 downto 0) <= chan_out_out(LATENCY downto 1);
        end if;
      end if;
    end if;
  end process;

  --Process to generate channel buffer effect and control the output rate
  channel_buffer : process(CLK)
    variable chan_buff : t_chan_buffer;
    variable addr_in,
      addr_out,
      op_rate_cnt
      : integer := 1;
    variable gen_op
      : boolean := false;
    constant op_rate : integer := select_integer(1, ip_rate*C_MIN_RATE, C_USE_STREAMING_INTERFACE = 1);
  begin
    if (rising_edge(CLK)) then
      if SCLR = '1' or change_rate = '1' then
        chan_buff             := (others => (others => '0'));
        addr_in               := 1;
        addr_out              := 1;
        gen_op                := false;
        chan_buffer_chan      <= (others => '0');
        chan_buffer_out       <= (others => '0');
        chan_buffer_chan_sync <= '0';
        chan_buffer_rdy       <= '0';
        op_rate_cnt           := 1;
        chan_buffer_chan_src  <= (others => '0');
      elsif CE = '1' then
        
        if rdy_out(latency_ptr) = '1' then
          chan_buff(addr_in) := dout_out(latency_ptr);

          if addr_in mod C_NUM_CHANNELS = 0 then
            gen_op := true;
          end if;

          if addr_in = 2*C_NUM_CHANNELS then
            addr_in := 1;
          else
            addr_in := addr_in+1;
          end if;
        end if;

        chan_buffer_rdy       <= '0';
        chan_buffer_chan_sync <= '0';
        if gen_op then
          
          if op_rate_cnt = 1 then
            chan_buffer_out      <= chan_buff(addr_out);
            chan_buffer_chan_src <= int_to_slv((addr_out mod C_NUM_CHANNELS), chan_buffer_chan'length);
            chan_buffer_chan     <= chan_buffer_chan_src;
            -- chan_buffer_chan<=std_logic_vector(to_unsigned((to_integer(unsigned(chan_buffer_chan))+1) mod C_NUM_CHANNELS,chan_buffer_chan'LENGTH));
            chan_buffer_rdy      <= '1';
            if addr_out mod C_NUM_CHANNELS = 1 then
              chan_buffer_chan_sync <= '1';
            end if;

            if addr_out = 2*C_NUM_CHANNELS then
              addr_out := 1;
            else
              addr_out := addr_out+1;
            end if;
          end if;

          if op_rate_cnt = op_rate then
            op_rate_cnt := 1;

            if addr_out mod C_NUM_CHANNELS = 1 then
              gen_op := false;
            end if;
            
          else
            op_rate_cnt := op_rate_cnt+1;
          end if;
        end if;
        
      end if;
    end if;
  end process;

  -- zero-latency processing qualified by the assertion of ND
  decimator : process

    variable din_ext            : signed(I_REG_WIDTHS(1)-1 downto 0)            := (others => '0');
    variable din_pad            : signed(C_INPUT_WIDTH+DYN_SCALE_BITS-1 downto 0);
    variable dyn_scale_bits_var : integer                                       := BMAX - CICBMAX(C_INPUT_WIDTH, C_RATE, C_NUM_STAGES, C_DIFF_DELAY);
    variable It_1               : signed(I_REG_WIDTHS(1)-1 downto 0)            := (others => '0');
    variable It_2               : signed(I_REG_WIDTHS(2)-1 downto 0)            := (others => '0');
    variable It_3               : signed(I_REG_WIDTHS(3)-1 downto 0)            := (others => '0');
    variable It_4               : signed(I_REG_WIDTHS(4)-1 downto 0)            := (others => '0');
    variable It_5               : signed(I_REG_WIDTHS(5)-1 downto 0)            := (others => '0');
    variable It_6               : signed(I_REG_WIDTHS(6)-1 downto 0)            := (others => '0');
    variable I_result           : signed(I_REG_WIDTHS(C_NUM_STAGES)-1 downto 0) := (others => '0');

    variable Ct_1     : signed(C_REG_WIDTHS(2)-1 downto 0)              := (others => '0');
    variable Ct_2     : signed(C_REG_WIDTHS(3)-1 downto 0)              := (others => '0');
    variable Ct_3     : signed(C_REG_WIDTHS(4)-1 downto 0)              := (others => '0');
    variable Ct_4     : signed(C_REG_WIDTHS(5)-1 downto 0)              := (others => '0');
    variable Ct_5     : signed(C_REG_WIDTHS(6)-1 downto 0)              := (others => '0');
    variable Ct_6     : signed(C_REG_WIDTHS(7)-1 downto 0)              := (others => '0');
    variable C_result : signed(C_REG_WIDTHS(C_NUM_STAGES+1)-1 downto 0) := (others => '0');

    variable rdy_var       : std_logic     := '0';
    variable chan_sync_var : std_logic     := '0';
    variable dec_cnt_var   : DEC_CNT_ARRAY := (others => 0);
    variable chan_cnt_var  : integer       := 0;

    variable rate_val   : integer := C_RATE;              -- count value for rate control
    variable rate_store : integer := C_RATE;              -- count value for rate control
    variable rate_sync  : integer := C_RATE;              -- count value for rate control
    
    variable ip_rate_cnt     : integer   := 0;
    variable change_rate_var : std_logic := '0';

    variable v_hold_rfd_low  : std_logic:='0';
    variable v_aresetn_d     : std_logic := '1';
   
  begin
    wait until rising_edge(clk);

    if (CE = '1' or SCLR = '1') then                
      rdy_var      := '0';                -- not ready unless set inside decimated processing
      chan_cnt_var := chan_cnt;
      dec_cnt_var  := dec_cnt;
    end if;


    -- Leaving reset - quickly assert ready_for_new_rate_i
    if aresetn = '1' and sclr = '1' then
      ready_for_new_rate_i <= '1';
    end if;

    -- Entering system reset - quickly deassert ready_for_new_rate_i 
    if aresetn = '0' then
      ready_for_new_rate_i <= '0';
    end if;

    -- The first cycle of halt.  Backup the value of ready_for_new_rate, force ready_for_new_rate
    -- to 0, and set the halted flag.  Don't do this if aresetn is 0 as we're going into a system reset.
    --
    if halt = '1' and halted = '0' and aresetn = '1' then
      if rate_we_int = '1' then
        ready_for_new_rate_before_halt <= '0';  -- If rate_we is asserted then rate_chaneg will go to 1 indicating  achange in rae is pending.
                                                -- In that case, we don't want to backup ready_for_new_rate_i, which is in the progress of changing to 0
      else
        ready_for_new_rate_before_halt <= ready_for_new_rate_i; 
      end if;
      
      ready_for_new_rate_i           <= '0';
      halted                         <= '1';
    end if;
    
    if SCLR = '0' then
      if CE = '1' then
        
        --Generate RFD
        if ip_rate > 1 then
          if nd_int = '1' and rfd_int = '1' then
            v_hold_rfd_low := '1';
          end if;
          
          if v_hold_rfd_low = '1' then
            if ip_rate_cnt = ip_rate-1 then
              
              ip_rate_cnt := 0;
              v_hold_rfd_low := '0';
            else
              ip_rate_cnt := ip_rate_cnt + 1;
            end if;
          end if;
        else -- ip_rate = 1
          
          v_hold_rfd_low := '0';
          --rfd_int <= '1'; -- Change for AXI.  RFD used to stay at 1 during reset, but now it goes to zero.
          -- This else branch is needed to put it back to 1 in the case where ip_rate == 1
        end if;
        
        if v_hold_rfd_low='1' then
--        if v_hold_rfd_low='1' or halt = '1' then   -- TODO: New line to try and get rid of input FIFO.
          --if v_hold_rfd_low = '0' and halt = '1' then
          --  report "Holding RFD low because of HALT only (1)" severity note;  -- TODO: Just some debug so I can check where the condition happened.
          --end if;
          rfd_int <= '0';
        else
          rfd_int <= '1';
        end if;
        
        change_rate     <= '0';
        change_rate_var := '0';

        if nd_int = '1' and rfd_int = '1' then
          
          if rate_change = '1' and chan_cnt_var = 0  then
            rate_val           := rate_store;
            rate_sync          := rate_store;
            dyn_scale_bits_var := BMAX - CICBMAX(C_INPUT_WIDTH, rate_val, C_NUM_STAGES, C_DIFF_DELAY);
            rate_change        <= '0';
            change_rate        <= '1';
            change_rate_var    := '1';
            -- We're updating ready_for_new_rate_i *AND* halt has just been asserted.
            -- Drive ready_for_new_rate_i to 0 to stop any other rate writes happening,
            -- but store the fact that ready_for_new_rate_i was changing to 1
            if halt = '1' then
              -- Halt has just been asserted.  
              ready_for_new_rate_before_halt <= '1';
            else
              -- Halt isn't asserted, so just update naturally
              ready_for_new_rate_i <= aresetn;  -- Use this in case we're going into system reset
            end if;
            
            
            -- reset filter state
            I_1 <= (others => to_signed(0, I_REG_WIDTHS(1)));
            I_2 <= (others => to_signed(0, I_REG_WIDTHS(2)));
            I_3 <= (others => to_signed(0, I_REG_WIDTHS(3)));
            I_4 <= (others => to_signed(0, I_REG_WIDTHS(4)));
            I_5 <= (others => to_signed(0, I_REG_WIDTHS(5)));
            I_6 <= (others => to_signed(0, I_REG_WIDTHS(6)));
            
            CM1_1 <= (others => to_signed(0, C_REG_WIDTHS(1)));
            CM1_2 <= (others => to_signed(0, C_REG_WIDTHS(2)));
            CM1_3 <= (others => to_signed(0, C_REG_WIDTHS(3)));
            CM1_4 <= (others => to_signed(0, C_REG_WIDTHS(4)));
            CM1_5 <= (others => to_signed(0, C_REG_WIDTHS(5)));
            CM1_6 <= (others => to_signed(0, C_REG_WIDTHS(6)));
            
            CM2_1 <= (others => to_signed(0, C_REG_WIDTHS(1)));
            CM2_2 <= (others => to_signed(0, C_REG_WIDTHS(2)));
            CM2_3 <= (others => to_signed(0, C_REG_WIDTHS(3)));
            CM2_4 <= (others => to_signed(0, C_REG_WIDTHS(4)));
            CM2_5 <= (others => to_signed(0, C_REG_WIDTHS(5)));
            CM2_6 <= (others => to_signed(0, C_REG_WIDTHS(6)));
            
            -- reset counters
            dec_cnt_var  := (others => 0);
            chan_cnt_var := 0;
          end if;
          
          -- process new input
          -- sign extend input data
          --din_ext := resize(signed(din),I_REG_WIDTHS(1));
          if (C_RATE_TYPE = 1) and (DYN_SCALE_BITS > 0) and (C_OUTPUT_WIDTH < C_REG_WIDTHS(C_NUM_STAGES)) then
            -- dynamic scaling
            din_pad(C_INPUT_WIDTH+DYN_SCALE_BITS-1 downto DYN_SCALE_BITS) := signed(din);
            din_pad(DYN_SCALE_BITS-1 downto 0)                            := (others => '0');
            din_pad                                                       := SHIFT_RIGHT(din_pad, DYN_SCALE_BITS-dyn_scale_bits_var);
            din_ext                                                       := resize(signed(din_pad), I_REG_WIDTHS(1));
          else
            -- no scaling needed
            din_ext := resize(signed(din), I_REG_WIDTHS(1));
          end if;
          
          -- integrators
          if change_rate_var = '1' then
            It_1              := resize(shift_right(din_ext, I_REG_SHIFT(1)), I_REG_WIDTHS(1));
            I_1(chan_cnt_var) <= It_1;
            It_2              := resize(shift_right(It_1, I_REG_SHIFT(2)), I_REG_WIDTHS(2));
            I_2(chan_cnt_var) <= It_2;
            It_3              := resize(shift_right(It_2, I_REG_SHIFT(3)), I_REG_WIDTHS(3));
            I_3(chan_cnt_var) <= It_3;
            It_4              := resize(shift_right(It_3, I_REG_SHIFT(4)), I_REG_WIDTHS(4));
            I_4(chan_cnt_var) <= It_4;
            It_5              := resize(shift_right(It_4, I_REG_SHIFT(5)), I_REG_WIDTHS(5));
            I_5(chan_cnt_var) <= It_5;
            It_6              := resize(shift_right(It_5, I_REG_SHIFT(6)), I_REG_WIDTHS(6));
            I_6(chan_cnt_var) <= It_6;
          else
            It_1          := I_1(chan_cnt) + resize(shift_right(din_ext, I_REG_SHIFT(1)), I_REG_WIDTHS(1));
            I_1(chan_cnt) <= It_1;
            It_2          := I_2(chan_cnt) + resize(shift_right(It_1, I_REG_SHIFT(2)), I_REG_WIDTHS(2));
            I_2(chan_cnt) <= It_2;
            It_3          := I_3(chan_cnt) + resize(shift_right(It_2, I_REG_SHIFT(3)), I_REG_WIDTHS(3));
            I_3(chan_cnt) <= It_3;
            It_4          := I_4(chan_cnt) + resize(shift_right(It_3, I_REG_SHIFT(4)), I_REG_WIDTHS(4));
            I_4(chan_cnt) <= It_4;
            It_5          := I_5(chan_cnt) + resize(shift_right(It_4, I_REG_SHIFT(5)), I_REG_WIDTHS(5));
            I_5(chan_cnt) <= It_5;
            It_6          := I_6(chan_cnt) + resize(shift_right(It_5, I_REG_SHIFT(6)), I_REG_WIDTHS(6));
            I_6(chan_cnt) <= It_6;
          end if;
          
          case C_NUM_STAGES is
            when 1      => I_result := It_1;
            when 2      => I_result := It_2;
            when 3      => I_result := It_3;
            when 4      => I_result := It_4;
            when 5      => I_result := It_5;
            when 6      => I_result := It_6;
            when others => I_result := It_1;
          end case;
          
          chan_sync_var := '0';           -- no channel sync unless deterined in decimated processing
          
          -- combs
          -- compare value controls phase of decimation
          -- this in turn should be set to match input register delay in implementation model
          -- if dec_cnt(chan_cnt) = (0) then
          if dec_cnt_var(chan_cnt_var) = (0) then
            if change_rate_var = '1' then
              Ct_1 := resize(shift_right(resize(shift_right(I_result, C_REG_SHIFT(1)), C_REG_WIDTHS(1)), C_REG_SHIFT(2)), C_REG_WIDTHS(2));
              Ct_2 := resize(shift_right((Ct_1), C_REG_SHIFT(3)), C_REG_WIDTHS(3));
              Ct_3 := resize(shift_right((Ct_2), C_REG_SHIFT(4)), C_REG_WIDTHS(4));
              Ct_4 := resize(shift_right((Ct_3), C_REG_SHIFT(5)), C_REG_WIDTHS(5));
              Ct_5 := resize(shift_right((Ct_4), C_REG_SHIFT(6)), C_REG_WIDTHS(6));
              Ct_6 := resize(shift_right((Ct_5), C_REG_SHIFT(7)), C_REG_WIDTHS(7));
            else
              Ct_1 := resize(shift_right(resize(shift_right(I_result, C_REG_SHIFT(1)), C_REG_WIDTHS(1)) - CM1_1(chan_cnt), C_REG_SHIFT(2)), C_REG_WIDTHS(2));
              Ct_2 := resize(shift_right((Ct_1 - CM1_2(chan_cnt)), C_REG_SHIFT(3)), C_REG_WIDTHS(3));
              Ct_3 := resize(shift_right((Ct_2 - CM1_3(chan_cnt)), C_REG_SHIFT(4)), C_REG_WIDTHS(4));
              Ct_4 := resize(shift_right((Ct_3 - CM1_4(chan_cnt)), C_REG_SHIFT(5)), C_REG_WIDTHS(5));
              Ct_5 := resize(shift_right((Ct_4 - CM1_5(chan_cnt)), C_REG_SHIFT(6)), C_REG_WIDTHS(6));
              Ct_6 := resize(shift_right((Ct_5 - CM1_6(chan_cnt)), C_REG_SHIFT(7)), C_REG_WIDTHS(7));
            end if;
            
            if C_DIFF_DELAY = 1 then
              CM1_1(chan_cnt_var) <= resize(shift_right(I_result, C_REG_SHIFT(1)), C_REG_WIDTHS(1));
              CM1_2(chan_cnt_var) <= Ct_1;
              CM1_3(chan_cnt_var) <= Ct_2;
              CM1_4(chan_cnt_var) <= Ct_3;
              CM1_5(chan_cnt_var) <= Ct_4;
              CM1_6(chan_cnt_var) <= Ct_5;
            else
              if change_rate_var = '1' then
                CM1_1(chan_cnt_var) <= (others => '0');
                CM1_2(chan_cnt_var) <= (others => '0');
                CM1_3(chan_cnt_var) <= (others => '0');
                CM1_4(chan_cnt_var) <= (others => '0');
                CM1_5(chan_cnt_var) <= (others => '0');
                CM1_6(chan_cnt_var) <= (others => '0');
              else
                CM1_1(chan_cnt_var) <= CM2_1(chan_cnt_var);
                CM1_2(chan_cnt_var) <= CM2_2(chan_cnt_var);
                CM1_3(chan_cnt_var) <= CM2_3(chan_cnt_var);
                CM1_4(chan_cnt_var) <= CM2_4(chan_cnt_var);
                CM1_5(chan_cnt_var) <= CM2_5(chan_cnt_var);
                CM1_6(chan_cnt_var) <= CM2_6(chan_cnt_var);
              end if;
              
              CM2_1(chan_cnt_var) <= resize(shift_right(I_result, C_REG_SHIFT(1)), C_REG_WIDTHS(1));
              CM2_2(chan_cnt_var) <= Ct_1;
              CM2_3(chan_cnt_var) <= Ct_2;
              CM2_4(chan_cnt_var) <= Ct_3;
              CM2_5(chan_cnt_var) <= Ct_4;
              CM2_6(chan_cnt_var) <= Ct_5;
            end if;
            
            case C_NUM_STAGES is
              when 1      => C_result := Ct_1;
              when 2      => C_result := Ct_2;
              when 3      => C_result := Ct_3;
              when 4      => C_result := Ct_4;
              when 5      => C_result := Ct_5;
              when 6      => C_result := Ct_6;
              when others => C_result := Ct_1;
            end case;

            
            dout_out(LATENCY) <= std_logic_vector(C_result);
            
            chan_out_out(LATENCY) <= int_to_slv(chan_cnt_var, log2_num_chan);
            rdy_var               := '1';
            
            if chan_cnt_var = (0) then
              if C_NUM_CHANNELS > 1 then
                chan_sync_var := '1';     -- tag channel 0 if multi-channel
              else
                chan_sync_var := '0';
              end if;
            end if;
            
          end if;
          
          -- drive IF signals
          -- update decimation counter
          if dec_cnt_var(chan_cnt_var) = (rate_sync - 1) then
            dec_cnt_var(chan_cnt_var) := 0;
          else
            dec_cnt_var(chan_cnt_var) := dec_cnt_var(chan_cnt_var) + 1;
          end if;
          
          -- update multi-channel output signals
          if chan_cnt_var = (C_NUM_CHANNELS - 1) then
            chan_cnt_var := 0;
          else
            chan_cnt_var := chan_cnt_var + 1;
          end if;
          
          chan_sync_out(LATENCY) <= chan_sync_var;
          
        end if;
        
        --Hold input rate
        if rate_we_int = '1' then
          rate_store  := conv_integer(RATE);
          rate_change <= '1';
          ready_for_new_rate_i <= '0'; -- New for AXI
        end if;
        
      elsif CE = '0' then
      -- Halt has been released, so restore ready_for_new_rate_change.  Note that CE will still be 0 because halt is just released
      -- (ce is registered so will still be changing to 1).
      -- Only do this if we're not in system reset.  If we are, code furthe rup the page will drive ready_for_new_rate_change
        if halt = '0' and halted = '1' and aresetn = '1' then
          ready_for_new_rate_i <= ready_for_new_rate_before_halt;
          halted <= '0';
        end if;
      end if; -- CE = '1'
    else
      -- SCLR = 1
      rate_val           := C_RATE;
      rate_store         := C_RATE;
      rate_sync          := C_RATE;
      dyn_scale_bits_var := BMAX - CICBMAX(C_INPUT_WIDTH, rate_val, C_NUM_STAGES, C_DIFF_DELAY);
      
      dout_out(LATENCY)      <= int_to_slv(0, C_OUTPUT_WIDTH);
      rdy_var                := '0';
      chan_sync_out(LATENCY) <= '0';
      chan_out_out(LATENCY)  <= int_to_slv(0, log2_num_chan);
      
      -- reset filter state
      I_1 <= (others => to_signed(0, I_REG_WIDTHS(1)));
      I_2 <= (others => to_signed(0, I_REG_WIDTHS(2)));
      I_3 <= (others => to_signed(0, I_REG_WIDTHS(3)));
      I_4 <= (others => to_signed(0, I_REG_WIDTHS(4)));
      I_5 <= (others => to_signed(0, I_REG_WIDTHS(5)));
      I_6 <= (others => to_signed(0, I_REG_WIDTHS(6)));
      
      CM1_1 <= (others => to_signed(0, C_REG_WIDTHS(1)));
      CM1_2 <= (others => to_signed(0, C_REG_WIDTHS(2)));
      CM1_3 <= (others => to_signed(0, C_REG_WIDTHS(3)));
      CM1_4 <= (others => to_signed(0, C_REG_WIDTHS(4)));
      CM1_5 <= (others => to_signed(0, C_REG_WIDTHS(5)));
      CM1_6 <= (others => to_signed(0, C_REG_WIDTHS(6)));
      
      CM2_1 <= (others => to_signed(0, C_REG_WIDTHS(1)));
      CM2_2 <= (others => to_signed(0, C_REG_WIDTHS(2)));
      CM2_3 <= (others => to_signed(0, C_REG_WIDTHS(3)));
      CM2_4 <= (others => to_signed(0, C_REG_WIDTHS(4)));
      CM2_5 <= (others => to_signed(0, C_REG_WIDTHS(5)));
      CM2_6 <= (others => to_signed(0, C_REG_WIDTHS(6)));
      
      -- reset counters
      dec_cnt_var  := (others => 0);
      chan_cnt_var := 0;
      
      ip_rate_cnt    := 0;
      rfd_int        <= '0';  -- Changed for AXI
      v_hold_rfd_low := '0';
      
      
      rate_change          <= '0'; -- Added with AXI.  The DUT resets this signal, and AXI "exposes" it

      if aresetn = '1' and v_aresetn_d = '1' then -- Respond to reset when not also a system reset.  
        ready_for_new_rate_i     <= '0';  -- New for AXI
      end if;

      halted               <= '0';

    end if;

    if sclr = '1' or CE = '1' then
      -- drive IF signals
      rdy_out(LATENCY) <= rdy_var;
        
      -- update counter signals
      dec_cnt  <= dec_cnt_var;
      chan_cnt <= chan_cnt_var;
    end if;
        

    v_aresetn_d := aresetn;
  end process;
  ready_for_new_rate <= ready_for_new_rate_i;

  
end behavioral;
