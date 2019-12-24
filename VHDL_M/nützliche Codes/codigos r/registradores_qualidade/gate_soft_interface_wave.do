onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {top_level} -radix unsigned /gate_soft_interface_tb/avs_address
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/avs_chipselect
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/avs_read
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/avs_readdata
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/avs_write
add wave -noupdate -expand -group {top_level} -radix unsigned /gate_soft_interface_tb/avs_writedata
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/clk
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/coe_read_gate
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/coe_sysclk
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/coe_write_gate
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/data_input
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/data_input_available
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/nios_clk_sync
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/quality_bus_i
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/quality_bus_o
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/reset_n
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/sample_clk
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/sample_clk_sync
add wave -noupdate -expand -group {top_level} -radix decimal /gate_soft_interface_tb/sysclk
add wave -noupdate -radix unsigned -childformat {{/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0) -radix unsigned -childformat {{/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(31) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(30) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(29) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(28) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(27) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(26) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(25) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(24) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(23) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(22) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(21) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(20) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(19) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(18) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(17) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(16) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(15) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(14) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(13) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(12) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(11) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(10) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(9) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(8) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(7) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(6) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(5) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(4) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(3) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(2) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(1) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(0) -radix unsigned}}} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(1) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(2) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(3) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(4) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(5) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(6) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(7) -radix unsigned}} -subitemconfig {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0) {-radix unsigned -childformat {{/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(31) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(30) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(29) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(28) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(27) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(26) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(25) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(24) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(23) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(22) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(21) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(20) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(19) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(18) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(17) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(16) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(15) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(14) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(13) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(12) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(11) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(10) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(9) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(8) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(7) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(6) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(5) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(4) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(3) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(2) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(1) -radix unsigned} {/gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(0) -radix unsigned}}} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(31) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(30) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(29) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(28) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(27) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(26) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(25) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(24) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(23) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(22) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(21) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(20) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(19) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(18) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(17) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(16) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(15) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(14) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(13) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(12) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(11) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(10) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(9) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(8) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(7) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(6) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(5) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(4) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(3) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(2) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(1) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(0)(0) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(1) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(2) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(3) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(4) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(5) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(6) {-radix unsigned} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS(7) {-radix unsigned}} /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/BUFFER_REGS_next
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_address
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_chipselect
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_read
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_readdata
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_write
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/avs_writedata
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/clk
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_read_gate
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_read_gate_next
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_read_gate_reg
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_sysclk
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_write_gate
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_write_gate_next
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/coe_write_gate_reg
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/quality_bus_i
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/quality_bus_o
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/rd_en_next
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/rd_en_reg
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/reset_n
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/wr_en_next
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/wr_en_reg
add wave -noupdate -radix unsigned /gate_soft_interface_tb/gate_soft_interface_1/wr_en_reg_align
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6791778 ns} 0}
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
configure wave -timeline 1
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {54334224 ns}
