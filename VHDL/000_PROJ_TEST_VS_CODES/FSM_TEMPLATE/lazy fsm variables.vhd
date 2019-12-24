-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-09-09
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------


-- buffer de entrada e saida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quality is
  
  port (
    sysclk            : in  std_logic;
    reset_n           : in  std_logic
    
end quality;

architecture quality_rtl of quality is

  -- type
  -- attribute
  -- constants
  -- signals
  -- procedures
  -- functions
  -- alias
    
  

  
begin  -- quality_rtl

  -- direct compoents instantiations
  -- registers
  -- sequential/parallel assignments
  -- output assignments

  process (sysclk, reset_n)
  begin  
    if reset_n = '0' then


    elsif rising_edge(sysclk) then      -- rising clock edge

    end if;

  end process;

  process ()
  begin  -- process

    -- default
    
    case x is
      when a =>
        
      when others =>
        quality_state_next <= WAIT_READY;
        
    end case;

  end process;

  
constant CHIPSCOPE_PWM_BITS: natural := 12; 
constant MAIN_COUNTER_BITS: natural := 22;
CONSTANT PWM_MAX: NATURAL := 2**CHIPSCOPE_PWM_BITS;
CONSTANT COUNT_MAX: NATURAL := 2**MAIN_COUNTER_BITS;
 
s_pwm_on_chipscope <= to_integer(unsigned())
s_pwm_off_chipscope <= to_integer(unsigned())



   MAIN_FSM : process(clock, reset)
      variable state_counter  	: natural range 0 to 10	:= 0;
	  variable s_valve_o		: std_logic;
	  variable s_valve_counter	: integer range 0 to COUNT_MAX-1;
	  variable PWM_counter		: integer range 0 to PWM_MAX-1;
	  variable s_pwm_on			: integer range 0 to PWM_MAX-1;
	  variable s_pwm_off		: integer range 0 to PWM_MAX-1;
   
   begin
   
		VALVE_o <= s_valve_o;
      
      if reset = '1' then
			state_counter  		:= 0;
			s_valve_o 			:= '0';
			s_valve_counter		:= 0;    
			PWM_counter         := 0;
			s_pwm_on  			:= 0;
			s_pwm_off  			:= 0;
			s_pwm_on_reg	    := 0;	
			s_pwm_off_reg       := 0;
	
      elsif rising_edge(clock) then	
			state_counter  		:= state_counter;
			s_valve_o 			:= s_valve_o; 
			s_valve_counter		:= s_valve_counter; 
			s_pwm_on  			:= s_pwm_on;
			s_pwm_off  			:= s_pwm_off;
			s_pwm_on_reg		:= s_pwm_on_chipscope;
			s_pwm_off_reg  	    := s_pwm_off_chipscope
			PWM_counter			:= PWM_counter;

			case state_counter is
			  
			  when 0 => --IDLE
				
				
				s_valve_o           := '0';                                  
				s_valve_counter     :=  0;
				s_pwm_on            := s_pwm_on_reg;
				s_pwm_off           := s_pwm_off_reg;				
				PWM_counter			:=  0;	
				state_counter       := state_counter + 1;
            
			
			  when 1 =>	  -- ACTIVE

				if s_valve_counter = ACTIVE_TIME-1 then 		
					s_valve_o    	:= '0';			
					PWM_counter     := 0; 
					s_valve_counter := 0; 		
					state_counter 	:=  2;			
				else 
					s_valve_o    		:=  '1';
					s_valve_counter   	:= s_valve_counter + 1;			
					state_counter 		:=  1; 
				end if;	
					
		

			  when 2 =>	 -- PWM OFF
			  
			  
				if  s_valve_counter = MAX_COUNT_TOTAL-1 then 	
					flag_finish     := '1';
					s_valve_counter := 0;
				else					
					s_valve_counter := s_valve_counter +1;
				end if;
				
				
				if PWM_counter = s_pwm_off-1 then 							
						
					if flag_finish     = 0 then  
						s_valve_o    	:= '1';	 -- ATIVA VALVULA PROX CLOCK	
						PWM_counter   	:=  0; 	 -- ZERA CONTADOR		
						state_counter 	:=  3; 	 -- PWM ON
					else
						flag_finish    := '0';  -- DESATIVA FLAG
						s_valve_o      := 0;
						PWM_counter    := 0;
						state_counter  := 4;  -- WAIT  
						s_valve_counter	:= 0;
					end if;	
						
						
				else 
					s_valve_o    	:= '0';
					PWM_counter     := PWM_counter + 1;			
					state_counter	:= 2; --PWM OFF
				end if;			
				
				

			  when 3 =>			-- PWM ON
			  
				if  s_valve_counter = MAX_COUNT_TOTAL-1 then 	
					flag_finish     := '1';
					s_valve_counter := 0;
				else					
					s_valve_counter := s_valve_counter +1;
				end if;
				
				
				if PWM_counter = s_pwm_on-1 then 							
						
					if flag_finish     = 0 then  
						s_valve_o    	:= '0';	 	-- DESATIVA VALVULA PROX CLOCK	
						PWM_counter   	:=  0; 	 	-- ZERA CONTADOR		
						state_counter 	:=  2; 	 	-- PWM OFF
					else
						flag_finish    := '0';  	-- DESATIVA FLAG
						s_valve_o      := 0;
						PWM_counter    := 0;
						state_counter  := 4;  		-- WAIT
						s_valve_counter	:= 0;					
					end if;	
						
						
				else 
					s_valve_o    	:= '1'; -- MANTEM VALV ATIVADO
					PWM_counter     := PWM_counter + 1;			
					state_counter	:= 3; --PWM ON
				end if;			
			  
			 when 4 =>			-- WAIT 

				if s_valve_counter = WAIT_TIME-1 then 		
					s_valve_o    		:= '0';
					s_valve_counter   	:= 0;
					state_counter		:= 0; -- PRO INICIO
				else 
					s_valve_o    		:= '0';
					s_valve_counter   	:= s_valve_counter + 1;			
					state_counter		:= 4; -- WAIT
				end if;	
	
				

			  when others => state_counter		:= 4; -- WAIT;
					 
			end case;
      end if;
    end process SEND_DATA;

  end block data_sender;

  

end quality_rtl;


-- configurations







