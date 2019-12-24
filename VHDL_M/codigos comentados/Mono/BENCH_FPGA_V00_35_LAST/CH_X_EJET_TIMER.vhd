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
-- gera sinal de pwm, de ativação, incremente decrementa numero de valvulas ativas
-- repassa informações para memoria
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity CH_X_EJET_TIMER is
  port (
  
     -- Sinal que indica qual canal deve ser tratado no momento
	 -- -> _has_already_ejected -> s_stop_ejection
    CH_NUM_i       : in std_logic_vector (5 downto 0);  
    -- ??? o que tem no buffer de entrada
	-- canal (CH_NUM_i) é identificado pra ver se houve mudança ( s_CH_IS = '1' )
	-- salvo em  -> s_LENGTH_IS
    LENGTH_BUFF_i  : in std_logic_vector (191 downto 0);  -- Sinais vindos do "buffer" de entrada    
	-- tem grão -> s_stop_ejection (usado para parar a ejeção)
	HAS_GRAIN_i    : in std_logic_vector(63 downto 0); 
	-- Sinal vindo da memoria que indica se a ejetora esta ativa ou nao
	--> muda estado da maquina  s_valve_state_i <= PWM_i & ACTIVE_i;	
    ACTIVE_i       : in std_logic;  
	-- Sinal que indica quando o sinal de acionamento de 0.4ms acabou e o pwm inicia
    --> muda estado da maquina  s_valve_state_i <= PWM_i & ACTIVE_i;
	PWM_i          : in std_logic;  
	-- Sinal que vem da memoria e indica se ha valvulas excedentes ??? não acionar a proxima
    PROTEC_VALVE_i : in std_logic;  
    -- Valor do contador de defeitos vindo da memoria 
	-- alterado na maquina de estado e jogado pra fora como COUNT_o
	-- timer do pulso de ejeção (cronometro)
	COUNT_i        : in std_logic_vector (9 downto 0);  
	-- contagem de ejeções
    DEF_CNT_i      : in std_logic_vector (15 downto 0); 
	-- Sinal vindo da memoria que indica qual foi a elipse que detectou falhas 
    LENGTH_MEM_i   : in std_logic_vector(2 downto 0);   

	-- sinal nao utilizado
    RETRIGGER_ON_i : in std_logic;

    --Tempos iniciais do contador ???
    A_ELIPSE1_i : in std_logic_vector (9 downto 0);
    A_ELIPSE2_i : in std_logic_vector (9 downto 0);
    A_ELIPSE3_i : in std_logic_vector (9 downto 0);
    A_ELIPSE4_i : in std_logic_vector (9 downto 0);
    A_ELIPSE5_i : in std_logic_vector (9 downto 0);
    A_ELIPSE6_i : in std_logic_vector (9 downto 0);
    A_ELIPSE7_i : in std_logic_vector (9 downto 0);

    B_ELIPSE1_i : in std_logic_vector (9 downto 0);
    B_ELIPSE2_i : in std_logic_vector (9 downto 0);
    B_ELIPSE3_i : in std_logic_vector (9 downto 0);
    B_ELIPSE4_i : in std_logic_vector (9 downto 0);
    B_ELIPSE5_i : in std_logic_vector (9 downto 0);
    B_ELIPSE6_i : in std_logic_vector (9 downto 0);
    B_ELIPSE7_i : in std_logic_vector (9 downto 0);

    C18MHZ_i : in std_logic;
    C3KHZ_i  : in std_logic;
    RST_i    : in std_logic;

    PROBE_o              : out std_logic_vector (15 downto 0);  -- Sinais de ejecao dos canais
    CH_OUT_o             : out std_logic_vector (63 downto 0);  -- Sinais de ejecao dos canais
    LENGTH_MEM_o         : out std_logic_vector (2 downto 0);
    COUNT_o              : out std_logic_vector (9 downto 0);  -- Valor do contador do canal que vai para a memoria
    ACTIVE_o             : out std_logic;  -- Indica se a ejecao deve continuar ou nao
    PWM_o                : out std_logic;  -- Indica se o PWM esta ativo
    DEF_CNT_o            : out std_logic_vector (15 downto 0);
    MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
    PROTEC_VALVE_o       : out std_logic
    );                                  --Indica se o tempo morto esta ativo
end CH_X_EJET_TIMER;

