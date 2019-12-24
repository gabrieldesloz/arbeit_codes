--=============================
-- Listing 16.11 push-pull talker
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity talker_interface is
   port(
      clkt, resett: in std_logic;
      start, rw: in std_logic;  --read or write to i/o
      ack_sync: in std_logic;
      ready: out std_logic;
      req_out: out std_logic;
      d_t2l: in std_logic_vector(7 downto 0);
      addr_in: in std_logic_vector(1 downto 0);
      d_l2t: out std_logic_vector(7 downto 0);
      pull: out std_logic;
      addr: out std_logic_vector(1 downto 0);
      d: inout std_logic_vector(7 downto 0)
   );
end talker_interface;

architecture arch of talker_interface is
   type t_state_type is (idle, s_req1, s_req0);
   signal state_reg, state_next: t_state_type;
   signal req_buf_reg, req_buf_next: std_logic;
   signal t_tri_en: std_logic;
   signal l2t_next, l2t_reg: std_logic_vector(7 downto 0);
   signal t2l_next, t2l_reg: std_logic_vector(7 downto 0);
   signal rw_next, rw_reg: std_logic;
   signal addr_next, addr_reg: std_logic_vector(1 downto 0);
begin
   --================
   -- talker FSM
   --================
   -- state register and output buffer
   process(clkt,resett)
   begin
      if (resett='1') then
         state_reg <= idle;
         req_buf_reg <='0';
      elsif (clkt'event and clkt='1') then
         state_reg <= state_next;
         req_buf_reg <=req_buf_next;
      end if;
   end process;
   -- next-state logic
   process(state_reg,start,ack_sync)
   begin
      ready <='0';
      state_next <= state_reg;
      case state_reg is
         when idle =>
            if start='1' then
               state_next <= s_req1;
            end if;
            ready <= '1';
         when s_req1 =>
            if ack_sync='1' then
               state_next <= s_req0;
            end if;
         when s_req0 =>
            if ack_sync='0' then
               state_next <= idle;
            end if;
      end case;
   end process;
   -- look-ahead output logic
   process(state_next)
   begin
      case state_next is
         when idle =>
            req_buf_next <= '0';
         when s_req1 =>
            req_buf_next <= '1';
         when s_req0 =>
            req_buf_next <= '0';
      end case;
   end process;
   req_out<= req_buf_reg;
   --==================
   -- talker data path
   --==================
   -- data register
   process(clkt,resett)
   begin
      if (resett='1') then
         t2l_reg <= (others=>'0');
         l2t_reg <= (others=>'0');
         addr_reg <= (others=>'0');
         rw_reg <= '0';
      elsif (clkt'event and clkt='1') then
         t2l_reg <= t2l_next;
         l2t_reg <= l2t_next;
         addr_reg <= addr_next;
         rw_reg <= rw_next;
      end if;
   end process;
   -- data path next-state logic
   process(state_reg,t2l_reg,l2t_reg,addr_reg,rw_reg,d_t2l,
           addr_in,d,rw,start,ack_sync)
   begin
      t2l_next <= t2l_reg;
      l2t_next <= l2t_reg;
      addr_next <= addr_reg;
      rw_next <= rw_reg;
      t_tri_en <= '0';
      case state_reg is
         when idle =>
            rw_next <= rw;
            addr_next <= addr_in;
            if (start='1' and rw='0') then -- write to i/o
               t2l_next <= d_t2l;
            end if;
         when s_req1 =>
            if (rw_reg='0') then -- write to i/o
               t_tri_en <= '1';
            end if;
            if (ack_sync='1') and (rw_reg='1') then
             l2t_next <= d;
            end if;
         when s_req0 =>
            t_tri_en <= '0';
      end case;
   end process;
   -- output
   d <= t2l_reg when t_tri_en='1' else (others=>'Z');
   pull <= rw_reg;
   d_l2t <= l2t_reg;
   addr <= addr_reg;
end arch;