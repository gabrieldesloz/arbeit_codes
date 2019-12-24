----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:05 03/18/2011 
-- Design Name: 
-- Module Name:    WRAPPER - Behavioral 
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

entity WRAPPER  is
    Port ( LENGTH_i : in  STD_LOGIC_VECTOR (191 downto 0);
--	 		  A_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
--			  B_TEMPO_MORTO_i : in STD_LOGIC_VECTOR (2 downto 0); -- Sinal que indica o tempo total morto (passos de 0.2us)
			  
--			  	DEF_CNT_RD_i : in std_logic_vector(0 downto 0); --Sinal indicando que a memoria esta sendo lida
				
				TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0); --Tempo da estatistica de ejecoes (3 - 10seg)
				HAS_GRAIN_i : in STD_LOGIC_VECTOR(63 downto 0);
				
				INT_CH_REQ_i : in std_logic_vector (5 downto 0); --CH que a interface deseja ler
				
				RETRIGGER_ON_i : in std_logic;
			  
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
           C3KHZ_i : in  STD_LOGIC;
			  C56MHz_i : in STD_LOGIC;
           RST_i : in  STD_LOGIC;
--			  RST_DEF_CNT_i : in STD_LOGIC;
				
				PROBE_o : out STD_LOGIC_VECTOR(15 downto 0);
				--PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
				EJ_CNT_o : out  STD_LOGIC_VECTOR (15 downto 0); --Estatistica do canal (Depende de CH_NUM_o)
--				CH_NUM_o : out  STD_LOGIC_VECTOR (5 downto 0);
--				CLEAR_CNT_o : out std_logic;
				MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
				OVERUSAGE_o : out std_logic_vector(63 downto 0);
           CH_OUT_o : out STD_LOGIC_VECTOR (63 downto 0); -- Sinais de ejecao dos canais
			  CH_OUT_SYNC2_o : out STD_LOGIC_VECTOR (63 downto 0) -- Sinais de ejecao dos canais segundo sincronismo (elipse 7 somente)
			  );
end WRAPPER ;

architecture Behavioral of WRAPPER  is

				signal CH_NUM_o	:  STD_LOGIC_VECTOR (5 downto 0);
				signal LENGTH_BUFF_o	:  STD_LOGIC_VECTOR (191 downto 0);

component ALL_IN_BUFF  is
    Port ( LENGTH_i : in  STD_LOGIC_VECTOR (191 downto 0);
           CH_NUM_i : in  STD_LOGIC_VECTOR (5 downto 0);
            C56MHz_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
           LENGTH_BUFF_o : out  STD_LOGIC_VECTOR (191 downto 0));
end component;

component WRAPPER_EJET  is
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
			  
			  PROBE_o : out STD_LOGIC_VECTOR(15 downto 0);
			  EJ_CNT_o : out  STD_LOGIC_VECTOR (15 downto 0);
--			  CLEAR_CNT_o : out std_logic;
--				PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
				MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
           CH_NUM_o : out  STD_LOGIC_VECTOR (5 downto 0);
			  OVERUSAGE_o : out std_logic_vector(63 downto 0);
           CH_OUT_o : out STD_LOGIC_VECTOR (63 downto 0); -- Sinais de ejecao dos canais
			  CH_OUT_SYNC2_o : out STD_LOGIC_VECTOR (63 downto 0) -- Sinais de ejecao dos canais segundo sincronismo (elipse 7 somente)
			  );
end component;

signal s_CH_NUM_o : STD_LOGIC_VECTOR (5 downto 0);

begin
--CH_NUM_o <= s_CH_NUM_o;

	i_ALL_BUFF : ALL_IN_BUFF  PORT MAP(
			  LENGTH_i => LENGTH_i,
           CH_NUM_i => CH_NUM_o,--s_CH_NUM_o,
           C56MHz_i => C56MHz_i,
           RST_i => RST_i,
           LENGTH_BUFF_o => LENGTH_BUFF_o
			);
			
	i_WRAPPER_EJET : WRAPPER_EJET  PORT MAP(
				LENGTH_BUFF_i => LENGTH_BUFF_o,
				
--				A_TEMPO_MORTO_i => A_TEMPO_MORTO_i,
--				B_TEMPO_MORTO_i => B_TEMPO_MORTO_i,
				
--				DEF_CNT_RD_i => DEF_CNT_RD_i,
				
				TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
				HAS_GRAIN_i => HAS_GRAIN_i,
				INT_CH_REQ_i => INT_CH_REQ_i,
	 
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
				
			  OVERUSAGE_CLR_A_i => OVERUSAGE_CLR_A_i,
			  OVERUSAGE_CLR_B_i => OVERUSAGE_CLR_B_i,
				
           C18MHZ_i => C18MHZ_i,
           C3KHZ_i => C3KHZ_i,
           RST_i => RST_i,
--			  RST_DEF_CNT_i => RST_DEF_CNT_i,
			  
			  PROBE_o => PROBE_o,
			  EJ_CNT_o => EJ_CNT_o,
--			  CLEAR_CNT_o => CLEAR_CNT_o,
				MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
				CH_NUM_o => CH_NUM_o,--s_CH_NUM_o,
				OVERUSAGE_o => OVERUSAGE_o,
           CH_OUT_o => CH_OUT_o,
			  CH_OUT_SYNC2_o => CH_OUT_SYNC2_o
			);

end Behavioral;

