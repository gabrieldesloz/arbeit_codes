library ieee;
use ieee.std_logic_1164.all;
entity nios_div2_top is
port(
   clk: in std_logic;
   ledg: out std_logic_vector(7 downto 0);
   hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0);
   sram_addr: out std_logic_vector (17 downto 0);
   sram_dq: inout std_logic_vector (15 downto 0);
   sram_ce_n, sram_oe_n, sram_we_n: out std_logic;
   sram_lb_n, sram_ub_n: out std_logic
);
end nios_div2_top;

architecture arch of nios_div2_top is
   component nios_div2 is 
      port(
         signal clk: in std_logic;
         signal reset_n: in std_logic;
         signal div_led_from_the_div32: out 
            std_logic_vector (7 downto 0);
         signal out_port_from_the_sseg: out 
            std_logic_vector (31 downto 0);
         signal sram_addr_from_the_sram: out 
            std_logic_vector (17 downto 0);
         signal sram_ce_n_from_the_sram: out std_logic;
         signal sram_dq_to_and_from_the_sram: inout 
            std_logic_vector (15 downto 0);
         signal sram_lb_n_from_the_sram: out std_logic;
         signal sram_oe_n_from_the_sram: out std_logic;
         signal sram_ub_n_from_the_sram: out std_logic;
         signal sram_we_n_from_the_sram: out std_logic
      );
   end component nios_div2;
   signal sseg4: std_logic_vector(31 downto 0);
   
begin
   -- instantiate processor
   nios_unit: nios_div2
   port map(
      clk=>clk, reset_n=>'1', 
      div_led_from_the_div32 => ledg,
      out_port_from_the_sseg=>sseg4,
      sram_addr_from_the_sram=>sram_addr,
      sram_dq_to_and_from_the_sram=>sram_dq,
      sram_ce_n_from_the_sram=>sram_ce_n,
      sram_lb_n_from_the_sram=>sram_lb_n,
      sram_oe_n_from_the_sram=>sram_oe_n,
      sram_ub_n_from_the_sram=>sram_ub_n,
      sram_we_n_from_the_sram=>sram_we_n
   );
   hex3 <= sseg4(30 downto 24);       
   hex2 <= sseg4(22 downto 16);       
   hex1 <= sseg4(14 downto 8);       
   hex0 <= sseg4(6 downto 0);   
end arch;