--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:52:39 09/06/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_MAX_CH_MEAN.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MAX_CHX_MEAN
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
 
ENTITY TB_MAX_CH_MEAN IS
END TB_MAX_CH_MEAN;
 
ARCHITECTURE behavior OF TB_MAX_CH_MEAN IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAX_CHX_MEAN
    Port ( REFLECT_MEAN_i : in  STD_LOGIC_VECTOR (63 downto 0);
			  TRANSLUC_MEAN_i : in  STD_LOGIC_VECTOR (63 downto 0);
			  EJETA_i : in STD_LOGIC_VECTOR(4 downto 0);
			  EJETB_i : in STD_LOGIC_VECTOR(4 downto 0);
           ADDR_RD_i : in  STD_LOGIC_VECTOR (4 downto 0);
			  POX_i : in  STD_LOGIC_VECTOR (7 downto 0);
			  BOUNDARIES_A_i : in STD_LOGIC_VECTOR (15 downto 0);
			  BOUNDARIES_B_i : in STD_LOGIC_VECTOR (15 downto 0);
			  GEN_TAB_i : in std_logic;
			  CANMAX_i : in STD_LOGIC;
			  IS_EXTACCESS_i : in std_logic;
			  GAIN_OR_MEAN_i : in  STD_LOGIC;
			  IS_FLOOR_i : in std_logic;
			  CLK_i : in  STD_LOGIC;
			  CLK_INV_i : in STD_LOGIC;
           RST_i : in  STD_LOGIC;
           MAX_A_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  MAX_B_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  GEN_TAB_CLR_o : out std_logic;
			  DEBUG_o : out std_logic_vector(63 downto 0);
			  TABLE_READY_o : out STD_LOGIC);
    END COMPONENT;
    

   --Inputs
   signal REFLECT_MEAN_i : std_logic_vector(63 downto 0) := (others => '0');
   signal TRANSLUC_MEAN_i : std_logic_vector(63 downto 0) := (others => '0');
   signal EJETA_i : std_logic_vector(4 downto 0) := (others => '0');
	signal EJETB_i : std_logic_vector(4 downto 0) := (others => '0');
   signal ADDR_RD_i : std_logic_vector(4 downto 0) := (others => '0');
   signal POX_i : std_logic_vector(7 downto 0) := (others => '0');
   signal BOUNDARIES_A_i : std_logic_vector(15 downto 0) := (others => '0');
	signal BOUNDARIES_B_i : std_logic_vector(15 downto 0) := (others => '0');
   signal GEN_TAB_i : std_logic := '0';
   signal CANMAX_i : std_logic := '0';
   signal IS_EXTACCESS_i : std_logic := '0';
   signal GAIN_OR_MEAN_i : std_logic := '0';
   signal IS_FLOOR_i : std_logic := '0';
   signal CLK_i : std_logic := '0';
   signal CLK_INV_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal MAX_A_o : std_logic_vector(63 downto 0);
   signal MAX_B_o : std_logic_vector(63 downto 0);
	signal DEBUG_o : std_logic_vector(63 downto 0);
	
   signal GEN_TAB_CLR_o : std_logic;
   signal TABLE_READY_o : std_logic;

   -- Clock period definitions
   constant CLK_i_period : time := 1 ns;
   constant CLK_INV_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MAX_CHX_MEAN PORT MAP (
          REFLECT_MEAN_i => REFLECT_MEAN_i,
          TRANSLUC_MEAN_i => TRANSLUC_MEAN_i,
          EJETA_i => EJETA_i,
			 EJETB_i => EJETB_i,
          ADDR_RD_i => ADDR_RD_i,
          POX_i => POX_i,
          BOUNDARIES_A_i => BOUNDARIES_A_i,
			 BOUNDARIES_B_i => BOUNDARIES_B_i,
          GEN_TAB_i => GEN_TAB_i,
          CANMAX_i => CANMAX_i,
          IS_EXTACCESS_i => IS_EXTACCESS_i,
          GAIN_OR_MEAN_i => GAIN_OR_MEAN_i,
          IS_FLOOR_i => IS_FLOOR_i,
          CLK_i => CLK_i,
          CLK_INV_i => CLK_INV_i,
          RST_i => RST_i,
          MAX_A_o => MAX_A_o,
          MAX_B_o => MAX_B_o,
          GEN_TAB_CLR_o => GEN_TAB_CLR_o,
			 DEBUG_o => DEBUG_o,
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
		BOUNDARIES_A_i <= "00000011" & "11111100";
		BOUNDARIES_B_i <= "00000011" & "11111100";
		REFLECT_MEAN_i <= "1111111111111111" & "1111111111111111" & "1111111111111111" & "1111111111111111";
		TRANSLUC_MEAN_i <= "1111111111111111" & "1111111111111111" & "1111111111111111" & "1111111111111111";
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		GEN_TAB_i  <= '1';
		
		RST_i <= '0';
		
		for i in 0 to 31 loop
		 for i in 0 to 8 loop
			CANMAX_i <= '1';
			wait for CLK_i_period*4;
			CANMAX_i <= '0';
			wait for CLK_i_period*32;
			POX_i <= POX_i + '1';
		 end loop;
			EJETA_i <= EJETA_i + '1';
			EJETB_i <= EJETB_i + '1';
		end loop;
		IS_EXTACCESS_i <= '1';
		GEN_TAB_i  <= '0';
		
		wait for 100 ns;	
		
		IS_EXTACCESS_i <= '1';
		
		wait for 2 ns;
		
		for i in 0 to 31 loop
			wait for 2 ns;
			ADDR_RD_i <= ADDR_RD_i + '1';
		end loop;
		
		wait for 100 ns;
		
		GAIN_OR_MEAN_i <= '1';
		
		wait for 2 ns;
		
		for i in 0 to 31 loop
			wait for 2 ns;
			ADDR_RD_i <= ADDR_RD_i + '1';
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
