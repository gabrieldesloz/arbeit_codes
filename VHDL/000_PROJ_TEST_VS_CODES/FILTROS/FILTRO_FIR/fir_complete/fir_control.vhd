library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_control is
	
	generic (
		N_SAMPLES : integer := 40;
		N_COEF : integer := 6
	);
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		en_in  : in std_logic;
		
		coef_ld_out : out std_logic;
		acc_en_out : out std_logic;
		addr_en_out : out std_logic;
		
		valid_out : out std_logic;
		done_out : out std_logic
				
	);
end entity fir_control;

architecture RTL of fir_control is
	type state_type is (IDLE, INIT, MEM_RD, ACC);
	
  signal filter : state_type;
  signal samples : integer range 0 to (N_SAMPLES+ N_COEF + 1);
	
begin

	state_p : process(rst, clk)
	begin
		if rst = '1' then
			filter <= IDLE;
			samples <= 0;
		
		elsif rising_edge(clk) then	
			case filter is
				when IDLE =>
					samples <= 0;
					if en_in = '1' then
						filter <= INIT;
					else
						filter <= IDLE;
					end if;
				when INIT => 	
					filter <= MEM_RD;
				when MEM_RD =>
					filter <= ACC;
				when ACC =>	
					samples <= samples + 1;				
					
					if (samples >= N_SAMPLES + N_COEF) then
						filter <= IDLE;
					else
						filter <= ACC;
					end if;					
			end case;
		end if;
	end process;
	
	output_p : process(filter)
	begin
		coef_ld_out <= '0';
		acc_en_out <= '0';
		addr_en_out <= '0';
				
		case filter is
			when IDLE =>
			
			when INIT =>
				coef_ld_out <= '1';
				addr_en_out <= '1';							
			when MEM_RD =>
				addr_en_out <= '1';
				acc_en_out <= '0';								
			when ACC =>
				addr_en_out <= '1';
				acc_en_out <= '1';
		end case;		
	end process;
	
	-- wait to pipeline be filled
	valid_out <= '1' when (samples > (N_COEF + 1)) else '0';
	done_out <= '1' when (samples > N_SAMPLES + N_COEF) else '0';
	
end architecture RTL;
