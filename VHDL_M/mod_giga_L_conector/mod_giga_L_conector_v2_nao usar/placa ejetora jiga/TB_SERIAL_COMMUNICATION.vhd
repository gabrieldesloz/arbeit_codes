--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:45:39 03/25/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Ejector_Board/EJECTORS_TEST_V01/TB_SERIAL_COMMUNICATION.vhd
-- Project Name:  EJECTORS_TEST_V01
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SERIAL_COMMUNICATION
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
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--
--package my_types_pkg is		-- Creates a type to use arrays in the entity declaration
--	type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
--end package;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.my_types_pkg.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_SERIAL_COMMUNICATION IS
END TB_SERIAL_COMMUNICATION;
 
ARCHITECTURE behavior OF TB_SERIAL_COMMUNICATION IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SERIAL_COMMUNICATION
    PORT(
         SEND_DATA_MASTER_i : IN  input_array;
         SEND_DATA_SLAVE_i : IN  input_array;
			
         CLK_i : in STD_LOGIC;
         RST_i : IN  std_logic;
			
         RECEIVED_DATA_SLAVE_o : OUT  input_array;
         RECEIVED_DATA_MASTER_o : OUT  input_array
        );
    END COMPONENT;
    
	 type input_array_tst is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type

   --Inputs
   signal SEND_DATA_MASTER_i : input_array;
   signal SEND_DATA_SLAVE_i : input_array;
   signal CLK_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal RECEIVED_DATA_SLAVE_o : input_array;
   signal RECEIVED_DATA_MASTER_o : input_array;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CLK_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SERIAL_COMMUNICATION PORT MAP (
          SEND_DATA_MASTER_i => SEND_DATA_MASTER_i,
          SEND_DATA_SLAVE_i => SEND_DATA_SLAVE_i,
          CLK_i => CLK_i,
          RST_i => RST_i,
          RECEIVED_DATA_SLAVE_o => RECEIVED_DATA_SLAVE_o,
          RECEIVED_DATA_MASTER_o => RECEIVED_DATA_MASTER_o
        );

   -- Clock process definitions
   CLK_i_process :process
   begin
		CLK_i <= '0';
		wait for CLK_i_period/2;
		CLK_i <= '1';
		wait for CLK_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
		SEND_DATA_MASTER_i(0) <= (others => '0');
		SEND_DATA_MASTER_i(1) <= (others => '0');
		SEND_DATA_MASTER_i(2) <= (others => '0');
		SEND_DATA_MASTER_i(3) <= (others => '0');
		SEND_DATA_MASTER_i(4) <= (others => '0');
		SEND_DATA_MASTER_i(5) <= (others => '0');
		SEND_DATA_MASTER_i(6) <= (others => '0');
		SEND_DATA_MASTER_i(7) <= (others => '0');
		
		SEND_DATA_SLAVE_i(0) <= (others => '0');
		SEND_DATA_SLAVE_i(1) <= (others => '0');
		SEND_DATA_SLAVE_i(2) <= (others => '0');
		SEND_DATA_SLAVE_i(3) <= (others => '0');
		SEND_DATA_SLAVE_i(4) <= (others => '0');
		SEND_DATA_SLAVE_i(5) <= (others => '0');
		SEND_DATA_SLAVE_i(6) <= (others => '0');
		SEND_DATA_SLAVE_i(7) <= (others => '0');
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';

      wait for CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
