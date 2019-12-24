onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /serial_comm_jiga_tb/sending_state_machine/time_counter
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/s_state
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/uC_REQUEST_i
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/uC_FPGA_SELECT_i
add wave -noupdate -expand -group {uC Commands} -radix hexadecimal /serial_comm_jiga_tb/FPGA1_1/uC_COMMAND_i
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/uC_DATA_i
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/DATA_TO_uC_RECEIVED_i
add wave -noupdate -expand -group {uC Commands} /serial_comm_jiga_tb/FPGA1_1/DATA_TO_uC_READY_o
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} -radix hexadecimal -childformat {{/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(7) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(6) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(5) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(4) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(3) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(2) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(1) -radix hexadecimal} {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(0) -radix hexadecimal}} -subitemconfig {/serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(7) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(6) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(5) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(4) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(3) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(2) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(1) {-height 18 -radix hexadecimal} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i(0) {-height 18 -radix hexadecimal}} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_i
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} -radix hexadecimal /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_2_o
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_SENT_1_2_i
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_FAIL_1_2_i
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_READY_1_2_i
add wave -noupdate -expand -group {Serial Signals FPGA 1 - 2} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SEND_PACKET_1_2_o
add wave -noupdate -group {Serial Signals FPGA 1- 3} -radix hexadecimal /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_3_i
add wave -noupdate -group {Serial Signals FPGA 1- 3} -radix hexadecimal /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SERIAL_DATA_1_3_o
add wave -noupdate -group {Serial Signals FPGA 1- 3} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_SENT_1_3_i
add wave -noupdate -group {Serial Signals FPGA 1- 3} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_FAIL_1_3_i
add wave -noupdate -group {Serial Signals FPGA 1- 3} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/PACKET_READY_1_3_i
add wave -noupdate -group {Serial Signals FPGA 1- 3} /serial_comm_jiga_tb/FPGA1_1/i_MASTER_SERIAL_COMMANDS/SEND_PACKET_1_3_o
add wave -noupdate -expand -group {Serial Commands FPGA 2} -radix hexadecimal /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/SERIAL_DATA_i
add wave -noupdate -expand -group {Serial Commands FPGA 2} -radix hexadecimal /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/SERIAL_DATA_o
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/PACKET_SENT_i
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/PACKET_FAIL_i
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/PACKET_READY_i
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/SEND_PACKET_o
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/s_state
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/s_end_cmd
add wave -noupdate -expand -group {Serial Commands FPGA 2} /serial_comm_jiga_tb/FPGA2_1/i_SERIAL_COMMANDS/s_receiving
add wave -noupdate -expand -label sim:/serial_comm_jiga_tb/FPGA1_1/Group1 -group {Region: sim:/serial_comm_jiga_tb/FPGA1_1} /serial_comm_jiga_tb/FPGA1_1/FPGA_2_VERSION_o
add wave -noupdate -expand -label sim:/serial_comm_jiga_tb/FPGA1_1/Group1 -group {Region: sim:/serial_comm_jiga_tb/FPGA1_1} /serial_comm_jiga_tb/FPGA1_1/FPGA_3_VERSION_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3877417 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3150 us}
