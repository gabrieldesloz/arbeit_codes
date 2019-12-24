puts "-- Simulation script (c) ALSE for QUAD encoder --"

vlib work

vcom -93 quad.vhd
vcom -93 quad_tb.vhd

vsim quad_tb

add wave -divider "QUAD (c) ALSE"
add wave  A
add wave  B
add wave -divider "Outputs :"
add wave  Dir
add wave  -radix decimal Cnt

run -a
