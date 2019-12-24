library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sigma_delta is
	generic (n: integer := 10);
	port 
	(
	CLK,CLR,enable:		 		in 		std_logic;
	input:  					in 		std_logic_vector(n-1 downto 0);
	dac_out: 					out 	std_logic
	);	   
	
end sigma_delta;

	
architecture arq  of  sigma_delta  is
	type 		state_type is 			(idle,op);	 
	signal 		state_reg,state_next:	state_type;
	signal 		delta_adder: 			unsigned(n+1 downto 0); 
	signal 		sigma_adder:			unsigned(n+1 downto 0);
	signal 		dac_reg:				std_logic;
	signal		dac_next:				std_logic;
	signal 		deltaB: 				unsigned(n+1 downto 0);
	signal 		sigma_next:  			unsigned(n+1 downto 0);
	signal 		sigma_reg:   			unsigned(n+1 downto 0);	
	signal 		zero:  					unsigned(n-1 downto 0):= (others => '0');
		
		begin 				
			--================--
			--Registradores 
			--================--	  
			
			reg_sinc: process (clk,clr) 
			begin 				
				if rising_edge(clk) then 
					if enable = '1' then					
						state_reg 	<= state_next;	
						sigma_reg  <=  sigma_next;
						dac_reg    <=  dac_next;					
					elsif (clr='1') then
						state_reg <= idle;						
					end if;
				end if;	 
			end process;   		 
			
		
		--================--
		--Lógica para definir o proximo estado dos registradores
		--================--	
			
		process(sigma_reg,dac_reg,sigma_adder,state_reg)	
		begin 	
			
			state_next <= state_reg;
			sigma_next <= sigma_reg;
			dac_next   <= dac_reg;
			
			case state_reg is  				
				when idle => 
				  	sigma_next  <=  (others => '0');
				  	dac_next    <=  '0';				  
					state_next <= op;  					
				when op =>	
					sigma_next		<=  sigma_adder; 
					dac_next		<= 	sigma_reg(n+1);
			end case;
		end process;
		
					
		delta_adder 		 <= 	( "00" & unsigned(input) ) + deltaB;	
		deltaB(n+1)		     <= 	sigma_reg(n+1);
		deltaB(n)		   	 <= 	sigma_reg(n+1);
		deltaB(n-1 downto 0) <= 	zero;
		sigma_adder			 <= 	delta_adder + sigma_reg;
		dac_out				 <= 	dac_reg;
		
end arq;