


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- freq: 32 Hz
entity bin_counter_updown is
	generic 
	(	 		
		MAX: natural:= 63; -- maximum value (2**N)-1
		N: integer  := 6;  -- ceil(log2(MAX))
		MIN: natural:= 0   -- minimum value 
	);
	port 
		(
			acc_carry:				in		std_logic;
			up:						in		std_logic; 	
			clock,reset: 			in 		std_logic;
			enable:					in 		std_logic;			
			carry: 					out 	std_logic;
			zero: 					out 	std_logic;
			q: 						out 	std_logic_vector(n-1 downto 0)
		);	
end bin_counter_updown;

	
	architecture arq  of  bin_counter_updown  is		
		signal 		enable_int:	std_logic;	 
		signal   	r_reg: 		unsigned(N-1 downto 0);		-- reg
		signal   	r_next:  	unsigned(N-1 downto 0);  	-- reg		
		
		begin 				
			
			
			--================--
			-- enable mux, selects diferent speeds
			-- when the button is not pressed 
			-- enable: 32 Hz
			--================--			
			
			  enable_int <= enable when up = '1' else acc_carry;   
			
			--================--
			-- register 
			--================--			
			
			reg_sinc: process (clock,  reset, enable) 
			begin 				
				if reset = '0' then 
					r_reg  		<=  (others => '0'); 				
				elsif rising_edge(clock) then
					if enable_int = '1' then 
						r_reg  		<=  r_next;							 
					end if;	 					
				end if;	 
			end process; 
						
			--================--
			-- next state logic  
			-- combinatorial
			--================--	
			
			process(up,r_reg) 			
			begin			
			 	if (up = '1') then											 
					 if r_reg = MAX then 						 
						 -- it keeps the same value if MAX is reached
						 r_next <= r_reg; 
					 else
						 r_next <= r_reg + 1;					 
					 end if;  						 
				else									
					if r_reg = MIN then						 
						 -- it keeps the same value if MIN is reached
						 r_next <= r_reg; 
					 else
						 r_next <= r_reg - 1;						
					 end if;					
						 
				end if;	 	
			
			end process;
								
			--================--
			-- output logic	-   
			-- not registered
			--================-- 			
			process(r_reg)
			begin
				-- default outputs
				zero  <= '0';
				carry <= '0';  
				-- conditional outputs
				if r_reg = MIN then 
					zero <= '1';
					elsif 
						r_reg = MAX then
							carry <= '1';
				end if;	
			end process;
				
			
			q  	 <=   std_logic_vector(r_reg); 		
			
			
			 
end arq;
					
				
					
					
					

				
					
					
					

