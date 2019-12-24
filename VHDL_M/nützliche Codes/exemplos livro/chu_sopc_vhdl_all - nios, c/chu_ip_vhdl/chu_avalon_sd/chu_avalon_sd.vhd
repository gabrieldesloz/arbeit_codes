library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_sd is
   port (
      clk, reset: in  std_logic;
      -- external interface
      sd_cs, sd_clk, sd_di: out std_logic;
      sd_do: in std_logic;
      -- avalon interface
      sd_address: in std_logic_vector(1 downto 0);    
      sd_chipselect: in std_logic; 
      sd_write: in std_logic;
      sd_writedata: in std_logic_vector(31 downto 0);
      sd_readdata: out std_logic_vector(31 downto 0)
   );
end chu_avalon_sd;

architecture arch of chu_avalon_sd is
   signal wr_en, wr_sd, wr_cs, wr_dvsr: std_logic;
   signal cs_reg: std_logic;
   signal dvsr_reg: std_logic_vector(7 downto 0);
   signal sd_out: std_logic_vector(7 downto 0);
   signal sd_ready: std_logic;
   
begin
   -- instantiate SPI unit
   spi_unit: entity work.spi(arch)
      port map(clk=>clk, reset=>reset, 
               din=>sd_writedata(7 downto 0),
               dvsr=>dvsr_reg, dout=>sd_out, wr_sd=>wr_sd, 
               spi_clk=>sd_clk, 
               spi_mosi=>sd_di,  spi_miso=>sd_do,
               spi_idle=>sd_ready,
               spi_done_tick=>open);
  -- decoding                      
  wr_en <= '1' when sd_write='1' and sd_chipselect='1' else 
           '0';
  wr_cs <= '1' when sd_address="01" and wr_en='1' else '0';
  wr_dvsr <= '1' when sd_address="10" and wr_en='1' else '0';
  wr_sd <= '1' when sd_address="11" and wr_en='1' else '0';
  -- registers
  process (clk, reset)
  begin
     if reset='1' then
        cs_reg <='0';
        dvsr_reg <= (others=>'1');    
     elsif (clk'event and clk='1') then
        if (wr_cs='1') then 
           cs_reg <=sd_writedata(0);
        end if;
        if (wr_dvsr='1') then 
           dvsr_reg <=sd_writedata(7 downto 0);
        end if;
     end if;
  end process;
  -- read data 
  sd_readdata <= x"00000" & "000" &  sd_ready & sd_out;          
  -- output
  sd_cs <= cs_reg; 
end arch;
