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



#set path "C:/Users/gdl/Desktop/registradores_qualidade"
set path "C:/work/produtos/MU320/SVN/gateware/mu320/rtl/vhdl"
set uut "quality_top"
set tb "quality_top_tb"
vdel -all
vlib work
set time_sim "7 ms"
set resolution "2 ns"

#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages


vcom -lint -work work $path/mu320_constants.vhd
vcom -lint -work work $path/quality/signal_align.vhd
vcom -lint -work work $path/quality/quality_or.vhd
vcom -lint -work work $path/quality/main_fsm.vhd
vcom -lint -work work $path/quality/gate_soft_interface.vhd
vcom -lint -work work $path/quality/quality_decoder.vhd
vcom -lint -work work $path/quality/quality_insert.vhd
vcom -lint -work work $path/quality/$uut.vhd
# compila configuração separadamente
vcom -just e -lint -work work $path/quality/$tb.vhd
vcom -just a -lint -work work $path/quality/$tb.vhd
vcom -just c -lint -work work $path/quality/$tb.vhd

# if {[file exists gate_work]} { 
	# vdel -lib gate_work -all   
	# vdel -lib work -all
	# vlib gate_work
	# vmap work gate_work
	# vcom -93 -work work $path/quartus_test_7_1200mv_0c_slow.vho
# }


vsim -assertfile assertions_log.txt -wlf projeto.wlf -t $resolution -voptargs=+acc work.$tb -do $path/quality/quality_top_wave.do
run $time_sim
write report -l report.txt 


