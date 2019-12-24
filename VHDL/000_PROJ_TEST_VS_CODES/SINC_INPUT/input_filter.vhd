 
library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
 
 
 entity INPUT_FILTER is
  port (
    CLK_i_150  	 	 : in  std_logic;  -- 150MHz CLK            
    CLK_i_10_pulse 	 : in  std_logic;  -- 10MHz CLK            
    RESET_i 	 	 : in  std_logic;
    EJECT_i		 	 : in std_logic;
    EJECT_o		 	 : out std_logic
	
    );

end INPUT_FILTER;


architecture Behavioral of INPUT_FILTER is

 
  CONSTANT DEBOUNCE_MAX:		NATURAL := EJECT_ON+10;
 
  type FSM_2 is (st_DIRT, st_CLEAN); 	 -- DEBOUNCE FSM
  signal state_fsm2_reg, state_fsm2_next                          : FSM_2;
  

 signal count_debounce_next, count_debounce_reg		: integer range 0 to DEBOUNCE_MAX-1;
  SIGNAL eje_i_reg1, eje_i_next1: std_logic;
  SIGNAL eje_i_reg2, eje_i_next2: std_logic;
	
  signal s_enable: std_logic;
   
begin


registers : process (CLK_i_150, RESET_i)  -- 1MHz
  begin
    
	if (RESET_i = '1') then
	
	  count_debounce_reg						  <= 0;	
	  state_fsm2_reg  							  <= st_DIRT;
	  s_clean_i_reg								  <= '0';  
	  ---------------------------------------------------
	  eje_i_reg1								  <= '0';
	  eje_i_reg2								  <= '0';
	  
	elsif rising_edge(CLK_i_150) then
		
      if s_enable = '1' then 	  
		 
		  count_debounce_reg 						  <= count_debounce_next; 	
		  state_fsm2_reg							  <= state_fsm2_next;	
		  s_clean_i_reg 							  <= s_clean_i_next;
			---------------------------------------------------
		  eje_i_reg1								  <= eje_i_next1;
		  eje_i_reg2								  <= eje_i_next2;
		  
	  end if;
	  
    end if;
  end process registers	  
	  

	  
c0:  entity work.pos_edge_mealy_p_reset 
		port map (
			clock => CLK_i_150,
			reset => RESET_i,
			level => CLK_i_10_pulse, --  10 MHz pulse generator input
			tick  =>  s_enable -- enable signal for the fsms 
		);


registers : process (CLK_i_150, RESET_i)  -- 1MHz
  begin
    
	if (RESET_i = '1') then

	  valv_counter_reg                            <= 0;	
	  PWM_counter_reg                             <= 0;
      state_reg                                   <= st_IDLE;
	  VALVE_o_reg 							  	  <= '0';	
	  s_proto_reg 								  <= '0';   	 
	  flag_finish_reg							  <= '0'; 	
      ---------------------------------------------------
	  count_debounce_reg						  <= 0;	
	  state_fsm2_reg  							  <= st_DIRT;
	  s_clean_i_reg								  <= '0';  
	  ---------------------------------------------------
	  eje_i_reg1								  <= '0';
	  eje_i_reg2								  <= '0';
	  
	elsif rising_edge(CLK_i_150) then
		
      if s_enable = '1' then 	  
	  
		  state_reg                                   <= state_next;
		  valv_counter_reg                            <= valv_counter_next;	
		  VALVE_o_reg 							  	  <= VALVE_o_next;	
		  PWM_counter_reg                             <= PWM_counter_next;
		  s_proto_reg                                 <= s_proto_next;  	 
		  flag_finish_reg                             <= flag_finish_next; 
		  ---------------------------------------------------
		  count_debounce_reg 						  <= count_debounce_next; 	
		  state_fsm2_reg							  <= state_fsm2_next;	
		  s_clean_i_reg 							  <= s_clean_i_next;
			---------------------------------------------------
		  eje_i_reg1								  <= eje_i_next1;
		  eje_i_reg2								  <= eje_i_next2;
		  
	  end if;


	eje_i_next1 <= EJECT_i;
	eje_i_next2 <= eje_i_reg1; 
  
  
  
  debounce: process(eje_i_reg2, count_debounce_reg, state_fsm2_reg, s_clean_i_reg) 
		begin
		  
			count_debounce_next <= count_debounce_reg;
			state_fsm2_next <= state_fsm2_reg;
		    s_clean_i_next  <= s_clean_i_reg;
	 
	 case state_fsm2_reg is	
		
		when st_DIRT =>
		
		   
		
			if eje_i_reg2 = '1' then 
											
				if count_debounce_reg = EJECT_ON then  -- DEBOUNCE = 10 us
					count_debounce_next   <= 0;
					state_fsm2_next <= st_CLEAN;
					s_clean_i_next 		<=  '1';
				else 
					count_debounce_next <= count_debounce_reg + 1;
					state_fsm2_next <= st_DIRT;
					s_clean_i_next 		<=  '0';
				end if;		
			
			else	
				count_debounce_next   <= 0;
				state_fsm2_next <= st_DIRT;
				s_clean_i_next 		<=  '0';
			end if;
			
				
		when st_CLEAN =>
			
			if eje_i_reg2 = '0' then 			 
			 
				if count_debounce_reg = EJECT_OFF then  -- DEBOUNCE = 1 us			
					count_debounce_next   <= 0;
					state_fsm2_next <= st_DIRT;
					s_clean_i_next 		<=  '0';
				else 
					count_debounce_next <= count_debounce_reg + 1;
					state_fsm2_next <= st_CLEAN;
					s_clean_i_next 		<=  '1';
				end if;
			
			else	
				count_debounce_next   <= 0;
				state_fsm2_next <= st_CLEAN;
				s_clean_i_next 		<=  '1';
			end if;
		end case;
		
		
	end process;	