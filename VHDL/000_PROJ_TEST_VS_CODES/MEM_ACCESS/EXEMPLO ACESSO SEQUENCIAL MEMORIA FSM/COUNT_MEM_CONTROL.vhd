----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    08:33:34 06/12/2012 
-- Design Name:    Counter memory controller
-- Module Name:    COUNT_MEM_CONTROL - Behavioral 
-- Project Name: 	 EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description:    Ejection count chopper memory controller
--
-- Dependencies:   COUNT_CHOPPER.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Is responsible for controlling the memory and giving
--								the address that is being taken care at the moment
--								Uses a sampling frequency of 1MHz / 32 ~= 31.25KHz and this
--								is to be 4x the lower valve frequency ~= 7KHz
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

entity COUNT_MEM_CONTROL is
    Port ( COUNT_i : in  STD_LOGIC_VECTOR (19 downto 0);				-- Memory output counter
			  MAX_FLAG_i : in  STD_LOGIC;										-- Flag that shows the counter reached maximum value (MAX_COUNT)
           C1MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  MAX_FLAG_o : out  STD_LOGIC;									-- Flag that shows the counter reached maximum value (MAX_COUNT)
			  CURRENT_VALVE_o : out  std_logic_vector (4 downto 0);	-- The current valve being read by the memory controller
           COUNT_o : out  STD_LOGIC_VECTOR (19 downto 0));			-- Memory output counter
end COUNT_MEM_CONTROL;

architecture Behavioral of COUNT_MEM_CONTROL is
signal s_valve, s_last_valve : std_logic_vector(4 downto 0);
signal s_mem_in, s_mem_out : std_logic_vector(31 downto 0);

-------------------------------------------------
------------ MEM_32x32 Counter Memory -----------
-------------------------------------------------
COMPONENT MEM_32x32
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-------------------------------------------------

begin

	CURRENT_VALVE_o <= s_valve;	-- Output receives memory address to address 64 bit valve vector (valverx)

	process(RST_i, C1MHZ_i)
	begin
		if rising_edge(C1MHZ_i) then				-- 1 MHz clock input rising edge
			if (RST_i = '1') then					-- If there is a reset signal
				s_valve <= (others => '0');		-- Reset memory address and valve index
				s_last_valve <= (others => '0');	-- Reset memory address and valve index
			else											-- If there is no reset
				s_valve <= s_valve + 1;				-- Increment memory address and valve index
				s_last_valve <= s_valve;			-- Write address is the last 
			end if;
		end if;
	end process;

-------------------------------------------------
-------------- 32x32 Counter Memory -------------
-------------------------------------------------
	s_mem_in <= MAX_FLAG_i & "00000000000" & COUNT_i;		-- A concatenation to the memory input
	COUNT_o <= s_mem_out(19 downto 0);							-- Set the lower 15 bits to the module counter output
	MAX_FLAG_o <= s_mem_out(31);									-- Set the MSB to the module maximum flag output

	COUNTER_MEM_32x32 : MEM_32x32
	  PORT MAP (	
		 clka => C1MHZ_i,								-- 1 MHz clock input
		 wea => "1",									-- Always enabled
		 addra => s_last_valve,						-- Write memory address using last valve index (to read the right address)
		 dina => s_mem_in,							-- Input is MAX_FLAG and the counter from COUNT_CHOPPER module
		 clkb => C1MHZ_i,								-- 1 MHz clock input
		 addrb => s_valve,							-- Read memory address using valve index
		 doutb => s_mem_out							-- Counter memory output
	  );
-------------------------------------------------

end Behavioral;