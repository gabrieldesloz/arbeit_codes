--=============================
-- Listing 10.10 edge detector (Mealy)
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity edge_detector2 is
   port(
      clk, reset: in std_logic;
      strobe: in std_logic;
      p2: out std_logic
   );
end edge_detector2;

architecture mealy_arch of edge_detector2 is
   type state_type is (zero, one);
   signal state_reg, state_next: state_type;
begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= zero;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state logic
   process(state_reg,strobe)
   begin
      case state_reg is
         when zero=>
            if strobe= '1' then
               state_next <= one;
            else
               state_next <= zero;
            end if;
         when one =>
            if strobe= '1' then
               state_next <= one;
            else
               state_next <= zero;
            end if;
      end case;
   end process;
   -- Mealy output logic
   p2 <= '1' when (state_reg=zero) and (strobe='1') else
         '0';
end mealy_arch;


--=============================
-- Listing 10.11
--=============================
architecture direct_arch of edge_detector2 is
   signal delay_reg: std_logic;
begin
   -- delay register
   process(clk,reset)
   begin
      if (reset='1') then
         delay_reg <= '0';
      elsif (clk'event and clk='1') then
         delay_reg <= strobe;
      end if;
   end process;
   -- decoding logic
   p2 <= (not delay_reg) and strobe;
end direct_arch;


