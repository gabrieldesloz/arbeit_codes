--=============================
-- Listing 7.34 adder-based multiplier
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mult8 is
   port(
      a, b: in std_logic_vector(7 downto 0);
      y: out std_logic_vector(15 downto 0)
   );
end mult8;

architecture comb1_arch of mult8 is
   constant WIDTH: integer:=8;
   signal au, bv0, bv1, bv2, bv3, bv4, bv5, bv6, bv7:
      unsigned(WIDTH-1 downto 0);
   signal p0,p1,p2,p3,p4,p5,p6,p7,prod:
      unsigned(2*WIDTH-1 downto 0);
begin
   au <= unsigned(a);
   bv0 <= (others=>b(0));
   bv1 <= (others=>b(1));
   bv2 <= (others=>b(2));
   bv3 <= (others=>b(3));
   bv4 <= (others=>b(4));
   bv5 <= (others=>b(5));
   bv6 <= (others=>b(6));
   bv7 <= (others=>b(7));
   p0 <="00000000" & (bv0 and au);
   p1 <="0000000" & (bv1 and au) & "0";
   p2 <="000000" & (bv2 and au) & "00";
   p3 <="00000" & (bv3 and au) & "000";
   p4 <="0000" & (bv4 and au) & "0000";
   p5 <="000" & (bv5 and au) & "00000";
   p6 <="00" & (bv6 and au) & "000000";
   p7 <="0" & (bv7 and au) & "0000000";
   prod <= ((p0+p1)+(p2+p3))+((p4+p5)+(p6+p7));
   y <= std_logic_vector(prod);
end comb1_arch;

--=============================
-- Listing 7.35
--=============================
architecture comb2_arch of mult8 is
   constant WIDTH: integer:=8;
   signal au,bv0,bv1,bv2,bv3,bv4,bv5,bv6,bv7:
      unsigned(WIDTH-1 downto 0);
   signal pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7:
      unsigned(WIDTH downto 0);
   signal prod: unsigned(2*WIDTH-1 downto 0);
begin
   au <= unsigned(a);
   bv0 <= (others=>b(0));
   bv1 <= (others=>b(1));
   bv2 <= (others=>b(2));
   bv3 <= (others=>b(3));
   bv4 <= (others=>b(4));
   bv5 <= (others=>b(5));
   bv6 <= (others=>b(6));
   bv7 <= (others=>b(7));
   pp0 <= "0" & (bv0 and au);
   pp1 <= ("0" & pp0(WIDTH downto 1)) + ("0" & (bv1 and au));
   pp2 <= ("0" & pp1(WIDTH downto 1)) + ("0" & (bv2 and au));
   pp3 <= ("0" & pp2(WIDTH downto 1)) + ("0" & (bv3 and au));
   pp4 <= ("0" & pp3(WIDTH downto 1)) + ("0" & (bv4 and au));
   pp5 <= ("0" & pp4(WIDTH downto 1)) + ("0" & (bv5 and au));
   pp6 <= ("0" & pp5(WIDTH downto 1)) + ("0" & (bv6 and au));
   pp7 <= ("0" & pp6(WIDTH downto 1)) + ("0" & (bv7 and au));
   prod <= pp7 & pp6(0) & pp5(0) & pp4(0) & pp3(0) &
           pp2(0) & pp1(0) & pp0(0);
   y <= std_logic_vector(prod);
end comb2_arch;
