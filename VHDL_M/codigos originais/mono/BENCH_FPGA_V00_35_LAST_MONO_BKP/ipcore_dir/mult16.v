////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: M.53d
//  \   \         Application: netgen
//  /   /         Filename: mult16.v
// /___/   /\     Timestamp: Wed Oct 27 16:35:56 2010
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog ./tmp/_cg\mult16.ngc ./tmp/_cg\mult16.v 
// Device	: 6slx16ftg256-2
// Input file	: ./tmp/_cg/mult16.ngc
// Output file	: ./tmp/_cg/mult16.v
// # of Modules	: 1
// Design Name	: mult16
// Xilinx        : C:\Xilinx\12.1\ISE_DS\ISE
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module mult16 (
  ce, clk, a, b, p
)/* synthesis syn_black_box syn_noprune=1 */;
  input ce;
  input clk;
  input [15 : 0] a;
  input [15 : 0] b;
  output [31 : 0] p;
  
  // synthesis translate_off
  
  wire \blk00000003/sig00000044 ;
  wire \blk00000003/sig00000023 ;
  wire NLW_blk00000001_P_UNCONNECTED;
  wire NLW_blk00000002_G_UNCONNECTED;
  wire \NLW_blk00000003/blk00000006_CARRYOUTF_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_CARRYOUT_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_BCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCIN<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_P<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<47>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<46>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<45>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<44>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<43>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<42>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<41>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<40>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<39>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<38>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<37>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<36>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<32>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<31>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<30>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<29>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<28>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<27>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<26>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<25>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<24>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<23>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<22>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<21>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<20>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<19>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<18>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<17>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<16>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<15>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<14>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<13>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<12>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<11>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<10>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<9>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<8>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<7>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<6>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<5>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<4>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<3>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<2>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<1>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_PCOUT<0>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<35>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<34>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<33>_UNCONNECTED ;
  wire \NLW_blk00000003/blk00000006_M<32>_UNCONNECTED ;
  wire [15 : 0] a_0;
  wire [15 : 0] b_1;
  wire [31 : 0] p_2;
  assign
    a_0[15] = a[15],
    a_0[14] = a[14],
    a_0[13] = a[13],
    a_0[12] = a[12],
    a_0[11] = a[11],
    a_0[10] = a[10],
    a_0[9] = a[9],
    a_0[8] = a[8],
    a_0[7] = a[7],
    a_0[6] = a[6],
    a_0[5] = a[5],
    a_0[4] = a[4],
    a_0[3] = a[3],
    a_0[2] = a[2],
    a_0[1] = a[1],
    a_0[0] = a[0],
    b_1[15] = b[15],
    b_1[14] = b[14],
    b_1[13] = b[13],
    b_1[12] = b[12],
    b_1[11] = b[11],
    b_1[10] = b[10],
    b_1[9] = b[9],
    b_1[8] = b[8],
    b_1[7] = b[7],
    b_1[6] = b[6],
    b_1[5] = b[5],
    b_1[4] = b[4],
    b_1[3] = b[3],
    b_1[2] = b[2],
    b_1[1] = b[1],
    b_1[0] = b[0],
    p[31] = p_2[31],
    p[30] = p_2[30],
    p[29] = p_2[29],
    p[28] = p_2[28],
    p[27] = p_2[27],
    p[26] = p_2[26],
    p[25] = p_2[25],
    p[24] = p_2[24],
    p[23] = p_2[23],
    p[22] = p_2[22],
    p[21] = p_2[21],
    p[20] = p_2[20],
    p[19] = p_2[19],
    p[18] = p_2[18],
    p[17] = p_2[17],
    p[16] = p_2[16],
    p[15] = p_2[15],
    p[14] = p_2[14],
    p[13] = p_2[13],
    p[12] = p_2[12],
    p[11] = p_2[11],
    p[10] = p_2[10],
    p[9] = p_2[9],
    p[8] = p_2[8],
    p[7] = p_2[7],
    p[6] = p_2[6],
    p[5] = p_2[5],
    p[4] = p_2[4],
    p[3] = p_2[3],
    p[2] = p_2[2],
    p[1] = p_2[1],
    p[0] = p_2[0];
  VCC   blk00000001 (
    .P(NLW_blk00000001_P_UNCONNECTED)
  );
  GND   blk00000002 (
    .G(NLW_blk00000002_G_UNCONNECTED)
  );
  DSP48A1 #(
    .CARRYINSEL ( "OPMODE5" ),
    .RSTTYPE ( "SYNC" ),
    .PREG ( 0 ),
    .A0REG ( 0 ),
    .A1REG ( 0 ),
    .B0REG ( 0 ),
    .MREG ( 1 ),
    .CARRYINREG ( 0 ),
    .OPMODEREG ( 0 ),
    .CARRYOUTREG ( 0 ),
    .B1REG ( 0 ),
    .CREG ( 0 ),
    .DREG ( 0 ))
  \blk00000003/blk00000006  (
    .CECARRYIN(\blk00000003/sig00000023 ),
    .RSTC(\blk00000003/sig00000023 ),
    .RSTCARRYIN(\blk00000003/sig00000023 ),
    .CED(\blk00000003/sig00000023 ),
    .RSTD(\blk00000003/sig00000023 ),
    .CEOPMODE(\blk00000003/sig00000023 ),
    .CEC(\blk00000003/sig00000023 ),
    .CARRYOUTF(\NLW_blk00000003/blk00000006_CARRYOUTF_UNCONNECTED ),
    .RSTOPMODE(\blk00000003/sig00000023 ),
    .RSTM(\blk00000003/sig00000023 ),
    .CLK(clk),
    .RSTB(\blk00000003/sig00000023 ),
    .CEM(ce),
    .CEB(\blk00000003/sig00000023 ),
    .CARRYIN(\blk00000003/sig00000023 ),
    .CEP(\blk00000003/sig00000023 ),
    .CEA(\blk00000003/sig00000023 ),
    .CARRYOUT(\NLW_blk00000003/blk00000006_CARRYOUT_UNCONNECTED ),
    .RSTA(\blk00000003/sig00000023 ),
    .RSTP(\blk00000003/sig00000023 ),
    .B({\blk00000003/sig00000023 , \blk00000003/sig00000023 , b_1[15], b_1[14], b_1[13], b_1[12], b_1[11], b_1[10], b_1[9], b_1[8], b_1[7], b_1[6], 
b_1[5], b_1[4], b_1[3], b_1[2], b_1[1], b_1[0]}),
    .BCOUT({\NLW_blk00000003/blk00000006_BCOUT<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<14>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<13>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<12>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<8>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<7>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<6>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<2>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_BCOUT<1>_UNCONNECTED , \NLW_blk00000003/blk00000006_BCOUT<0>_UNCONNECTED }),
    .PCIN({\NLW_blk00000003/blk00000006_PCIN<47>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<46>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<45>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<44>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<43>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<42>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<41>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<40>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<39>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<38>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<37>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<36>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<32>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<31>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<30>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<29>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<28>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<27>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<26>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<25>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<24>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<23>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<22>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<21>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<20>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<19>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<18>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<14>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<13>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<12>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<8>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<7>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<6>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<2>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCIN<1>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCIN<0>_UNCONNECTED }),
    .C({\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 }),
    .P({\NLW_blk00000003/blk00000006_P<47>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<46>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<45>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<44>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<43>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<42>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<41>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<40>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<39>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<38>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<37>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<36>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<32>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<31>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<30>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<29>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<28>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<27>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<26>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<25>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<24>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<23>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<22>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<21>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<20>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<19>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<18>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<14>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<13>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<12>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<8>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<7>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<6>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<2>_UNCONNECTED , \NLW_blk00000003/blk00000006_P<1>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_P<0>_UNCONNECTED }),
    .OPMODE({\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000044 }),
    .D({\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 , 
\blk00000003/sig00000023 , \blk00000003/sig00000023 , \blk00000003/sig00000023 }),
    .PCOUT({\NLW_blk00000003/blk00000006_PCOUT<47>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<46>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<45>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<44>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<43>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<42>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<41>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<40>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<39>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<38>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<37>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<36>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<32>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<31>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<30>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<29>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<28>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<27>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<26>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<25>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<24>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<23>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<22>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<21>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<20>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<19>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<18>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<17>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<16>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<15>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<14>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<13>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<12>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<11>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<10>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<9>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<8>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<7>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<6>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<5>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<4>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<3>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<2>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_PCOUT<1>_UNCONNECTED , \NLW_blk00000003/blk00000006_PCOUT<0>_UNCONNECTED }),
    .A({\blk00000003/sig00000023 , \blk00000003/sig00000023 , a_0[15], a_0[14], a_0[13], a_0[12], a_0[11], a_0[10], a_0[9], a_0[8], a_0[7], a_0[6], 
a_0[5], a_0[4], a_0[3], a_0[2], a_0[1], a_0[0]}),
    .M({\NLW_blk00000003/blk00000006_M<35>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<34>_UNCONNECTED , 
\NLW_blk00000003/blk00000006_M<33>_UNCONNECTED , \NLW_blk00000003/blk00000006_M<32>_UNCONNECTED , p_2[31], p_2[30], p_2[29], p_2[28], p_2[27], p_2[26]
, p_2[25], p_2[24], p_2[23], p_2[22], p_2[21], p_2[20], p_2[19], p_2[18], p_2[17], p_2[16], p_2[15], p_2[14], p_2[13], p_2[12], p_2[11], p_2[10], 
p_2[9], p_2[8], p_2[7], p_2[6], p_2[5], p_2[4], p_2[3], p_2[2], p_2[1], p_2[0]})
  );
  VCC   \blk00000003/blk00000005  (
    .P(\blk00000003/sig00000044 )
  );
  GND   \blk00000003/blk00000004  (
    .G(\blk00000003/sig00000023 )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

// synthesis translate_on
