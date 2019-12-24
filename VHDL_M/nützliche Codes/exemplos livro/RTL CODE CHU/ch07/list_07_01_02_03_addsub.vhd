--=============================
-- Listing 7.1 addition--subtraction circuit
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity addsub is
   port (
      a,b: in std_logic_vector(7 downto 0);
      ctrl: in std_logic;
      r: out  std_logic_vector(7 downto 0)
   );
end addsub;

architecture direct_arch of addsub is
   signal src0, src1, sum: signed(7 downto 0);
begin
   src0 <= signed(a);
   src1 <= signed(b);
   sum <= src0 + src1 when ctrl='0' else
          src0 - src1;
   r <= std_logic_vector(sum);
end direct_arch;

--=============================
-- Listing 7.2
--=============================
architecture shared_arch of addsub is
   signal src0, src1, sum: signed(7 downto 0);
   signal cin: signed(0 downto 0); -- carry-in bit
begin
   src0 <= signed(a);
   src1 <= signed(b) when ctrl='0' else
           signed(not b);
   cin <= "0" when ctrl='0' else
          "1";
   sum <= src0 + src1 + cin;
   r <= std_logic_vector(sum);
end shared_arch;


--=============================
-- Listing 7.3
--=============================
architecture manual_carry_arch of addsub is
   signal src0, src1, sum: signed(8 downto 0);
   signal b_tmp: std_logic_vector(7 downto 0);
   signal cin: std_logic; -- carry-in bit
begin
   src0 <= signed(a & '1');
   b_tmp <= b when ctrl='0' else
            not b;
   cin <= '0' when ctrl='0' else
          '1';
   src1 <= signed(b_tmp & cin);
   sum <= src0 + src1;
   r <= std_logic_vector(sum(8 downto 1));
end manual_carry_arch;
