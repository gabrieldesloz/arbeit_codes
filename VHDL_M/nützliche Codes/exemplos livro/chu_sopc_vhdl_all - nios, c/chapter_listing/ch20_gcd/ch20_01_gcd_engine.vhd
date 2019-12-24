library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gcd_engine is
   port(
      clk, reset: in std_logic;
      start: in std_logic;
      a_in, b_in: in std_logic_vector(31 downto 0);
      gcd_done_tick, ready: out std_logic;
      r: out std_logic_vector(31 downto 0)
   );
end gcd_engine;

architecture arch of gcd_engine is
   type state_type is (idle, op);
   signal state_reg, state_next: state_type;
   signal a_reg, a_next, b_reg, b_next: unsigned(31 downto 0);
   signal n_reg, n_next: unsigned(4 downto 0);
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
      state_next <= state_reg;
      gcd_done_tick<='0';
      case state_reg is
         when idle =>
            if start='1' then
               a_next <= unsigned(a_in);
               b_next <= unsigned(b_in);
               n_next <= (others=>'0');
               state_next <= op;
             end if;   
         when op =>
            if (a_reg=b_reg) then
               state_next <= idle;
               gcd_done_tick <= '1';
               a_next <= shift_left(a_reg, to_integer(n_reg));
            else
               if (a_reg(0)='0') then -- a_reg even
                  a_next <= '0' & a_reg(31 downto 1);
                  if (b_reg(0)='0') then  -- both even
                     b_next <= '0' & b_reg(31 downto 1);
                     n_next <= n_reg + 1;
                  end if;
               else -- a_reg odd
                  if (b_reg(0)='0') then  -- b_reg even
                     b_next <= '0' & b_reg(31 downto 1);
                  else -- both a_reg and b_reg odd
                     if (a_reg > b_reg) then
                        a_next <= a_reg - b_reg; 
                     else
                        b_next <= b_reg - a_reg;
                     end if;
                  end if;
               end if;
            end if;
      end case;
   end process;
   --output
   ready <= '1' when state_reg=idle else '0';
   r <= std_logic_vector(a_reg);
end arch;



