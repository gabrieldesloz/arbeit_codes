-- $RCSfile: c_addsub_v11_0.vhd,v $ $Revision: 1.5 $ $Date: 2010/03/19 10:44:17 $
-------------------------------------------------------------------------------
--  (c) Copyright 1995-2008 Xilinx, Inc. All rights reserved.
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library XilinxCoreLib;
use xilinxcorelib.xbip_addsub_v2_0_comp.all;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;
use xilinxcorelib.bip_utils_pkg_v2_0.all;
use xilinxcorelib.c_addsub_pkg_v11_0.all;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;


--core_if on entity c_addsub_v11_0
entity c_addsub_v11_0 is
  generic (
    C_VERBOSITY           :     integer                                    := 0;
    C_XDEVICEFAMILY       :     string                                     := "no_family";
    C_IMPLEMENTATION      :     integer                                    := 0;
    C_A_WIDTH             :     integer                                    := 15;
    C_B_WIDTH             :     integer                                    := 15;
    C_OUT_WIDTH           :     integer                                    := 16;
    C_CE_OVERRIDES_SCLR   :     integer                                    := 0;  -- replaces c_sync_enable
    C_A_TYPE              :     integer                                    := 0;
    C_B_TYPE              :     integer                                    := 0;
    C_LATENCY             :     integer                                    := 1;
    C_ADD_MODE            :     integer                                    := 0;
    C_B_CONSTANT          :     integer                                    := 0;
    C_B_VALUE             :     string                                     := "0";
    C_AINIT_VAL           :     string                                     := "0";
    C_SINIT_VAL           :     string                                     := "0";  -- ""
    C_CE_OVERRIDES_BYPASS :     integer                                    := 0;  -- replaces c_bypass_enable
    C_BYPASS_LOW          :     integer                                    := 0;
    C_SCLR_OVERRIDES_SSET :     integer                                    := 1;  -- replaces c_sync_priority
    C_HAS_C_IN            :     integer                                    := 0;
    C_HAS_C_OUT           :     integer                                    := 0;  -- may be registered in step with c_latency
    C_BORROW_LOW          :     integer                                    := 1;  -- only applies to implementation = 1
    C_HAS_CE              :     integer                                    := 0;
    C_HAS_BYPASS          :     integer                                    := 0;
    C_HAS_SCLR            :     integer                                    := 0;
    C_HAS_SSET            :     integer                                    := 0;
    C_HAS_SINIT           :     integer                                    := 0
    );
  port (
    A                     : in  std_logic_vector(C_A_WIDTH-1 downto 0)     := (others => '0');
    B                     : in  std_logic_vector(C_B_WIDTH-1 downto 0)     := (others => '0');
    CLK                   : in  std_logic                                  := '0';
    ADD                   : in  std_logic                                  := '1';
    C_IN                  : in  std_logic                                  := '0';
    CE                    : in  std_logic                                  := '1';
    BYPASS                : in  std_logic                                  := '0';
    SCLR                  : in  std_logic                                  := '0';
    SSET                  : in  std_logic                                  := '0';
    SINIT                 : in  std_logic                                  := '0';
    C_OUT                 : out std_logic                                  := '0';
    S                     : out std_logic_vector(C_OUT_WIDTH - 1 downto 0) := (others => '0')
    );
--core_if off
end c_addsub_v11_0;

architecture behavioral of c_addsub_v11_0 is

  function fn_out_data_type (
    p_a_type : integer;
    p_b_type : integer)
    return integer is
  begin
    if ((p_a_type = 1) and (p_b_type = 1)) then
      return 1;
    end if;
    return 0;
  end fn_out_data_type;

  constant c_out_data_type : integer := fn_out_data_type(
    p_a_type => C_A_TYPE,
    p_b_type => C_B_TYPE
    );

   function fn_a_internal_data_type (
     p_a_type : integer;
     p_b_type : integer)
     return integer is
   begin
     if ((p_a_type = 1) and (p_b_type = 0))  then
       return 1;
     end if;   
      return 0;
   end fn_a_internal_data_type;

   constant c_a_internal_data_type : integer := fn_a_internal_data_type(
     p_a_type => C_A_TYPE,
     p_b_type => C_B_TYPE
     );

  function fn_b_internal_data_type (
     p_a_type : integer;
     p_b_type : integer)
     return integer is
   begin
     if ((p_b_type = 1) and (p_a_type = 0))  then
       return 1;
     end if;   
      return 0;
   end fn_b_internal_data_type;

   constant c_b_internal_data_type : integer := fn_b_internal_data_type(
     p_a_type => C_A_TYPE,
     p_b_type => C_B_TYPE
     );

  
