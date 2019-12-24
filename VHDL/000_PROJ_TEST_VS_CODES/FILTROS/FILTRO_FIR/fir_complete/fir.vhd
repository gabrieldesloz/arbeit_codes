library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fir is
	generic (ADDR_BUS : integer := 16;
			DATA_BUS : integer := 16;
			COEF_BIT : integer := 16;			
			N_COEF : integer := 6;			
			N_SAMPLES : integer := 40
	);
	
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		en_in : std_logic;
		
		b0_in : in std_logic_vector(COEF_BIT-1 downto 0);
		b1_in : in std_logic_vector(COEF_BIT-1 downto 0);
		b2_in : in std_logic_vector(COEF_BIT-1 downto 0);
		b3_in : in std_logic_vector(COEF_BIT-1 downto 0);
		b4_in : in std_logic_vector(COEF_BIT-1 downto 0);
		b5_in : in std_logic_vector(COEF_BIT-1 downto 0);
		
		data_in : in std_logic_vector(DATA_BUS-1 downto 0);		
		addr_out : buffer std_logic_vector (ADDR_BUS-1 downto 0);
				
		y_out : out std_logic_vector(DATA_BUS-1 downto 0);
		valid_out : out std_logic;
		done_out : out std_logic	
	);
end entity fir;

architecture RTL of fir is
	
	component fir_control
	port (
		clk : in std_logic;
		rst : in std_logic;
		en_in  : in std_logic;
		
		coef_ld_out : out std_logic;
		acc_en_out : out std_logic;
		addr_en_out : out std_logic;
		
		valid_out : out std_logic;
		done_out : out std_logic	
	);
	end component;
	
	component counter
	port (
		clk, aclr_n : in std_logic;
		preset : in  std_logic_vector (ADDR_BUS-1 downto 0);
		input_in : in std_logic_vector (ADDR_BUS-1 downto 0);
		count_out : out std_logic_vector (ADDR_BUS-1 downto 0)
	);
	end component counter;
	
	component mult
	port (
		clk : in std_logic;
		rst : in std_logic;
		dataa : in std_logic_vector (DATA_BUS-1 downto 0);
		datab : in std_logic_vector (DATA_BUS-1 downto 0);
		product   : out std_logic_vector (2*DATA_BUS-1 downto 0)
	);
	end component;
			
	signal addr_en : std_logic;
	signal acc_en : std_logic;
	signal coef_ld : std_logic;
		
	type coef_type is array (0 to N_COEF-1) of std_logic_vector (COEF_BIT-1 downto 0);
	type mul_type is array (0 to N_COEF-1) of std_logic_vector (2*DATA_BUS-1 downto 0);
	type acc_type is array (0 to N_COEF-1) of std_logic_vector (2*DATA_BUS-1 downto 0);
	
	signal coef_array : coef_type;
	signal mul_array : mul_type;
	signal acc_array : acc_type;
	
	signal y :  std_logic_vector (2*DATA_BUS-1 downto 0);
		
begin
	
	controller: fir_control port map(
		clk => clk,
		rst => rst,
		en_in => en_in,
		
		coef_ld_out => coef_ld,
		acc_en_out => acc_en,
		addr_en_out => addr_en,
		
		valid_out => valid_out,
		done_out => done_out
	);
	
	counter_1 : counter 
		port map (
			clk => clk, 
			aclr_n => addr_en, 
			input_in => x"0000",
			preset => x"0000",
			count_out => addr_out
	);
	
	coef_array(0) <= b5_in;
	coef_array(1) <= b4_in;
	coef_array(2) <= b3_in;
	coef_array(3) <= b2_in;
	coef_array(4) <= b1_in;
	coef_array(5) <= b0_in;	
	
	
	-- latch ativo quando acc_en = '1' 
	sum_of_products: process(clk)
	begin
		if rising_edge(clk) then			
			
			if acc_en = '1' then			
				for i in 0 to N_COEF-2 loop
					acc_array(i) <= mul_array(i) + acc_array(i+1);
				end loop;
				
				acc_array(N_COEF-1) <= mul_array(N_COEF-1);
			
			end if;		
		y <= acc_array(0);
		end if;				
	end process;
	

    -- block multiplicador -- pega os coeficientes e multiplica pelo conteudo da memoria ram
	-- bloco funcional em vhdl
	mult_gen: for i in 0 to N_COEF-1 generate
	muls: mult
		port map (
			clk => clk,
			rst => rst,
			dataa => coef_array(i),
			datab => data_in,
			product => mul_array(i)		
		);
	end generate;
	
	y_out <= y(2*DATA_BUS-2 downto DATA_BUS-1);

end architecture RTL;