architecture Behavioral of CH_X_EJET_TIMER is
   
   -- tempo fixo para a ativação - 500ms
  constant c_ACIONA_EJ                      : std_logic_vector (9 downto 0) := "0010010011";  --500ms
  signal   s_ej_total, s_retr_total         : std_logic_vector (9 downto 0);
  signal   s_valve_state_i, s_valve_state_o : std_logic_vector(1 downto 0);
  signal   s_active_valves                  : std_logic_vector(5 downto 0);

  signal s_CH_IS0         : integer range 0 to 255;
  signal s_CH_IS1         : integer range 0 to 255;
  signal s_CH_IS2         : integer range 0 to 255;
  signal s_LENGTH_IS      : std_logic_vector (2 downto 0);
  signal s_CH_IS          : std_logic;
  signal s_CH_IS_INT      : std_logic;
  signal s_RST_MEM        : std_logic;
  signal s_SHOULD_RETTRIG : std_logic;

  signal s_rd_ptr : std_logic_vector (5 downto 0);

  signal s_inc_max_active_counter : std_logic;
  signal s_max_active_counter     : std_logic_vector(15 downto 0);

  signal s_PROTEC_VALVE_o : std_logic;

-----------------------------------------------------------------------------
------------------------- Already ejected latches ---------------------------
-----------------------------------------------------------------------------
  signal s_stop_ejection       : std_logic;
  signal s_already_ejected     : std_logic_vector(63 downto 0);
  signal s_has_already_ejected : std_logic_vector(63 downto 0); 
-----------------------------------------------------------------------------

begin

-- 
  p_EJ_DURACAO : process (LENGTH_MEM_i, CH_NUM_i, A_ELIPSE1_i, A_ELIPSE2_i, A_ELIPSE3_i, A_ELIPSE4_i, A_ELIPSE5_i, A_ELIPSE6_i, A_ELIPSE7_i, b_elipse1_i, b_elipse2_i, b_elipse3_i, b_elipse4_i, b_elipse5_i, b_elipse6_i, b_elipse7_i)
  begin
  -- (CH_NUM_i(5) = '0') seleciona qual lado será testado ???
    if (CH_NUM_i(5) = '0') then
      
	  --??? diferença entre LENGTH_MEM_i e s_LENGTH_IS
	  --??? diferença entre s_ej_total e s_retr_total 
	  --??? s_retr_total
	  case LENGTH_MEM_i is  -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
        
        when "000"  => s_ej_total <= "0000000000";
        when "001"  => s_ej_total <= A_ELIPSE1_i;
        when "010"  => s_ej_total <= A_ELIPSE2_i;
        when "011"  => s_ej_total <= A_ELIPSE3_i;
        when "100"  => s_ej_total <= A_ELIPSE4_i;
        when "101"  => s_ej_total <= A_ELIPSE5_i;
        when "110"  => s_ej_total <= A_ELIPSE6_i;
        when "111"  => s_ej_total <= A_ELIPSE7_i;
        when others => s_ej_total <= "0000000000";
                       
      end case;

      case s_LENGTH_IS is  -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
        
        when "000"  => s_retr_total <= "0000000000";
        when "001"  => s_retr_total <= A_ELIPSE1_i;
        when "010"  => s_retr_total <= A_ELIPSE2_i;
        when "011"  => s_retr_total <= A_ELIPSE3_i;
        when "100"  => s_retr_total <= A_ELIPSE4_i;
        when "101"  => s_retr_total <= A_ELIPSE5_i;
        when "110"  => s_retr_total <= A_ELIPSE6_i;
        when "111"  => s_retr_total <= A_ELIPSE7_i;
        when others => s_retr_total <= "0000000000";
                       
      end case;
      
    else
      case LENGTH_MEM_i is  -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
        
        when "000"  => s_ej_total <= "0000000000";
        when "001"  => s_ej_total <= B_ELIPSE1_i;
        when "010"  => s_ej_total <= B_ELIPSE2_i;
        when "011"  => s_ej_total <= B_ELIPSE3_i;
        when "100"  => s_ej_total <= B_ELIPSE4_i;
        when "101"  => s_ej_total <= B_ELIPSE5_i;
        when "110"  => s_ej_total <= B_ELIPSE6_i;
        when "111"  => s_ej_total <= B_ELIPSE7_i;
        when others => s_ej_total <= "0000000000";
                       
      end case;

      case s_LENGTH_IS is  -- Tamanho do pulso menos 0.4us da duração do pulso de acionamento!
        
        when "000"  => s_retr_total <= "0000000000";
        when "001"  => s_retr_total <= B_ELIPSE1_i;
        when "010"  => s_retr_total <= B_ELIPSE2_i;
        when "011"  => s_retr_total <= B_ELIPSE3_i;
        when "100"  => s_retr_total <= B_ELIPSE4_i;
        when "101"  => s_retr_total <= B_ELIPSE5_i;
        when "110"  => s_retr_total <= B_ELIPSE6_i;
        when "111"  => s_retr_total <= B_ELIPSE7_i;
        when others => s_retr_total <= "0000000000";
                       
      end case;
      
    end if;
    
  end process;

  MAX_ACTIVE_COUNTER_o <= s_max_active_counter;

  
 -- seleção do canal 
  s_CH_IS0    <= (CONV_INTEGER(CH_NUM_i) * 3);
  s_CH_IS1    <= s_CH_IS0 + 1;
  s_CH_IS2    <= s_CH_IS1 + 1;
