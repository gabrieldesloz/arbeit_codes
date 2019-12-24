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



set path "C:/Users/gdl/Desktop/media_movel"
#set path "C:/media_movel"
set uut "circular_buffer.vhd"
set tb "generic_tb"

vdel -all
vlib work
set time_sim "15 ms"
set resolution "2 ns"

#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages
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
