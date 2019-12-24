------------------------------------------
-- This header applys to all submodules --
------------------------------------------
-- Company: Buhler SANMAK S/A
-- Engineer: C.E.Bertagnolli
-- 
-- Create Date:    09:03:45 03/24/2011 
-- Design Name:          Ejectors Control Wrapper
-- Module Name:    WRAPPER_TOP - Behavioral 
-- Project Name:   LED8
-- Target Devices: LED8
-- Tool versions: 12.4, 13.1, 13.2
-- Description:         This module is responsible for formatting the ejection signals and 
--                                              create the delay between detection and ejection
-- Dependencies:  MAIN.VHD
--
-- Revision: 3.1.3
-- Additional Comments: 
------------------------------------------
-- This header applys to all submodules --
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- ??? onde est� o delay entre a detec��o e eje��o? 

entity WRAPPER_TOP is
  port (
    CH_IN00_i : in std_logic_vector (2 downto 0);  -- qual a informa��o nestes bits? entradas sort a,b
    CH_IN01_i : in std_logic_vector (2 downto 0);  -- tempo de dura��o dos sinais ... (inx)
    CH_IN02_i : in std_logic_vector (2 downto 0);
    CH_IN03_i : in std_logic_vector (2 downto 0);
    CH_IN04_i : in std_logic_vector (2 downto 0);
    CH_IN05_i : in std_logic_vector (2 downto 0);
    CH_IN06_i : in std_logic_vector (2 downto 0);
    CH_IN07_i : in std_logic_vector (2 downto 0);
    CH_IN08_i : in std_logic_vector (2 downto 0);
    CH_IN09_i : in std_logic_vector (2 downto 0);
    CH_IN10_i : in std_logic_vector (2 downto 0);
    CH_IN11_i : in std_logic_vector (2 downto 0);
    CH_IN12_i : in std_logic_vector (2 downto 0);
    CH_IN13_i : in std_logic_vector (2 downto 0);
    CH_IN14_i : in std_logic_vector (2 downto 0);
    CH_IN15_i : in std_logic_vector (2 downto 0);
    CH_IN16_i : in std_logic_vector (2 downto 0);
    CH_IN17_i : in std_logic_vector (2 downto 0);
    CH_IN18_i : in std_logic_vector (2 downto 0);
    CH_IN19_i : in std_logic_vector (2 downto 0);
    CH_IN20_i : in std_logic_vector (2 downto 0);
    CH_IN21_i : in std_logic_vector (2 downto 0);
    CH_IN22_i : in std_logic_vector (2 downto 0);
    CH_IN23_i : in std_logic_vector (2 downto 0);
    CH_IN24_i : in std_logic_vector (2 downto 0);
    CH_IN25_i : in std_logic_vector (2 downto 0);
    CH_IN26_i : in std_logic_vector (2 downto 0);
    CH_IN27_i : in std_logic_vector (2 downto 0);
    CH_IN28_i : in std_logic_vector (2 downto 0);
    CH_IN29_i : in std_logic_vector (2 downto 0);
    CH_IN30_i : in std_logic_vector (2 downto 0);
    CH_IN31_i : in std_logic_vector (2 downto 0);
    CH_IN32_i : in std_logic_vector (2 downto 0);
    CH_IN33_i : in std_logic_vector (2 downto 0);
    CH_IN34_i : in std_logic_vector (2 downto 0);
    CH_IN35_i : in std_logic_vector (2 downto 0);
    CH_IN36_i : in std_logic_vector (2 downto 0);
    CH_IN37_i : in std_logic_vector (2 downto 0);
    CH_IN38_i : in std_logic_vector (2 downto 0);
    CH_IN39_i : in std_logic_vector (2 downto 0);
    CH_IN40_i : in std_logic_vector (2 downto 0);
    CH_IN41_i : in std_logic_vector (2 downto 0);
    CH_IN42_i : in std_logic_vector (2 downto 0);
    CH_IN43_i : in std_logic_vector (2 downto 0);
    CH_IN44_i : in std_logic_vector (2 downto 0);
    CH_IN45_i : in std_logic_vector (2 downto 0);
    CH_IN46_i : in std_logic_vector (2 downto 0);
    CH_IN47_i : in std_logic_vector (2 downto 0);
    CH_IN48_i : in std_logic_vector (2 downto 0);
    CH_IN49_i : in std_logic_vector (2 downto 0);
    CH_IN50_i : in std_logic_vector (2 downto 0);
    CH_IN51_i : in std_logic_vector (2 downto 0);
    CH_IN52_i : in std_logic_vector (2 downto 0);
    CH_IN53_i : in std_logic_vector (2 downto 0);
    CH_IN54_i : in std_logic_vector (2 downto 0);
    CH_IN55_i : in std_logic_vector (2 downto 0);
    CH_IN56_i : in std_logic_vector (2 downto 0);
    CH_IN57_i : in std_logic_vector (2 downto 0);
    CH_IN58_i : in std_logic_vector (2 downto 0);
    CH_IN59_i : in std_logic_vector (2 downto 0);
    CH_IN60_i : in std_logic_vector (2 downto 0);
    CH_IN61_i : in std_logic_vector (2 downto 0);
    CH_IN62_i : in std_logic_vector (2 downto 0);
    CH_IN63_i : in std_logic_vector (2 downto 0);
    -- ditam o delay entre a entrada e a saida dos canais de eje��o  ???? vis e ejec
    SYNC1_i   : in std_logic_vector (8 downto 0);  -- 0 e 31
    SYNC2_i   : in std_logic_vector (8 downto 0);  -- 32 e 63

    RETRIGGER_ON_i : in std_logic;      ----?????

    TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);  --  Tempo da estatistica de ejecoes (3 - 10seg) ?????
    HAS_GRAIN_i         : in std_logic_vector(63 downto 0);

    INT_CH_REQ_i : in std_logic_vector (5 downto 0);  -- CH que a interface deseja ler ???

    -- valor de 10 bits do contador PWM para cada elipse
    -- tamanho do sinal de acionamento da ejetora � fixo 
    A_ELIPSE1_i : in std_logic_vector (9 downto 0);  --
    A_ELIPSE2_i : in std_logic_vector (9 downto 0);
    A_ELIPSE3_i : in std_logic_vector (9 downto 0);
    A_ELIPSE4_i : in std_logic_vector (9 downto 0);
    A_ELIPSE5_i : in std_logic_vector (9 downto 0);
    A_ELIPSE6_i : in std_logic_vector (9 downto 0);
    A_ELIPSE7_i : in std_logic_vector (9 downto 0);

    B_ELIPSE1_i : in std_logic_vector (9 downto 0);  --
    B_ELIPSE2_i : in std_logic_vector (9 downto 0);
    B_ELIPSE3_i : in std_logic_vector (9 downto 0);
    B_ELIPSE4_i : in std_logic_vector (9 downto 0);
    B_ELIPSE5_i : in std_logic_vector (9 downto 0);
    B_ELIPSE6_i : in std_logic_vector (9 downto 0);
    B_ELIPSE7_i : in std_logic_vector (9 downto 0);

    OVERUSAGE_CLR_A_i : in std_logic;   --???????
    OVERUSAGE_CLR_B_i : in std_logic;

    -- entradas de clock e reset        
    C20US_i  : in std_logic;
    C56MHz_i : in std_logic;
    C18MHZ_i : in std_logic;
    C3KHZ_i  : in std_logic;
    RST_i    : in std_logic;


    PROBE_o              : out std_logic_vector(15 downto 0);
    EJ_CNT_o             : out std_logic_vector (15 downto 0);  --Estatistica do canal (Depende de CH_NUM_o)
    MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
    OVERUSAGE_o          : out std_logic_vector(63 downto 0);

    -- sinais de eje��o formatados, pulso longo + pulsos pequenos
    CH_EJ_o : out std_logic_vector (63 downto 0));
