onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/sysclk
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/reset_n
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/ready
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/one_division_done
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/data_input_o
add wave -noupdate -expand -group {Top Level
} -radix decimal -childformat {{/arith_ctrl_tb/data_input_i(31) -radix decimal} {/arith_ctrl_tb/data_input_i(30) -radix decimal} {/arith_ctrl_tb/data_input_i(29) -radix decimal} {/arith_ctrl_tb/data_input_i(28) -radix decimal} {/arith_ctrl_tb/data_input_i(27) -radix decimal} {/arith_ctrl_tb/data_input_i(26) -radix decimal} {/arith_ctrl_tb/data_input_i(25) -radix decimal} {/arith_ctrl_tb/data_input_i(24) -radix decimal} {/arith_ctrl_tb/data_input_i(23) -radix decimal} {/arith_ctrl_tb/data_input_i(22) -radix decimal} {/arith_ctrl_tb/data_input_i(21) -radix decimal} {/arith_ctrl_tb/data_input_i(20) -radix decimal} {/arith_ctrl_tb/data_input_i(19) -radix decimal} {/arith_ctrl_tb/data_input_i(18) -radix decimal} {/arith_ctrl_tb/data_input_i(17) -radix decimal} {/arith_ctrl_tb/data_input_i(16) -radix decimal} {/arith_ctrl_tb/data_input_i(15) -radix decimal} {/arith_ctrl_tb/data_input_i(14) -radix decimal} {/arith_ctrl_tb/data_input_i(13) -radix decimal} {/arith_ctrl_tb/data_input_i(12) -radix decimal} {/arith_ctrl_tb/data_input_i(11) -radix decimal} {/arith_ctrl_tb/data_input_i(10) -radix decimal} {/arith_ctrl_tb/data_input_i(9) -radix decimal} {/arith_ctrl_tb/data_input_i(8) -radix decimal} {/arith_ctrl_tb/data_input_i(7) -radix decimal} {/arith_ctrl_tb/data_input_i(6) -radix decimal} {/arith_ctrl_tb/data_input_i(5) -radix decimal} {/arith_ctrl_tb/data_input_i(4) -radix decimal} {/arith_ctrl_tb/data_input_i(3) -radix decimal} {/arith_ctrl_tb/data_input_i(2) -radix decimal} {/arith_ctrl_tb/data_input_i(1) -radix decimal} {/arith_ctrl_tb/data_input_i(0) -radix decimal}} -subitemconfig {/arith_ctrl_tb/data_input_i(31) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(30) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(29) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(28) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(27) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(26) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(25) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(24) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(23) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(22) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(21) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(20) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(19) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(18) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(17) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(16) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(15) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(14) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(13) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(12) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(11) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(10) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(9) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(8) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(7) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(6) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(5) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(4) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(3) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(2) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(1) {-height 15 -radix decimal} /arith_ctrl_tb/data_input_i(0) {-height 15 -radix decimal}} /arith_ctrl_tb/data_input_i
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/data_available_i
add wave -noupdate -expand -group {Top Level
} -radix decimal /arith_ctrl_tb/d_ana_proc_o
add wave -noupdate -expand -group {Top Level
} /arith_ctrl_tb/SYS_CLK_PERIOD
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/write_req_i
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/sample_i
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/data_input_reg
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/data_available_reg
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/data_input_i
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/data_available_i
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/read_req_i
add wave -noupdate -expand -group {Arith_ctrl
} /arith_ctrl_tb/DUT/read_counter_reg
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/do_acc
add wave -noupdate -expand -group {Arith_ctrl
} -radix decimal /arith_ctrl_tb/DUT/acc_reg
add wave -noupdate -expand -group {Arith_ctrl
} /arith_ctrl_tb/DUT/state_reg
add wave -noupdate -expand -group {Arith_ctrl
} /arith_ctrl_tb/DUT/ok_div_reg
add wave -noupdate -expand -group {Arith_ctrl
} /arith_ctrl_tb/DUT/clear_acc
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/writing_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/writing_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/write_ptr_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/write_ptr_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/state_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/state_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_out_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_out_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/reading_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/reading_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/read_ptr_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/read_ptr_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/mem_ptr_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/mem_ptr_next
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/m_freq_mem
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/m_freq_buffer
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/f_write
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/writing_o
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_o
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/reading_o
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/write_req_i
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sysclk
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_i
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/reset_n
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/SAMPLE_SIZE
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/MEM_BUFFER_SIZE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12760 ns} 0}
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
