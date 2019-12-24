--=============================
-- Listing 8.24 variable
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity varaible_ff_demo is
   port(
      a,b,clk: in std_logic;
      q1,q2,q3: out std_logic
   );
end varaible_ff_demo;

architecture arch of varaible_ff_demo is
   signal tmp_sig1: std_logic;
begin
   -- attempt 1
   process(clk)
   begin
      if (clk'event and clk='1') then
         tmp_sig1 <= a and b;
         q1 <= tmp_sig1;
      end if;
   end process;
   -- attempt 2
   process(clk)
      variable  tmp_var2: std_logic;
   begin
      if (clk'event and clk='1') then
         tmp_var2 := a and b;
         q2 <= tmp_var2;
      end if;
   end process;
   -- attempt 3
   process(clk)
      variable  tmp_var3: std_logic;
   begin
      if (clk'event and clk='1') then
         q3 <= tmp_var3;
         tmp_var3 := a and b;
      end if;
   end process;
end arch;
