
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity COUNT_DEBOUNCER is
    Port (	
			CLK_i: in std_logic;
			RST_i: in std_logic;
			VALVE_i: in std_logic_vector(31 downto 0); -- 32 valvulas
			VALVE_o: out std_logic_vector(31 downto 0); -- 32 valvulas
			CLEAN_FLAG_o: out std_logic;
			CLEAN_FLAG_i: in std_logic;
			S_STATE_o: out std_logic;
			S_STATE_i: in std_logic;
			CURRENT_VALVE_i: in std_logic_vector(4 downto 0); -- valvula atual
			COUNT_DEBOUNCE_o: out std_logic_vector(7 downto 0); 
			COUNT_DEBOUNCE_i: in  std_logic_vector(7 downto 0) 
			);
			
end COUNT_DEBOUNCER;

architecture Behavioral of COUNT_DEBOUNCER is

  --constant CLOCK_MHz:           natural := 10;    -- 100* 0.667 us
  
  -- DEBOUNCING
  CONSTANT EJECT_ON: 				NATURAL := 12; -- 12*16*27ns (37.5 MHz) -- aprox 5 us
  CONSTANT EJECT_OFF: 			NATURAL := 12;

begin
	
	
	process (RST_i, CLK_i)
	begin
		if falling_edge(CLK_i) then
			if (RST_i = '1') then		
					COUNT_DEBOUNCE_o   	<=  ( others => '0');
					S_STATE_o			<=  '0';
					CLEAN_FLAG_o		<=  '0';
					VALVE_o				<= (others => '0');
			else
					COUNT_DEBOUNCE_o <= COUNT_DEBOUNCE_i;
					S_STATE_o			<=  S_STATE_i;
					CLEAN_FLAG_o		<=  CLEAN_FLAG_i;
										
				case S_STATE_i is
				
					when '0' => 	

						if VALVE_i(CONV_INTEGER(CURRENT_VALVE_i)) = '1' then 
											
							if COUNT_DEBOUNCE_i = EJECT_ON then  -- DEBOUNCE = 10 us
								COUNT_DEBOUNCE_o   	<=  ( others => '0');
								S_STATE_o 			<= 	'1';
								CLEAN_FLAG_o 		<=  '1';
								VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '1';
							else 
								COUNT_DEBOUNCE_o <= COUNT_DEBOUNCE_i + 1;
								S_STATE_o 			<= 	'0';
								CLEAN_FLAG_o 		<=  '0';
								VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '0';
							end if;		
			
						else	
							COUNT_DEBOUNCE_o   	<=  (others => '0');
							S_STATE_o		    <= '0';
							CLEAN_FLAG_o 		<=  '0';
							VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '0';
						end if;
					
					when '1' => 	

						if VALVE_i(CONV_INTEGER(CURRENT_VALVE_i)) = '0' then	 
				 
							if COUNT_DEBOUNCE_i = EJECT_OFF then  -- DEBOUNCE = 1 us			
								COUNT_DEBOUNCE_o   <= ( others => '0');
								S_STATE_o		   <= '0';
								CLEAN_FLAG_o 	   <=  '0';
								VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '0';
							else 
								COUNT_DEBOUNCE_o <= COUNT_DEBOUNCE_i + 1;
								S_STATE_o 			<= '1';
								CLEAN_FLAG_o 		<=  '1';
								VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '1';
							end if;
				
						else	
							COUNT_DEBOUNCE_o   <= ( others => '0');
							S_STATE_o 			<= '1';
							CLEAN_FLAG_o 		<=  '1';
							VALVE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= '1';
						end if;
						
					when others => 

							COUNT_DEBOUNCE_o <= COUNT_DEBOUNCE_i;
							S_STATE_o			<=  S_STATE_i;
							CLEAN_FLAG_o		<=  CLEAN_FLAG_i;
						
				end case;

			end if;
		end if;
	end process;

end Behavioral;