onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_floor_gen/uut/FLOORX_i
add wave -noupdate /tb_floor_gen/uut/RSYNC_i
add wave -noupdate /tb_floor_gen/uut/LED_SEQ_i_0
add wave -noupdate /tb_floor_gen/uut/RST_i
add wave -noupdate /tb_floor_gen/uut/PROBE_o
add wave -noupdate /tb_floor_gen/uut/FLOOR_o
add wave -noupdate /tb_floor_gen/uut/BGND_OFF_o
add wave -noupdate /tb_floor_gen/uut/BGND_FLOOR_o
add wave -noupdate /tb_floor_gen/uut/ILLUM_FLOOR_o
add wave -noupdate /tb_floor_gen/uut/xf2
add wave -noupdate /tb_floor_gen/uut/s_extfloor
add wave -noupdate /tb_floor_gen/uut/s_clean_xf2
add wave -noupdate /tb_floor_gen/uut/s_clean_xf2_count
add wave -noupdate /tb_floor_gen/uut/s_floor
add wave -noupdate /tb_floor_gen/uut/s_end_floor
add wave -noupdate /tb_floor_gen/uut/s_reset_floor_state_machine
add wave -noupdate /tb_floor_gen/uut/s_floor_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {152638 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {92712 ps} {170153 ps}
