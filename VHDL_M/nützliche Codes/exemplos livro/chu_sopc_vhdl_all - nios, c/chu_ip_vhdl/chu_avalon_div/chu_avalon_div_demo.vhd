library ieee;
use ieee.std_logic_1164.all;
entity chu_avalon_div_demo is
   generic(
      W: integer:=32;
      CBIT: integer:=6   -- CBIT=log2(W)+1
   );   
   port (
      -- to be connected to Avalon clock input interface
      clk, reset: in  std_logic;
      -- to be connected to Avalon MM slave interface
      div_address: in std_logic_vector(2 downto 0);    
      div_chipselect: in std_logic; 
      div_write: in std_logic;
      div_writedata: in std_logic_vector(W-1 downto 0);
      div_readdata: out std_logic_vector(W-1 downto 0);
      -- to be connected to interrupt sender interface
      div_irq: out std_logic;
      -- to be connected to Avalon conduit interface
      div_led: out std_logic_vector(7 downto 0)
   );
end chu_avalon_div_demo;

architecture arch of chu_avalon_div_demo is
   signal div_start, div_ready: std_logic;
   signal set_done_tick, clr_done_tick: std_logic;
   signal dvnd_reg, dvsr_reg: std_logic_vector(W-1 downto 0);
   signal done_tick_reg: std_logic;
   signal quo, rmd: std_logic_vector(W-1 downto 0);
   signal wr_en, wr_dvnd, wr_dvsr: std_logic;
   
begin
   --=======================================================
   -- instantiation
   --=======================================================
   -- instantiate division circuit
   div_unit: entity work.div
   generic map(W=>W, CBIT=>CBIT)
   port map(clk=>clk, reset=>'0', start=>div_start,
            dvsr=>dvsr_reg, dvnd=>dvnd_reg, 
            quo=>quo, rmd=>rmd,
            ready=>div_ready, done_tick=>set_done_tick);
   --=======================================================
   -- registers
   --=======================================================
   process (clk, reset)
   begin
      if reset='1' then
         dvnd_reg <= (others=>'0');
         dvsr_reg <= (others=>'0');
         done_tick_reg <= '0';
      elsif (clk'event and clk='1') then
         if wr_dvnd='1' then
            dvnd_reg <= div_writedata;
         end if;
         if wr_dvsr='1' then
            dvsr_reg <= div_writedata;
         end if;
         if (set_done_tick='1') then 
            done_tick_reg <= '1';
         elsif (clr_done_tick='1') then
            done_tick_reg <= '0';
         end if;
      end if;
   end process;         
   --=======================================================
   -- write decoding logic
   --=======================================================
   wr_en <=
      '1' when div_write='1' and div_chipselect='1' else '0';           
   wr_dvnd <= 
      '1' when div_address="000" and wr_en='1' else '0';
   wr_dvsr <= 
      '1' when div_address="001" and wr_en='1' else '0';
   div_start <= 
      '1' when div_address="010" and wr_en='1' else '0';
   clr_done_tick <= 
      '1' when div_address="110" and wr_en='1' else '0';
   --=======================================================
   -- read multiplexing logic
   --=======================================================
   div_readdata <= 
      quo when div_address="011" else
      rmd when div_address="100" else
      x"0000000"&"000"&div_ready when div_address="101" else
      x"0000000"&"000"&done_tick_reg;
   --=======================================================
   -- conduit signals
   --=======================================================
   div_led <= rmd(7 downto 0);  -- assume that W > 7
   --=======================================================
   -- interrupt signals
   --=======================================================
   div_irq <= done_tick_reg;
end arch;
