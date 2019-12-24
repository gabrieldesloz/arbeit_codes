library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_gcd is
   port (
      clk, reset: in  std_logic;
      -- avalon interface
      gcd_address: in std_logic_vector(2 downto 0);     -- 3-bit address
      gcd_chipselect: in std_logic; 
      gcd_write: in std_logic;
      gcd_writedata: in std_logic_vector(31 downto 0);
      gcd_readdata: out std_logic_vector(31 downto 0)
   );
end chu_avalon_gcd;

architecture arch of chu_avalon_gcd is
   signal gcd_start, gcd_done_tick: std_logic;
   signal a_in_reg, b_in_reg: std_logic_vector(31 downto 0);
   signal r_out: std_logic_vector(31 downto 0);
   signal gcd_ready: std_logic;
   signal wr_en, wr_a, wr_b: std_logic;
   type state_type is (idle, count);
   signal state_reg, state_next: state_type;
   signal c_reg, c_next: unsigned(15 downto 0);
   
begin
   --=======================================================
   -- instantiation
   --=======================================================
   -- instantiate gcd unit
   gcd_unit: entity work.gcd_engine(arch)
      port map
         (clk=>clk, reset=>reset, start=>gcd_start,
          a_in=>a_in_reg, b_in=>b_in_reg, r=>r_out,  
          gcd_done_tick=>gcd_done_tick, ready=>gcd_ready);

   --=======================================================
   -- registers and decoding 
   --=======================================================
   process (clk, reset)
   begin
      if reset='1' then
         a_in_reg <= (others=>'0');
         b_in_reg <= (others=>'0');
     elsif (clk'event and clk='1') then
         if wr_a='1' then
            a_in_reg <= gcd_writedata;
         end if;
         if wr_b='1' then
            b_in_reg <= gcd_writedata;
         end if;
     end if;
   end process;          
   wr_en <=
      '1' when gcd_write='1' and gcd_chipselect='1' else '0';
              
   wr_a <= '1' when gcd_address="000" and wr_en='1' else '0';
   wr_b <= '1' when gcd_address="001" and wr_en='1' else '0';
   gcd_start <= '1' when gcd_address="010" and wr_en='1' else
                '0';
   gcd_readdata <= r_out when gcd_address="100"  else
                   gcd_ready & "000" & x"000" &  
                   std_logic_vector(c_reg);
   --=======================================================
   -- built-in counter to keep track of cycles in execution
   --=======================================================
   process (clk, reset)
   begin
      if reset='1' then
         state_reg <= idle;
         c_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         c_reg <= c_next;
      end if;   
   end process;          
  
   -- next-state logic & data path functional units/routing
   process(state_reg,c_reg,gcd_start,gcd_done_tick)
   begin
      c_next <= c_reg;
      state_next <= state_reg;
      case state_reg is
         when idle =>
            if gcd_start='1' then
               c_next <= x"0001";
               state_next <= count;
             end if;   
         when count =>
            if (gcd_done_tick='1') then
               state_next <= idle;
            else
               c_next <= c_reg + 1;
            end if;
      end case;
   end process;              
end arch;