--check generics
  function check_generics_c_addsub_v11_0 (
    C_VERBOSITY           : integer;
    C_XDEVICEFAMILY       : string;
    C_IMPLEMENTATION      : integer;
    C_A_WIDTH             : integer;
    C_B_WIDTH             : integer;
    C_OUT_WIDTH           : integer;
    C_CE_OVERRIDES_SCLR   : integer;    -- replaces c_sync_enable
    C_A_TYPE              : integer;
    C_B_TYPE              : integer;
    C_LATENCY             : integer;
    C_ADD_MODE            : integer;
    C_B_CONSTANT          : integer;
    C_B_VALUE             : string;
    C_AINIT_VAL           : string;
    C_SINIT_VAL           : string;
    C_CE_OVERRIDES_BYPASS : integer;    -- replaces c_bypass_enable
    C_BYPASS_LOW          : integer;
    C_SCLR_OVERRIDES_SSET : integer;    -- replaces c_sync_priority
    C_HAS_C_IN            : integer;
    C_HAS_C_OUT           : integer;    -- may be registered in step with c_latency
    C_BORROW_LOW          : integer;    -- only applies to implementation = 1
    C_HAS_CE              : integer;
    C_HAS_BYPASS          : integer;
    C_HAS_SCLR            : integer;
    C_HAS_SSET            : integer;
    C_HAS_SINIT           : integer
    )
    return integer is
  begin
    if C_IMPLEMENTATION = 0 then
      --baseblox checks (e.g. sorry, no verbosity)
    else
      --baseip checks (e.g. no, sorry, no sinits)
      assert C_HAS_SSET = 0 and C_HAS_SINIT = 0
        report "WARNING   : c_addsub_v11_0 : with C_IMPLEMENTATION set to 1 (DSP48) SSET and SINIT cannot be supported."
        severity warning;
    end if;
    return 0;
  end check_generics_c_addsub_v11_0;


  constant c_addsub_latency_rec : t_c_addsub_v11_0_latency := fn_c_addsub_v11_0_latency(
    c_verbosity           => C_VERBOSITY,
    c_xdevicefamily       => C_XDEVICEFAMILY,
    c_implementation      => C_IMPLEMENTATION,
    c_a_width             => C_A_WIDTH,
    c_b_width             => C_B_WIDTH,
    c_out_width           => C_OUT_WIDTH,
    c_ce_overrides_sclr   => C_CE_OVERRIDES_SCLR,
    c_a_type              => C_A_TYPE,
    c_b_type              => C_B_TYPE,
    c_latency             => C_LATENCY,
    c_add_mode            => C_ADD_MODE,
    c_b_constant          => C_B_CONSTANT,
    c_b_value             => C_B_VALUE,
    c_ainit_val           => C_AINIT_VAL,
    c_sinit_val           => C_SINIT_VAL,
    c_ce_overrides_bypass => C_CE_OVERRIDES_BYPASS,
    c_bypass_low          => C_BYPASS_LOW,
    c_sclr_overrides_sset => C_SCLR_OVERRIDES_SSET,
    c_has_c_in            => C_HAS_C_IN,
    c_has_c_out           => C_HAS_C_OUT,
    c_has_ce              => C_HAS_CE,
    c_has_bypass          => C_HAS_BYPASS,
    c_has_sclr            => C_HAS_SCLR,
    c_has_sset            => C_HAS_SSET,
    c_has_sinit           => C_HAS_SINIT
    );
  constant c_addsub_latency     : integer                  := c_addsub_latency_rec.used;


