onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /full_adder_tb/a
add wave -noupdate /full_adder_tb/b
add wave -noupdate /full_adder_tb/c
add wave -noupdate /full_adder_tb/cin
add wave -noupdate /full_adder_tb/cin1
add wave -noupdate /full_adder_tb/cout
add wave -noupdate /full_adder_tb/cout1
add wave -noupdate /full_adder_tb/overflow
add wave -noupdate /full_adder_tb/overflow1
add wave -noupdate /full_adder_tb/sign
add wave -noupdate /full_adder_tb/sign1
add wave -noupdate /full_adder_tb/sum
add wave -noupdate /full_adder_tb/sum1
add wave -noupdate /full_adder_tb/zero
add wave -noupdate /full_adder_tb/zero1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {5250 us}
