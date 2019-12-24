--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:35:17 07/22/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V05/TB_SERIAL_COMMANDS_TEST_WRAPPER.vhd
-- Project Name:  TEST_RIG_FPGA_1_V05
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SERIAL_COMMANDS_TEST_WRAPPER
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
 
ENTITY TB_SERIAL_COMMANDS_TEST_WRAPPER IS
END TB_SERIAL_COMMANDS_TEST_WRAPPER;
 
ARCHITECTURE behavior OF TB_SERIAL_COMMANDS_TEST_WRAPPER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SERIAL_COMMANDS_TEST_WRAPPER
    PORT(
         CLK_60MHz_i : IN  std_logic;
         CLK_EN_1MHz_i : IN  std_logic;
         RESET_i : IN  std_logic;
         uC_REQUEST_i : IN  std_logic;
         uC_FPGA_SELECT_i : IN  std_logic;
         uC_COMMAND_i : IN  std_logic_vector(7 downto 0);
         uC_DATA_i : IN  std_logic_vector(31 downto 0);
         DATA_TO_uC_RECEIVED_i : IN  std_logic;
         DATA_TO_uC_READY_o : OUT  std_logic
        );
    END COMPONENT;
	 
	COMPONENT DCM_CLOCK
		Port ( 	CLK_37MHZ_i : in STD_LOGIC;
					RST_i : in STD_LOGIC;
					CLK_60MHz_o : out STD_LOGIC;
					EN_30MHz_o : out STD_LOGIC;
					EN_10MHz_o : out STD_LOGIC;
					EN_1MHz_o : out STD_LOGIC
				);
	end COMPONENT;
    

   --Inputs
	signal CLK_60MHz_i : std_logic := '0';
   signal CLK_37MHz_i : std_logic := '1';
   signal CLK_EN_1MHz_i : std_logic := '0';
   signal RESET_i : std_logic := '0';
   signal uC_REQUEST_i : std_logic := '0';
   signal uC_FPGA_SELECT_i : std_logic := '0';
   signal uC_COMMAND_i : std_logic_vector(7 downto 0) := (others=>'0');
   signal uC_DATA_i : std_logic_vector(31 downto 0) := (others=>'0');
   signal DATA_TO_uC_RECEIVED_i : std_logic := '0';

 	--Outputs
   signal DATA_TO_uC_READY_o : std_logic;

   -- Clock period definitions
   constant CLK_37MHz_i_period : time := 2 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SERIAL_COMMANDS_TEST_WRAPPER PORT MAP (
          CLK_60MHz_i => CLK_60MHz_i,
          CLK_EN_1MHz_i => CLK_EN_1MHz_i,
          RESET_i => RESET_i,
          uC_REQUEST_i => uC_REQUEST_i,
          uC_FPGA_SELECT_i => uC_FPGA_SELECT_i,
          uC_COMMAND_i => uC_COMMAND_i,
          uC_DATA_i => uC_DATA_i,
          DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,
          DATA_TO_uC_READY_o => DATA_TO_uC_READY_o
        );
		  
i_DCM_CLOCK : DCM_CLOCK
		Port map( 	
					CLK_37MHZ_i => CLK_37MHZ_i,
					RST_i => RESET_i,
					CLK_60MHz_o => CLK_60MHz_i,
					EN_30MHz_o => CLK_EN_1MHz_i,
					EN_10MHz_o => open,
					EN_1MHz_o => open
				);

   -- Clock process definitions
   CLK_37MHZ_i_process :process
   begin
		CLK_37MHZ_i <= '0';
		wait for CLK_37MHZ_i_period/2;
		CLK_37MHZ_i <= '1';
		wait for CLK_37MHZ_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RESET_i <= '1';
      -- hold reset state for 100 ns.
      wait for 30 ns;	
		RESET_i <= '0';
		wait for 100 ns;
		uC_REQUEST_i <= '1';
		uC_FPGA_SELECT_i <= '1';
		uC_COMMAND_i <= "00000011";
		wait for 1 ns;
		uC_REQUEST_i <= '0';

      wait for CLK_37MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
