onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /adder_ovf_tb/adder_ovf_1/sysclk
add wave -noupdate /adder_ovf_tb/adder_ovf_1/done_o
add wave -noupdate /adder_ovf_tb/adder_ovf_1/done_o_next
add wave -noupdate /adder_ovf_tb/adder_ovf_1/done_o_reg
add wave -noupdate /adder_ovf_tb/adder_ovf_1/ovf_o
add wave -noupdate /adder_ovf_tb/adder_ovf_1/ovf_sign_next
add wave -noupdate /adder_ovf_tb/adder_ovf_1/ovf_sign_reg
add wave -noupdate /adder_ovf_tb/adder_ovf_1/reset_n
add wave -noupdate /adder_ovf_tb/adder_ovf_1/start_calc_i
add wave -noupdate /adder_ovf_tb/adder_ovf_1/state_next
add wave -noupdate /adder_ovf_tb/adder_ovf_1/state_reg
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/sum_tmp_next
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/sum_tmp_reg
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_1_i
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_1_reg
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_2_i
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_2_reg
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_3_i
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_3_reg
add wave -noupdate -radix decimal /adder_ovf_tb/adder_ovf_1/val_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {5250 us}
