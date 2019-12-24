--=============================
-- Listing 16.7 talker FSM
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity talker_fsm is
   port(
      clk, reset: in std_logic;
      start, ack_sync: in std_logic;
      ready: out std_logic;
      req_out: out std_logic
   );
end talker_fsm;

architecture arch of talker_fsm is
   type t_state_type is (idle, s_req1, s_req0);
   signal state_reg, state_next: t_state_type;
   signal req_buf_reg, req_buf_next: std_logic;
begin
   -- state register and output buffer
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
         req_buf_reg <='0';
     elsif (clk'event and clk='1') then
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
end arch;