begin

  i_baseblocks            : if C_IMPLEMENTATION = 0 generate
    signal i_c_out        : std_logic                                := '0';
    signal i_b_out        : std_logic                                := '0';
    signal i_ovfl         : std_logic                                := '0';
    signal qi_ovfl        : std_logic                                := '0';
    signal qi_c_out       : std_logic                                := '0';
    signal qi_b_out       : std_logic                                := '0';
    signal i_s            : std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0');
    signal i_q            : std_logic_vector(C_OUT_WIDTH-1 downto 0) := (others => '0');
    signal i_b_in, i_c_in : std_logic                                := '0';


  begin
    i_baseblocks_addsub_behv : c_addsub_v11_0_legacy
      generic map(
        C_A_WIDTH             => C_A_WIDTH,
        C_B_WIDTH             => C_B_WIDTH,
        C_OUT_WIDTH           => C_OUT_WIDTH,
        C_LOW_BIT             => 0,
        C_HIGH_BIT            => C_OUT_WIDTH-1,
        C_ADD_MODE            => C_ADD_MODE,
        C_A_TYPE              => C_A_TYPE,
        C_B_TYPE              => C_B_TYPE,
        C_B_CONSTANT          => C_B_CONSTANT,
        C_B_VALUE             => C_B_VALUE,
        C_AINIT_VAL           => C_AINIT_VAL,
        C_SINIT_VAL           => C_SINIT_VAL,
        C_BYPASS_ENABLE       => C_CE_OVERRIDES_BYPASS,
        C_BYPASS_LOW          => C_BYPASS_LOW,
        C_SYNC_ENABLE         => C_CE_OVERRIDES_SCLR,
        C_SYNC_PRIORITY       => C_SCLR_OVERRIDES_SSET,
        C_PIPE_STAGES         => 0,     -- deprecated
        C_LATENCY             => c_addsub_latency,
        C_HAS_S               => boolean'pos(C_LATENCY = 0),
        C_HAS_Q               => boolean'pos(C_LATENCY /= 0),
        C_HAS_C_IN            => boolean'pos(C_HAS_C_IN = 1 and C_ADD_MODE /= 1),
        C_HAS_C_OUT           => boolean'pos(C_LATENCY = 0 and C_ADD_MODE /= 1 and C_HAS_C_OUT = 1),
        C_HAS_Q_C_OUT         => boolean'pos(C_LATENCY /= 0 and C_ADD_MODE /= 1 and C_HAS_C_OUT = 1),
        C_HAS_B_IN            => boolean'pos(C_HAS_C_IN = 1 and C_ADD_MODE = 1),
        C_HAS_B_OUT           => boolean'pos(C_LATENCY = 0 and C_ADD_MODE = 1 and C_HAS_C_OUT = 1),
        C_HAS_Q_B_OUT         => boolean'pos(C_LATENCY /= 0 and C_ADD_MODE = 1 and C_HAS_C_OUT = 1),
        C_HAS_OVFL            => 0,     --deprecated
        C_HAS_Q_OVFL          => 0,     --deprecated
        C_HAS_CE              => C_HAS_CE,
        C_HAS_ADD             => boolean'pos(C_ADD_MODE = 2),
        C_HAS_BYPASS          => C_HAS_BYPASS,
        C_HAS_A_SIGNED        => 0,     -- deprecated
        C_HAS_B_SIGNED        => 0,     -- deprecated
        C_HAS_ACLR            => 0,     -- deprecated
        C_HAS_ASET            => 0,     -- deprecated
        C_HAS_AINIT           => 0,     -- deprecated
        C_HAS_SCLR            => C_HAS_SCLR,
        C_HAS_SSET            => C_HAS_SSET,
        C_HAS_SINIT           => C_HAS_SINIT,
        C_ENABLE_RLOCS        => 0,     -- deprecated
        C_HAS_BYPASS_WITH_CIN => 0      -- deprecated
        )
      port map(
        A                     => A,
        B                     => B,
        CLK                   => CLK,
        ADD                   => ADD,
        C_IN                  => i_c_in,
        B_IN                  => i_b_in,
        CE                    => CE,
        BYPASS                => BYPASS,
        ACLR                  => '0',
        ASET                  => '0',
        AINIT                 => '0',
        SCLR                  => SCLR,
        SSET                  => SSET,
        SINIT                 => SINIT,
        A_SIGNED              => '0',
        B_SIGNED              => '0',
        OVFL                  => i_ovfl,
        C_OUT                 => i_c_out,
        B_OUT                 => i_b_out,
        Q_OVFL                => qi_ovfl,
        Q_C_OUT               => qi_c_out,
        Q_B_OUT               => qi_b_out,
        S                     => i_s,
        Q                     => i_q
        );

      map_registered_outputs : if C_LATENCY /= 0 generate
      S       <= i_q;
      map_b_out            : if C_ADD_MODE = 1 generate
        C_OUT <= qi_b_out;
      end generate map_b_out;
      map_c_out            : if C_ADD_MODE /= 1 generate
        C_OUT <= qi_c_out;
      end generate map_c_out;

