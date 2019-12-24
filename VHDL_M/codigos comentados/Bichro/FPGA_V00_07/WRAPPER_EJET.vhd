----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:51 03/23/2011 
-- Design Name: 
-- Module Name:    WRAPPER_EJET - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
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

entity WRAPPER_EJET  is
    Port ( LENGTH_BUFF_i : in  STD_LOGIC_VECTOR (191 downto 0);
--				A_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
--				B_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
				
--				DEF_CNT_RD_i : in std_logic_vector(0 downto 0); --Sinal indicando que a memoria esta sendo lida
				
				TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0); --Tempo da estatistica de ejecoes (3 - 10seg)
				HAS_GRAIN_i : in STD_LOGIC_VECTOR(63 downto 0);
				
				INT_CH_REQ_i : in std_logic_vector (5 downto 0); --CH que a interface deseja ler
				
				RETRIGGER_ON_i : in std_logic;
	 
			  	--Tempos iniciais do contador 
				A_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0); --
				A_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);
				
				B_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0); --
				B_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);

			  OVERUSAGE_CLR_A_i : in STD_LOGIC;
			  OVERUSAGE_CLR_B_i : in STD_LOGIC;
	 
           C18MHZ_i : in  STD_LOGIC;
--			  C20US_i : in STD_LOGIC;
           C3KHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  --RST_DEF_CNT_i : in STD_LOGIC;
			  
			  PROBE_o : out STD_LOGIC_VECTOR (15 downto 0); --Sinais de ejecao dos canais
			  EJ_CNT_o : out  STD_LOGIC_VECTOR (15 downto 0);
--			  CLEAR_CNT_o : out std_logic;
				MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
				--PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
           CH_NUM_o : out  STD_LOGIC_VECTOR (5 downto 0);
			  OVERUSAGE_o : out std_logic_vector(63 downto 0);
           CH_OUT_o : out STD_LOGIC_VECTOR (63 downto 0); -- Sinais de ejecao dos canais
			  CH_OUT_SYNC2_o : out STD_LOGIC_VECTOR (63 downto 0) -- Sinais de ejecao dos canais segundo sincronismo (elipse 7 somente)
			  );
end WRAPPER_EJET ;

architecture Behavioral of WRAPPER_EJET  is

				signal LENGTH_MEM_i : STD_LOGIC_VECTOR (2 downto 0);
				signal ACTIVE_i	:  STD_LOGIC;
				signal PWM_i		:  STD_LOGIC;
				signal COUNT_i	:  STD_LOGIC_VECTOR (9 downto 0);--in STD_LOGIC_VECTOR (7 downto 0);
				
				signal LENGTH_MEM_o : STD_LOGIC_VECTOR (2 downto 0);
				signal COUNT_o	:  STD_LOGIC_VECTOR (9 downto 0);--out STD_LOGIC_VECTOR (7 downto 0);
				signal ACTIVE_o	: STD_LOGIC;
				signal s_CH_NUM_o	:  STD_LOGIC_VECTOR (5 downto 0);
				signal PWM_o		:  STD_LOGIC;
				
				signal LENGTH_BUFF_o	:  STD_LOGIC_VECTOR (191 downto 0);
				
				signal PROTEC_VALVE_i : STD_LOGIC;
				signal PROTEC_VALVE_o : STD_LOGIC;
				
				signal s_DEF_CNT_i : std_logic_vector (15 downto 0);
				signal s_DEF_CNT_o : std_logic_vector (15 downto 0);

component MEM_CTRL  is
    Port ( PROTEC_VALVE_i : in STD_LOGIC;
			  LENGTH_MEM_i : in STD_LOGIC_VECTOR (2 downto 0);
			  COUNT_i : in  STD_LOGIC_VECTOR (9 downto 0);
           ACTIVE_i : in  STD_LOGIC;
           PWM_i : in  STD_LOGIC;
			  DEF_CNT_i: in std_logic_vector(15 downto 0);
--			  DEF_CNT_RD_i : in std_logic_vector(0 downto 0); --Sinal indicando que a memoria esta sendo lida
			  
			  TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);
			  INT_CH_REQ_i : in std_logic_vector (5 downto 0); --CH que a interface deseja ler
			  OVERUSAGE_CLR_A_i : in STD_LOGIC;
			  OVERUSAGE_CLR_B_i : in STD_LOGIC;
			  
           C18MHZ_i : in  STD_LOGIC;
