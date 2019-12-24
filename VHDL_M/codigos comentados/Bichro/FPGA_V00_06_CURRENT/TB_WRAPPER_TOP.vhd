--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:19:00 06/02/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L8+B/FPGA_Board/FPGA_V00_06_CURRENT/TB_WRAPPER_TOP.vhd
-- Project Name:  FPGA_V00_06
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WRAPPER_TOP
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
 
ENTITY TB_WRAPPER_TOP IS
END TB_WRAPPER_TOP;
 
ARCHITECTURE behavior OF TB_WRAPPER_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WRAPPER_TOP
    PORT(
         CH_IN00_i : IN  std_logic_vector(2 downto 0);
         CH_IN01_i : IN  std_logic_vector(2 downto 0);
         CH_IN02_i : IN  std_logic_vector(2 downto 0);
         CH_IN03_i : IN  std_logic_vector(2 downto 0);
         CH_IN04_i : IN  std_logic_vector(2 downto 0);
         CH_IN05_i : IN  std_logic_vector(2 downto 0);
         CH_IN06_i : IN  std_logic_vector(2 downto 0);
         CH_IN07_i : IN  std_logic_vector(2 downto 0);
         CH_IN08_i : IN  std_logic_vector(2 downto 0);
         CH_IN09_i : IN  std_logic_vector(2 downto 0);
         CH_IN10_i : IN  std_logic_vector(2 downto 0);
         CH_IN11_i : IN  std_logic_vector(2 downto 0);
         CH_IN12_i : IN  std_logic_vector(2 downto 0);
         CH_IN13_i : IN  std_logic_vector(2 downto 0);
         CH_IN14_i : IN  std_logic_vector(2 downto 0);
         CH_IN15_i : IN  std_logic_vector(2 downto 0);
         CH_IN16_i : IN  std_logic_vector(2 downto 0);
         CH_IN17_i : IN  std_logic_vector(2 downto 0);
         CH_IN18_i : IN  std_logic_vector(2 downto 0);
         CH_IN19_i : IN  std_logic_vector(2 downto 0);
         CH_IN20_i : IN  std_logic_vector(2 downto 0);
         CH_IN21_i : IN  std_logic_vector(2 downto 0);
         CH_IN22_i : IN  std_logic_vector(2 downto 0);
         CH_IN23_i : IN  std_logic_vector(2 downto 0);
         CH_IN24_i : IN  std_logic_vector(2 downto 0);
         CH_IN25_i : IN  std_logic_vector(2 downto 0);
         CH_IN26_i : IN  std_logic_vector(2 downto 0);
         CH_IN27_i : IN  std_logic_vector(2 downto 0);
         CH_IN28_i : IN  std_logic_vector(2 downto 0);
         CH_IN29_i : IN  std_logic_vector(2 downto 0);
         CH_IN30_i : IN  std_logic_vector(2 downto 0);
         CH_IN31_i : IN  std_logic_vector(2 downto 0);
         CH_IN32_i : IN  std_logic_vector(2 downto 0);
         CH_IN33_i : IN  std_logic_vector(2 downto 0);
         CH_IN34_i : IN  std_logic_vector(2 downto 0);
         CH_IN35_i : IN  std_logic_vector(2 downto 0);
         CH_IN36_i : IN  std_logic_vector(2 downto 0);
         CH_IN37_i : IN  std_logic_vector(2 downto 0);
         CH_IN38_i : IN  std_logic_vector(2 downto 0);
         CH_IN39_i : IN  std_logic_vector(2 downto 0);
         CH_IN40_i : IN  std_logic_vector(2 downto 0);
         CH_IN41_i : IN  std_logic_vector(2 downto 0);
         CH_IN42_i : IN  std_logic_vector(2 downto 0);
         CH_IN43_i : IN  std_logic_vector(2 downto 0);
         CH_IN44_i : IN  std_logic_vector(2 downto 0);
         CH_IN45_i : IN  std_logic_vector(2 downto 0);
         CH_IN46_i : IN  std_logic_vector(2 downto 0);
         CH_IN47_i : IN  std_logic_vector(2 downto 0);
         CH_IN48_i : IN  std_logic_vector(2 downto 0);
         CH_IN49_i : IN  std_logic_vector(2 downto 0);
         CH_IN50_i : IN  std_logic_vector(2 downto 0);
         CH_IN51_i : IN  std_logic_vector(2 downto 0);
         CH_IN52_i : IN  std_logic_vector(2 downto 0);
         CH_IN53_i : IN  std_logic_vector(2 downto 0);
         CH_IN54_i : IN  std_logic_vector(2 downto 0);
         CH_IN55_i : IN  std_logic_vector(2 downto 0);
         CH_IN56_i : IN  std_logic_vector(2 downto 0);
         CH_IN57_i : IN  std_logic_vector(2 downto 0);
         CH_IN58_i : IN  std_logic_vector(2 downto 0);
         CH_IN59_i : IN  std_logic_vector(2 downto 0);
         CH_IN60_i : IN  std_logic_vector(2 downto 0);
         CH_IN61_i : IN  std_logic_vector(2 downto 0);
         CH_IN62_i : IN  std_logic_vector(2 downto 0);
         CH_IN63_i : IN  std_logic_vector(2 downto 0);
         SYNC1_i : IN  std_logic_vector(8 downto 0);
         SYNC1_EL_7_i : IN  std_logic_vector(8 downto 0);
         SYNC2_i : IN  std_logic_vector(8 downto 0);
         SYNC2_EL_7_i : IN  std_logic_vector(8 downto 0);
         RETRIGGER_ON_i : IN  std_logic;
         TEMPO_ESTATISTICA_i : IN  std_logic_vector(2 downto 0);
         HAS_GRAIN_i : IN  std_logic_vector(63 downto 0);
         INT_CH_REQ_i : IN  std_logic_vector(5 downto 0);
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
         OVERUSAGE_CLR_A_i : IN  std_logic;
         OVERUSAGE_CLR_B_i : IN  std_logic;
         C20US_i : IN  std_logic;
         C56MHz_i : IN  std_logic;
         C18MHZ_i : IN  std_logic;
         C3KHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
         PROBE_o : OUT  std_logic_vector(15 downto 0);
         EJ_CNT_o : OUT  std_logic_vector(15 downto 0);
         MAX_ACTIVE_COUNTER_o : OUT  std_logic_vector(15 downto 0);
         OVERUSAGE_o : OUT  std_logic_vector(63 downto 0);
         CH_EJ_o : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CH_IN00_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN01_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN02_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN03_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN04_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN05_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN06_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN07_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN08_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN09_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN10_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN11_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN12_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN13_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN14_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN15_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN16_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN17_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN18_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN19_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN20_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN21_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN22_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN23_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN24_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN25_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN26_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN27_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN28_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN29_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN30_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN31_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN32_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN33_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN34_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN35_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN36_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN37_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN38_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN39_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN40_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN41_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN42_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN43_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN44_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN45_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN46_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN47_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN48_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN49_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN50_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN51_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN52_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN53_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN54_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN55_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN56_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN57_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN58_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN59_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN60_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN61_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN62_i : std_logic_vector(2 downto 0) := (others => '0');
   signal CH_IN63_i : std_logic_vector(2 downto 0) := (others => '0');
   signal SYNC1_i : std_logic_vector(8 downto 0) := "000011111";
   signal SYNC1_EL_7_i : std_logic_vector(8 downto 0) := "000000111";
   signal SYNC2_i : std_logic_vector(8 downto 0) := "000011111";
   signal SYNC2_EL_7_i : std_logic_vector(8 downto 0) := "000000111";
   signal RETRIGGER_ON_i : std_logic := '0';
   signal TEMPO_ESTATISTICA_i : std_logic_vector(2 downto 0) := (others => '0');
   signal HAS_GRAIN_i : std_logic_vector(63 downto 0) := (others => '0');
   signal INT_CH_REQ_i : std_logic_vector(5 downto 0) := (others => '0');
   signal A_ELIPSE1_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE2_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE3_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE4_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE5_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE6_i : std_logic_vector(9 downto 0) := "0011111111";
   signal A_ELIPSE7_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE1_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE2_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE3_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE4_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE5_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE6_i : std_logic_vector(9 downto 0) := "0011111111";
   signal B_ELIPSE7_i : std_logic_vector(9 downto 0) := "0011111111";
   signal OVERUSAGE_CLR_A_i : std_logic := '0';
   signal OVERUSAGE_CLR_B_i : std_logic := '0';
   signal C20US_i : std_logic := '0';
   signal C56MHz_i : std_logic := '0';
   signal C18MHZ_i : std_logic := '0';
   signal C3KHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal PROBE_o : std_logic_vector(15 downto 0);
   signal EJ_CNT_o : std_logic_vector(15 downto 0);
   signal MAX_ACTIVE_COUNTER_o : std_logic_vector(15 downto 0);
   signal OVERUSAGE_o : std_logic_vector(63 downto 0);
   signal CH_EJ_o : std_logic_vector(63 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant C56MHz_i_period : time := 1 ns;
	constant C18MHZ_i_period : time := 3 ns;
	constant C20US_i_period : time := 1120 ns;
	constant C3KHZ_i_period : time := 17920 ns;
 
BEGIN
 
   -- Clock process definitions
   C56MHz_i_process :process
   begin
		C56MHz_i <= '0';
		wait for C56MHz_i_period/2;
		C56MHz_i <= '1';
		wait for C56MHz_i_period/2;
   end process;
	
   -- Clock process definitions
   C18MHZ_i_process :process
   begin
		C18MHZ_i <= '0';
		wait for C18MHZ_i_period/2;
		C18MHZ_i <= '1';
		wait for C18MHZ_i_period/2;
   end process;
	
   -- Clock process definitions
   C20US_i_process :process
   begin
		C20US_i <= '0';
		wait for C20US_i_period/2;
		C20US_i <= '1';
		wait for C20US_i_period/2;
   end process;
	
   -- Clock process definitions
   C3KHZ_i_process :process
   begin
		C3KHZ_i <= '0';
		wait for C3KHZ_i_period/2;
		C3KHZ_i <= '1';
		wait for C3KHZ_i_period/2;
   end process;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WRAPPER_TOP PORT MAP (
          CH_IN00_i => CH_IN00_i,
          CH_IN01_i => CH_IN01_i,
          CH_IN02_i => CH_IN02_i,
          CH_IN03_i => CH_IN03_i,
          CH_IN04_i => CH_IN04_i,
          CH_IN05_i => CH_IN05_i,
          CH_IN06_i => CH_IN06_i,
          CH_IN07_i => CH_IN07_i,
          CH_IN08_i => CH_IN08_i,
          CH_IN09_i => CH_IN09_i,
          CH_IN10_i => CH_IN10_i,
          CH_IN11_i => CH_IN11_i,
          CH_IN12_i => CH_IN12_i,
          CH_IN13_i => CH_IN13_i,
          CH_IN14_i => CH_IN14_i,
          CH_IN15_i => CH_IN15_i,
          CH_IN16_i => CH_IN16_i,
          CH_IN17_i => CH_IN17_i,
          CH_IN18_i => CH_IN18_i,
          CH_IN19_i => CH_IN19_i,
          CH_IN20_i => CH_IN20_i,
          CH_IN21_i => CH_IN21_i,
          CH_IN22_i => CH_IN22_i,
          CH_IN23_i => CH_IN23_i,
          CH_IN24_i => CH_IN24_i,
          CH_IN25_i => CH_IN25_i,
          CH_IN26_i => CH_IN26_i,
          CH_IN27_i => CH_IN27_i,
          CH_IN28_i => CH_IN28_i,
          CH_IN29_i => CH_IN29_i,
          CH_IN30_i => CH_IN30_i,
          CH_IN31_i => CH_IN31_i,
          CH_IN32_i => CH_IN32_i,
          CH_IN33_i => CH_IN33_i,
          CH_IN34_i => CH_IN34_i,
          CH_IN35_i => CH_IN35_i,
          CH_IN36_i => CH_IN36_i,
          CH_IN37_i => CH_IN37_i,
          CH_IN38_i => CH_IN38_i,
          CH_IN39_i => CH_IN39_i,
          CH_IN40_i => CH_IN40_i,
          CH_IN41_i => CH_IN41_i,
          CH_IN42_i => CH_IN42_i,
          CH_IN43_i => CH_IN43_i,
          CH_IN44_i => CH_IN44_i,
          CH_IN45_i => CH_IN45_i,
          CH_IN46_i => CH_IN46_i,
          CH_IN47_i => CH_IN47_i,
          CH_IN48_i => CH_IN48_i,
          CH_IN49_i => CH_IN49_i,
          CH_IN50_i => CH_IN50_i,
          CH_IN51_i => CH_IN51_i,
          CH_IN52_i => CH_IN52_i,
          CH_IN53_i => CH_IN53_i,
          CH_IN54_i => CH_IN54_i,
          CH_IN55_i => CH_IN55_i,
          CH_IN56_i => CH_IN56_i,
          CH_IN57_i => CH_IN57_i,
          CH_IN58_i => CH_IN58_i,
          CH_IN59_i => CH_IN59_i,
          CH_IN60_i => CH_IN60_i,
          CH_IN61_i => CH_IN61_i,
          CH_IN62_i => CH_IN62_i,
          CH_IN63_i => CH_IN63_i,
          SYNC1_i => SYNC1_i,
          SYNC1_EL_7_i => SYNC1_EL_7_i,
          SYNC2_i => SYNC2_i,
          SYNC2_EL_7_i => SYNC2_EL_7_i,
          RETRIGGER_ON_i => RETRIGGER_ON_i,
          TEMPO_ESTATISTICA_i => TEMPO_ESTATISTICA_i,
          HAS_GRAIN_i => HAS_GRAIN_i,
          INT_CH_REQ_i => INT_CH_REQ_i,
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
          C20US_i => C20US_i,
          C56MHz_i => C56MHz_i,
          C18MHZ_i => C18MHZ_i,
          C3KHZ_i => C3KHZ_i,
          RST_i => RST_i,
          PROBE_o => PROBE_o,
          EJ_CNT_o => EJ_CNT_o,
          MAX_ACTIVE_COUNTER_o => MAX_ACTIVE_COUNTER_o,
          OVERUSAGE_o => OVERUSAGE_o,
          CH_EJ_o => CH_EJ_o
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 18000 ns;	
		RST_i <= '0';
		wait for 1000 ns;	
		CH_IN00_i <= "100";
		CH_IN01_i <= "111";
		wait for 100 ns;	
		CH_IN00_i <= "000";
		CH_IN01_i <= "000";

      -- insert stimulus here 

      wait;
   end process;

END;