-- delay element for c_out is creating unknown states in behavioral model
-- set latency to 0 in behavioral model and implement latency with xbip_pipe externally
-- pre_c_out_vec(0) <= pre_c_out;
-- Tried this but cannot init registers in xbip_pipe. Literature for addsub says to expect Xs when
-- pipes are being flushed. Data-valid signal added to trap flushing in
-- testbench (in baseblox addsub as well)


    end generate map_registered_outputs;

    map_unregistered_outputs : if C_LATENCY = 0 generate
      S       <= i_s;
      map_b_out              : if C_ADD_MODE = 1 generate
        C_OUT <= i_b_out;
      end generate map_b_out;
      map_c_out              : if C_ADD_MODE /= 1 generate
        C_OUT <= i_c_out;
      end generate map_c_out;
    end generate map_unregistered_outputs;

    has_c_in : if (C_HAS_C_IN = 1 and C_ADD_MODE /= 1) generate
      i_c_in <= C_IN;
    end generate has_c_in;
    has_b_in : if (C_HAS_C_IN = 1 and C_ADD_MODE = 1) generate
      i_b_in <= C_IN;
    end generate has_b_in;

  end generate i_baseblocks;

  xbip_addsub : if C_IMPLEMENTATION = 1 generate
    --Individual typing was added for a and b inputs at top level in order to accommodate fabric;
    --xbip implementation was designed to handle a single type for all inputs;
    --Need to resize inputs individually according to type. 

    constant ci_b_value    : std_logic_vector(c_b_width-1 downto 0) := str_to_slv_0(C_B_VALUE, C_B_WIDTH);
    signal   a_internal    : std_logic_vector (c_a_width + c_a_internal_data_type -1 downto 0);
    signal   b_internal    : std_logic_vector (c_b_width + c_b_internal_data_type -1 downto 0);
   -- signal   a_internal_ze : std_logic_vector (c_a_width downto 0);
    --signal   b_internal_ze : std_logic_vector (c_b_width downto 0);
    signal   b_for_sum     : std_logic_vector (c_b_width-1 downto 0);
    signal   i_out1       : std_logic_vector (c_out_width + c_out_data_type - 1 downto 0);
    signal   i_CE          : std_logic                              := '1';
    signal   i_SCLR        : std_logic                              := '0';
    signal   i_BYPASS      : std_logic                              := '0';
    signal   i_ADDF        : std_logic                              := '0';  --this is i_ADD_false and a zero gets us an add in the usecase  
    signal   i_C_IN        : std_logic;
    signal   add_delay     : std_logic;
    signal   i_CLK         : std_logic                              := '0';

  begin

    -- Generate appropriate b input
    i_b_constant : if c_b_constant = 1 generate
      b_for_sum(c_b_width-1 downto 0) <= ci_b_value(c_b_width-1 downto 0);
    end generate i_b_constant;
    i_b_variable : if c_b_constant = 0 generate
      b_for_sum                       <= b;
    end generate i_b_variable;


    -- Generate call to xbip_addsub
  --  i_baseip           : if ((c_a_type = 0 and c_b_type = 0) or (c_a_type = 1 and c_b_type = 1)) generate
   --    signal i_out1  : std_logic_vector (c_out_width-1 downto 0);
   --   signal add_delay : std_logic;
  --  begin


 --     noresize_a : if(C_A_TYPE = 0)generate
 --       a_internal(c_a_width-1 downto 0) <= A;
  --    end generate noresize_a;

   --   noresize_b : if(C_B_TYPE = 0)generate
   --     b_internal(c_b_width-1 downto 0) <= b_for_sum;
   --   end generate noresize_b;

