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



set path "C:/Users/gdl/Desktop/reorg"
set uut "teco_filters_top.vhd"
set tb "teco_filters_top_tb"
vdel -all
vlib work
set time_sim "30 ms"
set resolution "2 ns"

#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# test packages

vlib ieee_proposed
vmap ieee_proposed ./ieee_proposed

vcom -work work -2008 $path/RandomBasePkg.vhd
vcom -work work -2008 $path/SortListPkg_int.vhd
vcom -work work -2008 $path/RandomPkg.vhd
vcom -work work -2008 $path/CoveragePkg.vhd

vcom -lint -work work $path/test_units/p_random_generic.vhd
vcom -lint -work work $path/reset_generator.vhd
vcom -lint -work work $path/circular_buffer.vhd
vcom -lint -work work $path/divider.vhd
vcom -lint -work work $path/divider_mux.vhd
vcom -lint -work work $path/arith_ctrl.vhd
vcom -lint -work work $path/main_fsm.vhd
vcom -lint -work work $path/dds/acumulador.vhd
vcom -lint -work work $path/dds/sen_rom.vhd
vcom -lint -work work $path/dds/pwm.vhd
vcom -lint -work work $path/dds/clock_div.vhd
vcom -lint -work work $path/dds/sigma_delta.vhd
vcom -lint -work work $path/dds/dds.vhd
vcom -lint -work work $path/arith_top_fsm.vhd
vcom -lint -work work $path/arith_top.vhd
vcom -lint -work work $path/$uut
# compila configuração separadamente
vcom -just e -lint -work work $path/$tb.vhd
vcom -just a -lint -work work $path/$tb.vhd
vcom -just c -lint -work work $path/$tb.vhd


if {[file exists gate_work]} { # se existe simulação timing
	vdel -lib gate_work -all   
	vdel -lib work -all
	vlib gate_work
	vmap work gate_work
	vcom -93 -work work {quartus_test_7_1200mv_85c_slow.vho}
}

vsim -assertfile assertions_log.txt -wlf projeto.wlf -t $resolution -voptargs=+acc work.$tb -do $path/wave.do
# vsim -t $resolution -voptargs=+acc work.$tb -do $path/list.do
run $time_sim
write report -l report.txt 





# quit -force
#log -r /*
#add wave /*
#update
# WaveRestoreZoom {0 ns} {20 us}
# configure wave -timelineunits ms

# ---- exemplos estimulos modelsim -----

#estimulos /100 
# forçar estímulos
#  2#1111 binary radix
#  10#15 decimal radix1
#  16#F hexadecimal radix	

#force -freeze sim:n_reset 1
#force -freeze sim:num 16#03C0000000000000
#force -freeze sim:den 16#5f5e100
#force -freeze sim:start    			1 0, 0 {10 ns} -r {5000 ms}
#force -freeze sim:sysclk		   	1 0, 0 {5 ns} -r {10 ns}

# force -freeze sim:/$tlu/pps_copernicus    0 0, 1 {5 ms}, 0 {100 ns} -r {10 ms} 
# force -freeze sim:/$tlu/pps_copernicus    1 0, 0 {100 ns} -r {1 ms}
# force -freeze sim:/$tlu/CLOCK_100MHz	  1 0, 0 {5 ns} -r {10 ns}


# ---- adicionar formas de onda -----

#hierarquia, adicionar "/"
#add wave /pwm/exemplo
#caracteres especiais "\\"
# \\/CLK\\
# adicionar todos os sinais
#add wave -label clock CLOCK_50  
# o editor de diag. esquematico do Quartus 2 utiliza "[]" para especificar uma fatia do vetor
#add wave -label INC KEY(3) 
#add wave -label DEC KEY(2)
#estabele uma fatia do vetor LEDR do indice 11 até o indice 5
#add wave -label Valor_PWM {LEDR(11 downto 5)}
#add wave -label PWM LEDR(12)

# --------------------------seno altera-------------------------------------------
#vcom -93 -lint -work work $path/sine_modelsim/sine.vho
# compila o gerador de seno/cos

# if {[file exist [project env]] > 0} {
# project close
# }

# if {[file exist lpm] ==0} 	{
  # exec vlib lpm
  # exec vmap lpm lpm}
# vcom -93 -work lpm  $env(QUARTUS_ROOTDIR)/eda/sim_lib/220pack.vhd 
# vcom -93 -work lpm  $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.vhd 


# if {[file exist altera_mf] ==0} 	{
  # exec vlib altera_mf
  # exec vmap altera_mf altera_mf}
# vcom -93 -work altera_mf $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf_components.vhd 
# vcom -93 -work altera_mf $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.vhd 

# if {[file exist sgate] ==0} 	{
  # exec vlib sgate
  # exec vmap sgate sgate}
# vcom -93 -work sgate $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate_pack.vhd 
# vcom -93 -work sgate $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.vhd 
