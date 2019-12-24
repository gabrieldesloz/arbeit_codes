------------------------------------------------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/M/axi_utils_v1_0/simulation/glb_srl_fifo_v1_0.vhd,v 1.4 2011/03/08 16:20:31 gordono Exp $
------------------------------------------------------------------------------------------------------------------------
--
--  (c) Copyright 2009 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------------------------------------------------------
--
--  Title: glb_srl_fifo_v1_0.vhd
--  Author: David Andrews
--  Date  : August 2008
--  Description: SRL based FIFO
--
--  Simple and fast SRL FIFO with the following features:
--    o Very small overhead over a single register [uses ceil(log2(DEPTH+1)) extra FDs for control]
--    o Optional underflow protection (HAS_UVPROT)
--      Gates rd_enable with not empty to prevent reads when FIFO is empty
--    o Optional Interface-X compatible output (HAS_IFX)
--      User should drive rd_enable with (not valid or ready)
--      Uses clock enable on the post-SRL FD to hold data until valid and ready asserted
--      Note that FIFO also requires underflow protection for this to work
--    o Optional programmable almost full/empty flags, with potential hysteresis
--      FIFO also contains negated version of the same outputs.
--      These output are sometimes more useful (e.g. not_afull can drive a CE directly without the need for inverter)
--    o The FIFO does not have a count output
--      Instead, the FIFO has an add output (SRL address) - at all times add=count-1
--
--  Performance:
--    The FIFO will generally run at full speed when DEPTH<=16, but note the following:
--    o Use of the empty/add outputs does not increase resource usage (they are uses internally by the FIFO so are always present)
--    o Use of the full/afull/not_afull/aempty/not_aempty/rd_avail outputs increases resource usage
--    o The HAS_IFX mode uses a gated clock enable (e.g. LUT feeding CE)
--        If map does a reasonable job, this is generally acceptable.
--        If map does a bad job...
--    o afull/not_afull logic is disabled when AFULL_THRESH1=AFULL_THRESH0=0
--    o aempty/not_aempty logic is disabled when AEMPTY_THRESH1=AEMPTY_THRESH0=0
--    o afull/not_afull logic is minimised when AFULL_THRESH1=AFULL_THRESH0 (i.e. no hysteresis)
--    o aempty/not_aempty logic is mninimised when AEMPTY_THRESH1=AEMPTY_THRESH0 (i.e. no hysteresis)
--
------------------------------------------------------------------------------------------------------------------------
--  SRL FIFO: DEPTH=4, HAS_UVPROT=false, HAS_IFX=false, AFULL_THRESH0=AFULL_THRESH1=2, AEMPTY_THRESH0=AEMPTY_THRESH1=1
--              _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
--  aclk       | |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_
--
--                  _______________                             _______________
--  wr_enable  ____|               |___________________________|               |___________
--                  ___ ___ ___ ___                             ___ ___ ___ ___
--  wr_data    XXXX|a__|b__|c__|d__|XXXXXXXXXXXXXXXXXXXXXXXXXXX|A__|B__|C__|D__|XXXXXXXXXXX
--
--                                      _______________             _______________
--  rd_enable  ________________________|               |___________|               |_______
--                                          _______________             _______________
--  rd_valid   ____________________________|               |___________|               |___
--                          _______________________________             _______________
--  rd_avail   ____________|                               |___________|               |___
--                          ___________________ ___ ___ ___             ___ ___ ___ ___
--  rd_data    XXXXXXXXXXXX|a__________________|b__|c__|d__|XXXXXXXXXXX|A__|B__|C__|D__|XXX
--
--                                  _______
--  full       ____________________|       |_______________________________________________
--             ________                                 ___________                 _______
--  empty              |_______________________________|           |_______________|
--                              ___________________
--  afull      ________________|                   |_______________________________________
--             ____________                             ___________________________________
--  aempty                 |___________________________|
--             ________ ___ ___ ___ _______ ___ ___ ___ ___________ _______________ _______
--  add        _-1_____|0__|1__|2__|3______|2__|1__|0__|-1_________|0______________|-1_____
--
--                                                     http://rann:1337/mywave.cgi/iFBdL1YE
------------------------------------------------------------------------------------------------------------------------
--  SRL FIFO: DEPTH=4, HAS_UVPROT=true, HAS_IFX=true, AFULL_THRESH0=AFULL_THRESH1=2, AEMPTY_THRESH0=AEMPTY_THRESH1=1
--              _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
--  aclk       | |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_
--
--                  _______________                             _______________
--  wr_enable  ____|               |___________________________|               |___________
--                  ___ ___ ___ ___                             ___ ___ ___ ___
--  wr_data    XXXX|a__|b__|c__|d__|XXXXXXXXXXXXXXXXXXXXXXXXXXX|A__|B__|C__|D__|XXXXXXXXXXX
--
--                                          ___________     _______________________________
--  ifx_ready  ____________________________|           |___|
--             ____________                 ___________     _______________________________
--  rd_enable              |_______________|           |___|
--                          ___________________________________         _______________
--  rd_valid   ____________|                                   |_______|               |___
--                          ___________________________________         _______________
--  rd_avail   ____________|                                   |_______|               |___
--                          ___________________ ___ ___ _______         ___ ___ ___ ___
--  rd_data    XXXXXXXXXXXX|a__________________|b__|c__|d______|XXXXXXX|A__|B__|C__|D__|XXX
--
--                                                     http://rann:1337/mywave.cgi/mrIfuKeM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xilinxcorelib;
use xilinxcorelib.global_util_pkg_v1_0.all;

