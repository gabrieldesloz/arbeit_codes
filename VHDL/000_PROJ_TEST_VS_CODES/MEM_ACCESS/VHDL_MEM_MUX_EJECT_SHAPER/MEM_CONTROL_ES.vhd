library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

			
entity MEM_CONTROL_ES is
    
	Port (	
			CLK_i : in std_logic; 
			RST_i : in std_logic;
			FSM_STATE_o: out std_logic_vector(3 downto 0);
			FSM_STATE_i: in std_logic_vector(3 downto 0);			
			FLAG_FINISH_o: out std_logic;
			FLAG_FINISH_i: in std_logic;
			VALV_COUNTER_o: out std_logic_vector(12 downto 0);
			VALV_COUNTER_i: in std_logic_vector(12 downto 0);
			PWM_COUNTER_o: out std_logic_vector(6 downto 0);
			PWM_COUNTER_i: in std_logic_vector(6 downto 0);
			CURRENT_VALVE_o: out std_logic_vector(4 downto 0)
			);
			
end entity MEM_CONTROL_ES;



architecture Behavioral of MEM_CONTROL_ES is
	signal s_valve, s_last_valve : std_logic_vector(3 downto 0); -- 16 valvulas
	signal s_mem_in, s_mem_out : std_logic_vector(31 downto 0);

			
	signal ss_valve: std_logic_vector(4 downto 0);
	signal ss_last_valve: std_logic_vector(4 downto 0);


COMPONENT MEM_32x32
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
	
	
begin

	
	s_mem_in 			<= 	FLAG_FINISH_i & FSM_STATE_i  &  "0000000"  &     PWM_COUNTER_i &  VALV_COUNTER_i; -- 32 bits  
	
	
	FLAG_FINISH_o 		<= s_mem_out(31);
	FSM_STATE_o 		<= s_mem_out(30 downto 27);
	PWM_COUNTER_o		<= s_mem_out(19 downto 13);
	VALV_COUNTER_o		<= s_mem_out(12 downto 0);



CURRENT_VALVE_o <= '0' & s_valve;	

	process(RST_i, CLK_i)
	begin
		if rising_edge(CLK_i) then				
			if (RST_i = '1') then					
				s_valve 	 <= (others => '0');	
				s_last_valve <= (others => '0');	
			else									
				s_valve <= s_valve + 1;				
				s_last_valve <= s_valve;			 
			end if;
		end if;
	end process;

-------------------------------------------------
-------------- 32x32 Counter Memory -------------
-------------------------------------------------
	
	COUNTER_MEM_32x32 : MEM_32x32
	  PORT MAP (	
		 clka => CLK_i,								
		 wea => "1",									
		 addra => ss_last_valve,						
		 dina => s_mem_in,							
		 clkb => CLK_i,								
		 addrb => ss_valve,							
		 doutb => s_mem_out							
	  );
-------------------------------------------------

ss_last_valve <= '0' & s_last_valve;
ss_valve <= '0' & s_valve;


end Behavioral;