--			  C20US_i : in STD_LOGIC;
			  C3KHZ_i : in STD_LOGIC;
           RST_i : in  STD_LOGIC;
			 -- RST_DEF_CNT_i : in std_logic;
			  
			  LENGTH_MEM_o : out STD_LOGIC_VECTOR (2 downto 0);
           COUNT_o : out  STD_LOGIC_VECTOR (9 downto 0);
           PWM_o : out  STD_LOGIC;
           ACTIVE_o : out  STD_LOGIC;
			  PROTEC_VALVE_o : out STD_LOGIC;
			  PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
			  DEF_CNT_o : out std_logic_vector(15 downto 0); --Sinal de estatistica que vai ser atualizado
			  EJ_CNT_o : out std_logic_vector(15 downto 0); -- Sinal que vai ser jogado para a interface mostrando as estatisticas totais
			  OVERUSAGE_o : out std_logic_vector(63 downto 0);
			  --CLEAR_CNT_o : out std_logic;
           CH_NUM_o : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component CH_X_EJET_TIMER  is
    Port ( 	LENGTH_BUFF_i : in STD_LOGIC_VECTOR (191 downto 0); --Sinais vindos do "buffer" de entrada
--				A_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
--				B_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
				CH_NUM_i : in STD_LOGIC_VECTOR (5 downto 0);--Sinal que indica qual canal deve ser tratado no momento
				HAS_GRAIN_i : in STD_LOGIC_VECTOR(63 downto 0);
				ACTIVE_i	: in STD_LOGIC; --Sinal vindo da memoria que indica se a ejetora esta ativa ou nao
				PWM_i		: in STD_LOGIC; --Sinal que indica quando o sinal de acionamento de 0.4ms acabou e o pwm inicia
				PROTEC_VALVE_i : in std_logic; --Sinal que vem da memoria e indica se ha tempo morto
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
--				RST_DEF_CNT_i : in STD_LOGIC;
				
				PROBE_o : out STD_LOGIC_VECTOR (15 downto 0); --Sinais de ejecao dos canais
				CH_OUT_o : out STD_LOGIC_VECTOR (63 downto 0); -- Sinais de ejecao dos canais
				CH_OUT_SYNC2_o : out STD_LOGIC_VECTOR (63 downto 0); -- Sinais de ejecao dos canais segundo sincronismo (elipse 7 somente)
				LENGTH_MEM_o : out STD_LOGIC_VECTOR (2 downto 0);
				COUNT_o	: out STD_LOGIC_VECTOR (9 downto 0); --Valor do contador do canal que vai para a memoria
				ACTIVE_o	: out STD_LOGIC; --Indica se a ejecao deve continuar ou nao
				PWM_o		: out STD_LOGIC;	 --Indica se o PWM esta ativo
				DEF_CNT_o : out std_logic_vector (15 downto 0);
				MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
				PROTEC_VALVE_o : out STD_LOGIC 
				); --Indica se o tempo morto esta ativo
end component;

signal s_probe_ch_x : std_logic_vector(15 downto 0); 
signal s_probe_mem : std_logic_vector(7 downto 0);

begin

--EJ_CNT_o <= s_DEF_CNT_o;
CH_NUM_o <= s_CH_NUM_o;

PROBE_o <= s_probe_ch_x(15 downto 3) & s_probe_mem(2 downto 1) & s_probe_ch_x(0);

