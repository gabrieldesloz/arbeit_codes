--------------------------------------------------------------------------------
------------------------- Cascadde DCM to generate clock enables ------------------------
--------------------------------------------------------------------------------
  i_DCM_CLOCK : entity work.DCM_CLOCK
    port map (
      CLK_37MHZ_i => GCLK1, --CLK_37.5
	  CLK_37MHZ_buf_o => s_CLK_37MHZ_buf_o, -- CLK_37.5MHz buf
      RST_i       => s_reset_buf,
      CLK_60MHz_o => s_clk_60MHz,
      CLK_30MHz_o  => open, --s_en_30MHz,    
      EN_10MHz_o  => s_en_10MHz,
	  EN_9_375MHz_o => s_EN_9_375MHz,
      EN_1MHz_o   => s_en_1MHz,
      EN_100kHz_o => open, --s_en_100kHz,
	  EN_10kHz_o  => open, --s_en_10kHz,	
	  CLK_56MHz_o => s_CLK_56MHz_o,
	  DEBUG_o  	  => open
	  
      );
	    
		
		
		
