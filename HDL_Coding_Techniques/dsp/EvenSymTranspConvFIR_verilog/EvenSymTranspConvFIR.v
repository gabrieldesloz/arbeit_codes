//------------------------------------------------------------------------------ 
// Copyright (c) 1996-2009 Xilinx, Inc. 
// All Rights Reserved 
//------------------------------------------------------------------------------ 
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /   Company: Xilinx 
// \   \   \/    Design: EvenSymTranspConvFIR_verilog
//  \   \        Version: 1.0
//  /   /        Filename: EvenSymTranspConvFIR.v
// /___/   /\    Date Last Modified:  Feb 16, 2010
// \   \  /  \   Date Created: Feb 16, 2010
//  \___\/\___\ 
// 
// Device: Xilinx Virtex-6 () 
// Library: IEEE 
// Purpose: Symmetric Transpose Convolution Filter
//          with an Even Number of Taps Example
//          Top-level design file
// Reference: http://www.xilinx.com
// Tools: Xilinx ISE 12.1, MTI ModelSim-SE 6.3b
// Revision History: 
//    Rev 1.0 - First release, wendling, Feb 16, 2010
//------------------------------------------------------------------------------ 

module EvenSymTranspConvFIR (clk, ce, reset, din, dout);

  parameter  DataWidth  = 16;
  parameter  CoefWidth  = 16;
  parameter  NumStages  = 8;		// must be even

  input                           clk;
  input                           ce;
  input                           reset;
  input  signed  [DataWidth-1:0]  din;
  output signed           [47:0]  dout;
  
  reg  [31:0] Coeffs [0:NumStages/2-1];
  
  initial
  begin
    Coeffs[0] =    761;   // Stages: 3 and 4
    Coeffs[1] =      6;	  // Stages: 2 and 5
    Coeffs[2] =  -5388;	  // Stages: 1 and 6
    Coeffs[3] =  27303;	  // Stages: 0 and 7
  end

  wire signed  [CoefWidth-1:0] bin_bus   [0:NumStages/2-1];
  wire signed  [DataWidth-1:0] acout_bus [0:NumStages/2];
  wire signed           [47:0] dout_bus  [0:NumStages/2];
  
  wire gnd48 = 48'b0;
  
  assign dout_bus[0]  = gnd48;
  assign acout_bus[0] = din;
  
  assign dout = dout_bus[NumStages/2];

  generate
  genvar i;
  
    for (i = 0; i <= NumStages/2-1; i = i+1)
    begin : L0
    
      assign bin_bus[i] = $signed(Coeffs[i]);

      DelayLine #(
        .Depth(2),
        .Width(DataWidth)
      ) U1 (
        .clk(clk),
        .ce(ce),
        .din(acout_bus[i]),
        .dout(acout_bus[i+1])
      );

      FilterStage #(
        .DataWidth(DataWidth),
        .CoefWidth(CoefWidth)
      ) U2 (
        .clk(clk),
        .ce(ce),
        .reset(reset),
        .ain(acout_bus[i+1]),
        .bin(bin_bus[i]),
        .din(din),
        .cin(dout_bus[i]),
        .dout(dout_bus[i+1])
      );

    end;  
  endgenerate;  
  
endmodule
