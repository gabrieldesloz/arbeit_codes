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

entity MEM_CTRL is
    Port ( PROTEC_VALVE_i : in STD_LOGIC;
			  OVERUSAGE_CLR_A_i : in STD_LOGIC;
			  OVERUSAGE_CLR_B_i : in STD_LOGIC;
			  LENGTH_MEM_i : in STD_LOGIC_VECTOR (2 downto 0);
			  COUNT_i : in  STD_LOGIC_VECTOR (9 downto 0);
           ACTIVE_i : in  STD_LOGIC;
           PWM_i : in  STD_LOGIC;
			  DEF_CNT_i: in std_logic_vector(15 downto 0);

			  
			  TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0);
			  INT_CH_REQ_i : in std_logic_vector (5 downto 0); --CH que a interface deseja ler
			  
           C18MHZ_i : in  STD_LOGIC;
			  C3KHZ_i : in STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  LENGTH_MEM_o : out STD_LOGIC_VECTOR (2 downto 0);
           COUNT_o : out  STD_LOGIC_VECTOR (9 downto 0);
           PWM_o : out  STD_LOGIC;
           ACTIVE_o : out  STD_LOGIC;
			  PROTEC_VALVE_o : out STD_LOGIC;
			  PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
			  DEF_CNT_o : out std_logic_vector(15 downto 0); --Sinal de estatistica que vai ser atualizado
			  EJ_CNT_o : out std_logic_vector(15 downto 0); -- Sinal que vai ser jogado para a interface mostrando as estatisticas totais
			  OVERUSAGE_o : out std_logic_vector(63 downto 0);
           CH_NUM_o : out  STD_LOGIC_VECTOR (5 downto 0));
end MEM_CTRL;

architecture Behavioral of MEM_CTRL is

component EJ_SEL_MEM
	port (
	a: in std_logic_vector(5 downto 0);
	d: in std_logic_vector(15 downto 0);
	dpra: in std_logic_vector(5 downto 0);
	clk: in std_logic;
	we: in std_logic;
	dpo: out std_logic_vector(15 downto 0));
end component;

