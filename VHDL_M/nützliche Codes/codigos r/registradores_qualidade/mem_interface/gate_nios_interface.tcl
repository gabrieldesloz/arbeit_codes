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



set path "C:/Users/gdl/Desktop/registradores_qualidade/mem_interface/"
set uut "gate_nios_interface.vhd"
set tb "gate_nios_interface_tb"
vdel -all
vlib work
set time_sim "10 ms"
set resolution "2 ns"

#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages


vcom -lint -work work $path/true_dual_port_ram_dual_clock.vhd
vcom -lint -work work $path/p_random_generic.vhd
vcom -lint -work work $path/reset_generator.vhd
vcom -lint -work work $path/$uut
# compila configura��o separadamente
vcom -just e -lint -work work $path/$tb.vhd
vcom -just a -lint -work work $path/$tb.vhd
vcom -just c -lint -work work $path/$tb.vhd

# if {[file exists gate_work]} { 
	# vdel -lib gate_work -all   
	# vdel -lib work -all
	# vlib gate_work
	# vmap work gate_work
	# vcom -93 -work work $path/quartus_test_7_1200mv_0c_slow.vho
# }


vsim -assertfile assertions_log.txt -wlf projeto.wlf -t $resolution -voptargs=+acc work.$tb -do $path/wave_interfac.do
run $time_sim
write report -l report.txt 