i_MEM_CTRL : MEM_CTRL  PORT MAP (

			  LENGTH_MEM_i => LENGTH_MEM_i,
			  COUNT_i => COUNT_i,
           ACTIVE_i => ACTIVE_i,
           PWM_i => PWM_i,
			  PROTEC_VALVE_i => PROTEC_VALVE_i,
			  DEF_CNT_i => s_DEF_CNT_i, 
--			  DEF_CNT_RD_i => DEF_CNT_RD_i,
			  
			  TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
			  INT_CH_REQ_i => INT_CH_REQ_i,
			  OVERUSAGE_CLR_A_i => OVERUSAGE_CLR_A_i,
			  OVERUSAGE_CLR_B_i => OVERUSAGE_CLR_B_i,
			  
           C18MHZ_i => C18MHZ_i,
--			  C20US_i => C20US_i,
			  C3KHZ_i => C3KHZ_i,
           RST_i => RST_i,
			  --RST_DEF_CNT_i => RST_DEF_CNT_i,
			  
			  LENGTH_MEM_o => LENGTH_MEM_o,
           COUNT_o => COUNT_o,
           PWM_o => PWM_o,
           ACTIVE_o => ACTIVE_o,
			  PROTEC_VALVE_o => PROTEC_VALVE_o,
			  PROBE_o => s_probe_mem,
			  DEF_CNT_o => s_DEF_CNT_o,
			  EJ_CNT_o => EJ_CNT_o,
			  OVERUSAGE_o => OVERUSAGE_o,
--			  CLEAR_CNT_o => CLEAR_CNT_o,
           CH_NUM_o => s_CH_NUM_o
);

i_EJET_TIMER : CH_X_EJET_TIMER  PORT MAP (
			   LENGTH_BUFF_i	=> LENGTH_BUFF_i,
--				A_TEMPO_MORTO_i => A_TEMPO_MORTO_i,
--				B_TEMPO_MORTO_i => B_TEMPO_MORTO_i,
				CH_NUM_i => s_CH_NUM_o,
				HAS_GRAIN_i => HAS_GRAIN_i,
				ACTIVE_i	=> ACTIVE_o,
				PWM_i		=> PWM_o,
				COUNT_i	=> COUNT_o,
				LENGTH_MEM_i => LENGTH_MEM_o,
				PROTEC_VALVE_i => PROTEC_VALVE_o,
				DEF_CNT_i => s_DEF_CNT_o,
				
				RETRIGGER_ON_i => RETRIGGER_ON_i,
				
				--Tempos iniciais do contador 
				A_ELIPSE1_i => A_ELIPSE1_i,
				A_ELIPSE2_i => A_ELIPSE2_i,
				A_ELIPSE3_i => A_ELIPSE3_i,
				A_ELIPSE4_i => A_ELIPSE4_i,
				A_ELIPSE5_i => A_ELIPSE5_i,
				A_ELIPSE6_i => A_ELIPSE6_i,
				A_ELIPSE7_i => A_ELIPSE7_i,
				
				B_ELIPSE1_i => B_ELIPSE1_i,
				B_ELIPSE2_i => B_ELIPSE2_i,
				B_ELIPSE3_i => B_ELIPSE3_i,
				B_ELIPSE4_i => B_ELIPSE4_i,
				B_ELIPSE5_i => B_ELIPSE5_i,
				B_ELIPSE6_i => B_ELIPSE6_i,
				B_ELIPSE7_i => B_ELIPSE7_i,
				
            C18MHZ_i 	=> C18MHZ_i,
            C3KHZ_i 	=> C3KHZ_i,
				RST_i		=> RST_i,
--				RST_DEF_CNT_i => RST_DEF_CNT_i,
				 
				PROBE_o => s_probe_ch_x,
				CH_OUT_o => CH_OUT_o,
				CH_OUT_SYNC2_o => CH_OUT_SYNC2_o,
				LENGTH_MEM_o => LENGTH_MEM_i,
				COUNT_o	=> COUNT_i,
				ACTIVE_o	=> ACTIVE_i,
				PROTEC_VALVE_o => PROTEC_VALVE_i,
				DEF_CNT_o => s_DEF_CNT_i,
				MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
				PWM_o		=> PWM_i
);

end Behavioral;

