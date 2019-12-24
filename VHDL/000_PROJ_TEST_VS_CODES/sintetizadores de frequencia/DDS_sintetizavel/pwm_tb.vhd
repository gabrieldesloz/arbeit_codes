library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
	generic(
		palavra		: natural:=800; 
		r			: natural:=10);
end pwm_tb;

architecture stimuli of pwm_tb is
	constant clock_period: time:= 20 ns; 
	signal start		: std_logic:= '0'; 
	signal stop			: std_logic:= '0'; 
	signal reset		: std_logic:= '0'; 
	signal clk			: std_logic:= '0'; 
	signal d			: std_logic_vector(r-1 downto 0);
	signal pwm_out		: std_logic;
	signal pwm_reg_out	: std_logic;  	
begin
	
	uut: entity work.pwm(PWM_arq) 
	generic map (r)
	port map (
	start,
	stop,
	reset,
	clk,
	d,
	pwm_out,
	pwm_reg_out
	);	
	
	-- estimulo clock
	relogio: process
	begin
		clk <= '0';
		wait for clock_period/2;
		clk <= '1';
		wait for clock_period/2;
	end process relogio;  
	
	
	stim_start:process			
	begin
		start <= '1';			
		wait for 30 ns;
		start <= '0';	
		wait for 60 us; 
		stop <= '1';
		wait for 30 ns;
		stop <= '0';
		wait for 30 us; 		
	end process stim_start ; 	
	

	
	--stop <= '0';
	d <= std_logic_vector(to_unsigned(palavra,r));	
	reset <= '0';
	
	
end stimuli;

