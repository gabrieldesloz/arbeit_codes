----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:19:55 03/18/2011 
-- Design Name: 
-- Module Name:    MEM_CTRL - Behavioral 
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

entity MEM_CTRL is
  port (
  -- IN Valvulas excedentes --> concatenado no vetor S_DATA_IN --> memoria EJ_SEL_MEM
  -- ativa quando tem valvula em excesso (9) 
    PROTEC_VALVE_i    : in std_logic; 
  -- Limpa flags de sobre - uso das válvulas ??? limpa os vetores de 32 bits, sinal externo WRAPPER_EJET
  -- s_overusage_a, s_overusage_b
    OVERUSAGE_CLR_A_i : in std_logic; -- ultrapassa numero maximo de ejeçoes, limpa flag, protege ejeçoes
    OVERUSAGE_CLR_B_i : in std_logic;
  -- Indica qual a elipse utilizada -> concatenado no vetor S_DATA_IN --> memoria EJ_SEL_MEM
    LENGTH_MEM_i      : in std_logic_vector (2 downto 0); 
  -- Contador vindo da memoria ??? -> concatenado no vetor S_DATA_IN --> memoria EJ_SEL_MEM
    COUNT_i           : in std_logic_vector (9 downto 0);
  -- indica se a ejetora está ativa ou não -> concatenado no vetor S_DATA_IN --> memoria EJ_SEL_MEM
    ACTIVE_i          : in std_logic;
 -- indica quando o sinal de acionamento de 0.4ms acabou e o pwm inicia -> concatenado no vetor S_DATA_IN --> memoria EJ_SEL_MEM 
    PWM_i             : in std_logic;
 -- contagem ATUAL, vinda da memoria, numero de defeitos
 -- -> memoria de defeitos, -> memoria de ejeções ???
    DEF_CNT_i         : in std_logic_vector(15 downto 0);

 -- Tempo da estatistica de ejecoes (3 - 10seg) -> EJ_CLEAR_COUNT
    TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);
 -- CH que a interface deseja ler (canal), externo WRAPPER_EJET
 -- -> endereço memoria do total de ejeções -- -> i_MEM_DEF_OUT ???
    INT_CH_REQ_i        : in std_logic_vector (5 downto 0);  

    C18MHZ_i : in std_logic;
    C3KHZ_i  : in std_logic;
    RST_i    : in std_logic;
   -- elipse detectada, dependente de ( p_contador -> s_rd_ptr -> S_DATA_OUT -> LENGTH_MEM_o)
    LENGTH_MEM_o   : out std_logic_vector (2 downto 0);
	-- idem
    COUNT_o        : out std_logic_vector (9 downto 0);
	-- idem
    PWM_o          : out std_logic; 
	-- idem
    ACTIVE_o       : out std_logic;
	-- idem
    PROTEC_VALVE_o : out std_logic;
	--- teste
    PROBE_o        : out std_logic_vector(7 downto 0);
	
	-- Sinal de estatistica que vai ser atualizado -- memoria de contagem de ejeçoes	
    DEF_CNT_o      : out std_logic_vector(15 downto 0);  
	-- Sinal que vai ser jogado para a interface mostrando as estatisticas totais 
	-- memoria do contador do numero total de ejeções
    EJ_CNT_o       : out std_logic_vector(15 downto 0);  
	-- se o numero total de ejeções for maior que 3000, s_overusage_max = '1' para cada INT_CH_REQ_i (válvula)
    OVERUSAGE_o    : out std_logic_vector(63 downto 0);
    -- numero do canal sendo processado	( = s_rd_ptr, contador de leitura das memorias)
    CH_NUM_o       : out std_logic_vector (5 downto 0));
end MEM_CTRL;



