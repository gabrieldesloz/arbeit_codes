--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:58:50 05/21/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V02/TB_SERIAL_TX.vhd
-- Project Name:  TEST_RIG_FPGA_1_V02
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SERIAL_TX
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
 
ENTITY TB_SERIAL_TX IS
END TB_SERIAL_TX;
 
ARCHITECTURE behavior OF TB_SERIAL_TX IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SERIAL_TX
    PORT(
         TX_DATA_i : IN  std_logic_vector(7 downto 0);
         SEND_i : IN  std_logic;
         BAUD_CLK_i : IN  std_logic;
         RST_i : IN  std_logic;
         PACKET_SENT_o : OUT  std_logic;
         TX_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal TX_DATA_i : std_logic_vector(7 downto 0) := (others => '0');
   signal SEND_i : std_logic := '0';
   signal BAUD_CLK_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal PACKET_SENT_o : std_logic;
   signal TX_o : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant BAUD_CLK_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SERIAL_TX PORT MAP (
          TX_DATA_i => TX_DATA_i,
          SEND_i => SEND_i,
          BAUD_CLK_i => BAUD_CLK_i,
          RST_i => RST_i,
          PACKET_SENT_o => PACKET_SENT_o,
          TX_o => TX_o
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
		TX_DATA_i <= "10101010";
		wait for 100 ns;
		SEND_i <= '1';
		wait for 1 ns;
		SEND_i <= '0';

      wait for BAUD_CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
