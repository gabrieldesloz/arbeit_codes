		----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:24 03/09/2011 
-- Design Name: 
-- Module Name:    CH_X_EJET_TIMER - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.08 - Tests if grain was already ejected and do not generate active time
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.l_definitions.all;

entity CH_X_EJET_TIMER is
    Port ( 	LENGTH_BUFF_i : in STD_LOGIC_VECTOR (191 downto 0); --Sinais vindos do "buffer" de entrada

				HAS_GRAIN_i : in STD_LOGIC_VECTOR(63 downto 0);
				CH_NUM_i : in STD_LOGIC_VECTOR (5 downto 0);--Sinal que indica qual canal deve ser tratado no momento
				ACTIVE_i	: in STD_LOGIC; --Sinal vindo da memoria que indica se a ejetora esta ativa ou nao
				PWM_i		: in STD_LOGIC; --Sinal que indica quando o sinal de acionamento de 0.4ms acabou e o pwm inicia
				PROTEC_VALVE_i : in std_logic; --Sinal que vem da memoria e indica se ha valvulas excedentes
				COUNT_i	: in STD_LOGIC_VECTOR (9 downto 0);--Valor do contador vindo da memoria
				DEF_CNT_i : in std_logic_vector (15 downto 0);
				LENGTH_MEM_i : in std_logic_vector(2 downto 0);--Sinal vindo da memoria que indica qual foi a elipse que detectou
				
				RETRIGGER_ON_i : in std_logic;
				
				--Tempos iniciais do contador 
				A_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0); 
				A_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);
				
				B_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0); 
				B_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);
				
            C18MHZ_i 	: in  STD_LOGIC;
            C3KHZ_i 	: in  STD_LOGIC;
				RST_i		: in STD_LOGIC;
				
				PROBE_o : out STD_LOGIC_VECTOR (15 downto 0); --Sinais de ejecao dos canais
				CH_OUT_o : out STD_LOGIC_VECTOR (63 downto 0); --Sinais de ejecao dos canais
				LENGTH_MEM_o : out STD_LOGIC_VECTOR (2 downto 0);
				COUNT_o	: out STD_LOGIC_VECTOR (9 downto 0); --Valor do contador do canal que vai para a memoria
				ACTIVE_o	: out STD_LOGIC; --Indica se a ejecao deve continuar ou nao
				PWM_o		: out STD_LOGIC;	 --Indica se o PWM esta ativo
				DEF_CNT_o : out std_logic_vector (15 downto 0);
				MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
				PROTEC_VALVE_o : out STD_LOGIC 
				); --Indica se o tempo morto esta ativo
end CH_X_EJET_TIMER;

architecture Behavioral of CH_X_EJET_TIMER is


