library ieee	;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity accumulator is	
	generic (INPUT_WIDTH : integer := 32);
	
port (
	clk      :  in std_logic;
	aclr_n	 :  in std_logic;
	
	data_a_in : in std_logic_vector (INPUT_WIDTH-1 downto 0);
	data_b_in : in std_logic_vector (INPUT_WIDTH-1 downto 0);
	
	data_out : out std_logic_vector (INPUT_WIDTH-1 downto 0)
);
end accumulator;

architecture rtl of accumulator is
begin	
	process(clk, aclr_n)
		variable acc : std_logic_vector (INPUT_WIDTH-1 downto 0);
	begin
		if aclr_n = '0' then
			acc := (others => '0');
		else	
			if rising_edge (clk) then
				acc := acc + data_a_in + data_b_in;				
			end if;			
		end if;
		data_out <= acc;
	end process;
	
end rtl;