--        noresize_ab :  if  (((c_a_type = 1) and (c_b_type = 1)) or ((c_a_type = 0) and (c_b_type = 0))) generate
--          a_internal(c_a_width-1 downto 0) <= A;
--          b_internal(c_b_width-1 downto 0) <= b_for_sum;
--        end generate noresize_ab;

       resize_mixed1 : if((C_A_TYPE = 1) and (C_B_TYPE = 0))generate
         a_internal(c_a_width downto 0) <= ('0' & A);
         b_internal(c_b_width-1 downto 0) <= b_for_sum;
       end generate resize_mixed1;

       resize_mixed2 : if((C_A_TYPE = 0) and (C_B_TYPE = 1))generate
         a_internal(c_a_width-1 downto 0) <= A;
         b_internal(c_b_width downto 0) <= ('0' & b_for_sum);
       end generate resize_mixed2;
    
        noresize_signed : if((C_A_TYPE = 0) and (C_B_TYPE = 0))generate
         a_internal(c_a_width -1 downto 0) <= A;
         b_internal(c_b_width -1 downto 0) <= (b_for_sum);
       end generate noresize_signed;

         noresize_unsigned :  if  ((c_a_type = 1) and (c_b_type = 1))  generate
         a_internal(c_a_width - 1 downto 0) <= (A);
         b_internal(c_b_width - 1 downto 0) <=(b_for_sum) ;
       end generate noresize_unsigned;

      i_xbip_addsub_behv : xbip_addsub_v2_0
        generic map (
          C_XDEVICEFAMILY     => C_XDEVICEFAMILY,
          C_LATENCY           => c_addsub_latency,
          C_A_WIDTH           => C_A_WIDTH + c_a_internal_data_type,
          C_B_WIDTH           => C_B_WIDTH + c_b_internal_data_type,
          C_OUT_WIDTH         => C_OUT_WIDTH + c_out_data_type,
          C_BYPASS_LOW        => C_BYPASS_LOW,
          C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
          C_VERBOSITY         => C_VERBOSITY,
          C_MODEL_TYPE        => 0,
          C_DATA_TYPE         => c_out_data_type  --unsigned only for
                                        --case when both unsigned
          )
        port map (
          CLK                 => i_CLK,
          CE                  => i_CE,
          SCLR                => i_SCLR,
          ADDF                => i_ADDF,
          BYPASS              => i_BYPASS,
          C_IN                => i_C_IN,
          A                   => a_internal,  --this is "C" in xbip.
          B                   => b_internal,  --this is "A:B..:D" in xbip.  
          Q                   => i_out1
          );

      S <= i_out1(C_OUT_WIDTH-1 downto 0);
      --set carry_out equal to the MSB from the sum in dsp48

      has_c_out              : if C_HAS_C_OUT = 1 and C_A_TYPE = 1 and C_B_TYPE = 1 generate
        add_mode             : if c_add_mode = 0 generate
          C_OUT     <= i_out1(C_OUT_WIDTH + c_out_data_type - 1);  -- carry out from top bit
        end generate add_mode;
        sub_mode             : if c_add_mode = 1 generate
          borrow_low         : if c_borrow_low = 1 generate
            C_OUT   <= not(i_out1(C_OUT_WIDTH + c_out_data_type - 1));  -- carry out from top bit
          end generate borrow_low;
          borrow_high        : if c_borrow_low = 0 generate
            C_OUT   <= i_out1(C_OUT_WIDTH + c_out_data_type - 1);  -- carry out from top bit
          end generate borrow_high;
        end generate sub_mode;
        addsub_mode          : if c_add_mode = 2 generate
          borrow_low         : if c_borrow_low = 1 generate
            equal_output     : if (C_OUT_WIDTH = C_A_WIDTH) and (C_OUT_WIDTH = C_B_WIDTH) generate
              C_OUT <= i_out1(C_OUT_WIDTH + c_out_data_type - 1) when add_delay = '1' else not(i_out1(C_OUT_WIDTH + c_out_data_type - 1));  -- carry out from top bit
            end generate equal_output;
            non_equal_output : if (C_OUT_WIDTH > C_A_WIDTH) or (C_OUT_WIDTH > C_B_WIDTH) generate
              C_OUT <= i_out1(C_OUT_WIDTH-1)          when add_delay = '1' else not(i_out1(C_OUT_WIDTH-1));  -- carry out from top bit
            end generate non_equal_output;
          end generate borrow_low;
          borrow_high        : if c_borrow_low = 0 generate
            C_OUT   <= i_out1(C_OUT_WIDTH + c_out_data_type - 1);  -- carry out from top bit
          end generate borrow_high;
        end generate addsub_mode;
      end generate has_c_out;

      has_no_c_out : if C_HAS_C_OUT = 0 generate
        C_OUT <= '0';
      end generate has_no_c_out;

      i_add_pipe : xbip_pipe_v2_0_xst
        generic map(
          C_LATENCY  => c_addsub_latency,
          C_HAS_CE   => 1,
          C_HAS_SSET => 1,
          C_WIDTH    => 1
          )
        port map(
          CLK        => i_CLK,
          CE         => i_CE,
          SSET       => i_SCLR,
          D(0)       => add,
          Q(0)       => add_delay
          );


 --   end generate i_baseip;