--signal s_ej_total, s_TEMPO_MORTO_CNT : STD_LOGIC_VECTOR (9 downto 0);
signal s_ej_total, s_retr_total : STD_LOGIC_VECTOR (9 downto 0);
signal s_valve_state_i, s_valve_state_o : std_logic_vector(1 downto 0);
signal s_active_valves : std_logic_vector(5 downto 0);
signal s_CH_OUT_o: std_logic_vector(CH_OUT_o'range); -- test

signal HAS_GRAIN_i_edge: std_logic_vector(63 downto 0);

signal s_CH_IS0 : integer range 0 to 255;
signal s_CH_IS1 : integer range 0 to 255;
signal s_CH_IS2 : integer range 0 to 255;
signal s_LENGTH_IS : std_logic_vector (2 downto 0);
signal s_CH_IS : std_logic;
signal s_CH_IS_INT : std_logic;
signal s_RST_MEM : std_logic;
signal s_SHOULD_RETTRIG : std_logic;

signal s_rd_ptr : std_logic_vector (5 downto 0);

signal s_PROTEC_VALVE_o : std_logic;
signal s_test_1 : std_logic;

-----------------------------------------------------------------------------
------------------------- Already ejected latches ---------------------------
-----------------------------------------------------------------------------
signal s_stop_ejection : std_logic;
signal s_already_ejected : std_logic_vector(63 downto 0);
signal s_has_already_ejected : std_logic_vector(63 downto 0);
-----------------------------------------------------------------------------

begin

p_EJ_DURACAO : process (LENGTH_MEM_i, CH_NUM_i, A_ELIPSE1_i, A_ELIPSE2_i, A_ELIPSE3_i, 
A_ELIPSE4_i, A_ELIPSE5_i, A_ELIPSE6_i, A_ELIPSE7_i, b_elipse1_i, b_elipse2_i, 
b_elipse3_i, b_elipse4_i, b_elipse5_i, b_elipse6_i, b_elipse7_i)
begin

	if (CH_NUM_i(5) = '0') then
		case LENGTH_MEM_i is 
	
			when "000" => s_ej_total <= "0000000000"; 
			when "001" => s_ej_total <= A_ELIPSE1_i; 
			when "010" => s_ej_total <= A_ELIPSE2_i; 
			when "011" => s_ej_total <= A_ELIPSE3_i; 
			when "100" => s_ej_total <= A_ELIPSE4_i; 
			when "101" => s_ej_total <= A_ELIPSE5_i; 
			when "110" => s_ej_total <= A_ELIPSE6_i; 
			when "111" => s_ej_total <= A_ELIPSE7_i;
			when others => s_ej_total <= "0000000000";
			
		end case;	
		
	else
		case LENGTH_MEM_i is 
		
			when "000" => s_ej_total <= "0000000000"; 
			when "001" => s_ej_total <= B_ELIPSE1_i; 
			when "010" => s_ej_total <= B_ELIPSE2_i; 
			when "011" => s_ej_total <= B_ELIPSE3_i; 
			when "100" => s_ej_total <= B_ELIPSE4_i; 
			when "101" => s_ej_total <= B_ELIPSE5_i; 
			when "110" => s_ej_total <= B_ELIPSE6_i; 
			when "111" => s_ej_total <= B_ELIPSE7_i;
			when others => s_ej_total <= "0000000000";
		end case;	
		
	end if;
	
end process;

MAX_ACTIVE_COUNTER_o <= (others => '0');

s_CH_IS0 <= (CONV_INTEGER(CH_NUM_i) * 3);
s_CH_IS1 <= s_CH_IS0 + 1;
s_CH_IS2 <= s_CH_IS1 + 1;
--Identifica o canal
s_CH_IS_INT <= (LENGTH_BUFF_i(s_CH_IS0) or LENGTH_BUFF_i(s_CH_IS1)); 
s_CH_IS <= (s_CH_IS_INT or LENGTH_BUFF_i(s_CH_IS2));
--Recebe os dados de cada bit do canal respectivo
s_LENGTH_IS <= (LENGTH_BUFF_i(s_CH_IS2) & LENGTH_BUFF_i(s_CH_IS1) & LENGTH_BUFF_i(s_CH_IS0)); 

s_valve_state_i <= PWM_i & ACTIVE_i;

PWM_o <= s_valve_state_o(1);
ACTIVE_o <= s_valve_state_o(0);

PROTEC_VALVE_o <= s_PROTEC_VALVE_o;



test: block is


signal is_valve1: std_logic;
signal s_has_already_ejected1: std_logic;
signal s_HAS_GRAIN_i1_edge: std_logic;
signal s_HAS_GRAIN_i1: std_logic;
signal s_CH_OUT_o1: std_logic;

begin

	is_valve1 <= '1' when (CH_NUM_i = 0) else '0';	 	
	s_has_already_ejected1 		<= s_has_already_ejected(CONV_INTEGER(0));
	s_HAS_GRAIN_i1_edge 		<= HAS_GRAIN_i_edge(CONV_INTEGER(0));	
	s_HAS_GRAIN_i1 				<= HAS_GRAIN_i(CONV_INTEGER(0));	
	s_CH_OUT_o1 				<= s_CH_OUT_o(CONV_INTEGER(0)); 
	PROBE_o 					<= "0000000" & s_test_1 & s_valve_state_i &  s_PROTEC_VALVE_o & 
								   s_CH_OUT_o1 & s_HAS_GRAIN_i1_edge & s_has_already_ejected1 & 
								   s_stop_ejection & is_valve1;

end block test; 



s_stop_ejection <= s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) and not(HAS_GRAIN_i_edge(CONV_INTEGER(CH_NUM_i))); -- Flag that indicates
																																					-- there is no grain and
																																					-- has already ejected!
																														

