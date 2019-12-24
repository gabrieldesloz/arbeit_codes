library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity frac_engine is
   generic(
     W: integer := 32;  -- width (# bits) of Qm.f format
     M: integer := 4    -- # of bits in m
    );
   port(
      clk, reset: in std_logic;
      frac_start: in std_logic;
      cx, cy: in std_logic_vector(W-1 downto 0); 
      max_it: in std_logic_vector(15 downto 0); 
      iter: out std_logic_vector(15 downto 0);
      frac_ready, frac_done_tick: out std_logic
   );
end frac_engine;

architecture arch of frac_engine is
   constant F: integer := W - M; -- # of bits in fraction
   type state_type is (idle, op);
   signal state_reg, state_next: state_type;
   signal it_reg, it_next: unsigned(15 downto 0);
   signal xx_raw, yy_raw, xy_raw: signed(2*W-1 downto 0);
   signal xx, yy, xy2: signed(W-1 downto 0);
   signal x_reg, x_next, y_reg, y_next: signed(W-1 downto 0); 
   signal cx_reg, cx_next: signed(W-1 downto 0); 
   signal cy_reg, cy_next: signed(W-1 downto 0); 
   signal escape: std_logic;
begin
   -- FSMD state & data registers
   process(clk, reset)
   begin
      if reset='1' then
         state_reg <= idle;
         it_reg <= (others=>'0');
         x_reg <= (others=>'0');
         y_reg <= (others=>'0');
         cx_reg <= (others=>'0');
         cy_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         it_reg <= it_next;
         x_reg <= x_next;
         y_reg <= y_next;
         cx_reg <= cx_next;
         cy_reg <= cy_next;
      end if;
   end process;
   
   -- fixed-point multiplications 
   xx_raw <= x_reg*x_reg;                 -- in Q2m.2f  
   xx <= xx_raw((2*W-1)-M downto F);      -- back to Qm.f  
   yy_raw <= y_reg*y_reg;                 -- in Q2m.2f 
   yy <= yy_raw((2*W-1)-M downto F);      -- back to Qm.f 
   xy_raw  <= x_reg*y_reg;                -- xy in Q2m.2f
   xy2 <= xy_raw((2*W-1)-M-1 downto F-1); -- 2xy in Qm.f 
   -- escape condition 
   escape <= '1' when (xx + yy > x"40000000") else '0'; 
   
   -- FSMD next-state logic
   process(state_reg,it_reg,it_next,x_reg,y_reg,cx_reg,cy_reg,max_it,
           cx,cy,xx,yy,xy2,frac_start,escape)
   begin
      state_next <= state_reg;
      it_next <= it_reg;
      x_next <= x_reg;
      y_next <= y_reg;
      cx_next <= cx_reg;
      cy_next <= cy_reg;
      frac_ready <= '0';
      frac_done_tick <= '0';
      case state_reg is
         when idle =>
            frac_ready <= '1';
            if frac_start='1' then
               x_next <= signed(cx);
               y_next <= signed(cy);
               cx_next <= signed(cx);
               cy_next <= signed(cy);
               it_next <= (0=>'0',others=>'0');
               state_next <= op;
            end if;
         when op =>
            x_next <= xx - yy + cx_reg;
            y_next <= xy2 + cy_reg; 
            it_next <= it_reg +  1;
            if (escape='1' or it_next=unsigned(max_it)) then 
               state_next <= idle;
               frac_done_tick <= '1';
           end if;
      end case;
   end process;
   iter <= std_logic_vector(it_reg);
end arch;
