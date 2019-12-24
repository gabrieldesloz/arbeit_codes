
library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


entity IN_REG is
  port (
    CLK_i 	 	 	 : in  std_logic;         
    CLK_i_pulse 	 : in  std_logic;              
    RESET_i 	 	 : in  std_logic;
	PROTO_o      	 : out std_logic;
    VALVE_I		 	 : in std_logic_vector(31 downto 0);
	VALVE_O       	 : out std_logic_vector(31 downto 0)
    );

end IN_REG;

architecture behavorial of IN_REG is

signal valve_i_reg, valve_i_reg2, valve_i_next, valve_i_next2: std_logic_vector(31 downto 0);
signal s_enable: std_logic;

begin


registers : process (CLK_i, RESET_i, s_enable)  -- 1MHz
  begin
    
	if (RESET_i = '1') then

	valve_i_reg <= (others => '0');
	valve_i_reg2 <= (others => '0');
	  
	elsif rising_edge(CLK_i) then
		
      if s_enable = '1' then 	  
	  
		  valve_i_reg <= valve_i_next;
		  valve_i_reg2 <= valve_i_next2;
		  
	  end if;	  
    end if;
  end process registers;
  
	  valve_i_next <= VALVE_I;
	  valve_i_next2 <= valve_i_reg;
	  VALVE_O <= valve_i_reg2;  
	  s_enable <= CLK_i_pulse;
  
  end architecture;
  
  