----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    16:28:31 09/20/2012 
-- Design Name: 	 Tune memory controller
-- Module Name:    TUNE_MEM_CONTROL - Behavioral 
-- Project Name: 	 EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 This module is responsible for controlling the memory based on what is
--						 being received from the tune controller block
--
-- Dependencies:   TUNE_PLAYER.vhd
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

entity TUNE_MEM_CONTROL is
    Port ( REC_i : in  STD_LOGIC_VECTOR(0 downto 0);							-- Memory write enable
           REC_ADDR_i : in  STD_LOGIC_VECTOR (8 downto 0);					-- Recording address (0 - 510)
           PERIOD_i : in  STD_LOGIC_VECTOR (23 downto 0);					-- Tone period in 1us step
           NOTE_LENGTH_i : in  STD_LOGIC_VECTOR (39 downto 0);				-- Tone duration (length)
           ADDR_i : in  STD_LOGIC_VECTOR (8 downto 0);						-- Read address to the memory
           CLK_i : in  STD_LOGIC;													-- 1MHz clock
           PERIOD_MEM_o : out  STD_LOGIC_VECTOR (23 downto 0);				-- Current tone read from the memory
           NOTE_LENGTH_MEM_o : out  STD_LOGIC_VECTOR (39 downto 0));		-- Current tone duration (length)
end TUNE_MEM_CONTROL;

architecture Behavioral of TUNE_MEM_CONTROL is

signal s_memory_in, s_memory_out : std_logic_vector(63 downto 0);

COMPONENT MEM_512x64
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

begin

	s_memory_in <= NOTE_LENGTH_i & PERIOD_i;				-- Memory input bus
	
	PERIOD_MEM_o <= s_memory_out(23 downto 0);			-- First 24 bits are the tone period
	NOTE_LENGTH_MEM_o <= s_memory_out(63 downto 24);	-- Last 40 bits are the tone duration

	i_MEM_512x64 : MEM_512x64
	  PORT MAP (
		 clka => not(CLK_i),										-- On falling clock edge
		 wea => REC_i,
		 addra => REC_ADDR_i,
		 dina => s_memory_in,
		 clkb => not(CLK_i),										-- On falling clock edge
		 addrb => ADDR_i,
		 doutb => s_memory_out
	  );

end Behavioral;

