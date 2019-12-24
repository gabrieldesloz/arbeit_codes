--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:04:00 08/29/2014
-- Design Name:   
-- Module Name:   M:/vhdl/clocking mono/xilinx/clocking_test/tb_clock_gen.vhd
-- Project Name:  clocking_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_gen
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_clock_gen IS
END tb_clock_gen;
 
ARCHITECTURE behavior OF tb_clock_gen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_gen
    PORT(
         dcmrst_i : IN  std_logic;
         CLK37mux_i : IN  std_logic;
         clkaq_o : OUT  std_logic;
         clk2x_o : OUT  std_logic;
         clkx_o : OUT  std_logic;
         clkz_o : OUT  std_logic;
         c1us_o : OUT  std_logic;
		 adc1_sclk_o: out std_logic;
		 adc2_sclk_o: out std_logic;
		 clka_o: out std_logic;   
         clkab_o: out std_logic  
        );
    END COMPONENT;
    

   --Inputs
   signal dcmrst_i : std_logic := '0';
   signal CLK37mux_i : std_logic := '0';

 	--Outputs
   signal clkaq_o : std_logic;
   signal clk2x_o : std_logic;
   signal clkx_o : std_logic;
   signal clkz_o : std_logic;
   signal c1us_o : std_logic;
   signal adc1_sclk_o : std_logic;
   signal adc2_sclk_o : std_logic;
   signal clka_o : std_logic;   
   signal clkab_o : std_logic;  
   

   -- Clock period definitions
   constant CLK37mux_i_period : time := 27 ns;
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_gen PORT MAP (
          dcmrst_i => dcmrst_i,
          CLK37mux_i => CLK37mux_i,
          
		  
		  clkaq_o => clkaq_o,
          clk2x_o => clk2x_o,
          clkx_o => clkx_o,
          clkz_o => clkz_o,
          c1us_o => c1us_o,
		  adc1_sclk_o => adc1_sclk_o,
		  adc2_sclk_o => adc2_sclk_o,		  
		  clka_o 	=> clka_o,   
		  clkab_o 	=> clkab_o  
        );

   -- Clock process definitions
   CLK37mux_i_process :process
   begin
		CLK37mux_i <= '0';
		wait for CLK37mux_i_period/2;
		CLK37mux_i <= '1';
		wait for CLK37mux_i_period/2;
   end process;
 
 
 
   -- Stimulus process
   stim_proc: process
   begin
	  dcmrst_i <= '1';
      wait for 100 ns;	
	  wait until CLK37mux_i = '1'; 
      dcmrst_i <= '0'; 
      wait for 800 ns;
	  dcmrst_i <= '1';
	  wait for 100 ns;	
	  wait until CLK37mux_i = '1';   
  	  dcmrst_i <= '0';
      wait;
   end process;

END;
