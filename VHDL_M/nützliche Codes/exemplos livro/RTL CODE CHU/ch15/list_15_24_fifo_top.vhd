--=============================
-- Listing 15.24 fifo
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity fifo_top_para is
   generic(
      B: natural:=3; -- number of bits
      W: natural:=2; -- number of address bits
      CNT_MODE: natural:=0 -- binary or LFSR
   );
   port(
      clk, reset: in std_logic;
      rd, wr: in std_logic;
      w_data: in std_logic_vector (B-1 downto 0);
      empty, full: out std_logic;
      r_data: out std_logic_vector (B-1 downto 0)
   );
end fifo_top_para;

architecture arch of fifo_top_para is
   component fifo_sync_ctrl_para
      generic(
         N: natural;
         CNT_MODE: natural
      );
      port(
         clk, reset: in std_logic;
         wr, rd: in std_logic;
         full, empty: out std_logic;
         w_addr, r_addr: out std_logic_vector(N-1 downto 0)
      );
   end component;
   component reg_file_para
      generic(
         W: natural;
         B: natural
      );
      port(
         clk, reset: in std_logic;
         wr_en: in std_logic;
         w_data: in std_logic_vector(B-1 downto 0);
         w_addr, r_addr: in std_logic_vector(W-1 downto 0);
         r_data: out std_logic_vector(B-1 downto 0)
      );
   end component;
   signal r_addr : std_logic_vector(W-1 downto 0);
   signal w_addr : std_logic_vector(W-1 downto 0);
   signal f_status, wr_fifo:std_logic;

begin
   u_ctrl: fifo_sync_ctrl_para
      generic map(N=>W, CNT_MODE=>CNT_MODE)
      port map(clk=>clk, reset=>reset, wr=>wr, rd=>rd,
               full=>f_status, empty=>empty,
               w_addr=>w_addr, r_addr=>r_addr);
   wr_fifo <= wr and (not f_status);
   full <= f_status;
   u_reg_file: reg_file_para
      generic map(W=>W, B=>B)
      port map(clk=>clk, reset=>reset, wr_en=>wr_fifo,
               w_data=>w_data, w_addr=>w_addr,
               r_addr=> r_addr, r_data => r_data);
end arch;