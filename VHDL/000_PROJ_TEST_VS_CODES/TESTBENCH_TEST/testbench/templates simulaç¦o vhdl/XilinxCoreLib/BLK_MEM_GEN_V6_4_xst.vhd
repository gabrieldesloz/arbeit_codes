-------------------------------------------------------------------------------
-- (c) Copyright 2006 - 2011 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
--
-- Filename: blk_mem_gen_v6_4.vhd
--
-- Description:
--   This file is the VHDL behvarial model for the
--       Block Memory Generator Core.
--
-------------------------------------------------------------------------------
-- Author: Xilinx
--
-- History: January 11, 2006 : Initial revision
--          April 07, 2009   : Added new ports and generics for Virtex-6 and 
--                             Spartan-6 support.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  Top-level Entity
-------------------------------------------------------------------------------

LIBRARY STD;
USE STD.TEXTIO.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.blk_mem_gen_v6_4_comp.ALL;

ENTITY blk_mem_gen_v6_4_xst IS
  GENERIC (
  C_FAMILY                  : STRING  := "virtex6";
  C_XDEVICEFAMILY           : STRING  := "virtex6";
  C_ELABORATION_DIR         : STRING  := "";
  C_INTERFACE_TYPE          : INTEGER := 0;
  C_ENABLE_32BIT_ADDRESS    : INTEGER := 0;
  C_AXI_TYPE                : INTEGER := 0;
  C_AXI_SLAVE_TYPE          : INTEGER := 0;
  C_HAS_AXI_ID              : INTEGER := 0;
  C_AXI_ID_WIDTH            : INTEGER := 4;
  C_MEM_TYPE                : INTEGER := 2;
  C_BYTE_SIZE               : INTEGER := 8;
  C_ALGORITHM               : INTEGER := 2;
  C_PRIM_TYPE               : INTEGER := 3;
  C_LOAD_INIT_FILE          : INTEGER := 0;
  C_INIT_FILE_NAME          : STRING  := "";
  C_USE_DEFAULT_DATA        : INTEGER := 0;
  C_DEFAULT_DATA            : STRING  := "";
  C_RST_TYPE                : STRING  := "SYNC";
  C_HAS_RSTA                : INTEGER := 0;
  C_RST_PRIORITY_A          : STRING  := "CE";
  C_RSTRAM_A                : INTEGER := 0;
  C_INITA_VAL               : STRING  := "";
  C_HAS_ENA                 : INTEGER := 1;
  C_HAS_REGCEA              : INTEGER := 0;
  C_USE_BYTE_WEA            : INTEGER := 0;
  C_WEA_WIDTH               : INTEGER := 1;
  C_WRITE_MODE_A            : STRING  := "WRITE_FIRST";
  C_WRITE_WIDTH_A           : INTEGER := 32;
  C_READ_WIDTH_A            : INTEGER := 32;
  C_WRITE_DEPTH_A           : INTEGER := 64;
  C_READ_DEPTH_A            : INTEGER := 64;
  C_ADDRA_WIDTH             : INTEGER := 6;
  C_HAS_RSTB                : INTEGER := 0;
  C_RST_PRIORITY_B          : STRING  := "CE";
  C_RSTRAM_B                : INTEGER := 0;
  C_INITB_VAL               : STRING  := "";
  C_HAS_ENB                 : INTEGER := 1;
  C_HAS_REGCEB              : INTEGER := 0;
  C_USE_BYTE_WEB            : INTEGER := 0;
  C_WEB_WIDTH               : INTEGER := 1;
  C_WRITE_MODE_B            : STRING  := "WRITE_FIRST";
  C_WRITE_WIDTH_B           : INTEGER := 32;
  C_READ_WIDTH_B            : INTEGER := 32;
  C_WRITE_DEPTH_B           : INTEGER := 64;
  C_READ_DEPTH_B            : INTEGER := 64;
  C_ADDRB_WIDTH             : INTEGER := 6;
  C_HAS_MEM_OUTPUT_REGS_A   : INTEGER := 0;
  C_HAS_MEM_OUTPUT_REGS_B   : INTEGER := 0;
  C_HAS_MUX_OUTPUT_REGS_A   : INTEGER := 0;
  C_HAS_MUX_OUTPUT_REGS_B   : INTEGER := 0;
  C_HAS_SOFTECC_INPUT_REGS_A  : INTEGER := 0;
  C_HAS_SOFTECC_OUTPUT_REGS_B : INTEGER := 0;
  C_MUX_PIPELINE_STAGES     : INTEGER := 0;
  C_USE_SOFTECC             : INTEGER := 0;
  C_USE_ECC                 : INTEGER := 0;
  C_HAS_INJECTERR           : INTEGER := 0;
  C_SIM_COLLISION_CHECK     : STRING  := "NONE";
  C_COMMON_CLK              : INTEGER := 1;
  C_DISABLE_WARN_BHV_COLL   : INTEGER := 0;
  C_DISABLE_WARN_BHV_RANGE  : INTEGER := 0
);
  PORT (
  CLKA          : IN  STD_LOGIC;
  RSTA          : IN  STD_LOGIC := '0';
  ENA           : IN  STD_LOGIC := '1';
  REGCEA        : IN  STD_LOGIC := '1';
  WEA           : IN  STD_LOGIC_VECTOR(C_WEA_WIDTH-1 DOWNTO 0)
                      := (OTHERS => '0');
  ADDRA         : IN  STD_LOGIC_VECTOR(C_ADDRA_WIDTH-1 DOWNTO 0);
  DINA          : IN  STD_LOGIC_VECTOR(C_WRITE_WIDTH_A-1 DOWNTO 0)
                      := (OTHERS => '0');
  DOUTA         : OUT STD_LOGIC_VECTOR(C_READ_WIDTH_A-1 DOWNTO 0);
  CLKB          : IN  STD_LOGIC := '0';
  RSTB          : IN  STD_LOGIC := '0';
  ENB           : IN  STD_LOGIC := '1';
  REGCEB        : IN  STD_LOGIC := '1';
  WEB           : IN  STD_LOGIC_VECTOR(C_WEB_WIDTH-1 DOWNTO 0)
                      := (OTHERS => '0');
  ADDRB         : IN  STD_LOGIC_VECTOR(C_ADDRB_WIDTH-1 DOWNTO 0)
                      := (OTHERS => '0');
  DINB          : IN  STD_LOGIC_VECTOR(C_WRITE_WIDTH_B-1 DOWNTO 0)
                      := (OTHERS => '0');
  DOUTB         : OUT STD_LOGIC_VECTOR(C_READ_WIDTH_B-1 DOWNTO 0);
  INJECTSBITERR : IN STD_LOGIC;
  INJECTDBITERR : IN STD_LOGIC;
  SBITERR       : OUT STD_LOGIC;
  DBITERR       : OUT STD_LOGIC;
  RDADDRECC     : OUT STD_LOGIC_VECTOR(C_ADDRB_WIDTH-1 DOWNTO 0);
  -- AXI BMG Input and Output Port Declarations

    -- AXI Global Signals
  S_ACLK                         : IN  STD_LOGIC := '0';
  S_ARESETN                      : IN  STD_LOGIC := '0'; 

  -- AXI Full/Lite Slave Write (write side)
  S_AXI_AWID                     : IN  STD_LOGIC_VECTOR(C_AXI_ID_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_AWADDR                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  S_AXI_AWLEN                    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  S_AXI_AWSIZE                   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
  S_AXI_AWBURST                  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_AWVALID                  : IN  STD_LOGIC := '0';
  S_AXI_AWREADY                  : OUT STD_LOGIC;
  S_AXI_WDATA                    : IN  STD_LOGIC_VECTOR(C_WRITE_WIDTH_A-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_WSTRB                    : IN  STD_LOGIC_VECTOR(C_WEA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_WLAST                    : IN  STD_LOGIC := '0';
  S_AXI_WVALID                   : IN  STD_LOGIC := '0';
  S_AXI_WREADY                   : OUT STD_LOGIC;
  S_AXI_BID                      : OUT  STD_LOGIC_VECTOR(C_AXI_ID_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_BRESP                    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
  S_AXI_BVALID                   : OUT STD_LOGIC;
  S_AXI_BREADY                   : IN  STD_LOGIC := '0';

  -- AXI Full/Lite Slave Read (Write side)
  S_AXI_ARID                     : IN  STD_LOGIC_VECTOR(C_AXI_ID_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_ARADDR                   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  S_AXI_ARLEN                    : IN  STD_LOGIC_VECTOR(8-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_ARSIZE                   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
  S_AXI_ARBURST                  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_ARVALID                  : IN  STD_LOGIC := '0';
  S_AXI_ARREADY                  : OUT STD_LOGIC;
  S_AXI_RID                      : OUT  STD_LOGIC_VECTOR(C_AXI_ID_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  S_AXI_RDATA                    : OUT STD_LOGIC_VECTOR(C_WRITE_WIDTH_B-1 DOWNTO 0); 
  S_AXI_RRESP                    : OUT STD_LOGIC_VECTOR(2-1 DOWNTO 0);
  S_AXI_RLAST                    : OUT STD_LOGIC;
  S_AXI_RVALID                   : OUT STD_LOGIC;
  S_AXI_RREADY                   : IN  STD_LOGIC := '0';

  -- AXI Full/Lite Sideband Signals
  S_AXI_INJECTSBITERR              : IN  STD_LOGIC := '0';
  S_AXI_INJECTDBITERR              : IN  STD_LOGIC := '0';
  S_AXI_SBITERR                    : OUT STD_LOGIC;
  S_AXI_DBITERR                    : OUT STD_LOGIC;
  S_AXI_RDADDRECC                  : OUT STD_LOGIC_VECTOR(C_ADDRB_WIDTH-1 DOWNTO 0)

);
END blk_mem_gen_v6_4_xst;

-- Note: C_ELABORATION_DIR parameter is only used in synthesis 
-- (and doesn't get mentioned in the instantiation template Coregen generates). 
-- This wrapper file has to work both in simulation and synthesis. So, this 
-- parameter exists. It is not used by the behavioral model 
-- (BLK_MEM_GEN_v6_4.vhd)

-- Note: C_CORENAME parameter is hard-coded to "blk_mem_gen_v6_4" and it is
-- passed to blk_mem_gen_v6_4.vhd to be used to print warning messages.
-- It is not present in the instantiation template coregen generates

ARCHITECTURE behavioral OF blk_mem_gen_v6_4_xst IS

  -----------------------------------------------------------------------------
  -- FUNCTION: toLowerCaseChar
  -- Returns the lower case form of char if char is an upper case letter.
  -- Otherwise char is returned.
  -----------------------------------------------------------------------------
  FUNCTION toLowerCaseChar(
    char : character )
  RETURN character IS
  BEGIN
    -- If char is not an upper case letter then return char
    IF char<'A' OR char>'Z' THEN
      RETURN char;
    END IF;
    -- Otherwise map char to its corresponding lower case character and
    -- RETURN that
    CASE char IS
      WHEN 'A' => RETURN 'a';
      WHEN 'B' => RETURN 'b';
      WHEN 'C' => RETURN 'c';
      WHEN 'D' => RETURN 'd';
      WHEN 'E' => RETURN 'e';
      WHEN 'F' => RETURN 'f';
      WHEN 'G' => RETURN 'g';
      WHEN 'H' => RETURN 'h';
      WHEN 'I' => RETURN 'i';
      WHEN 'J' => RETURN 'j';
      WHEN 'K' => RETURN 'k';
      WHEN 'L' => RETURN 'l';
      WHEN 'M' => RETURN 'm';
      WHEN 'N' => RETURN 'n';
      WHEN 'O' => RETURN 'o';
      WHEN 'P' => RETURN 'p';
      WHEN 'Q' => RETURN 'q';
      WHEN 'R' => RETURN 'r';
      WHEN 'S' => RETURN 's';
      WHEN 'T' => RETURN 't';
      WHEN 'U' => RETURN 'u';
      WHEN 'V' => RETURN 'v';
      WHEN 'W' => RETURN 'w';
      WHEN 'X' => RETURN 'x';
      WHEN 'Y' => RETURN 'y';
      WHEN 'Z' => RETURN 'z';
      WHEN OTHERS => RETURN char;
    END CASE;
  END toLowerCaseChar;

  -- Returns true if case insensitive string comparison determines that
  -- str1 and str2 are equal
  FUNCTION equalIgnoreCase(
    str1 : STRING;
    str2 : STRING )
  RETURN BOOLEAN IS
    CONSTANT len1 : INTEGER := str1'length;
    CONSTANT len2 : INTEGER := str2'length;
    VARIABLE equal : BOOLEAN := TRUE;
  BEGIN
    IF NOT (len1=len2) THEN
      equal := FALSE;
    ELSE
      FOR i IN str2'left TO str1'right LOOP
        IF NOT (toLowerCaseChar(str1(i)) = toLowerCaseChar(str2(i))) THEN
          equal := FALSE;
        END IF;
      END LOOP;
    END IF;

    RETURN equal;
  END equalIgnoreCase;

  ------------------------------------------------------------------------------
  -- FUNCTION: if_then_else
  -- This function is used to implement an IF..THEN when such a statement is not
  --  allowed.
  ------------------------------------------------------------------------------
  FUNCTION if_then_else (
    condition : BOOLEAN;
    true_case : STRING;
    false_case : STRING)
  RETURN STRING IS
  BEGIN
    IF NOT condition THEN
      RETURN false_case;
    ELSE
      RETURN true_case;
    END IF;
  END if_then_else;


BEGIN -- Architecture

  behv_mem:  blk_mem_gen_v6_4
  GENERIC MAP(
    C_CORENAME                => "blk_mem_gen_v6_4",
    C_FAMILY                    => if_then_else(equalIgnoreCase(C_FAMILY,"VIRTEX6L"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"VIRTEX7"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"KINTEX7"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"ARTIX7"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"ARTIX7L"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"AARTIX7"),"virtex6",if_then_else(equalIgnoreCase(C_FAMILY,"SPARTAN6L"),"spartan6",if_then_else(equalIgnoreCase(C_FAMILY,"ASPARTAN6"),"spartan6",if_then_else(equalIgnoreCase(C_FAMILY,"ASPARTAN3ADSP"),"spartan3adsp",if_then_else(equalIgnoreCase(C_FAMILY,"ASPARTAN3A"),"spartan3a",C_FAMILY)))))))))),
    C_XDEVICEFAMILY           => C_XDEVICEFAMILY,                 
    C_INTERFACE_TYPE          => C_INTERFACE_TYPE,
    C_ENABLE_32BIT_ADDRESS    => C_ENABLE_32BIT_ADDRESS,
    C_AXI_TYPE                => C_AXI_TYPE,
    C_AXI_SLAVE_TYPE          => C_AXI_SLAVE_TYPE,
    C_HAS_AXI_ID              => C_HAS_AXI_ID,
    C_AXI_ID_WIDTH            => C_AXI_ID_WIDTH,
    C_MEM_TYPE                => C_MEM_TYPE,               
    C_BYTE_SIZE               => C_BYTE_SIZE,              
    C_ALGORITHM               => C_ALGORITHM,              
    C_PRIM_TYPE               => C_PRIM_TYPE,              
    C_LOAD_INIT_FILE          => C_LOAD_INIT_FILE,         
    C_INIT_FILE_NAME          => C_INIT_FILE_NAME,         
    C_USE_DEFAULT_DATA        => C_USE_DEFAULT_DATA,       
    C_DEFAULT_DATA            => C_DEFAULT_DATA,           
    C_RST_TYPE                => C_RST_TYPE,
    C_HAS_RSTA                => C_HAS_RSTA,
    C_RST_PRIORITY_A          => C_RST_PRIORITY_A,
    C_RSTRAM_A                => C_RSTRAM_A,
    C_INITA_VAL               => C_INITA_VAL,
    C_HAS_ENA                 => C_HAS_ENA,                
    C_HAS_REGCEA              => C_HAS_REGCEA,             
    C_USE_BYTE_WEA            => C_USE_BYTE_WEA,           
    C_WEA_WIDTH               => C_WEA_WIDTH,              
    C_WRITE_MODE_A            => C_WRITE_MODE_A,           
    C_WRITE_WIDTH_A           => C_WRITE_WIDTH_A,          
    C_READ_WIDTH_A            => C_READ_WIDTH_A,           
    C_WRITE_DEPTH_A           => C_WRITE_DEPTH_A,          
    C_READ_DEPTH_A            => C_READ_DEPTH_A,           
    C_ADDRA_WIDTH             => C_ADDRA_WIDTH,            
    C_HAS_RSTB                => C_HAS_RSTB,
    C_RST_PRIORITY_B          => C_RST_PRIORITY_B,
    C_RSTRAM_B                => C_RSTRAM_B,
    C_INITB_VAL               => C_INITB_VAL,
    C_HAS_ENB                 => C_HAS_ENB,
    C_HAS_REGCEB              => C_HAS_REGCEB,
    C_USE_BYTE_WEB            => C_USE_BYTE_WEB,
    C_WEB_WIDTH               => C_WEB_WIDTH,
    C_WRITE_MODE_B            => C_WRITE_MODE_B,
    C_WRITE_WIDTH_B           => C_WRITE_WIDTH_B,
    C_READ_WIDTH_B            => C_READ_WIDTH_B,
    C_WRITE_DEPTH_B           => C_WRITE_DEPTH_B,
    C_READ_DEPTH_B            => C_READ_DEPTH_B,
    C_ADDRB_WIDTH             => C_ADDRB_WIDTH,
    C_HAS_MEM_OUTPUT_REGS_A   => C_HAS_MEM_OUTPUT_REGS_A,
    C_HAS_MEM_OUTPUT_REGS_B   => C_HAS_MEM_OUTPUT_REGS_B,
    C_HAS_MUX_OUTPUT_REGS_A   => C_HAS_MUX_OUTPUT_REGS_A,
    C_HAS_MUX_OUTPUT_REGS_B   => C_HAS_MUX_OUTPUT_REGS_B,
    C_HAS_SOFTECC_INPUT_REGS_A  => C_HAS_SOFTECC_INPUT_REGS_A,
    C_HAS_SOFTECC_OUTPUT_REGS_B => C_HAS_SOFTECC_OUTPUT_REGS_B,
    C_MUX_PIPELINE_STAGES     => C_MUX_PIPELINE_STAGES,
    C_USE_SOFTECC             => C_USE_SOFTECC,
    C_USE_ECC                 => C_USE_ECC,
    C_HAS_INJECTERR           => C_HAS_INJECTERR,
    C_SIM_COLLISION_CHECK     => C_SIM_COLLISION_CHECK,
    C_COMMON_CLK              => C_COMMON_CLK,
    C_DISABLE_WARN_BHV_COLL   => C_DISABLE_WARN_BHV_COLL,
    C_DISABLE_WARN_BHV_RANGE  => C_DISABLE_WARN_BHV_RANGE
  )
  PORT MAP(
    CLKA          => CLKA,
    RSTA          => RSTA, 
    ENA           => ENA,
    REGCEA        => REGCEA,
    WEA           => WEA,           
    ADDRA         => ADDRA,
    DINA          => DINA,
    DOUTA         => DOUTA,
    CLKB          => CLKB, 
    RSTB          => RSTB, 
    ENB           => ENB,  
    REGCEB        => REGCEB,
    WEB           => WEB,            
    ADDRB         => ADDRB,         
    DINB          => DINB,          
    DOUTB         => DOUTB,
    INJECTSBITERR => INJECTSBITERR,
    INJECTDBITERR => INJECTDBITERR,
    SBITERR       => SBITERR,
    DBITERR       => DBITERR,
    RDADDRECC     => RDADDRECC,
  -- AXI BMG Input and Output Port Declarations

    -- AXI Global Signals
    S_ACLK                         => S_ACLK,
    S_ARESETN                      => S_ARESETN, 
 
    -- AXI Full/Lite Slave Write (write side)
    S_AXI_AWID                     => S_AXI_AWID,
    S_AXI_AWADDR                   => S_AXI_AWADDR,
    S_AXI_AWLEN                    => S_AXI_AWLEN,
    S_AXI_AWSIZE                   => S_AXI_AWSIZE,
    S_AXI_AWBURST                  => S_AXI_AWBURST,
    S_AXI_AWVALID                  => S_AXI_AWVALID,
    S_AXI_AWREADY                  => S_AXI_AWREADY,
    S_AXI_WDATA                    => S_AXI_WDATA,
    S_AXI_WSTRB                    => S_AXI_WSTRB,
    S_AXI_WLAST                    => S_AXI_WLAST,
    S_AXI_WVALID                   => S_AXI_WVALID,
    S_AXI_WREADY                   => S_AXI_WREADY,
    S_AXI_BID                      => S_AXI_BID,
    S_AXI_BRESP                    => S_AXI_BRESP,
    S_AXI_BVALID                   => S_AXI_BVALID,
    S_AXI_BREADY                   => S_AXI_BREADY,
 
    -- AXI Full/Lite Slave Read (Write side)
    S_AXI_ARID                     => S_AXI_ARID,
    S_AXI_ARADDR                   => S_AXI_ARADDR,
    S_AXI_ARLEN                    => S_AXI_ARLEN,
    S_AXI_ARSIZE                   => S_AXI_ARSIZE,
    S_AXI_ARBURST                  => S_AXI_ARBURST,
    S_AXI_ARVALID                  => S_AXI_ARVALID,
    S_AXI_ARREADY                  => S_AXI_ARREADY,
    S_AXI_RID                      => S_AXI_RID,
    S_AXI_RDATA                    => S_AXI_RDATA,
    S_AXI_RRESP                    => S_AXI_RRESP,
    S_AXI_RLAST                    => S_AXI_RLAST,
    S_AXI_RVALID                   => S_AXI_RVALID,
    S_AXI_RREADY                   => S_AXI_RREADY,
 
    -- AXI Full/Lite Sideband Signals
    S_AXI_INJECTSBITERR            => S_AXI_INJECTSBITERR,
    S_AXI_INJECTDBITERR            => S_AXI_INJECTDBITERR,
    S_AXI_SBITERR                  => S_AXI_SBITERR,
    S_AXI_DBITERR                  => S_AXI_DBITERR,
    S_AXI_RDADDRECC                => S_AXI_RDADDRECC

  );
 END behavioral;

