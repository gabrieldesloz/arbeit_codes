--=============================
-- Listing 12.1 one-shot pulse generator
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pulse_5clk is
   port(
      clk, reset: in std_logic;
      go, stop: in std_logic;
      pulse: out std_logic
   );
end pulse_5clk;

architecture fsm_arch of pulse_5clk is
   type fsm_state_type is
      (idle, delay1, delay2, delay3, delay4, delay5);
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
   -- next-state logic & output logic
   process(state_reg,go,stop)
   begin
      pulse <= '0';
      case state_reg is
         when idle =>
            if go='1' then
               state_next <= delay1;
            else
               state_next <= idle;
            end if;
         when delay1 =>
            if stop='1' then
               state_next <=idle;
            else
               state_next <=delay2;
            end if;
            pulse <= '1';
         when delay2 =>
            if stop='1' then
               state_next <=idle;
            else
               state_next <=delay3;
            end if;
            pulse <= '1';
         when delay3 =>
            if stop='1' then
               state_next <=idle;
            else
               state_next <=delay4;
            end if;
            pulse <= '1';
         when delay4 =>
            if stop='1' then
               state_next <=idle;
            else
               state_next <=delay5;
            end if;
            pulse <= '1';
         when delay5 =>
            state_next <=idle;
            pulse <= '1';
      end case;
   end process;
end fsm_arch;


--=============================
-- Listing 12.2
--=============================
architecture regular_seq_arch of pulse_5clk is
   constant P_WIDTH: natural:= 5;
   signal c_reg, c_next: unsigned(3 downto 0);
   signal flag_reg, flag_next: std_logic;
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         c_reg <= (others=>'0');
         flag_reg <= '0';
      elsif (clk'event and clk='1') then
         c_reg <= c_next;
         flag_reg <= flag_next;
      end if;
   end process;
   -- next-state logic
   process(c_reg,flag_reg,go,stop)
   begin
      c_next <= c_reg;
      flag_next <= flag_reg;
      if (flag_reg='0') and (go='1') then
         flag_next <= '1';
         c_next <= (others=>'0');
      elsif (flag_reg='1') and
            ((c_reg=P_WIDTH-1) or (stop='1')) then
         flag_next <= '0';
      elsif (flag_reg='1') then
         c_next <= c_reg + 1;
      end if ;
   end process;
   -- output logic
   pulse <= '1' when flag_reg='1' else '0';
end regular_seq_arch;


--=============================
-- Listing 12.3
--=============================
architecture fsmd_arch of pulse_5clk is
   constant P_WIDTH: natural:= 5;
   type fsmd_state_type is (idle, delay);
   signal state_reg, state_next: fsmd_state_type;
   signal c_reg, c_next: unsigned(3 downto 0);
begin
   -- state and data registers
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
         c_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         c_reg <= c_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,go,stop,c_reg)
   begin
      pulse <= '0';
      c_next <= c_reg;
      case state_reg is
         when idle =>
            if go='1' then
               state_next <= delay;
            else
               state_next <= idle;
            end if;
            c_next <= (others=>'0');
         when delay =>
            if stop='1' then
               state_next <=idle;
            else
               if (c_reg=P_WIDTH-1) then
                  state_next <=idle;
               else
                  state_next <=delay;
                  c_next <= c_reg + 1;
               end if;
            end if;
            pulse <= '1';
      end case;
   end process;
end fsmd_arch;


--=============================
-- Listing 12.4
--=============================
architecture prog_arch of pulse_5clk is
   type fsmd_state_type is (idle, delay, sh1, sh2, sh3);
   signal state_reg, state_next: fsmd_state_type;
   signal c_reg, c_next: unsigned(2 downto 0);
   signal w_reg, w_next: unsigned(2 downto 0);
begin
   -- state and data registers
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
         c_reg <= (others=>'0');
         w_reg <= "101";  -- default 5-cycle delay
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         c_reg <= c_next;
         w_reg <= w_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,go,stop,c_reg,w_reg)
   begin
      pulse <= '0';
      c_next <= c_reg;
      w_next <= w_reg;
      case state_reg is
         when idle =>
            if go='1' then
               if stop='1' then
                  state_next <= sh1;
               else
                  state_next <= delay;
               end if;
            else
               state_next <= idle;
            end if;
            c_next <= (others=>'0');
         when delay =>
            if stop='1' then
               state_next <=idle;
            else
               if (c_reg=w_reg-1) then
                  state_next <=idle;
               else
                  c_next <= c_reg + 1;
                  state_next <=delay;
               end if;
            end if;
            pulse <= '1';
         when sh1 =>
            w_next <= go & w_reg(2 downto 1);
            state_next <= sh2;
         when sh2 =>
            w_next <= go & w_reg(2 downto 1);
            state_next <= sh3;
         when sh3 =>
            w_next <= go & w_reg(2 downto 1);
            state_next <= idle;
      end case;
   end process;
end prog_arch;
