library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_audio is
   generic(FIFO_SIZE: integer:=3); -- 2^FIFO_SIZE words 
   port (
      clk, reset: in  std_logic;
      -- external signals (to avalon conduit interface)
      m_clk, b_clk, dac_lr_clk, adc_lr_clk: out std_logic;
      dacdat: out std_logic;
      adcdat: in std_logic;
      i2c_sclk: out std_logic;
      i2c_sdat: inout std_logic;
      -- avalon MM interface
      audio_address: in std_logic_vector(1 downto 0);    
      audio_chipselect: in std_logic; 
      audio_write: in std_logic;
      audio_writedata: in std_logic_vector(31 downto 0);
      audio_read: in std_logic;
      audio_readdata: out std_logic_vector(31 downto 0);
      -- avalon conduit interface
      codec_adc_rd: in std_logic;
      codec_adc_data_out: out std_logic_vector(31 downto 0);
      codec_dac_wr: in std_logic;
      codec_dac_data_in: in std_logic_vector(31 downto 0);
      codec_sample_tick: out std_logic
   );
end chu_avalon_audio;

architecture arch of chu_avalon_audio is
   signal wr_en: std_logic;
   signal wr_i2c, i2c_idle, wr_sel: std_logic;
   signal dbus_sel_reg: std_logic_vector(1 downto 0);
   signal dac_fifo_in: std_logic_vector(31 downto 0);
   signal adc_fifo_out: std_logic_vector(31 downto 0);
   signal wr_dac_fifo, cpu_wr_dac_fifo: std_logic;
   signal rd_adc_fifo, cpu_rd_adc_fifo: std_logic;
   signal adc_fifo_empty, dac_fifo_full: std_logic;  
begin
   -- instantiate codec controller   
   codec_unit: entity work.codec_top(arch)
      generic map(FIFO_SIZE=>FIFO_SIZE)  
      port map(clk=>clk, reset=>reset, 
               i2c_sclk=>i2c_sclk, i2c_sdat=>i2c_sdat,      
               m_clk=>m_clk, b_clk=>b_clk, 
               dac_lr_clk=>dac_lr_clk, adc_lr_clk=>adc_lr_clk,
               dacdat=>dacdat, adcdat=>adcdat, 
               wr_i2c=>wr_i2c, i2c_idle=>i2c_idle,
               i2c_packet=>audio_writedata(23 downto 0),
               rd_adc_fifo=>rd_adc_fifo,
               adc_fifo_empty=>adc_fifo_empty,
               adc_fifo_out=>adc_fifo_out,
               wr_dac_fifo=>wr_dac_fifo,
               dac_fifo_full=>dac_fifo_full,
               dac_fifo_in=>dac_fifo_in, 
               sample_tick=>codec_sample_tick);
   -- data stream selection register 
   process (clk, reset)
   begin
      if reset='1' then
         dbus_sel_reg <= "00";
      elsif (clk'event and clk='1') then
         if wr_sel='1' then
            dbus_sel_reg <= audio_writedata(1 downto 0);
         end if;
      end if;
   end process;          
   -- write decoding
   wr_en <= '1' when audio_write='1' and audio_chipselect='1' else
            '0';
   wr_i2c <= '1' when audio_address="00" and wr_en='1' else  
             '0';
   wr_sel <= '1' when audio_address="01" and wr_en='1' else  
             '0';
   cpu_wr_dac_fifo <= '1' when audio_address="10" and wr_en='1' else 
                      '0';
   cpu_rd_adc_fifo <= '1' when audio_address="11" and audio_read='1' and 
                               audio_chipselect='1' else
                      '0';
   -- read multiplexing   
   audio_readdata <= 
      adc_fifo_out when audio_address="11" else 
      x"0000000" & '0' & adc_fifo_empty & dac_fifo_full & i2c_idle;
   -- data stream routing & control
   wr_dac_fifo <= cpu_wr_dac_fifo when dbus_sel_reg(0)='0' else 
                  codec_dac_wr;            
   dac_fifo_in <= audio_writedata when dbus_sel_reg(0)='0' else   
                  codec_dac_data_in;
   rd_adc_fifo <= cpu_rd_adc_fifo when dbus_sel_reg(1)='0' else 
                  codec_adc_rd;   
   codec_adc_data_out <= adc_fifo_out;
end arch;
