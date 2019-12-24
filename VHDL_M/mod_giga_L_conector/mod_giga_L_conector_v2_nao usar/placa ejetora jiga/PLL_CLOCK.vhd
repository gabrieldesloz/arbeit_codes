----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:33 09/11/2013 
-- Design Name: 
-- Module Name:    PLL_CLOCK - Behavioral 
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

entity PLL_CLOCK is
	Port ( 	CLK_37MHZ_i : in STD_LOGIC;
				RST_i : in STD_LOGIC;
				CLK_1MHZ_o : out STD_LOGIC;
				CLK_10MHZ_o : out STD_LOGIC
			);
end PLL_CLOCK;

architecture Behavioral of PLL_CLOCK is
signal clk_10MHz, clk_1MHz : std_logic;
signal s_clk_10MHz_buf : std_logic;
signal s_clk_fb, s_locked, s_inv_locked, s_clk_fb_buf : std_logic;
signal s_1MHz_cnt : integer range 0 to 32;

begin

   PLL_BASE_inst : PLL_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",             -- "HIGH", "LOW" or "OPTIMIZED" 
      CLKFBOUT_MULT => 16,                  -- Multiply value for all CLKOUT clock outputs (1-64)
      CLKFBOUT_PHASE => 0.0,                -- Phase offset in degrees of the clock feedback output
                                            -- (0.0-360.0).
      CLKIN_PERIOD => 26.666,               -- Input clock period in ns to ps resolution (i.e. 33.333 is 30
                                            -- MHz).
      -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for CLKOUT# clock output (1-128)
      CLKOUT0_DIVIDE => 60,
      CLKOUT1_DIVIDE => 1,
      CLKOUT2_DIVIDE => 1,
      CLKOUT3_DIVIDE => 1,
      CLKOUT4_DIVIDE => 1,
      CLKOUT5_DIVIDE => 1,
      -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for CLKOUT# clock output (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      CLKOUT3_DUTY_CYCLE => 0.5,
      CLKOUT4_DUTY_CYCLE => 0.5,
      CLKOUT5_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT5_PHASE: Output phase relationship for CLKOUT# clock output (-360.0-360.0).
      CLKOUT0_PHASE => 0.0,
      CLKOUT1_PHASE => 0.0,
      CLKOUT2_PHASE => 0.0,
      CLKOUT3_PHASE => 0.0,
      CLKOUT4_PHASE => 0.0,
      CLKOUT5_PHASE => 0.0,
      CLK_FEEDBACK => "CLKFBOUT",           -- Clock source to drive CLKFBIN ("CLKFBOUT" or "CLKOUT0")
      COMPENSATION => "SYSTEM_SYNCHRONOUS", -- "SYSTEM_SYNCHRONOUS", "SOURCE_SYNCHRONOUS", "EXTERNAL" 
      DIVCLK_DIVIDE => 1,                   -- Division value for all output clocks (1-52)
      REF_JITTER => 0.1,                    -- Reference Clock Jitter in UI (0.000-0.999).
      RESET_ON_LOSS_OF_LOCK => FALSE        -- Must be set to FALSE
   )
   port map (
      CLKFBOUT => s_clk_fb, 				-- 1-bit output: PLL_BASE feedback output
      -- CLKOUT0 - CLKOUT5: 1-bit (each) output: Clock outputs
      CLKOUT0 => clk_10MHz,
      CLKOUT1 => open,
      CLKOUT2 => open,
      CLKOUT3 => open,
      CLKOUT4 => open,
      CLKOUT5 => open,
      LOCKED => s_locked,     			-- 1-bit output: PLL_BASE lock status output
      CLKFBIN => s_clk_fb_buf,   		-- 1-bit input: Feedback clock input
      CLKIN => CLK_37MHZ_i,       		-- 1-bit input: Clock input
      RST => RST_i            			-- 1-bit input: Reset input
   );
	
   BUFG_10MHz : BUFG
   port map ( O => s_clk_10MHz_buf,  I => clk_10MHz); -- CLKDV_DIVIDE = 2 = 9.375 MHz
	
	CLK_10MHZ_o <= s_clk_10MHz_buf;
	
   BUFG_1MHz : BUFG
   port map ( O => CLK_1MHZ_o,  I => clk_1MHz); -- clk_56MHz / 23 = 1.00446 MHz
	
   BUFG_clk_fb : BUFG
   port map ( O => s_clk_fb_buf,  I => s_clk_fb); -- DIV_BY_2 TRUE * 2 = 37.5 MHz

-----------------------------------------------------------------------------------------
	process (s_clk_10MHz_buf, RST_i) 
	begin
		if RST_i = '1' then
			s_1MHz_cnt <= 0;
			clk_1MHz <= '0';
		elsif rising_edge(s_clk_10MHz_buf) then

			s_1MHz_cnt <= s_1MHz_cnt + 1; 
			if (s_1MHz_cnt = 4) then 
				s_1MHz_cnt <= 0; 
				clk_1MHz <= not(clk_1MHz); 
			end if;

		end if;
	end process;

end Behavioral;
