onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/CLK_i
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/DATA_RX_i
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/DATA_TX_o
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/EOP_o
add wave -noupdate -expand -group Master -childformat {{/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(7) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(6) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(5) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(4) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(3) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(2) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(1) -radix hexadecimal} {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(0) -radix hexadecimal}} -subitemconfig {/comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(7) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(6) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(5) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(4) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(3) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(2) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(1) {-radix hexadecimal} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o(0) {-radix hexadecimal}} /comm_tb/EJ_SERIAL_MASTER_1/RECEIVED_DATA_o
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/RST_i
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/SEND_DATA_i
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/SOP_o
add wave -noupdate -expand -group Master /comm_tb/EJ_SERIAL_MASTER_1/SYNC_CLK_o
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/DATA_RX_i
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/SEND_DATA_i
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/SYNC_CLK_i
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/RST_i
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/RECEIVED_DATA_o
add wave -noupdate -expand -group Serial /comm_tb/EJ_SERIAL_SLAVE_1/DATA_TX_o
add wave -noupdate /comm_tb/mux_1/fsm_state_reg
add wave -noupdate /comm_tb/mux_1/mux_i
add wave -noupdate /comm_tb/mux_1/not_mux_i_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1410593574 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {5468639579 ps} {5552677884 ps}
