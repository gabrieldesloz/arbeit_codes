--=============================
-- Listing 16.12 push-pull listener
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity listener_interface is
   port(
      clkl, resetl: in std_logic;
      req_sync: in std_logic;
      ack_out: out std_logic;
      pull: in std_logic;
      addr: in std_logic_vector(1 downto 0);
      d: inout std_logic_vector(7 downto 0)
   );
end listener_interface;

architecture arch of listener_interface is
   type l_state_type is (s_ack0, s_ack1);
   signal state_reg, state_next: l_state_type;
   signal ack_buf_reg, ack_buf_next: std_logic;
   signal l_tri_en, r_en: std_logic;
   type r_file_type is array (3 downto 0) of
        std_logic_vector(7 downto 0);
   signal r_file_reg: r_file_type;
begin
   --================
   -- listener FSM
   --================
   -- state register and output buffer
   process(clkl,resetl)
   begin
      if (resetl='1') then
         state_reg <= s_ack0;
         ack_buf_reg <='0';
      elsif (clkl'event and clkl='1') then
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
   --====================
   -- listener data path
   --====================
   -- register file
   process(clkl,resetl)
   begin
      if (resetl='1') then
         for i in 0 to 3 loop
            r_file_reg(i) <= (others=>'0');
         end loop;
      elsif (clkl'event and clkl='1') then
         if r_en='1' then
            r_file_reg(to_integer(unsigned(addr))) <= d;
         end if;
     end if;
   end process;
   -- enable logic
   process(state_reg,req_sync,pull)
   begin
      l_tri_en <= '0';
      r_en <= '0';
      case state_reg is
         when s_ack0 =>
            if (req_sync='1')  then
               if (pull='0') then -- push
                  r_en <= '1';
               end if;
            end if;
         when s_ack1 =>
            if (pull='1')then
               l_tri_en <='1';
            end if;
      end case;
   end process;
    -- output
   d <= r_file_reg(to_integer(unsigned(addr)))
                       when l_tri_en='1' else
        (others=>'Z');
end arch;
