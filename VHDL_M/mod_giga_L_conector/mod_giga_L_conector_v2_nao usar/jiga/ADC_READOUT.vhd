----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:35 09/25/2013 
-- Design Name: 
-- Module Name:    ADC_READOUT - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity ADC_READOUT is
    Port ( ADC1_i : in  STD_LOGIC_VECTOR(7 downto 0);					-- 8 bits ADC output (14-bit one byte each time)
           ENABLE_i : in  STD_LOGIC;										-- Enables the reading process
			  
           CLK_i : in  STD_LOGIC;											-- 60 MHz clock
           RESET_i : in  STD_LOGIC;									
			  
           ADC_OEB_o : out  STD_LOGIC;										-- Output enable (always 0)
           ADCCLK_o : out  STD_LOGIC;										-- ADC clock 
           CDSCLK1_o : out  STD_LOGIC;										-- CDS for CDS mode (NOT USED IN 
           CDSCLK2_o : out  STD_LOGIC;										-- Controls the SHA sampling point
				
           ADC1_RED_o : out  STD_LOGIC_VECTOR (13 downto 0);		-- ADC 1 Red sample
           ADC1_GREEN_o : out  STD_LOGIC_VECTOR (13 downto 0)		-- ADC 1 Green sample
			  );	
end ADC_READOUT;

architecture Behavioral of ADC_READOUT is
type t_state is (st_LOW_BLUE, st_LOW_GREEN, st_LOW_RED, st_HIGH_BLUE, st_HIGH_GREEN, st_HIGH_RED);
signal s_state : t_state;
signal s_clk30MHz, s_clk15MHz : std_logic;
signal s_en_cdsclk2 : std_logic;
signal s_adc1_red, s_adc1_green : std_logic_vector(13 downto 0);

begin

FDCE_CLK30MHz : FDCE -- 60MHz Clock divider
generic map (
	INIT => '0') -- Initial value of register ('0' or '1')  
port map (
	Q => s_clk30MHz,      -- Data output
	C => CLK_i,      		 -- Clock input
	CE => '1',    			 -- Clock enable input
	CLR => RESET_i,  		 -- Asynchronous clear input
	D => not(s_clk30MHz)  -- Data input
);

FDCE_CLK15MHz : FDCE -- 30 MHz divider
generic map (
	INIT => '0') -- Initial value of register ('0' or '1')  
port map (
	Q => s_clk15MHz,      -- Data output
	C => not(s_clk30MHz), -- Clock input
	CE => '1',    			 -- Clock enable input
	CLR => RESET_i,  		 -- Asynchronous clear input
	D => not(s_clk15MHz)  -- Data input
);

--   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
-- _| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| 
-- Clock input - 60MHz
--     ___     ___     ___     ___     ___     ___     ___     ___
-- ___|   |___|   |___|   |___|   |___|   |___|   |___|   |___|   |___
-- System clock - 30MHz
--     ___                                             ___
-- ___|   |___________________________________________|   |___________
-- CDSCLK2
--         _______         _______         _______         _______
-- _______|       |_______|       |_______|       |_______|       |___
-- ADCCLK
-- _ _______ _______ _______ _______ _______ _______ _______ _______ _
-- _X__H-R__X__H-R__X__L-R__X__H-G__X__L-G__X__H-B__X__L-B__X__H-R__X_
-- ADC Out

ADC_OEB_o <= '0';
ADCCLK_o <= s_clk15MHz;
CDSCLK1_o <= '0';
CDSCLK2_o <= s_clk30MHz when (s_en_cdsclk2 = '1') else '0';

process(s_clk30MHz, RESET_i)
begin

	if falling_edge(s_clk30MHz) then
	
		if (RESET_i = '1') or (ENABLE_i = '0') then 												-- Stop state machine in case there is a 
																												-- reset or enable is inactive
			s_state <= st_LOW_BLUE;																		-- Initial state is receives low blue byte and
																												-- already has CDSCLK2 active
			s_en_cdsclk2 <= '0';																			-- By default CDSCLK2 is disabled
			
		else
			s_en_cdsclk2 <= '0';																			-- Assure that CDSCLK2 is enabled only 1 cycle
			
			case s_state is	
			
				when st_LOW_BLUE =>																		-- Low blue state receives low byte of blue input
											ADC1_RED_o <= s_adc1_red;									-- Receives the buffered data
											ADC1_GREEN_o <= s_adc1_green;
											
											s_state <= st_HIGH_RED;
				
				when st_HIGH_RED =>																		-- High red state receives high byte of red input
											s_adc1_red(13 downto 6) <= ADC1_i;						
											
											s_state <= st_LOW_RED;
											
				when st_LOW_RED =>																		-- Low red state receives low byte of red input
											s_adc1_red(5 downto 0) <= ADC1_i(5 downto 0);
											
											s_state <= st_HIGH_GREEN;
											
											
				when st_HIGH_GREEN =>																	-- High green state receives high byte of green input
											s_adc1_green(13 downto 6) <= ADC1_i;
											
											s_state <= st_LOW_GREEN;

											
				when st_LOW_GREEN =>																		-- Low green state receives low byte of green input
											s_adc1_green(5 downto 0) <= ADC1_i(5 downto 0);
											
											s_state <= st_HIGH_BLUE;
											
				when st_HIGH_BLUE =>																		-- High blue state receives high byte of blue input
											s_en_cdsclk2 <= '1';											-- Next state the CDSCLK2 will be active and process starts
											s_state <= st_LOW_BLUE;
											
			end case;
											
		end if;
	
	end if;

end process;

end Behavioral;