--Identifica o canal 
  s_CH_IS_INT <= (LENGTH_BUFF_i(s_CH_IS0) or LENGTH_BUFF_i(s_CH_IS1));
  s_CH_IS     <= (s_CH_IS_INT or LENGTH_BUFF_i(s_CH_IS2));
  
  
  
--Recebe os dados de cada bit do canal respectivo
  s_LENGTH_IS <= (LENGTH_BUFF_i(s_CH_IS2) & LENGTH_BUFF_i(s_CH_IS1) & LENGTH_BUFF_i(s_CH_IS0));

  
  -- sinal s_SHOULD_RETTRIG não é utilizado, e por consequencia, s_retr_total
  s_SHOULD_RETTRIG <= '1' when s_retr_total > s_ej_total else '0';

  -- estado da maquina de estado muda conforme info vinda da memória 
  s_valve_state_i <= PWM_i & ACTIVE_i;

  PWM_o    <= s_valve_state_o(1);
  ACTIVE_o <= s_valve_state_o(0);

  PROTEC_VALVE_o <= s_PROTEC_VALVE_o;

  
  -- sonda de testes 
  PROBE_o <= s_active_valves & PROTEC_VALVE_i & s_PROTEC_VALVE_o & s_valve_state_i & s_valve_state_o & s_CH_IS &
             s_has_already_ejected(0) & s_already_ejected(0) & C18MHZ_i;

  
  
  -- TESTE PARA PARAR EJEÇÃO -- já ejetou e não tem grão
  s_stop_ejection <= s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) and not ( HAS_GRAIN_i(CONV_INTEGER(CH_NUM_i)));  
  -- Flag that indicates: there is no grain and has already ejected!

 -- processa o canal?
  p_SEQ : process (RST_i, C18MHZ_i, s_valve_state_i, s_CH_IS, s_stop_ejection)
  begin

    if (RST_i = '1') then

      CH_OUT_o                 <= "0000000000000000000000000000000000000000000000000000000000000000";
      s_PROTEC_VALVE_o         <= '0';
      s_valve_state_o          <= "00"; --estado
      s_active_valves          <= (others => '0');
      COUNT_o                  <= "0000000000";
      DEF_CNT_o                <= "0000000000000000";
      s_inc_max_active_counter <= '0';
      s_max_active_counter     <= (others => '0');

      s_has_already_ejected <= (others => '0');
      
    elsif falling_edge(C18MHZ_i) then
      
	  
	  ---- rotina para indicar o numero de válvulas ativas-----
	  ---------------------------------------------------------
      if (s_active_valves > "001000") then
        if (s_inc_max_active_counter = '1') then
          s_inc_max_active_counter <= '1';
        else
          s_max_active_counter     <= s_max_active_counter + '1';
          s_inc_max_active_counter <= '1';
        end if;
      else
        s_inc_max_active_counter <= '0';
      end if;
	  --------------------------------------------------

      DEF_CNT_o    <= DEF_CNT_i;
	  
	  -- joga pra fora a entrada???
      LENGTH_MEM_o <= LENGTH_MEM_i;

      case s_valve_state_i is
        
        when "00" =>                    -- Valve is quiet
          -- sinal de ejeção do sinal = 0 para o canal selecionado (CH_NUM_I)
		  CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';

          if (s_stop_ejection = '1') then -- se já ejetou e não tem grão
            
            s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';  -- Clean has_already_ejected flag
            s_valve_state_o                               <= "00";  -- Do not eject
            
          else
              
              if (s_CH_IS = '1') then -- se já está ejetando, se houve requisição de ejeção
                
                s_valve_state_o <= "01";  -- PWM = 0 e  ACTIVE = 1 --> grava na memoria o estado
				
				
				-- indica o numero de valvulas ativas
                if (s_active_valves > "001000") then
                  s_PROTEC_VALVE_o <= '1'; -- protege a valvula se maior que 8
                else
                  s_PROTEC_VALVE_o <= '0';
                  s_active_valves  <= s_active_valves + 1;
                end if;
				------------------------------------------
                
				-- ??? joga pra saida do contador da memoria o tempo fixo de ejeção (500 ms)
                COUNT_o      <= c_ACIONA_EJ;
				-- joga para a memoria a elipse atual ???
                LENGTH_MEM_o <= s_LENGTH_IS; 
                                
              else -- se não está ejetando

                s_valve_state_o <= "00";
                
              end if;
              
          end if;
          
          
        when "01" =>                    -- Valve is active (500 ms)
          
          if s_stop_ejection = '1' then  -- If there is no grain and already ejected once -- grao todo preto, multiplas ejeções no mesmo grão
            
            s_valve_state_o                               <= "00";  -- Stop ejecting
            s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';
             
			-- verifica se a valvula está protegida (parada) ???
            if (PROTEC_VALVE_i = '1') then         -- If valve is inactive
              s_active_valves <= s_active_valves;  -- Keep active valve number
            else                        -- If valve is active
              -- ??? pq a contagem diminui se a valvula está ativa
			  s_PROTEC_VALVE_o <= '0'; -- desabilita a flag de prteção para a valvula especifica
              if (s_active_valves = "000000") then
                s_active_valves <= "000000";
              else
                s_active_valves <= s_active_valves - 1;  -- Decrease number of active valves
              end if;
            end if;
            
          else                          -- If this is the first ejection
            
            s_valve_state_o <= "01";    -- Keep ejecting

            if (PROTEC_VALVE_i = '1') then
              
              if (s_active_valves > "001000") then
                s_PROTEC_VALVE_o <= '1';
              else
                s_PROTEC_VALVE_o <= '0';
                s_active_valves  <= s_active_valves + 1;
              end if;
              
            else
              
              s_PROTEC_VALVE_o <= '0';

              if (s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) = '1') then  -- If this grain has already been ejected
                -- geração do PWM
                if (C3KHZ_i = '1') then  -- Do not generate active time, only PWM
                  CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);
                else
                  CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
                end if;
                
              else  -- If this grain has no being ejected yet                
                CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= not(PROTEC_VALVE_i);  -- Eject normally                
              end if;
              
            end if;

            if (COUNT_i = "0000000000") then              
              s_valve_state_o                  <= "10";
              COUNT_o                          <= s_ej_total;
              CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';              
            else              
              COUNT_o <= COUNT_i - 1;
              
            end if;
          end if;
          
        when "10" =>                    -- Valve is on PWM state (7.4KHz)

          if s_stop_ejection = '1' then  -- If there is no grain and already ejected once
            
            s_valve_state_o                               <= "00";  -- Stop ejecting
            s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '0';

            if (PROTEC_VALVE_i = '1') then         -- If valve is inactive
              s_active_valves <= s_active_valves;  -- Keep active valve number
            else                        -- If valve is active
              s_PROTEC_VALVE_o <= '0';
              if (s_active_valves = "000000") then
                s_active_valves <= "000000";
              else
                s_active_valves <= s_active_valves - 1;  -- Decrease number of active valves
              end if;
            end if;
            
          else                          -- If this is the first ejection
            s_valve_state_o <= "10";    -- Keep ejecting

            if (COUNT_i = "0000000000") then
              
              s_valve_state_o <= "00";

              s_has_already_ejected(CONV_INTEGER(CH_NUM_i)) <= '1';

              DEF_CNT_o <= DEF_CNT_i + '1';

              if (PROTEC_VALVE_i = '1') then
                s_active_valves                  <= s_active_valves;
                CH_OUT_o(CONV_INTEGER(CH_NUM_i)) <= '0';
              else
                if (s_active_valves = "000000") then
                  s_active_valves <= "000000";
                else
                  s_active_valves <= s_active_valves - 1;  -- Decrease number of active valves
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
                  s_active_valves  <= s_active_valves + 1;
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


end Behavioral;
