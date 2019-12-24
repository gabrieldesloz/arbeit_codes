------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 4.0
--  \   \        Filename: $RCSfile: dds_compiler_v5_0_lut_ram.vhd,v $
--  /   /        Date Last Modified: $Date: 2010/09/08 11:21:21 $
-- /___/   /\    Date Created: 2006
-- \   \  /  \
--  \___\/\___\
--
-- Device  : All
-- Library : dds_compiler_v5_0
-- Purpose : LUT RAM (Synthesizable model)
-------------------------------------------------------------------------------
--  (c) Copyright 2006-2010 Xilinx, Inc. All rights reserved.
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
use ieee.std_logic_unsigned.all;

library xilinxcorelib;
use xilinxcorelib.pkg_dds_compiler_v5_0.all;
use xilinxcorelib.dds_compiler_v5_0_sim_comps.all;

library xilinxcorelib;
use xilinxcorelib.bip_utils_pkg_v2_0.all;
use xilinxcorelib.bip_usecase_utils_pkg_v2_0.all;

library xilinxcorelib;
use xilinxcorelib.xbip_pipe_v2_0_xst_comp.all;

entity dds_compiler_v5_0_lut_ram is
  GENERIC (
    INIT_VAL     : t_ram_type;
    C_CHANNELS   : integer;
    C_DATA_WIDTH : integer;
    C_ADDR_WIDTH : integer;
    C_DPRA_WIDTH : integer;
    C_HAS_MUTE   : integer := 0;
    C_HAS_CE     : integer := 0;
    C_LATENCY    : integer
    );
  PORT (
    CLK  : in  std_logic := '0';
    WE   : in  std_logic := '0';
    MUTE : in  std_logic := '0';
    CE   : in  std_logic := '0';
    A    : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
    DI   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
    DPRA : in  std_logic_vector(C_DPRA_WIDTH-1 downto 0) := (others => '0');
    DPO  : out std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0')
    );
end dds_compiler_v5_0_lut_ram;



architecture synth of dds_compiler_v5_0_lut_ram is

  type t_local_ram_type is array (0 to 15) of std_logic_vector(C_DATA_WIDTH-1 downto 0);

  function fn_init_ram (
    p_init_val : t_ram_type)
    return t_local_ram_type is
    variable ret : t_local_ram_type;
  begin
    for i in 0 to 15 loop
      ret(i) := INIT_VAL(i)(C_DATA_WIDTH-1 downto 0);
    end loop;  -- i
    return ret;
  end function fn_init_ram;
  -- signals section
  signal the_ram : t_local_ram_type := fn_init_ram(p_init_val => INIT_VAL);
  signal ram_op  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
  signal reg_op  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');

  attribute ram_style : string;
  attribute ram_style of the_ram : signal is "distributed";
  
  
begin

  --start of async RAM inference macro
  process(CLK)
  begin
    if rising_edge(CLK) then
      if (WE = '1') then
        the_ram(conv_integer(A)) <= DI;
      end if;
    end if;
  end process;
  
  ram_op <= the_ram(conv_integer(DPRA));
  --end of async RAM inference macro
  
  i_ram_reg : xbip_pipe_v2_0_xst
    generic map(
      C_LATENCY  => C_LATENCY,
      C_HAS_CE   => C_HAS_CE,
      C_HAS_SCLR => C_HAS_MUTE,
      C_WIDTH    => C_DATA_WIDTH
      )
    port map(
      CLK  => CLK,
      CE   => CE,
      SCLR => MUTE,
      D    => ram_op,
      Q    => reg_op
      );
      
  DPO <= (others=>'0') when (MUTE='1' and C_HAS_MUTE=1 and C_LATENCY=0) else reg_op;

end synth;
