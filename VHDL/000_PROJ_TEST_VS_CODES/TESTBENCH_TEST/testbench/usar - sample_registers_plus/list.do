onerror {resume}
add list -dec -width 20 -label sample /teco_filters_top_tb/DUT/arith_ctrl_3/sample_n_i_reg
add list -dec -width 20 -label offset /teco_filters_top_tb/DUT/arith_ctrl_3/shift_result_reg
add list -dec -width 20 -label subtraction /teco_filters_top_tb/DUT/arith_ctrl_3/subt_result_reg
add list -dec -width 20 -label result /teco_filters_top_tb/DUT/avg_channel_0_reg
configure list -usestrobe 0
configure list -strobestart {0 ns} -strobeperiod {0 ns}
configure list -usesignaltrigger 1
configure list -delta none
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
