library ieee	;
use ieee.std_logic_1164.all;

entity reg is
	generic (WORD_SIZE : integer := 32	);	
	port (
		clk       : in std_logic;
		aclr    : in std_logic;
		datain    : in std_logic_vector (WORD_SIZE-1 downto 0);
		reg_out   : out std_logic_vector (WORD_SIZE-1 downto 0)
	);
end reg;

architecture rtl of reg is
begin	
	process(clk, aclr)
	begin
		if aclr = '1' then
			reg_out <=  (others => '0');
		else
			if rising_edge (clk) then
				reg_out <= datain;
			end if;	
		end if;
	end process;
end rtl;