end WRAPPER_TOP;

architecture Behavioral of WRAPPER_TOP is

  component WRAPPER is
    port (
      LENGTH_i : in std_logic_vector (191 downto 0);

      TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);  --Tempo da estatistica de ejecoes (3 - 10seg)
      HAS_GRAIN_i         : in std_logic_vector(63 downto 0);

      INT_CH_REQ_i : in std_logic_vector (5 downto 0);  --CH que a interface deseja ler

      RETRIGGER_ON_i : in std_logic;

      A_ELIPSE1_i : in std_logic_vector (9 downto 0);  --
      A_ELIPSE2_i : in std_logic_vector (9 downto 0);
      A_ELIPSE3_i : in std_logic_vector (9 downto 0);
      A_ELIPSE4_i : in std_logic_vector (9 downto 0);
      A_ELIPSE5_i : in std_logic_vector (9 downto 0);
      A_ELIPSE6_i : in std_logic_vector (9 downto 0);
      A_ELIPSE7_i : in std_logic_vector (9 downto 0);

      B_ELIPSE1_i : in std_logic_vector (9 downto 0);  --
      B_ELIPSE2_i : in std_logic_vector (9 downto 0);
      B_ELIPSE3_i : in std_logic_vector (9 downto 0);
      B_ELIPSE4_i : in std_logic_vector (9 downto 0);
      B_ELIPSE5_i : in std_logic_vector (9 downto 0);
      B_ELIPSE6_i : in std_logic_vector (9 downto 0);
      B_ELIPSE7_i : in std_logic_vector (9 downto 0);

      OVERUSAGE_CLR_A_i : in std_logic;
      OVERUSAGE_CLR_B_i : in std_logic;

      C18MHZ_i : in std_logic;
      C3KHZ_i  : in std_logic;
      C56MHz_i : in std_logic;
      RST_i    : in std_logic;

      PROBE_o              : out std_logic_vector(15 downto 0);
      EJ_CNT_o             : out std_logic_vector (15 downto 0);  --Estatistica do canal (Depende de CH_NUM_o)
      MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
      OVERUSAGE_o          : out std_logic_vector(63 downto 0);
      CH_OUT_o             : out std_logic_vector (63 downto 0));
  end component;

  component MEM_CTRL_DELTA is
    port (C20US_i       : in  std_logic;
           RST_i        : in  std_logic;
           CH_EJ_i      : in  std_logic_vector (63 downto 0);
           CH_EJ_o      : out std_logic_vector (63 downto 0);
           SYNC_31_0_i  : in  std_logic_vector (8 downto 0);
           SYNC_63_32_i : in  std_logic_vector (8 downto 0));
  end component;

  signal CH_EJ_i    : std_logic_vector (63 downto 0);
  signal s_LENGTH_i : std_logic_vector (191 downto 0);