entity glb_srl_fifo_v1_0 is

  generic (
    WIDTH : positive := 32;             --Width of FIFO in bits
    DEPTH : positive := 16;  --Depth of FIFO in words (must be a power of 2)

    HAS_UVPROT : boolean := false;  --True if FIFO has underflow protection (i.e. rd_enable to an empty FIFO is safe)
    HAS_IFX    : boolean := false;  --True if FIFO has Interface-X compatible output (note that this also sets HAS_UVPROT=true)

    AFULL_THRESH1 : natural := 0;       --Almost full assertion threshold
                                        --  afull asserted as count goes from AFULL_THRESH1 to AFULL_THRESH1+1
    AFULL_THRESH0 : natural := 0;       --Almost full deassertion threshold
                                        --  afull deasserted as count goes from AFULL_THRESH0 to AFULL_THRESH0-1
                                        --If AFULL_THRESH1 and AFULL_THRESH0 are both zero, afull/not_afull are disabled

    AEMPTY_THRESH0 : natural := 0;      --Almost empty deassertion threshold
                                        --  aempty deasserted as count goes from AEMPTY_THRESH0 to AEMPTY_THRESH0+1
    AEMPTY_THRESH1 : natural := 0;      --Almost empty assertion threshold
                                        --  aempty asserted as count goes from AEMPTY_THRESH1 to AEMPTY_THRESH1-1
                                        --If AEMPTY_THRESH1 and AEMPTY_THRESH0 are both zero, aempty/not_aempty are disabled

    HAS_HIERARCHY : boolean := true  --True to apply KEEP_HIERARCHY="soft" to FIFO, false to apply KEEP_HIERARCHY="no"
    );
  port (
    aclk   : in std_logic;
    areset : in std_logic;

    --Write interface
    wr_enable : in std_logic;                           --True to write data
    wr_data   : in std_logic_vector(WIDTH-1 downto 0);  --Write data

    --Read interface
    rd_enable : in  std_logic;          --True to read data
    rd_avail  : out std_logic;          --True when rd_data is available
    rd_valid  : out std_logic;  --True when rd_data is available and valid (i.e. has been read)
    rd_data   : out std_logic_vector(WIDTH-1 downto 0);  --Read data (only valid when rd_avail asserted)

    --FIFO status
    full       : out std_logic;         --FIFO full
    not_full   : out std_logic;  --FIFO not full (logical inverse of full)
    empty      : out std_logic;         --FIFO empty
    not_empty  : out std_logic;  --FIFO not empty (logical inverse of empty)
    afull      : out std_logic;         --FIFO almost full
    not_afull  : out std_logic;  --FIFO not almost full (logical inverse of afull)
    aempty     : out std_logic;         --FIFO almost empty
    not_aempty : out std_logic;  --FIFO not almost empty (logical inverse of aempty)
    add        : out signed(GLB_log2(DEPTH+1)-1 downto 0)  --Read address of SRL (this is always FIFO count-1)
    );

