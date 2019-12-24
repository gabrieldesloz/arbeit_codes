----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:03 03/13/2011 
-- Design Name: 
-- Module Name:    fail_detector - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity fail_detector is
    Port ( c10k : in  STD_LOGIC;
           vv : in  STD_LOGIC;
           sens : in  STD_LOGIC;
           fail : out  STD_LOGIC;
			  r1,r2 : in std_logic; -- any ZERO will reset the failure latch
           reset : in  STD_LOGIC);
end fail_detector;

architecture Behavioral of fail_detector is
signal mono : integer range 0 to 15;
signal a,b : std_logic;

begin
  process (c10k,vv,r1,r2)
  begin
    if (r1='0') or (r2='0') then
	    fail<='0';
    elsif vv='1' then 
	   mono<=9;
	   b<='1';
	 elsif rising_edge(c10k) and mono>0 then
	   mono<=mono-1;
	   if mono=1 then 
		   fail<=not a;
			b<='0';
		end if;
	 end if;
  end process;
  
  process (sens,b,reset,vv)
  begin
    if (reset='1')  or (vv='1') then
	    a<='0';
	 elsif falling_edge(sens) and b='1' then
	    a<='1';
	 end if;
  end process;

end Behavioral;

