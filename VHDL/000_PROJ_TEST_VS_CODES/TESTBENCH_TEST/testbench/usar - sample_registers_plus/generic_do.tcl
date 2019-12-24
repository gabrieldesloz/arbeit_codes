# -- ----------------------------------------------------------------------
# -- >>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<>>>>>> Warrantee <<<<<<<<<<<<<<<
# -- ----------------------------------------------------------------------

# -------------------------------------------------------------------------------
# -- Title       : 
# -- Project     : 
# -- Library:    : 
# -------------------------------------------------------------------------------
# -- File name   : 
# -- Author      : 
# -- Company     : 
# -- Last update : 
# -- Platform    : 
# -------------------------------------------------------------------------------
# -- Purpose     : do file for test bench
# -------------------------------------------------------------------------------
# -- Assumptions : -
# -- Limitations : -
# -- Known Errors: -
# -- Notes       : -
# -------------------------------------------------------------------------------
# -- Revisions   :
# -- Date        Version  Author          Description
# -- 2005/07/27  0.01    	GDL				Created
# -------------------------------------------------------------------------------

puts {
  ModelSim general compile script 
  by Gabriel Lozano, 2012.
}

quit -sim
restart



set path "C:/Users/gdl/Desktop/sample_registers_plus"
set uut "sample_register.vhd"
set tb "generic_tb"

vdel -all
vlib work
set time_sim "20 ms"
set resolution "2 ns"

#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages
vcom -work work -2008 $path/test_packages/RandomBasePkg.vhd
vcom -work work -2008 $path/test_packages/SortListPkg_int.vhd
vcom -work work -2008 $path/test_packages/RandomPkg.vhd
vcom -work work -2008 $path/test_packages/CoveragePkg.vhd

vcom -lint -work work $path/mu320_constants.vhd
vcom -lint -work work $path/dual_ram.vhd
vcom -lint -work work $path/sample_register_fifo.vhd
vcom -lint -work work $path/test_units/p_random_generic.vhd
vcom -lint -work work $path/reset_generator.vhd
vcom -lint -work work $path/$uut
vcom -lint -work work $path/$tb.vhd


vsim -t $resolution -voptargs=+acc work.$tb -do $path/wave.do

#log -r /*
#add wave /*

update

configure wave -timelineunits ms
run $time_sim
WaveRestoreZoom {0 ns} {10 ms}

# quit -force
