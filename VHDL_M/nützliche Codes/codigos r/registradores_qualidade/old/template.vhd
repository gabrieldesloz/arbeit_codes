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




  -- lazy process - exemplo 

  data_sender : block is
      begin	

    SEND_DATA : process(clock, reset)
      variable state_counter  : natural range 0 to 10	:= 0;
    begin
      
      if reset = '1' then
		state_counter  := 0;
		
	
      elsif rising_edge(clock) then	
		state_counter  := state_counter;
	

			case state_counter is
			  when 0 =>				
				state_counter  := state_counter + 1;

			  when 1 =>			
				state_counter := state_counter + 1;

			  when 2 =>	
				 state_counter := state_counter + 1;
				

			  when 3 =>			-- END
				
				state_counter := 0;

			  when others => null;
					 
			end case;
      end if;
    end process SEND_DATA;

  end block data_sender;

  	latch_counter1: process(s_uart_clk, reset)
      variable state_counter  : natural range 0 to 3;
	  variable time_counter  : natural range 0 to 60_000;
    begin      
      if reset = '1' then
		state_counter  := 0;
		time_counter   := 0;
		 max_current    <= '0';
      elsif rising_edge(s_uart_clk) then	
		state_counter  := state_counter;
		time_counter   := time_counter;
			case state_counter is
			  when 0 =>				  
				if s_max_current = '1' then			  
					state_counter  := state_counter + 1;
				end if;	
				
			  when 1 =>		
				  time_counter := time_counter + 1;
				  max_current <= '1';
				if time_counter = 30_000 then
					max_current <= '0';
					state_counter  := 0;
					time_counter := 0;
				end if;
				
			  when others => null;					 
			end case;
      end if;
    end process latch_counter1;	
	
	
		process(c10MHz, reset)
			
			variable state: std_logic;
			variable counter: std_logic_vector(31 downto 0);			
			variable value: std_logic_vector(31 downto 0);
			
		begin
			
			if reset = '1' then 
			
				state := '0';
				counter := (others => '0');
				value := (others => '0');
			
			elsif rising_edge(c10MHz) then 
					
				state := state;
				counter := counter;
				value := value;
				
				case state is		
				
					when '0' =>					
					
					  value := (others => '0');
								
					  for i in 31 downto 0 loop
						 sens_tmp(i) <= sens(i) xor value(i);
					  end loop;	   
					
								
						
						if counter = 100_000_000 then -- 1 s 
							state := '1';
							counter := (others => '0');
						else 
							counter	:= counter + '1';
							state 	:= '0';
						end if;		
						
						
					when '1' => 
							
					  value := (others => '1');
								
					  for i in 31 downto 0 loop
						 sens_tmp(i) <= sens(i) xor value(i);
					  end loop;	   
												
						
						if counter = 100_000_000 then -- 1 s 
							state := '0';
							counter := (others => '0');
						else 
							counter	:= counter + '1';
							state 	:= '1';
						end if;		
					
					when others => null;	
				end case;
			end if;
		end process;

end quality_rtl;


-- configurations







