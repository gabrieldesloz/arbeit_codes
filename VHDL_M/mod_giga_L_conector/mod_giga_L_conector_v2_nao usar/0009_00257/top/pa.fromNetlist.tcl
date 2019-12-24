
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name shift_reg -dir "M:/vhdl/0009_00257/shift_reg/planAhead_run_1" -part xc3s200tq144-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "M:/vhdl/0009_00257/shift_reg/shift_reg_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {M:/vhdl/0009_00257/shift_reg} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "shift_reg_top.ucf" [current_fileset -constrset]
add_files [list {shift_reg_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
