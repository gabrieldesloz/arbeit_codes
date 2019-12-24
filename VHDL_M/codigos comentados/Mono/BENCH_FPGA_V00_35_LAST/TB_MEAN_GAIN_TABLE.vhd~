--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:39:21 08/04/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_MEAN_GAIN_TABLE.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEAN_GAIN_TABLE
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
 
ENTITY TB_MEAN_GAIN_TABLE IS
END TB_MEAN_GAIN_TABLE;
 
ARCHITECTURE behavior OF TB_MEAN_GAIN_TABLE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEAN_GAIN_TABLE
    PORT(
         DATA_MEAN_i : IN  std_logic_vector(15 downto 0);
         ADDR_RD_i : IN  std_logic_vector(7 downto 0);
			IS_EXTACCESS_i : in std_logic;
         IS_FLOOR_i : IN  std_logic;
         RD_EN_i : IN  std_logic;
         CLK_i : IN  std_logic;
         CLK_INV_i : IN  std_logic;
         RST_i : IN  std_logic;
         DATA_MEAN_o : OUT  std_logic_vector(15 downto 0);
         POX_RD_o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DATA_MEAN_i : std_logic_vector(15 downto 0) := (others => '0');
   signal ADDR_RD_i : std_logic_vector(7 downto 0) := (others => '0');
   signal IS_FLOOR_i : std_logic := '0';
	signal IS_EXTACCESS_i : std_logic := '0';
   signal RD_EN_i : std_logic := '0';
   signal CLK_i : std_logic := '0';
   signal CLK_INV_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal DATA_MEAN_o : std_logic_vector(15 downto 0);
   signal POX_RD_o : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_i_period : time := 1 ns;
   constant CLK_INV_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEAN_GAIN_TABLE PORT MAP (
          DATA_MEAN_i => DATA_MEAN_i,
          ADDR_RD_i => ADDR_RD_i,
          IS_FLOOR_i => IS_FLOOR_i,
			 IS_EXTACCESS_i => IS_EXTACCESS_i,
          RD_EN_i => RD_EN_i,
          CLK_i => CLK_i,
          CLK_INV_i => CLK_INV_i,
          RST_i => RST_i,
          DATA_MEAN_o => DATA_MEAN_o,
          POX_RD_o => POX_RD_o
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
		RST_i <= '1';
		DATA_MEAN_i <= "00000001" & "00000001";
		wait for 10 ns;
		RST_i <= '0';
		wait for 5 ns;
		RD_EN_i <= '1';
		wait for 100 ns;
		IS_FLOOR_i <= '1';
		wait for 100 ns;
		IS_EXTACCESS_i <= '1';
      wait for CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
