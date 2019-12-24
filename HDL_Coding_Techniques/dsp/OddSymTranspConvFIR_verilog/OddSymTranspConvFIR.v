//------------------------------------------------------------------------------ 
// Copyright (c) 1996-2009 Xilinx, Inc. 
// All Rights Reserved 
//------------------------------------------------------------------------------ 
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /   Company: Xilinx 
// \   \   \/    Design: OddSymTranspConvFIR_verilog
//  \   \        Version: 1.0
//  /   /        Filename: OddSymTranspConvFIR.v
// /___/   /\    Date Last Modified:  Feb 16, 2010
// \   \  /  \   Date Created: Feb 16, 2010
//  \___\/\___\ 
// 
// Device: Xilinx Virtex-6 () 
// Library: IEEE 
// Purpose: Symmetric Transpose Convolution Filter
//          with an Odd Number of Taps Example
//          Top-level design file
// Reference: http://www.xilinx.com
// Tools: Xilinx ISE 12.1, MTI ModelSim-SE 6.3b
// Revision History: 
//    Rev 1.0 - First release, wendling, Feb 16, 2010
//------------------------------------------------------------------------------ 

module OddSymTranspConvFIR (clk, ce, reset, din, dout);

  parameter  DataWidth  = 16;
  parameter  CoefWidth  = 16;
  parameter  NumStages  = 7;		// must be odd

  input                           clk;
  input                           ce;
  input                           reset;
  input  signed  [DataWidth-1:0]  din;
  output signed           [47:0]  dout;
  
  reg  [31:0] Coeffs [0:(NumStages+1)/2-1];
  
  initial
  begin
    Coeffs[0] = (761/2);  // Stages: 3 (central stage)
	                  // Coefficient is divided by two and the related
			  // DSP stage is configured with a pre-adder 
			  // that receives this divided coefficient on
			  // both the A and D inputs
			   
    Coeffs[1] =      6;	  // Stages: 2 and 4
    Coeffs[2] =  -1676;	  // Stages: 1 and 5
    Coeffs[3] =  27303;	  // Stages: 0 and 6
  end

  wire signed  [CoefWidth-1:0] bin_bus   [0:(NumStages+1)/2-1];
  wire signed  [DataWidth-1:0] acout_bus [0:(NumStages+1)/2];
  wire signed           [47:0] dout_bus  [0:(NumStages+1)/2];
  
  wire gnd48 = 48'b0;
  
  assign dout_bus[0]  = gnd48;
  assign acout_bus[0] = din;
  assign bin_bus[0]   = $signed(Coeffs[0]);
  
  assign dout = dout_bus[(NumStages+1)/2];

  // Central tap

  DelayLine #(
      .Depth(1),
      .Width(DataWidth)
  ) U0 (
      .clk(clk),
      .ce(ce),
      .din(acout_bus[0]),
      .dout(acout_bus[1])
  );

  FilterStage #(
      .DataWidth(DataWidth),
      .CoefWidth(CoefWidth)
  ) U1 (
      .clk(clk),
      .ce(ce),
      .reset(reset),
      .ain(acout_bus[1]),
      .bin(bin_bus[0]),
      .din(din),
      .cin(dout_bus[0]),
      .dout(dout_bus[1])
  );

  // Symmetric taps
  
  generate
  genvar i;
  
    for (i = 1; i <= (NumStages+1)/2-1; i = i+1)
    begin : L0
    
      assign bin_bus[i] = $signed(Coeffs[i]);

      DelayLine #(
        .Depth(2),
        .Width(DataWidth)
      ) U2 (
        .clk(clk),
        .ce(ce),
        .din(acout_bus[i]),
        .dout(acout_bus[i+1])
      );

      FilterStage #(
        .DataWidth(DataWidth),
        .CoefWidth(CoefWidth)
      ) U3 (
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
