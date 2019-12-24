--=============================
-- Listing 12.11 approximated square root
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sqrt is
   port(
      clk, reset: in std_logic;
      start: in std_logic;
      a_in, b_in: in std_logic_vector(7 downto 0);
      ready: out std_logic;
      r: out std_logic_vector(8 downto 0)
   );
end sqrt;

architecture seq_arch of sqrt is
   constant WIDTH: integer:=8;
   type state_type is (idle, s1, s2, s3, s4, s5);
   signal state_reg, state_next: state_type;
   signal r1_reg, r2_reg, r3_reg: signed(WIDTH downto 0);
   signal r1_next, r2_next, r3_next: signed(WIDTH downto 0);
   signal sub_op0, sub_op1, diff, au1_out:
      signed(WIDTH downto 0);
   signal add_op0, add_op1, sum, au2_out:
      signed(WIDTH downto 0);
   signal add_carry: integer ;
begin
   -- state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= idle;
         r1_reg <= (others=>'0');
         r2_reg <= (others=>'0');
         r3_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         r1_reg <= r1_next;
         r2_reg <= r2_next;
         r3_reg <= r3_next;
      end if;
   end process;
   -- next-state logic and data path routing
   process(start,state_reg,r1_reg,r2_reg,r3_reg,
           a_in,b_in,au1_out,au2_out)
   begin
      r1_next <= r1_reg;
      r2_next <= r2_reg;
      r3_next <= r3_reg;
      ready <='0';
      case state_reg is
         when idle =>
            if start='1' then
               r1_next <= signed(a_in(WIDTH-1) & a_in);
               r2_next <= signed(b_in(WIDTH-1) & b_in);
               state_next <= s1;
             else
               state_next <= idle;
            end if;
            ready <='1';
         when s1 =>
            r1_next <= au1_out; -- t1=|a|
            r2_next <= au2_out; -- t2=|b|
            state_next <= s2;
         when s2 =>
            r1_next <= au1_out; -- y=min(t1,t2)
            r2_next <= au2_out; -- x=max(t1,t2)
            state_next <= s3;
         when s3 =>
            r3_next <= au2_out; -- t5=x-0.125x
            state_next <= s4;
         when s4 =>
            r3_next <= au2_out; -- t6=0.5y+t5
            state_next <= s5;
         when s5 =>
            r3_next <= au2_out; -- t7=max(t6,x)
            state_next <= idle;
      end case;
   end process;
   -- arithmetic unit 1
   -- subtractor
   diff <= sub_op0 - sub_op1;
   -- input routing
   process(state_reg,r1_reg,r2_reg)
   begin
      case state_reg is
         when s1 => -- 0-a
            sub_op0 <= (others=>'0');
            sub_op1 <= r1_reg; -- a
         when others =>  -- s2: t2-t1
            sub_op0 <= r2_reg; -- t2
            sub_op1 <= r1_reg; -- t1
      end case;
   end process;
   -- output routing
   process(state_reg,r1_reg,r2_reg,diff)
   begin
      case state_reg is
         when s1 => --|a|
            if diff(WIDTH)='0' then  -- (0-a)>0
               au1_out <= diff; -- - a
            else
               au1_out <= r1_reg; -- a
            end if;
         when others =>  -- s2: min(a,b)
            if diff(WIDTH)='0' then --(t2-t1)>0
               au1_out <= r1_reg; -- t1
            else
               au1_out <= r2_reg; -- t2
            end if;
      end case;
   end process;
   -- arithmetic unit 2
   -- adder
   sum <= add_op0 + add_op1 + add_carry;
   -- input routing
   process(state_reg,r1_reg,r2_reg,r3_reg)
   begin
      case state_reg is
         when s1 => -- 0-b
            add_op0 <= (others=>'0'); --0
            add_op1 <= not r2_reg;  -- not b
            add_carry <= 1;
         when s2 => -- t1-t2
            add_op0 <= r1_reg; --t1
            add_op1 <= not r2_reg; --not t2
            add_carry <= 1;
         when s3 => -- -- x-0.125x
            add_op0 <= r2_reg; --x
            add_op1 <= not ("000" & r2_reg(WIDTH downto 3));
            add_carry <= 1;
         when s4 => -- 0.5*y + t5
            add_op0 <= "0" & r1_reg(WIDTH downto 1);
            add_op1 <= r3_reg;
            add_carry <= 0;
         when others => -- t6 - x
            add_op0 <= r3_reg; --t1
            add_op1 <= not r2_reg; --not x
            add_carry <= 1;
      end case;
   end process;
   -- output routing
   process(state_reg,r1_reg,r2_reg,r3_reg,sum)
   begin
      case state_reg is
         when s1 => -- |b|
            if sum(WIDTH)='0' then  -- (0-b)>0
               au2_out <= sum; -- -b
            else
               au2_out <= r2_reg; -- b
            end if;
         when s2 =>
            if sum(WIDTH)='0' then
               au2_out <= r1_reg;
            else
               au2_out <= r2_reg;
            end if;
         when s3|s4 => -- +,-
            au2_out <= sum;
         when others => -- s5
            if sum(WIDTH)='0' then
               au2_out <= r3_reg;
            else
               au2_out <= r2_reg;
            end if;
      end case;
   end process;
   -- output
   r <= std_logic_vector(r3_reg);
end seq_arch;
