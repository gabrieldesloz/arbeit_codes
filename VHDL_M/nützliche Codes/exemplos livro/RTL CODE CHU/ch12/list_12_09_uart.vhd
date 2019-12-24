--=============================
-- Listing 12.9
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart_receiver is
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      ready: out std_logic;
      pout: out std_logic_vector(7 downto 0)
   );
end uart_receiver ;

architecture arch of uart_receiver is
   type state_type is (idle, start, data, stop);
   signal state_reg, state_next: state_type;
   signal clk16_next, clk16_reg: unsigned(5 downto 0);
   signal s_reg, s_next: unsigned(3 downto 0);
   signal n_reg, n_next: unsigned(2 downto 0);
   signal b_reg, b_next: std_logic_vector(7 downto 0);
   signal s_pulse: std_logic;
   constant DVSR: integer := 52;
begin
   -- free-running mod-52 counter, independent of FSMD
   process(clk,reset)
   begin
      if reset='1' then
         clk16_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         clk16_reg <= clk16_next;
      end if;
   end process;
   -- next-state/output logic
   clk16_next <= (others=>'0') when clk16_reg=(DVSR-1) else
                 clk16_reg + 1 ;
   s_pulse <= '1' when clk16_reg=0 else '0';

   -- FSMD state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= idle;
         s_reg <= (others=>'0');
         n_reg <= (others=>'0');
         b_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,s_reg,n_reg,b_reg,s_pulse,rx)
   begin
      s_next <= s_reg;
      n_next <= n_reg;
      b_next <= b_reg;
      ready <='0';
      case state_reg is
         when idle =>
            if rx='0' then
               state_next <= start;
            else
               state_next <= idle;
            end if;
            ready <='1';
         when start =>
            if (s_pulse = '0') then
               state_next <= start;
            else
               if s_reg=7 then
                  state_next <= data;
                  s_next <= (others=>'0');
               else
                  state_next <= start;
                  s_next <= s_reg + 1;
               end if;
            end if;
         when data =>
            if (s_pulse = '0') then
               state_next <= data;
            else
               if s_reg=15 then
                  s_next <= (others=>'0');
                  b_next <= rx & b_reg(7 downto 1) ;
                  if n_reg=7 then
                     state_next <= stop ;
                     n_next <= (others=>'0');
                  else
                     state_next <= data;
                     n_next <= n_reg + 1;
                  end if;
               else
                  state_next <= data;
                  s_next <= s_reg + 1;
               end if;
            end if;
         when stop =>
            if (s_pulse = '0') then
               state_next <= stop;
            else
               if s_reg=15 then
                  state_next <= idle;
                  s_next <= (others=>'0');
               else
                  state_next <= stop;
                  s_next <= s_reg + 1;
               end if;
            end if;
      end case;
   end process;
   pout <= b_reg;
end arch;