begin

-- informa��es de dura��o concatenadas em apenas um vetor
  s_LENGTH_i(2 downto 0)     <= CH_IN00_i;
  s_LENGTH_i(5 downto 3)     <= CH_IN01_i;
  s_LENGTH_i(8 downto 6)     <= CH_IN02_i;
  s_LENGTH_i(11 downto 9)    <= CH_IN03_i;
  s_LENGTH_i(14 downto 12)   <= CH_IN04_i;
  s_LENGTH_i(17 downto 15)   <= CH_IN05_i;
  s_LENGTH_i(20 downto 18)   <= CH_IN06_i;
  s_LENGTH_i(23 downto 21)   <= CH_IN07_i;
  s_LENGTH_i(26 downto 24)   <= CH_IN08_i;
  s_LENGTH_i(29 downto 27)   <= CH_IN09_i;
  s_LENGTH_i(32 downto 30)   <= CH_IN10_i;
  s_LENGTH_i(35 downto 33)   <= CH_IN11_i;
  s_LENGTH_i(38 downto 36)   <= CH_IN12_i;
  s_LENGTH_i(41 downto 39)   <= CH_IN13_i;
  s_LENGTH_i(44 downto 42)   <= CH_IN14_i;
  s_LENGTH_i(47 downto 45)   <= CH_IN15_i;
  s_LENGTH_i(50 downto 48)   <= CH_IN16_i;
  s_LENGTH_i(53 downto 51)   <= CH_IN17_i;
  s_LENGTH_i(56 downto 54)   <= CH_IN18_i;
  s_LENGTH_i(59 downto 57)   <= CH_IN19_i;
  s_LENGTH_i(62 downto 60)   <= CH_IN20_i;
  s_LENGTH_i(65 downto 63)   <= CH_IN21_i;
  s_LENGTH_i(68 downto 66)   <= CH_IN22_i;
  s_LENGTH_i(71 downto 69)   <= CH_IN23_i;
  s_LENGTH_i(74 downto 72)   <= CH_IN24_i;
  s_LENGTH_i(77 downto 75)   <= CH_IN25_i;
  s_LENGTH_i(80 downto 78)   <= CH_IN26_i;
  s_LENGTH_i(83 downto 81)   <= CH_IN27_i;
  s_LENGTH_i(86 downto 84)   <= CH_IN28_i;
  s_LENGTH_i(89 downto 87)   <= CH_IN29_i;
  s_LENGTH_i(92 downto 90)   <= CH_IN30_i;
  s_LENGTH_i(95 downto 93)   <= CH_IN31_i;
  s_LENGTH_i(98 downto 96)   <= CH_IN32_i;
  s_LENGTH_i(101 downto 99)  <= CH_IN33_i;
  s_LENGTH_i(104 downto 102) <= CH_IN34_i;
  s_LENGTH_i(107 downto 105) <= CH_IN35_i;
  s_LENGTH_i(110 downto 108) <= CH_IN36_i;
  s_LENGTH_i(113 downto 111) <= CH_IN37_i;
  s_LENGTH_i(116 downto 114) <= CH_IN38_i;
  s_LENGTH_i(119 downto 117) <= CH_IN39_i;
  s_LENGTH_i(122 downto 120) <= CH_IN40_i;
  s_LENGTH_i(125 downto 123) <= CH_IN41_i;
  s_LENGTH_i(128 downto 126) <= CH_IN42_i;
  s_LENGTH_i(131 downto 129) <= CH_IN43_i;
  s_LENGTH_i(134 downto 132) <= CH_IN44_i;
  s_LENGTH_i(137 downto 135) <= CH_IN45_i;
  s_LENGTH_i(140 downto 138) <= CH_IN46_i;
  s_LENGTH_i(143 downto 141) <= CH_IN47_i;
  s_LENGTH_i(146 downto 144) <= CH_IN48_i;
  s_LENGTH_i(149 downto 147) <= CH_IN49_i;
  s_LENGTH_i(152 downto 150) <= CH_IN50_i;
  s_LENGTH_i(155 downto 153) <= CH_IN51_i;
  s_LENGTH_i(158 downto 156) <= CH_IN52_i;
  s_LENGTH_i(161 downto 159) <= CH_IN53_i;
  s_LENGTH_i(164 downto 162) <= CH_IN54_i;
  s_LENGTH_i(167 downto 165) <= CH_IN55_i;
  s_LENGTH_i(170 downto 168) <= CH_IN56_i;
  s_LENGTH_i(173 downto 171) <= CH_IN57_i;
  s_LENGTH_i(176 downto 174) <= CH_IN58_i;
  s_LENGTH_i(179 downto 177) <= CH_IN59_i;
  s_LENGTH_i(182 downto 180) <= CH_IN60_i;
  s_LENGTH_i(185 downto 183) <= CH_IN61_i;
  s_LENGTH_i(188 downto 186) <= CH_IN62_i;
  s_LENGTH_i(191 downto 189) <= CH_IN63_i;

  i_EJ_TIMER : WRAPPER port map (
    -- entrada da dura��o de cada canal
    LENGTH_i            => s_LENGTH_i,
    TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
    HAS_GRAIN_i         => HAS_GRAIN_i,
    INT_CH_REQ_i        => INT_CH_REQ_i,

    RETRIGGER_ON_i => RETRIGGER_ON_i,

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
    C3KHZ_i  => C3KHZ_i,
    C56MHz_i => C56MHz_i,
    RST_i    => RST_i,

    PROBE_o              => PROBE_o,
    EJ_CNT_o             => EJ_CNT_o,
    MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
    OVERUSAGE_o          => OVERUSAGE_o,
    CH_OUT_o             => CH_EJ_i
    );

	
 -- ??? cria um delay
  i_MEM_DELTA : MEM_CTRL_DELTA port map (

    C20US_i      => C20US_i,
    RST_i        => RST_i,
    CH_EJ_i      => CH_EJ_i,
    CH_EJ_o      => CH_EJ_o,  
    SYNC_31_0_i  => SYNC1_i, -- endere�amento externo por delay
    SYNC_63_32_i => SYNC2_i  -- endere�amento externo por delay
    );

end Behavioral;