architecture Behavioral of MEM_CTRL is

  component EJ_SEL_MEM
    port (
      a    : in  std_logic_vector(5 downto 0);
      d    : in  std_logic_vector(15 downto 0);
      dpra : in  std_logic_vector(5 downto 0);
      clk  : in  std_logic;
      we   : in  std_logic;
      dpo  : out std_logic_vector(15 downto 0));
  end component;

  component MEM_DEF_CNT_DIST
    port (
      clk      : in  std_logic;
      we       : in  std_logic;
      a        : in  std_logic_vector(5 downto 0);
      d        : in  std_logic_vector(15 downto 0);
      qdpo_clk : in  std_logic;
      qdpo_rst : in  std_logic;
      dpra     : in  std_logic_vector(5 downto 0);
      qdpo     : out std_logic_vector(15 downto 0));
  end component;

  component EJ_CLEAR_COUNT is
    port (TEMPO_ESTATISTICA_i : in  std_logic_vector (2 downto 0);
          C3KHZ_i             : in  std_logic;
          RST_i               : in  std_logic;
          CLEAR_CNT_o         : out std_logic);
  end component;

  attribute syn_black_box               : boolean;
  attribute syn_black_box of EJ_SEL_MEM : component is true;
  signal s_rd_ptr                       : std_logic_vector (5 downto 0);
  signal s_wr_ptr                       : std_logic_vector (5 downto 0);
  signal s_DATA_IN                      : std_logic_vector (15 downto 0);
  signal s_DATA_OUT                     : std_logic_vector (15 downto 0);
  signal s_cnt_ptr                      : std_logic_vector (5 downto 0);
  signal s_EJ_CNT_o                     : std_logic_vector(15 downto 0);
  signal s_RST_DEF_CNT                  : std_logic;

  signal s_CLEAR_CNT_o : std_logic;

  signal s_DEF_CNT_RD_i : std_logic;

  signal s_def_rd_ptr : std_logic_vector (5 downto 0);

  signal s_INT         : std_logic;
  signal s_tst         : std_logic;
  signal s_TSTz        : std_logic;
  signal s_RST_CNT_MEM : std_logic;

  signal s_CNTHERE : std_logic_vector(6 downto 0);

  signal s_overusage_max                      : std_logic;
  signal s_overusage_int_a, s_overusage_int_b : std_logic_vector(31 downto 0);
  signal s_overusage_a, s_overusage_b         : std_logic_vector(31 downto 0);
  signal s_overusage                          : std_logic_vector(63 downto 0);

  signal s_is_ch0, s_is_ch32 : std_logic;

begin


-- memoria do total de ejeções só é ativada para escrita quando
  s_tst         <= (not(s_INT) and s_CLEAR_CNT_o);
  s_RST_DEF_CNT <= RST_i or s_INT;

  s_TSTz <= s_tst;

  ----------------------

  s_wr_ptr <= s_rd_ptr;

  CH_NUM_o <= s_rd_ptr;

  s_DATA_IN(9 downto 0)   <= COUNT_i;
  s_DATA_IN(10)           <= ACTIVE_i;
  s_DATA_IN(11)           <= PWM_i;
  s_DATA_IN(12)           <= PROTEC_VALVE_i;
  s_DATA_IN(15 downto 13) <= LENGTH_MEM_i;

  COUNT_o        <= s_DATA_OUT(9 downto 0);
  ACTIVE_o       <= s_DATA_OUT(10);
  PWM_o          <= s_DATA_OUT(11);
  PROTEC_VALVE_o <= s_DATA_OUT(12);
  LENGTH_MEM_o   <= s_DATA_OUT(15 downto 13);
  ----------------------

-- memoria info ejeções ???
  i_MEM1 : EJ_SEL_MEM
    port map (
      a    => s,
      d    => s_DATA_IN,
      dpra => s_rd_ptr,
      clk  => C18MHZ_i,
      we   => '1',
      dpo  => s_DATA_OUT);

-- Memoria de contagem de defeitos, endereço está atrasado em 1 ciclo em relação
-- às outras memórias
  i_MEM_DEF_CNT : MEM_DEF_CNT_DIST    
    port map (
      clk      => C18MHZ_i,
      we       => '1',
      a        => s_cnt_ptr, -- endereço da escrita ???
      d        => DEF_CNT_i,
      qdpo_clk => C18MHZ_i,
      qdpo_rst => s_RST_DEF_CNT,
      dpra     => s_rd_ptr, -- endereço da leitura ???
      qdpo     => DEF_CNT_o);

