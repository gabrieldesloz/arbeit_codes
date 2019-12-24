--=============================
-- Listing 12.6 GCD
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gcd is
   port(
      clk, reset: in std_logic;
      start: in std_logic;
      a_in, b_in: in std_logic_vector(7 downto 0);
      ready: out std_logic;
      r: out std_logic_vector(7 downto 0)
   );
end gcd ;

architecture slow_arch of gcd is
   type state_type is (idle, swap, sub);
   signal state_reg, state_next: state_type;
   signal a_reg, a_next, b_reg, b_next: unsigned(7 downto 0);
begin
   -- state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= idle;
         a_reg <= (others=>'0');
         b_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         a_reg <= a_next;
         b_reg <= b_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,a_reg,b_reg,start,a_in,b_in)
   begin
      a_next <= a_reg;
      b_next <= b_reg;
      case state_reg is
         when idle =>
            if start='1' then
               a_next <= unsigned(a_in);
               b_next <= unsigned(b_in);
               state_next <= swap;
            else
               state_next <= idle;
            end if;
         when swap =>
            if (a_reg=b_reg) then
               state_next <= idle;
            else
               if (a_reg < b_reg) then
                  a_next <= b_reg;
                  b_next <= a_reg;
               end if;
               state_next <= sub;
            end if;
         when sub =>
            a_next <= a_reg - b_reg;
            state_next <= swap;
         end case;
   end process;
   -- output
   ready <= '1' when state_reg=idle else '0';
   r <= std_logic_vector(a_reg);
end slow_arch;


--=============================
-- Listing 12.7
--=============================
architecture fast_arch of gcd is
   type state_type is (idle, swap, sub, res);
   signal state_reg, state_next: state_type;
   signal a_reg, a_next, b_reg, b_next: unsigned(7 downto 0);
   signal n_reg, n_next: unsigned(2 downto 0);
begin
   -- state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= idle;
         a_reg <= (others=>'0');
         b_reg <= (others=>'0');
         n_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         a_reg <= a_next;
         b_reg <= b_next;
         n_reg   <= n_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,a_reg,b_reg,n_reg,start,a_in,b_in,n_next)
   begin
      a_next <= a_reg;
      b_next <= b_reg;
      n_next <= n_reg;
      case state_reg is
         when idle =>
            if start='1' then
               a_next <= unsigned(a_in);
               b_next <= unsigned(b_in);
               n_next <= (others=>'0');
               state_next <= swap;
            else
               state_next <= idle;
            end if;
         when swap =>
            if (a_reg=b_reg) then
               if (n_reg=0) then
                  state_next <= idle;
               else
                  state_next <= res;
               end if;
            else
               if (a_reg(0)='0') then -- a_reg even
                  a_next <= '0' & a_reg(7 downto 1);
                  if (b_reg(0)='0') then  -- both even
                     b_next <= '0' & b_reg(7 downto 1);
                     n_next <= n_reg + 1;
                  end if;
                  state_next <= swap;
               else -- a_reg odd
                  if (b_reg(0)='0') then  -- b_reg even
                     b_next <= '0' & b_reg(7 downto 1);
                     state_next <= swap;
                  else -- both a_reg and b_reg odd
                     if (a_reg < b_reg) then
                        a_next <= b_reg;
                        b_next <= a_reg;
                     end if;
                     state_next <= sub;
                  end if;
               end if;
            end if;
         when sub =>
            a_next <= a_reg - b_reg;
            state_next <= swap;
         when res =>
            a_next <= a_reg(6 downto 0) & '0';
            n_next <= n_reg - 1;
            if (n_next=0) then
               state_next <= idle;
            else
               state_next <= res;
            end if;
      end case;
   end process;
   --output
   ready <= '1' when state_reg=idle else '0';
   r <= std_logic_vector(a_reg);
end fast_arch;


--=============================
-- Listing 12.8
--=============================
architecture fastest_arch of gcd is
   type state_type is (idle, swap, sub, res);
   signal state_reg, state_next: state_type;
   signal a_reg, a_next, b_reg, b_next: unsigned(7 downto 0);
   signal n_reg, n_next, a_zero, b_zero: unsigned(2 downto 0);
