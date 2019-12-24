--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:49:39 08/10/2011
-- Design Name:   
-- Module Name:   C:/Carlos/Projetos/peakdetectorv2.1.2_OK/TB_MEM_ROMPIXVAL.vhd
-- Project Name:  peakdetectorv2.1.2_OK
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEM_ROMPIXVAL
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
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_MEM_ROMPIXVAL IS
END TB_MEM_ROMPIXVAL;
 
ARCHITECTURE behavior OF TB_MEM_ROMPIXVAL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEM_ROMPIXVAL
    PORT(
         clka : IN  std_logic;
         addra : IN  std_logic_vector(7 downto 0);
         douta : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clka : std_logic := '0';
   signal addra : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal douta : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clka_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEM_ROMPIXVAL PORT MAP (
          clka => clka,
          addra => addra,
          douta => douta
        );

   -- Clock process definitions
   clka_process :process
   begin
		clka <= '0';
		wait for clka_period/2;
		clka <= '1';
		wait for clka_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
    wait for 1 ns;
    addra <= X"00";  --reset the address value for reading from memory location "0"
    --reading all the 16 memory locations in the BRAM.
    for i in 0 to 255 loop
--        ena <= '1';  --Enable RAM always.
--        wea <= "0";
        wait for 2 ns;
        addra <= addra + '1';
    end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