-- i_a_extend: IF (c_a_type = 1 and c_b_type = 0) GENERATE
-- b_internal(c_b_width-1 DOWNTO 0) <= b_for_sum;
-- a_internal_ze(c_a_width-1 DOWNTO 0) <= a;
-- a_internal_ze(c_a_width) <= '0';     -- zero extend unsigned a by 1 bit
--   -- i_S(c_out_width-1 DOWNTO 0) <= S;
--   -- i_S(c_out_width) <= '0';        -- zero extend output by 1 bit

-- i_xbip_addsub_behv : xbip_addsub_v2_0
-- generic map (
-- C_XDEVICEFAMILY => C_XDEVICEFAMILY,
-- C_LATENCY => c_addsub_latency,
-- C_A_WIDTH => C_A_WIDTH+1,            --extend unsigned a input by 1 bit and make it signed    
--           C_B_WIDTH           => C_B_WIDTH,   
--           C_OUT_WIDTH         => C_OUT_WIDTH,  --we need to constrain c_out_width (in pkg.vhd and tcl file) such that rollovers will not occur  (since we cannot extend c_out_width beyond what user specifies; c_out_width)
--           C_BYPASS_LOW        => c_BYPASS_LOW,
--           C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
--           C_VERBOSITY         => C_VERBOSITY,
--           C_MODEL_TYPE        => 0,
--           C_DATA_TYPE         => 0   --extend unsigned a input by 1 bit and make it signed so c_data_type is signed
--           )
--         port map (
--           CLK    => i_CLK,
--           CE     => i_CE,
--           SCLR   => i_SCLR,
--           ADDF    => i_ADDF,
--           BYPASS => i_BYPASS,
--           C_IN   => i_C_IN,
--           A      => a_internal_ze,
--           B      => b_internal,
--           Q      => i_c_out
--           );

-- S <= i_c_out;
-- C_OUT <= '0';
--  --  i_S(c_out_width-1 DOWNTO 0) <= S;
--   -- i_S(c_out_width) <= '0';        -- zero extend output by 1 bit

-- END GENERATE i_a_extend;


-- i_b_extend: IF (c_a_type = 0 and c_b_type = 1) GENERATE
-- a_internal(c_a_width-1 DOWNTO 0) <= a;
-- b_internal_ze(c_b_width-1 DOWNTO 0) <= b_for_sum;
-- b_internal_ze(c_b_width) <= '0';     -- zero extend unsigned b by 1 bit 
--   -- i_S(c_out_width-1 DOWNTO 0) <= S;
--   -- i_S(c_out_width) <= '0';        -- zero extend output by 1 bit

-- i_xbip_addsub_behv : xbip_addsub_v2_0
-- generic map (
-- C_XDEVICEFAMILY => C_XDEVICEFAMILY,
-- C_LATENCY => c_addsub_latency,
-- C_A_WIDTH => C_A_WIDTH,
-- C_B_WIDTH => C_B_WIDTH+1,
-- C_OUT_WIDTH => C_OUT_WIDTH,          --take care of c_out_width constraints in pkg.vhd and tcl so rollover does not occur
--        C_BYPASS_LOW        => C_BYPASS_LOW,
--           C_CE_OVERRIDES_SCLR => C_CE_OVERRIDES_SCLR,
--           C_VERBOSITY         => C_VERBOSITY,
--           C_MODEL_TYPE        => 0,
--      C_DATA_TYPE         => 0        --extend unsigned b input by 1 bit and make it signed so c_data_type is signed
--           )
--         port map (
--           CLK    => i_CLK,
--           CE     => i_CE,
--           SCLR   => i_SCLR,
--           ADDF    => i_ADDF,
--           BYPASS => i_BYPASS,
--           C_IN   => i_C_IN,
--           A      => a_internal,
--           B      => b_internal_ze,
--           Q      => i_c_out
--           );

