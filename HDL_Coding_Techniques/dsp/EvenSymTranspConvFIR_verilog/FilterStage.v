//------------------------------------------------------------------------------ 
// Copyright (c) 1996-2009 Xilinx, Inc. 
// All Rights Reserved 
//------------------------------------------------------------------------------ 
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /   Company: Xilinx 
// \   \   \/    Design: EvenSymTranspConvFIR_verilog
//  \   \        Version: 1.0
//  /   /        Filename: FilterStage.v
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

module FilterStage (clk, ce, reset, ain, bin, din, cin, dout);

  parameter  DataWidth  = 18;
  parameter  CoefWidth  = 18;

  input                               clk;
  input                               ce;
  input                               reset;
  input  signed      [DataWidth-1:0]  ain;
  input  signed      [CoefWidth-1:0]  bin;
  input  signed      [DataWidth-1:0]  din;
  input  signed               [47:0]  cin;
  output signed               [47:0]  dout;
  
  reg signed          [DataWidth-1:0]  din_r;
  reg signed            [DataWidth:0]  preadd_r;
  reg signed  [DataWidth+CoefWidth:0]  mult_r;
  reg signed                   [47:0]  sum_r;
  
  assign dout = sum_r;
  
  always @(posedge clk)
  begin
    if (reset)
    begin
      din_r <= 0;
      preadd_r <= 0;
      mult_r <= 0;
      sum_r <= 0;
    end
    else if (ce)
    begin
      din_r    <= din;
      preadd_r <= ain + din_r;
      mult_r   <= preadd_r * bin;
      sum_r    <= mult_r + cin;
    end
  end
  
endmodule
