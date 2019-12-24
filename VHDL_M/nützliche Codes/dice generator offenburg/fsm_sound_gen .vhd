
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity fsm_sound_gen is
	 port(
		 finish: out std_logic; -- send a signal telling that is ok to turn-off system
		 enable: in std_logic;
		 tick_enable: in std_logic;
		 melody_select: in std_logic;
		 melody_enable: in std_logic;
		 tone_4000: in std_logic;
		 tone_5333:	in std_logic;
		 tone_6400: in std_logic;
		 pulse_8: 	in std_logic;
		 pulse_1000: in std_logic;
		 clk: in std_logic;
		 start_tick: in std_logic;		 
		 start_melody: in std_logic;
		 one: in std_logic;
		 six: in std_logic;
		 reset_n: in std_logic;		 
	     speaker: out std_logic
		 );
end fsm_sound_gen;

--}} End of automatically maintained section

architecture fsm_sound_gen of fsm_sound_gen is

type state_type is (sleep_mode,end_all,tick_1,tick_2,tick_3,
		m1_1,m1_2,m1_3,m2_1,m2_2,m2_3,m2_4,m2_5,m2_6,m2_7,m3_1,m3_2);
signal mode_reg, mode_next: state_type;	 
signal  speaker_reg, speaker_next: std_logic;
	
	begin
		
		
		--===================================
		-- registradores de estado e de dados
		-- variáveis
		--==================================
		
		registradores: process(clk,reset_n,enable)
		    begin		    
			if reset_n = '0' then 				
				mode_reg <=  sleep_mode;
				speaker_reg <= '0';
			elsif rising_edge(clk) then				
				if enable = '1' then
					mode_reg <= mode_next;
					speaker_reg <= speaker_next;
				end if;				
			end if;				
		end process	registradores;

   
   --======================--
	-- logica de proximo estado	
	-- controlpath/fsm
	-- next state decoder
	--======================--
	logica_prox_estado: process(mode_reg,start_tick,start_melody, 
		one, six,pulse_1000, pulse_8,melody_select) -- all -> vhdl 2008 -- lista de todos os 
	-- sinais que estão dentro do processo e que são modificados externamente
		   begin
		   -- valores default (impedem a inferencia de latches)
		   mode_next 	<= mode_reg; 	-- padrão voltar para o mesmo estado 		   	  
		   		
		   --mux 
		   case mode_reg is			   		
				when sleep_mode => 					
					 if start_tick = '1' then				
					 	mode_next 	<= tick_1;
						elsif start_melody = '1' then						 	
							if melody_select = '1' then	
								if one = '1' then  
									mode_next <= m1_1;
									elsif six = '1' then
										mode_next <= m2_1;
								else 
									mode_next <= m3_1;
								end if;	
							else   
								mode_next <= m3_1;
							end if;							
					end if;	
					
				when tick_1 => 	 					
					if pulse_1000 = '1' then 
						mode_next <= tick_2;
					end if;
				when tick_2 =>
					if pulse_1000 = '1' then 
						mode_next <= tick_3;
					end if;
				when tick_3 =>
					if pulse_1000 = '1' then 
						mode_next <= sleep_mode;
					end if;				
				when m1_1 => 
					if pulse_8 = '1' then 
					mode_next <= m1_2;
					end if;
				when m1_2 =>
					if pulse_8 = '1' then 
					mode_next <= m1_3;
					end if;	
				when m1_3 => 
					if pulse_8 = '1' then 
					mode_next <= end_all; 
					end if;	
				when m2_1 => 
					if pulse_8 = '1' then
					mode_next <= m2_2; 
					end if;	
				when m2_2 => 
					if pulse_8 = '1' then
					mode_next <= m2_3;
					end if;	
				when m2_3 =>
					if pulse_8 = '1' then
					mode_next <= m2_4; 
					end if;
				when m2_4 =>
					if pulse_8 = '1' then
					mode_next <= m2_5; 
					end if;
				when m2_5 =>
					if pulse_8 = '1' then
					mode_next <= m2_6;
					end if;
				when m2_6 =>
					if pulse_8 = '1' then
					mode_next <= m2_7;
					end if;
				when m2_7 =>
					if pulse_8 = '1' then
					mode_next <= end_all;
					end if;
				when m3_1 =>
					if pulse_8 = '1' then
					mode_next <= m3_2; 
					end if;
				when m3_2 => 
					if pulse_8 = '1' then
					mode_next <= end_all;
					end if;
				when end_all =>
					 if start_melody = '0' then 
						mode_next <= sleep_mode;
					end if;	
		   	   	end case; 	  
	end process logica_prox_estado;				  
	
	
	-- output decoder
	speaker_out: process(clk, mode_reg,tick_enable,melody_enable, speaker_reg)	
	begin 
	 		if rising_edge(clk) then			
			finish  <= '0';
			speaker_next <= speaker_reg;
			case mode_reg is 			
				when sleep_mode =>
					speaker_next <= '0';						
				when tick_1 =>
					if tick_enable = '1' then
					speaker_next <= tone_4000;
					else
					speaker_next <= '0';
					end if;
				when tick_2 =>
					if tick_enable = '1' then
					speaker_next <= tone_4000;  
					else
					speaker_next <= '0';
					end if;
				when tick_3 =>
					if tick_enable = '1' then
					speaker_next <= tone_4000; 
					else
					speaker_next <= '0';
					end if;
				when m1_1 => 
					if melody_enable = '1' then 
					speaker_next <= tone_6400;
					else 
					speaker_next <= '0';	   
					end if;
				when m1_2 =>
					if melody_enable = '1' then 
					speaker_next <= tone_5333;
					else 
					speaker_next <= '0';	   
					end if;
				when m1_3 => 
					if melody_enable = '1' then 
					speaker_next <= tone_4000;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_1 => 
					if melody_enable = '1' then 
					speaker_next <= tone_4000;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_2 => 
					if melody_enable = '1' then 
					speaker_next <= tone_5333;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_3 =>
					if melody_enable = '1' then 
					speaker_next <= tone_6400;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_4 =>
					if melody_enable = '1' then 
					speaker_next <= tone_4000;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_5 =>
					if melody_enable = '1' then 
					speaker_next <= tone_5333;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_6 =>
					if melody_enable = '1' then 
					speaker_next <= tone_6400;
					else 
					speaker_next <= '0';	   
					end if;
				when m2_7 =>
					if melody_enable = '1' then 
					speaker_next <= tone_4000;
					else 
					speaker_next <= '0';	   
					end if;
				when m3_1 =>
					 if melody_enable = '1' then 
					speaker_next <= tone_4000;
					else 
					speaker_next <= '0';	   
					end if;
				when m3_2 => 
					 if melody_enable = '1' then 
					speaker_next <= tone_5333;
					else 
					speaker_next <= '0';	   
					end if;
				when end_all =>
					 finish  <= '1';
					 speaker_next <= '0';
		end case;
		end if;
						
						
		speaker <= speaker_reg; -- definition				
						
	end process	speaker_out;
		
	
	