-- S <= i_c_out;
-- C_OUT <= '0';
--  -- i_S(c_out_width-1 DOWNTO 0) <= S;
--   -- i_S(c_out_width) <= '0';        -- zero extend output by 1 bit

-- END GENERATE i_b_extend;



    --invert sense of add signal from fabric sense for dsp48 implementation
    mode_adder      : if C_ADD_MODE = 0 generate
      i_ADDF <= '0';                    --generic add_mode 0 is an add. port nomenclature is add = 1; (opposite of generic sense... just to make things confusing) So to get an add operation, the add port needs to be set to "1" in fabric but since the sense of this signal is switched around in the xbip_dsp48_addsub we need to set the add port to "0" for an add. 
    end generate mode_adder;
    mode_subtractor : if C_ADD_MODE = 1 generate
      i_ADDF <= '1';
    end generate mode_subtractor;
    mode_addsub     : if C_ADD_MODE = 2 generate
      i_ADDF <= not(ADD);               --adds the inversion on the port sense to get from high add in c_addsub to low add in xbip_dsp48_addsub
    end generate mode_addsub;


    --add c_borrow_low generic to change the sense of cin and cout signal from fabric sense for dsp48 implementation
    mode_borrow_active_low : if ((C_BORROW_LOW = 1) and (C_ADD_MODE = 1) and (C_HAS_C_IN = 1)) generate
      i_C_IN <= not(C_IN);              --generic makes sense of borrow_in the same as fabric when subtracting 
    end generate mode_borrow_active_low;

    mode_borrow_active_high : if ((C_BORROW_LOW = 0) and (C_ADD_MODE = 1) and (C_HAS_C_IN = 1)) or (C_HAS_C_IN = 1 and C_ADD_MODE = 0) generate
      i_C_IN <= (C_IN);
    end generate mode_borrow_active_high;

    mode_borrow_active_low_addsub : if C_HAS_C_IN = 1 and C_ADD_MODE = 2 AND C_BORROW_LOW = 1 generate
      i_C_IN <= C_IN when ADD = '1' else not(C_IN);
    end generate mode_borrow_active_low_addsub;

    mode_borrow_active_high_addsub : if C_HAS_C_IN = 1 and C_ADD_MODE = 2 AND C_BORROW_LOW = 0 generate
      i_C_IN <= C_IN;
    end generate mode_borrow_active_high_addsub;

    has_no_c_in : if C_HAS_C_IN = 0 generate
      i_C_IN <= '0';
    end generate has_no_c_in;

    has_ce    : if C_HAS_CE = 1 generate
      i_CE <= CE;
    end generate has_ce;
    has_no_ce : if C_HAS_CE = 0 generate
      i_CE <= '1';
    end generate has_no_ce;

    has_clk    : if C_LATENCY /= 0 generate
      i_CLK <= CLK;
    end generate has_clk;
    has_no_clk : if C_LATENCY = 0 generate
      i_CLK <= '0';
    end generate has_no_clk;

    has_sclr    : if C_HAS_SCLR = 1 generate
      i_SCLR <= SCLR;
    end generate has_sclr;
    has_no_sclr : if C_HAS_SCLR = 0 generate
      i_SCLR <= '0';
    end generate has_no_sclr;

    has_bypass_normal : if (C_HAS_BYPASS = 1) AND (C_BYPASS_LOW = 0) generate
      i_BYPASS <= BYPASS;
    end generate has_bypass_normal;

    has_bypass_low : if (C_HAS_BYPASS = 1) AND (C_BYPASS_LOW = 1) generate
      i_BYPASS <= not(BYPASS);
    end generate has_bypass_low;

    has_no_bypass : if C_HAS_BYPASS = 0 generate
      i_BYPASS <= '0';
    end generate has_no_bypass;


  end generate xbip_addsub;

end behavioral;





