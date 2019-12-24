
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity acumulador_tb is
	generic(
	palavra: integer:= 101;
	w: natural:=24);
end acumulador_tb;

architecture stimuli of acumulador_tb is
	constant clock_period: time:= 100 ns; -- 10 MHz
	signal clk			: std_logic; 
	signal phase_pulse	: std_logic;
	signal FCW: std_logic_vector(w-1 downto 0);
	signal phase_word: std_logic_vector(w-1 downto 0); 
	
begin
 
uut: entity work.acumulador(acc_arq) 
	generic map (w => w)
	port map (clk => clk, FCW => FCW, phase_pulse => phase_pulse, phase_word => phase_word);	
	
	 -- estimulo clock
	relogio: process
		begin
			clk <= '0';
			wait for clock_period/2;
			clk <= '1';
			wait for clock_period/2;
		end process relogio;  
			
			
	--count: process
--		variable i: unsigned(w-1 downto 0) := (others => '0');
--			begin
--				FCW <= std_logic_vector(i); 
--				i := i + 1 ;
--				wait for 100*clock_period; 
--		end process count;

FCW <= std_logic_vector(to_unsigned(palavra,w));	
				  
end stimuli;
