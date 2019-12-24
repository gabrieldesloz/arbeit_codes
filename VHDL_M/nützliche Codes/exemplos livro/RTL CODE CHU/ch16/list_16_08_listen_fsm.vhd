--=============================
-- Listing 16.8 listener FSM
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity listener_fsm is
   port(
      clk, reset: in std_logic;
      req_sync: in std_logic;
      ack_out: out std_logic
   );
end listener_fsm;

architecture arch of listener_fsm is
   type l_state_type is (s_ack0, s_ack1);
   signal state_reg, state_next: l_state_type;
   signal ack_buf_reg, ack_buf_next: std_logic;
begin
   -- state register and output buffer
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= s_ack0;
         ack_buf_reg <='0';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         ack_buf_reg <= ack_buf_next;
      end if;
   end process;
   -- next-state logic
   process(state_reg,req_sync)
   begin
      state_next <= state_reg;
      case state_reg is
         when s_ack0 =>
            if req_sync='1' then
               state_next <= s_ack1;
            end if;
         when s_ack1 =>
            if req_sync='0' then
               state_next <= s_ack0;
            end if;
         end case;
   end process;
   -- look-ahead output logic
   process(state_next)
   begin
      case state_next is
         when s_ack0 =>
            ack_buf_next <= '0';
         when s_ack1 =>
            ack_buf_next <= '1';
         end case;
   end process;
   ack_out<= ack_buf_reg;
end arch;