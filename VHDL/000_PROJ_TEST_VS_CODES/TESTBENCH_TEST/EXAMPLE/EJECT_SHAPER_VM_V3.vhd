
library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


entity EJECT_SHAPER_VM_3 is
  port (
    CLK_i_150  	 	 : in  std_logic;  -- 150MHz CLK            
    CLK_i_10_pulse 	 : in  std_logic;  -- 10MHz CLK            
    RESET_i 	 	 : in  std_logic;
    VALVE_o		 	 : out std_logic;
	PROTO_o      	 : out std_logic;
	DIRT_i       	 : in std_logic
    );

end EJECT_SHAPER_VM_3;


architecture Behavioral of EJECT_SHAPER_VM_3 is
  
  constant CLOCK_MHz:           natural := 10;    
  
  -- DEBOUNCING
  CONSTANT EJECT_ON: 			NATURAL := 10*CLOCK_MHz; -- 10 us - time duration to consider the input signal a valid signal
  CONSTANT EJECT_OFF: 			NATURAL := 2*CLOCK_MHz; -- 2 us - time duration to consider that the valve signal is off
  CONSTANT DEBOUNCE_MAX:		NATURAL := EJECT_ON+10;
  
  -- DEFINITIONS
  CONSTANT PWM_ON: 				NATURAL := 14*CLOCK_MHz; 	-- 14 us
  CONSTANT PWM_OFF: 			NATURAL := 34*CLOCK_MHz; 	-- 34 us
  CONSTANT PWM_MAX: 			NATURAL := PWM_OFF+10;
  
  CONSTANT ACTIVE_TIME:			natural := 2200*CLOCK_MHz; -- 2.2 ms = ceil(log2(2200*10)) = 15 bits
    
  
  -- MINIMUM TIME TO CLOSE THE VALVE  
  constant WAIT_TIME:		 	natural := 1300*CLOCK_MHz; -- ceil(log2(1300*10)) = 14 bits = 1.3 ms
  CONSTANT COUNT_MAX: 			NATURAL := ACTIVE_TIME + 10;  
  
  
  
   -- FSMs
  type FSM_1 is (st_IDLE, st_ACTIVE, st_PWM_OFF, st_PWM_ON, ST_WAIT_TIME);  -- MAIN FSM
  signal state_reg, state_next                                   : FSM_1;
  

  type FSM_2 is (st_DIRT, st_CLEAN); 	 -- DEBOUNCE FSM
  signal state_fsm2_reg, state_fsm2_next                          : FSM_2;
  
  
  signal valv_counter_next, valv_counter_reg			: integer range 0 to COUNT_MAX-1;
  signal PWM_counter_reg, PWM_counter_next				: integer range 0 to PWM_MAX-1;
  signal count_debounce_next, count_debounce_reg		: integer range 0 to DEBOUNCE_MAX-1;
  
  signal VALVE_o_reg, VALVE_o_next: std_logic;  
  signal s_proto_reg, s_proto_next: std_Logic;  
 
  signal flag_finish_next, flag_finish_reg: std_Logic := '0'; 	
  signal s_clean_i_reg, s_clean_i_next: std_logic := '0';

  SIGNAL eje_i_reg1, eje_i_next1: std_logic;
  SIGNAL eje_i_reg2, eje_i_next2: std_logic;
  
  signal s_enable: std_logic;
    
begin

  VALVE_o	  	<= VALVE_o_reg;
  PROTO_o       <= s_proto_reg;    


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
	  
	  
	  
	  
    end if;
  end process registers;

  
 c0:  entity work.pos_edge_mealy_p_reset 
  port map (
    clock => CLK_i_150,
	reset => RESET_i,
    level => CLK_i_10_pulse, --  10 MHz pulse generator input
    tick  =>  s_enable -- enable signal for the fsms 
    );

  
  
  
	eje_i_next1 <= DIRT_i;
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
			


  fsm : process(VALVE_o_reg, state_reg, valv_counter_reg,  
  PWM_counter_reg, flag_finish_reg, s_proto_reg, s_clean_i_reg)

  begin

    --DEFAULT
	
	flag_finish_next            <= flag_finish_reg; 
	state_next          		<= state_reg;
	VALVE_o_next 				<= VALVE_o_reg;
	valv_counter_next 			<= valv_counter_reg;    
	PWM_counter_next    		<= PWM_counter_reg;
	s_proto_next 				<= s_proto_reg; 
	
	
    case state_reg is

      when st_IDLE =>
                                      
		s_proto_next        <= '1'; 
		VALVE_o_next 		<= '0';
		valv_counter_next   <= 0;

		if 	s_clean_i_reg = '1' then 
		state_next 			<= st_ACTIVE;
		end if;

      
	  when st_ACTIVE =>
		s_proto_next <= '0';
        
		if valv_counter_reg = ACTIVE_TIME then 		
			VALVE_o_next    	<= '0';
			PWM_counter_next    <= 0;
			state_next 			<= st_PWM_OFF;
			valv_counter_next   <= 0;
			
		else 
			VALVE_o_next    	<= '1';
			valv_counter_next   <= valv_counter_reg + 1;			
			state_next 			<= st_ACTIVE;
	    end if;
		
		
		
	   when st_PWM_OFF =>
	   
	   
	   -- flag and input check --------------------------------
		if s_clean_i_reg  = '0' then 	
			flag_finish_next    <= '1';					
		else
			flag_finish_next    <= '0';	
		end if; 
		---------------------------------------------------------
		
			
		if PWM_counter_reg = PWM_OFF then 
		
			if flag_finish_reg = '0' then
				VALVE_o_next		<= '1';
				PWM_counter_next    <= 0;
				state_next 			<= st_PWM_ON;
			else
				flag_finish_next    <= '0';
				VALVE_o_next		<= '0';
				PWM_counter_next    <= 0;	
				valv_counter_next   <= 0;					
				state_next 			<= st_WAIT_TIME;
		    end if;
				
		else 
			VALVE_o_next    	<= '0';
			PWM_counter_next    <= PWM_counter_reg + 1;			
			state_next 			<= st_PWM_OFF;
	    end if;
		
		----------------------------------------------
		
		
	   
	   when st_PWM_ON =>
	    
		  -- flag and input check --------------------------------
		if s_clean_i_reg  = '0' then 	
			flag_finish_next    <= '1';					
		else
			flag_finish_next    <= '0';	
		end if; 
		---------------------------------------------------------
		
			
		
		if PWM_counter_reg = PWM_ON then 
			
			if flag_finish_reg = '0' then
				VALVE_o_next		<= '0';
				PWM_counter_next    <= 0;
				state_next 			<= st_PWM_OFF;
			else
				flag_finish_next    <= '0';
				VALVE_o_next		<= '0';
				PWM_counter_next    <= 0;	
				valv_counter_next   <= 0;		
				state_next 			<= st_WAIT_TIME;
		    end if;
				
		else 
			VALVE_o_next    	<= '1';
			PWM_counter_next    <= PWM_counter_reg + 1;			
			state_next 			<= st_PWM_ON;
	    end if;
		
		----------------------------------------------
		
		
	    when st_WAIT_TIME =>
	    
		if valv_counter_reg = WAIT_TIME then 		
			VALVE_o_next    	<= '0';
			valv_counter_next   <= 0;
			state_next 			<= st_IDLE;
		else 
			VALVE_o_next    	<= '0';
			valv_counter_next   <= valv_counter_reg + 1;			
			state_next 			<= ST_WAIT_TIME;
		end if;	

      when others =>
		state_next <= st_IDLE;

    end case;

  end process fsm;


end Behavioral;



