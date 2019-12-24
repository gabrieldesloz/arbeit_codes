--=============================
-- Listing 7.32 programmable pririty encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity fair_prio_encoder is
   port(
      r: in std_logic_vector(7 downto 0);
      c: in std_logic_vector(2 downto 0);
      code: out std_logic_vector(2 downto 0);
      active: out std_logic
   );
end fair_prio_encoder;

architecture arch of fair_prio_encoder is
   signal mask, lower_r, upper_r:
      std_logic_vector(7 downto 0);
   signal lower_code, upper_code:
      std_logic_vector(2 downto 0);
   signal lower_active: std_logic;
begin
   with c select
      mask <= "00000001" when "000",
              "00000011" when "001",
              "00000111" when "010",
              "00001111" when "011",
              "00011111" when "100",
              "00111111" when "101",
              "01111111" when "110",
              "11111111" when others;
   lower_r <= r and mask;
   upper_r <= r and (not mask);
   lower_code <= "111"  when lower_r(7)='1' else
                 "110"  when lower_r(6)='1' else
                 "101"  when lower_r(5)='1' else
                 "100"  when lower_r(4)='1' else
                 "011"  when lower_r(3)='1' else
                 "010"  when lower_r(2)='1' else
                 "001"  when lower_r(1)='1' else
                 "000";
   upper_code <= "111"  when upper_r(7)='1' else
                 "110"  when upper_r(6)='1' else
                 "101"  when upper_r(5)='1' else
                 "100"  when upper_r(4)='1' else
                 "011"  when upper_r(3)='1' else
                 "010"  when upper_r(2)='1' else
                 "001"  when upper_r(1)='1' else
                 "000";
   lower_active <= lower_r(7) or lower_r(6) or lower_r(5) or
                   lower_r(4) or lower_r(3) or lower_r(2) or
                   lower_r(1) or lower_r(0);
   code <= lower_code when lower_active='1' else
           upper_code;
   active <= r(7) or r(6) or r(5) or r(4) or
             r(3) or r(2) or r(1) or r(0);
end arch;