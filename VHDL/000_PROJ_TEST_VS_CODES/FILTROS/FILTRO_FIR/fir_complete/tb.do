#******************************************************************************
#                                                                             *
#                  Copyright (C) 2016 IFSC                                    *
#                                                                             *
#                                                                             *
# All information provided herein is provided on an "as is" basis,            *
# without warranty of any kind.                                               *
#                                                                             *
# File Name: tb.do          							    				  *
#                                                                             *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 0.1.0    25/02/2017 - Initial Revision                            *
#******************************************************************************

vlib work
vcom input_ram.vhd register.vhd counter.vhd accumulator.vhd mult.vhd fir_control.vhd fir.vhd testbench.vhd

vsim -t ns work.testbench

# view wave
add wave -radix binary /clk
add wave -radix binary /rst

add wave -label state /fir_1/controller/filter
add wave -label samples /fir_1/controller/samples

add wave -radix hex -label coef /fir_1/coef_array
add wave -radix hex -label mul /fir_1/mul_array
add wave -radix hex -label acc /fir_1/acc_array

# add wave -radix hex -label accm /fir_1/accm
# add wave -radix hex /fir_1/product_0_reg
# add wave -radix hex /fir_1/product_1_reg

add wave /fir_1/acc_en

add wave -radix hex /data

add wave -radix dec  /address

add wave -radix hex -label y /fir_1/y
add wave -radix hex -label y_o /fir_1/y_out

add wave /valid
add wave /done

vcd file waveform.vcd
vcd add -r /*

run 2 us

wave zoomfull