COMPONENT MEM_DEF_CNT_DIST
  PORT (
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    a : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    qdpo_clk : IN STD_LOGIC;
    qdpo_rst : IN STD_LOGIC;
    dpra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    qdpo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

COMPONENT EJ_CLEAR_COUNT is
    Port ( TEMPO_ESTATISTICA_i : in  STD_LOGIC_VECTOR (2 downto 0);
			  C3KHZ_i : in  STD_LOGIC;
			  RST_i : in  STD_LOGIC;
           CLEAR_CNT_o : out  STD_LOGIC);
end COMPONENT;

attribute syn_black_box : boolean;
attribute syn_black_box of EJ_SEL_MEM: component is true;
signal s_rd_ptr   : std_logic_vector (5 downto 0);
signal s_wr_ptr   : std_logic_vector (5 downto 0);
signal s_DATA_IN  : std_logic_vector (15 downto 0);
signal s_DATA_OUT : std_logic_vector (15 downto 0);
signal s_cnt_ptr   : std_logic_vector (5 downto 0);
signal s_EJ_CNT_o : std_logic_vector(15 downto 0);
signal s_RST_DEF_CNT : std_logic;

signal s_CLEAR_CNT_o : std_logic;

signal s_DEF_CNT_RD_i : std_logic;

signal s_def_rd_ptr : std_logic_vector (5 downto 0);

signal s_INT : std_logic;
signal s_tst : std_logic;
signal s_TSTz : std_logic;
signal s_RST_CNT_MEM : std_logic;

signal s_CNTHERE : std_logic_vector(6 downto 0);

signal s_overusage_max : std_logic;
signal s_overusage_int_a, s_overusage_int_b : std_logic_vector(31 downto 0);
signal s_overusage_a, s_overusage_b : std_logic_vector(31 downto 0);
signal s_overusage : std_logic_vector(63 downto 0);

signal s_is_ch0, s_is_ch32 : std_logic;

begin

	s_tst <= (not(s_INT) and s_CLEAR_CNT_o);
	s_RST_DEF_CNT <= RST_i or s_INT;
	
	s_TSTz <= s_tst;
	
	----------------------
	
	s_wr_ptr <= s_rd_ptr;
	
	CH_NUM_o <=  s_rd_ptr;

	s_DATA_IN(9 downto 0) <= COUNT_i;
	s_DATA_IN(10) <= ACTIVE_i;
	s_DATA_IN(11) <= PWM_i;
	s_DATA_IN(12) <= PROTEC_VALVE_i;
	s_DATA_IN(15 downto 13) <= LENGTH_MEM_i;

	COUNT_o  <= s_DATA_OUT(9 downto 0);
	ACTIVE_o <= s_DATA_OUT(10);
	PWM_o		<= s_DATA_OUT(11);
	PROTEC_VALVE_o <= s_DATA_OUT(12);
	LENGTH_MEM_o <= s_DATA_OUT(15 downto 13);
	----------------------
	

	i_MEM1 : EJ_SEL_MEM
		port map (
			a => s_wr_ptr,
			d => s_DATA_IN,
			dpra => s_rd_ptr,
			clk => C18MHZ_i,
			we => '1',
			dpo => s_DATA_OUT);
			
	i_MEM_DEF_CNT : MEM_DEF_CNT_DIST --Memoria de contagem de defeitos
	  PORT MAP (
		 clk => C18MHZ_i,
		 we => '1',
		 a => s_cnt_ptr,
		 d => DEF_CNT_i,
		 qdpo_clk => C18MHZ_i,
		 qdpo_rst => s_RST_DEF_CNT,
		 dpra => s_rd_ptr, 
		 qdpo => DEF_CNT_o );
		 
	i_MEM_DEF_OUT : MEM_DEF_CNT_DIST --Memoria que armazena o valor total de ejeçoes
	  PORT MAP (
		 clk => C18MHZ_i,
		 we => s_TSTz,
		 a => s_rd_ptr,--CH_NUM_i,
		 d => DEF_CNT_i,
		 qdpo_clk => C18MHZ_i,
		 qdpo_rst => RST_i,
		 dpra => INT_CH_REQ_i,
		 qdpo => s_EJ_CNT_o );
		 
	EJ_CNT_o <= s_EJ_CNT_o;
		 

	i_EJ_CLEAR : EJ_CLEAR_COUNT
	 port map( 
		TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
	   C3KHZ_i => C3KHZ_i,
	   RST_i => RST_i,
	   CLEAR_CNT_o => s_CLEAR_CNT_o);
		
	s_is_ch0 <= '1' when (s_rd_ptr = "000000") else '0';
	s_is_ch32 <= '1' when (s_rd_ptr = "100000") else '0';
		
	-----------------------------------------------------------------------------------------------
	------------------------------------------ OVERUSAGE ------------------------------------------
	-----------------------------------------------------------------------------------------------
	-- Make this a block when there is enough time
	
	PROBE_o <= s_overusage_max & s_overusage(0) & s_overusage_int_a(0) & OVERUSAGE_CLR_A_i & s_overusage_a(0) & s_is_ch0 & s_is_ch32 & '0'; --"000";
		
	s_overusage_max <= '1' when (s_EJ_CNT_o > "0000101110111000") else '0';
	
	process(RST_i, C18MHZ_i, OVERUSAGE_CLR_A_i, OVERUSAGE_CLR_B_i, s_overusage_max)
	begin
		if rising_edge(C18MHZ_i) then
			if (RST_i = '1') then
				s_overusage <= (others=>'0');
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
	
	overusage: for i in 0 to 31 generate
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

	p_contador: process(C18MHZ_i, RST_i)
	begin
	
		if rising_edge(C18MHZ_i) then

			if (RST_i = '1') then
				s_rd_ptr <= "000000";
			
			else			
	
				s_rd_ptr <= s_rd_ptr + 1;
				s_cnt_ptr <= s_rd_ptr;
				
			end if;
		end if;
		
	end process;

	p_rst_cnt_mem: process(C18MHZ_i, RST_i, s_CLEAR_CNT_o)
	begin
	
		if rising_edge(C18MHZ_i) then

			if (RST_i = '1') then
				s_INT <= '0';
				s_CNTHERE <= "1111111";
			else			
				if (s_CLEAR_CNT_o = '1') then
					if (s_CNTHERE = "0000000") then
						s_INT <= '1'; -- sinal de enable da memoria de saída ( so atualiza quando o contador chega ao final )
					else
						s_INT <= '0';
						s_CNTHERE <= s_CNTHERE - 1;
					end if;
				else
					s_INT <= '0';
					s_CNTHERE <= "1111111";
				end if;
			end if;
		end if;
		
	end process;
	
end Behavioral;