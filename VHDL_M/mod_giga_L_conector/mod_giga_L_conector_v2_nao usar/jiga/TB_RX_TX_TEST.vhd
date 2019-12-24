--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:17:53 05/21/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V02/TB_RX_TX_TEST.vhd
-- Project Name:  TEST_RIG_FPGA_1_V02
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RX_TX_TEST
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
 
ENTITY TB_RX_TX_TEST IS
END TB_RX_TX_TEST;
 
ARCHITECTURE behavior OF TB_RX_TX_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RX_TX_TEST
    Port ( TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);
           SEND_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;										-- Baud clock (38400 Hz)
			  CLK_EN_i : in  STD_LOGIC;									-- Clock enable (in case it is needed)
           RST_i : in  STD_LOGIC;
			  
			  FAIL_o : out STD_LOGIC;											-- Flag that indicates if there was not an end signal
           PACKET_READY_o : out  STD_LOGIC;
           PACKET_SENT_o : out  STD_LOGIC;
			  RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    END COMPONENT;
	 
component DCM_CLOCK
	Port ( 	CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_60MHz_o : out STD_LOGIC;
				EN_30MHz_o : out STD_LOGIC;
				EN_10MHz_o : out STD_LOGIC;
				EN_1MHz_o : out STD_LOGIC
			);
end component;
    

   --Inputs
   signal TX_DATA_i : std_logic_vector(7 downto 0) := (others => '0');
   signal SEND_i : std_logic := '0';
   signal BAUD_CLK_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal FAIL_o : std_logic;
   signal PACKET_READY_o : std_logic;
   signal PACKET_SENT_o : std_logic;
   signal RX_DATA_o : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	
	signal s_clk_60MHz : std_logic;
	signal s_en_1MHz, s_en_10MHz, s_en_30MHz : std_logic;
 
   constant BAUD_CLK_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RX_TX_TEST PORT MAP (
          TX_DATA_i => TX_DATA_i,
          SEND_i => SEND_i,
          CLK_i => s_clk_60MHz,
			 CLK_EN_i => s_en_1MHz,
          RST_i => RST_i,
          FAIL_o => FAIL_o,
          PACKET_READY_o => PACKET_READY_o,
          PACKET_SENT_o => PACKET_SENT_o,
          RX_DATA_o => RX_DATA_o
        );
		  
	i_DCM_CLOCK : DCM_CLOCK
		Port map ( 	
					CLK_37MHZ_i => BAUD_CLK_i,
					RST_i => RST_i,
					CLK_60MHz_o => s_clk_60MHz,
					EN_30MHz_o => s_en_30MHz,
					EN_10MHz_o => s_en_10MHz,
					EN_1MHz_o => s_en_1MHz
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
		wait for 10 ns;	
		SEND_i <= '1';
		wait for 10 ns;	
		SEND_i <= '0';
      wait for 500 ns;	
		TX_DATA_i <= "11111010";
		wait for 10 ns;	
		SEND_i <= '1';
		wait for 10 ns;	
		SEND_i <= '0';

      wait for BAUD_CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