begin
   -- state & data registers
   process(clk,reset)
   begin
      if reset='1' then
         state_reg <= idle;
         a_reg <= (others=>'0');
         b_reg <= (others=>'0');
         n_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         a_reg <= a_next;
         b_reg <= b_next;
         n_reg   <= n_next;
      end if;
   end process;
   -- next-state logic & data path functional units/routing
   process(state_reg,a_reg,b_reg,n_reg,start,
           a_in,b_in,a_zero,b_zero)
   begin
      a_next <= a_reg;
      b_next <= b_reg;
      n_next <= n_reg;
      a_zero <= (others=>'0');
      b_zero <= (others=>'0');
      case state_reg is
         when idle =>
            if start='1' then
               a_next <= unsigned(a_in);
               b_next <= unsigned(b_in);
               n_next <= (others=>'0');
               state_next <= swap;
            else
               state_next <= idle;
            end if;
         when swap =>
            if (a_reg=b_reg) then
               if (n_reg=0) then
                  state_next <= idle;
               else
                  state_next <= res;
               end if;
            else
               if (a_reg(0)='1' and b_reg(0)='1') then -- swap
                  if (a_reg < b_reg) then
                     a_next <= b_reg;
                     b_next <= a_reg;
                  end if;
                  state_next <= sub;
               else
                  -- shift out 0s of a_reg
                  if (a_reg(0)='1') then
                       a_zero <="000";
                  elsif (a_reg(1)='1') then
                     a_next <= "0" & a_reg(7 downto 1);
                       a_zero <="001";
                  elsif (a_reg(2)='1') then
                     a_next <= "00" & a_reg(7 downto 2);
                       a_zero <="010";
                  elsif (a_reg(3)='1') then
                     a_next <= "000" & a_reg(7 downto 3);
                       a_zero <="011";
                  elsif (a_reg(4)='1') then
                     a_next <= "0000" & a_reg(7 downto 4);
                       a_zero <="100";
                  elsif (a_reg(5)='1') then
                     a_next <= "00000" & a_reg(7 downto 5);
                       a_zero <="101";
                  elsif (a_reg(6)='1') then
                     a_next <= "000000" & a_reg(7 downto 6);
                       a_zero <="110";
                  else  -- a_reg(7)='1'
                     a_next <= "0000000" & a_reg(7);
                       a_zero <="111";
                  end if;
                  -- shift out 0s of b_reg
                  if (b_reg(0)='1') then
                       b_zero <="000";
                  elsif (b_reg(1)='1') then
                     b_next <= "0" & b_reg(7 downto 1);
                       a_zero <="001";
                  elsif (b_reg(2)='1') then
                     b_next <= "00" & b_reg(7 downto 2);
                       b_zero <="010";
                  elsif (b_reg(3)='1') then
                     b_next <= "000" & b_reg(7 downto 3);
                       b_zero <="011";
                  elsif (b_reg(4)='1') then
                     b_next <= "0000" & b_reg(7 downto 4);
                       b_zero <="100";
                  elsif (b_reg(5)='1') then
                     b_next <= "00000" & b_reg(7 downto 5);
                       b_zero <="101";
                  elsif (b_reg(6)='1') then
                     b_next <= "000000" & b_reg(7 downto 6);
                       b_zero <="110";
                  else  -- b_reg(7)='1'
                     b_next <= "0000000" & b_reg(7);
                       b_zero <="111";
                  end if;
                  -- find common number of 0s
                  if (a_zero > b_zero) then
                     n_next <= n_reg + b_zero;
                  else
                     n_next <= n_reg + a_zero;
                  end if;
                  state_next <= swap;
               end if;
            end if;
         when sub =>
            a_next <= a_reg - b_reg;
            state_next <= swap;
         when res =>
            case n_reg is
               when "000" =>
                  a_next <= a_reg;
               when "001" => a_next <=
                  a_reg(6 downto 0) & '0';
               when "010" =>
                  a_next <= a_reg(5 downto 0) & "00";
               when "011" =>
                  a_next <= a_reg(4 downto 0) & "000";
               when "100" => a_next <=
                  a_reg(3 downto 0) & "0000";
               when "101" =>
                  a_next <= a_reg(2 downto 0) & "00000";
               when "110" =>
                  a_next <= a_reg(1 downto 0) & "000000";
               when others =>
                  a_next <= a_reg(0) & "0000000";
            end case;
            state_next <= idle;
      end case;
   end process;
   -- output
   ready <= '1' when state_reg=idle else '0';
   r <= std_logic_vector(a_reg);
end fastest_arch;
