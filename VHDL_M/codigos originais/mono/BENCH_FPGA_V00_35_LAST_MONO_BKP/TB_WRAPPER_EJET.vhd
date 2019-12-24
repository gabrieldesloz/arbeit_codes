--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:54:05 11/01/2012
-- Design Name:   
-- Module Name:   D:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_70/TB_WRAPPER_EJET.vhd
-- Project Name:  FPGA_V00_70
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WRAPPER_EJET
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
 
ENTITY TB_WRAPPER_EJET IS
END TB_WRAPPER_EJET;
 
ARCHITECTURE behavior OF TB_WRAPPER_EJET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WRAPPER_EJET
    PORT(
         LENGTH_BUFF_i : IN  std_logic_vector(191 downto 0);
         TEMPO_ESTATISTICA_i : IN  std_logic_vector(2 downto 0);
         INT_CH_REQ_i : IN  std_logic_vector(5 downto 0);
         RETRIGGER_ON_i : IN  std_logic;
         A_ELIPSE1_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE2_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE3_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE4_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE5_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE6_i : IN  std_logic_vector(9 downto 0);
         A_ELIPSE7_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE1_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE2_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE3_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE4_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE5_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE6_i : IN  std_logic_vector(9 downto 0);
         B_ELIPSE7_i : IN  std_logic_vector(9 downto 0);
		   OVERUSAGE_CLR_A_i : in STD_LOGIC;
		   OVERUSAGE_CLR_B_i : in STD_LOGIC;
         C18MHZ_i : IN  std_logic;
         C3KHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
         EJ_CNT_o : OUT  std_logic_vector(15 downto 0);
         MAX_ACTIVE_COUNTER_o : OUT  std_logic_vector(15 downto 0);
         CH_NUM_o : OUT  std_logic_vector(5 downto 0);
         OVERUSAGE_o : OUT  std_logic_vector(63 downto 0);
         CH_OUT_o : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal LENGTH_BUFF_i : std_logic_vector(191 downto 0) := (others => '0');
   signal TEMPO_ESTATISTICA_i : std_logic_vector(2 downto 0) := (others => '0');
   signal INT_CH_REQ_i : std_logic_vector(5 downto 0) := (others => '0');
   signal RETRIGGER_ON_i : std_logic := '0';
   signal A_ELIPSE1_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE2_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE3_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE4_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE5_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE6_i : std_logic_vector(9 downto 0) := (others => '0');
   signal A_ELIPSE7_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE1_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE2_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE3_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE4_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE5_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE6_i : std_logic_vector(9 downto 0) := (others => '0');
   signal B_ELIPSE7_i : std_logic_vector(9 downto 0) := (others => '0');
	signal OVERUSAGE_CLR_A_i : STD_LOGIC := '0';
	signal OVERUSAGE_CLR_B_i : STD_LOGIC := '0';
   signal C18MHZ_i : std_logic := '0';
   signal C3KHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal EJ_CNT_o : std_logic_vector(15 downto 0);
   signal MAX_ACTIVE_COUNTER_o : std_logic_vector(15 downto 0);
   signal CH_NUM_o : std_logic_vector(5 downto 0);
   signal OVERUSAGE_o : std_logic_vector(63 downto 0);
   signal CH_OUT_o : std_logic_vector(63 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant C18MHZ_i_period : time := 1 ns;
	constant C3KHZ_i_period : time := 2337 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WRAPPER_EJET PORT MAP (
          LENGTH_BUFF_i => LENGTH_BUFF_i,
          TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
          INT_CH_REQ_i => INT_CH_REQ_i,
          RETRIGGER_ON_i => RETRIGGER_ON_i,
          A_ELIPSE1_i => A_ELIPSE1_i,
          A_ELIPSE2_i => A_ELIPSE2_i,
          A_ELIPSE3_i => A_ELIPSE3_i,
          A_ELIPSE4_i => A_ELIPSE4_i,
          A_ELIPSE5_i => A_ELIPSE5_i,
          A_ELIPSE6_i => A_ELIPSE6_i,
          A_ELIPSE7_i => A_ELIPSE7_i,
          B_ELIPSE1_i => B_ELIPSE1_i,
          B_ELIPSE2_i => B_ELIPSE2_i,
          B_ELIPSE3_i => B_ELIPSE3_i,
          B_ELIPSE4_i => B_ELIPSE4_i,
          B_ELIPSE5_i => B_ELIPSE5_i,
          B_ELIPSE6_i => B_ELIPSE6_i,
          B_ELIPSE7_i => B_ELIPSE7_i,
			 OVERUSAGE_CLR_A_i => OVERUSAGE_CLR_A_i,
			 OVERUSAGE_CLR_B_i => OVERUSAGE_CLR_B_i,
          C18MHZ_i => C18MHZ_i,
          C3KHZ_i => C3KHZ_i,
          RST_i => RST_i,
          EJ_CNT_o => EJ_CNT_o,
          MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
          CH_NUM_o => CH_NUM_o,
          OVERUSAGE_o => OVERUSAGE_o,
          CH_OUT_o => CH_OUT_o
        );

   -- Clock process definitions
   C18MHZ_i_process :process
   begin
		C18MHZ_i <= '0';
		wait for C18MHZ_i_period/2;
		C18MHZ_i <= '1';
		wait for C18MHZ_i_period/2;
   end process;
	
   C3KHZ_i_process :process
   begin
		C3KHZ_i <= '0';
		wait for C3KHZ_i_period/2;
		C3KHZ_i <= '1';
		wait for C3KHZ_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
		A_ELIPSE7_i <= "0000000100";
		B_ELIPSE7_i <= "0000000100";
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';
--		LENGTH_BUFF_i <= (others=>'1');
		LENGTH_BUFF_i(191 downto 189) <= "001";
		TEMPO_ESTATISTICA_i <= "000";
		wait for 42200 ns;	
		INT_CH_REQ_i <= "111111";
		wait for 10 ns;
		INT_CH_REQ_i <= "000000";
		wait for 100 ns;
		OVERUSAGE_CLR_B_i <= '1';
		wait for 1 ns;
		OVERUSAGE_CLR_B_i <= '0';
--		wait for 1000 ns;
--		OVERUSAGE_CLR_A_i <= '1';
--		wait for 1 ns;
--		OVERUSAGE_CLR_A_i <= '0';
      wait for C18MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
