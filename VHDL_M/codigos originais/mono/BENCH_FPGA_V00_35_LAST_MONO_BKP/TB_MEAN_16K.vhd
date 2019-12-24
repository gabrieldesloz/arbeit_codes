--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:51:17 08/24/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_MEAN_16K.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEAN_16K
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_MEAN_16K IS
END TB_MEAN_16K;
 
ARCHITECTURE behavior OF TB_MEAN_16K IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEAN_16K
    PORT(
         ACC_TRANSLUC_i : IN  std_logic_vector(63 downto 0);
         ACC_REFLECT_i : IN  std_logic_vector(63 downto 0);
         POX_i : IN  std_logic_vector(7 downto 0);
         BOUNDARIES_i : IN  std_logic_vector(15 downto 0);
         CANSUM_i : IN  std_logic;
         IS_EXTACCESS_i : IN  std_logic;
         IS_FLOOR_i : IN  std_logic;
         GEN_TAB_i : IN  std_logic;
         ADDR_REQ_i : IN  std_logic_vector(7 downto 0);
         GAIN_OR_MEAN_i : IN  std_logic;
         RST_i : IN  std_logic;
         CLK_i : IN  std_logic;
         CLK_INV_i : IN  std_logic;
         GEN_TAB_CLR_o : OUT  std_logic;
         TRANSLUC_o : OUT  std_logic_vector(63 downto 0);
         REFLECT_o : OUT  std_logic_vector(63 downto 0);
         TABLE_READY_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ACC_TRANSLUC_i : std_logic_vector(63 downto 0) := (others => '0');
   signal ACC_REFLECT_i : std_logic_vector(63 downto 0) := (others => '0');
   signal POX_i : std_logic_vector(7 downto 0) := (others => '0');
   signal BOUNDARIES_i : std_logic_vector(15 downto 0) := (others => '0');
   signal CANSUM_i : std_logic := '0';
   signal IS_EXTACCESS_i : std_logic := '0';
   signal IS_FLOOR_i : std_logic := '0';
   signal GEN_TAB_i : std_logic := '0';
   signal ADDR_REQ_i : std_logic_vector(7 downto 0) := (others => '0');
   signal GAIN_OR_MEAN_i : std_logic := '0';
   signal RST_i : std_logic := '0';
   signal CLK_i : std_logic := '0';
   signal CLK_INV_i : std_logic := '0';

 	--Outputs
   signal GEN_TAB_CLR_o : std_logic;
   signal TRANSLUC_o : std_logic_vector(63 downto 0);
   signal REFLECT_o : std_logic_vector(63 downto 0);
   signal TABLE_READY_o : std_logic;

   -- Clock period definitions
   constant CLK_i_period : time := 1 ns;
   constant CLK_INV_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEAN_16K PORT MAP (
          ACC_TRANSLUC_i => ACC_TRANSLUC_i,
          ACC_REFLECT_i => ACC_REFLECT_i,
          POX_i => POX_i,
          BOUNDARIES_i => BOUNDARIES_i,
          CANSUM_i => CANSUM_i,
          IS_EXTACCESS_i => IS_EXTACCESS_i,
          IS_FLOOR_i => IS_FLOOR_i,
          GEN_TAB_i => GEN_TAB_i,
          ADDR_REQ_i => ADDR_REQ_i,
          GAIN_OR_MEAN_i => GAIN_OR_MEAN_i,
          RST_i => RST_i,
          CLK_i => CLK_i,
          CLK_INV_i => CLK_INV_i,
          GEN_TAB_CLR_o => GEN_TAB_CLR_o,
          TRANSLUC_o => TRANSLUC_o,
          REFLECT_o => REFLECT_o,
          TABLE_READY_o => TABLE_READY_o
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
		
          ACC_TRANSLUC_i <= "1111111111111110" & "0000000000000000" & "0000000000000000" & "0000000000000000";
          ACC_REFLECT_i <= "1111111111111110" & "0000000000000000" & "0000000000000000" & "0000000000000000";
			  
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		RST_i <= '0';
		for i in 0 to 257 loop
		 for i in 0 to 255 loop
				CANSUM_i <= '1';
			  wait for CLK_i_period*5;
				CANSUM_i <= '0';
			 			  
				wait for CLK_i_period*15;
			  POX_i <= POX_i + '1';
		 end loop;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
