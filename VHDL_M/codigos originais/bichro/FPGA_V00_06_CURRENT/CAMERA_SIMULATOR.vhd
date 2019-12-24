----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:14:34 06/05/2013 
-- Design Name: 
-- Module Name:    CAMERA_SIMULATOR - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CAMERA_SIMULATOR is
    Port (  SI_i : in  STD_LOGIC;
				CLK_i : in  STD_LOGIC;
				RESET_i : in  STD_LOGIC;
				CCD_o : out  STD_LOGIC_VECTOR (7 downto 0));
end CAMERA_SIMULATOR;

architecture Behavioral of CAMERA_SIMULATOR is

signal s_ccd_o : std_logic_vector(7 downto 0);

begin

CCD_o <= s_ccd_o;

process(CLK_i,SI_i,RESET_i)
begin

	if rising_edge(CLK_i) then
		if (RESET_i = '1') or (SI_i = '1') then
			s_ccd_o <= "00000000";
		else
			s_ccd_o <= s_ccd_o + '1';
		end if;
	end if;
	
end process;

end Behavioral;

