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
# restart

set path "C:/Users/gdl/Desktop/mux_divider"
set uut "divider.vhd"
set tb "generic_tb"

vdel -all
vlib work
set time_sim "10 ms"


#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
vcom -lint -work work $path/reset_generator.vhd
vcom -lint -work work $path/mux_divider.vhd
vcom -lint -work work $path/divider.vhd
vcom -lint -work work $path/$uut
vcom -lint -work work $path/$tb.vhd


vsim -voptargs=+acc work.$tb -do $path/wave.do
log -r /*


configure wave -timelineunits ms
run $time_sim


# quit -force










