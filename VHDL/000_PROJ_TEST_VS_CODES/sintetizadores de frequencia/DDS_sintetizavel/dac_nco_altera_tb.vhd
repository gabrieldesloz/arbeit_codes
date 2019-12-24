library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity dac_nco_altera_tb is	
end dac_nco_altera_tb;

architecture stimuli of dac_nco_altera_tb is
	constant clock_period: 			time:= 20 ns;
	constant clock_stim_period: 	time:= 1  ms;	
	signal clock_stim: std_logic;
	signal clock_50: std_logic;
	signal SW: std_logic_vector(9 downto 0);
	signal GPIO_0:  std_logic_vector(4 DOWNTO 0);
	--signal LEDG: std_logic_vector(8 downto 8);
	--signal LEDR: std_logic_vector(0 downto 0);
	
	
	component dac_nco_altera is 	
		port (
			clock_50: in std_logic;
			SW: in std_logic_vector(9 downto 0);
			GPIO_0 : out std_logic_vector(4 DOWNTO 0)
			--LEDG: out std_logic_vector(8 downto 8);
			--LEDR: OUT std_logic_vector(0 downto 0)
		);	
	end component;	 
		
	
	begin
	
	A1: dac_nco_altera 		
		port map (clock_50,SW,GPIO_0);
	
	relogio: process
	begin
		clock_50 <= '0';
		wait for clock_period/2;
		clock_50 <= '1';
		wait for clock_period/2;
	end process relogio;  
	
	
	stim: process
	begin
		clock_stim <= '0';
		wait for clock_stim_period/2;
		clock_stim <= '1';
		wait for clock_stim_period/2;
	end process stim;  
	
	
	estimulo: process(clock_stim)
		variable i: unsigned(9 downto 0) := (others => '0');
			begin
				SW <= std_logic_vector(i); 
				i := i + 10 ;				
		end process estimulo;
	
end stimuli;


