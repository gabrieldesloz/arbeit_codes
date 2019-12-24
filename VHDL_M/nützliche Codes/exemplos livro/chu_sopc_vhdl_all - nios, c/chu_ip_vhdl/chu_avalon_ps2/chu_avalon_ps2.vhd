library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_ps2 is
   generic(W_SIZE: integer:=2);  -- 2^W_SIZE words in FIFO
   port (
      clk, reset: in  std_logic;
      ps2d, ps2c: inout  std_logic;
      -- avalon interface
      ps2_address: in  std_logic_vector(1 downto 0); -- 2-bit address
      ps2_chipselect: in  std_logic; 
      ps2_write: in std_logic;
      ps2_writedata: in std_logic_vector(31 downto 0);
      ps2_readdata: out std_logic_vector(31 downto 0)
   );
end chu_avalon_ps2;

architecture arch of chu_avalon_ps2 is
   signal ps2_rx_data: std_logic_vector(7 downto 0);
   signal rd_fifo, ps2_rx_buf_empty: std_logic;
   signal wr_ps2, ps2_tx_idle: std_logic;
begin
   -- instantiation
   ps2_unit: entity work.ps2_tx_rx_buf
      generic map (W_SIZE=>W_SIZE)
      port map(clk=>clk, reset=>reset, 
               ps2d=>ps2d, ps2c=>ps2c, 
               wr_ps2=>wr_ps2,
               rd_ps2_packet=>rd_fifo,
               ps2_tx_data=>ps2_writedata(7 downto 0),
               ps2_rx_data=>ps2_rx_data,
               ps2_tx_idle=>ps2_tx_idle,
               ps2_rx_buf_empty=>ps2_rx_buf_empty);
   -- read data multiplexing
   ps2_readdata <= 
     x"000000" & ps2_rx_data when ps2_address="00" else
     x"0000000" & "00" & ps2_tx_idle & ps2_rx_buf_empty; 
   -- remove an item from FIFO  
   rd_fifo <= 
     '1' when ps2_chipselect='1' and ps2_address="00" 
              and ps2_write='1' else
     '0';
   -- write data to PS2 transmitting subsystem  
   wr_ps2 <= 
     '1' when ps2_chipselect='1' and ps2_address="10" 
              and ps2_write='1' else
     '0';       
end arch;
