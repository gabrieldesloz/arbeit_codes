library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity mult is
	generic ( WORD_SIZE : integer := 16	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		dataa : in std_logic_vector (WORD_SIZE-1 downto 0);
		datab : in std_logic_vector (WORD_SIZE-1 downto 0);
		product   : out std_logic_vector (2*WORD_SIZE-1 downto 0)
	);
end mult;

architecture logic of mult is
begin
	
	process (clk, rst)
	begin
		if rst = '1' then
			product <= (others => '0');
		else
			if rising_edge(clk) then
				product <= dataa * datab;
			end if;
		end if;
	end process;
	
end logic;
