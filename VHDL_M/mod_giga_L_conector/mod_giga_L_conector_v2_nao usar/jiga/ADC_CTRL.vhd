----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:22 09/20/2013 
-- Design Name: 
-- Module Name:    ADC_CTRL - Behavioral 
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

entity ADC_CTRL is
    Port ( ENABLE_i : in  STD_LOGIC;									-- Enables the module and starts the ADC read
	 
			  -- Configuration control flag
           SEND_PGA_i : in  STD_LOGIC;									-- Sends new serial PGA data
			  
			  -- Serial configuration interface
           PGA1_RED_i : in  STD_LOGIC_VECTOR (5 downto 0);		-- PGA data configuration for red input (CCD1 / CHUTE A FRONT CAM)
           PGA1_GREEN_i : in  STD_LOGIC_VECTOR (5 downto 0);	-- PGA data configuration for green input (CCD2 / CHUTE A REAR CAM)
			  
			  -- ADC output
           ADC1_2_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);	-- ADC output data (8 bits at a time with High byte first)
			  
			  CLK1_i : in  STD_LOGIC;										-- 1 MHz input clock
			  CLK60_i : in  STD_LOGIC;										-- 56.25 MHz input clock
			  RESET_i : in  STD_LOGIC;										-- Reset signal
			  			  
			  -- ADC control
			  ADC1_OEB_o : out STD_LOGIC;									-- ADC Output enable 
			  ADC1_CLK_o : out STD_LOGIC;									-- ADC clock
			  ADC1_CDSCLK1_o : out STD_LOGIC;							-- ADC Reference level sampler (NOT USED IN SHA MODE)
			  ADC1_CDSCLK2_o : out STD_LOGIC;							-- ADC Data level sampler
			  
			  -- Serial configuration interface
			  ADC_1_2_SDATA : out STD_LOGIC;								-- ADC 1 serial configuration data
			  ADC1_SCLK_o : out STD_LOGIC;								-- ADC Serial clock
			  ADC1_SLOAD_o : out STD_LOGIC;								-- ADC Serial write enable (Active low when writing)
			  
			  -- ADC data output
			  ADC1_RED_o : out STD_LOGIC_VECTOR(13 downto 0);		-- ADC red data output (CCD1 / CHUTE A FRONT CAM)
			  ADC1_GREEN_o : out STD_LOGIC_VECTOR(13 downto 0)		-- ADC green data output (CCD2 / CHUTE A REAR CAM)
			  );
end ADC_CTRL;

architecture Behavioral of ADC_CTRL is
---------------------------------------------
------------- Reads ADC data ----------------
---------------------------------------------
component ADC_READOUT
    Port ( ADC1_i : in  STD_LOGIC_VECTOR(7 downto 0);					-- 8 bits ADC output (14-bit one byte each time)
           ENABLE_i : in  STD_LOGIC;										-- Enables the reading process
			  
           CLK_i : in  STD_LOGIC;											-- 60 MHz clock
           RESET_i : in  STD_LOGIC;									
			  
           ADC_OEB_o : out  STD_LOGIC;										-- Output enable (always 0)
           ADCCLK_o : out  STD_LOGIC;										-- ADC clock 
           CDSCLK1_o : out  STD_LOGIC;										-- CDS for CDS mode (NOT USED IN 
           CDSCLK2_o : out  STD_LOGIC;										-- Controls the SHA sampling point
				
           ADC1_RED_o : out  STD_LOGIC_VECTOR (13 downto 0);		-- ADC 1 Red sample
           ADC1_GREEN_o : out  STD_LOGIC_VECTOR (13 downto 0));	-- ADC 1 Green sample
end component;
---------------------------------------------
------------- Configures ADC ----------------
---------------------------------------------
component ADC_CONFIGURATION
    Port ( PGA1_RED_i : 	in  STD_LOGIC_VECTOR (5 downto 0);	-- PGA data configuration for red input (CCD1 / CHUTE A FRONT CAM)
           PGA1_GREEN_i : 	in  STD_LOGIC_VECTOR (5 downto 0);	-- PGA data configuration for green input (CCD2 / CHUTE A REAR CAM)
           SEND_PGA_i : 	in  STD_LOGIC;								-- Sends new serial PGA data
           CLK_i : 			in  STD_LOGIC;								-- 1 MHz input clock
           RESET_i : 		in  STD_LOGIC;										
			  
           ADC_1_2_SDATA : out STD_LOGIC;								-- ADC 1 serial configuration data
			  ADC_SCLK : 		out STD_LOGIC;								-- ADC Serial clock
			  ADC_SLOAD : 		out STD_LOGIC);							-- ADC Serial write enable (Active low when writing)
end component;
---------------------------------------------
signal s_adc_oeb, s_adcclk, s_adc_cdsclk1, s_adc_cdsclk2 : std_logic;
signal s_adc_sclk, s_adc_sload : std_logic;
begin

i_ADC_READOUT : ADC_READOUT
    Port map( 
			  ADC1_i => ADC1_2_DATA_i,
           ENABLE_i => ENABLE_i,
			  
           CLK_i => CLK60_i,
           RESET_i => RESET_i,
			  
           ADC_OEB_o => s_adc_oeb,
           ADCCLK_o => s_adcclk,
           CDSCLK1_o => s_adc_cdsclk1,
           CDSCLK2_o => s_adc_cdsclk2,
			  
           ADC1_RED_o => ADC1_RED_o,
           ADC1_GREEN_o => ADC1_GREEN_o
			  );
			  
-- ADC control
ADC1_OEB_o <= s_adc_oeb;
ADC1_CLK_o <= s_adcclk;
ADC1_CDSCLK1_o <= s_adc_cdsclk1;
ADC1_CDSCLK2_o <= s_adc_cdsclk2;
		  
i_ADC_CONFIGURATION : ADC_CONFIGURATION
    Port map( 
			  PGA1_RED_i => PGA1_RED_i,
           PGA1_GREEN_i => PGA1_GREEN_i,
           SEND_PGA_i => SEND_PGA_i,
           CLK_i => CLK1_i,
           RESET_i => RESET_i,
			  
           ADC_1_2_SDATA => ADC_1_2_SDATA,
			  ADC_SCLK => s_adc_sclk,
			  ADC_SLOAD => s_adc_sload
			  );

-- Serial configuration interface
ADC1_SLOAD_o <= s_adc_sload;

-- ODDR for SCLK outputs
ODDR2_ADC_SCLK1 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
		INIT => '0', -- Sets initial state of the Q output to '0' or '1'
		SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
	port map (
		Q => ADC1_SCLK_o, -- 1-bit output data
		C0 => s_adc_sclk, -- 1-bit clock input
		C1 => not(s_adc_sclk), -- 1-bit clock input
		CE => '1',  -- 1-bit clock enable input
		D0 => '1',   -- 1-bit data input (associated with C0)
		D1 => '0',   -- 1-bit data input (associated with C1)
		R => '0',    -- 1-bit reset input
		S => '0'     -- 1-bit set input
	);

end Behavioral;