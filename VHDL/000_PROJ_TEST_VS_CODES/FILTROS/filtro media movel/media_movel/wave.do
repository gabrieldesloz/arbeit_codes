onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group test_bench -radix decimal /generic_tb/writing
add wave -noupdate -group test_bench -radix decimal /generic_tb/write_req_i
add wave -noupdate -group test_bench -radix decimal /generic_tb/sysclk
add wave -noupdate -group test_bench -radix decimal /generic_tb/sample_out
add wave -noupdate -group test_bench -radix decimal /generic_tb/sample_i
add wave -noupdate -group test_bench -radix decimal /generic_tb/sample_clk_sync
add wave -noupdate -group test_bench -radix decimal /generic_tb/sample_clk
add wave -noupdate -group test_bench -radix decimal /generic_tb/reset_n
add wave -noupdate -group test_bench -radix decimal /generic_tb/reading
add wave -noupdate -group test_bench -radix decimal /generic_tb/read_req_i
add wave -noupdate -group test_bench -radix decimal /generic_tb/data_input_available
add wave -noupdate -group test_bench -radix decimal /generic_tb/data_input
add wave -noupdate -expand -group {filter
} -radix decimal /generic_tb/circular_buffer_1/state_reg
add wave -noupdate -expand -group {filter
} -radix decimal /generic_tb/circular_buffer_1/writing_reg
add wave -noupdate -expand -group {filter
} -radix decimal /generic_tb/circular_buffer_1/reading_reg
add wave -noupdate -expand -group {filter
} -radix decimal -childformat {{/generic_tb/circular_buffer_1/m_freq_buffer(0) -radix decimal} {/generic_tb/circular_buffer_1/m_freq_buffer(1) -radix decimal} {/generic_tb/circular_buffer_1/m_freq_buffer(2) -radix decimal} {/generic_tb/circular_buffer_1/m_freq_buffer(3) -radix decimal}} -expand -subitemconfig {/generic_tb/circular_buffer_1/m_freq_buffer(0) {-height 15 -radix decimal} /generic_tb/circular_buffer_1/m_freq_buffer(1) {-height 15 -radix decimal} /generic_tb/circular_buffer_1/m_freq_buffer(2) {-height 15 -radix decimal} /generic_tb/circular_buffer_1/m_freq_buffer(3) {-height 15 -radix decimal}} /generic_tb/circular_buffer_1/m_freq_buffer
add wave -noupdate -expand -group {filter
} -radix decimal /generic_tb/circular_buffer_1/sample_reg
add wave -noupdate -expand -group {filter
} /generic_tb/circular_buffer_1/f_write
add wave -noupdate /generic_tb/circular_buffer_1/read_req_i
add wave -noupdate -radix decimal /generic_tb/circular_buffer_1/m_freq_mem
add wave -noupdate -radix decimal /generic_tb/circular_buffer_1/sample_out_reg
add wave -noupdate /generic_tb/circular_buffer_1/write_ptr_reg
add wave -noupdate /generic_tb/circular_buffer_1/read_ptr_reg
add wave -noupdate /generic_tb/circular_buffer_1/writing_reg
add wave -noupdate /generic_tb/circular_buffer_1/reading_reg
add wave -noupdate /generic_tb/circular_buffer_1/mem_ptr_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6779045 ns} 0}
configure wave -namecolwidth 153
configure wave -valuecolwidth 77
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
WaveRestoreZoom {0 ns} {18029376 ns}
