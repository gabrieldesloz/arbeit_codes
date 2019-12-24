onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/reset
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/sincin_i
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/CDSCLK2_o
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ADCCLK_o
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/MEM_read_i
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/READ_Addr_i
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/DATA_o
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/afec
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/CDSCLK2
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ADCCLK
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/clkb
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/pix
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/datab
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ADDRA
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/addrb
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ccd3
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ccd2
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ccd1
add wave -noupdate -radix unsigned /ad_main_tb/DUT/CLOCK_AD/channel_counter
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/DATAA
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/s_ADC1_IN
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/clkaq
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/ADC_i
add wave -noupdate -radix binary /ad_main_tb/DUT/CLOCK_AD/wena
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/CLKA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/memory_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/RSTA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/ENA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/REGCEA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/WEA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/ADDRA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/DINA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/DOUTA
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/CLKB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/RSTB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/ENB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/REGCEB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/WEB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/ADDRB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/DINB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/DOUTB
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/INJECTSBITERR
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/INJECTDBITERR
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/SBITERR
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/DBITERR
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/RDADDRECC
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/doublebit_error_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/current_contents_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/memory_out_a
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/memory_out_b
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/sbiterr_in
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/sbiterr_sdp
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/dbiterr_in
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/dbiterr_sdp
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/rdaddrecc_in
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/rdaddrecc_sdp
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/doutb_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/rdaddrecc_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/sbiterr_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/dbiterr_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/ena_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/enb_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/reseta_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/resetb_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/wea_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/web_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/rea_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/reb_i
add wave -noupdate -label sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/Group1 -group {Region: sim:/ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module} /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/message_complete
add wave -noupdate /ad_main_tb/DUT/CLOCK_AD/CAM_A/U0/mem_module/line__1466/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1989694149 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10500 us}
