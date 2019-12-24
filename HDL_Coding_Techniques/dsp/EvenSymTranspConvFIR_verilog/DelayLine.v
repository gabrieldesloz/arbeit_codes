//------------------------------------------------------------------------------ 
// Copyright (c) 1996-2010 Xilinx, Inc. 
// All Rights Reserved 
//------------------------------------------------------------------------------ 
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /   Company: Xilinx 
// \   \   \/    Design: EvenSymTranspConvFIR_verilog
//  \   \        Version: 1.0
//  /   /        Filename: DelayLine.v
// /___/   /\    Date Last Modified:  Feb 16, 2010
// \   \  /  \   Date Created: Feb 16, 2010
//  \___\/\___\ 
// 
// Device: Xilinx Virtex-6 () 
// Library: IEEE 
// Purpose: Symmetric Transpose Convolution Filter
//          with an Even Number of Taps Example
//          Sub-level design file
// Reference: http://www.xilinx.com
// Tools: Xilinx ISE 12.1, MTI ModelSim-SE 6.3b
// Revision History: 
//    Rev 1.0 - First release, wendling, Feb 16, 2010 
//------------------------------------------------------------------------------ 

module DelayLine (clk, ce, din, dout);

  parameter  Depth  = 2;
  parameter  Width  = 16;

  input                       clk;
  input                       ce;
  input  signed  [Width-1:0]  din;
  output signed  [Width-1:0]  dout;
  
  reg  [Width-1:0]  DataBuffer [0:Depth];

  assign dout = DataBuffer[Depth];

  always @(din)
    DataBuffer[0] <= din;  
  
  generate
  genvar i;
    for (i = 1; i <= Depth; i = i+1)
    begin: delay
      always @(posedge clk)
      begin
        if (ce)
          DataBuffer[i] <= DataBuffer[i-1];
      end    
    end
  endgenerate

  
endmodule
