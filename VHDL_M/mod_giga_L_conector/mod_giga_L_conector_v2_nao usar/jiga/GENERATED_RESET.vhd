----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:07:00 09/11/2013 
-- Design Name: 
-- Module Name:    GENERATED_RESET - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity GENERATED_RESET is
    Port ( CLK_37MHz_i : in  STD_LOGIC;
           RESET_o : out  STD_LOGIC);
end GENERATED_RESET;

architecture Behavioral of GENERATED_RESET is
signal s_reset_cnt : integer range 0 to 4194303;
signal s_reset : std_logic;
begin

	process(CLK_37MHz_i) 
	begin
		if rising_edge(CLK_37MHz_i) then
			if (s_reset_cnt = 3750000) then
				RESET_o <= '0';
			else
				RESET_o <= '1';
				s_reset_cnt <= s_reset_cnt + 1;
			end if;
		end if;
	end process;

end Behavioral;