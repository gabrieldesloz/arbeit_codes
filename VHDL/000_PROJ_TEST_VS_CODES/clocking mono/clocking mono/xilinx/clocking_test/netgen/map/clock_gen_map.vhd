--------------------------------------------------------------------------------
-- Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.15xf
--  \   \         Application: netgen
--  /   /         Filename: clock_gen_map.vhd
-- /___/   /\     Timestamp: Fri Aug 29 15:24:06 2014
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -s 3 -pcf clock_gen.pcf -rpw 100 -tpw 0 -ar Structure -tm clock_gen -w -dir netgen/map -ofmt vhdl -sim clock_gen_map.ncd clock_gen_map.vhd 
-- Device	: 6slx25ftg256-3 (PRODUCTION 1.21 2012-04-23)
-- Input file	: clock_gen_map.ncd
-- Output file	: \\smkn33\s10169\vhdl\clocking mono\xilinx\clocking_test\netgen\map\clock_gen_map.vhd
-- # of Entities	: 1
-- Design Name	: clock_gen
-- Xilinx	: C:\Xilinx\14.1\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity clock_gen is
  port (
    dcmrst_i : in STD_LOGIC := 'X'; 
    CLK37mux_i : in STD_LOGIC := 'X'; 
    clkaq_o : out STD_LOGIC; 
    clk2x_o : out STD_LOGIC; 
    clkx_o : out STD_LOGIC; 
    clkz_o : out STD_LOGIC; 
    c1us_o : out STD_LOGIC; 
    adc1_sclk_o : out STD_LOGIC; 
    adc2_sclk_o : out STD_LOGIC; 
    clka_o : out STD_LOGIC; 
    clkab_o : out STD_LOGIC 
  );
end clock_gen;

architecture Structure of clock_gen is
  signal clk2x_o_OBUF_184 : STD_LOGIC; 
  signal clkaq_185 : STD_LOGIC; 
  signal dcmrst_i_IBUF_0 : STD_LOGIC; 
  signal ck1us_192 : STD_LOGIC; 
  signal CLK37mux_i_IBUFG_0 : STD_LOGIC; 
  signal clkab_o_OBUF_196 : STD_LOGIC; 
  signal adc2_sclk_o_OBUF_197 : STD_LOGIC; 
  signal clkx_o_OBUF_198 : STD_LOGIC; 
  signal clkz_o_OBUF_199 : STD_LOGIC; 
  signal CLKFX : STD_LOGIC; 
  signal clkxx_202 : STD_LOGIC; 
  signal clkxxx_203 : STD_LOGIC; 
  signal PWR_4_o_ck1us_AND_6_o1_204 : STD_LOGIC; 
  signal Madd_dv1_5_GND_4_o_add_10_OUT_cy_3_Q : STD_LOGIC; 
  signal PWR_4_o_ck1us_AND_6_o : STD_LOGIC; 
  signal N11 : STD_LOGIC; 
  signal N18 : STD_LOGIC; 
  signal N13 : STD_LOGIC; 
  signal PWR_4_o_ck1us_AND_7_o_210 : STD_LOGIC; 
  signal CLK37mux_i_IBUFG_3 : STD_LOGIC; 
  signal dcmrst_i_IBUF_14 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS0 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS1 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS2 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS3 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS4 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS5 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS6 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_STATUS7 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_LOCKED : STD_LOGIC; 
  signal DCM_CLKGEN_inst_CLKFXDV : STD_LOGIC; 
  signal DCM_CLKGEN_inst_PROGDONE : STD_LOGIC; 
  signal DCM_CLKGEN_inst_CLKFX180 : STD_LOGIC; 
  signal DCM_CLKGEN_inst_PROGCLK_INT : STD_LOGIC; 
  signal DCM_CLKGEN_inst_PROGEN_INT : STD_LOGIC; 
  signal DCM_CLKGEN_inst_PROGDATA_INT : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_12_OUT_1_Q : STD_LOGIC; 
  signal N18_pack_13 : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_14_OUT_3_Q : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_14_OUT_0_Q : STD_LOGIC; 
  signal N21 : STD_LOGIC; 
  signal ck1us_rstpot_89 : STD_LOGIC; 
  signal N20 : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_14_OUT_5_Q : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_12_OUT_2_Q : STD_LOGIC; 
  signal dv1_5_GND_4_o_mux_14_OUT_4_Q : STD_LOGIC; 
  signal dv3_2_pack_5 : STD_LOGIC; 
  signal dv3_3_GND_4_o_mux_9_OUT_1_Q : STD_LOGIC; 
  signal dv3_3_GND_4_o_mux_9_OUT_2_Q : STD_LOGIC; 
  signal clkxx_rstpot_144 : STD_LOGIC; 
  signal dv1a_3_GND_4_o_mux_4_OUT_0_Q : STD_LOGIC; 
  signal dv1a_3_GND_4_o_mux_4_OUT_1_Q : STD_LOGIC; 
  signal dv1a_1_pack_3 : STD_LOGIC; 
  signal clkxxx_rstpot_166 : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal dv1 : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal dv3 : STD_LOGIC_VECTOR ( 2 downto 1 ); 
  signal dv1a : STD_LOGIC_VECTOR ( 1 downto 0 ); 
