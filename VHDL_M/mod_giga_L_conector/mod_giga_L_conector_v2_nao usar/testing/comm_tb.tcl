
puts {
  ModelSim general compile script 
  by Gabriel Lozano, 2012.
}

quit -sim

set path_rtl "M:/vhdl/mod_giga_L_conector/testing"

vdel -all
vlib work
set time_sim "10 ms"

#Main files
vcom -work work $path_rtl/*.vhd

#Init Simulation
vsim -voptargs=+acc work.comm_tb

#write new waveform
add wave /*
add wave /tb_ccd_ctrl/random_p/*
add wave -noupdate -radix decimal /test_tb/dut/a
add wave -noupdate -radix unsigned /test_tb/dut/b
write format wave -window .main_pane.wave.interior.cs.body.pw.wf $path_rtl/wave.do

#execute an already saved waveform
do $path_rtl/wave.do

configure wave -timelineunits ms
update
run $time_sim

wave zoom full
write report -l report.txt 

log -r /*

restart -f
run 10 ms







































#outros exemplos modelsim e programacao tcl

# set proj "1"
# if {$proj == "1"} {
    # puts "um"
# } else {
    # puts "dois"
# }

#do ./bcd_wave.do
#tutorial_pwm: nome do arquivo principal
#vsim -c -do sim.do counter -wlf counter.wlf
#vsim -voptargs=+acc work.tutorial_pwm
#log -r /*
#reinicia simulação
#restart -force

#  relógio de 50 Mhz, período de 20 ns 	
#force -freeze sim:CLOCK_50   1 0, 0 {10 ns} -r {20 ns}
#  começa bit 1 no segundo zero, zero após 1 segundo	
#force -freeze sim:KEY(3) 1 0, 0 {1000 ms}
#force -freeze sim:KEY(2) 0 0, 1 {1500 ms} 


#traça formas de onda
#run 3000 ms

#vizualiza toda a simulação
#wave zoom full
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
-------------------------------------------------------------------------------

# puts {
  # ModelSim general compile script 
  # by Gabriel Lozano, 2012.
# }

# quit -sim
# restart


# set path "E:/TRAB/sync"
# set path "C:/Users/gdl/Desktop/sync"

# vdel -all
# vlib work
# set time_sim "100 ms"



#compila a biblioteca, especificar hierarquia de baixo para cima
#primeiro bibliotecas
#force_refresh
# - 87, 93, 2002, -2008
# vcom -work work $path/rl131_constants.vhd
# vcom -work work $path/divider.vhd
# vcom -work work $path/edge_detector.vhd
# vcom -work work $path/frequency_meter.vhd
# vcom -work work $path/k_controller.vhd
# vcom -work work $path/k_controller_soc.vhd
# vcom -work work $path/k_calculator.vhd
# vcom -work work $path/k_calculator_soc.vhd
# vcom -work work $path/dco_soc.vhd
# vcom -work work $path/dco.vhd
# vcom -work work $path/adpll.vhd
# vcom -work work $path/adpll_soc.vhd
# vcom -work work $path/fir_pulse_emulator.vhd
# vcom -work work $path/reset_generator.vhd
# vcom -work work $path/pps_defect_emulator.vhd
# vcom -work work $path/synchronization.vhd
# vcom -work work $path/synchronization_tb.vhd




# vsim -voptargs=+acc work.synchronization_tb
#log -r /*




# onerror {resume}
# quietly WaveActivateNextPane {} 0
# add wave -noupdate -divider {Testbench}
# add wave -noupdate -radix unsigned /synchronization_tb/*
# add wave -noupdate -divider {ADPLL SOC}
# add wave -noupdate -radix unsigned /synchronization_tb/DUT/adpll_soc_inst/*
# add wave -noupdate -divider {ADPLL}
# add wave -noupdate -radix unsigned /synchronization_tb/DUT/adpll_inst/*
# TreeUpdate [SetDefaultTree]
# configure wave -timelineunits ns
# update

# force -freeze sim:/$tlu/pps_copernicus    0 0, 1 {5 ms}, 0 {100 ns} -r {10 ms} 
# force -freeze sim:/$tlu/pps_copernicus    1 0, 0 {100 ns} -r {1 ms}
# force -freeze sim:/$tlu/CLOCK_100MHz	  1 0, 0 {5 ns} -r {10 ns}

#update
# configure wave -timelineunits ms
# run $time_sim
# wave zoom full
# WaveRestoreZoom {0 ps} {$time_sim}
# write report -l report.txt 



# quit -force










































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



#adicionar formas de onda
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




#outros exemplos modelsim e programacao tcl

# set proj "1"
# if {$proj == "1"} {
    # puts "um"
# } else {
    # puts "dois"
# }

#do ./bcd_wave.do
#tutorial_pwm: nome do arquivo principal
#vsim -c -do sim.do counter -wlf counter.wlf
#vsim -voptargs=+acc work.tutorial_pwm
#log -r /*
#reinicia simulação
#restart -force

#  relógio de 50 Mhz, período de 20 ns 	
#force -freeze sim:CLOCK_50   1 0, 0 {10 ns} -r {20 ns}
#  começa bit 1 no segundo zero, zero após 1 segundo	
#force -freeze sim:KEY(3) 1 0, 0 {1000 ms}
#force -freeze sim:KEY(2) 0 0, 1 {1500 ms} 


#traça formas de onda
#run 3000 ms

#vizualiza toda a simulação
#wave zoom full
