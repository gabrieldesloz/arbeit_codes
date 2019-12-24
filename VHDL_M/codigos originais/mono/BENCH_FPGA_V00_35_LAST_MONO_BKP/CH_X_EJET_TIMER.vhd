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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CH_X_EJET_TIMER is
    Port ( 	LENGTH_BUFF_i : in STD_LOGIC_VECTOR (191 downto 0); --Sinais vindos do "buffer" de entrada
--				A_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
--				B_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
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

--constant c_ACIONA_EJ : STD_LOGIC_VECTOR (9 downto 0) := "0001110110"; --400ms
constant c_ACIONA_EJ : STD_LOGIC_VECTOR (9 downto 0) := "0010010011";	--500ms

--signal s_ej_total, s_TEMPO_MORTO_CNT : STD_LOGIC_VECTOR (9 downto 0);
signal s_ej_total, s_retr_total : STD_LOGIC_VECTOR (9 downto 0);
signal s_valve_state_i, s_valve_state_o : std_logic_vector(1 downto 0);
signal s_active_valves : std_logic_vector(5 downto 0);

signal s_CH_IS0 : integer range 0 to 255;
signal s_CH_IS1 : integer range 0 to 255;
signal s_CH_IS2 : integer range 0 to 255;
signal s_LENGTH_IS : std_logic_vector (2 downto 0);
signal s_CH_IS : std_logic;
signal s_CH_IS_INT : std_logic;
signal s_RST_MEM : std_logic;
signal s_SHOULD_RETTRIG : std_logic;

signal s_rd_ptr : std_logic_vector (5 downto 0);

signal s_inc_max_active_counter : std_logic;
signal s_max_active_counter : std_logic_vector(15 downto 0);

signal s_PROTEC_VALVE_o : std_logic;

-----------------------------------------------------------------------------
------------------------- Already ejected latches ---------------------------
-----------------------------------------------------------------------------
signal s_stop_ejection : std_logic;
signal s_already_ejected : std_logic_vector(63 downto 0);
signal s_has_already_ejected : std_logic_vector(63 downto 0);
-----------------------------------------------------------------------------

begin

p_EJ_DURACAO : process (LENGTH_MEM_i, CH_NUM_i, A_ELIPSE1_i, A_ELIPSE2_i, A_ELIPSE3_i, A_ELIPSE4_i, A_ELIPSE5_i, A_ELIPSE6_i, A_ELIPSE7_i, b_elipse1_i, b_elipse2_i, b_elipse3_i, b_elipse4_i, b_elipse5_i, b_elipse6_i, b_elipse7_i)
begin

	if (CH_NUM_i(5) = '0') then
		case LENGTH_MEM_i is -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
	
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
		
		case s_LENGTH_IS is -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
	
			when "000" => s_retr_total <= "0000000000"; 
			when "001" => s_retr_total <= A_ELIPSE1_i; 
			when "010" => s_retr_total <= A_ELIPSE2_i; 
			when "011" => s_retr_total <= A_ELIPSE3_i; 
			when "100" => s_retr_total <= A_ELIPSE4_i; 
			when "101" => s_retr_total <= A_ELIPSE5_i; 
			when "110" => s_retr_total <= A_ELIPSE6_i; 
			when "111" => s_retr_total <= A_ELIPSE7_i;
			when others => s_retr_total <= "0000000000";
			
		end case;
		
	else
		case LENGTH_MEM_i is -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
		
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
		
		case s_LENGTH_IS is -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
		
			when "000" => s_retr_total <= "0000000000"; 
			when "001" => s_retr_total <= B_ELIPSE1_i; 
			when "010" => s_retr_total <= B_ELIPSE2_i; 
			when "011" => s_retr_total <= B_ELIPSE3_i; 
			when "100" => s_retr_total <= B_ELIPSE4_i; 
			when "101" => s_retr_total <= B_ELIPSE5_i; 
			when "110" => s_retr_total <= B_ELIPSE6_i; 
			when "111" => s_retr_total <= B_ELIPSE7_i;
			when others => s_retr_total <= "0000000000";
			
		end case;
		
	end if;
	
end process;

MAX_ACTIVE_COUNTER_o <= s_max_active_counter;

s_CH_IS0 <= (CONV_INTEGER(CH_NUM_i) * 3);
s_CH_IS1 <= s_CH_IS0 + 1;
s_CH_IS2 <= s_CH_IS1 + 1;
--Identifica o canal
s_CH_IS_INT <= (LENGTH_BUFF_i(s_CH_IS0) or LENGTH_BUFF_i(s_CH_IS1)); 
s_CH_IS <= (s_CH_IS_INT or LENGTH_BUFF_i(s_CH_IS2));
--Recebe os dados de cada bit do canal respectivo
s_LENGTH_IS <= (LENGTH_BUFF_i(s_CH_IS2) & LENGTH_BUFF_i(s_CH_IS1) & LENGTH_BUFF_i(s_CH_IS0)); 

s_SHOULD_RETTRIG <= '1' when s_retr_total > s_ej_total else '0';

s_valve_state_i <= PWM_i & ACTIVE_i;

PWM_o <= s_valve_state_o(1);
ACTIVE_o <= s_valve_state_o(0);

PROTEC_VALVE_o <= s_PROTEC_VALVE_o;

PROBE_o <= s_active_valves & PROTEC_VALVE_i & s_PROTEC_VALVE_o & s_valve_state_i & s_valve_state_o & s_CH_IS & 
				s_has_already_ejected(0) & s_already_ejected(0) & C18MHZ_i;

s_stop_ejection <= s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) and not(HAS_GRAIN_i(CONV_INTEGER(CH_NUM_i))); -- Flag that indicates
																																					-- there is no grain and
																																					-- has already ejected!
																														

