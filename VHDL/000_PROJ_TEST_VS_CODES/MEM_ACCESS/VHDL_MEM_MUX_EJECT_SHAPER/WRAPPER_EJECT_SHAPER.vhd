

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;





entity WRAPPER_EJECT_SHAPER is
    Port (	
			CLK_i: in std_logic;
			RST_i: in std_logic;
			VALVE_CTRL_IHM_i: in std_logic_vector(31 downto 0); -- 32 valvulas
			VALVE_o: out std_logic_vector(31 downto 0)			
			);
			
end WRAPPER_EJECT_SHAPER;



architecture Behavioral of WRAPPER_EJECT_SHAPER is

signal s_current_valve: std_logic_vector(4 downto 0);

signal s_fsm_state_from_es, s_fsm_state_from_mc: std_logic_vector(3 downto 0);

signal s_flag_finish_from_es, s_flag_finish_from_mc: std_logic;

signal s_valve_counter_from_es, s_valve_counter_from_mc: std_logic_vector(12 downto 0);

signal s_pwm_counter_from_es, s_pwm_counter_from_mc: std_logic_vector(6 downto 0);


BEGIN


			
C1:  entity work.EJECT_SHAPER(Behavioral) 
    Port map(	
			CLK_i 				=> CLK_i,
			RST_i				=> RST_i,
			FSM_STATE_o			=> s_fsm_state_from_es,
			FSM_STATE_i			=> s_fsm_state_from_mc,
			FLAG_FINISH_o		=> s_flag_finish_from_es,
			FLAG_FINISH_i		=> s_flag_finish_from_mc,
			VALVE_o				=> VALVE_o,
			VALVE_i				=> VALVE_CTRL_IHM_i,
			VALV_COUNTER_o		=> s_valve_counter_from_es,
			VALV_COUNTER_i		=> s_valve_counter_from_mc,
			PWM_COUNTER_o 		=> s_pwm_counter_from_es, 
			PWM_COUNTER_i		=> s_pwm_counter_from_mc,
			CURRENT_VALVE_i		=> s_current_valve
		
			);

			
			
c2: entity work.MEM_CONTROL_ES(Behavioral) 
    
	Port map (	
			CLK_i 				=> CLK_i, 
			RST_i 				=> RST_i,
			FSM_STATE_o			=> s_fsm_state_from_mc,
			FSM_STATE_i			=> s_fsm_state_from_es,
			FLAG_FINISH_o		=> s_flag_finish_from_mc,
			FLAG_FINISH_i		=> s_flag_finish_from_es,
			VALV_COUNTER_o		=> s_valve_counter_from_mc,
			VALV_COUNTER_i		=> s_valve_counter_from_es,
			PWM_COUNTER_o		=> s_pwm_counter_from_mc,
			PWM_COUNTER_i 		=> s_pwm_counter_from_es,
			CURRENT_VALVE_o 	=> s_current_valve
			
			);
			

end Behavioral;			
			
