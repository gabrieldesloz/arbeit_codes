--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:32:36 10/24/2012
-- Design Name:   
-- Module Name:   D:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V016/TB_WRAPPER_VALVE_FAIL.vhd
-- Project Name:  EJECTORS_V016
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WRAPPER_VALVE_FAIL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_WRAPPER_VALVE_FAIL IS
END TB_WRAPPER_VALVE_FAIL;
 
ARCHITECTURE behavior OF TB_WRAPPER_VALVE_FAIL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WRAPPER_VALVE_FAIL
    PORT(
         VALVE_i : IN  std_logic_vector(31 downto 0);
         SENS_i : IN  std_logic_vector(31 downto 0);
         C10MHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
         PROBE_o : OUT  std_logic_vector(2 downto 0);
         FUSE_o : OUT  std_logic_vector(31 downto 0);
	 VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);
	 clock2MHz_i: in std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal VALVE_i : std_logic_vector(31 downto 0) := (others => '0');
   signal SENS_i : std_logic_vector(31 downto 0) := (others => '1');
   signal C10MHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal PROBE_o : std_logic_vector(2 downto 0);
   signal FUSE_o : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant C10MHZ_i_period : time := 100 ns;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WRAPPER_VALVE_FAIL PORT MAP (
          VALVE_i => VALVE_i,
          SENS_i => SENS_i,
          C10MHZ_i => C10MHZ_i,
          RST_i => RST_i,
          PROBE_o => PROBE_o,
          FUSE_o => FUSE_o,
		VALVE_LIMITER_i => (others => '0'),
		clock2MHz_i => '0'
        );

   -- Clock process definitions
   C10MHZ_i_process :process
   begin
		C10MHZ_i <= '0';
		wait for C10MHZ_i_period/2;
		C10MHZ_i <= '1';
		wait for C10MHZ_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 500 ns;	
		RST_i <= '0';
		wait for 1000 ns;	
		VALVE_i(31) <= '1';
		wait for 750 us;	
		VALVE_i(31) <= '0';
		wait for 100 ns;	
		SENS_i(31) <= '0';
		wait for 18 us;	
		SENS_i(31) <= '1';
		VALVE_i(31) <= '0';		
      wait for C10MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

   
   bloco: block is
		signal sens: std_logic_vector(31 downto 0);	
		signal sens_tmp: std_logic_vector(31 downto 0);	
		signal sens_tmp_next: std_logic_vector(31 downto 0);	
		signal sens_tmp_reg: std_logic_vector(31 downto 0);	
	
	begin	
	    
		sens <= (others => '1');	  
	   
	   
	   
	   e1: process(C10MHZ_i, RST_i)
			
			begin 
				
				if RST_i = '1' then 
					sens_tmp_reg <= (others => '0');
				elsif rising_edge(C10MHZ_i) then 
					sens_tmp_reg <= sens_tmp_next;
				end if;
		
		end process;	   
	   
	   
	   
	    e2: process(C10MHZ_i, RST_i)
				
				variable state: std_logic;
				variable counter: std_logic_vector(31 downto 0);			
				variable value: std_logic_vector(31 downto 0);
				
			begin
			
			
		
				sens_tmp_next <= sens_tmp_reg;
				
					
			
				
				if RST_i = '1' then 
				
					state := '0';
					counter := (others => '0');
					value := (others => '0');
				
				elsif rising_edge(C10MHZ_i) then 
						
					state := state;
					counter := counter;
					value := value;
					
					case state is		
					
						when '0' =>					
						
						  value := (others => '0');
									
						  for i in 31 downto 0 loop
							 sens_tmp_next(i) <= sens(i) xor value(i);
						  end loop;	   
						
									
							
							if counter = 20_000 then -- 1 s 
								state := '1';
								counter := (others => '0');
							else 
								counter	:= counter + '1';
								state 	:= '0';
							end if;		
							
							
						when '1' => 
								
						  value := (others => '1');
									
						  for i in 31 downto 0 loop
							 sens_tmp_next(i) <= sens(i) xor value(i);
						  end loop;	 				
							
							if counter = 20_000 then -- 1 s 
								state := '0';
								counter := (others => '0');
							else 
								counter	:= counter + '1';
								state 	:= '1';
							end if;		
						
						when others => null;	
					end case;
				end if;
			end process;
    end block; 
    
   
END;
