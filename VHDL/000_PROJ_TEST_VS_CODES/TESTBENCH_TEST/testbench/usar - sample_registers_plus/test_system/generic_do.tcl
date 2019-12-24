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


set path "C:/Users/gdl/Desktop/soma_de_fases/test_system"
set uut "test_system_tb"

vdel -all
vlib work
set time_sim "40 ms"


#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages

vcom -lint -work work $path/mu320_constants.vhd
vcom -lint -work work $path/reset_generator.vhd
vcom -lint -work work $path/gain_registers.vhd
vcom -lint -work work $path/gain_registers_tb.vhd
vcom -lint -work work $path/phase_sum.vhd
vcom -lint -work work $path/phase_sum_tb.vhd
vcom -lint -work work $path/sample_adjust.vhd
vcom -lint -work work $path/sample_adjust_tb.vhd
vcom -lint -work work $path/$uut.vhd


vsim -voptargs=+acc work.$uut -do $path/wave.do


#log -r /*
#add wave /*

update

configure wave -timelineunits ms
run $time_sim


# quit -force










