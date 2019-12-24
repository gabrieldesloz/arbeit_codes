onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /synchronization_top/mdat
add wave -noupdate -radix unsigned /synchronization_top/mdat1
add wave -noupdate -radix unsigned /synchronization_top/mdat2
add wave -noupdate -radix unsigned /synchronization_top/mdat4
add wave -noupdate -radix unsigned /synchronization_top/mdat3
add wave -noupdate /synchronization_top/sysclk
add wave -noupdate /synchronization_top/lsfr_clock
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/d_ana_in
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/d_ana_in_int
add wave -noupdate -height 40 -radix unsigned /synchronization_top/bfilter_1/d_ana_out
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/sample0_read
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/sample1_read
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/sample_new_read
add wave -noupdate /synchronization_top/bfilter_1/state_bfilter
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/d_ana_register_out_reg
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/counter_test_reg
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/counter_reg
add wave -noupdate /synchronization_top/bfilter_1/burst_ein
add wave -noupdate -divider Channel2
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/channel_2_in
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_2_in_burst
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_2_out
add wave -noupdate -divider Channel1
add wave -noupdate -radix unsigned /synchronization_top/bfilter_1/channel_1_in
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_1_out
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_1_in_burst
add wave -noupdate -divider Channel3
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_3_in
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_3_in_burst
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_3_out
add wave -noupdate -divider Channel4
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_4_in
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_4_in_burst
add wave -noupdate -height 20 -radix unsigned /synchronization_top/bfilter_1/channel_4_out
add wave -noupdate /synchronization_top/bfilter_1/period_samp_test
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3748104 ps} 0}
configure wave -namecolwidth 328
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
configure wave -timelineunits ms
update
WaveRestoreZoom {3387661 ps} {4042518 ps}