end fsm_sound_gen;
			  
			  
			  
--library IEEE;
--use IEEE.STD_LOGIC_1164.all;
--
--entity fsm_sound_gen is
--	 port(
--		 finish: out std_logic; -- send a signal telling that is ok to turn-off system
--		 enable: in std_logic;
--		 tick_enable: in std_logic;
--		 melody_select: in std_logic;
--		 melody_enable: in std_logic;
--		 tone_4000: in std_logic;
--		 tone_5333:	in std_logic;
--		 tone_6400: in std_logic;
--		 pulse_8: 	in std_logic;
--		 pulse_1000: in std_logic;
--		 clk: in std_logic;
--		 start_tick: in std_logic;		 
--		 start_melody: in std_logic;
--		 one: in std_logic;
--		 six: in std_logic;
--		 reset_n: in std_logic;		 
--	     speaker: out std_logic
--		 );
--end fsm_sound_gen;
--
----}} End of automatically maintained section
--
--architecture fsm_sound_gen of fsm_sound_gen is
--
--type state_type is (sleep_mode,end_all,tick_1,tick_2,tick_3,
--		m1_1,m1_2,m1_3,m2_1,m2_2,m2_3,m2_4,m2_5,m2_6,m2_7,m3_1,m3_2);
--signal mode_reg, mode_next: state_type;	 
--signal  speaker_reg, speaker_next: std_logic;
--signal ctrl_sig: std_logic_vector(4 downto 0);
--
--	begin
--		
--		
--		--===================================
--		-- registradores de estado e de dados
--		-- variáveis
--		--==================================
--		
--		registradores: process(clk,reset_n,enable)
--		    begin		    
--			if reset_n = '0' then 				
--				mode_reg <=  sleep_mode;
--				speaker_reg <= '0';
--			elsif rising_edge(clk) then				
--				if enable = '1' then
--					mode_reg <= mode_next;
--					speaker_reg <= speaker_next;
--				end if;				
--			end if;				
--		end process	registradores;
--
--  
--   -- priority encoder for the signal start_tick
--   ctrl_sig <= "10000" when start_tick = '1' 
--   			else  '0' & start_melody & melody_select & one & six; 
--   
--   
--    --======================--
--	-- logica de proximo estado	
--	-- controlpath/fsm
--	-- next state decoder
--	--======================--
--	logica_prox_estado: process(mode_reg,ctrl_sig,pulse_1000,pulse_8) -- all -> vhdl 2008 -- lista de todos os 
--	-- sinais que estão dentro do processo e que são modificados externamente
--		   begin
--		   -- valores default (impedem a inferencia de latches)
--		   mode_next 	<= mode_reg; 	-- padrão voltar para o mesmo estado 		   	  
--		   		
--		   --mux 
--		   case mode_reg is			   		
--				when sleep_mode => 					 
--					 
--					 case ctrl_sig is
--					 	when  "10000" =>  mode_next 	<= tick_1;
--					 	when  "01110" =>  mode_next     <= m1_1;	
--						when  "01101" =>  mode_next 	<= m2_1;	
--						when  "01100" =>  mode_next 	<= m3_1;
--						when  "01000" =>  mode_next 	<= m3_1;
--						when  others  =>  mode_next		<= sleep_mode;
--					end case;  						
--					
--					
--				when tick_1 => 	 					
--					if pulse_1000 = '1' then 
--						mode_next <= tick_2;
--					end if;
--				when tick_2 =>
--					if pulse_1000 = '1' then 
--						mode_next <= tick_3;
--					end if;
--				when tick_3 =>
--					if pulse_1000 = '1' then 
--						mode_next <= sleep_mode;
--					end if;				
--				when m1_1 => 
--					if pulse_8 = '1' then 
--					mode_next <= m1_2;
--					end if;
--				when m1_2 =>
--					if pulse_8 = '1' then 
--					mode_next <= m1_3;
--					end if;	
--				when m1_3 => 
--					if pulse_8 = '1' then 
--					mode_next <= end_all; 
--					end if;	
--				when m2_1 => 
--					if pulse_8 = '1' then
--					mode_next <= m2_2; 
--					end if;	
--				when m2_2 => 
--					if pulse_8 = '1' then
--					mode_next <= m2_3;
--					end if;	
--				when m2_3 =>
--					if pulse_8 = '1' then
--					mode_next <= m2_4; 
--					end if;
--				when m2_4 =>
--					if pulse_8 = '1' then
--					mode_next <= m2_5; 
--					end if;
--				when m2_5 =>
--					if pulse_8 = '1' then
--					mode_next <= m2_6;
--					end if;
--				when m2_6 =>
--					if pulse_8 = '1' then
--					mode_next <= m2_7;
--					end if;
--				when m2_7 =>
--					if pulse_8 = '1' then
--					mode_next <= end_all;
--					end if;
--				when m3_1 =>
--					if pulse_8 = '1' then
--					mode_next <= m3_2; 
--					end if;
--				when m3_2 => 
--					if pulse_8 = '1' then
--					mode_next <= end_all;
--					end if;
--				when end_all =>
--					 if start_melody = '0' then 
--						mode_next <= sleep_mode;
--					end if;	
--		   	   	end case; 	  
--	end process logica_prox_estado;				  
--	
--	
--	-- output decoder
--	speaker_out: process(clk, mode_reg,tick_enable,melody_enable, speaker_reg)	
--	begin 
--	 		if rising_edge(clk) then			
--			finish  <= '0';
--			speaker_next <= speaker_reg;
--			case mode_reg is 			
--				when sleep_mode =>
--					speaker_next <= '0';						
--				when tick_1 =>
--					if tick_enable = '1' then
--					speaker_next <= tone_4000;
--					else
--					speaker_next <= '0';
--					end if;
--				when tick_2 =>
--					if tick_enable = '1' then
--					speaker_next <= tone_4000;  
--					else
--					speaker_next <= '0';
--					end if;
--				when tick_3 =>
--					if tick_enable = '1' then
--					speaker_next <= tone_4000; 
--					else
--					speaker_next <= '0';
--					end if;
--				when m1_1 => 
--					if melody_enable = '1' then 
--					speaker_next <= tone_6400;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m1_2 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_5333;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m1_3 => 
--					if melody_enable = '1' then 
--					speaker_next <= tone_4000;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_1 => 
--					if melody_enable = '1' then 
--					speaker_next <= tone_4000;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_2 => 
--					if melody_enable = '1' then 
--					speaker_next <= tone_5333;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_3 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_6400;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_4 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_4000;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_5 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_5333;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_6 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_6400;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m2_7 =>
--					if melody_enable = '1' then 
--					speaker_next <= tone_4000;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m3_1 =>
--					 if melody_enable = '1' then 
--					speaker_next <= tone_4000;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when m3_2 => 
--					 if melody_enable = '1' then 
--					speaker_next <= tone_5333;
--					else 
--					speaker_next <= '0';	   
--					end if;
--				when end_all =>
--					 finish  <= '1';
--					 speaker_next <= '0';
--		end case;
--		end if;
--						
--						
--		speaker <= speaker_reg; -- definition				
--						
--	end process	speaker_out;
--		
--	
--	
--end fsm_sound_gen;