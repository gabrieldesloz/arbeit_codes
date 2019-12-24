-------------------------------------------------------------------------------------------
--  (c) Copyright 2007-2010 Xilinx, Inc. All rights reserved.
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
-------------------------------------------------------------------------------------------
-- Unit     : pipeline_layby_block.vhd
-- Function : 
-- 2 deep fifo to allow register to be inserted between WREADYs (CTS and RFD) for pipelined block
-- Author   :  Xilinx
--------------------------------------------------------------------------------
-- Description: Very small fifo is used to prevent data being dropped when CTS changes and there is a register between
-- CTS and RFD. This block drives the RFD from a registered process bassed on the nearly full of the fifo rather than
-- from the CTS directly. used at the input and output of the LLR module to aid meeting timing when combining modules.
-- 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity axi_utils_v1_1_skid_buffer is
  generic (
    c_has_ce    : integer := 0;
    c_has_reset : integer := 0;
    c_width     : integer := 6
    );
  port (
    aclk      : in  std_logic                             := '0';
    ce        : in  std_logic                             := '0';
    areset    : in  std_logic                             := '0';
    rfd       : out std_logic                             := '0';
    din       : in  std_logic_vector(c_width -1 downto 0) := (others => '0');
    valid_in  : in  std_logic                             := '0';
    cts       : in  std_logic                             := '0';
    dout      : out std_logic_vector(c_width -1 downto 0) := (others => '0');
    valid_out : out std_logic                             := '0'
    );

end axi_utils_v1_1_skid_buffer;

architecture synth of axi_utils_v1_1_skid_buffer is
  signal data_reg0   : std_logic_vector(c_width -1 downto 0) := (others => '0');
  signal data_reg1   : std_logic_vector(c_width -1 downto 0) := (others => '0');
  signal valid_reg0  : std_logic                             := '0';
  signal valid_reg1  : std_logic                             := '0';
  signal full        : std_logic                             := '0';
  signal not_empty   : std_logic                             := '0';
  signal wr_en       : std_logic                             := '0';
  signal rd_en       : std_logic                             := '0';
  signal out_pointer : std_logic                             := '0';
begin
  rfd       <= not full;
  full      <= valid_reg1;              
  not_empty <= valid_reg0;
  wr_en     <= not full and valid_in;
  rd_en     <= cts and not_empty;

  i_data_reg0 : process(aclk)
  begin
    if rising_edge(aclk) then
      if ce = '1' then
        if areset = '1' then
          data_reg0   <= (others => '0');
          data_reg1   <= (others => '0');
        else
          if wr_en = '1' then
            data_reg0 <= din;
            data_reg1 <= data_reg0;
          end if;
        end if;
      end if;
    end if;
  end process i_data_reg0;

  i_output_pointer : process(aclk)
  begin
    if rising_edge(aclk) then
      if ce = '1' then
        if areset = '1' then
          out_pointer   <= '0';
          valid_reg0    <= '0';
          valid_reg1    <= '0';
        else
          if wr_en = '1' and rd_en = '0' and not_empty = '1' then
            out_pointer <= '1';
          elsif rd_en = '1' and wr_en = '0' then
            out_pointer <= '0';
          end if;

          if wr_en = '1' and rd_en = '0' then
            valid_reg0   <= valid_in;
            valid_reg1   <= valid_reg0;
          elsif rd_en = '1' and wr_en = '0' then
            valid_reg1   <= '0';
            if full = '0' then
              valid_reg0 <= '0';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process i_output_pointer;

  dout      <= data_reg0  when out_pointer = '0' else data_reg1;
  valid_out <= valid_reg0 when out_pointer = '0' else valid_reg1;

end synth;
