--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:11:17 08/11/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_CORR_AGT.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CORR_AGT
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_CORR_AGT IS
END TB_CORR_AGT;
 
ARCHITECTURE behavior OF TB_CORR_AGT IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CORR_AGT
    PORT(
         GEN_TAB_i : IN  std_logic;
         ADDR_RD_i : IN  std_logic_vector(7 downto 0);
			BOUNDARIES_i : in STD_LOGIC_VECTOR (15 downto 0);
         IS_EXTACCESS_i : IN  std_logic;
         IS_FLOOR_i : IN  std_logic;
         DATA_256_i : IN  std_logic_vector(15 downto 0);
         CLK_i : IN  std_logic;
         CLK_INV_i : IN  std_logic;
         RST_i : IN  std_logic;
         ADDR256_RD_o : OUT  std_logic_vector(7 downto 0);
         DATA_CORR_o : OUT  std_logic_vector(31 downto 0);
         IS_READING_o : OUT  std_logic;
         GEN_TAB_CLR_o : OUT  std_logic;
         TABLE_READY_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal GEN_TAB_i : std_logic := '0';
   signal ADDR_RD_i : std_logic_vector(7 downto 0) := (others => '0');
	signal BOUNDARIES_i : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
   signal IS_EXTACCESS_i : std_logic := '0';
   signal IS_FLOOR_i : std_logic := '0';
   signal DATA_256_i : std_logic_vector(15 downto 0) := (others => '0');
   signal CLK_i : std_logic := '0';
   signal CLK_INV_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal ADDR256_RD_o : std_logic_vector(7 downto 0);
   signal DATA_CORR_o : std_logic_vector(31 downto 0);
   signal IS_READING_o : std_logic;
   signal GEN_TAB_CLR_o : std_logic;
   signal TABLE_READY_o : std_logic;

   -- Clock period definitions
   constant CLK_i_period : time := 17 ns;
   constant CLK_INV_i_period : time := 17 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CORR_AGT PORT MAP (
          GEN_TAB_i => GEN_TAB_i,
          ADDR_RD_i => ADDR_RD_i,
          IS_EXTACCESS_i => IS_EXTACCESS_i,
			 BOUNDARIES_i => BOUNDARIES_i,
          IS_FLOOR_i => IS_FLOOR_i,
          DATA_256_i => DATA_256_i,
          CLK_i => CLK_i,
          CLK_INV_i => CLK_INV_i,
          RST_i => RST_i,
          ADDR256_RD_o => ADDR256_RD_o,
          DATA_CORR_o => DATA_CORR_o,
          IS_READING_o => IS_READING_o,
          GEN_TAB_CLR_o => GEN_TAB_CLR_o,
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
		CLK_INV_i <= '0';
		wait for CLK_INV_i_period/2;
		CLK_INV_i <= '1';
		wait for CLK_INV_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	RST_i <= '1';
	DATA_256_i <= "11111111" & "00000010";
	BOUNDARIES_i <= "00010100" & "11110000";
	wait for 50 ns;
	RST_i <= '0';
	GEN_TAB_i <= '1';
	wait for 10 ns;
	GEN_TAB_i <= '0';
	wait for 85000 ns;
	IS_EXTACCESS_i <= '1';
	for i in 0 to 255 loop
		wait for 20 ns;
		ADDR_RD_i <= ADDR_RD_i + 1;
		if (i=255) then
			wait for 300 ns;
			IS_FLOOR_i <= '1';
			IS_EXTACCESS_i <= '0';
			wait for 5000 ns;
			IS_EXTACCESS_i <= '1';
			for i in 0 to 255 loop
				wait for 20 ns;
				ADDR_RD_i <= ADDR_RD_i + 1;
				if (i=255) then
					wait for 300 ns;
					IS_FLOOR_i <= '1';
					IS_EXTACCESS_i <= '0';
				end if;
			end loop;
		end if;
	end loop;
	
		
      -- insert stimulus here 

      wait;
   end process;

END;
