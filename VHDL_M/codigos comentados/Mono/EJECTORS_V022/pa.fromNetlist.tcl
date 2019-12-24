
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name EJECTORS_V016 -dir "D:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V016/planAhead_run_1" -part xc3s200tq144-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V016/MAIN_VHDL.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V016} {ipcore_dir} }
add_files [list {ipcore_dir/MEM_32x16.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/MEM_32x32.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/MEM_512x64.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ontimeRAM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "main.ucf" [current_fileset -constrset]
add_files [list {main.ucf}] -fileset [get_property constrset [current_run]]
link_design
