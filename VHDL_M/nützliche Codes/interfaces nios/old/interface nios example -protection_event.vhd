-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Memory mapped registers
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : mmapreg.vhd
-- Author     : Andre Castelan Prado
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-09-29
-- Last update: 2013-01-28
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  Registers mapped into a single table
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-09-29  1.0      ACP     Created
-------------------------------------------------------------------------------
-- 31            21 20                   0
--[ decimal       ] [  fracionary        ]
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_signed.all;

-- entity declaration
entity protection_event is
  port(
    -- Avalon interface signals
    -- avalon signals
    clk        : in  std_logic;
    sysclk     : in  std_logic;
    reset_n    : in  std_logic;
    address    : in  std_logic_vector(5 downto 0);
    byteenable : in  std_logic_vector(3 downto 0);
    writedata  : in  std_logic_vector(31 downto 0);
    write      : in  std_logic;
    readdata   : out std_logic_vector(31 downto 0);
    irq        : out std_logic;
    read       : in  std_logic;
    chipselect : in  std_logic;

    -- interface signals
    ptoc_0_op     : in std_logic_vector(2 downto 0);
    ptoc_1_op     : in std_logic_vector(2 downto 0);
    ptoc_2_op     : in std_logic_vector(2 downto 0);
    ptoc_3_op     : in std_logic_vector(2 downto 0);
    ptoc_4_op     : in std_logic;
    ptoc_5_op     : in std_logic;
    ptoc_6_op     : in std_logic;
    ptoc_7_op     : in std_logic;
    ptoc_8_op     : in std_logic;
    ptoc_9_op     : in std_logic;
    ptoc_10_op    : in std_logic;
    ptoc_11_op    : in std_logic;
    ptoc_12_op    : in std_logic;
    ptoc_13_op    : in std_logic;
    ptoc_14_op    : in std_logic;
    ptoc_15_op    : in std_logic;
    ptoc_0_sense  : in std_logic_vector(2 downto 0);
    ptoc_1_sense  : in std_logic_vector(2 downto 0);
    ptoc_2_sense  : in std_logic_vector(2 downto 0);
    ptoc_3_sense  : in std_logic_vector(2 downto 0);
    ptoc_4_sense  : in std_logic;
    ptoc_5_sense  : in std_logic;
    ptoc_6_sense  : in std_logic;
    ptoc_7_sense  : in std_logic;
    ptoc_8_sense  : in std_logic;
    ptoc_9_sense  : in std_logic;
    ptoc_10_sense : in std_logic;
    ptoc_11_sense : in std_logic;
    ptoc_12_sense : in std_logic;
    ptoc_13_sense : in std_logic;
    ptoc_14_sense : in std_logic;
    ptoc_15_sense : in std_logic;
    --ptoc gerador
    sense_timer_1 : in std_logic;       -- sense signal timer 1
    sense_timer_2 : in std_logic;       -- sense signal timer 2
    sense_termic  : in std_logic;       -- sense termical
    op_termic     : in std_logic;       -- termic operation
    alarm         : in std_logic;       -- alarm (op timer 1)
    op_timer_2    : in std_logic;

    -- pioc
    pioc_0_sense : in std_logic_vector(2 downto 0);
    pioc_0_op    : in std_logic_vector(2 downto 0);
    pioc_1_sense : in std_logic_vector(2 downto 0);
    pioc_1_op    : in std_logic_vector(2 downto 0);
    pioc_2_sense : in std_logic;
    pioc_2_op    : in std_logic;
    pioc_3_sense : in std_logic;
    pioc_3_op    : in std_logic;
    pioc_4_sense : in std_logic;
    pioc_4_op    : in std_logic;
    pioc_5_sense : in std_logic;
    pioc_5_op    : in std_logic;
    pioc_6_sense : in std_logic;
    pioc_6_op    : in std_logic;
    pioc_7_sense : in std_logic;
    pioc_7_op    : in std_logic;

    -- ptov
    ptov_0_sense          : in std_logic_vector(2 downto 0);
    ptov_0_op             : in std_logic_vector(2 downto 0);
    ptov_1_sense          : in std_logic_vector(2 downto 0);
    ptov_1_op             : in std_logic_vector(2 downto 0);
    ptov_2_sense          : in std_logic;
    ptov_2_op             : in std_logic;
    ptov_3_sense          : in std_logic;
    ptov_3_op             : in std_logic;
    ptov_4_sense          : in std_logic;
    ptov_4_op             : in std_logic;
    ptov_5_sense          : in std_logic;
    ptov_5_op             : in std_logic;
    ptov_6_sense          : in std_logic;
    ptov_6_op             : in std_logic;
    ptov_7_sense          : in std_logic;
    ptov_7_op             : in std_logic;
    -- ptuv
    ptuv_0_sense          : in std_logic_vector(2 downto 0);
    ptuv_0_op             : in std_logic_vector(2 downto 0);
    ptuv_1_sense          : in std_logic_vector(2 downto 0);
    ptuv_1_op             : in std_logic_vector(2 downto 0);
    -- ptof
    ptof_0_sense          : in std_logic;
    ptof_0_op             : in std_logic;
    ptof_1_sense          : in std_logic;
    ptof_1_op             : in std_logic;
    -- ptuf
    ptuf_0_sense          : in std_logic;
    ptuf_0_op             : in std_logic;
    ptuf_1_sense          : in std_logic;
    ptuf_1_op             : in std_logic;
    -- pdir
    pdir_forward_fase     : in std_logic;
    pdir_reverse_fase     : in std_logic;
    pdir_forward_neg      : in std_logic;
    pdir_reverse_neg      : in std_logic;
    pdir_forward_n        : in std_logic;
    pdir_reverse_n        : in std_logic;
    pdir_forward_zer      : in std_logic;
    pdir_reverse_zer      : in std_logic;
    -- pfrc
    pfrc_sense            : in std_logic;
    pfrc_op               : in std_logic;
    -- pfrc 1
    pfrc_sense_1          : in std_logic;
    pfrc_op_1             : in std_logic;
    -- pcheck_sync
    pcheck_sync_synprg    : in std_logic;
    pcheck_sync_rel       : in std_logic;
    pcheck_sync_vind      : in std_logic;
    pcheck_sync_angind    : in std_logic;
    pcheck_sync_hzind     : in std_logic;
    -- rbrf
    rbrf_sense            : in std_logic;
    rbrf_opin             : in std_logic;
    rbrf_opex             : in std_logic;
    -- pdop
    pdop_sense            : in std_logic;
    pdop_1_sense          : in std_logic;
    pdop_op               : in std_logic;
    pdop_1_op             : in std_logic;
    pdup_sense            : in std_logic;
    pdup_1_sense          : in std_logic;
    pdup_op               : in std_logic;
    pdup_1_op             : in std_logic;
    pdop_reactive_sense   : in std_logic;
    pdop_reactive_1_sense : in std_logic;
    pdop_reactive_op      : in std_logic;
    pdop_reactive_1_op    : in std_logic;
    pdup_reactive_sense   : in std_logic;
    pdup_reactive_1_sense : in std_logic;
    pdup_reactive_op      : in std_logic;
    pdup_reactive_1_op    : in std_logic;
    -- rrec
    rrec_status           : in std_logic_vector (1 downto 0);
    rrec_op               : in std_logic;


    goose_input       : in std_logic_vector(31 downto 0);
    trip_input        : in std_logic;
    digital_monitor   : in std_logic_vector(15 downto 0);
    digital_in        : in std_logic_vector(11 downto 0);
    relay_keys_input  : in std_logic_vector(4 downto 0);
    leds_input        : in std_logic_vector(13 downto 0);
    sample_counter_in : in std_logic_vector(63 downto 0);





    irq_event : out std_logic
    );
