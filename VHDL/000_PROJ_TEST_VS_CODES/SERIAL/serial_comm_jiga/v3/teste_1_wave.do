onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {TX jiga FPGA1} -radix hexadecimal /serial_comm_jiga_tb/SERIAL_TX_1/TX_DATA_i
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/SEND_i
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/PACKET_SENT_o
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/CLK_i
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/CLK_EN_i
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/RST_i
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/TX_o
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/s_finish_packet
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/s_send_packet
add wave -noupdate -expand -group {TX jiga FPGA1} /serial_comm_jiga_tb/SERIAL_TX_1/s_send_state_machine
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/PACKET_READY_o
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/FAIL_o
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/RX_i
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/CLK_i
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/CLK_EN_i
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/RST_i
add wave -noupdate -expand -group {RX FPGA2} -radix hexadecimal /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/RX_DATA_o
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/s_parity
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/s_packet_ready
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/s_new_packet
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/s_receive_state_machine
add wave -noupdate -expand -group {RX FPGA2} /serial_comm_jiga_tb/SERIAL_RX_fpga_2_1/s_rx_data_buff
add wave -noupdate /serial_comm_jiga_tb/sending_state_machine/time_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9813432754 ps} 0}
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
WaveRestoreZoom {9804660902 ps} {9825894164 ps}
