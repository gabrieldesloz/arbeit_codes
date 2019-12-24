--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:36:07 08/08/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_MEAN_256.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEAN_256
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
 
ENTITY TB_MEAN_256 IS
END TB_MEAN_256;
 
ARCHITECTURE behavior OF TB_MEAN_256 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEAN_256
    PORT(
         POX_i : IN  std_logic_vector(7 downto 0);
         CANSUM_i : IN  std_logic;
         IS_EXTACCESS_i : IN  std_logic;
         IS_FLOOR_i : IN  std_logic;
         AUTOGAINT_i : IN  std_logic_vector(15 downto 0);
         ADDR_REQ_i : IN  std_logic_vector(7 downto 0);
         RST_i : IN  std_logic;
         CLK_i : IN  std_logic;
			CLK_INV_i : IN std_logic;
         DATA_OUT_o : OUT  std_logic_vector(15 downto 0);
         IS_READING_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal POX_i : std_logic_vector(7 downto 0) := (others => '0');
   signal CANSUM_i : std_logic := '0';
   signal IS_EXTACCESS_i : std_logic := '0';
   signal IS_FLOOR_i : std_logic := '0';
   signal AUTOGAINT_i : std_logic_vector(15 downto 0) := (others => '0');
   signal ADDR_REQ_i : std_logic_vector(7 downto 0) := (others => '0');
   signal RST_i : std_logic := '0';
   signal CLK_i : std_logic := '0';
	signal CLK_INV_i : std_logic := '0';

 	--Outputs
   signal DATA_OUT_o : std_logic_vector(15 downto 0);
   signal IS_READING_o : std_logic;

   -- Clock period definitions
   constant CLK_i_period : time := 1 ns;
	constant CLK_INV_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEAN_256 PORT MAP (
          POX_i => POX_i,
          CANSUM_i => CANSUM_i,
          IS_EXTACCESS_i => IS_EXTACCESS_i,
          IS_FLOOR_i => IS_FLOOR_i,
          AUTOGAINT_i => AUTOGAINT_i,
          ADDR_REQ_i => ADDR_REQ_i,
          RST_i => RST_i,
          CLK_i => CLK_i,
			 CLK_INV_i => CLK_INV_i,
          DATA_OUT_o => DATA_OUT_o,
          IS_READING_o => IS_READING_o
        );

   -- Clock process definitions
   CLK_i_process :process
   begin
		CLK_i <= '0';
		wait for CLK_i_period/2;
		CLK_i <= '1';
		wait for CLK_i_period/2;
   end process;
	
   CLK_INV_i_process :process
   begin
		CLK_INV_i <= '1';
		wait for CLK_INV_i_period/2;
		CLK_INV_i <= '0';
		wait for CLK_INV_i_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
		CANSUM_i <= '1';
		AUTOGAINT_i <= "00000010" & "00000010";
		IS_EXTACCESS_i <= '0';
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		RST_i <= '0';
      wait for 100 ns;	
		IS_EXTACCESS_i <= '1';
      wait for 100 ns;	
		IS_EXTACCESS_i <= '0';
		CANSUM_i <= '0';
      wait for 100 ns;	
		CANSUM_i <= '1';
		wait for 5000 ns;	
		IS_EXTACCESS_i <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
