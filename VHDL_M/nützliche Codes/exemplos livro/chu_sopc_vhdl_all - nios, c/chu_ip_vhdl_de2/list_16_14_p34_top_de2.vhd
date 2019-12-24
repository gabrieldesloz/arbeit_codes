library ieee;
use ieee.std_logic_1164.all;
entity p34_top_de2 is
   port(
      clk: in std_logic;
      -- switch/LEDs
      sw: in std_logic_vector(9 downto 0);
      key: in std_logic_vector(3 downto 0);
      ledg: out std_logic_vector(7 downto 0);
      -- ***************   FOR DE2  ******************
      hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0:   
         out std_logic_vector(6 downto 0);
      ledr: out std_logic_vector(17 downto 0);
      -- *********************************************      
      -- to/from ps2
      ps2c, ps2d: inout std_logic;
      -- to VGA
      vsync, hsync: out std_logic;
      -- ***************   FOR DE2  ******************
      rgb: out std_logic_vector(29 downto 0); -- DE2 
      vdac_clk: out std_logic;     -- used by DE2 dac
      vdac_blank_n: out std_logic; -- used by DE2 dac
      vdac_sync_n: out std_logic;  -- used by DE2 dac
      -- *********************************************      
      -- to/from audiocodec
      m_clk, b_clk, dac_lr_clk, adc_lr_clk: out std_logic;
      dacdat: out std_logic;
      adcdat: in std_logic;
      i2c_sclk: out std_logic;
      i2c_sdat: inout std_logic;
      -- to/from SD card
      sd_clk: out std_logic;
      sd_di: out std_logic;
      sd_do: in std_logic;
      sd_cs: out std_logic;
      -- to/from SRAM
      sram_addr: out std_logic_vector (17 downto 0);
      sram_dq: inout std_logic_vector (15 downto 0);
      sram_ce_n: out std_logic;
      sram_lb_n: out std_logic;
      sram_oe_n: out std_logic;
      sram_ub_n: out std_logic;
      sram_we_n: out std_logic;
      -- to/from SDRAM 
      dram_clk: out std_logic;
      dram_cs_n, dram_cke: out std_logic;
      dram_ldqm, dram_udqm: out std_logic;
      dram_cas_n, dram_ras_n, dram_we_n: out std_logic;
      dram_addr: out std_logic_vector(11 downto 0);
      dram_ba_0, dram_ba_1: out std_logic;
      dram_dq: inout std_logic_vector(15 downto 0)
   );
end p34_top_de2;

architecture structure of p34_top_de2 is
   component nios_p34_de2 is 
   port (
      -- clock and reset
      signal clk_50m: in std_logic;
      signal clk_sdram: out std_logic;
      signal clk_sys: out std_logic;
      signal reset_n: in std_logic;
      -- SDRAM
      signal zs_addr_from_the_sdram: 
             out std_logic_vector (11 downto 0);
      signal zs_ba_from_the_sdram: 
             out std_logic_vector (1 downto 0);
      signal zs_dq_to_and_from_the_sdram: 
             inout std_logic_vector (15 downto 0);
      signal zs_cas_n_from_the_sdram: out std_logic;
      signal zs_cke_from_the_sdram: out std_logic;
      signal zs_cs_n_from_the_sdram: out std_logic;
      signal zs_ras_n_from_the_sdram: out std_logic;
      signal zs_we_n_from_the_sdram: out std_logic;
      signal zs_dqm_from_the_sdram: 
             out std_logic_vector (1 downto 0);
      -- siwtch and leds
      signal in_port_to_the_switch: 
             in std_logic_vector (9 downto 0);
      signal in_port_to_the_btn: 
             in std_logic_vector (3 downto 0);
      signal out_port_from_the_led: 
             out std_logic_vector (17 downto 0);
      signal out_port_from_the_sseg: 
             out std_logic_vector (31 downto 0);
      -- PS2
      signal ps2c_to_and_from_the_ps2: inout std_logic;
      signal ps2d_to_and_from_the_ps2: inout std_logic;
      -- video RAM (VGA)
      signal hsync_from_the_vram: out std_logic;
      signal vsync_from_the_vram: out std_logic;
      -- ***************   FOR DE2  ******************
      signal rgb_from_the_vram:
             out std_logic_vector (29 downto 0);
      signal vdac_clk_from_the_vram: out std_logic;
      signal vdac_blank_n_from_the_vram: out std_logic;
      signal vdac_sync_n_from_the_vram: out std_logic;
      -- *********************************************
      -- video RAM (SRAM)
      signal sram_addr_from_the_vram: 
             out std_logic_vector (17 downto 0);
      signal sram_dq_to_and_from_the_vram: 
             inout std_logic_vector (15 downto 0);
      signal sram_ce_n_from_the_vram:out std_logic;
      signal sram_lb_n_from_the_vram: out std_logic;
      signal sram_oe_n_from_the_vram: out std_logic;
      signal sram_ub_n_from_the_vram: out std_logic;
      signal sram_we_n_from_the_vram: out std_logic;
      -- audio codec
      signal m_clk_from_the_audio: out std_logic;
      signal b_clk_from_the_audio: out std_logic;
      signal adc_lr_clk_from_the_audio: out std_logic;
      signal adcdat_to_the_audio: in std_logic;
      signal dac_lr_clk_from_the_audio: out std_logic;
      signal dacdat_from_the_audio: out std_logic;
      signal codec_adc_data_out_from_the_audio: 
             out std_logic_vector (31 downto 0);
      signal codec_dac_data_in_to_the_audio: 
             in std_logic_vector (31 downto 0);
      signal codec_adc_rd_to_the_audio: in std_logic;
      signal codec_dac_wr_to_the_audio: in std_logic;
      signal codec_sample_tick_from_the_audio: out std_logic;
      signal i2c_sclk_from_the_audio: out std_logic;
      signal i2c_sdat_to_and_from_the_audio: inout std_logic;
      -- SD card
      signal sd_clk_from_the_sdc: out std_logic;
      signal sd_cs_from_the_sdc: out std_logic;
      signal sd_di_from_the_sdc: out std_logic;
      signal sd_do_to_the_sdc: in std_logic;
      -- DDFS
      signal ddfs_data_out_from_the_d_engine: 
             out std_logic_vector (15 downto 0)
      );
   end component nios_p34_de2;
   signal sseg4: std_logic_vector(31 downto 0);
   signal led: std_logic_vector(17 downto 0);
   signal ddfs_data: std_logic_vector(15 downto 0);
   signal dac_load_tick: std_logic;

