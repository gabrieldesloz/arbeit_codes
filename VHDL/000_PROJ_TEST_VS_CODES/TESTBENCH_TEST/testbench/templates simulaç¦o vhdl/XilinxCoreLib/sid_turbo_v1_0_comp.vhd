--------------------------------------------------------------------------------
-- Copyright 2001 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
-- $Id: sid_turbo_v1_0_comp.vhd,v 1.13 2008/09/08 20:09:29 akennedy Exp $
--
-- Description: Component statement for Interleaver/Deinterleaver
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE sid_turbo_v1_0_comp IS

-- c_family_int constants
CONSTANT SID_TURBO_V1_0_COMP_c_virtex        : INTEGER := 0;
CONSTANT SID_TURBO_V1_0_COMP_c_virtex2       : INTEGER := 1;

-- c_mode constants
CONSTANT SID_TURBO_V1_0_COMP_c_interleaver   : INTEGER := 0;
CONSTANT SID_TURBO_V1_0_COMP_c_iaddr_gen     : INTEGER := 1;

-- c_memstyle constants
CONSTANT SID_TURBO_V1_0_COMP_c_distmem       : INTEGER := 0;
CONSTANT SID_TURBO_V1_0_COMP_c_blockmem      : INTEGER := 1;
CONSTANT SID_TURBO_V1_0_COMP_c_automatic     : INTEGER := 2;
-- c_pipe_level constants
CONSTANT SID_TURBO_V1_0_COMP_c_minimum       : INTEGER := 0;
CONSTANT SID_TURBO_V1_0_COMP_c_maximum       : INTEGER := 1;



--------------------------------------------------------------------------------
-- Component declaration
--------------------------------------------------------------------------------
COMPONENT sid_turbo_v1_0
GENERIC (
  c_family_int              : INTEGER := SID_TURBO_V1_0_COMP_c_virtex;
  c_mem_init_prefix         : STRING  := "sid1";
  c_mode                    : INTEGER := SID_TURBO_V1_0_COMP_c_interleaver;
  c_symbol_width            : INTEGER := 1;
  -- implementation GENERICs
  c_has_external_ram        : INTEGER := 0;
  c_memstyle                : INTEGER := SID_TURBO_V1_0_COMP_c_blockmem;
  c_pipe_level              : INTEGER := SID_TURBO_V1_0_COMP_c_minimum;
  c_simultaneous_blocks     : INTEGER := 1;
  c_continuous_mode         : INTEGER := 0;
  c_has_frame_buffer        : INTEGER := 0;
  c_enable_rlocs            : INTEGER := 1;
  -- optional pin GENERICs
  c_has_ce                  : INTEGER := 0;
  c_has_nd                  : INTEGER := 0;
  c_has_sclr                : INTEGER := 0;
  c_has_aclr                : INTEGER := 0;
  c_has_rdy                 : INTEGER := 0;
  c_has_rffd                : INTEGER := 0;
  c_has_rfd                 : INTEGER := 0;
  c_has_block_size_valid    : INTEGER := 0;
  c_has_block_start         : INTEGER := 0;
  c_has_block_end           : INTEGER := 0);
PORT (
  -- mandatory input pins
  clk              : IN STD_LOGIC := '0';
  fd               : IN STD_LOGIC := '0';
  block_size_sel   : IN STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS=>'0');
  -- optional input pins
  din              : IN STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0);
  ce               : IN STD_LOGIC := '1';
  nd               : IN STD_LOGIC := '1';
  sclr             : IN STD_LOGIC := '0';
  aclr             : IN STD_LOGIC := '0';
  -- optional output pins
  block_size_valid : OUT STD_LOGIC;
  rfd              : OUT STD_LOGIC;
  rffd             : OUT STD_LOGIC;
  iaddr            : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
  dout             : OUT STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0);
  frame_buffer_dout: OUT STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0);
  rdy              : OUT STD_LOGIC;
  block_start      : OUT STD_LOGIC;
  block_end        : OUT STD_LOGIC;
  --IF c_external_ram=1 the following ports will be enabled: 
  ram_we           : OUT STD_LOGIC; 
  ram_din          : OUT STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0);
  ram_addra        : OUT STD_LOGIC_VECTOR(14 DOWNTO 0); --interleaver address 
  ram_douta        : IN STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0):= (OTHERS => '0'); -- interleaver ext ram dout 
  --IF c_external_ram=1 AND c_has_frame_buffer=1, the following ports will be enabled: 
  ram_addrb        : OUT STD_LOGIC_VECTOR(14 DOWNTO 0); --frame buffer address 
  ram_doutb        : IN STD_LOGIC_VECTOR((c_symbol_width - 1) DOWNTO 0):= (OTHERS => '0')); -- frame buffer dout 
END COMPONENT; -- sid_turbo_v1_0

-- The following tells XST that SID_turbo_v1_0 is a black box which 
-- should be generated by the command given by the value of this attribute.
-- Note the fully qualified SIM (JAVA class) name that forms the basis of the
-- core.
ATTRIBUTE box_type : STRING; 
ATTRIBUTE box_type OF SID_turbo_v1_0 : COMPONENT IS "black_box"; 
ATTRIBUTE GENERATOR_DEFAULT : STRING; 
ATTRIBUTE GENERATOR_DEFAULT OF SID_turbo_v1_0 : COMPONENT IS 
                                 "generatecore com.xilinx.ip.sid_turbo_v1_0.sid_turbo_v1_0";

END sid_turbo_v1_0_comp ;


