library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
  generic
  (
		n: natural:= 6;
		p: natural:= 8
  );  
  
  port(
    clock   	: in     std_logic;
    reset 		: in     std_logic;
    enable		: in     std_logic;
    cin   		: in     std_logic;
    d     		: in     std_logic_vector(n-1 downto 0);
    e       	: in     std_logic_vector(p-1 downto 0);	
	reg_q   	: out    std_logic_vector(p-1 downto 0);     
    reg_cout 	: out    std_logic);

end entity accumulator ;

architecture rtl of accumulator is	
  -- signal with p+1 bits for storing the carry signal
  signal tmp_int : unsigned(p downto 0);
  -- signal for storing the registered bus output
  signal reg_int : unsigned(p-1 downto 0);
  										   
begin   	
	-- adding the input signals
  	tmp_int <= resize(unsigned(reg_int),p+1)+ resize(unsigned(d),p+1) 
				+ resize(unsigned(e),p+1) + unsigned'(0 => cin); 	
	 -- synchronous logic
  process(clock,reset,enable)
	  begin			
		if reset = '0' then 
			reg_int <= (others => '0');
	        reg_cout 	<= '0';	 	
		    elsif rising_edge(clock) then		      
			  reg_cout <= '0';	
			  if enable = '1' then         
		          reg_int <= tmp_int(p-1 downto 0);
		          reg_cout <= tmp_int(p);
		      end if;
	      end if;        
  end process;
    -- reg bus output   
  reg_q <= std_logic_vector(reg_int);
  
  
 

end architecture rtl ; 






