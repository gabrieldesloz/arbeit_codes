# TCL File Generated by Component Editor 8.1
# Sun Sep 20 13:36:32 EDT 2009
# DO NOT MODIFY


# +-----------------------------------
# | 
# | chu_avalon_frac "chu_avalon_frac" v1.0
# | null 2009.09.20.13:36:32
# | 
# | 
# | K:/code/nios/chu_ip/chu_avalon_frac/hdl/chu_avalon_frac.vhd
# | 
# |    ./chu_avalon_frac.vhd syn, sim
# |    ./frac_engine.vhd syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | module chu_avalon_frac
# | 
set_module_property DESCRIPTION ""
set_module_property NAME chu_avalon_frac
set_module_property VERSION 1.0
set_module_property GROUP chu_ip
set_module_property DISPLAY_NAME chu_avalon_frac
set_module_property LIBRARIES {ieee.std_logic_1164.all ieee.numeric_std.all std.standard.all}
set_module_property TOP_LEVEL_HDL_FILE chu_avalon_frac.vhd
set_module_property TOP_LEVEL_HDL_MODULE chu_avalon_frac
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file chu_avalon_frac.vhd {SYNTHESIS SIMULATION}
add_file frac_engine.vhd {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end
set_interface_property clock_reset ptfSchematicName ""

add_interface_port clock_reset clk clk Input 1
add_interface_port clock_reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point frac_cpu
# | 
add_interface frac_cpu avalon end
set_interface_property frac_cpu addressAlignment DYNAMIC
set_interface_property frac_cpu addressSpan 16
set_interface_property frac_cpu bridgesToMaster ""
set_interface_property frac_cpu burstOnBurstBoundariesOnly false
set_interface_property frac_cpu holdTime 0
set_interface_property frac_cpu isMemoryDevice false
set_interface_property frac_cpu isNonVolatileStorage false
set_interface_property frac_cpu linewrapBursts false
set_interface_property frac_cpu maximumPendingReadTransactions 0
set_interface_property frac_cpu minimumUninterruptedRunLength 1
set_interface_property frac_cpu printableDevice false
set_interface_property frac_cpu readLatency 0
set_interface_property frac_cpu readWaitStates 0
set_interface_property frac_cpu readWaitTime 0
set_interface_property frac_cpu setupTime 0
set_interface_property frac_cpu timingUnits Cycles
set_interface_property frac_cpu writeWaitTime 0

set_interface_property frac_cpu ASSOCIATED_CLOCK clock_reset

add_interface_port frac_cpu frac_address address Input 2
add_interface_port frac_cpu frac_chipselect chipselect Input 1
add_interface_port frac_cpu frac_write write Input 1
add_interface_port frac_cpu frac_writedata writedata Input 32
add_interface_port frac_cpu frac_readdata readdata Output 32
# | 
# +-----------------------------------
