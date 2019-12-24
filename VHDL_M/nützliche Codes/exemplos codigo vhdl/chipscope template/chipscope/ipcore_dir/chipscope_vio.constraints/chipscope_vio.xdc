#
#
# Clock constraints
#
set_false_path -from [get_cells -of_object [get_nets -hierarchical -segments CLK]] -to [get_cells -of_object [get_nets -hierarchical -segments CONTROL[0]]]
set_false_path -from [get_cells -of_object [get_nets -hierarchical -segments CONTROL[0]]] -to [get_cells -of_object [get_nets -hierarchical -segments CLK]]
