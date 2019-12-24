# Simulation script for ModelSim
# (c) 2009 ALSE - http://www.alse-fr.com

vlib work
vcom ../src/servo.vhd
vcom ./servo_tb.vhd
vsim servo_tb
add wave rst clk Tick7us
add wave -radix hexadecimal Posit
add wave Start Done Q
add wave uut/Count
run -a