p_SEQ : process (RST_i, C18MHZ_i, s_valve_state_i, s_CH_IS, s_stop_ejection, HAS_GRAIN_i_edge)
begin

	if (RST_i = '1') then

		CH_OUT_o <= "0000000000000000000000000000000000000000000000000000000000000000";
		s_CH_OUT_o <= "0000000000000000000000000000000000000000000000000000000000000000";
		s_PROTEC_VALVE_o <= '0';
		s_valve_state_o <= "00";
		s_active_valves <= (others=>'0');
		COUNT_o	<= "0000000000";
		DEF_CNT_o <= "0000000000000000";
		s_test_1  <= '0';		
		
		s_has_already_ejected <= (others=>'0');
						
	elsif falling_edge(C18MHZ_i) then
	
	
		DEF_CNT_o <=  DEF_CNT_i;
		LENGTH_MEM_o <= LENGTH_MEM_i;
				
		case s_valve_state_i is		
		
		    --IDLE
			when "00" =>	-- Valve is quiet
								CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
								
								
								if (s_stop_ejection = '1') then
								
									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';	-- Clean has_already_ejected flag
									s_valve_state_o <= "00";										-- Do not eject
									
								else
								
									if (s_CH_IS = '1') then
									
										s_valve_state_o <= "01";
										
										if (s_active_valves > MAX_ACTIVE_VALVES) then
											s_PROTEC_VALVE_o <= '1';
										else
											s_PROTEC_VALVE_o <= '0';
											s_active_valves <= s_active_valves + 1;
										end if;
										
										COUNT_o	<= c_ACIONA_EJ + s_ej_total; 							-- activation plus ellipse
										LENGTH_MEM_o <= s_LENGTH_IS;
										
									else

										s_valve_state_o <= "00";
										
									end if;
								
								end if;
								
								
					when "01" =>	-- Valve is active 
								
								CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);       		 	-- ejects
								
								if s_stop_ejection = '1' then											-- If there is no grain and already ejected once
																										-- (ejected once: counter reached its maximum)
									s_valve_state_o <= "11";			--*--							-- go to 							
									COUNT_o 		<= DEFLUX_T;		--*--
									
									if PROTEC_VALVE_i = '0' then 									
										DEF_CNT_o 		<=  DEF_CNT_i + '1'; 							-- increase defect counter (ejection counter)
									end if; 
									
									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';			
									
									if (PROTEC_VALVE_i = '1') then									-- If valve is inactive
										s_active_valves <= s_active_valves;							-- Keep active valve number
									else															-- If valve is active
										s_PROTEC_VALVE_o <= '0';
										if (s_active_valves = "000000") then
											s_active_valves <= "000000";
										else
											s_active_valves <= s_active_valves - 1;					-- Decrease number of active valves
										end if;
									end if;
											
								
									
								else
								
								
								
									s_valve_state_o <= "01";										-- Keep ejecting
									
									if (COUNT_i = "0000000000") then                                -- Minimal ejection time routine																				
										s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '1';	    -- has ejected for minimum time							
									else
										
										if HAS_GRAIN_i_edge(CONV_INTEGER(CH_NUM_i)) = '1' then								-- resets counter if it still finds a defect
											s_test_1 <= '1';
											COUNT_o <=  c_ACIONA_EJ + s_ej_total; 
											
											if PROTEC_VALVE_i = '0' then 									
												DEF_CNT_o 		<=  DEF_CNT_i + '1'; 								-- increase defect counter (ejection counter)
											end if; 																-- only if it is not protected
										
										else
											COUNT_o <= COUNT_i - 1;									 			
										end if;
									
									
									end if;
								
								end if;		
								
					when "11" =>
									CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';									
									
									if (COUNT_i = "0000000000") then 
										s_valve_state_o <= "00";
									else
										s_valve_state_o <= "11";
										COUNT_o <= COUNT_i - 1;
									end if;						
								
											
										
					when others =>
								s_valve_state_o <= "00";	

					
		end case;

	end if;

end process;


	edge_detect: block 
	signal nRST_i: std_logic;
	begin
   
		gen_reg: for i in 0 to 63 generate
	
			uu3:entity work.edge_detector
			  port map (
				n_reset  => nRST_i,
				sysclk   => C18MHZ_i, --  -- falling edge
				f_in     => HAS_GRAIN_i(i),
				pos_edge => HAS_GRAIN_i_edge(i)
				);
	
		end generate gen_reg;
		nRST_i <=  not RST_i;
	end block;
	
	

		
end Behavioral;