----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:53:37 10/31/2013 
-- Design Name: 
-- Module Name:    DCM_CLOCK - Behavioral 
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

library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCM_CLOCK is
	Port ( 	    CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_60MHz_o : out STD_LOGIC;
				EN_30MHz_o : out STD_LOGIC;
				EN_10MHz_o : out STD_LOGIC;
				EN_1MHz_o : out STD_LOGIC;
				EN_100kHz_o: out std_logic;	
				EN_10kHz_o: out std_logic;
				CLK_56_25MHz_o: std_Logic				
			);
end DCM_CLOCK;


architecture Behavioral of DCM_CLOCK is


signal s_30MHz_en, s_10MHz_en, s_1MHz_en, s_100kHz_en, s_10kHz_en : std_logic := '0';
signal s_clk_60MHz_buf : std_logic;
signal s_clk_fb, s_clk_fb_buf : std_logic;
signal clk_60MHz : std_logic;
signal s_1MHz_en_cnt, s_10kHz_en_cnt s_100kHz_en_cnt, s_10MHz_en_cnt : integer range 0 to 100_000 := 0;
signal CLKFX: std_logic; 


begin




 DCM_CLKGEN_inst_0 : DCM_CLKGEN
   generic map (
      CLKFXDV_DIVIDE => 1,       -- CLKFXDV divide value (2, 4, 8, 16, 32)
      CLKFX_DIVIDE => 2,         -- Divide value - D - (1-256)
      CLKFX_MD_MAX => 1.5,       -- Specify maximum M/D ratio for timing anlysis
      CLKFX_MULTIPLY => 3,       -- Multiply value - M - (2-256)
      CLKIN_PERIOD => 23.0,       -- Input clock period specified in nS
      SPREAD_SPECTRUM => "NONE", -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD" or "CENTER_HIGH_SPREAD" 
      STARTUP_WAIT => FALSE      -- Delay config DONE until DCM LOCKED (TRUE/FALSE)
   )
   port map (
      CLKFX => CLKFX,         -- 1-bit Generated clock output
      CLKFX180 => open,       -- 1-bit Generated clock output 180 degree out of phase from CLKFX.
      CLKFXDV => open,        -- 1-bit Divided clock output
      LOCKED => open,      -- 1-bit Locked output
      PROGDONE => open,		   -- 1-bit Active high output to indicate the successful re-programming
      STATUS => open,  		   -- 2-bit DCM status
      CLKIN => CLK_37MHZ_i,         -- 1-bit Input clock
      FREEZEDCM => '0', 			-- 1-bit Prevents frequency adjustments to input clock
      PROGCLK => '0', 				-- 1-bit Clock input for M/D reconfiguration
      PROGDATA => '0', 				-- 1-bit Serial data input for M/D reconfiguration
      PROGEN => '0', 				-- 1-bit Active high program enable
      RST => reset 					-- 1-bit Reset input pin
   );

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => CLK_56_25MHz_o,  I => clkfx); -- 3 * 37.5/2 = 56.25MHz
   
   
   

-- DCM Instantiation multiply input (37,5MHZ) by 8 (300MHZ) and divide by 5 (60 MHz)
   
   DCM_inst_1 : DCM
   generic map (
      CLKDV_DIVIDE => 8.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 5,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 8, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 26.666,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      SIM_MODE => "SAFE", -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
                          -- Design Guide" for details
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 => s_clk_fb,     -- 0 degree DCM CLK ouptput
      CLK180 => open, -- 180 degree DCM CLK output
      CLK270 => open, -- 270 degree DCM CLK output
      CLK2X => open,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => clk_60MHz,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, -- 180 degree CLK synthesis out
      LOCKED => open, -- DCM LOCK status output
      PSDONE => open, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => s_clk_fb_buf,   -- DCM clock feedback
      CLKIN => CLK_37MHZ_i,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   -- Dynamic phase adjust clock input
      PSEN => '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
      RST => RST_i        -- DCM asynchronous reset input
   );
	

    -- clock feedback
	s_clk_fb_buf <= s_clk_fb;
	
    BUFG_60MHz : BUFG
    port map ( O => s_clk_60MHz_buf,  I => clk_60MHz); 
	CLK_60MHZ_o <= s_clk_60MHz_buf;	
   --s_clk_60MHz_buf <= clk_60MHz;
   
   
   	BUFG_10MHz : BUFG
    port map ( O => EN_10MHz_o,  I => s_10MHz_en); 
	--EN_10MHz_o <= s_10MHz_en; 

   	BUFG_30MHz : BUFG
    port map ( O => EN_30MHZ_o,  I => s_30MHz_en); 	
	--EN_30MHZ_o <= s_30MHz_en;
	
	
	BUFG_1MHz : BUFG
    port map ( O => EN_1MHZ_o,  I => s_1MHz_en); 
	--EN_1MHZ_o <= s_1MHz_en;
	
	
	BUFG_100kHz : BUFG
    port map ( O => EN_100kHz_o,  I => s_100kHz_en); 
	--EN_100kHz_o <= s_100kHz_en;
	
	BUFG_10kHz : BUFG
    port map ( O => EN_10kHz_o,  I => s_10kHz_en); 
	--EN_10kHz_o <= s_10kHz_en;
	

	

	process (s_clk_60MHz_buf, RST_i) 
	begin
	
		if rising_edge(s_clk_60MHz_buf) then
	
			s_30MHz_en <= not(s_30MHz_en); 				-- Assures 30MHz enable signal is 0 every cycle

			---------------------------------------------------
			
			s_10MHz_en <= '0'; 								-- Assures 10MHz enable signal is 0 every cycle
			
			if (s_10MHz_en_cnt = 9) then 					-- If counter has reached 9
				s_10MHz_en_cnt <= 0; 						-- Set counter to 0
				s_10MHz_en <= '1'; 							-- Set enable signal to 1
			else
				s_10MHz_en_cnt <= s_10MHz_en_cnt + 1; 	-- Increase 10MHz enable counter
			end if;
			
			---------------------------------------------------
			
			s_1MHz_en <= '0'; 								-- Assures 1MHz enable signal is 0 every cycle
			
			if (s_1MHz_en_cnt = 59) then 					
				s_1MHz_en_cnt <= 0; 							-- Set counter to 0
				s_1MHz_en <= '1'; 							-- Set enable signal to 1
			else
				s_1MHz_en_cnt <= s_1MHz_en_cnt + 1; 	-- Increase 1MHz enable counter
			end if;
			
			s_100kHz_en <= '0';
			
			if (s_100kHz_en_cnt = 599) then 					-
				s_100kHz_en_cnt <= 0; 							-- Set counter to 0
				s_100kHz_en <= '1'; 							-- Set enable signal to 1
			else
				s_100kHz_en_cnt <= s_100kHz_en_cnt + 1; 	
			end if;
			
			
			s_10kHz_en <= '0';
			
			if (s_10kHz_en_cnt = 5999) then 					
				s_10kHz_en_cnt <= 0; 							-- Set counter to 0
				s_10kHz_en <= '1'; 							-- Set enable signal to 1
			else
				s_10kHz_en_cnt <= s_10kHz_en_cnt + 1; 	
			end if;
			
			
			
		end if;
	end process;

end Behavioral;
