--=============================
-- Listing 15.25 fifo control
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo_sync_ctrl_para is
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
end fifo_sync_ctrl_para;

architecture lookahead_arch of fifo_sync_ctrl_para is
   component lfsr_next is
      generic(N: natural);
      port(
         q_in: in std_logic_vector(N-1 downto 0);
         q_out: out std_logic_vector(N-1 downto 0)
      );
   end component;
   constant LFSR_CTR: natural:=0;
   signal w_ptr_reg, w_ptr_next, w_ptr_succ:
      std_logic_vector(N-1 downto 0);
   signal r_ptr_reg, r_ptr_next, r_ptr_succ:
      std_logic_vector(N-1 downto 0);
   signal full_reg, empty_reg, full_next, empty_next:
          std_logic;
   signal wr_op: std_logic_vector(1 downto 0);
begin
   -- register for read and write pointers
   process(clk,reset)
   begin
      if (reset='1') then
         w_ptr_reg <= (others=>'0');
         r_ptr_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         w_ptr_reg <= w_ptr_next;
         r_ptr_reg <= r_ptr_next;
      end if;
   end process;
   -- statue FF
   process(clk,reset)
   begin
      if (reset='1') then
         full_reg <= '0';
         empty_reg <= '1';
      elsif (clk'event and clk='1') then
         full_reg <= full_next;
         empty_reg <= empty_next;
      end if;
   end process;
   -- successive value for LFSR counter
   g_lfsr: 
   if (CNT_MODE=LFSR_CTR) generate
      u_lfsr_wr: lfsr_next
         generic map(N=>N)
         port map(q_in=>w_ptr_reg, q_out=>w_ptr_succ);
      u_lfsr_rd: lfsr_next
         generic map(N=>N)
         port map(q_in=>r_ptr_reg, q_out=>r_ptr_succ);
   end generate;
   -- successive value for binary counter
   g_bin: 
   if (CNT_MODE/=LFSR_CTR) generate
      w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg) + 1);
      r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg) + 1);
   end generate;
   -- next-state logic for read and write pointers
   wr_op <= wr & rd;
   process(w_ptr_reg,w_ptr_succ,r_ptr_reg,r_ptr_succ,wr_op,
           empty_reg,full_reg)
   begin
      w_ptr_next <= w_ptr_reg;
      r_ptr_next <= r_ptr_reg;
      full_next <= full_reg;
      empty_next <= empty_reg;
      case wr_op is
         when "00" => -- no op
         when "01" => -- read
            if (empty_reg /= '1') then -- not empty
               r_ptr_next <= r_ptr_succ;
               full_next <= '0';
               if (r_ptr_succ=w_ptr_reg) then
                  empty_next <='1';
               end if;
            end if;
         when "10" => -- write
            if (full_reg /= '1') then -- not full
               w_ptr_next <= w_ptr_succ;
               empty_next <= '0';
               if (w_ptr_succ=r_ptr_reg) then
                  full_next <='1';
               end if;
            end if;
         when others => -- write/read;
            w_ptr_next <= w_ptr_succ;
            r_ptr_next <= r_ptr_succ;
      end case;
   end process;
   -- output
   w_addr <= w_ptr_reg;
   full <= full_reg;
   r_addr <= r_ptr_reg;
   empty <= empty_reg;
end lookahead_arch;