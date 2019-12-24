library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all; 


entity EJECT_SHAPER is
    Port ( 	
				CLK_i : IN std_logic;	-- 10 MHz / 100 ns maximum resolution	 		
				RESET_i : IN std_logic;
				EJECT_i : IN std_logic;  -- 
				EJECT_o  : OUT std_logic
				);
				
end EJECT_SHAPER;


  architecture Behavioral of EJECT_SHAPER is

  type FSM_1 is (st_IDLE, st_ACTIVATION_PULSE, st_PWM_BOOST_low, st_PWM_BOOST_high, st_DEAD_time, st_PWM_high,  st_PWM_low)
  signal state_reg, state_next: FSM_1;
  type FSM_2 is (st_ACT_IDLE, st_COUNT)
  signal state_activation_total_reg, state_activation_total_next: FSM_2; 	
	
	
	constant COUNTER_debounc_MAX: natural: 100; -- 10 us (100 ns clock)
	constant COUNTER_debounc_bits: natural:= ceil(log2(COUNTER_debounc_MAX));
	constant COUNTER_max: 100_000; -- 10 ms  (100 ns clock)
	constant COUNTER_bits: natural:= ceil(log2(COUNTER_max));
	
	constant C_EJ_DEBOUNCE_COUNT: natural := 100; -- 10 us (100 ns clock)
	constant C_ACTIVATION_COUNT: natural := 4_000; -- 400 us
	constant C_ACTIVATION_COUNT_low: natural := 50; -- 5 us 
	constant C_ACTIVATION_COUNT_high: natural := 70; -- 7 us 
	constant C_DEAD_TIME: natural := 100; -- 10 us
	constant C_PWM_HIGH: natural := 50; -- 5 us  
	constant C_PWM_LOW : natural := 30; -- 3 us  
	
	constant C_ACTIVATION_TOTAL: natural := 16_000;  -- 1.6 ms
	constant C_ACTIVATION_TOTAL_bits: natural ceil(log2(C_ACTIVATION_TOTAL));


	
	signal EJECT_o_reg, EJECT_o_next: std_logic;
	signal flag_start_activation_counter_reg, flag_start_activation_counter_next: std_logic;
	signal flag_clear_total_activation_counter_end_reg, flag_clear_total_activation_counter_end_next: std_logic;
	signal s_has_ejection_reg, s_has_ejection_next: std_logic;
	signal s_COUNTER_debounc_reg, s_COUNTER_debounc_next: unsigned(COUNTER_debounc_bits-1 downto 0);
	signal s_COUNTER_reg, s_COUNTER_next: unsigned(COUNTER_bits-1 downto 0);
	signal total_activation_counter_end_reg, total_activation_counter_end_next: std_logic; 
	signal s_activation_total_reg, s_activation_total_next: unsigned(C_ACTIVATION_TOTAL_bits-1 downto 0);
	
	
		
	
	begin
		
   
   
   
   registers: process (CLK_i,RESET_i) -- 10MHz
	begin	
			if (RESET_i = '1') then
				
				state_reg <= st_IDLE;
				EJECT_o_reg < ='0';
				flag_start_activation_counter_reg <= '0';
				flag_clear_total_activation_counter_end_reg <= '0';
				s_COUNTER_debounc_reg <= (others => '0');
				s_has_ejection_reg <= '0';
				s_COUNTER_reg <= (others => '0');
				state_activation_total_reg <= st_ACT_IDLE;
				total_activation_counter_end_reg <= '0';
				s_activation_total_reg <= (others => '0');
			
			elsif rising_edge(CLK_i)
					
				s_has_ejection_reg <= s_has_ejection_next;
				state_reg <= state_next;
				EJECT_o_reg <= EJECT_o_next;
				flag_start_activation_counter_reg <= flag_start_activation_counter_next;
				flag_clear_total_activation_counter_end_reg <= flag_clear_total_activation_counter_end_next;
				s_COUNTER_debounc_reg <= s_COUNTER_debounc_next;
				s_COUNTER_reg <= s_COUNTER_next;
				state_activation_total_reg <= state_activation_total_next;
				total_activation_counter_end_reg <= total_activation_counter_end_next;
				s_activation_total_reg <= s_activation_total_next;
			end if;
	end process registers;		
			


	fsm: process(state_reg, EJECT_o_reg, s_COUNTER_debounc_reg,s_has_ejection_reg, EJECT_i)
			
		begin

			--DEFAULT
			state_next 								<= state_reg;
			EJECT_o_next 							<= EJECT_o_reg;						
			flag_start_activation_counter_next 				<= '0';
			flag_clear_total_activation_counter_end_next 	<= '0';			
			s_COUNTER_debounc_next					<= s_COUNTER_debounc_reg;
			s_has_ejection_next 					<= s_has_ejection_reg;
			s_COUNTER_next 							<= s_COUNTER_reg;
			
			----- ejeção parou?? -----
				if EJECT_i = '0' then	
					s_COUNTER_debounc_next <= s_COUNTER_debounc_reg + 1; 
					
					if 	s_COUNTER_debounc_reg = to_unsigned(COUNTER_debounc_MAX, COUNTER_debounc_bits) then 
						s_has_ejection_next <= '0';
						s_COUNTER_debounc_next <= (others => '0');				 		
					end if;	
						
					else		
						s_COUNTER_debounc_next <= (others => '0');						
				end if;	
			
			
			
			case state_reg is 
		
				when st_IDLE => 
					
					---- EJEÇÃO COMEÇOU?
					if EJECT_i = '1' then	
						s_COUNTER_next <= s_COUNTER_reg + 1; 
						
						if 	s_COUNTER_reg = to_unsigned(C_EJ_DEBOUNCE_COUNT, COUNTER_bits) then 
							state_next <= st_ACTIVATION_PULSE;
							s_COUNTER_next <= (others => '0');
							flag_start_activation_counter_next <= '1';					
							s_has_ejection_next	<= '1'; 						
						end if;	
						
					else		
						s_COUNTER_next <= (others => '0');
						state_next <= st_IDLE;
					end if;	
				
				when st_ACTIVATION_PULSE => 
				
					
					if s_COUNTER_reg = to_unsigned(C_ACTIVATION_COUNT,COUNTER_bits) then 
							s_COUNTER_next <= (others => '0');
							state_next <= st_PWM_BOOST_low;
							EJECT_o_next <= '0'; 
				
					else 
							EJECT_o_next <= '1'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_ACTIVATION_PULSE;
								
					end if;
					
				when st_PWM_BOOST_low =>									
												
					
					if s_COUNTER_reg = to_unsigned(C_ACTIVATION_COUNT_low,COUNTER_bits) then 
							
							s_COUNTER_next <= (others => '0');
							 
							
							if total_activation_counter_end_reg = '1' then 
								EJECT_o_next <= '0';
								state_next <= st_DEAD_time;
								flag_clear_total_activation_counter_end_next <= '1';  		
							else
								EJECT_o_next <= '1';	
								state_next <= st_PWM_BOOST_high;
							end if;
							
					else 
							EJECT_o_next <= '0'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_PWM_BOOST_low;
					end if;
					
					
				when st_PWM_BOOST_high>									
												
					
					if s_COUNTER_reg = to_unsigned(C_ACTIVATION_COUNT_high,COUNTER_bits) then 
							
							s_COUNTER_next <= (others => '0');
							EJECT_o_next <= '0'; 
							state_next <= st_PWM_BOOST_low;							
					else 
							EJECT_o_next <= '1'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_PWM_BOOST_high;
					end if;
					
					
				when st_DEAD_time => 
						
					if s_COUNTER_reg = to_unsigned(C_DEAD_TIME,COUNTER_bits) then 
							
							s_COUNTER_next <= (others => '0');
							EJECT_o_next <= '1'; 
							state_next <= st_PWM_high;	
					else 
							EJECT_o_next <= '0'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_DEAD_time;
							
					end if;	
					
					--- ends ejection
					if s_has_ejection_reg = '0' then 
							EJECT_o_next <= '0'; 
							state_next <= st_IDLE;
							s_COUNTER_next <= (others => '0');						
					end if; 
					
				
				when st_PWM_high => 
				
					if s_COUNTER_reg = to_unsigned(C_PWM_HIGH,COUNTER_bits) then 
							
							s_COUNTER_next <= (others => '0');
							EJECT_o_next <= '0'; 
							state_next <= st_PWM_low;
					else 
							EJECT_o_next <= '1'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_PWM_high;
							
					end if;	
					
					
					
				when st_PWM_low =>									
												
					
					if s_COUNTER_reg = to_unsigned(C_PWM_LOW,COUNTER_bits) then 
							
							s_COUNTER_next <= (others => '0');
							 
						
							if s_has_ejection_reg = '0'  then 
								EJECT_o_next <= '0';
								state_next <= st_IDLE;								  		
							else	
								EJECT_o_next <= '1';
								state_next <= st_PWM_BOOST_high;
							end if;		
							
					else 
							EJECT_o_next <= '0'; 
							s_COUNTER_next <= s_COUNTER_reg + 1;
							state_next <= st_PWM_BOOST_low;
					end if;
					
					
					when others => 
					
			end case;
		
		end process fsm;
					
							

		activation: process(state_activation_total_reg, total_activation_counter_end_reg, s_activation_total_reg)
			begin
					
				state_activation_total_next <= state_activation_total_reg;
				total_activation_counter_end_next <= total_activation_counter_end_reg; 
				s_activation_total_next <= s_activation_total_reg;
				
				case state_activation_total_reg is
						
						when st_ACT_IDLE =>
							
							if flag_start_activation_counter_reg = '1' then	
								state_activation_total_next <= st_COUNT;
								else
								state_activation_total_next <= flag_start_activation_counter_reg;
							end if;		
							
						when st_COUNT => 							
						
							
							if s_activation_total_reg <= to_unsigned(C_ACTIVATION_TOTAL,C_ACTIVATION_TOTAL_bits) then 								
								total_activation_counter_end_next <= '1'
								
								if 	flag_clear_total_activation_counter_end_reg = '1' then
									s_activation_total_next <= (others => '0');
									state_activation_total_next <= st_ACT_IDLE;
									total_activation_counter_end_next <= '0';
								end if;	
							
							else								
								s_activation_total_next <=  s_activation_total_reg + 1;	
								state_activation_total_next <= st_COUNT;
							end if;		
						
						when others =>
				end case;
			end if;
		end process activation;
		
	end Behavioral;	
		
		
	
						
						
						
			
			
	

	

							


			
							
								
					
					
					
					
					
					
				
						
				
				
				
					
					
					
					
					
					
			