library UNISIM;
use UNISIM.VComponents.all;


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