begin
  clkaq_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD176"
    )
    port map (
      I => clkaq_185,
      O => clkaq_o
    );
  CLK37mux_i_IBUFG : X_BUF
    generic map(
      LOC => "PAD159",
      PATHPULSE => 115 ps
    )
    port map (
      O => CLK37mux_i_IBUFG_3,
      I => CLK37mux_i
    );
  ProtoComp4_IMUX : X_BUF
    generic map(
      LOC => "PAD159",
      PATHPULSE => 115 ps
    )
    port map (
      I => CLK37mux_i_IBUFG_3,
      O => CLK37mux_i_IBUFG_0
    );
  clkab_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD160"
    )
    port map (
      I => clkab_o_OBUF_196,
      O => clkab_o
    );
  adc1_sclk_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD178"
    )
    port map (
      I => adc2_sclk_o_OBUF_197,
      O => adc1_sclk_o
    );
  clk2x_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD158"
    )
    port map (
      I => clk2x_o_OBUF_184,
      O => clk2x_o
    );
  clkx_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD177"
    )
    port map (
      I => clkx_o_OBUF_198,
      O => clkx_o
    );
  dcmrst_i_IBUF : X_BUF
    generic map(
      LOC => "PAD180",
      PATHPULSE => 115 ps
    )
    port map (
      O => dcmrst_i_IBUF_14,
      I => dcmrst_i
    );
  ProtoComp4_IMUX_1 : X_BUF
    generic map(
      LOC => "PAD180",
      PATHPULSE => 115 ps
    )
    port map (
      I => dcmrst_i_IBUF_14,
      O => dcmrst_i_IBUF_0
    );
  adc2_sclk_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD195"
    )
    port map (
      I => adc2_sclk_o_OBUF_197,
      O => adc2_sclk_o
    );
  clkz_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD179"
    )
    port map (
      I => clkz_o_OBUF_199,
      O => clkz_o
    );
  clka_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD175"
    )
    port map (
      I => clkab_o_OBUF_196,
      O => clka_o
    );
  c1us_o_OBUF : X_OBUF
    generic map(
      LOC => "PAD157"
    )
    port map (
      I => adc2_sclk_o_OBUF_197,
      O => c1us_o
    );
  BUFG_inst : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => CLKFX,
      O => clk2x_o_OBUF_184
    );
  BUFG_1u : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y4",
      PATHPULSE => 115 ps
    )
    port map (
      I => ck1us_192,
      O => adc2_sclk_o_OBUF_197
    );
  DCM_CLKGEN_inst_PROGCLKINV : X_BUF
    generic map(
      LOC => "DCM_X0Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => DCM_CLKGEN_inst_PROGCLK_INT
    );
  DCM_CLKGEN_inst_PROGENINV : X_BUF
    generic map(
      LOC => "DCM_X0Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => DCM_CLKGEN_inst_PROGEN_INT
    );
  DCM_CLKGEN_inst_PROGDATAINV : X_BUF
    generic map(
      LOC => "DCM_X0Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => GND,
      O => DCM_CLKGEN_inst_PROGDATA_INT
    );
  DCM_CLKGEN_inst : X_DCM_CLKGEN
    generic map(
      CLKFXDV_DIVIDE => 2,
      STARTUP_WAIT => FALSE,
      SPREAD_SPECTRUM => "NONE",
      CLKFX_MD_MAX => 3.000000,
      CLKFX_MULTIPLY => 3,
      CLKFX_DIVIDE => 1,
      CLKIN_PERIOD => 23.000000,
      LOC => "DCM_X0Y1"
    )
    port map (
      CLKIN => CLK37mux_i_IBUFG_0,
      PROGDATA => DCM_CLKGEN_inst_PROGDATA_INT,
      PROGEN => DCM_CLKGEN_inst_PROGEN_INT,
      FREEZEDCM => GND,
      PROGCLK => DCM_CLKGEN_inst_PROGCLK_INT,
      RST => dcmrst_i_IBUF_0,
      CLKFX180 => DCM_CLKGEN_inst_CLKFX180,
      CLKFX => CLKFX,
      PROGDONE => DCM_CLKGEN_inst_PROGDONE,
      CLKFXDV => DCM_CLKGEN_inst_CLKFXDV,
      LOCKED => DCM_CLKGEN_inst_LOCKED,
      STATUS(7) => DCM_CLKGEN_inst_STATUS7,
      STATUS(6) => DCM_CLKGEN_inst_STATUS6,
      STATUS(5) => DCM_CLKGEN_inst_STATUS5,
      STATUS(4) => DCM_CLKGEN_inst_STATUS4,
      STATUS(3) => DCM_CLKGEN_inst_STATUS3,
      STATUS(2) => DCM_CLKGEN_inst_STATUS2,
      STATUS(1) => DCM_CLKGEN_inst_STATUS1,
      STATUS(0) => DCM_CLKGEN_inst_STATUS0
    );
  BUFG_1x : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y2",
      PATHPULSE => 115 ps
    )
    port map (
      I => clkxx_202,
      O => clkx_o_OBUF_198
    );
  BUFG_1z : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y3",
      PATHPULSE => 115 ps
    )
    port map (
      I => clkxxx_203,
      O => clkz_o_OBUF_199
    );
  PWR_4_o_ck1us_AND_6_o11 : X_LUT6
    generic map(
      LOC => "SLICE_X24Y23",
      INIT => X"00000000FF000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => dv1(5),
      ADR4 => dv1(4),
      ADR5 => dv1(0),
      O => PWR_4_o_ck1us_AND_6_o1_204
    );
  PWR_4_o_ck1us_AND_6_o1 : X_LUT6
    generic map(
      LOC => "SLICE_X24Y23",
      INIT => X"0100020000000000"
    )
    port map (
      ADR0 => dv1(2),
      ADR1 => dv1(3),
      ADR2 => ck1us_192,
      ADR3 => dv1(1),
      ADR4 => dv1(0),
      ADR5 => PWR_4_o_ck1us_AND_6_o1_204,
      O => PWR_4_o_ck1us_AND_6_o
    );
  dv1_1_dv1_1_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N18_pack_13,
      O => N18
    );
  dv1_1 : X_FF
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_12_OUT_1_Q,
      O => dv1(1),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_12_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => X"00FFFD0000FFFF00"
    )
    port map (
      ADR0 => dv1(2),
      ADR1 => dv1(3),
      ADR2 => ck1us_192,
      ADR3 => dv1(1),
      ADR4 => dv1(0),
      ADR5 => PWR_4_o_ck1us_AND_6_o1_204,
      O => dv1_5_GND_4_o_mux_12_OUT_1_Q
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT41_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => X"0FFFFFFF0FFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => dv1(5),
      ADR3 => dv1(4),
      ADR4 => ck1us_192,
      ADR5 => '1',
      O => N13
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT11_SW2 : X_LUT5
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => X"0FFF0FFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => dv1(5),
      ADR3 => dv1(4),
      ADR4 => '1',
      O => N18_pack_13
    );
  dv1_3 : X_FF
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_14_OUT_3_Q,
      O => dv1(3),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => X"33CCFF00FF00FC00"
    )
    port map (
      ADR0 => '1',
      ADR1 => dv1(1),
      ADR2 => N13,
      ADR3 => dv1(3),
      ADR4 => dv1(0),
      ADR5 => dv1(2),
      O => dv1_5_GND_4_o_mux_14_OUT_3_Q
    );
  dv1_0 : X_FF
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_14_OUT_0_Q,
      O => dv1(0),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT11 : X_LUT6
    generic map(
      LOC => "SLICE_X25Y23",
      INIT => X"00FF00FF00EF00F7"
    )
    port map (
      ADR0 => dv1(2),
      ADR1 => dv1(1),
      ADR2 => dv1(3),
      ADR3 => dv1(0),
      ADR4 => ck1us_192,
      ADR5 => N18,
      O => dv1_5_GND_4_o_mux_14_OUT_0_Q
    );
  ck1us_rstpot : X_MUX2
    generic map(
      LOC => "SLICE_X26Y23"
    )
    port map (
      IA => N20,
      IB => N21,
      O => ck1us_rstpot_89,
      SEL => ck1us_192
    );
  ck1us_rstpot_F : X_LUT6
    generic map(
      LOC => "SLICE_X26Y23",
      INIT => X"0400000000000000"
    )
    port map (
      ADR0 => dv1(3),
      ADR1 => dv1(1),
      ADR2 => dv1(0),
      ADR3 => dv1(5),
      ADR4 => dv1(4),
      ADR5 => dv1(2),
      O => N20
    );
  ck1us : X_FF
    generic map(
      LOC => "SLICE_X26Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => ck1us_rstpot_89,
      O => ck1us_192,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  ck1us_rstpot_G : X_LUT6
    generic map(
      LOC => "SLICE_X26Y23",
      INIT => X"FFFFFFFFFFF7FFFF"
    )
    port map (
      ADR0 => dv1(5),
      ADR1 => dv1(4),
      ADR2 => dv1(0),
      ADR3 => dv1(1),
      ADR4 => dv1(3),
      ADR5 => dv1(2),
      O => N21
    );
  Madd_dv1_5_GND_4_o_add_10_OUT_cy_3_11 : X_LUT6
    generic map(
      LOC => "SLICE_X26Y23",
      INIT => X"F000000000000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => dv1(3),
      ADR3 => dv1(2),
      ADR4 => dv1(1),
      ADR5 => dv1(0),
      O => Madd_dv1_5_GND_4_o_add_10_OUT_cy_3_Q
    );
  PWR_4_o_ck1us_AND_7_o_SW2 : X_LUT6
    generic map(
      LOC => "SLICE_X26Y23",
      INIT => X"FFFFFFFFFFFF3FFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => ck1us_192,
      ADR2 => dv1(4),
      ADR3 => dv1(3),
      ADR4 => dv1(1),
      ADR5 => dv1(0),
      O => N11
    );
  dv1_5 : X_FF
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_14_OUT_5_Q,
      O => dv1(5),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT61 : X_LUT6
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => X"0000000000003FC0"
    )
    port map (
      ADR0 => '1',
      ADR1 => dv1(4),
      ADR2 => Madd_dv1_5_GND_4_o_add_10_OUT_cy_3_Q,
      ADR3 => dv1(5),
      ADR4 => PWR_4_o_ck1us_AND_6_o,
      ADR5 => PWR_4_o_ck1us_AND_7_o_210,
      O => dv1_5_GND_4_o_mux_14_OUT_5_Q
    );
  dv1_4 : X_FF
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_14_OUT_4_Q,
      O => dv1(4),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_14_OUT51 : X_LUT6
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => X"0000000000000FF0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => Madd_dv1_5_GND_4_o_add_10_OUT_cy_3_Q,
      ADR3 => dv1(4),
      ADR4 => PWR_4_o_ck1us_AND_6_o,
      ADR5 => PWR_4_o_ck1us_AND_7_o_210,
      O => dv1_5_GND_4_o_mux_14_OUT_4_Q
    );
  PWR_4_o_ck1us_AND_7_o : X_LUT6
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => X"00000000C00C0C0C"
    )
    port map (
      ADR0 => '1',
      ADR1 => dv1(5),
      ADR2 => dv1(2),
      ADR3 => dv1(1),
      ADR4 => dv1(0),
      ADR5 => N11,
      O => PWR_4_o_ck1us_AND_7_o_210
    );
  dv1_2 : X_FF
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1_5_GND_4_o_mux_12_OUT_2_Q,
      O => dv1(2),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1_5_GND_4_o_mux_12_OUT31 : X_LUT6
    generic map(
      LOC => "SLICE_X27Y23",
      INIT => X"55AA51A2FF00FF00"
    )
    port map (
      ADR0 => dv1(0),
      ADR1 => PWR_4_o_ck1us_AND_6_o1_204,
      ADR2 => ck1us_192,
      ADR3 => dv1(2),
      ADR4 => dv1(3),
      ADR5 => dv1(1),
      O => dv1_5_GND_4_o_mux_12_OUT_2_Q
    );
  clkaq_clkaq_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => dv3_2_pack_5,
      O => dv3(2)
    );
  clkaq : X_FF
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => clkab_o_OBUF_196,
      O => clkaq_185,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  clka_o1_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => X"00FF00FF00FF00FF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => clkaq_185,
      ADR4 => '1',
      ADR5 => '1',
      O => clkab_o_OBUF_196
    );
  clkxx : X_FF
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => clkxx_rstpot_144,
      O => clkxx_202,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  clkxx_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => X"FF00FF000FF0FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => dv3(2),
      ADR3 => clkxx_202,
      ADR4 => clkaq_185,
      ADR5 => dv3(1),
      O => clkxx_rstpot_144
    );
  dv3_1 : X_FF
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv3_3_GND_4_o_mux_9_OUT_1_Q,
      O => dv3(1),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv3_3_GND_4_o_mux_9_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => X"0F000FF00F000FF0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => clkaq_185,
      ADR3 => dv3(1),
      ADR4 => dv3(2),
      ADR5 => '1',
      O => dv3_3_GND_4_o_mux_9_OUT_1_Q
    );
  Mmux_dv3_3_GND_4_o_mux_9_OUT31 : X_LUT5
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => X"0F0FF000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => clkaq_185,
      ADR3 => dv3(1),
      ADR4 => dv3(2),
      O => dv3_3_GND_4_o_mux_9_OUT_2_Q
    );
  dv3_2 : X_FF
    generic map(
      LOC => "SLICE_X28Y3",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv3_3_GND_4_o_mux_9_OUT_2_Q,
      O => dv3_2_pack_5,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  clkxxx_clkxxx_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => dv1a_1_pack_3,
      O => dv1a(1)
    );
  clkxxx : X_FF
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => clkxxx_rstpot_166,
      O => clkxxx_203,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  clkxxx_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => X"FF0000FFFF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => clkxxx_203,
      ADR4 => dv1a(0),
      ADR5 => dv1a(1),
      O => clkxxx_rstpot_166
    );
  dv1a_0 : X_FF
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1a_3_GND_4_o_mux_4_OUT_0_Q,
      O => dv1a(0),
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  Mmux_dv1a_3_GND_4_o_mux_4_OUT11 : X_LUT6
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => X"000000FF000000FF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => dv1a(0),
      ADR4 => dv1a(1),
      ADR5 => '1',
      O => dv1a_3_GND_4_o_mux_4_OUT_0_Q
    );
  Mmux_dv1a_3_GND_4_o_mux_4_OUT21 : X_LUT5
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => X"0000FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => dv1a(0),
      ADR4 => dv1a(1),
      O => dv1a_3_GND_4_o_mux_4_OUT_1_Q
    );
  dv1a_1 : X_FF
    generic map(
      LOC => "SLICE_X28Y39",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => clk2x_o_OBUF_184,
      I => dv1a_3_GND_4_o_mux_4_OUT_1_Q,
      O => dv1a_1_pack_3,
      RST => dcmrst_i_IBUF_0,
      SET => GND
    );
  NlwBlock_clock_gen_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlock_clock_gen_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;

