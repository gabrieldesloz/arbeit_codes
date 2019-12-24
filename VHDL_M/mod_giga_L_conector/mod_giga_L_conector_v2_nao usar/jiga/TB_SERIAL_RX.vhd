--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:09:27 05/21/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V02/TB_SERIAL_RX.vhd
-- Project Name:  TEST_RIG_FPGA_1_V02
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SERIAL_RX
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
 
ENTITY TB_SERIAL_RX IS
END TB_SERIAL_RX;
 
ARCHITECTURE behavior OF TB_SERIAL_RX IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SERIAL_RX
    PORT(
         RX_i : IN  std_logic;
         BAUD_CLK_i : IN  std_logic;
         RST_i : IN  std_logic;
         FAIL_o : OUT  std_logic;
         PACKET_READY_o : OUT  std_logic;
         RX_DATA_o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RX_i : std_logic := '1';
   signal BAUD_CLK_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal FAIL_o : std_logic;
   signal PACKET_READY_o : std_logic;
   signal RX_DATA_o : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant BAUD_CLK_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SERIAL_RX PORT MAP (
          RX_i => RX_i,
          BAUD_CLK_i => BAUD_CLK_i,
          RST_i => RST_i,
          FAIL_o => FAIL_o,
          PACKET_READY_o => PACKET_READY_o,
          RX_DATA_o => RX_DATA_o
        );

   -- Clock process definitions
   BAUD_CLK_i_process :process
   begin
		BAUD_CLK_i <= '0';
		wait for BAUD_CLK_i_period/2;
		BAUD_CLK_i <= '1';
		wait for BAUD_CLK_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';
		wait for 10 ns;
		RX_i <= '0'; 	-- Init bit
		wait for 1 ns;
		RX_i <= '1';	-- Bit 0
		wait for 1 ns;
		RX_i <= '0';	-- Bit 1
		wait for 1 ns;
		RX_i <= '1';	-- Bit 2
		wait for 1 ns;
		RX_i <= '0';	-- Bit 3
		wait for 1 ns;
		RX_i <= '1';	-- Bit 4
		wait for 1 ns;
		RX_i <= '0';	-- Bit 5
		wait for 1 ns;
		RX_i <= '1';	-- Bit 6
		wait for 1 ns;
		RX_i <= '0';	-- Bit 7
		wait for 1 ns;
		RX_i <= '1';	-- Parity
		wait for 1 ns;
		RX_i <= '0';	-- End bit
		wait for 1 ns;
		RX_i <= '1';
		wait for 1 ns;

      wait for BAUD_CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