p_SEQ : process (RST_i, C18MHZ_i, s_valve_state_i, s_CH_IS, s_stop_ejection)
begin

	if (RST_i = '1') then

		CH_OUT_o <= "0000000000000000000000000000000000000000000000000000000000000000";
		s_PROTEC_VALVE_o <= '0';
		s_valve_state_o <= "00";
		s_active_valves <= (others=>'0');
		COUNT_o	<= "0000000000";
		DEF_CNT_o <= "0000000000000000";
		s_inc_max_active_counter <= '0';
		s_max_active_counter <= (others=>'0');
		
		s_has_already_ejected <= (others=>'0');
						
	elsif falling_edge(C18MHZ_i) then
	
		if (s_active_valves > "001000") then
			if (s_inc_max_active_counter = '1') then
				s_inc_max_active_counter <= '1';
			else
				s_max_active_counter <= s_max_active_counter + '1';
				s_inc_max_active_counter <= '1';
			end if;
		else
			s_inc_max_active_counter <= '0';
		end if;
	
		DEF_CNT_o <=  DEF_CNT_i;
		LENGTH_MEM_o <= LENGTH_MEM_i;
				
		case s_valve_state_i is
		
			when "00" =>	-- Valve is quiet
								CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
								
								if (s_stop_ejection = '1') then
								
									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';	-- Clean has_already_ejected flag
									s_valve_state_o <= "00";										-- Do not eject
									
								else
								
									if (s_CH_IS = '1') then
									
										s_valve_state_o <= "01";
										
										if (s_active_valves > "001000") then
											s_PROTEC_VALVE_o <= '1';
										else
											s_PROTEC_VALVE_o <= '0';
											s_active_valves <= s_active_valves + 1;
										end if;
										
										COUNT_o	<= c_ACIONA_EJ;
										LENGTH_MEM_o <= s_LENGTH_IS;
										
									else

										s_valve_state_o <= "00";
										
									end if;
								
								end if;
									
								
--								if (HAS_GRAIN_i(CONV_INTEGER(CH_NUM_i)) = '0') then
--								
--									s_ejected_twice(CONV_INTEGER(CH_NUM_i)) <= '0';
--									
--								end if;
								
