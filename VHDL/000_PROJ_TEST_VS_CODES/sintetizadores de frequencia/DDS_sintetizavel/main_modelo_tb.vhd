
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity main_modelo_tb is
	generic(
	frequency_word			: natural   := 4194;
	largura_ac				: natural 	:= 24;
	largura_sen_rom 		: natural 	:= 10;
	tabela_seno				: string  	:= "full_sin.txt"; 
	largura_pwm				: natural	:= 10; 
	divisao_freq			: natural   := 10 
	
	);
end main_modelo_tb;

architecture stimuli of main_modelo_tb is  
									 
constant clock_period: time:= 10 ns;   --> main clock -> 100E6 Hz

signal reset:			  std_logic	:='0';
signal clk: 			  std_logic :='0';
signal FCW: 			  std_logic_vector(largura_ac-1 downto 0) 	:= (others => '0'); 
signal to_filter:	 	  std_logic :='0';
signal to_filter_dac:	  std_logic :='0';
	
begin
 
uut: entity work.main_modelo(teste_arq) 
	generic map (
	largura_ac => largura_ac, 
	largura_sen_rom => largura_sen_rom,
	tabela_seno => tabela_seno,
	largura_pwm => largura_pwm,
	divisao_freq => divisao_freq)
	port map (
	reset => reset,
	clk => clk,
	FCW => FCW,
	to_filter => to_filter,
	to_filter_dac => to_filter_dac
	);	
	
	 -- estimulo clock
	relogio: process
		begin
			clk <= '0';
			wait for clock_period/2;
			clk <= '1';
			wait for clock_period/2;
		end process relogio;  
			
		
FCW <= std_logic_vector(to_unsigned(frequency_word,largura_ac));	
reset <= '0';


end stimuli;
