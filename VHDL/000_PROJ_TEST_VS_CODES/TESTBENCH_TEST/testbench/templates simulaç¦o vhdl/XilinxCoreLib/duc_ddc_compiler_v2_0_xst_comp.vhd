-- $RCSfile $ $Date: 2011/04/21 15:01:51 $ $Revision: 1.2 $
--
--  (c) Copyright 2009-2010 Xilinx, Inc. All rights reserved.
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
-- Component statement for wrapper of behavioural model
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package duc_ddc_compiler_v2_0_xst_comp is

----------------------------------------------------------
-- insert component declaration of top level xst file here
----------------------------------------------------------
  --core_if on component duc_ddc_compiler_v2_0_xst
  component duc_ddc_compiler_v2_0_xst
    generic (
      C_ELABORATION_DIR :    string    := "./elab/";  -- directory path containing data files
      C_FAMILY          :    string    := "virtex6";  -- the general family name
      C_XDEVICEFAMILY   :    string    := "virtex6";  -- the family specific part
      C_COMPONENT_NAME  :    string    := "dudc001";  -- the core instance name
      CORE_TYPE         :    integer   := 0;          -- core type: 0=DUC, 1=DDC
      STANDARD          :    integer   := 0;          -- air interface standard: 0=LTE, 1=TD-SCDMA
      CH_BANDWIDTH      :    integer   := 5;          -- channel bandwidth, rounded: 1 (1.4), 2 (1.6), 3, 5, 10, 15, 20
      RATE_P            :    integer   := 16;         -- numerator of overall rate change: 2-192
      RATE_Q            :    integer   := 1;          -- denominator of overall rate change: 1-3
      DIGITAL_IF        :    integer   := 0;          -- digital IF: 0=0Hz, 1=Fs/4
      N_CARRIERS        :    integer   := 1;          -- number of carriers: 1-18
      IF_PASSBAND       :    integer   := 5;          -- IF passband in MHz: 5, 10, 15, 20, 30, 40, 50
      N_ANTENNAS        :    integer   := 1;          -- number of antennas: 1-8
      F_CARRIER_01      :    integer   := 0;          -- frequency offset 1, multiple of frequency raster: -2500 - 2500
      F_CARRIER_02      :    integer   := 0;          -- frequency offset 2, multiple of frequency raster: -2500 - 2500
      F_CARRIER_03      :    integer   := 0;          -- frequency offset 3, multiple of frequency raster: -2500 - 2500
      F_CARRIER_04      :    integer   := 0;          -- frequency offset 4, multiple of frequency raster: -2500 - 2500
      F_CARRIER_05      :    integer   := 0;          -- frequency offset 5, multiple of frequency raster: -2500 - 2500
      F_CARRIER_06      :    integer   := 0;          -- frequency offset 6, multiple of frequency raster: -2500 - 2500
      F_CARRIER_07      :    integer   := 0;          -- frequency offset 7, multiple of frequency raster: -2500 - 2500
      F_CARRIER_08      :    integer   := 0;          -- frequency offset 8, multiple of frequency raster: -2500 - 2500
      F_CARRIER_09      :    integer   := 0;          -- frequency offset 9, multiple of frequency raster: -2500 - 2500
      F_CARRIER_10      :    integer   := 0;          -- frequency offset 10, multiple of frequency raster: -2500 - 2500
      F_CARRIER_11      :    integer   := 0;          -- frequency offset 11, multiple of frequency raster: -2500 - 2500
      F_CARRIER_12      :    integer   := 0;          -- frequency offset 12, multiple of frequency raster: -2500 - 2500
      F_CARRIER_13      :    integer   := 0;          -- frequency offset 13, multiple of frequency raster: -2500 - 2500
      F_CARRIER_14      :    integer   := 0;          -- frequency offset 14, multiple of frequency raster: -2500 - 2500
      F_CARRIER_15      :    integer   := 0;          -- frequency offset 15, multiple of frequency raster: -2500 - 2500
      F_CARRIER_16      :    integer   := 0;          -- frequency offset 16, multiple of frequency raster: -2500 - 2500
      F_CARRIER_17      :    integer   := 0;          -- frequency offset 17, multiple of frequency raster: -2500 - 2500
      F_CARRIER_18      :    integer   := 0;          -- frequency offset 18, multiple of frequency raster: -2500 - 2500
      F_CARRIER_19      :    integer   := 0;          -- frequency offset 19, multiple of frequency raster: -2500 - 2500
      F_CARRIER_20      :    integer   := 0;          -- frequency offset 20, multiple of frequency raster: -2500 - 2500
      F_CARRIER_21      :    integer   := 0;          -- frequency offset 21, multiple of frequency raster: -2500 - 2500
      F_CARRIER_22      :    integer   := 0;          -- frequency offset 22, multiple of frequency raster: -2500 - 2500
      F_CARRIER_23      :    integer   := 0;          -- frequency offset 23, multiple of frequency raster: -2500 - 2500
      F_CARRIER_24      :    integer   := 0;          -- frequency offset 24, multiple of frequency raster: -2500 - 2500
      F_CARRIER_25      :    integer   := 0;          -- frequency offset 25, multiple of frequency raster: -2500 - 2500
      F_CARRIER_26      :    integer   := 0;          -- frequency offset 26, multiple of frequency raster: -2500 - 2500
      F_CARRIER_27      :    integer   := 0;          -- frequency offset 27, multiple of frequency raster: -2500 - 2500
      F_CARRIER_28      :    integer   := 0;          -- frequency offset 28, multiple of frequency raster: -2500 - 2500
      F_CARRIER_29      :    integer   := 0;          -- frequency offset 29, multiple of frequency raster: -2500 - 2500
      F_CARRIER_30      :    integer   := 0;          -- frequency offset 30, multiple of frequency raster: -2500 - 2500
      PHI_CARRIER_01    :    integer   := 0;          -- phase offset 1, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_02    :    integer   := 0;          -- phase offset 2, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_03    :    integer   := 0;          -- phase offset 3, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_04    :    integer   := 0;          -- phase offset 4, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_05    :    integer   := 0;          -- phase offset 5, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_06    :    integer   := 0;          -- phase offset 6, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_07    :    integer   := 0;          -- phase offset 7, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_08    :    integer   := 0;          -- phase offset 8, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_09    :    integer   := 0;          -- phase offset 9, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_10    :    integer   := 0;          -- phase offset 10, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_11    :    integer   := 0;          -- phase offset 11, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_12    :    integer   := 0;          -- phase offset 12, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_13    :    integer   := 0;          -- phase offset 13, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_14    :    integer   := 0;          -- phase offset 14, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_15    :    integer   := 0;          -- phase offset 15, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_16    :    integer   := 0;          -- phase offset 16, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_17    :    integer   := 0;          -- phase offset 17, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_18    :    integer   := 0;          -- phase offset 18, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_19    :    integer   := 0;          -- phase offset 19, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_20    :    integer   := 0;          -- phase offset 20, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_21    :    integer   := 0;          -- phase offset 11, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_22    :    integer   := 0;          -- phase offset 12, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_23    :    integer   := 0;          -- phase offset 13, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_24    :    integer   := 0;          -- phase offset 14, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_25    :    integer   := 0;          -- phase offset 15, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_26    :    integer   := 0;          -- phase offset 16, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_27    :    integer   := 0;          -- phase offset 17, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_28    :    integer   := 0;          -- phase offset 18, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_29    :    integer   := 0;          -- phase offset 19, multiple of phase raster: -2500 - 2500
      PHI_CARRIER_30    :    integer   := 0;          -- phase offset 20, multiple of phase raster: -2500 - 2500
      F_PROG            :    integer   := 0;          -- frequency programming capability: 0=none, 1=enabled
      PHI_PROG          :    integer   := 0;          -- phase programming capability: 0=none (no other value permitted)
      GAIN_PROG         :    integer   := 0;          -- gain control programming capability: 0=none, 1=enabled
      N_OVERSAMP        :    integer   := 3;          -- oversampling ratio of clock to RF sample frequency: 1-12
      DIN_WIDTH         :    integer   := 16;         -- input data sample width, bits: 11-17
      DOUT_WIDTH        :    integer   := 16;         -- output data sample width, bits: 11-18
      
      S_AXIS_DIN_TDATA_WIDTH  : integer := 16;         -- aggregated input data bus width, 16-384 in multiples of 8
      M_AXIS_DOUT_TDATA_WIDTH : integer := 16;         -- aggregated output data bus width, 16-384 in multiples of 8
      
      HAS_TDM           :    integer   := 0;          -- data interface format: 0=parallel I/Q inputs, 1=combined TDM I/Q
      HAS_RESET         :    integer   := 0;          -- synchronous reset present: 0=not present, 1=present
      C_OPTIMIZATION    :    integer   := 0;          -- implementation optimization goal: 0=area, 1=speed
      BRAM_USAGE        :    integer   := 1;          -- BRAM usage preference: 1=auto, 2=maximum
      DSP_USAGE         :    integer   := 1;          -- DSP48 usage preference: 0=minimum, 1=auto
      NUM_PREC_W0       :    integer   := 11;         -- unused: 11
      NUM_PREC_W1       :    integer   := 11;         -- unused: 11
      NUM_PREC_W2       :    integer   := 11;         -- unused: 11
      NUM_PREC_W3       :    integer   := 11;         -- unused: 11
      NUM_PREC_W4       :    integer   := 11;         -- unused: 11
      NUM_PREC_W5       :    integer   := 11;         -- unused: 11
      NUM_PREC_W6       :    integer   := 11;         -- unused: 11
      NUM_PREC_W7       :    integer   := 11;         -- unused: 11
      NUM_PREC_W8       :    integer   := 11;         -- unused: 11
      NUM_PREC_W9       :    integer   := 11;         -- unused: 11
      NUM_PREC_F0       :    integer   := 11;         -- unused: 11
      NUM_PREC_F1       :    integer   := 11;         -- unused: 11
      NUM_PREC_F2       :    integer   := 11;         -- unused: 11
      NUM_PREC_F3       :    integer   := 11;         -- unused: 11
      NUM_PREC_F4       :    integer   := 11;         -- unused: 11
      NUM_PREC_F5       :    integer   := 11;         -- unused: 11
      NUM_PREC_F6       :    integer   := 11;         -- unused: 11
      NUM_PREC_F7       :    integer   := 11;         -- unused: 11
      NUM_PREC_F8       :    integer   := 11;         -- unused: 11
      NUM_PREC_F9       :    integer   := 11          -- unused: 11
    );
    port (
      --control signals
      ACLK        : in std_logic := '0';
      ARESETN     : in std_logic := '1';  -- active low datapath reset

      --input handshaking
      S_AXIS_DIN_TVALID : in  std_logic := '0';
      S_AXIS_DIN_TREADY : out std_logic := '0';
      S_AXIS_DIN_TLAST  : in  std_logic := '0';
      S_AXIS_DIN_TDATA  : in  std_logic_vector(S_AXIS_DIN_TDATA_WIDTH-1 downto 0) := (others => '0');

      --output handshaking
      M_AXIS_DOUT_TVALID : out std_logic := '0';
      M_AXIS_DOUT_TREADY : in  std_logic := '0';
      M_AXIS_DOUT_TLAST  : out std_logic := '0';
      M_AXIS_DOUT_TUSER  : out std_logic := '0';
      M_AXIS_DOUT_TDATA  : out std_logic_vector(M_AXIS_DOUT_TDATA_WIDTH-1 downto 0) := (others => '0');

      --programming interface
      SREG_PRESETn : in  std_logic                     := '1';  -- active low APB reset
      SREG_PADDR   : in  std_logic_vector(11 downto 0) := (others => '0');
      SREG_PSEL    : in  std_logic                     := '0';
      SREG_PENABLE : in  std_logic                     := '0';
      SREG_PWRITE  : in  std_logic                     := '0';
      SREG_PWDATA  : in  std_logic_vector(31 downto 0) := (others => '0');
      SREG_PREADY  : out std_logic                     := '0';
      SREG_PRDATA  : out std_logic_vector(31 downto 0) := (others => '0');
      SREG_PSLVERR : out std_logic                     := '0';

      --interrupt interface
      INT_MISSINPUT  : out std_logic := '0';
      INT_ERRPACKET  : out std_logic := '0';
      INT_LOSTOUTPUT : out std_logic := '0';
      INT_DUCDDC     : out std_logic := '0'
      );
  --core_if off
  end component;


end duc_ddc_compiler_v2_0_xst_comp;

