-- $RCSfile: xfft_v8_0_xst.vhd,v $ $Revision: 1.2 $ $Date: 2010/09/08 12:33:25 $
--
--  (c) Copyright 1995-2010 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------------
-- Wrapper for behavioral model
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library XilinxCoreLib;
use Xilinxcorelib.xfft_v8_0_comp.all;

--core_if on entity xfft_v8_0_xst
  entity xfft_v8_0_xst is
    generic (
      C_XDEVICEFAMILY             : string  := "no_family";
      C_S_AXIS_CONFIG_TDATA_WIDTH : integer := 40;    -- The width of the configuration channel's TDATA
      C_S_AXIS_DATA_TDATA_WIDTH   : integer := 32;    -- The width of the input data channel's TDATA
      C_M_AXIS_DATA_TDATA_WIDTH   : integer := 32;    -- The width of the output data channel's TDATA
      C_M_AXIS_DATA_TUSER_WIDTH   : integer := 1;     -- The width of the output data channel's TUSER
      C_M_AXIS_STATUS_TDATA_WIDTH : integer := 1;     -- The width of the output status channel's TDATA
      C_THROTTLE_SCHEME           : integer := 0;     -- 0: Real Time mode.  Externally induced waitstates are not allowed.
                                                      -- 1: Non real time mode.  Throttling by external wait states is allowed
      C_CHANNELS                  : integer := 1;     -- Number of channels: 1-12 (ignored unless C_ARCH=4)
      C_NFFT_MAX                  : integer := 8;     -- log2(maximum point size): 3-16
      C_ARCH                      : integer := 2;     -- Architecture: 1=radix4, 2=radix2, 3=pipelined, 4=single output
      C_HAS_NFFT                  : integer := 1;     -- Run-time configurable point size: 0=no, 1=yes
      C_USE_FLT_PT                : integer := 0;     -- Build a pseudo floating point single-precision FFT
      C_INPUT_WIDTH               : integer := 12;    -- Input data width: 8-34 bits
      C_TWIDDLE_WIDTH             : integer := 12;    -- Twiddle factor width: 8-34 bits
      C_OUTPUT_WIDTH              : integer := 12;    -- Output data width: must be C_INPUT_WIDTH+C_NFFT_MAX+1 if C_HAS_SCALING=0, C_INPUT_WIDTH otherwise
      C_HAS_SCALING               : integer := 1;     -- Data is scaled after the butterfly: 0=no, 1=yes
      C_HAS_BFP                   : integer := 0;     -- Type of scaling if C_HAS_SCALING=1: 0=set by SCALE_SCH input, 1=block floating point
      C_HAS_ROUNDING              : integer := 0;     -- Type of data rounding: 0=truncation, 1=unbiased rounding
      C_HAS_ACLKEN                : integer := 0;     -- Clock enable input present: 0=no, 1=yes
      C_HAS_ARESETN               : integer := 0;     -- Synchronous clear input present: 0=no, 1=yes
      C_HAS_OVFLO                 : integer := 0;     -- Overflow output present: 0=no, 1=yes (ignored unless C_HAS_SCALING=1 and C_HAS_BFP=0)
      C_HAS_NATURAL_INPUT         : integer := 1;     -- Input ordering: 0=bit/digit reversed order input, 1=natural order input
      C_HAS_NATURAL_OUTPUT        : integer := 1;     -- Output ordering: 0=bit/digit reversed order output, 1=natural order output
      C_HAS_CYCLIC_PREFIX         : integer := 1;     -- Optional cyclic prefix insertion: 0=no, 1=yes
      C_HAS_XK_INDEX              : integer := 0;     -- Optional XK_INDEX generation: 0=no, 1=yes
      C_DATA_MEM_TYPE             : integer := 0;     -- Type of data memory: 0=distributed memory, 1=BRAM (ignored if C_ARCH=3)
      C_TWIDDLE_MEM_TYPE          : integer := 0;     -- Type of twiddle factor memory: 0=distributed memory, 1=BRAM (ignored if C_ARCH=3)
      C_BRAM_STAGES               : integer := 0;     -- Number of pipeline stages using BRAM for data and twiddle memories (C_ARCH=3 only)
      C_REORDER_MEM_TYPE          : integer := 1;     -- Type of reorder buffer memory: 0=distributed memory, 1=BRAM (C_ARCH=3 only)
      C_USE_HYBRID_RAM            : integer := 0;     -- Implement data memories using a hybrid BRAM/DistRAM structure if possible
      C_OPTIMIZE_GOAL             : integer := 0;     -- Optimization goal: 0=minimum slices, 1=maximum clock frequency
      C_CMPY_TYPE                 : integer := 1;     -- 0=Use LUTs, 1=Use Mults/DSPs (3-mult structure), 2=Use Mults/DSPs (4-mult structure)
      C_BFLY_TYPE                 : integer := 0      -- Optimize butterfly arithmetic for speed using DSP48s: 0=no, 1=yes
      );

    port (
      -- Inputs independent of number of channels
      aclk       : in std_logic := '1';              -- Clock
      aclken     : in std_logic := '1';              -- Clock enable (present if C_HAS_ACLKEN=1)
      aresetn    : in std_logic := '1';              -- Synchronous clear (present if C_HAS_ARESETN=1)

      -- AXI Signals
      -- -----------
      s_axis_config_tdata  : in std_logic_vector (C_S_AXIS_CONFIG_TDATA_WIDTH-1 downto 0); -- TDATA  for the configuration chanel
      s_axis_config_tvalid : in std_logic                                                ; -- TVALID for the configuration chanel
      s_axis_config_tready : out std_logic                                               ; -- TREADY for the configuration chanel
                                                                                                                               
      s_axis_data_tdata  : in std_logic_vector (C_S_AXIS_DATA_TDATA_WIDTH-1 downto 0)    ; -- TDATA  for the Data Input channel                                   
      s_axis_data_tvalid : in std_logic                                                  ; -- TVALID for the Data Input channel
      s_axis_data_tready : out std_logic                                                 ; -- TREADY for the Data Input channel
      s_axis_data_tlast  : in std_logic                                                  ; -- TLAST  for the Data Input channel

      -- The outgoing data channel                                                                                                           
      m_axis_data_tdata  : out std_logic_vector (C_M_AXIS_DATA_TDATA_WIDTH-1 downto 0)   ; -- TDATA  for the Data Output channel                                   
      m_axis_data_tuser  : out std_logic_vector (C_M_AXIS_DATA_TUSER_WIDTH-1 downto 0)   ; -- TUSER  for the Data Output channel
      m_axis_data_tvalid : out std_logic                                                 ; -- TVALID for the Data Output channel
      m_axis_data_tready : in  std_logic  := '1'                                         ; -- TREADY for the Data Output channel
      m_axis_data_tlast  : out std_logic                                                 ; -- TLAST  for the Data Output channel

      -- Status Channel                                                                                                                      
      m_axis_status_tdata  : out std_logic_vector(C_M_AXIS_STATUS_TDATA_WIDTH-1 downto 0); -- TDATA  for the Status channel   
      m_axis_status_tvalid : out std_logic                                               ; -- TVALID for the Status channel                                      
      m_axis_status_tready : in  std_logic := '1'                                        ; -- TREADY for the Status channel   

      -- Event interface
      event_frame_started        : out std_logic := '0';                                   -- The event_frame_started event
      event_tlast_unexpected     : out std_logic := '0';                                   -- The event_tlast_unexpected event
      event_tlast_missing        : out std_logic := '0';                                   -- The event_tlast_missing event
      event_fft_overflow         : out std_logic := '0';                                   -- The event_fft_overflow  event
      event_status_channel_halt  : out std_logic := '0';                                   -- The event_status_channel_halt event
      event_data_in_channel_halt : out std_logic := '0';                                   -- The event_data_in_channel_halt event
      event_data_out_channel_halt: out std_logic := '0'                                    -- The event_data_out_channel_halt event
      );
