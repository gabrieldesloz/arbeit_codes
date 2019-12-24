onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/sysclk
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/reset_n
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_i
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_o
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_available_i
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/ready
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/state_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/state_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_input_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_input_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_available_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/data_available_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/read_req_i
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/write_req_i
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/sample_i
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/sample_o
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/writing_o
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/reading_o
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/read_counter_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/read_counter_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/do_acc
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/acc_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/acc_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/ok_div_next
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/ok_div_reg
add wave -noupdate /arith_ctrl_tb/arith_ctrl_1/clear_acc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1153 ns} 0} {{Cursor 2} {13602 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {20 us}
