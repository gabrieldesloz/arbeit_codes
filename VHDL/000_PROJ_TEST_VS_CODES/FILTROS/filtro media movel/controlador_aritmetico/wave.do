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
} -radix decimal /arith_ctrl_tb/DUT/data_i
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
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/write_ptr_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/state_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/sample_out_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/reading_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/read_ptr_reg
add wave -noupdate -expand -group {Circular_Buffer
} -radix decimal /arith_ctrl_tb/DUT/circular_buffer_1/mem_ptr_reg
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
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/start_div_i
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/quo_int
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/state_reg
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/ready_data_o
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/one_division_done
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/start_div_reg
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/start_div
add wave -noupdate -expand -group {Mux Divider 2
} -expand -group {main signals} -radix decimal /arith_ctrl_tb/divider_mux_1/ready_div
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/ready_data_o_reg
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/quo_addr_ptr_reg
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/num_addr_ptr_reg
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/done_reg
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/done_next
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/den_addr_ptr_reg
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/den_addr_ptr_next
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/d_ana_i_array_num_int
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/d_ana_i_array_den_int
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/D_ANA_O_ARRAY
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/D_ANA_I_ARRAY
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/d_ana_proc_o
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/sysclk
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/n_reset
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/d_ana_i
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/N_CHANNELS_ANA
add wave -noupdate -expand -group {Mux Divider 2
} -radix decimal /arith_ctrl_tb/divider_mux_1/N_BITS_ADC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12814 ns} 0} {{Cursor 2} {13602 ns} 0}
quietly wave cursor active 2
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
configure wave -timelineunits us
update
WaveRestoreZoom {11697 ns} {14499 ns}
