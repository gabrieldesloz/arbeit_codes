create_clock -period 5.000 -name clock_100mhz [get_ports clock_100mhz]

derive_pll_clocks

derive_clock_uncertainty 




#################### Ethernet ############################
#Only using 100 Mbps mode, input clocks at 25 MHz
create_clock -name eth0_rx_clk -period "25MHz" [get_ports eth0_rx_clk]
create_clock -name eth0_tx_clk -period "25MHz" [get_ports eth0_tx_clk]
create_clock -name eth1_rx_clk -period "25MHz" [get_ports eth1_rx_clk]
create_clock -name eth1_tx_clk -period "25MHz" [get_ports eth1_tx_clk]

# Ethernet MAC_0
set_min_delay 0.0 -from [get_ports { eth0_col eth0_crs eth0_rxd[*] eth0_rx_dv eth0_rx_er}] -to *
set_max_delay 4.0 -from [get_ports { eth0_col eth0_crs eth0_rxd[*] eth0_rx_dv eth0_rx_er}] -to *
                                   
set_min_delay 4.0 -from * -to [get_ports {eth0_tx[*] eth0_tx_en}]
set_max_delay 12.0 -from * -to [get_ports {eth0_tx[*] eth0_tx_en}]

# MDIO_0
set_min_delay 0.0 -from [get_ports {eth0_mdio}] -to *
set_max_delay 4.0 -from [get_ports {eth0_mdio}] -to *

set_min_delay 4.0 -from * -to [get_ports {eth0_mdio eth0_mdc}]
set_max_delay 12.0 -from * -to [get_ports {eth0_mdio eth0_mdc}]


# Ethernet MAC_1
set_min_delay 0.0 -from [get_ports { eth1_col eth1_crs eth1_rxd[*] eth1_rx_dv eth1_rx_er}] -to *
set_max_delay 4.0 -from [get_ports { eth1_col eth1_crs eth1_rxd[*] eth1_rx_dv eth1_rx_er}] -to *
                                   
set_min_delay 4.0 -from * -to [get_ports {eth1_tx[*] eth1_tx_en}]
set_max_delay 12.0 -from * -to [get_ports {eth1_tx[*] eth1_tx_en}]

# MDIO_1
set_min_delay 0.0 -from [get_ports {eth1_mdio}] -to *
set_max_delay 4.0 -from [get_ports {eth1_mdio}] -to *

set_min_delay 4.0 -from * -to [get_ports {eth1_mdio eth1_mdc}]
set_max_delay 12.0 -from * -to [get_ports {eth1_mdio eth1_mdc}]




#set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
#set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
#set_multicycle_path -setup 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
#set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
#set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
#set_multicycle_path -hold 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
#set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|dout_reg_sft*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
#set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|eop_sft*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
#set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|sop_reg*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
   
#set_clock_groups -exclusive -group ${SYSTEM_CLK} -group {eth0_rx_clk} -group {eth0_tx_clk}
