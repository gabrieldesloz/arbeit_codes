teste_uart: block 
-- nesse bloco é feito o "bypass" da comunicação serial 
-- vinda do Microcontrolador para as saídas de teste
	   signal s_L_RX: std_logic;
	   signal CLK_100MHz: std_logic;	
	   signal tx_ready: std_logic;
	   signal rx_enable: std_logic;
	   signal CLK_100MHz_div: std_logic;
	   signal rx_data: std_logic_vector(7 downto 0);
	   
		begin
			test(14) <= L_TX; -- from Luminay TX output 
			s_L_RX <= test(15); -- to Luminary Rx Input
		    L_RX  <= s_L_RX; 
			
			-- teste comunicacao
			test(0) <= L_TX;
			test(1) <= s_L_RX; 	
			
			
			--TEST(0) <= '0';
			--TEST(1) <= '0';
			TEST(2) <= '0';
			TEST(3) <= '0';
			TEST(4) <= '0';
			TEST(5) <= rx_enable;
			TEST(6) <= tx_ready;
			TEST(7) <= '1';
			TEST(8) <= '0';
			TEST(9) <= '0';
			TEST(10) <= CLK_100MHz_div;
			TEST(11) <= '0';
			--TEST(12) <= '0';
			TEST(13) <= '0';	
			--TEST(14) <= s_probe(2);
			--TEST(15) <= s_probe(1);
			
			
			
	   DCM_CLKGEN_inst_100MHz : DCM_CLKGEN
   generic map (
      CLKFXDV_DIVIDE => 32,       -- CLKFXDV divide value (2, 4, 8, 16, 32)
      CLKFX_DIVIDE => 3,         -- Divide value - D - (1-256)
      CLKFX_MD_MAX => 2.6,       -- Specify maximum M/D ratio for timing anlysis
      CLKFX_MULTIPLY => 8,       -- Multiply value - M - (2-256)
      CLKIN_PERIOD => 23.0,       -- Input clock period specified in nS
      SPREAD_SPECTRUM => "NONE", -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD" or "CENTER_HIGH_SPREAD" 
      STARTUP_WAIT => FALSE      -- Delay config DONE until DCM LOCKED (TRUE/FALSE)
   )
   port map (
      CLKFX => CLK_100MHz,         -- 1-bit Generated clock output
      CLKFX180 => open,   -- 1-bit Generated clock output 180 degree out of phase from CLKFX.
      CLKFXDV => CLK_100MHz_div,     -- 1-bit Divided clock output
      LOCKED => open, --test(1),      -- 1-bit Locked output
      PROGDONE => open,		   -- 1-bit Active high output to indicate the successful re-programming
      STATUS => open,  		   -- 2-bit DCM status
      CLKIN => CLK37mux,         -- 1-bit Input clock
      FREEZEDCM => '0', 			-- 1-bit Prevents frequency adjustments to input clock
      PROGCLK => '0', 				-- 1-bit Clock input for M/D reconfiguration
      PROGDATA => '0', 				-- 1-bit Serial data input for M/D reconfiguration
      PROGEN => '0', 				-- 1-bit Active high program enable
      RST => dcmrst 					-- 1-bit Reset input pin
   );
	
		
		
			
	basic_uart_1: entity work.basic_uart
		  generic map (
			DIVISOR => 2604)
			-- 9600 -> 651
		    -- 2400 -> 2604
		  port map (
			clk       => CLK_100MHz,
			reset     => dcmrst,
			rx_data   => rx_data, -- o
			rx_enable => rx_enable, -- o
			tx_data   => x"AA", -- in 
			tx_enable => '1', -- in 
			tx_ready  => tx_ready, -- o
			rx        => L_TX, -- i
			tx        => TEST(12)); -- o
		
	
end block teste_uart;