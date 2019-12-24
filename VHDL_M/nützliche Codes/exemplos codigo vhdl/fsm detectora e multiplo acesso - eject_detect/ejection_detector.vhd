library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all; 

entity ejection_detector is
  
  port (	
	reset:				 in std_logic;
	clk: 				in 	std_logic;
	clear_ejection_i: 	in 	std_logic;
	ejection_o:         out std_logic; 
	FEEDBACK_i:          in std_logic
    );

end entity ejection_detector;



architecture ARQ of ejection_detector is

	type   FSM_TYPE is (ST_IDLE,ST_1ST_PULSE, ST_2ND_PULSE_ON, ST_2ND_PULSE_OFF);
	type   FSM_D_TYPE is (NO_EJECT, HAS_EJECT); 
	signal state_reg, state_next : FSM_TYPE;
	signal state_reg_EJECT, state_next_EJECT : FSM_D_TYPE;
	signal s_clear_ejection, s_eject: 	std_logic := '0' ; 
	signal s_eject_0, s_clear_ejection_0: std_logic;
    signal  counter_reg, counter_next, timer_reg, timer_next: unsigned(14 downto 0); -- max count 32768
	signal s_ejections_has_ocurred_reg: std_logic  := '0';
	signal s_ejections_has_ocurred_next: std_logic := '0';  
	signal not_reset: std_logic;
	signal neg_edge_reg, pos_edge_reg: std_logic;
	signal s_clear_ejection_1: std_logic; 
	
	

	constant PULSE_LARGE: natural := 500;
	constant TOLERANCE_PL: natural := 20;
	constant TIMEOUT_LARGE: natural :=  2*PULSE_LARGE; 
	constant PULSE_PWM: natural := 70;
	constant TJET_BEFORE_PWM: natural := 15;
	constant TOLERANCE_PP: natural :=  10;
	constant TIMEOUT_SMALL: natural := 2*PULSE_PWM;
	CONSTANT MAX_LIMIT: natural := 20_000;   -- 20 ms / 1 us(periodo 1 MHz)

begin

--registers
  process(reset, clk)
  begin
    if reset = '1' then
		state_reg	    					<= ST_IDLE;
		counter_reg 						<= (others => '0');
		s_ejections_has_ocurred_reg	 		<= '0';
		state_reg_EJECT 					<= NO_EJECT;
		timer_reg 							<= (others => '0');
    elsif rising_edge(clk) then
		timer_reg                           <= timer_next;  
		state_reg_EJECT 					<= state_next_EJECT;
		s_ejections_has_ocurred_reg	 		<= s_ejections_has_ocurred_next;
		state_reg							<= state_next;	
		counter_reg 						<= counter_next;
    end if;
  end process;

  
ejection_o <= s_ejections_has_ocurred_reg; 
  
not_reset <= not reset;	
	
c0: entity work.neg_edge_mealy 
  port map (
    clock 	=> clk, 
	n_reset => not_reset, 
    level  	=> FEEDBACK_i,         
    tick 	=> neg_edge_reg 
    );


c1: entity work.pos_edge_mealy
  port map(
    clock => clk, 
	n_reset => not_reset, 
    level => FEEDBACK_i, 
    tick  => pos_edge_reg 
    );


	----------------------------------------------------------------------------
	-- this structure allows multiple access to the register
	----------------------------------------------------------------------------
	s_clear_ejection <= clear_ejection_i OR s_clear_ejection_1; 
    s_eject			 <= s_eject_0;
	
	-- ejection reg set clear	
	process(state_reg_EJECT, s_clear_ejection, s_eject)
		begin
			s_ejections_has_ocurred_next <= s_ejections_has_ocurred_reg;	
			state_next_EJECT 			 <= state_reg_EJECT;
			
			case state_reg_EJECT is
				--espera ocorrer a ejeção
				when NO_EJECT =>
					s_ejections_has_ocurred_next <= '0';
					if s_eject = '1' then 
						state_next_EJECT <= HAS_EJECT;
					end if;
				
				when HAS_EJECT =>
					s_ejections_has_ocurred_next <= '1';
					if s_clear_ejection = '1' then 
						state_next_EJECT <= NO_EJECT;
					end if;
			end case;
	end process;
	
	-----------------------------------------------------------------------------   

	
	-- state machine 	
  fsm1: process(state_reg, counter_reg, neg_edge_reg, pos_edge_reg, timer_reg)
  begin
	
	state_next	   		<= state_reg;
	counter_next 		<= counter_reg;	
	s_eject_0    		<= '0'; 
	s_clear_ejection_1 	<= '0';
	timer_next 			<= timer_reg;
   
   case state_reg is
	
	--espera ocorrer a ejeção
	when ST_IDLE =>
		
		if timer_reg = 	MAX_LIMIT then 
			timer_next <= (others => '0'); 
			s_clear_ejection_1 <= '1';
		else 
			timer_next <= timer_reg + 1;
		end if;
		
		s_eject_0    		<= '0';
		counter_next 		<= (others => '0') ;	
		
		if neg_edge_reg = '1' then
			state_next <= ST_1ST_PULSE;
			timer_next <= (others => '0'); 
		end if;
		
	

    when ST_1ST_PULSE =>
		counter_next <= counter_reg + 1;
	
		if (pos_edge_reg = '1') then 			
			counter_next <= (others => '0');			
			if (counter_reg > PULSE_LARGE-TOLERANCE_PL) OR (counter_reg < PULSE_LARGE+TOLERANCE_PL) then
				state_next <= ST_2ND_PULSE_ON;
			else
				state_next <= ST_IDLE;	
			end if;
		else
			if counter_reg > TIMEOUT_LARGE then
				counter_next <= (others => '0');
				state_next <= ST_IDLE;
			end if; 
		end if;
		
	 when ST_2ND_PULSE_ON =>
		counter_next <= counter_reg + 1;
	
		if (neg_edge_reg = '1') then 			
			counter_next <= (others => '0');			
			if (counter_reg > (PULSE_PWM+TJET_BEFORE_PWM-TOLERANCE_PP)) OR (counter_reg < (PULSE_PWM+TJET_BEFORE_PWM+TOLERANCE_PP)) then
				state_next <= ST_2ND_PULSE_OFF;
			else
				state_next <= ST_IDLE;	
			end if;
		else
			if counter_reg > TIMEOUT_SMALL then
				counter_next <= (others => '0');
				state_next <= ST_IDLE;
			end if; 
		end if;
		
	when ST_2ND_PULSE_OFF =>
		counter_next <= counter_reg + 1;
	
		if (pos_edge_reg = '1') then 			
			counter_next <= (others => '0');			
			if (counter_reg > (PULSE_PWM-TOLERANCE_PP)) OR (counter_reg < (PULSE_PWM+TOLERANCE_PP)) then
				state_next <= ST_IDLE;
				s_eject_0 <= '1';	
			end if;
		else
			if counter_reg > TIMEOUT_SMALL then
				counter_next <= (others => '0');
				state_next <= ST_IDLE;
			end if; 
		end if;
  
	when others => 
	 state_next <= ST_IDLE;
    end case;    

  end process;
  
end ARQ;
