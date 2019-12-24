library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_frac is
   port (
      clk, reset: in  std_logic;
      -- avalon interface
      frac_address: in std_logic_vector(1 downto 0);
      frac_write: in std_logic;
      frac_chipselect: in std_logic;
      frac_writedata: in std_logic_vector(31 downto 0);
      frac_readdata: out std_logic_vector(31 downto 0)
   );
end chu_avalon_frac;

architecture arch of chu_avalon_frac is
   signal frac_start: std_logic;
   signal cx_reg, cy_reg: std_logic_vector(31 downto 0);
   signal max_it_reg: std_logic_vector(15 downto 0);
   signal iter_out: std_logic_vector(15 downto 0);
   signal frac_ready: std_logic;
   signal wr_en, wr_cx, wr_cy, wr_max: std_logic;

begin
   -- instantiation
   frac_unit: entity work.frac_engine(arch)
      port map(clk=>clk, reset=>reset,
               frac_start=>frac_start,
               cx=>cx_reg, cy=>cy_reg,
               max_it=>max_it_reg,
               iter=>iter_out,
               frac_ready=>frac_ready,
               frac_done_tick=>open);
   -- registers
   process (clk, reset)
   begin
      if reset='1' then
         cx_reg <= (others=>'0');
         cy_reg <= (others=>'0');
         max_it_reg <= (others=>'0');
     elsif (clk'event and clk='1') then
         if wr_cx='1' then
            cx_reg <= frac_writedata;
         end if;
         if wr_cy='1' then
            cy_reg <= frac_writedata;
         end if;
         if wr_max='1' then
            max_it_reg <= frac_writedata(15 downto 0);
         end if;
     end if;
   end process;
   -- write encoding
   wr_en <= '1' when frac_write='1' and frac_chipselect='1' else '0';
   wr_cx <= '1' when frac_address="00" and wr_en='1' else '0';
   wr_cy <= '1' when frac_address="01" and wr_en='1' else '0';
   wr_max <= '1' when frac_address="10" and wr_en='1' else '0';
   frac_start <= '1' when frac_address="11" and wr_en='1' else '0';
   -- read 
   frac_readdata <= x"000" & "000" & frac_ready & iter_out;
end arch;
