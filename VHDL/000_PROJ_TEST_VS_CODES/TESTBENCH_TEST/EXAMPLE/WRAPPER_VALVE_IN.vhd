library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity WRAPPER_VALVE_IN is
    Port (	
			CLK_i: in std_logic;
			CLK_i_pulse: in std_logic;
			RST_i: in std_logic;
			VALVE_i: in std_logic_vector(31 downto 0); -- 32 valvulas
			VALVE_o: out std_logic_vector(31 downto 0); -- 32 valvulas
			CLEAN_FLAG_o: out std_logic			
			);
			
end WRAPPER_VALVE_IN;



architecture Behavioral of WRAPPER_VALVE_IN is


signal s_valve_o: std_logic_vector(VALVE_i'range);

BEGIN



c1_INREG: entity WORK.IN_REG(behavorial)
  port map (
			CLK_i 	 	 	 => CLK_i,         
			CLK_i_pulse 	 => '1',              
			RESET_i 	 	 => RST_i,
			PROTO_o      	 => open,
			VALVE_I		 	 => VALVE_i,
			VALVE_O       	 => s_valve_o
    );



c2_WD: entity WORK.WRAPPER_DEBOUNCER(Behavioral)
    Port map (	
			CLK_i 	 	 	 => CLK_i,
			RST_i 	 	 	 => RST_i,
			VALVE_i 	 	 => s_valve_o,
			VALVE_o 	 	 => VALVE_o,
			CLEAN_FLAG_o 	 => CLEAN_FLAG_o			
			);

			
			
		

end architecture;


			