-- Memoria que armazena o valor total de ejeçoes (diferença ???)
  i_MEM_DEF_OUT : MEM_DEF_CNT_DIST  
    port map (
      clk      => C18MHZ_i,
      we       => s_TSTz,
      a        => s_rd_ptr,             --CH_NUM_i,  -- endereço da escrita ???
      d        => DEF_CNT_i,
      qdpo_clk => C18MHZ_i,
      qdpo_rst => RST_i,
      dpra     => INT_CH_REQ_i, -- endereço da leitura ???
      qdpo     => s_EJ_CNT_o);

  EJ_CNT_o <= s_EJ_CNT_o;



  i_EJ_CLEAR : EJ_CLEAR_COUNT
    port map(
      TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
      C3KHZ_i             => C3KHZ_i,
      RST_i               => RST_i,
      CLEAR_CNT_o         => s_CLEAR_CNT_o);

  s_is_ch0  <= '1' when (s_rd_ptr = "000000") else '0';
  s_is_ch32 <= '1' when (s_rd_ptr = "100000") else '0';

  -----------------------------------------------------------------------------------------------
  ------------------------------------------ OVERUSAGE ------------------------------------------
  -----------------------------------------------------------------------------------------------
  -- Make this a block when there is enough time

  PROBE_o <= s_overusage_max & s_overusage(0) & s_overusage_int_a(0) & OVERUSAGE_CLR_A_i & s_overusage_a(0) & s_is_ch0 & s_is_ch32 & '0';  --"000";

  --uso maior que 3000
  s_overusage_max <= '1' when (s_EJ_CNT_o > "0000101110111000") else '0'; -- maior que 3000

  process(RST_i, C18MHZ_i, OVERUSAGE_CLR_A_i, OVERUSAGE_CLR_B_i, s_overusage_max)
  begin
    if rising_edge(C18MHZ_i) then
      if (RST_i = '1') then
        s_overusage <= (others => '0');
      else
        if (s_overusage_max = '1') then
          s_overusage(CONV_INTEGER(INT_CH_REQ_i)) <= '1';
        else
          s_overusage(CONV_INTEGER(INT_CH_REQ_i)) <= '0';
        end if;
      end if;
    end if;
  end process;

  s_overusage_int_a <= s_overusage(31 downto 0);
  s_overusage_int_b <= s_overusage(63 downto 32);

  overusage : for i in 0 to 31 generate
  begin
    process(RST_i, OVERUSAGE_CLR_A_i, OVERUSAGE_CLR_b_i, s_overusage_int_a, s_overusage_int_b)
    begin
      
      if (RST_i = '1') or (OVERUSAGE_CLR_A_i = '1') then
        s_overusage_a(i) <= '0';
      else
        if rising_edge(s_overusage_int_a(i)) then
          s_overusage_a(i) <= '1';
        end if;
      end if;

      if (RST_i = '1') or (OVERUSAGE_CLR_B_i = '1') then
        s_overusage_b(i) <= '0';
      else
          if rising_edge(s_overusage_int_b(i)) then
            s_overusage_b(i) <= '1';
          end if;
      end if;
      
    end process;
    
  end generate;

  OVERUSAGE_o <= s_overusage_b & s_overusage_a;
  -----------------------------------------------------------------------------------------------

  p_contador : process(C18MHZ_i, RST_i)
  begin
    
    if rising_edge(C18MHZ_i) then

      if (RST_i = '1') then
        s_rd_ptr <= "000000";
       -- le no proximo, escreve no anterior 
      else
        
        s_rd_ptr  <= s_rd_ptr + 1;
        s_cnt_ptr <= s_rd_ptr;
        
      end if;
    end if;
    
  end process;

  
  
  -- processo para limpar a memoria de estatistica de ejecoes
  -- controle de acesso a memoria das ejecoes ?? 
  p_rst_cnt_mem : process(C18MHZ_i, RST_i, s_CLEAR_CNT_o)
  begin
    
    if rising_edge(C18MHZ_i) then

      if (RST_i = '1') then
        s_INT     <= '0';
        s_CNTHERE <= "1111111"; -- 127 
      else
        if (s_CLEAR_CNT_o = '1') then -- vem do modulo de reset, com frequencia de 3 kHz
          if (s_CNTHERE = "0000000") then
            s_INT <= '1';  -- sinal de enable da memoria de saída ( so atualiza quando o contador chega ao final )
          else
              s_INT     <= '0';
              s_CNTHERE <= s_CNTHERE - 1;
          end if;
        else
          s_INT     <= '0';
          s_CNTHERE <= "1111111";
        end if;
      end if;
    end if;
    
  end process;
  
end Behavioral;
