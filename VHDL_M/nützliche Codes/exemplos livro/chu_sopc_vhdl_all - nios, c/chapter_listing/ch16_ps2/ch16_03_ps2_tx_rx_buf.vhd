
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ps2_tx_rx_buf is
   generic(W_SIZE: integer:=4);  -- 2^W_SIZE words in FIFO
   port (
      clk, reset: in  std_logic;
      wr_ps2: in std_logic;
      rd_ps2_packet: in std_logic;
      ps2_tx_data: in std_logic_vector(7 downto 0);
      ps2_rx_data: out std_logic_vector(7 downto 0);
      ps2_tx_idle: out std_logic;
      ps2_rx_buf_empty: out std_logic;
      ps2d, ps2c: inout std_logic
   );
end ps2_tx_rx_buf;

architecture arch of ps2_tx_rx_buf is
   signal rx_data: std_logic_vector(7 downto 0);
   signal rx_done_tick: std_logic;
   signal rx_idle, tx_idle: std_logic;

begin
   -- instantiation
   ps2_tx_unit: entity work.ps2_tx(arch)
      port map(clk=>clk, reset=>reset, wr_ps2=>wr_ps2, rx_idle=>rx_idle,
               din=>ps2_tx_data, ps2d=>ps2d, ps2c=>ps2c,
               tx_idle=>tx_idle, tx_done_tick=>open);
   ps2_rx_unit: entity work.ps2_rx(arch)
      port map(clk=>clk, reset=>reset, rx_en=>tx_idle,
               ps2d=>ps2d, ps2c=>ps2c, rx_idle=>rx_idle,
               rx_done_tick=>rx_done_tick,
               dout=>rx_data);
   rx_fifo_unit: entity work.fifo(reg_file_arch)
      generic map(DATA_WIDTH=>8, ADDR_WIDTH=>W_SIZE)
      port map(clk=>clk, reset=>reset, rd=>rd_ps2_packet,
               wr=>rx_done_tick, w_data=>rx_data,
               empty=>ps2_rx_buf_empty, full=>open,
               r_data=>ps2_rx_data);
   ps2_tx_idle <= tx_idle;
end arch;