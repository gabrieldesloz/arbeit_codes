library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity start_melody_reg is
	port(  
	clk: in std_logic;	
	reset_n: std_logic;
	start_melody_int: in std_logic;
	start_melody: out std_logic; 
	pulse_8: in std_logic
	);
end entity start_melody_reg;


architecture bahavorial of start_melody_reg is
	begin
		--===================================
		-- reg/delay signal start_melody
		-- purpose: the adition of this register is necessary 
		-- because an assinchronous start_melody 
		-- (in relation to pulse_8 clock signal) 
		-- means that one state could last less than the others
		--==================================
		
		reg: process(clk,start_melody_int,reset_n,pulse_8)
		    begin		    
			if reset_n = '0' then 				
				start_melody <= '0';				
			elsif rising_edge(clk) then				
				if pulse_8 = '1' then
					start_melody <= start_melody_int;					
				end if;				
			end if;				
		end process	reg; 
		
end architecture bahavorial;
