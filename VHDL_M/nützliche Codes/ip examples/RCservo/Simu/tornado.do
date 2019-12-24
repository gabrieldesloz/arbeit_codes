# Simulation script for ModelSim
# (c) 2009 ALSE - http://www.alse-fr.com

vlib work
vcom ../src/servo.vhd
vcom ../src/fdiv.vhd
vcom ../src/tornado.vhd
vcom ./tornado_tb.vhd
vsim tornado_tb
add wave uut/rst
add wave uut/SW3r
add wave rcserv
add wave uut/Tick1ms uut/Start uut/Done
add wave -radix unsigned uut/Posit
run -a
