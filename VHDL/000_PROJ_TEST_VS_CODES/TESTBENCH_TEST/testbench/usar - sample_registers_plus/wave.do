onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {TESTBENCH
} /generic_tb/NIOS_CLK_PERIOD
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/SYS_CLK_PERIOD
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/SAMPLE_CLK_PERIOD
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/PERIOD_CLK_PPS
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sysclk
add wave -noupdate -group {TESTBENCH
} /generic_tb/clock_pps_sync
add wave -noupdate -group {TESTBENCH
} /generic_tb/nios_clk_sync
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/reset_n
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/data_input
add wave -noupdate -group {TESTBENCH
} /generic_tb/sample_clk_sync
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/data_input_available
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_writedata
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_write
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_readdata
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_read
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_irq
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_chipselect
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/sample_address
add wave -noupdate -group {TESTBENCH
} -radix unsigned /generic_tb/pps_input
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/reset_n
add wave -noupdate -group {sample_register_plus
} -radix unsigned -childformat {{/generic_tb/sample_register_1/REGISTERS(19) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(18) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(17) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(16) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(15) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(14) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(13) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(12) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(11) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(10) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(9) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(8) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(7) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(6) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(5) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(4) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(3) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(2) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(1) -radix unsigned} {/generic_tb/sample_register_1/REGISTERS(0) -radix unsigned}} -subitemconfig {/generic_tb/sample_register_1/REGISTERS(19) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(18) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(17) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(16) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(15) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(14) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(13) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(12) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(11) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(10) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(9) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(8) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(7) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(6) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(5) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(4) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(3) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(2) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(1) {-height 15 -radix unsigned} /generic_tb/sample_register_1/REGISTERS(0) {-height 15 -radix unsigned}} /generic_tb/sample_register_1/REGISTERS
add wave -noupdate -group {sample_register_plus
} -group {FSM - PPS flag
} -radix unsigned /generic_tb/sample_register_1/state_pps_reg
add wave -noupdate -group {sample_register_plus
} -group {FSM - PPS flag
} -radix unsigned /generic_tb/sample_register_1/pps_pulse_reg
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/counter_samples_reg
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/sample_state
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/input_register
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/wr_en
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/rd_en
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/irq
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/counter
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/started
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/status_reg
add wave -noupdate -group {sample_register_plus
} -radix unsigned /generic_tb/sample_register_1/control_reg
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_readdata
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_writedata
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_write
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_read
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_chipselect
add wave -noupdate -group {INTERFACE
} /generic_tb/sample_register_1/avs_address
add wave -noupdate -group {fifo
} /generic_tb/sample_register_1/sample_register_fifo_1/sub_wire0
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/q
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/wrreq
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/wrclk
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/rdreq
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/rdclk
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/data
add wave -noupdate -group {fifo
} -radix unsigned /generic_tb/sample_register_1/sample_register_fifo_1/aclr
add wave -noupdate -expand -group {DUAL_RAM} /generic_tb/sample_register_1/addr_a_tmp
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/addr_a
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/addr_b
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/data_a
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/data_b
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/we_a
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/we_b
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/q_a
add wave -noupdate -expand -group {DUAL_RAM} -radix unsigned /generic_tb/sample_register_1/true_dual_port_ram_dual_clock_1/q_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2781544 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 183
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
WaveRestoreZoom {0 ns} {21 ms}
