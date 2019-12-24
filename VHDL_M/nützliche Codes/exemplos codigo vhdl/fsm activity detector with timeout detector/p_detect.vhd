library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all; 

entity p_detect is
  
  port (	
	reset:				in std_logic;
	clk: 				in 	std_logic;
	OK_o:         		out std_logic; 
	FEEDBACK_i:         in std_logic
    );

end entity p_detect;



architecture ARQ of p_detect is

	type   FSM_TYPE is (ST_WAIT_1ST_PULSE, ST_1ST_PULSE, ST_WAIT_2ND_PULSE, ST_2ND_PULSE);
	signal state_reg, state_next : FSM_TYPE;
    signal timer_reg, timer_next: unsigned(14 downto 0); -- max count 32768
	signal not_reset, s_ok_reg, s_ok_next: std_logic;
	signal pos_edge_next, pos_edge_reg: std_logic;
	CONSTANT MAX_LIMIT: natural := 100_000;   -- 1s / 10us (100kHz)

begin

--registers
  process(reset, clk)
  begin
    if reset = '1' then
		state_reg	    					<= ST_WAIT_1ST_PULSE;	
		timer_reg 							<= (others => '0');
		s_ok_reg             				<= '0' 	
    elsif rising_edge(clk) then
		timer_reg                           <= timer_next; 
		state_reg							<= state_next;	
		s_ok_reg		                    <= s_ok_next;
    end if;
  end process;

 
not_reset <= not reset;	
	
c1: entity work.pos_edge_mealy
  port map(
    clock => clk, 
	n_reset => not_reset, 
    level => FEEDBACK_i, 
    tick  => pos_edge_reg 
    );

OK_o <= s_ok_reg;

-- state machine 	
  fsm1: process(state_reg, pos_edge_reg, timer_reg)
  begin
	
	state_next	   		<= state_reg;	
	s_ok_next    		<= s_ok_reg 
	s_clear_ejection_1 	<= '0';
	timer_next 			<= timer_reg;
   
   case state_reg is
	
	--espera ocorrer a primeira tansição 
	when ST_WAIT_1ST_PULSE =>
		
		if timer_reg = 	MAX_LIMIT then  -- se ultrapassar o tempo maximo ...
			timer_next <= (others => '0'); 
			s_ok_next  <= '0';           -- limpa a flag ok   
		else 
			timer_next <= timer_reg + 1;
		end if;
		
		if pos_edge_reg = '1' then
			state_next <= ST_1ST_PULSE;
			timer_next <= (others => '0'); 
		end if;
		
	

    when ST_1ST_PULSE =>		
		state_next <= ST_WAIT_2ND_PULSE;

		
	 when ST_WAIT_2ND_PULSE =>
			
		if timer_reg = 	MAX_LIMIT then  -- se ultrapassar o tempo maximo ...
			timer_next <= (others => '0'); 
			s_ok_next  <= '0';           -- limpa a flag ok   
		else 
			timer_next <= timer_reg + 1;
		end if;
		
		if pos_edge_reg = '1' then
			state_next <= ST_2ND_PULSE;
			timer_next <= (others => '0'); 
		end if;
		
	when ST_2ND_PULSE =>
		s_ok_next    		<= '1';
		state_next <= ST_WAIT_1ST_PULSE;

		
	when others => 
	 state_next <= ST_WAIT_1ST_PULSE;
    end case;    

  end process;
  
end ARQ;
