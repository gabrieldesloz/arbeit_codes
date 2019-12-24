library ieee	;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is	
	generic (ADDR_BUS : integer := 16;
			N_SAMPLES : integer := 40
	);
	
port (
	clk      : in std_logic;
	aclr_n	 :  in std_logic;
	preset : in  std_logic_vector (ADDR_BUS-1 downto 0);
	input_in : in std_logic_vector (ADDR_BUS-1 downto 0);
	count_out : out std_logic_vector (ADDR_BUS-1 downto 0)
);
end counter;

architecture counter_beh of counter is
begin	
	process(clk, aclr_n)
		variable count : std_logic_vector (ADDR_BUS-1 downto 0);
	begin
		if aclr_n = '0' then
			count := preset;
		else	
			if rising_edge (clk) then
				count := count + 1;				
			end if;			
		end if;
		count_out <= count;
	end process;
	
end counter_beh;
