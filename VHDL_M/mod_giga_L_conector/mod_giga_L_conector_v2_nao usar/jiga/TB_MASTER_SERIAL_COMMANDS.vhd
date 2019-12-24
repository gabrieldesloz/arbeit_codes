--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:15:46 07/18/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V05/TB_MASTER_SERIAL_COMMANDS.vhd
-- Project Name:  TEST_RIG_FPGA_1_V05
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MASTER_SERIAL_COMMANDS
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
 
ENTITY TB_MASTER_SERIAL_COMMANDS IS
END TB_MASTER_SERIAL_COMMANDS;
 
ARCHITECTURE behavior OF TB_MASTER_SERIAL_COMMANDS IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MASTER_SERIAL_COMMANDS
    PORT(
         CLK_60MHZ_i : IN  std_logic;
         EN_CLK_i : IN  std_logic;
         RESET_i : IN  std_logic;
         uC_REQUEST_i : IN  std_logic;
         uC_FPGA_SELECT_i : IN  std_logic;
         uC_COMMAND_i : IN  std_logic_vector(7 downto 0);
         uC_DATA_i : IN  std_logic_vector(31 downto 0);
         DATA_TO_uC_RECEIVED_i : IN  std_logic;
         DATA_TO_uC_READY_o : OUT  std_logic;
         SERIAL_DATA_1_2_i : IN  std_logic_vector(7 downto 0);
         SERIAL_DATA_1_2_o : OUT  std_logic_vector(7 downto 0);
         PACKET_SENT_1_2_i : IN  std_logic;
         PACKET_FAIL_1_2_i : IN  std_logic;
         PACKET_READY_1_2_i : IN  std_logic;
         SEND_PACKET_1_2_o : OUT  std_logic;
         SERIAL_DATA_1_3_i : IN  std_logic_vector(7 downto 0);
         SERIAL_DATA_1_3_o : OUT  std_logic_vector(7 downto 0);
         PACKET_SENT_1_3_i : IN  std_logic;
         PACKET_FAIL_1_3_i : IN  std_logic;
         PACKET_READY_1_3_i : IN  std_logic;
         SEND_PACKET_1_3_o : OUT  std_logic;
         FPGA_2_VERSION_o : OUT  std_logic_vector(7 downto 0);
         FPGA_3_VERSION_o : OUT  std_logic_vector(7 downto 0);
         R2R_i : IN  std_logic_vector(7 downto 0);
         FRONT_LED_A_o : OUT  std_logic;
         FRONT_LED_B_o : OUT  std_logic;
         FRONT_LED_C_o : OUT  std_logic;
         FRONT_LED_D_o : OUT  std_logic;
         REAR_LED_A_o : OUT  std_logic;
         REAR_LED_B_o : OUT  std_logic;
         REAR_LED_C_o : OUT  std_logic;
         REAR_LED_D_o : OUT  std_logic;
         V_BCKGND_o : OUT  std_logic;
         EJEC_SDATA_Q_o : OUT  std_logic;
         EJET_o : OUT  std_logic_vector(31 downto 0);
         TEST_FED_OUT_o : OUT  std_logic_vector(11 downto 0);
         R_COMP_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_60MHZ_i : std_logic := '0';
   signal EN_CLK_i : std_logic := '0';
   signal RESET_i : std_logic := '0';
   signal uC_REQUEST_i : std_logic := '0';
   signal uC_FPGA_SELECT_i : std_logic := '0';
   signal uC_COMMAND_i : std_logic_vector(7 downto 0) := (others => '0');
   signal uC_DATA_i : std_logic_vector(31 downto 0) := (others => '0');
   signal DATA_TO_uC_RECEIVED_i : std_logic := '0';
   signal SERIAL_DATA_1_2_i : std_logic_vector(7 downto 0) := (others => '0');
   signal PACKET_SENT_1_2_i : std_logic := '0';
   signal PACKET_FAIL_1_2_i : std_logic := '0';
   signal PACKET_READY_1_2_i : std_logic := '0';
   signal SERIAL_DATA_1_3_i : std_logic_vector(7 downto 0) := (others => '0');
   signal PACKET_SENT_1_3_i : std_logic := '0';
   signal PACKET_FAIL_1_3_i : std_logic := '0';
   signal PACKET_READY_1_3_i : std_logic := '0';
   signal R2R_i : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal DATA_TO_uC_READY_o : std_logic;
   signal SERIAL_DATA_1_2_o : std_logic_vector(7 downto 0);
   signal SEND_PACKET_1_2_o : std_logic;
   signal SERIAL_DATA_1_3_o : std_logic_vector(7 downto 0);
   signal SEND_PACKET_1_3_o : std_logic;
   signal FPGA_2_VERSION_o : std_logic_vector(7 downto 0);
   signal FPGA_3_VERSION_o : std_logic_vector(7 downto 0);
   signal FRONT_LED_A_o : std_logic;
   signal FRONT_LED_B_o : std_logic;
   signal FRONT_LED_C_o : std_logic;
   signal FRONT_LED_D_o : std_logic;
   signal REAR_LED_A_o : std_logic;
   signal REAR_LED_B_o : std_logic;
   signal REAR_LED_C_o : std_logic;
   signal REAR_LED_D_o : std_logic;
   signal V_BCKGND_o : std_logic;
   signal EJEC_SDATA_Q_o : std_logic;
   signal EJET_o : std_logic_vector(31 downto 0);
   signal TEST_FED_OUT_o : std_logic_vector(11 downto 0);
   signal R_COMP_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_60MHZ_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MASTER_SERIAL_COMMANDS PORT MAP (
          CLK_60MHZ_i => CLK_60MHZ_i,
          EN_CLK_i => EN_CLK_i,
          RESET_i => RESET_i,
          uC_REQUEST_i => uC_REQUEST_i,
          uC_FPGA_SELECT_i => uC_FPGA_SELECT_i,
          uC_COMMAND_i => uC_COMMAND_i,
          uC_DATA_i => uC_DATA_i,
          DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,
          DATA_TO_uC_READY_o => DATA_TO_uC_READY_o,
          SERIAL_DATA_1_2_i => SERIAL_DATA_1_2_i,
          SERIAL_DATA_1_2_o => SERIAL_DATA_1_2_o,
          PACKET_SENT_1_2_i => PACKET_SENT_1_2_i,
          PACKET_FAIL_1_2_i => PACKET_FAIL_1_2_i,
          PACKET_READY_1_2_i => PACKET_READY_1_2_i,
          SEND_PACKET_1_2_o => SEND_PACKET_1_2_o,
          SERIAL_DATA_1_3_i => SERIAL_DATA_1_3_i,
          SERIAL_DATA_1_3_o => SERIAL_DATA_1_3_o,
          PACKET_SENT_1_3_i => PACKET_SENT_1_3_i,
          PACKET_FAIL_1_3_i => PACKET_FAIL_1_3_i,
          PACKET_READY_1_3_i => PACKET_READY_1_3_i,
          SEND_PACKET_1_3_o => SEND_PACKET_1_3_o,
          FPGA_2_VERSION_o => FPGA_2_VERSION_o,
          FPGA_3_VERSION_o => FPGA_3_VERSION_o,
          R2R_i => R2R_i,
          FRONT_LED_A_o => FRONT_LED_A_o,
          FRONT_LED_B_o => FRONT_LED_B_o,
          FRONT_LED_C_o => FRONT_LED_C_o,
          FRONT_LED_D_o => FRONT_LED_D_o,
          REAR_LED_A_o => REAR_LED_A_o,
          REAR_LED_B_o => REAR_LED_B_o,
          REAR_LED_C_o => REAR_LED_C_o,
          REAR_LED_D_o => REAR_LED_D_o,
          V_BCKGND_o => V_BCKGND_o,
          EJEC_SDATA_Q_o => EJEC_SDATA_Q_o,
          EJET_o => EJET_o,
          TEST_FED_OUT_o => TEST_FED_OUT_o,
          R_COMP_o => R_COMP_o
        );

   -- Clock process definitions
   CLK_60MHZ_i_process :process
   begin
		CLK_60MHZ_i <= '0';
		wait for CLK_60MHZ_i_period/2;
		CLK_60MHZ_i <= '1';
		wait for CLK_60MHZ_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_60MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