begin
   nios: nios_p34_de2
   port map(
      clk_50M=>clk,
      clk_sdram=>dram_clk,
      clk_sys=>open,
      reset_n=>key(3),  --***** 
      in_port_to_the_btn=> '0'&key(2 downto 0),
      in_port_to_the_switch=>sw,
      out_port_from_the_led=>led,
      out_port_from_the_sseg=>sseg4,
      -- SDRAM
      zs_addr_from_the_sdram=>dram_addr,
      zs_ba_from_the_sdram(1)=>dram_ba_1,  
      zs_ba_from_the_sdram(0)=>dram_ba_0,  
      zs_cas_n_from_the_sdram=>dram_cas_n,
      zs_cke_from_the_sdram=>dram_cke,
      zs_cs_n_from_the_sdram=>dram_cs_n,
      zs_dq_to_and_from_the_sdram=>dram_dq,
      zs_ras_n_from_the_sdram=>dram_ras_n,
      zs_we_n_from_the_sdram=>dram_we_n, 
      zs_dqm_from_the_sdram(1)=> dram_udqm,
      zs_dqm_from_the_sdram(0)=> dram_ldqm,
      -- PS2
      ps2c_to_and_from_the_ps2=>ps2c,
      ps2d_to_and_from_the_ps2=>ps2d,
      -- video ram
      -- ***************   FOR DE2  ******************
      vdac_clk_from_the_vram => vdac_clk,
      vdac_sync_n_from_the_vram => vdac_sync_n,
      vdac_blank_n_from_the_vram => vdac_blank_n,
      -- *********************************************      
      hsync_from_the_vram=>hsync,
      vsync_from_the_vram => vsync,
      rgb_from_the_vram=>rgb,
      sram_addr_from_the_vram => sram_addr,
      sram_ce_n_from_the_vram => sram_ce_n,
      sram_dq_to_and_from_the_vram => sram_dq,
      sram_lb_n_from_the_vram => sram_lb_n,
      sram_oe_n_from_the_vram => sram_oe_n,
      sram_ub_n_from_the_vram => sram_ub_n,
      sram_we_n_from_the_vram => sram_we_n,
      -- audio codec
      b_clk_from_the_audio=>b_clk,
      m_clk_from_the_audio=>m_clk,
      dac_lr_clk_from_the_audio=>dac_lr_clk,
      adc_lr_clk_from_the_audio=>adc_lr_clk,
      dacdat_from_the_audio=>dacdat,
      adcdat_to_the_audio=>adcdat,
      i2c_sclk_from_the_audio=>i2c_sclk,
      i2c_sdat_to_and_from_the_audio=>i2c_sdat,
      codec_adc_data_out_from_the_audio=>open,
      codec_adc_rd_to_the_audio=>dac_load_tick,
      codec_dac_data_in_to_the_audio=>(ddfs_data & ddfs_data),
      codec_dac_wr_to_the_audio=>dac_load_tick,
      codec_sample_tick_from_the_audio=>dac_load_tick,
      -- SD card
      sd_clk_from_the_sdc=>sd_clk,
      sd_do_to_the_sdc=>sd_do,
      sd_di_from_the_sdc=>sd_di,        
      sd_cs_from_the_sdc=>sd_cs,        
      -- DDFS
      ddfs_data_out_from_the_d_engine=>ddfs_data
    );
    ledr(9 downto 0) <= led(17 downto 8);
    ledg <= led(7 downto 0);      
    hex3 <= sseg4(30 downto 24);
    hex2 <= sseg4(22 downto 16);
    hex1 <= sseg4(14 downto 8);
    hex0 <= sseg4(6 downto 0);
    -- ***************   FOR DE2  ******************
    ledr(17 downto 10) <= (others=>'0');
    hex7 <= (others=>'1');
    hex6 <= (others=>'1');
    hex5 <= (others=>'1');
    hex4 <= (others=>'1');
end structure;