end entity;

------------------------------------------------------------------------------------------------------------------------
architecture xilinx of glb_srl_fifo_v1_0 is

  constant HAS_AFULL  : boolean := (AFULL_THRESH0 > 0 and AFULL_THRESH1 > 0);
  constant HAS_AEMPTY : boolean := (AEMPTY_THRESH0 > 0 and AEMPTY_THRESH1 > 0);

  --Types
  subtype Word is std_logic_vector(WIDTH-1 downto 0);
  type WordArray is array (natural range <>) of Word;

  --Gated read/write signals
  signal rd_en : std_logic;
  signal wr_en : std_logic;

  --FIFO data
  signal fifo_1 : WordArray(0 to DEPTH-1) := (others => (others => '0'));

  --FIFO address/count
  signal add_1 : signed(add'range) := (others => '1');

  --Full/empty flags
  signal full_1       : std_logic := '0';
  signal not_full_1   : std_logic := '1';
  signal empty_1      : std_logic := '1';  --This is an alias of MSB of add_1
  signal not_empty_1  : std_logic := '0';
  signal afull_1      : std_logic := '0';
  signal aempty_1     : std_logic := '1';
  signal not_afull_1  : std_logic := '1';
  signal not_aempty_1 : std_logic := '0';

  --Data avail/valid flags
  signal rd_avail_2 : std_logic := '0';
  signal rd_valid_2 : std_logic := '0';

  --FIFO read data
  signal fifo_2 : Word := (others => '0');

  ------------------------------------------------------------------------------------------------------------------------
  --Compare FIFO count with THRESH (i.e. compare add with THRESH-1)
  --  Note that we actually only compare the LSBs of add and ignore the sign
  --  This makes the compare ambiguous between add=-1 and add=DEPTH-1
  --  This ambiguity must be resolved by the caller
  function eq(THRESH : integer; add : signed) return boolean is
    constant T : signed(add'range) := to_signed(THRESH-1, add'length);
  begin
    assert THRESH >= 0 and THRESH <= DEPTH
                                  report "ERROR:THRESH must be in range [0,DEPTH]"
                                  severity failure;
    return (add(add'left-1 downto 0) = T(add'left-1 downto 0));
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --We want carry chains for adders
  attribute use_carry_chain of add_1 : signal is "yes";

  --Don't replicate high fan-in registers
  attribute register_duplication of add_1        : signal is "no";
  attribute register_duplication of full_1       : signal is "no";
  attribute register_duplication of not_full_1   : signal is "no";
  attribute register_duplication of not_empty_1  : signal is "no";
  attribute register_duplication of afull_1      : signal is "no";
  attribute register_duplication of aempty_1     : signal is "no";
  attribute register_duplication of not_afull_1  : signal is "no";
  attribute register_duplication of not_aempty_1 : signal is "no";

  --Stop XST trying to use CE on these signals
  attribute use_clock_enable of add_1        : signal is "no";
  attribute use_clock_enable of full_1       : signal is "no";
  attribute use_clock_enable of not_full_1   : signal is "no";
  attribute use_clock_enable of not_empty_1  : signal is "no";
  attribute use_clock_enable of afull_1      : signal is "no";
  attribute use_clock_enable of aempty_1     : signal is "no";
  attribute use_clock_enable of not_afull_1  : signal is "no";
  attribute use_clock_enable of not_aempty_1 : signal is "no";
  attribute use_clock_enable of rd_avail_2   : signal is "no";
  attribute use_clock_enable of rd_valid_2   : signal is "no";

  --Stop XST trying to use SET on these signals
  attribute use_sync_set of not_empty_1  : signal is "no";
  attribute use_sync_set of full_1       : signal is "no";
  attribute use_sync_set of afull_1      : signal is "no";
  attribute use_sync_set of not_aempty_1 : signal is "no";
  attribute use_sync_set of rd_avail_2   : signal is "no";
  attribute use_sync_set of rd_valid_2   : signal is "no";

  --Stop XST trying to use RESET on these signals
  attribute use_sync_reset of add_1       : signal is "no";
  attribute use_sync_reset of not_full_1  : signal is "no";
  attribute use_sync_reset of aempty_1    : signal is "no";
  attribute use_sync_reset of not_afull_1 : signal is "no";
  attribute use_sync_reset of rd_valid_2  : signal is "no";

  --Keep hierarchy around this entity
  attribute keep_hierarchy of xilinx : architecture is  "no"; --CR579946;

begin

  ------------------------------------------------------------------------------------------------------------------------
  assumptions : block
  begin
    assert DEPTH >= 4
      report "ERROR:DEPTH must be >=4"
      severity failure;
    assert GLB_is_pow2(DEPTH)
      report "ERROR:DEPTH must be a power of 2"
      severity failure;

    --Check the thresholds
    --  The eq() function has an ambiguity when a threshold is 0 or DEPTH - we need to make sure that we avoid the ambiguity
    --  If a threshold is only used when the FIFO count is incrementing, we know it makes no sense to looks for count=DEPTH (as we'd be overflowing)
    --  If a threshold is only used when the FIFO count is decrementing, we know it makes no sense to looks for count=0 (as we'd be underflowing)
    assert not HAS_AFULL or AFULL_THRESH1 < DEPTH
      report "ERROR:AFULL_THRESH1 muts be <DEPTH"
      severity failure;
    assert not HAS_AEMPTY or AEMPTY_THRESH0 < DEPTH
      report "ERROR:AEMPTY_THRESH0 muts be <DEPTH"
      severity failure;
    assert not HAS_AFULL or AFULL_THRESH0 > 0
      report "ERROR:AFULL_THRESH0 muts be >0"
      severity failure;
    assert not HAS_AEMPTY or AEMPTY_THRESH1 > 0
      report "ERROR:AEMPTY_THRESH1 muts be >0"
      severity failure;
  end block;

  ------------------------------------------------------------------------------------------------------------------------
  io : block
  begin
    --Empty flag is always MSB of add_1 (if add_1<0 FIFO is empty)
    empty_1 <= add_1(add_1'left);

    --Outputs
    rd_avail   <= rd_avail_2;
    rd_valid   <= rd_valid_2;
    rd_data    <= fifo_2;
    full       <= full_1;
    not_full   <= not_full_1;
    empty      <= empty_1;
    not_empty  <= not_empty_1;
    afull      <= afull_1;
    aempty     <= aempty_1;
    not_afull  <= not_afull_1;
    not_aempty <= not_aempty_1;
    add        <= add_1;

    --Gate rd_enable against not empty if HAS_UVPROT or HAS_IFX generics set
    rd_en <= rd_enable and GLB_if(HAS_UVPROT or HAS_IFX, not empty_1, '1');
    wr_en <= wr_enable;
  end block;

  ------------------------------------------------------------------------------------------------------------------------
  reg_proc : process (aclk)
    --Increment/decrement value for add_1 signal
    variable add_lhs : unsigned(add_1'range);
    variable add_cin : unsigned(0 downto 0);

  begin
    if rising_edge(aclk) then

      if (areset = '1') then
        add_1        <= (others => '1');
        not_empty_1  <= '0';
        full_1       <= '0';
        not_full_1   <= '1';
        afull_1      <= '0';
        aempty_1     <= '1';
        not_afull_1  <= '1';
        not_aempty_1 <= '0';
        rd_avail_2   <= '0';
        rd_valid_2   <= '0';
      else
        if (not HAS_IFX or rd_enable = '1') then
                                        --Data is available when we're not empty
          rd_avail_2 <= not empty_1;
                                        --Data is valid if we're doing a read
          rd_valid_2 <= rd_en;
        end if;

        if (rd_en = '0' and wr_en = '1') then
                                        --No read, write (add word to FIFO)

                                        --translate off
          assert full_1 = '0'
            report "ERROR:Write to full FIFO"
            severity failure;
                                        --translate on

                                        --Update flags
          if eq(DEPTH-1, add_1) then
            full_1     <= '1';
            not_full_1 <= '0';
          end if;

          not_empty_1 <= '1';  --Adding word to FIFO, so can not be empty

          if (HAS_AFULL and eq(AFULL_THRESH1, add_1)) then
            afull_1     <= '1';
            not_afull_1 <= '0';
          end if;

          if (HAS_AEMPTY and eq(AEMPTY_THRESH0, add_1)) then
            aempty_1     <= '0';
            not_aempty_1 <= '1';
          end if;

        elsif (rd_en = '1' and wr_en = '0') then
                                        --Read, no write (remove word from FIFO)

                                        --translate off
          assert empty_1 = '0'
            report "ERROR:Read from empty FIFO"
            severity failure;
                                        --translate on

                                        --Update flags
          full_1     <= '0';  --Removing word from FIFO, so can not be full
          not_full_1 <= '1';

          if (eq(1, add_1)) then
            not_empty_1 <= '0';
          end if;

          if (HAS_AFULL and eq(AFULL_THRESH0, add_1)) then
            afull_1     <= '0';
            not_afull_1 <= '1';
          end if;

          if (HAS_AEMPTY and eq(AEMPTY_THRESH1, add_1)) then
            aempty_1     <= '1';
            not_aempty_1 <= '0';
          end if;

        elsif (rd_en = '1' and wr_en = '1') then
                                        --Read and write

                                        --translate off
          assert empty_1 = '0'
            report "ERROR:Read/write from empty FIFO"
            severity failure;
                                        --translate on

          null;                         --FIFO state doesn't change
        end if;

        --Need to add n to add_1 (where n=-1,0 or +1 depending on wr_en/rd_en)
        --  By using the cin we save one input to the LUT, which helps when absorbing logic on rd_enable
        add_lhs    := (others => rd_en);  --When rd_en is high, add_lhs is 11.11 (i.e. -1)
        add_cin(0) := wr_en;  --When wr_en is high, add_cin is 1 (i.e. +1)
        add_1      <= signed(std_logic_vector(add_lhs+unsigned(add_1)+add_cin));  --Note that the order (lhs+add+cin) is important otehrwise XST infers an accumulator...

      end if;

      --Write word to FIFO
      if (wr_en = '1') then
        fifo_1 <= (wr_data & fifo_1(0 to DEPTH-2));
      end if;

      --Read from FIFO
      -- When addressing the SRL, we ignore the sign of add_1. Note we're slicing a signed into an unsigned
      if (not HAS_IFX or rd_enable = '1') then
        fifo_2 <= fifo_1(to_integer(unsigned(add_1(add'left-1 downto 0))));
      end if;

    end if;
  end process;

  ------------------------------------------------------------------------------------------------------------------------
  --Simulation only checking process
  --translate off
  check_proc : process (aclk)
    --Coverpoints
    constant READS  : natural := 0;
    constant WRITES : natural := 0;
    constant COUNT  : natural := 0;
    constant DATA   : natural := 0;
  begin
    if rising_edge(aclk) then
      --Invariants
      assert rd_valid_2 = '0' or rd_avail_2 = '1'
        report "ERROR:rd_avail asserted when rd_valid deasserted"
        severity failure;
      assert (add_1 >= -1 and add_1 <= DEPTH-1)
        report "ERROR:add_1 must be in range [-1,DEPTH-1]"
        severity failure;
      assert (add_1 = -1) = (empty_1 = '1')
        report "ERROR:add_1 and empty_1 are inconsistent"
        severity failure;
      assert (add_1 = DEPTH-1) = (full_1 = '1')
        report "ERROR:add_1 and full_1 are inconsistent"
        severity failure;
      assert full_1 = '0' or empty_1 = '0'
        report "ERROR:full and empty asserted at the same time"
        severity failure;
      assert full_1 = not not_full_1
        report "ERROR:full_1 and not_full_1 are inconsistent"
        severity failure;
      assert empty_1 = not not_empty_1
        report "ERROR:empty_1 and not_empty_1 are inconsistent"
        severity failure;
      assert afull_1 = not not_afull_1
        report "ERROR:afull_1 and not_afull_1 are inconsistent"
        severity failure;
      assert aempty_1 = not not_aempty_1
        report "ERROR:aempty_1 and not_aempty_1 are inconsistent"
        severity failure;
    end if;
  end process;
  --translate on

end architecture;
