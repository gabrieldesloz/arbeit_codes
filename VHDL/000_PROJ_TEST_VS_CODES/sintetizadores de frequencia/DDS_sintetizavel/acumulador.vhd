library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity acumulador is
  
generic (
	w: natural:= 32
);

port (
   clk : in std_logic;
   FCW : in std_logic_vector(w-1 downto 0);
   phase_pulse : out std_logic;
   phase_word: out std_logic_vector(w-1 downto 0)  
   
  );
end acumulador;

architecture acc_arq of acumulador is

	signal acc  	   : unsigned(w downto 0)			:=(others => '0');
	signal FCW_ext	   : unsigned(w downto 0)			:=(others => '0'); 
												  	
begin
		
	FCW_ext <= unsigned('0' & FCW);
	
process(clk, FCW_ext)
  begin
    if rising_edge(clk) then      	
		acc <=  acc + FCW_ext;
    end if;
  end process;

  phase_pulse <= acc(w);
  phase_word  <= std_logic_vector(acc(w-1 downto 0));
  
end acc_arq;
