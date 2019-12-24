--=============================
-- Listing 10.14 dram read strobe
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity dram_strobe is
   port(
      clk, reset: in std_logic;
      mem: in std_logic;
      cas_n, ras_n: out std_logic
   );
end dram_strobe;

architecture fsm_slow_clk_arch of dram_strobe is
   type fsm_state_type is (idle, r, c, p);
   signal state_reg, state_next: fsm_state_type;
begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state logic
   process(state_reg,mem)
   begin
      case state_reg is
         when idle =>
            if mem='1' then
               state_next <= r;
            else
               state_next <= idle;
            end if;
         when r =>
            state_next <=c;
         when c =>
            state_next <=p;
         when p =>
            state_next <=idle;
      end case;
   end process;
   -- output logic
   process(state_reg)
   begin
      ras_n <= '1';
      cas_n <= '1';
      case state_reg is
         when idle =>
         when r =>
            ras_n <= '0';
         when c =>
            ras_n <= '0';
            cas_n <= '0';
         when p =>
      end case;
   end process;
end fsm_slow_clk_arch;

--=============================
-- Listing 10.15
--=============================
architecture fsm_slow_clk_buf_arch of dram_strobe is
   type fsm_state_type is (idle,r,c,p);
   signal state_reg, state_next: fsm_state_type;
   signal ras_n_reg, cas_n_reg: std_logic;
   signal ras_n_next, cas_n_next: std_logic;
begin
   -- state register and output buffer
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
         ras_n_reg <= '1';
         cas_n_reg <= '1';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         ras_n_reg <= ras_n_next;
         cas_n_reg <= cas_n_next;
      end if;
   end process;
   -- next-state
   process(state_reg,mem)
   begin
      case state_reg is
         when idle =>
            if mem='1' then
               state_next <= r;
            else
               state_next <= idle;
            end if;
         when r =>
            state_next <=c;
         when c =>
            state_next <=p;
         when p =>
            state_next <=idle;
      end case;
   end process;
   -- look-ahead output logic
   process(state_next)
   begin
      ras_n_next <= '1';
      cas_n_next <= '1';
      case state_next is
         when idle =>
         when r =>
            ras_n_next <= '0';
         when c =>
            ras_n_next <= '0';
            cas_n_next <= '0';
         when p =>
       end case;
   end process;
   --output
   ras_n <= ras_n_reg;
   cas_n <= cas_n_reg;
end fsm_slow_clk_buf_arch;
