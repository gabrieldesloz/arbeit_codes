onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_testejet/uut2/CLK_i
add wave -noupdate -radix unsigned /tb_testejet/uut2/RESET_i
add wave -noupdate -radix unsigned /tb_testejet/uut2/EJECT_i
add wave -noupdate -radix unsigned /tb_testejet/uut2/EJECT_o
add wave -noupdate -radix unsigned /tb_testejet/uut2/state_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/state_activation_total_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/EJECT_o_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/flag_start_activation_counter_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/flag_clear_total_activation_counter_end_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_has_ejection_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_has_ejection_next
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_COUNTER_debounc_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_COUNTER_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/total_activation_counter_end_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_activation_total_reg
add wave -noupdate -radix unsigned /tb_testejet/uut2/s_activation_total_next
add wave -noupdate -radix unsigned /tb_testejet/uut2/COUNTER_debounc_MAX
add wave -noupdate -radix unsigned /tb_testejet/uut2/COUNTER_debounc_bits
add wave -noupdate -radix unsigned /tb_testejet/uut2/COUNTER_max
add wave -noupdate -radix unsigned /tb_testejet/uut2/COUNTER_bits
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_EJ_DEBOUNCE_COUNT
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_ACTIVATION_COUNT
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_ACTIVATION_COUNT_low
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_ACTIVATION_COUNT_high
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_DEAD_TIME
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_PWM_HIGH
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_PWM_LOW
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_ACTIVATION_TOTAL
add wave -noupdate -radix unsigned /tb_testejet/uut2/C_ACTIVATION_TOTAL_bits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0} {{Cursor 2} {5364222 ns} 0} {{Cursor 3} {1368014 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 410
configure wave -valuecolwidth 221
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
WaveRestoreZoom {0 ns} {21 ms}
