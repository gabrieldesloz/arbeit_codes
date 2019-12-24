library ieee;
use ieee.std_logic_1164.all;
entity mem_top is
   port(
      clk: in std_logic;
      -- LEDs
      ledg: out std_logic_vector(7 downto 0);
      ledr: out std_logic_vector(9 downto 0);
      hex3, hex2, hex1, hex0: 
         out std_logic_vector(6 downto 0);
      -- to/from SRAM
      sram_addr: out std_logic_vector (17 downto 0);
      sram_dq: inout std_logic_vector (15 downto 0);
      sram_ce_n: out std_logic;
      sram_lb_n: out std_logic;
      sram_oe_n: out std_logic;
      sram_ub_n: out std_logic;
      sram_we_n: out std_logic;
      -- to/from SDRAM side
      dram_clk: out std_logic;
      dram_cs_n, dram_cke: out std_logic;
      dram_ldqm, dram_udqm: out std_logic;
      dram_cas_n, dram_ras_n, dram_we_n: out std_logic;
      dram_addr: out std_logic_vector(11 downto 0);
      dram_ba_0, dram_ba_1: out std_logic;
      dram_dq: inout std_logic_vector(15 downto 0)
   );
end mem_top;

architecture structure of mem_top is
   component nios_ram is 
   port(
      -- clock and reset
      signal clk_50M: in std_logic;
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
      signal zs_cke_from_the_sdram: out std_logic;
      signal zs_cs_n_from_the_sdram: out std_logic;
      signal zs_ras_n_from_the_sdram: out std_logic;
      signal zs_cas_n_from_the_sdram: out std_logic;
      signal zs_we_n_from_the_sdram: out std_logic;
      signal zs_dqm_from_the_sdram: 
             out std_logic_vector (1 downto 0);
      -- SRAM
      signal sram_addr_from_the_sram: 
             out std_logic_vector (17 downto 0);
      signal sram_dq_to_and_from_the_sram: 
             inout std_logic_vector (15 downto 0);
      signal sram_ce_n_from_the_sram: out std_logic;
      signal sram_we_n_from_the_sram: out std_logic;              
      signal sram_oe_n_from_the_sram: out std_logic;
      signal sram_ub_n_from_the_sram: out std_logic;
      signal sram_lb_n_from_the_sram: out std_logic
    );
    end component nios_ram;    
begin
   nios: nios_ram
   port map(
      clk_50M=>clk,
      clk_sys=>open, 
      clk_sdram => dram_clk,
      reset_n=>'1',  
      -- SDRAM
      zs_addr_from_the_sdram=>dram_addr,
      zs_ba_from_the_sdram(1)=>dram_ba_1,  
      zs_ba_from_the_sdram(0)=>dram_ba_0,   
      zs_cas_n_from_the_sdram=>dram_cas_n,
      zs_cke_from_the_sdram=>dram_cke,
      zs_cs_n_from_the_sdram=>dram_cs_n,
      zs_dq_to_and_from_the_sdram=>dram_dq,
      zs_dqm_from_the_sdram(1)=> dram_udqm,
      zs_dqm_from_the_sdram(0)=> dram_ldqm,
      zs_ras_n_from_the_sdram=>dram_ras_n,
      zs_we_n_from_the_sdram=>dram_we_n, 
      -- SRAM
      sram_addr_from_the_sram => sram_addr,
      sram_ce_n_from_the_sram => sram_ce_n,
      sram_dq_to_and_from_the_sram => sram_dq,
      sram_lb_n_from_the_sram => sram_lb_n,
      sram_oe_n_from_the_sram => sram_oe_n,
      sram_ub_n_from_the_sram => sram_ub_n,
      sram_we_n_from_the_sram => sram_we_n
   );
   -- turn off all LEDs         
   ledr <= (others=>'0');
   ledg <= (others=>'0');      
   hex3 <= (others=>'1');
   hex2 <= (others=>'1');
   hex1 <= (others=>'1');
   hex0 <= (others=>'1');   
end structure;