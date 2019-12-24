l-- Listing 5.26
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo is
   generic(
      ADDR_WIDTH: integer:=2;
      DATA_WIDTH:integer:=8
   );
   port(
      clk, reset: in std_logic;
      rd, wr: in std_logic;
      w_data: in std_logic_vector(DATA_WIDTH-1 downto 0);
      empty, full: out std_logic;
      r_data: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end fifo;

architecture sync_sram_arch of fifo is
   signal full_tmp: std_logic;
   signal wr_en: std_logic;
   signal w_addr: std_logic_vector (ADDR_WIDTH-1 downto 0);
   signal r_addr_next: 
                  std_logic_vector (ADDR_WIDTH-1 downto 0);
begin
   -- write enabled only when FIFO is not full
   wr_en <= wr and (not full_tmp);
   full <= full_tmp;
   -- instantiate fifo control unit
   ctrl_unit: entity work.fifo_ctrl(arch)
      generic map(ADDR_WIDTH=>ADDR_WIDTH)
      port map(clk=>clk, reset=>reset,
               rd=>rd, wr=>wr,
               empty=>empty, full=>full_tmp,
               w_addr=>w_addr, r_addr=>open,
               r_addr_next=>r_addr_next);
   -- instantiate synchronous SRAM
   ssram_unit: 
     entity work.altera_dual_port_ram_simple(new_data_arch)
       generic map(DATA_WIDTH=>DATA_WIDTH, 
                   ADDR_WIDTH=>ADDR_WIDTH)
       port map(clk=>clk, 
               w_addr=>w_addr, r_addr=>r_addr_next,
               d=>w_data, q=>r_data,
               we=>wr_en);
end sync_sram_arch;