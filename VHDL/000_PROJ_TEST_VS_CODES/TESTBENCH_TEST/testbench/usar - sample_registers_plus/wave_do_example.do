# exemplos formas de onda


onerror {resume}
add wave -noupdate -height 74 -radix decimal /teco_filters_top_tb/channel3
quietly virtual signal -install /teco_filters_top_tb/DUT { /teco_filters_top_tb/DUT/channel_0_output(30 downto 14)} inteiros
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Analog-Step -height 40 -max 50.0 -radix decimal /arith_top_tb/sample_n_i
add wave -noupdate -radix decimal /arith_top_tb/amostra

update
WaveRestoreZoom {0 ns} {31500 us}