--								if (s_stop_ejection = '1') then
--								
--									s_ejected_twice(CONV_INTEGER(CH_NUM_i)) <= '0';
--									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';	-- Clean has_already_ejected flag
--									s_valve_state_o <= "00";										-- Do not eject
--										
--									if (s_CH_IS = '1') then
--
--										s_active_valves <= s_active_valves;
--									
--									end if;
--									
--								end if;
								
			when "01" =>	-- Valve is active (500 ms)
			
								if s_stop_ejection = '1' then											-- If there is no grain and already ejected once
								
									s_valve_state_o <= "00";											-- Stop ejecting
									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';		
									
									if (PROTEC_VALVE_i = '1') then									-- If valve is inactive
										s_active_valves <= s_active_valves;							-- Keep active valve number
									else																		-- If valve is active
										s_PROTEC_VALVE_o <= '0';
										if (s_active_valves = "000000") then
											s_active_valves <= "000000";
										else
											s_active_valves <= s_active_valves - 1;					-- Decrease number of active valves
										end if;
									end if;
									
								else																			-- If this is the first ejection
									
									s_valve_state_o <= "01";											-- Keep ejecting
								
									if (PROTEC_VALVE_i = '1') then
									
										if (s_active_valves > "001000") then
											s_PROTEC_VALVE_o <= '1';
										else
											s_PROTEC_VALVE_o <= '0';
											s_active_valves <= s_active_valves + 1;
										end if;
										
									else
									
										s_PROTEC_VALVE_o <= '0';
										
										if (s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) = '1') then 	-- If this grain has already been ejected
										
											if (C3KHZ_i = '1') then													-- Do not generate active time, only PWM
												CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);
											else
												CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
											end if;
										
										else																				-- If this grain has no being ejected yet
										
											CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);		-- Eject normally
											
										end if;
										
									end if;								
									
									if (COUNT_i = "0000000000") then
										
										s_valve_state_o <= "10";
										COUNT_o <= s_ej_total;
										CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
										
									else
									
										COUNT_o <= COUNT_i - 1;
									
									end if;
								end if;
									
			when "10" => -- Valve is on PWM state (7.4KHz)

								if s_stop_ejection = '1' then											-- If there is no grain and already ejected once
								
									s_valve_state_o <= "00";											-- Stop ejecting
									s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';
									
									if (PROTEC_VALVE_i = '1') then									-- If valve is inactive
										s_active_valves <= s_active_valves;							-- Keep active valve number
									else																		-- If valve is active
										s_PROTEC_VALVE_o <= '0';
										if (s_active_valves = "000000") then
											s_active_valves <= "000000";
										else
											s_active_valves <= s_active_valves - 1;					-- Decrease number of active valves
										end if;
									end if;
									
								else																			-- If this is the first ejection
									s_valve_state_o <= "10";											-- Keep ejecting
								
									if (COUNT_i = "0000000000") then
										
										s_valve_state_o <= "00";
										
										s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '1';
										
										DEF_CNT_o <=  DEF_CNT_i + '1';
										
										if (PROTEC_VALVE_i = '1') then
											s_active_valves <= s_active_valves;
											CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
										else
											if (s_active_valves = "000000") then
												s_active_valves <= "000000";
											else
												s_active_valves <= s_active_valves - 1;					-- Decrease number of active valves
											end if;
											CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '1';
										end if;
										
									else
									
										COUNT_o <= COUNT_i - 1;
										
										if (PROTEC_VALVE_i = '1') then
										
											if (s_active_valves > "001000") then
												s_PROTEC_VALVE_o <= '1';
											else
												s_PROTEC_VALVE_o <= '0';
												s_active_valves <= s_active_valves + 1;
											end if;
											
										else
										
											s_PROTEC_VALVE_o <= '0';
											
											if (C3KHZ_i = '1') then
												CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);
											else
												CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
											end if;
											
										end if;	
									
									end if;
								end if;
									
			when "11" =>
								s_valve_state_o <= "00";
								
			when others =>
								
		
		end case;

	end if;

end process;

-----------------------------------------------------------------------------
------------------------- Already ejected latches ---------------------------
-----------------------------------------------------------------------------
--already_ejected: for i in 0 to 63 generate 								-- Generate 63 s_already_ejected latches
--begin
--	process(RST_i, HAS_GRAIN_i, s_already_ejected_int)				
--	begin
--		if ((RST_i = '1') or (HAS_GRAIN_i(i) = '0')) then				-- If reset or has no grain = 1
--			s_already_ejected(i) <= '0';										-- Product has ended, clear has ejected
--		else
--			if rising_edge(s_already_ejected_int(i)) then				-- If there was already a complete ejection
--				s_already_ejected(i) <= '1';									-- Set has_ejected flag to 1
--			end if;
--		end if;
--	end process;
--	
--end generate;

--	process(RST_i, HAS_GRAIN_i(0), s_already_ejected_int(0))				
--	begin
--		if ((RST_i = '1') or (HAS_GRAIN_i(0) = '0')) then				-- If reset or has no grain = 1
--			s_already_ejected(0) <= '0';										-- Product has ended, clear has ejected
--		else
--			if rising_edge(s_already_ejected_int(0)) then				-- If there was already a complete ejection
--				s_already_ejected(0) <= '1';									-- Set has_ejected flag to 1
--			end if;
--		end if;
--	end process;
-----------------------------------------------------------------------------

end Behavioral;