--core_if off
end xfft_v8_0_xst;


architecture behavioral of xfft_v8_0_xst is

begin
  --core_if on instance i_behv xfft_v8_0
  i_behv : xfft_v8_0
    generic map (
      C_XDEVICEFAMILY             => C_XDEVICEFAMILY,
      C_S_AXIS_CONFIG_TDATA_WIDTH => C_S_AXIS_CONFIG_TDATA_WIDTH,
      C_S_AXIS_DATA_TDATA_WIDTH   => C_S_AXIS_DATA_TDATA_WIDTH,
      C_M_AXIS_DATA_TDATA_WIDTH   => C_M_AXIS_DATA_TDATA_WIDTH,
      C_M_AXIS_DATA_TUSER_WIDTH   => C_M_AXIS_DATA_TUSER_WIDTH,
      C_M_AXIS_STATUS_TDATA_WIDTH => C_M_AXIS_STATUS_TDATA_WIDTH,
      C_THROTTLE_SCHEME           => C_THROTTLE_SCHEME,
      C_CHANNELS                  => C_CHANNELS,
      C_NFFT_MAX                  => C_NFFT_MAX,
      C_ARCH                      => C_ARCH,
      C_HAS_NFFT                  => C_HAS_NFFT,
      C_USE_FLT_PT                => C_USE_FLT_PT,
      C_INPUT_WIDTH               => C_INPUT_WIDTH,
      C_TWIDDLE_WIDTH             => C_TWIDDLE_WIDTH,
      C_OUTPUT_WIDTH              => C_OUTPUT_WIDTH,
      C_HAS_SCALING               => C_HAS_SCALING,
      C_HAS_BFP                   => C_HAS_BFP,
      C_HAS_ROUNDING              => C_HAS_ROUNDING,
      C_HAS_ACLKEN                => C_HAS_ACLKEN,
      C_HAS_ARESETN               => C_HAS_ARESETN,
      C_HAS_OVFLO                 => C_HAS_OVFLO,
      C_HAS_NATURAL_INPUT         => C_HAS_NATURAL_INPUT,
      C_HAS_NATURAL_OUTPUT        => C_HAS_NATURAL_OUTPUT,
      C_HAS_CYCLIC_PREFIX         => C_HAS_CYCLIC_PREFIX,
      C_HAS_XK_INDEX              => C_HAS_XK_INDEX,
      C_DATA_MEM_TYPE             => C_DATA_MEM_TYPE,
      C_TWIDDLE_MEM_TYPE          => C_TWIDDLE_MEM_TYPE,
      C_BRAM_STAGES               => C_BRAM_STAGES,
      C_REORDER_MEM_TYPE          => C_REORDER_MEM_TYPE,
      C_USE_HYBRID_RAM            => C_USE_HYBRID_RAM,
      C_OPTIMIZE_GOAL             => C_OPTIMIZE_GOAL,
      C_CMPY_TYPE                 => C_CMPY_TYPE,
      C_BFLY_TYPE                 => C_BFLY_TYPE
      )
    port map (
      aclk                        => aclk,
      aclken                      => aclken,
      aresetn                     => aresetn,
      s_axis_config_tdata         => s_axis_config_tdata,
      s_axis_config_tvalid        => s_axis_config_tvalid,
      s_axis_config_tready        => s_axis_config_tready,
      s_axis_data_tdata           => s_axis_data_tdata,
      s_axis_data_tvalid          => s_axis_data_tvalid,
      s_axis_data_tready          => s_axis_data_tready,
      s_axis_data_tlast           => s_axis_data_tlast,
      m_axis_data_tdata           => m_axis_data_tdata,
      m_axis_data_tuser           => m_axis_data_tuser,
      m_axis_data_tvalid          => m_axis_data_tvalid,
      m_axis_data_tready          => m_axis_data_tready,
      m_axis_data_tlast           => m_axis_data_tlast,
      m_axis_status_tdata         => m_axis_status_tdata,
      m_axis_status_tvalid        => m_axis_status_tvalid,
      m_axis_status_tready        => m_axis_status_tready,
      event_frame_started         => event_frame_started,
      event_tlast_unexpected      => event_tlast_unexpected,
      event_tlast_missing         => event_tlast_missing,
      event_fft_overflow          => event_fft_overflow,
      event_status_channel_halt   => event_status_channel_halt,
      event_data_in_channel_halt  => event_data_in_channel_halt,
      event_data_out_channel_halt => event_data_out_channel_halt
      );

  --core_if off

end behavioral;

