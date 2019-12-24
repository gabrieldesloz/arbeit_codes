onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /bfilter_tb/sysclk
add wave -noupdate -radix hexadecimal /bfilter_tb/reset_n
add wave -noupdate -radix hexadecimal /bfilter_tb/start
add wave -noupdate -radix hexadecimal /bfilter_tb/ready
add wave -noupdate -radix hexadecimal /bfilter_tb/d_ana_in
add wave -noupdate -radix hexadecimal /bfilter_tb/d_ana_out
add wave -noupdate -radix hexadecimal /bfilter_tb/clk
add wave -noupdate -radix hexadecimal /bfilter_tb/counter
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sysclk
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/reset_n
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/start
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/ready
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/d_ana_in
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/d_ana_out
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/state_bfilter
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/state_bfilter_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/d_ana_register_in
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/d_ana_register_out_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/d_ana_register_out_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/counter_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/counter_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_memory_address
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_write_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_write_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_read
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/ready_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/ready_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample1_read
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample0_read
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample1_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample1_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample0_next
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/sample0_reg
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/sysclk
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/readaddress
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/writeaddress
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/write
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/writedata
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/readdata
add wave -noupdate -radix hexadecimal /bfilter_tb/dut/bfilter_data_ram_inst_1/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 381
configure wave -valuecolwidth 184
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {26220 ps}
