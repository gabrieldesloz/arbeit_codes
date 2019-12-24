library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

entity testbench is
	generic (ADDR_BUS : integer := 16;    --- barramento endereço, 16 bits = 2^16 endereços
			DATA_BUS : integer := 16;     --- barramento dados 16 bits  
			COEF_BIT : integer := 16;     --- 16 bits coeficiente   
			N_SAMPLES : integer := 40     --- numero de amostras = 40    
	);
end entity testbench;

architecture RTL of testbench is
	
	
	--- componente memoria
	component input_ram
	port
	(
		address		: in std_logic_vector (15 downto 0);
		clock		: in std_logic  := '1';
		data		: in std_logic_vector (15 downto 0);
		wren		: in std_logic ;
		q		: out std_logic_vector (15 downto 0)
	);
	end component;
    
	
	--- componente filtro fir
	component fir
	port
	(
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
		addr_out : out std_logic_vector (ADDR_BUS-1 downto 0);
		y_out : out std_logic_vector(DATA_BUS-1 downto 0);
		
		valid_out : out std_logic;
		done_out : out std_logic	
	);
	end component;
	
	-- input audio signals
	signal address : std_logic_vector (ADDR_BUS-1 downto 0); --- barramento/sinal  endereço
	signal data : std_logic_vector (DATA_BUS-1 DOWNTO 0);    --- barramento de dados  
	signal filtered : std_logic_vector(DATA_BUS-1 downto 0); --- sinais filtrados	
	
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal en  : std_logic := '1';
	signal done : std_logic;
	signal valid : std_logic;
	
begin
	

	--- gerador do relogio periodo 20 ns = 50 MHz 	
	clk_p: process 
	begin
		wait for 10ns;
		clk <= '1';
		wait for 10ns;
		clk <= '0';
	end process;
	
	
	--- gerador do sinal de resert
	rst_p: process
	begin
		wait for 9ns;
		rst <= '0';
		wait;	
	end process;
	
	
	--- aplica (zera) o sinal de "enable" no filtro fir após 30 ns
	en <= '0' after 30 ns;
	
	--- instanciamento da memoria com o arquivo de audio
	audio_ram : input_ram PORT MAP (
		address => address,
		clock => clk,
		data => (others => '0'),
		wren => '0',
		q	=> data
	);
	

	-- instanciamento do filtro fir 	
	fir_1 : fir port map(
		clk => clk,
		rst => rst,
		en_in => en,
		
		
		--- entrada dos coeficientes das equações
		--- Media movel q15 => (1 / 6 * 32768)d -> 1555h  --- 6 etapas transformadas no formato de representação 
														   --- ponto flutuante
		--- 6 coeficientes
		b0_in => x"1555",
		b1_in => x"1555",
		b2_in => x"1555",
		b3_in => x"1555",
		b4_in => x"1555",
		b5_in => x"1555",		
		
		data_in => data,			
		addr_out => address,
		y_out => filtered,
		valid_out => valid,
		done_out => done 
	);
	
	print: process (valid, filtered)
		variable my_line : line; 
		variable samples : integer := 0;
		
		alias swrite is write [line, string, side, width];
		
		file my_output : TEXT open WRITE_MODE is "filtrado.txt";
	begin
		 if valid = '1' then		 
			--swrite(my_line, "data=");	
			--hwrite(my_line, samples);
			--hwrite(my_line, " : ");
			hwrite(my_line, filtered);		-- needs use IEEE.std_logic_textio.all;
			writeline(my_output, my_line);	-- needs use STD.textio.all;
			
			samples := samples + 1;
			
			if samples = 40005 then
				assert false report "End of simulation" severity failure;
			end if;
			
			
		end if;
	end process;
		

end architecture RTL;
