onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /generic_tb/divider_1/sysclk
add wave -noupdate -radix decimal /generic_tb/divider_1/n_reset
add wave -noupdate -radix decimal /generic_tb/divider_1/start
add wave -noupdate -radix decimal /generic_tb/divider_1/num
add wave -noupdate -radix decimal /generic_tb/divider_1/den
add wave -noupdate -radix decimal /generic_tb/divider_1/quo
add wave -noupdate -radix decimal /generic_tb/divider_1/rema
add wave -noupdate -radix decimal /generic_tb/divider_1/ready
add wave -noupdate -radix decimal /generic_tb/divider_1/state_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/state_next
add wave -noupdate -radix decimal /generic_tb/divider_1/shift_vector_next
add wave -noupdate -radix decimal /generic_tb/divider_1/shift_vector_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/b_next
add wave -noupdate -radix decimal /generic_tb/divider_1/b_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/i_count_next
add wave -noupdate -radix decimal /generic_tb/divider_1/i_count_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/den_sign_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/den_sign_next
add wave -noupdate -radix decimal /generic_tb/divider_1/num_sign_reg
add wave -noupdate -radix decimal /generic_tb/divider_1/num_sign_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1868171 ps} 0}
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
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {9998731889 ps} {10000066743 ps}
