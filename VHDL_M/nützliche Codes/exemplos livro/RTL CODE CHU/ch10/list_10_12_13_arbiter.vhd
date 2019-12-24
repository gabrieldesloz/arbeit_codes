--=============================
-- Listing 12.14 arbiter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity arbiter2 is
   port(
      clk: in std_logic;
      reset: in std_logic;
      r: in std_logic_vector(1 downto 0);
      g: out std_logic_vector(1 downto 0)
   );
end arbiter2;

architecture fixed_prio_arch of arbiter2 is
   type mc_state_type is (waitr, grant1, grant0);
   signal state_reg, state_next: mc_state_type;
begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= waitr;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state and output logic
   process(state_reg,r)
   begin
      g <= "00";    -- default values
      case state_reg is
         when waitr =>
            if r(1)='1' then
               state_next <= grant1;
            elsif r(0)='1' then
               state_next <= grant0;
            else
               state_next <= waitr;
            end if;
         when grant1 =>
            if (r(1)='1') then
               state_next <= grant1;
            else
               state_next <= waitr;
            end if;
            g(1) <= '1';
         when grant0 =>
            if (r(0)='1') then
               state_next <= grant0;
            else
               state_next <= waitr;
            end if;
            g(0) <= '1';
      end case;
   end process;
end fixed_prio_arch;


--=============================
-- Listing 10.13
--=============================
architecture rotated_prio_arch of arbiter2 is
   type mc_state_type is (waitr1, waitr0, grant1, grant0);
   signal state_reg, state_next: mc_state_type;
begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= waitr1;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state and output logic
   process(state_reg,r)
   begin
      g <= "00";    -- default values
      case state_reg is
         when waitr1 =>
            if r(1)='1' then
               state_next <= grant1;
            elsif r(0)='1' then
               state_next <= grant0;
            else
               state_next <= waitr1;
            end if;
         when waitr0 =>
            if r(0)='1' then
               state_next <= grant0;
            elsif r(1)='1' then
               state_next <= grant1;
            else
               state_next <= waitr0;
            end if;
         when grant1 =>
            if (r(1)='1') then
               state_next <= grant1;
            else
               state_next <= waitr0;
            end if;
            g(1) <= '1';
         when grant0 =>
            if (r(0)='1') then
               state_next <= grant0;
            else
               state_next <= waitr1;
            end if;
            g(0) <= '1';
      end case;
   end process;
end rotated_prio_arch;
