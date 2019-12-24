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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity WRAPPER is
  port (
    LENGTH_i : in std_logic_vector (191 downto 0);

    TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);  -- Tempo da estatistica de ejecoes (3 - 10seg)
    HAS_GRAIN_i         : in std_logic_vector(63 downto 0);

    INT_CH_REQ_i : in std_logic_vector (5 downto 0);  -- CH que a interface deseja ler

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

    PROBE_o : out std_logic_vector(15 downto 0);

    EJ_CNT_o : out std_logic_vector (15 downto 0);  --Estatistica do canal (Depende de CH_NUM_o)

    MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
    OVERUSAGE_o          : out std_logic_vector(63 downto 0);
    CH_OUT_o             : out std_logic_vector (63 downto 0));
end WRAPPER;

architecture Behavioral of WRAPPER is

  signal CH_NUM_o      : std_logic_vector (5 downto 0);
  signal LENGTH_BUFF_o : std_logic_vector (191 downto 0);

  component ALL_IN_BUFF is
    port (  LENGTH_i       : in  std_logic_vector (191 downto 0);
           CH_NUM_i      : in  std_logic_vector (5 downto 0);
           C56MHz_i      : in  std_logic;
           RST_i         : in  std_logic;
           LENGTH_BUFF_o : out std_logic_vector (191 downto 0));
  end component;

  component WRAPPER_EJET is
    port (LENGTH_BUFF_i : in std_logic_vector (191 downto 0);

           TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);  --Tempo da estatistica de ejecoes (3 - 10seg)
           HAS_GRAIN_i         : in std_logic_vector(63 downto 0);

           INT_CH_REQ_i : in std_logic_vector (5 downto 0);  --CH que a interface deseja ler

           RETRIGGER_ON_i : in std_logic;

           --Tempos iniciais do contador 
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

           C3KHZ_i : in std_logic;
           RST_i   : in std_logic;

           PROBE_o  : out std_logic_vector(15 downto 0);
           EJ_CNT_o : out std_logic_vector (15 downto 0);

           MAX_ACTIVE_COUNTER_o : out std_logic_vector (15 downto 0);
           CH_NUM_o             : out std_logic_vector (5 downto 0);
           OVERUSAGE_o          : out std_logic_vector(63 downto 0);
           CH_OUT_o             : out std_logic_vector (63 downto 0));
  end component;

  signal s_CH_NUM_o : std_logic_vector (5 downto 0);

begin

  i_ALL_BUFF : ALL_IN_BUFF port map(
    LENGTH_i      => LENGTH_i,  -- elipses (64 canais x 3 bits)
    CH_NUM_i      => CH_NUM_o,  -- canal sendo requisitado
    C56MHz_i      => C56MHz_i,   
    RST_i         => RST_i,
    LENGTH_BUFF_o => LENGTH_BUFF_o  
    );

  i_WRAPPER_EJET : WRAPPER_EJET port map(
    LENGTH_BUFF_i => LENGTH_BUFF_o,


    TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
    HAS_GRAIN_i         => HAS_GRAIN_i,
    INT_CH_REQ_i        => INT_CH_REQ_i,

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
    C3KHZ_i  => C3KHZ_i,
    RST_i    => RST_i,

    PROBE_o  => PROBE_o,
    EJ_CNT_o => EJ_CNT_o,

    MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
    CH_NUM_o             => CH_NUM_o,   --s_CH_NUM_o,
    OVERUSAGE_o          => OVERUSAGE_o,
    CH_OUT_o             => CH_OUT_o
    );

end Behavioral;