end protection_event;


architecture rtl of protection_event is


  -- Build an enumerated type for the state machine
  type STATE_TYPE_CORE is (INIT, WAIT_ACTION, DELAY, FINISH);
  type BUFFER_R is array (integer range <>) of std_logic_vector (31 downto 0);
  type GERA_INTERRUPT is (INIT, WAIT_ACTION, DELAY, FINISH);



  attribute ENUM_ENCODING                    : string;
  attribute ENUM_ENCODING of STATE_TYPE_CORE : type is "00 01 10 11";
  attribute ENUM_ENCODING of GERA_INTERRUPT  : type is "00 01 10 11";


  -- Registers to hold the current state
  -- Trip 
  signal state_gera_irq      : GERA_INTERRUPT;
  signal state_gera_irq_next : GERA_INTERRUPT;
  -- Start
  signal state_start         : STATE_TYPE_CORE;
  signal state_start_next    : STATE_TYPE_CORE;

  signal read_en      : std_logic;
  signal total_input  : std_logic_vector(1023 downto 0);
  signal or_rdir_neg  : std_logic;
  signal or_rdir_n    : std_logic;
  signal or_rdir_zer  : std_logic;
  signal or_rdir_fase : std_logic;

  signal BUFFER_REGS        : BUFFER_R ((total_input'length/(8*4))-1 downto 0);
  signal BUFFER_REGS_next   : BUFFER_R ((total_input'length/(8*4))-1 downto 0);
  signal GERA_IRQ           : natural range 0 to 10;
  signal GERA_IRQ_next      : natural range 0 to 11;
  signal irq_event_reg      : std_logic;
  signal irq_event_reg_next : std_logic;

  signal sample_counter_int : std_logic_vector(63 downto 0);
  signal sample_counter_int_next : std_logic_vector(63 downto 0);

  alias ptoc0        : std_logic_vector(7 downto 0) is total_input(7 downto 0);
  alias ptoc1        : std_logic_vector(7 downto 0) is total_input(15 downto 8);
  alias ptoc2        : std_logic_vector(7 downto 0) is total_input(23 downto 16);
  alias ptoc3        : std_logic_vector(7 downto 0) is total_input(31 downto 24);
  alias ptoc4        : std_logic_vector(7 downto 0) is total_input(39 downto 32);
  alias ptoc5        : std_logic_vector(7 downto 0) is total_input(47 downto 40);
  alias ptoc6        : std_logic_vector(7 downto 0) is total_input(55 downto 48);
  alias ptoc7        : std_logic_vector(7 downto 0) is total_input(63 downto 56);
  alias ptoc8        : std_logic_vector(7 downto 0) is total_input(71 downto 64);
  alias ptoc9        : std_logic_vector(7 downto 0) is total_input(79 downto 72);
  alias ptoc10       : std_logic_vector(7 downto 0) is total_input(87 downto 80);
  alias ptoc11       : std_logic_vector(7 downto 0) is total_input(95 downto 88);
  alias ptoc12       : std_logic_vector(7 downto 0) is total_input(103 downto 96);
  alias ptoc13       : std_logic_vector(7 downto 0) is total_input(111 downto 104);
  alias ptoc14       : std_logic_vector(7 downto 0) is total_input(119 downto 112);
  alias ptoc15       : std_logic_vector(7 downto 0) is total_input(127 downto 120);
  alias ptuf0        : std_logic_vector(7 downto 0) is total_input(135 downto 128);
  alias ptuf1        : std_logic_vector(7 downto 0) is total_input(143 downto 136);
  alias ptof0        : std_logic_vector(7 downto 0) is total_input(151 downto 144);
  alias ptof1        : std_logic_vector(7 downto 0) is total_input(159 downto 152);
  alias ptuv0        : std_logic_vector(7 downto 0) is total_input(167 downto 160);
  alias ptuv1        : std_logic_vector(7 downto 0) is total_input(175 downto 168);
  alias ptov0        : std_logic_vector(7 downto 0) is total_input(183 downto 176);
  alias ptov1        : std_logic_vector(7 downto 0) is total_input(191 downto 184);
  alias ptov2        : std_logic_vector(7 downto 0) is total_input(199 downto 192);
  alias ptov3        : std_logic_vector(7 downto 0) is total_input(207 downto 200);
  alias ptov4        : std_logic_vector(7 downto 0) is total_input(215 downto 208);
  alias ptov5        : std_logic_vector(7 downto 0) is total_input(223 downto 216);
  alias ptov6        : std_logic_vector(7 downto 0) is total_input(231 downto 224);
  alias ptov7        : std_logic_vector(7 downto 0) is total_input(239 downto 232);
  alias pioc0        : std_logic_vector(7 downto 0) is total_input(247 downto 240);
  alias pioc1        : std_logic_vector(7 downto 0) is total_input(255 downto 248);
  alias pioc2        : std_logic_vector(7 downto 0) is total_input(263 downto 256);
  alias pioc3        : std_logic_vector(7 downto 0) is total_input(271 downto 264);
  alias pioc4        : std_logic_vector(7 downto 0) is total_input(279 downto 272);
  alias pioc5        : std_logic_vector(7 downto 0) is total_input(287 downto 280);
  alias pioc6        : std_logic_vector(7 downto 0) is total_input(295 downto 288);
  alias pioc7        : std_logic_vector(7 downto 0) is total_input(303 downto 296);
  alias ptoc_gerador : std_logic_vector(7 downto 0) is total_input(311 downto 304);
  alias rdir0        : std_logic_vector(7 downto 0) is total_input(319 downto 312);
  alias rdir1        : std_logic_vector(7 downto 0) is total_input(327 downto 320);
  alias rdir2        : std_logic_vector(7 downto 0) is total_input(335 downto 328);
  alias rdir3        : std_logic_vector(7 downto 0) is total_input(343 downto 336);
  alias pfrc0        : std_logic_vector(7 downto 0) is total_input(351 downto 344);
  alias pfrc1        : std_logic_vector(7 downto 0) is total_input(359 downto 352);
  alias checksync    : std_logic_vector(7 downto 0) is total_input(367 downto 360);
  alias pdop0        : std_logic_vector(7 downto 0) is total_input(375 downto 368);
  alias pdop1        : std_logic_vector(7 downto 0) is total_input(383 downto 376);
  alias pdop2        : std_logic_vector(7 downto 0) is total_input(391 downto 384);
  alias pdop3        : std_logic_vector(7 downto 0) is total_input(399 downto 392);
  alias pdup0        : std_logic_vector(7 downto 0) is total_input(407 downto 400);
  alias pdup1        : std_logic_vector(7 downto 0) is total_input(415 downto 408);
  alias pdup2        : std_logic_vector(7 downto 0) is total_input(423 downto 416);
  alias pdup3        : std_logic_vector(7 downto 0) is total_input(431 downto 424);
  alias rbrf         : std_logic_vector(7 downto 0) is total_input(439 downto 432);
  alias rrec         : std_logic_vector(7 downto 0) is total_input(447 downto 440);
  alias reserved0    : std_logic_vector(31 downto 0) is total_input(479 downto 448);
  alias reserved1    : std_logic_vector(31 downto 0) is total_input(511 downto 480);
  alias reserved2    : std_logic_vector(31 downto 0) is total_input(543 downto 512);
  alias reserved3    : std_logic_vector(31 downto 0) is total_input(575 downto 544);
  alias reserved4    : std_logic_vector(31 downto 0) is total_input(607 downto 576);
  alias reserved5    : std_logic_vector(31 downto 0) is total_input(639 downto 608);
  alias reserved6    : std_logic_vector(31 downto 0) is total_input(671 downto 640);
  alias reserved7    : std_logic_vector(31 downto 0) is total_input(703 downto 672);
  alias reserved8    : std_logic_vector(31 downto 0) is total_input(735 downto 704);
  alias reserved9    : std_logic_vector(31 downto 0) is total_input(767 downto 736);
  alias reserved10   : std_logic_vector(31 downto 0) is total_input(799 downto 768);
  alias reserved11   : std_logic_vector(31 downto 0) is total_input(831 downto 800);
  alias reserved12   : std_logic_vector(31 downto 0) is total_input(863 downto 832);
  alias goose        : std_logic_vector(31 downto 0) is total_input(895 downto 864);
  alias zero_vect3   : std_logic_vector(2 downto 0) is total_input(898 downto 896);
  alias trip         : std_logic is total_input(899);
  alias digmon       : std_logic_vector(15 downto 0) is total_input(915 downto 900);
  alias digin        : std_logic_vector(11 downto 0) is total_input(927 downto 916);
  alias zero_vect13  : std_logic_vector(12 downto 0) is total_input(940 downto 928);
  alias relay_keys   : std_logic_vector(4 downto 0) is total_input(945 downto 941);
  alias leds         : std_logic_vector(13 downto 0) is total_input(959 downto 946);
  alias samplecount0 : std_logic_vector(31 downto 0) is total_input(991 downto 960);
  alias samplecount1 : std_logic_vector(31 downto 0) is total_input(1023 downto 992);


  
  
  
  
begin

  irq_event    <= irq_event_reg;
  or_rdir_fase <= '1' when ((ptoc_0_sense or ptoc_1_sense or ptoc_2_sense or ptoc_3_sense) /= "000") else '0';
  or_rdir_neg  <= '1' when ((ptoc_5_sense or ptoc_8_sense or ptoc_11_sense or ptoc_14_sense) /= '0') else '0';
  or_rdir_zer  <= '1' when ((ptoc_6_sense or ptoc_9_sense or ptoc_12_sense or ptoc_15_sense) /= '0') else '0';
  or_rdir_n    <= '1' when ((ptoc_4_sense or ptoc_7_sense or ptoc_10_sense or ptoc_13_sense) /= '0') else '0';


  ptoc0 <= (ptoc_0_op(0) or ptoc_0_op(1) or ptoc_0_op(2)) & (ptoc_0_sense(0) or ptoc_0_sense(1) or ptoc_0_sense(2)) & ptoc_0_op(2) & ptoc_0_op(1) & ptoc_0_op(0) & ptoc_0_sense(2) & ptoc_0_sense(1) & ptoc_0_sense(0);

  ptoc1 <= (ptoc_1_op(0) or ptoc_1_op(1) or ptoc_1_op(2)) & (ptoc_1_sense(0) or ptoc_1_sense(1) or ptoc_1_sense(2)) & ptoc_1_op(2) & ptoc_1_op(1) & ptoc_1_op(0) & ptoc_1_sense(2) & ptoc_1_sense(1) & ptoc_1_sense(0);

  ptoc2 <= (ptoc_2_op(0) or ptoc_2_op(1) or ptoc_2_op(2)) & (ptoc_2_sense(0) or ptoc_2_sense(1) or ptoc_2_sense(2)) & ptoc_2_op(2) & ptoc_2_op(1) & ptoc_2_op(0) & ptoc_2_sense(2) & ptoc_2_sense(1) & ptoc_2_sense(0);

  ptoc3 <= (ptoc_3_op(0) or ptoc_3_op(1) or ptoc_3_op(2)) & (ptoc_3_sense(0) or ptoc_3_sense(1) or ptoc_3_sense(2)) & ptoc_3_op(2) & ptoc_3_op(1) & ptoc_3_op(0) & ptoc_3_sense(2) & ptoc_3_sense(1) & ptoc_3_sense(0);

  ptoc4 <= "000000" & ptoc_4_op & ptoc_4_sense;

  ptoc5 <= "000000" & ptoc_5_op & ptoc_5_sense;

  ptoc6 <= "000000" & ptoc_6_op & ptoc_6_sense;

  ptoc7 <= "000000" & ptoc_7_op & ptoc_7_sense;

  ptoc8 <= "000000" & ptoc_8_op & ptoc_8_sense;

  ptoc9 <= "000000" & ptoc_9_op & ptoc_9_sense;

  ptoc10 <= "000000" & ptoc_10_op & ptoc_10_sense;

  ptoc11 <= "000000" & ptoc_11_op & ptoc_11_sense;

  ptoc12 <= "000000" & ptoc_12_op & ptoc_12_sense;

  ptoc13 <= "000000" & ptoc_13_op & ptoc_13_sense;

  ptoc14 <= "000000" & ptoc_14_op & ptoc_14_sense;

  ptoc15 <= "000000" & ptoc_15_op & ptoc_15_sense;

  ptuf0 <= "000000" & ptuf_0_op & ptuf_0_sense;

  ptuf1 <= "000000" & ptuf_1_op & ptuf_1_sense;

  ptof0 <= "000000" & ptof_0_op & ptof_0_sense;

  ptof1 <= "000000" & ptof_1_op & ptof_1_sense;

  ptuv0 <= (ptuv_0_op(0) or ptuv_0_op(1) or ptuv_0_op(2)) & (ptuv_0_sense(0) or ptuv_0_sense(1) or ptuv_0_sense(2)) & ptuv_0_op(2) & ptuv_0_op(1) & ptuv_0_op(0) & ptuv_0_sense(2) & ptuv_0_sense(1) & ptuv_0_sense(0);

  ptuv1 <= (ptuv_1_op(0) or ptuv_1_op(1) or ptuv_1_op(2)) & (ptuv_1_sense(0) or ptuv_1_sense(1) or ptuv_1_sense(2)) & ptuv_1_op(2) & ptuv_1_op(1) & ptuv_1_op(0) & ptuv_1_sense(2) & ptuv_1_sense(1) & ptuv_1_sense(0);

  ptov0 <= (ptov_0_op(0) or ptov_0_op(1) or ptov_0_op(2)) & (ptov_0_sense(0) or ptov_0_sense(1) or ptov_0_sense(2)) & ptov_0_op(2) & ptov_0_op(1) & ptov_0_op(0) & ptov_0_sense(2) & ptov_0_sense(1) & ptov_0_sense(0);

  ptov1 <= (ptov_1_op(0) or ptov_1_op(1) or ptov_1_op(2)) & (ptov_1_sense(0) or ptov_1_sense(1) or ptov_1_sense(2)) & ptov_1_op(2) & ptov_1_op(1) & ptov_1_op(0) & ptov_1_sense(2) & ptov_1_sense(1) & ptov_1_sense(0);

  ptov2 <= "000000" & ptov_2_op & ptov_2_sense;

  ptov3 <= "000000" & ptov_3_op & ptov_3_sense;

  ptov4 <= "000000" & ptov_4_op & ptov_4_sense;

  ptov5 <= "000000" & ptov_5_op & ptov_5_sense;

  ptov6 <= "000000" & ptov_6_op & ptov_6_sense;

  ptov7 <= "000000" & ptov_7_op & ptov_7_sense;

  pioc0 <= (pioc_0_op(0) or pioc_0_op(1) or pioc_0_op(2)) & (pioc_0_sense(0) or pioc_0_sense(1) or pioc_0_sense(2)) & pioc_0_op(2) & pioc_0_op(1) & pioc_0_op(0) & pioc_0_sense(2) & pioc_0_sense(1) & pioc_0_sense(0);

  pioc1 <= (pioc_1_op(0) or pioc_1_op(1) or pioc_1_op(2)) & (pioc_1_sense(0) or pioc_1_sense(1) or pioc_1_sense(2)) & pioc_1_op(2) & pioc_1_op(1) & pioc_1_op(0) & pioc_1_sense(2) & pioc_1_sense(1) & pioc_1_sense(0);

  pioc2 <= "000000" & pioc_2_op & pioc_2_sense;

  pioc3 <= "000000" & pioc_3_op & pioc_3_sense;

  pioc4 <= "000000" & pioc_4_op & pioc_4_sense;

  pioc5 <= "000000" & pioc_5_op & pioc_5_sense;

  pioc6 <= "000000" & pioc_6_op & pioc_6_sense;

  pioc7 <= "000000" & pioc_7_op & pioc_7_sense;

  ptoc_gerador <= "00" & op_timer_2 & sense_timer_2 & op_termic & sense_termic & alarm & sense_timer_1;

  rdir0 <= "00000" & or_rdir_fase & pdir_forward_fase & pdir_reverse_fase;

  rdir1 <= "00000" & or_rdir_n & pdir_forward_n & pdir_reverse_n;

  rdir2 <= "00000" & or_rdir_zer & pdir_forward_zer & pdir_reverse_zer;

  rdir3 <= "00000" & or_rdir_neg & pdir_forward_neg & pdir_reverse_neg;

  pfrc0 <= "000000" & pfrc_op & pfrc_sense;

  pfrc1 <= "000000" & pfrc_op_1 & pfrc_sense_1;

  checksync <= "000" & pcheck_sync_synprg & pcheck_sync_hzind & pcheck_sync_angind & pcheck_sync_vind & pcheck_sync_rel;

  pdop0 <= "000000" & pdop_reactive_op & pdop_reactive_sense;

  pdop1 <= "000000" & pdop_reactive_1_op & pdop_reactive_1_sense;

  pdop2 <= "000000" & pdop_op & pdop_sense;

  pdop3 <= "000000" & pdop_1_op & pdop_1_sense;

  pdup0 <= "000000" & pdup_reactive_op & pdup_reactive_sense;

  pdup1 <= "000000" & pdup_reactive_1_op & pdup_reactive_1_sense;

  pdup2 <= "000000" & pdup_op & pdup_sense;

  pdup3 <= "000000" & pdup_1_op & pdup_1_sense;

  rbrf <= "00000" & rbrf_opex & rbrf_opin & rbrf_sense;

  rrec <= "00000" & rrec_status & rrec_op;

  reserved0 <= (others => '0');

  reserved1 <= (others => '0');

  reserved2 <= (others => '0');

  reserved3 <= (others => '0');

  reserved4 <= (others => '0');

  reserved5 <= (others => '0');

  reserved6 <= (others => '0');

  reserved7 <= (others => '0');

  reserved8 <= (others => '0');

  reserved9 <= (others => '0');

  reserved10 <= (others => '0');

  reserved11 <= (others => '0');

  reserved12 <= (others => '0');

  goose <= goose_input;

  zero_vect3 <= "000";

  trip <= trip_input;

  digmon <= digital_monitor;

  digin <= digital_in;

  zero_vect13 <= "0000000000000";

  relay_keys <= relay_keys_input;

  leds <= leds_input(1) & leds_input(2) & leds_input(3) & leds_input(4) & leds_input(5) & leds_input(6) & leds_input(7) & leds_input(0) & leds_input(13) & leds_input(12) & leds_input(11) & leds_input(10) & leds_input(9) & leds_input(8);

  samplecount0 <= sample_counter_int(31 downto 0);

  samplecount1 <= sample_counter_int(63 downto 32);
                  


  --total_input <=
  --  x"00000000" & "00000" & rrec_status & rrec_op & "00000" & rbrf_opex & rbrf_opin & rbrf_sense &
  --  "000000" & pdup_reactive_1_op & pdup_reactive_1_sense & "000000" & pdup_reactive_op & pdup_reactive_sense & "000000" & pdup_1_op & pdup_1_sense & "000000" & pdup_op & pdup_sense & "000000" & pdop_reactive_1_op & pdop_reactive_1_sense & "000000" & pdop_reactive_op & pdop_reactive_sense & "000000" & pdop_1_op & pdop_1_sense & "000000" & pdop_op & pdop_sense &
  --  "000" & pcheck_sync_synprg & pcheck_sync_hzind & pcheck_sync_angind & pcheck_sync_vind & pcheck_sync_rel & "000000" & pfrc_op_1 & pfrc_sense_1 &
  --  "000000" & pfrc_op & pfrc_sense & "00000" & or_rdir_neg & pdir_forward_neg & pdir_reverse_neg & "00000" & or_rdir_zer & pdir_forward_zer & pdir_reverse_zer & "00000" & or_rdir_n & pdir_forward_n & pdir_reverse_n &"00000" & or_rdir_fase & pdir_forward_fase & pdir_reverse_fase &
  --  "00" & op_timer_2 & sense_timer_2 & op_termic & sense_termic & alarm & sense_timer_1 & "0000" & pioc_7_op & "00" & pioc_7_sense & "0000" & pioc_6_op & "00" & pioc_6_sense &
  --  "0000" & pioc_5_op & "00" & pioc_5_sense & "0000" & pioc_4_op & "00" & pioc_4_sense & "0000" & pioc_3_op & "00" & pioc_3_sense & "0000" & pioc_2_op & "00" & pioc_2_sense &
  --  "00" & pioc_1_op & pioc_1_sense & "00" & pioc_0_op & pioc_0_sense & "0000" & ptov_7_op & "00" & ptov_7_sense & "0000" & ptov_6_op & "00" & ptov_6_sense &
  --  "0000" & ptov_5_op & "00" & ptov_5_sense & "0000" & ptov_4_op & "00" & ptov_4_sense & "0000" & ptov_3_op & "00" & ptov_3_sense & "0000" & ptov_2_op & "00" & ptov_2_sense &
  --  "00" & ptov_1_op & ptov_1_sense & "00" & ptov_0_op & ptov_0_sense & "00" & ptuv_1_op & ptuv_1_sense & "00" & ptuv_0_op & ptuv_0_sense &
  --  "0000" & ptof_1_op & "00" & ptof_1_sense & "0000" & ptof_0_op & "00" & ptof_0_sense & "0000" & ptuf_1_op & "00" & ptuf_1_sense & "0000" & ptuf_0_op & "00" & ptuf_0_sense &
  --  "00" & ptoc_15_op & ptoc_15_sense & "00" & ptoc_14_op & ptoc_14_sense & "00" & ptoc_13_op & ptoc_13_sense & "00" & ptoc_12_op & ptoc_12_sense &
  --  "00" & ptoc_11_op & ptoc_11_sense & "00" & ptoc_10_op & ptoc_10_sense & "00" & ptoc_9_op & ptoc_9_sense & "00" & ptoc_8_op & ptoc_8_sense &
  --  "00" & ptoc_7_op & ptoc_7_sense & "00" & ptoc_6_op & ptoc_6_sense & "00" & ptoc_5_op & ptoc_5_sense & "00" & ptoc_4_op & ptoc_4_sense &
  --  "00" & ptoc_3_op & ptoc_3_sense & "00" & ptoc_2_op & ptoc_2_sense & "00" & ptoc_1_op & ptoc_1_sense & "00" & ptoc_0_op & ptoc_0_sense;


  read_en <= '1' when ((chipselect = '1') and (read = '1')) else '0';


  process (BUFFER_REGS, address, read_en) is
  begin
    -- Linux adresses and values
    if read_en = '1' then
      readdata <= BUFFER_REGS(to_integer(unsigned(address)));
    else
      readdata <= "00000000000000000000000000000000";
    end if;
  end process;

  -- Start
  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      state_start <= INIT;
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i
    elsif rising_edge(sysclk) then
      state_start <= state_start_next;
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= BUFFER_REGS_next(i)(j);
        end loop;  -- j
      end loop;  -- i
    end if;
  end process;
  process (BUFFER_REGS, state_start, total_input)
  begin
    state_start_next <= state_start;
    for i in 0 to BUFFER_REGS'length-1 loop
      for j in 0 to 31 loop
        BUFFER_REGS_next(i)(j) <= BUFFER_REGS(i)(j);
      end loop;  -- j
    end loop;  -- i

    case state_start is
      
      when INIT =>
        state_start_next <= WAIT_ACTION;
        for i in 0 to BUFFER_REGS'length-1 loop
          for j in 0 to 31 loop
            BUFFER_REGS_next(i)(j) <= '0';
          end loop;  -- j
        end loop;  -- i
        
      when WAIT_ACTION =>
        for i in 0 to BUFFER_REGS'length-1 loop
          for j in 0 to 31 loop
            BUFFER_REGS_next(i)(j) <= total_input(i*32 + j);
          end loop;  -- j
        end loop;  -- i
        state_start_next <= DELAY;
        
      when DELAY =>
        state_start_next <= WAIT_ACTION;
        
      when others =>
        state_start_next <= INIT;
        
    end case;
  end process;

  -- Temporario, gera interrupcao e zera o resto dos registradores

  -- Start
  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      state_gera_irq <= INIT;
      irq_event_reg  <= '0';
      GERA_IRQ       <= 0;
      sample_counter_int <= (others => '0');
    elsif rising_edge(sysclk) then
      state_gera_irq <= state_gera_irq_next;
      irq_event_reg  <= irq_event_reg_next;
      GERA_IRQ       <= GERA_IRQ_next;
      sample_counter_int <= sample_counter_int_next;
    end if;
  end process;
  process (BUFFER_REGS, BUFFER_REGS_next, GERA_IRQ, irq_event_reg,
           sample_counter_in, sample_counter_int, state_gera_irq)
  begin
    state_gera_irq_next <= state_gera_irq;
    irq_event_reg_next  <= irq_event_reg;
    GERA_IRQ_next       <= GERA_IRQ;
    sample_counter_int_next <= sample_counter_int;


    case state_gera_irq is
      
      when INIT =>
        sample_counter_int_next <= (others => '0');
        state_gera_irq_next <= WAIT_ACTION;
        
        
      when WAIT_ACTION =>
        irq_event_reg_next <= '0';
        for i in 0 to BUFFER_REGS'length-1 loop
          if(BUFFER_REGS_next(i) /= BUFFER_REGS(i)) then
            state_gera_irq_next <= DELAY;
            sample_counter_int_next <= sample_counter_in;
          end if;
        end loop;  -- i
        
      when DELAY =>
        GERA_IRQ_next      <= GERA_IRQ + 1;
        irq_event_reg_next <= '1';
        if GERA_IRQ = 10 then
          GERA_IRQ_next       <= 0;
          state_gera_irq_next <= WAIT_ACTION;
        end if;

      when others =>
        state_gera_irq_next <= INIT;
        
    end case;
  end process;


end rtl;
