--=============================
-- Listing 7.19 reduced-xor-vector circuit
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity reduced_xor_vector is
   port(
      a: in std_logic_vector(7 downto 0);
      y: out std_logic_vector(7 downto 0)
   );
end reduced_xor_vector;

architecture direct_arch of reduced_xor_vector is
begin
   y(0) <= a(0);
   y(1) <= a(1) xor a(0);
   y(2) <= a(2) xor a(1) xor a(0);
   y(3) <= a(3) xor a(2) xor a(1) xor a(0);
   y(4) <= a(4) xor a(3) xor a(2) xor a(1) xor a(0);
   y(5) <= a(5) xor a(4) xor a(3) xor a(2) xor a(1) xor a(0);
   y(6) <= a(6) xor a(5) xor a(4) xor a(3) xor a(2) xor a(1)
           xor a(0);
   y(7) <= a(7) xor a(6) xor a(5) xor a(4) xor a(3) xor a(2)
           xor a(1) xor a(0);
end direct_arch;


--=============================
-- Listing 7.20
--=============================
architecture shared1_arch of reduced_xor_vector is
   signal p: std_logic_vector(7 downto 0);
begin
   p(0) <= a(0);
   p(1) <= p(0) xor a(1);
   p(2) <= p(1) xor a(2);
   p(3) <= p(2) xor a(3);
   p(4) <= p(3) xor a(4);
   p(5) <= p(4) xor a(5);
   p(6) <= p(5) xor a(6);
   p(7) <= p(6) xor a(7);
   y <= p;
end shared1_arch;


--=============================
-- Listing 7.21
--=============================
architecture shared_compact_arch of reduced_xor_vector is
   constant WIDTH: integer := 8;
   signal p: std_logic_vector(WIDTH-1 downto 0);
begin
   p <= (p(WIDTH-2 downto 0) & '0') xor a;
   y <= p;
end shared_compact_arch;


--=============================
-- Listing 7.22
--=============================
architecture direct_tree_arch of reduced_xor_vector is
begin
   y(0) <= a(0);
   y(1) <= a(1) xor a(0);
   y(2) <= a(2) xor a(1) xor a(0);
   y(3) <= (a(3) xor a(2)) xor (a(1) xor a(0));
   y(4) <= (a(4) xor a(3)) xor (a(2) xor a(1)) xor a(0);
   y(5) <= (a(5) xor a(4)) xor (a(3) xor a(2)) xor
           (a(1) xor a(0));
   y(6) <= ((a(6) xor a(5)) xor (a(4) xor a(3))) xor
           ((a(2) xor a(1)) xor a(0));
   y(7) <= ((a(7) xor a(6)) xor (a(5) xor a(4))) xor
           ((a(3) xor a(2)) xor (a(1) xor a(0)));
end direct_tree_arch;


--=============================
-- Listing 7.23
--=============================
architecture optimal_tree_arch of reduced_xor_vector is
   signal p01, p23, p45, p67, p012,
          p0123, p456, p4567: std_logic;
begin
   p01 <= a(0) xor a(1);
   p23 <= a(2) xor a(3);
   p45 <= a(4) xor a(5);
   p67 <= a(6) xor a(7);
   p012 <= p01 xor a(2);
   p0123 <= p01 xor p23;
   p456 <= p45 xor a(6);
   p4567 <= p45 xor p67;
   y(0) <= a(0);
   y(1) <= p01;
   y(2) <= p012;
   y(3) <= p0123;
   y(4) <= p0123 xor a(4);
   y(5) <= p0123 xor p45;
   y(6) <= p0123 xor p456;
   y(7) <= p0123 xor p4567;
end optimal_tree_arch;
