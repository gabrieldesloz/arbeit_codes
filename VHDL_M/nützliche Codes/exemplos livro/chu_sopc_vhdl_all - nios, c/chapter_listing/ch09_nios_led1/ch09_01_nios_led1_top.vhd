library ieee;
use ieee.std_logic_1164.all;
entity nios_led1_top is
port(
   clk: in std_logic;
   sw: in std_logic_vector(9 downto 0);
   ledg: out std_logic_vector(1 downto 0)
);
end nios_led1_top;

architecture arch of nios_led1_top is
   component nios_led1 
      port(
         clk: in std_logic;
         reset_n: in std_logic;
         -- 10-bit slide switch
         in_port_to_the_switch: 
            in std_logic_vector (9 downto 0);
         -- 2-bit green LEDs
         out_port_from_the_led: 
            out std_logic_vector (1 downto 0)
      );
   end component;
   
begin
   nios_unit: nios_led1 
   port map(
      clk=>clk, reset_n=>'1', 
      in_port_to_the_switch=>sw,
      out_port_from_the_led=>ledg
   );
end arch;