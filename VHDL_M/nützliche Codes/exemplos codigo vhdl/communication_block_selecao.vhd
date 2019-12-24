  -- serial communication output
  comm_uart : block is
  
   constant N_WORDS: natural := 8;
   constant LF: std_logic_vector(7 downto 0) := "00001010"; -- LINE FEED
   constant CR: std_logic_vector(7 downto 0) := "00001101"; -- CARRIAGE RETURNO
   constant ONE: std_logic_vector(7 downto 0) := "00110001"; -- um
   constant ZERO: std_logic_vector(7 downto 0) := "00110000"; -- zero
   
   
   
   signal s_sys_clock: std_logic;    
   signal s_uart_clk: std_logic;    
   signal s_TX: std_logic;    
   signal reset: std_logic;    
   signal DATA: std_logic_vector((N_WORDS*8)-1 downto 0);
	signal s_send: std_logic;   
   
  type   IN_ARRAY_TYPE is array (integer range <>) of std_logic_vector(8-1 downto 0);
  signal in_array_s : IN_ARRAY_TYPE(0 to N_WORDS-1);
   
    
  begin
  
  
  ---trigger
  
  
  
    
  --INPUT
  s_sys_clock <= s_clk_60MHz;   
  reset <= s_reset; 
  s_send <= '1';
  
  in_array_s(0) <= CR;
  in_array_s(1) <= LF;
  in_array_s(2) <= ONE when dcmrst = '1' else ZERO;
  in_array_s(3) <= ONE when dcmlocked = '1' else ZERO;
  in_array_s(4) <= ONE when dcmstatus(0) = '1' else ZERO;
  in_array_s(5) <= ONE when dcmstatus(1) = '1' else ZERO;
  in_array_s(6) <= ZERO;
  in_array_s(7) <= ZERO;
  
  
  --- output
	EX_IO_FPGA1(7 downto 2) <= "00000" & s_TX;   
    
  -- matrix -> 	 
	process(in_array_s)
		begin
			for i in (N_WORDS - 1) downto 0 loop
				DATA(((i+1)*8)-1 downto i*8) <= in_array_s(i);
			end loop;
	end process;
  
  tx_controller : entity work.serial_tx_controller
    generic map(
	 N_WORDS => N_WORDS,
      DATA_i_WIDTH => N_WORDS*8) 		
    port map (
		START_i  => s_send,
		CLK_i    => s_sys_clock,
		CLK_EN_i => s_uart_clk,
		RST_i    => reset,
		DATA_i   => DATA,
		TX_o     => s_TX,
		SENT_o   => open
      );  
  
  clk_division: entity work.clock_div 
	  generic map(
		divider =>  46875 -- 2400		
		)

	  port map (
		clock => s_sys_clock,
		q     => open,
		carry => s_uart_clk,
		ena   => '1',
		reset => reset
		);
		
  end block;