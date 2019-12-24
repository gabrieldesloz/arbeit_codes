gui_open_window Wave
gui_sg_create clkblock_group
gui_list_add_group -id Wave.1 {clkblock_group}
gui_sg_addsignal -group clkblock_group {clkblock_tb.test_phase}
gui_set_radix -radix {ascii} -signals {clkblock_tb.test_phase}
gui_sg_addsignal -group clkblock_group {{Input_clocks}} -divider
gui_sg_addsignal -group clkblock_group {clkblock_tb.CLK_IN1}
gui_sg_addsignal -group clkblock_group {{Output_clocks}} -divider
gui_sg_addsignal -group clkblock_group {clkblock_tb.dut.clk}
gui_list_expand -id Wave.1 clkblock_tb.dut.clk
gui_sg_addsignal -group clkblock_group {{Status_control}} -divider
gui_sg_addsignal -group clkblock_group {clkblock_tb.RESET}
gui_sg_addsignal -group clkblock_group {{Counters}} -divider
gui_sg_addsignal -group clkblock_group {clkblock_tb.COUNT}
gui_sg_addsignal -group clkblock_group {clkblock_tb.dut.counter}
gui_list_expand -id Wave.1 clkblock_tb.dut.counter
gui_zoom -window Wave.1 -full
