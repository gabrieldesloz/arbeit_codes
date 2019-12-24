# TCL File Generated by Component Editor 10.1sp1
# Thu Oct 06 15:44:28 EDT 2011
# DO NOT MODIFY


# +-----------------------------------
# | 
# | chu_avalon_vga_de2 "chu_avalon_vga_DE2" v1.0
# | pchu 2011.10.06.15:44:28
# | Vido controller for the DE2 board
# | 
# | K:/code/vhdl_chu_ip_v101/chu_avalon_vga_de2/chu_avalon_vga_de2.vhd
# | 
# |    ./chu_avalon_vga_de2.vhd syn, sim
# |    ./palette_de2.vhd syn, sim
# |    ./vga_sync.vhd syn, sim
# |    ./vram_ctrl.vhd syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 10.1
# | 
package require -exact sopc 10.1
# | 
# +-----------------------------------

# +-----------------------------------
# | module chu_avalon_vga_de2
# | 
set_module_property DESCRIPTION "Vido controller for the DE2 board"
set_module_property NAME chu_avalon_vga_de2
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP chu_ip
set_module_property AUTHOR pchu
set_module_property DISPLAY_NAME chu_avalon_vga_DE2
set_module_property TOP_LEVEL_HDL_FILE chu_avalon_vga_de2.vhd
set_module_property TOP_LEVEL_HDL_MODULE chu_avalon_vga_de2
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file chu_avalon_vga_de2.vhd {SYNTHESIS SIMULATION}
add_file palette_de2.vhd {SYNTHESIS SIMULATION}
add_file vga_sync.vhd {SYNTHESIS SIMULATION}
add_file vram_ctrl.vhd {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock clockRate 0

set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset
# | 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT

set_interface_property reset ENABLED true

add_interface_port reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point cpu_vga
# | 
add_interface cpu_vga avalon end
set_interface_property cpu_vga addressAlignment DYNAMIC
set_interface_property cpu_vga addressUnits WORDS
set_interface_property cpu_vga associatedClock clock
set_interface_property cpu_vga associatedReset reset
set_interface_property cpu_vga burstOnBurstBoundariesOnly false
set_interface_property cpu_vga explicitAddressSpan 0
set_interface_property cpu_vga holdTime 0
set_interface_property cpu_vga isMemoryDevice false
set_interface_property cpu_vga isNonVolatileStorage false
set_interface_property cpu_vga linewrapBursts false
set_interface_property cpu_vga maximumPendingReadTransactions 0
set_interface_property cpu_vga printableDevice false
set_interface_property cpu_vga readLatency 0
set_interface_property cpu_vga readWaitStates 2
set_interface_property cpu_vga readWaitTime 2
set_interface_property cpu_vga setupTime 0
set_interface_property cpu_vga timingUnits Cycles
set_interface_property cpu_vga writeWaitTime 0

set_interface_property cpu_vga ENABLED true

add_interface_port cpu_vga vga_address address Input 20
add_interface_port cpu_vga vga_write write Input 1
add_interface_port cpu_vga vga_read read Input 1
add_interface_port cpu_vga vga_writedata writedata Input 32
add_interface_port cpu_vga vga_readdata readdata Output 32
add_interface_port cpu_vga vga_chipselect chipselect Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end
# | 
add_interface conduit_end conduit end

set_interface_property conduit_end ENABLED true

add_interface_port conduit_end hsync export Output 1
add_interface_port conduit_end vsync export Output 1
add_interface_port conduit_end rgb export Output 30
add_interface_port conduit_end vdac_clk export Output 1
add_interface_port conduit_end vdac_blank_n export Output 1
add_interface_port conduit_end vdac_sync_n export Output 1
add_interface_port conduit_end sram_addr export Output 18
add_interface_port conduit_end sram_dq export Bidir 16
add_interface_port conduit_end sram_we_n export Output 1
add_interface_port conduit_end sram_oe_n export Output 1
add_interface_port conduit_end sram_ce_n export Output 1
add_interface_port conduit_end sram_ub_n export Output 1
add_interface_port conduit_end sram_lb_n export Output 1
# | 
# +-----------------------------------
