

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;





entity WRAPPER_DEBOUNCER is
    Port (	
			CLK_i: in std_logic;
			RST_i: in std_logic;
			VALVE_i: in std_logic_vector(31 downto 0); -- 32 valvulas
			VALVE_o: out std_logic_vector(31 downto 0); -- 32 valvulas
			CLEAN_FLAG_o: out std_logic			
			);
			
end WRAPPER_DEBOUNCER;



architecture Behavioral of WRAPPER_DEBOUNCER is


signal s_clean_flag_from_mem: std_logic;
signal s_clean_flag_from_cd: std_logic;
signal s_state_from_mem: std_logic;
signal s_state_from_cd: std_logic;
signal s_current_valve: std_logic_vector(4 downto 0);
signal s_count_debounce_from_mem: std_logic_vector(7 downto 0);
signal s_count_debounce_from_cd: std_logic_vector(7 downto 0);

BEGIN

CLEAN_FLAG_o <= s_clean_flag_from_cd;


c1: entity work.COUNT_DEBOUNCER(Behavioral) 
    Port map (	
			CLK_i => CLK_i, 
			RST_i => RST_i,
			VALVE_i => VALVE_i,
			VALVE_o => VALVE_o,
			CLEAN_FLAG_o => s_clean_flag_from_cd,
			CLEAN_FLAG_i => s_clean_flag_from_mem,
			S_STATE_o => s_state_from_cd,
			S_STATE_i => s_state_from_mem,
			CURRENT_VALVE_i => s_current_valve,
			COUNT_DEBOUNCE_o => s_count_debounce_from_cd, 
			COUNT_DEBOUNCE_i => s_count_debounce_from_mem
			);
			
			
			
c2: entity work.MEM_CONTROL(Behavioral) 
    
	Port map (	
			CLK_i => CLK_i, 
			RST_i => RST_i,
			CLEAN_FLAG_o => s_clean_flag_from_mem,
			CLEAN_FLAG_i => s_clean_flag_from_cd,
			S_STATE_o => s_state_from_mem,
			S_STATE_i => s_state_from_cd,
			CURRENT_VALVE_o => s_current_valve,
			COUNT_DEBOUNCE_o => s_count_debounce_from_mem, 
			COUNT_DEBOUNCE_i => s_count_debounce_from_cd
			);
			

end Behavioral;			
			
