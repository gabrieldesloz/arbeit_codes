onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_address
add wave -noupdate -expand -group AVS /gate_nios_interface_tb/nios_clk_sync
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_chipselect
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_read
add wave -noupdate -expand -group AVS -radix unsigned -childformat {{/gate_nios_interface_tb/avs_readdata(31) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(30) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(29) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(28) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(27) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(26) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(25) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(24) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(23) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(22) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(21) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(20) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(19) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(18) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(17) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(16) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(15) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(14) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(13) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(12) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(11) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(10) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(9) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(8) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(7) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(6) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(5) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(4) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(3) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(2) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(1) -radix unsigned} {/gate_nios_interface_tb/avs_readdata(0) -radix unsigned}} -subitemconfig {/gate_nios_interface_tb/avs_readdata(31) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(30) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(29) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(28) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(27) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(26) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(25) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(24) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(23) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(22) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(21) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(20) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(19) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(18) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(17) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(16) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(15) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(14) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(13) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(12) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(11) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(10) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(9) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(8) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(7) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(6) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(5) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(4) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(3) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(2) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(1) {-height 15 -radix unsigned} /gate_nios_interface_tb/avs_readdata(0) {-height 15 -radix unsigned}} /gate_nios_interface_tb/avs_readdata
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_waitrequest
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_write
add wave -noupdate -expand -group AVS -radix unsigned /gate_nios_interface_tb/avs_writedata
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_address
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_read
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_readdata
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_waitrequest
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_write
add wave -noupdate -expand -group COE -radix unsigned /gate_nios_interface_tb/coe_gate_writedata
add wave -noupdate -expand -group COE /gate_nios_interface_tb/sysclk
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/clk_a
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/clk_b
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/addr_a
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/addr_b
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/data_a
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/data_b
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/we_a
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/we_b
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/q_a
add wave -noupdate -expand -group {DUAL RAM} -radix unsigned /gate_nios_interface_tb/gate_nios_interface_1/true_dual_port_ram_dual_clock_1/q_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6499312 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 213
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {10500 us}
