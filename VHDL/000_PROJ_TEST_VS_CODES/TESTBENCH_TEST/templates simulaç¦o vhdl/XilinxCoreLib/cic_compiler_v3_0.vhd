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
-- Behavioural Model
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.cic_compiler_v3_0_pkg.all;
use xilinxcorelib.cic_compiler_v3_0_sim_comps.all;
use Xilinxcorelib.bip_utils_pkg_v2_0.get_max;
use xilinxcorelib.axi_utils_pkg_v1_1.all;
use xilinxcorelib.axi_utils_v1_1_comps.all;

-- (A)synchronous multi-input gate
--
--core_if on entity cic_compiler_v3_0
  entity cic_compiler_v3_0 is
    GENERIC (
      C_COMPONENT_NAME  : string := "cic_compiler_v3_0";
      C_FILTER_TYPE     : integer := 1;
      C_NUM_STAGES      : integer := 3;
      C_DIFF_DELAY      : integer := 1;
      C_RATE            : integer := 4;
      C_INPUT_WIDTH     : integer := 18;
      C_OUTPUT_WIDTH    : integer := 22;
      C_USE_DSP         : integer := 0;
      C_HAS_ROUNDING    : integer := 0;
      C_NUM_CHANNELS    : integer := 1;
      C_RATE_TYPE       : integer := 0;
      C_MIN_RATE        : integer := 4;
      C_MAX_RATE        : integer := 4;
      C_SAMPLE_FREQ     : integer := 1;
      C_CLK_FREQ        : integer := 4;
      C_USE_STREAMING_INTERFACE : integer:= 0;
      C_FAMILY          : string  := "virtex6";
      C_XDEVICEFAMILY   : string  := "virtex6";
      C_C1    : integer := 19;
      C_C2    : integer := 20;
      C_C3    : integer := 20;
      C_C4    : integer := 0;
      C_C5    : integer := 0;
      C_C6    : integer := 0;
      C_I1    : integer := 20;
      C_I2    : integer := 21;
      C_I3    : integer := 22;
      C_I4    : integer := 0;
      C_I5    : integer := 0;
      C_I6    : integer := 0;

      -- The width of the configuration channel's TDATA
      C_S_AXIS_CONFIG_TDATA_WIDTH : integer := 32;

      -- The width of the input data channel's TDATA
      C_S_AXIS_DATA_TDATA_WIDTH : integer := 32;

      -- The width of the output data channel's TDATA
      C_M_AXIS_DATA_TDATA_WIDTH : integer := 32;

      -- The width of the output data channel's TUSER
      C_M_AXIS_DATA_TUSER_WIDTH : integer := 32;
      -- 0 = no m_axis_data_tready
      -- 1 = has m_axis_data_tready
      --
      C_HAS_DOUT_TREADY: integer := 0;
      -- 0 = No clock enable
      -- 1 = active-high clock enable
      --
      C_HAS_ACLKEN : integer := 0;
      -- 0 = No reset
      -- 1 = Active-low reset
      --
      C_HAS_ARESETN : integer := 1
      );
    PORT (
        aclk    : in std_logic := '1';
        aclken  : in std_logic := '1';
        aresetn : in std_logic := '1';

        -- Configuration Channel (Optional)
        -- --------------------------------
        --

        s_axis_config_tdata  : in std_logic_vector (C_S_AXIS_CONFIG_TDATA_WIDTH-1 downto 0) := (others => '0');
        s_axis_config_tvalid : in std_logic := '0';
        s_axis_config_tready : out std_logic := '0';

        -- Data In Channel
        ------------------
        --
        s_axis_data_tdata  : in std_logic_vector (C_S_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
        s_axis_data_tvalid : in std_logic                                               := '0';
        s_axis_data_tready : out std_logic                                              := '0';
        s_axis_data_tlast  : in  std_logic                                              := '0';

        -- Data Out Channel
        -- ----------------
        --
        m_axis_data_tdata  : out std_logic_vector (C_M_AXIS_DATA_TDATA_WIDTH-1 downto 0) := (others => '0');
        m_axis_data_tuser  : out std_logic_vector (C_M_AXIS_DATA_TUSER_WIDTH-1 downto 0) := (others => '0');
        m_axis_data_tvalid : out std_logic                                               := '0';
        m_axis_data_tready : in std_logic                                                := '0';
        m_axis_data_tlast  : out  std_logic                                              := '0';

        event_tlast_unexpected : out std_logic := '0';   
        event_tlast_missing    : out std_logic := '0';   
        event_halted           : out std_logic := '0'   
      );
--core_if off
end cic_compiler_v3_0;


architecture behavioral of cic_compiler_v3_0 is

  -- signals section
  signal aclken_i             : std_logic := '1';
  signal reset_i              : std_logic := '0';

  -- Internal signals
  signal rfd_i                       : std_logic                                                                       := '0';
  signal rdy_i                       : std_logic                                                                       := '0';
  signal nd_i                        : std_logic                                                                       := '0';
  signal din_i                       : std_logic_vector (C_INPUT_WIDTH-1 downto 0)                                     := (others => '0');
  signal rate_we_i                   : std_logic                                                                       := '0';
  signal rate_i                      : std_logic_vector (number_of_digits(C_MAX_RATE, 2)-1 downto 0)                   := (others => '0');
  signal ready_for_new_rate_change_i : std_logic                                                                       := '0';
  signal chan_sync_from_cic_pe       : std_logic                                                                       := '0';
  signal chan_out_from_cic_pe        : std_logic_vector (get_max(1, number_of_digits(C_NUM_CHANNELS-1, 2))-1 downto 0) := (others => '0');
  signal dout_from_cic_pe            : std_logic_vector (C_OUTPUT_WIDTH-1 downto 0)                                    := (others=>'0');
   
  signal ce_to_core                  : std_logic := '1';  -- The clock enable used by the internal core
  signal halt                        : std_logic := '1';  -- The output FIFO is full, so halt the core
  signal event_halted_i              : std_logic := '0';
  signal last_channel_in             : std_logic := '0'; -- Asserted when the sample being consumed is for the last channel
  signal last_channel_out            : std_logic := '0'; -- Asserted when the sample being produced is for the last channel
  signal s_axis_data_tready_i        : std_logic := '0';

  signal aresetn_i                   : std_logic := '1';

  signal channel_in_count            : std_logic_vector (get_max(1, number_of_digits(C_NUM_CHANNELS-1, 2))-1 downto 0) := (others => '0');
--  signal sample_consumed             : std_logic := '0'; -- Asserted when the core consumes a sample.   When there is a FIFO, it's the
--                                                         -- read signal.  When there's no FIFO, it's TREADY and TVALID

  
  -- Function used to get the C_HAS_CE generic value for the CIC core.
  -- --------------------------------------------------------------------
  function get_ce_generic (constant C_HAS_DOUT_TREADY : integer;
                           constant C_HAS_ACLKEN      : integer)
    return integer is
  begin
    -- When C_HAS_DOUT_TREADY = 0 C_HAS_CE is optional
    -- When C_HAS_DOUT_TREADY = 1 we MUST have CE.
    
    if C_HAS_DOUT_TREADY = 0 then
      return C_HAS_ACLKEN;
    else
      return 1;
    end if;
  end get_ce_generic;
  -- --------------------------------------------------------------------

  signal output_fifo_full: std_logic := '0';
  signal write_to_fifo   : std_logic := '0';
  signal input_fifo_empty            : std_logic := '0';
  --signal read_from_fifo              : std_logic := '0';


  signal dout_fifo_vector_in         : std_logic_vector(calculate_data_out_width_no_padding(C_OUTPUT_WIDTH, C_NUM_CHANNELS)-1 downto 0);
  signal dout_fifo_vector_out        : std_logic_vector(calculate_data_out_width_no_padding(C_OUTPUT_WIDTH, C_NUM_CHANNELS)-1 downto 0);

  signal din_fifo_vector_in         : std_logic_vector(calculate_data_in_width_no_padding(C_INPUT_WIDTH)-1 downto 0);
  signal din_fifo_vector_out        : std_logic_vector(calculate_data_in_width_no_padding(C_INPUT_WIDTH)-1 downto 0);


  
  
begin

  has_aclken    : if (C_HAS_ACLKEN = 1) generate aclken_i <= aclken; end generate;
  has_no_aclken : if (C_HAS_ACLKEN = 0) generate aclken_i <= '1'; end generate;

  has_aresetn : if (C_HAS_ARESETN = 1) generate
    p_gen_reset : process (aclk)
    begin
      if rising_edge(aclk) then
        reset_i <= not aresetn;
      end if;
    end process p_gen_reset;
    aresetn_i <= aresetn;
  end generate;

  has_no_aresetn : if (C_HAS_ARESETN = 0) generate
    reset_i   <= '0';
    aresetn_i <= '1';
  end generate;

  -- -------------------------------------------------
  -- AXI Channels
  -- -------------------------------------------------

  -- Configuration Channel
  -- ---------------------
  --       TVALID and data can be driven from here
  --       TREADY requires a signal from the decimate and interpolate sub cores
  has_fixed_rate : if (C_RATE_TYPE = 0) generate
    -- Fixed rate, so just tie the rate signals to constant values.  
    --
    rate_we_i            <= '0';
    rate_i               <= (others => '0');
    s_axis_config_tready <= '0';
  end generate;

  has_prog_rate : if (C_RATE_TYPE /= 0) generate
    -- Programable rate
    --
    s_axis_config_tready <= ready_for_new_rate_change_i;
    rate_we_i            <= '1' when s_axis_config_tvalid = '1' and ready_for_new_rate_change_i = '1' and aclken_i = '1' else '0';
    rate_i               <= s_axis_config_tdata(number_of_digits(C_MAX_RATE,2)-1 downto 0);
  end generate;


  -- --------------------------------------------------------------------------
  -- Data In AXI Channel
  -- --------------------------------------------------------------------------
  -- When C_HAS_DOUT_TREADY = 0 then we can just attach the AXI signals directly to the internal core.  This gives no elasticity, but
  -- doesn't consume extra resources.  However, when C_HAS_DOUT_TREADY = 1 we hao include an inut FIFO.  When we have an output TREADY,
  -- the system can stall the core by not reading data quickly enough.  The stall is handled by deasserting CE to the decimator/interpolator
  -- modules.  However, RFD will hold its last value, so may get stuck at 1, which means TREADY will be 1 even though the core can't
  -- actually accept data.  Therefore, we have to decouple s_axis_data_tready from RFD, and make sure it's registered, and the AXI FIFO
  -- is the obvious way to do this.


  -- This block concatenates the AXI signals              This block spilts the vector into signals suitable for the decimator
  -- into a single vector which can be stored             and interpolator sub-modules.  
  -- in a FIFO if required.                                           ______/
  -- Padding is removed.                                             /
  --  \___                                                          /      _______
  --       \                          _____                       _/      |                              
  --        \                        |     |                     | |      | I                          
  --         \_                      |     |                     | |      | N  D                        
  --         | |                     |     |                     | |      | T  E                           
  --         | |                     |     |                     | | ND   | E  C                         
  --  TDATA  | |  din_fifo_vector_in |     | din_fifo_vector_out | |----- | R  I 
  -- ------- |1|---------------------|  2  |---------------------|3| DIN  | P  M                         
  --         | |                     |     |                     | |----- | O  A  
  --         | |                     |     |                     | |      | L  T                          
  --         | |                     |     |                     | |      | A  O  
  --         |_|                     |     |                     | |      | T  R                           
  --                                 |_____|                     |_|      | O           
  --               ____________________/                                  | R
  --              /                                                       |_______
  --   This block is a FIFO when C_HAS_DOUT_TREADY = 1,             
  --   and is just some aliasing when it is 0.                      
  --                                                                
                                                             
  



  -- Step 1: Merge AXI inputs into single vector
  -- --------------------------------------------------
  --
  axi_din_chan_build_fifo_in_vector  (tdata          => s_axis_data_tdata,
                                      out_vector     => din_fifo_vector_in,
                                      C_INPUT_WIDTH  => C_INPUT_WIDTH
                                    );



  -- Step 2: Route through FIFO if required
  -- --------------------------------------
  --
  din_channel_has_no_dout_tready : if (C_HAS_DOUT_TREADY = 0) generate
    -- No output FIFO
    -- Just pass vector
    din_fifo_vector_out    <= din_fifo_vector_in;
    --nd_i                   <= s_axis_data_tvalid;  -- TODO: This is wrong.  We only have new data when ACLKEN = '1'
    nd_i                   <= s_axis_data_tvalid and aclken_i; 

    --sample_consumed        <= s_axis_data_tvalid and rfd_i;  -- When both of these are high, a sample is consumed (ignoring ce_to_core)

    s_axis_data_tready_i   <= rfd_i;
   
  end generate;


  din_channel_has_dout_tready : if (C_HAS_DOUT_TREADY = 1) generate
    signal one : std_logic := '1';
    signal read_from_buffer : std_logic;
    signal write_from_buffer : std_logic;

  begin

    read_from_buffer <= rfd_i and ce_to_core;  -- Don't read if PE (processing engine) is disabled

    -- The skid buffer arsserts TVALID when ACLKEN is 0, so we have to qualify the TVALID with ACLKEN so that we don't pass
    -- data to the DUT when the buffer is disabled because of ACLKEN.
    -- 
    nd_i <= write_from_buffer and aclken_i;

    -- Only use A port.  Tie off B port
      
    skid_buffer : axi_slave_2to1_v1_1
      generic map (
        C_A_TDATA_WIDTH => calculate_data_in_width_no_padding(C_INPUT_WIDTH),
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
        sclr   => reset_i,
        
        -- AXI slave interface A
        s_axis_a_tready => s_axis_data_tready_i,
        s_axis_a_tvalid => s_axis_data_tvalid,
        s_axis_a_tdata  => din_fifo_vector_in,
        s_axis_a_tuser  => open,
        s_axis_a_tlast  => open,
        
        -- AXI slave interface B
        s_axis_b_tready => one,
        s_axis_b_tvalid => one,
        s_axis_b_tdata  => open,
        s_axis_b_tuser  => open,
        s_axis_b_tlast  => open,
        
        -- Read interface to core
        m_axis_z_tready  => read_from_buffer, 
        m_axis_z_tvalid  => write_from_buffer,
        m_axis_z_tdata_a => din_fifo_vector_out,
        m_axis_z_tuser_a => open,
        m_axis_z_tlast_a => open,  -- TLAST is already packed into the data, so we don't need it here.
        m_axis_z_tdata_b => open, 
        m_axis_z_tuser_b => open,  
        m_axis_z_tlast_b => open
        );
  end generate;

  
--  din_channel_has_dout_tready : if (C_HAS_DOUT_TREADY = 1) generate
--    -- Some signals to tie the two FIFOs together
--    signal master_has_space : std_logic := '0';  -- When 1, there's space in the master FIFO, so read from the slave FIFO
--    signal slave_has_data   : std_logic := '0';  -- When 1, the slave is transferring data to the master
--    signal slave_data_out   : std_logic_vector(calculate_data_in_width_no_padding(C_INPUT_WIDTH)-1 downto 0);
--    
--  begin
--    -- Has input FIFO.
--    --
--
--    -- Read from the FIFO when RFD is high.  There is a gotcha though.  On clock cycle 1, RFD goes
--    -- high.  On clock cycle 2, ND will go high because we have data from the FIFO.  However, RFD will still be high
--    -- because it hasn't seen ND high yet.  This will cause a second read from the FIFO if data is available.
--    -- On clock cycle 3, ND will be high for the second read.  However, RFD will be low and the data will be lost.
--    --
--    -- We can get bursts of RFDs that do have to be satisfied, so blocking RFD with ND doesn't work.  The real
--    -- problem is that when RFD asserts, we have to return ND that cycle.  I'll use a master FIFO as a skid
--    -- buffer to make that happen
--    
--    read_from_fifo <= rfd_i;
--
--    nd_i <= sample_consumed;
--
--    fifo_slave : glb_ifx_slave_v1_1
--      generic map (
--        WIDTH          => calculate_data_in_width_no_padding(C_INPUT_WIDTH),
--        DEPTH          => 16,
--        HAS_IFX        => false,
--        HAS_UVPROT     => true,
--        AEMPTY_THRESH0 => 15,
--        AEMPTY_THRESH1 => 15)   
--      port map (
--        aclk   => aclk,
--        aclken => aclken_i,
--        areset => reset_i,
--        aresetn => aresetn_i,
--
--        ifx_valid  => s_axis_data_tvalid,
--        ifx_ready  => s_axis_data_tready_i,
--        ifx_data   => din_fifo_vector_in,
--        rd_enable  => master_has_space, 
--        rd_avail   => open,
--        rd_valid   => slave_has_data,
--        rd_data    => slave_data_out,
--        full       => open,
--        empty      => open,
--        aempty     => open,
--        not_full   => open,
--        not_empty  => open,
--        not_aempty => open,
--        add        => open);
--
--
--    fifo_master : glb_ifx_master_v1_1
--      generic map (
--        WIDTH         => calculate_data_in_width_no_padding(C_INPUT_WIDTH),
--        DEPTH         => 16,
--        AFULL_THRESH1 => 14,            -- Actual threshhold is this +2
--        AFULL_THRESH0 => 14)
--
--      port map (
--        aclk   => aclk,
--        aclken => ce_to_core,
--        areset => reset_i,
--
--        wr_enable => slave_has_data,  
--        wr_data   => slave_data_out,  
--
--        ifx_valid => sample_consumed,
--        ifx_ready => read_from_fifo,
--        ifx_data  => din_fifo_vector_out,  
--
--        full      => open,
--        afull     => open,
--        not_full  => open,
--        not_afull => master_has_space,
--        add       => open);
--
--    
--    
--  end generate;
  s_axis_data_tready  <= s_axis_data_tready_i;


  -- Step 3: Split and send to Interpolator/Decimator and Event Interface
  -- ---------------------------------------------------------------------
  axi_din_chan_convert_fifo_out_vector_to_cic_in (fifo_vector     => din_fifo_vector_out,
                                                  data            => din_i,
                                                  C_INPUT_WIDTH  => C_INPUT_WIDTH);


  -- --------------------------------------------------------------------------
  -- Data Out AXI Channel
  -- --------------------------------------------------------------------------
  --
  -- This block concatenates the signals into a single vector which
  -- can be stored in a FIFO if required.  No padding is added.
  --            \______________________  
  --   ______                          \                           _____                        _
  --         |                          \                         |     |                      | | TDATA    
  --         |                           \_                       |     |                      | |-------
  --     D   |                           | |                      |     |                      | | 
  --     U   |--- dout_from_cic_pe ------| |                      |     |                      | |
  --     T   |                           | |  dout_fifo_vector_in |     | dout_fifo_vector_out | | TUSER    
  --         |--- chan_out_from_cic_pe --|1|----------------------|  2  |----------------------|3|-------
  --         |                           | |                      |     |                      | |     
  --         |--- chan_sync_from_cic_pe -| |                      |     |                      | |
  --         |                           | |                      |     |                      | | TLAST
  --         |    last_channel_out ------|_|                      |     |                      | |-------     
  --   ______|                                                    |_____|                      |_|     
  --               _________________________________________________/         __________________/ 
  --              /                                                          /   
  --   This block is a FIFO when C_HAS_DOUT_TREADY = 1,         This block spilts the vector and merges the individual 
  --   and is just some aliasing when it is 0.                  signals into TDATA and TUSER.  Padding is added where required.
  --



  last_channel_out <= '1' when chan_out_from_cic_pe = C_NUM_CHANNELS -1 and C_NUM_CHANNELS >1 else '0';
 
   
  
  -- Step 1: Merge CIC_PE outputs into single vector
  -- --------------------------------------------------
  --
  axi_dout_chan_build_fifo_in_vector(last_channel_out => last_channel_out,
                                     dout             => dout_from_cic_pe,
                                     chan_out         => chan_out_from_cic_pe,
                                     chan_sync        => chan_sync_from_cic_pe,
                                     out_vector       => dout_fifo_vector_in,
                                     C_OUTPUT_WIDTH   => C_OUTPUT_WIDTH,
                                     C_NUM_CHANNELS   => C_NUM_CHANNELS);



  -- Step 2: Route through FIFO if required
  -- --------------------------------------
  --
  dout_channel_has_no_dout_tready : if (C_HAS_DOUT_TREADY = 0) generate
    -- No output FIFO
    -- Just pass vector
    dout_fifo_vector_out <= dout_fifo_vector_in;
    halt                 <= '0';
    ce_to_core           <= aclken_i;
    m_axis_data_tvalid   <= rdy_i;
  end generate;

  dout_channel_has_dout_tready : if (C_HAS_DOUT_TREADY = 1) generate
    -- Has output FIFO.
    --

    write_to_fifo <= '1' when rdy_i = '1' and ce_to_core = '1' else '0';

    fifo :glb_ifx_master_v1_1
      generic map (
        WIDTH         => calculate_data_out_width_no_padding(C_OUTPUT_WIDTH, C_NUM_CHANNELS),
        DEPTH         => 16,
        AFULL_THRESH1 => 14,            -- Actual threshhold is this +2
        AFULL_THRESH0 => 14)

      port map (
        aclk   => aclk,
        aclken => aclken_i,
        areset => reset_i,

        wr_enable => write_to_fifo,
        wr_data   => dout_fifo_vector_in,

        ifx_valid => m_axis_data_tvalid,
        ifx_ready => m_axis_data_tready,
        ifx_data  => dout_fifo_vector_out,

        --full      => output_fifo_full,
        afull      => output_fifo_full,
        full     => open,
        not_full  => open,
        not_afull => open,
        add       => open);


    -- Disable the core (drive CE = 0) when the FIFO is full.  
    halt <= output_fifo_full;

    p_ce_to_core: process (aclk)
    begin
      if rising_edge(aclk) then
        if reset_i = '1' then
          ce_to_core <= '1';
        else
          ce_to_core <= aclken_i and (not halt);
        end if;
      end if;
    end process p_ce_to_core;
    
    
  end generate;


  -- Step 3: Split and pad
  -- ---------------------
  axi_dout_chan_convert_fifo_out_vector_to_axi (fifo_vector    => dout_fifo_vector_out,
                                                tdata          => m_axis_data_tdata,
                                                tuser          => m_axis_data_tuser,
                                                tlast          => m_axis_data_tlast,
                                                C_OUTPUT_WIDTH => C_OUTPUT_WIDTH,
                                                C_NUM_CHANNELS => C_NUM_CHANNELS);


  decimator : if C_FILTER_TYPE = 1 generate
    decimation_filter : cic_compiler_v3_0_decimate_bhv
      generic map (
        C_NUM_STAGES              => C_NUM_STAGES,
        C_DIFF_DELAY              => C_DIFF_DELAY,
        C_RATE                    => C_RATE,
        C_INPUT_WIDTH             => C_INPUT_WIDTH,
        C_OUTPUT_WIDTH            => C_OUTPUT_WIDTH,
        C_USE_DSP                 => C_USE_DSP,
        C_HAS_ROUNDING            => C_HAS_ROUNDING,
        C_NUM_CHANNELS            => C_NUM_CHANNELS,
        C_RATE_TYPE               => C_RATE_TYPE,
        C_MIN_RATE                => C_MIN_RATE,
        C_MAX_RATE                => C_MAX_RATE,
        C_SAMPLE_FREQ             => C_SAMPLE_FREQ,
        C_CLK_FREQ                => C_CLK_FREQ,
        C_HAS_CE                  => get_ce_generic (C_HAS_DOUT_TREADY => C_HAS_DOUT_TREADY, C_HAS_ACLKEN => C_HAS_ACLKEN),
        C_HAS_SCLR                => C_HAS_ARESETN,
        C_HAS_ND                  => 1,
        C_USE_STREAMING_INTERFACE => C_USE_STREAMING_INTERFACE,
        C_FAMILY                  => C_XDEVICEFAMILY,
        C_COMB_WIDTHS             => (C_C1, C_C2, C_C3, C_C4, C_C5, C_C6),
        C_INT_WIDTHS              => (C_I1, C_I2, C_I3, C_I4, C_I5, C_I6)
        )
      port map (
        DIN                => din_i,
        ND                 => nd_i,
        RATE               => rate_i,
        RATE_WE            => rate_we_i,
        CE                 => ce_to_core,
        SCLR               => reset_i,
        CLK                => aclk,
        DOUT               => dout_from_cic_pe,
        RDY                => rdy_i,
        RFD                => rfd_i,
        CHAN_SYNC          => chan_sync_from_cic_pe,
        CHAN_OUT           => chan_out_from_cic_pe,
        halt               => halt,
        ready_for_new_rate => ready_for_new_rate_change_i,
        aresetn            => aresetn_i
        );
  end generate;

  interpolator : if C_FILTER_TYPE = 0 generate
    interpolation_filter : cic_compiler_v3_0_interpolate_bhv
      generic map (
        C_NUM_STAGES              => C_NUM_STAGES,
        C_DIFF_DELAY              => C_DIFF_DELAY,
        C_RATE                    => C_RATE,
        C_INPUT_WIDTH             => C_INPUT_WIDTH,
        C_OUTPUT_WIDTH            => C_OUTPUT_WIDTH,
        C_USE_DSP                 => C_USE_DSP,
        C_HAS_ROUNDING            => C_HAS_ROUNDING,
        C_NUM_CHANNELS            => C_NUM_CHANNELS,
        C_RATE_TYPE               => C_RATE_TYPE,
        C_MIN_RATE                => C_MIN_RATE,
        C_MAX_RATE                => C_MAX_RATE,
        C_SAMPLE_FREQ             => C_SAMPLE_FREQ,
        C_CLK_FREQ                => C_CLK_FREQ,
        C_HAS_CE                  => get_ce_generic (C_HAS_DOUT_TREADY => C_HAS_DOUT_TREADY, C_HAS_ACLKEN => C_HAS_ACLKEN),
        C_HAS_SCLR                => C_HAS_ARESETN,
        C_HAS_ND                  => 1,
        C_USE_STREAMING_INTERFACE => C_USE_STREAMING_INTERFACE,
        C_FAMILY                  => C_XDEVICEFAMILY,
        C_COMB_WIDTHS             => (C_C1, C_C2, C_C3, C_C4, C_C5, C_C6),
        C_INT_WIDTHS              => (C_I1, C_I2, C_I3, C_I4, C_I5, C_I6)
        )
      port map (
        DIN                => din_i,
        ND                 => nd_i,
        RATE               => rate_i,
        RATE_WE            => rate_we_i,
        CE                 => ce_to_core,
        SCLR               => reset_i,
        CLK                => aclk,
        DOUT               => dout_from_cic_pe,
        RDY                => rdy_i,
        RFD                => rfd_i,
        CHAN_SYNC          => chan_sync_from_cic_pe,
        CHAN_OUT           => chan_out_from_cic_pe,
        halt               => halt,
        ready_for_new_rate => ready_for_new_rate_change_i,
        aresetn            => aresetn_i
        );
  end generate;

  -- --------------------------------------------------------------------------
  -- Event Interface
  -- --------------------------------------------------------------------------
  p_channel_in_counter: process (aclk)
  begin
    if rising_edge(aclk) then
      if reset_i = '1' then
        channel_in_count <= (others => '0');
      elsif aclken_i = '1' then
        if s_axis_data_tready_i = '1' and s_axis_data_tvalid = '1' then
           if channel_in_count = C_NUM_CHANNELS - 1 then
            channel_in_count <= (others => '0');
          else
            channel_in_count <= std_logic_vector(unsigned(channel_in_count) +  1);
          end if;
        end if;
      end if;
    end if;
  end process;

  last_channel_in <= '1' when channel_in_count = C_NUM_CHANNELS - 1 else '0';

  -- Event TLAST Missing
  -- --------------------
  -- event_tlast_missing  :  Asserted when the sample for the last channel does not have s_axis_data_tlast asserted
  --
  -- It will take 1 cycle for the external event to be seen by anything using it on a rising clock edge.  
  
  gen_event_tlast_missing: if C_NUM_CHANNELS > 1 generate
    signal event_tlast_missing_int  : std_logic := '0';
  begin

    -- NOTE: Last channel in extends for a while - we can only check it when the transfer occurs
    event_tlast_missing_int  <= '1' when
                                last_channel_in = '1' and s_axis_data_tlast /= '1' and s_axis_data_tready_i = '1' and s_axis_data_tvalid = '1'
                                else '0';
   
    process (aclk)
    begin
      if rising_edge(aclk) then        
        if reset_i = '1' then
          event_tlast_missing <= '0';
        elsif aclken_i = '1' then
          event_tlast_missing <= event_tlast_missing_int;
        end if;
      end if;
    end process;
  end generate gen_event_tlast_missing;


  -- Event TLAST Unexpected
  -- --------------------
  -- event_tlast_unexpected  :  Asserted when the sample for any channel apart from the last has s_axis_data_tlast asserted
  --
  -- It will take 1 cycle for the external event to be seen by anything using it on a rising clock edge.  
 
  gen_event_tlast_unexpected: if C_NUM_CHANNELS > 1 generate
    signal event_tlast_unexpected_int  : std_logic := '0';
  begin

    -- NOTE: Last channel in extends for a while - we can only check it when the transfer occurs
    
    event_tlast_unexpected_int  <= '1' when
                                last_channel_in = '0' and s_axis_data_tlast /= '0' and s_axis_data_tready_i = '1' and s_axis_data_tvalid = '1'
                                else '0';
    
    process (aclk)
    begin
      if rising_edge(aclk) then        
        if reset_i = '1' then
          event_tlast_unexpected <= '0';
        elsif aclken_i = '1' then
          event_tlast_unexpected <= event_tlast_unexpected_int;
        end if;
      end if;
    end process;
  end generate gen_event_tlast_unexpected;
 
 
   -- Event Halted
   -- --------------------
   -- event_halted  :  Asserted when the core is halted due to the output data channel being full
   --
   -- It will take 1 cycle for the external event to be seen by anything using it on a rising clock edge.  
 
   gen_event_halted: if C_HAS_DOUT_TREADY = 1 generate
     p_event_halted : process (aclk)
     begin
       if rising_edge(aclk) then
         if reset_i = '1' then
           event_halted_i  <= '0';
        else
           event_halted_i  <= halt;
         end if;
       end if;
     end process p_event_halted;
     
     event_halted  <= event_halted_i;
   end generate gen_event_halted;
end behavioral;
