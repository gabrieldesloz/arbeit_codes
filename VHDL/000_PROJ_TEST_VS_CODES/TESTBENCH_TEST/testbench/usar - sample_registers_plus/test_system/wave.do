onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/data_output
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/data_ready
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/clk
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/reset_n
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/address
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/byteenable
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/writedata
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/write
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/chipselect
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/sysclk
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/data_input
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/data_available
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/addr_avalon
add wave -noupdate -expand -group {Gain Registers} -radix unsigned /test_system_tb/gain_registers_tb_1/clock
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/coe_data_input
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/coe_data_output
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/coe_data_ready_in
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/coe_data_ready_out
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/sysclk
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/clock_linux
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/clock_stim
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/clock_stim_b
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/reset_n
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_read
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_address
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_chipselect
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_write
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_writedata
add wave -noupdate -expand -group {Phase Sum Board 1 } -radix unsigned /test_system_tb/board1/avs_readdata
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/coe_data_input
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/coe_data_output
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/coe_data_ready_in
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/coe_data_ready_out
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/sysclk
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/clock_linux
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/clock_stim
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/clock_stim_b
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/reset_n
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_read
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_address
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_chipselect
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_write
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_writedata
add wave -noupdate -expand -group {Phase Sum Board 2} -radix unsigned /test_system_tb/board2/avs_readdata
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/data_in
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/data_in_available
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/clk
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/reset_n
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/address
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/byteenable
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/writedata
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/write
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/chipselect
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/sysclk
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/data_out
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/data_out_ready
add wave -noupdate -expand -group {Sample Adjust} -radix unsigned /test_system_tb/sample_adjust_tb_1/clock
add wave -noupdate -expand -group {Top Level} /test_system_tb/coe_data_ready_out2
add wave -noupdate -expand -group {Top Level} /test_system_tb/data_ready
add wave -noupdate -expand -group {Top Level} /test_system_tb/coe_data_ready_out1
add wave -noupdate -expand -group {Top Level} /test_system_tb/data_in_available
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {408709052 ps} 0}
configure wave -namecolwidth 357
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
WaveRestoreZoom {36092480589 ps} {40205658917 ps}
