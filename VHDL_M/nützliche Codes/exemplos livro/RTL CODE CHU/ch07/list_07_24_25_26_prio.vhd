--=============================
-- Listing 7.24 16-to-4 prioirty encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity prio_encoder is
   port(
      r: in std_logic_vector(15 downto 0);
      code: out std_logic_vector(3 downto 0);
      active: out std_logic
   );
end prio_encoder;

architecture cascade_arch of prio_encoder is
begin
   code <= "1111"  when r(15)='1' else
           "1110"  when r(14)='1' else
           "1101"  when r(13)='1' else
           "1100"  when r(12)='1' else
           "1011"  when r(11)='1' else
           "1010"  when r(10)='1' else
           "1001"  when r(9)='1'  else
           "1000"  when r(8)='1'  else
           "0111"  when r(7)='1'  else
           "0110"  when r(6)='1'  else
           "0101"  when r(5)='1'  else
           "0100"  when r(4)='1'  else
           "0011"  when r(3)='1'  else
           "0010"  when r(2)='1'  else
           "0001"  when r(1)='1'  else
           "0000";
   active <= r(15) or r(14) or r(13) or r(12) or
             r(11) or r(10) or r(9) or r(8) or
             r(7) or r(6) or r(5) or r(4) or
             r(3) or r(2) or r(1) or r(0);
end cascade_arch;


--=============================
-- Listing 7.25 4-to-2 prioirty encoder
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity prio42 is
   port(
      r4: in std_logic_vector(3 downto 0);
      code2: out std_logic_vector(1 downto 0);
      act42: out std_logic
   );
end prio42;

architecture cascade_arch of prio42 is
begin
   code2 <= "11"  when r4(3)='1'  else
            "10"  when r4(2)='1'  else
            "01"  when r4(1)='1'  else
            "00";
   act42 <= r4(3) or r4(2) or r4(1) or r4(0);
end cascade_arch;


--=============================
-- Listing 7.26
--=============================
architecture tree_arch of prio_encoder is
   component prio42 is
      port(
         r4: in std_logic_vector(3 downto 0);
         code2: out std_logic_vector(1 downto 0);
         act42: out std_logic
      );
   end component;
   signal code_g3, code_g2, code_g1, code_g0, code_msb:
      std_logic_vector(1 downto 0);
   signal tmp: std_logic_vector(3 downto 0);
   signal act3, act2, act1, act0: std_logic;
begin
   -- four 1st-stage 4-to-2 priority encoders
   unit_level_0_0: prio42
      port map(r4=>r(3 downto 0), code2=>code_g0,
               act42=>act0);
   unit_level_0_1: prio42
      port map(r4=>r(7 downto 4), code2=>code_g1,
               act42=>act1);
   unit_level_0_2: prio42
      port map(r4=>r(11 downto 8), code2=>code_g2,
               act42=>act2);
   unit_level_0_3: prio42
      port map(r4=>r(15 downto 12), code2=>code_g3,
               act42=>act3);
   -- 2nd stage 4-to-2 priority encoder
   tmp <= act3 & act2 & act1 & act0;
   unit_level_2: prio42
      port map(r4=>tmp, code2=>code(3 downto 2),
               act42=>active);
   -- 2 MSBs of code
   code(3 downto 2) <= code_msb;
   -- 2 LSBs of code
   with code_msb select
      code(1 downto 0) <= code_g3 when "11",
                          code_g2 when "10",
                          code_g1 when "01",
                          code_g0 when others;
end tree_arch;