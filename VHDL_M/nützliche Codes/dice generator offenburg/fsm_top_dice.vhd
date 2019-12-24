
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity fsm_top_dice is
	 port(
		 time_out: out std_logic;
		 clk : in std_logic;
		 reset_n : in std_logic;
		 time_out_int : in STD_LOGIC;
		 finish : in std_logic;
		 speaker_int : in STD_LOGIC;
		 push_button : in std_logic;
		 push_button_int : out STD_LOGIC;
		 speaker : out std_logic;
		 reset_int : out STD_LOGIC
	     );
end fsm_top_dice;


architecture fsm_top_dice of fsm_top_dice is
	
	type  state_type  is  (sleep,reset,count_up,sound);
	signal state_reg, state_next:  state_type;	
	signal push_button_reg,push_button_next  : std_logic;
	
	 begin			 
	 
	 -- next_state register decoder
	 
	 nx_decoder: process(clk,reset_n)
	 begin	 	
		if reset_n = '0' then			 
			 state_reg <= sleep;
			 -- assinchrnonous imput is regged (button)
			 push_button_reg <= '0';
		elsif rising_edge(clk) then	 		
			state_reg <= state_next;
			push_button_reg <= push_button_next;   
		end if;
	 end process;
	 
 
	 push_button_int <= push_button_reg;
	
	
	-- next state decoder  
	 	 
	 process(state_reg,push_button,finish)
	 begin
	 	state_next <= state_reg;	
				
		case state_reg is 
	 		when sleep =>			
				if push_button = '1' then 					
	 				state_next <= reset;	 									
	 			end if;	
			   
			when reset =>                
				 -- to eliminate glitches, push button should at 
				 -- least last one clock cycle
				 if push_button = '0' then 					
	 				state_next <= sleep;	 									
	 			 else
				    state_next <= count_up;
				end if;		
				
			when count_up => 
			
				 if push_button = '1' then 					
	 				state_next <= count_up;	 									
	 			 else
				    state_next <= sound;
				end if;
				
			when sound =>                
				if finish = '1' then 
					state_next <= sleep;
				 else
				    state_next <= sound;
				end if;			
	 	end case;
	 end process; 
	 
	-- output decoder 
	
	out_decoder: process(state_reg,push_button,reset_n,speaker_int,time_out_int) 
	  begin	  
	  	-- default outputs
		speaker 			<= '0';
		reset_int		 	<= '1';
		time_out 			<= '0';
		push_button_next 	<= '0';
				
		  	case state_reg is
				when sleep =>
					 	time_out 			<= time_out_int;						
						-- conditions for asynchronous reset
						if push_button = '1' or reset_n = '0' then
							reset_int 		<= '0';				
						end if;						
				when reset =>
					 	reset_int	 		<= '0';	
						-- push_button_int should be 
						-- on when reset is off (in sync)
						if push_button = '1'  then
							push_button_next <= '1'; 	
						end if;
				when count_up => 					
						push_button_next 	<= '1';  				
				when sound => 
						speaker 			<= speaker_int;
				
			end case;  
		
	end process;     
	  
	  
	 

end fsm_top_dice;
