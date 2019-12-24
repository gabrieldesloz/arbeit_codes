chipscope_block: block  

		signal  CONTROL_c1: std_logic_vector(35 downto 0);
		signal  CLK_c1: std_logic;
		
		signal  SYNC_IN_c1: std_logic_vector(31 downto 0);
		signal  SYNC_IN_c2: std_logic_vector(31 downto 0);
		
		signal  SYNC_OUT_C1: std_logic_vector(31 downto 0);
		signal  SYNC_OUT_C2: std_logic_vector(31 downto 0);
		
		
		signal  CONTROL0: std_logic_vector(35 downto 0);
		signal  CONTROL1: std_logic_vector(35 downto 0);
		signal  CONTROL2: std_logic_vector(35 downto 0);
		signal  CONTROL3: std_logic_vector(35 downto 0);
		signal  CONTROL4: std_logic_vector(35 downto 0);
		
		signal  DATA_1:  std_logic_vector(31 downto 0);
		signal  DATA_2:  std_logic_vector(31 downto 0);
		
		signal TRIG0_1:  std_logic_vector(31 downto 0);
		signal TRIG0_2:  std_logic_vector(31 downto 0);
		
	begin
	
		TRIG0_2 <= (others => '0'); 
		TRIG0_1 <=  "00" & s_raw_front_a & "00" & s_raw_front_b;
		
		CLK_c1 		<= CLK_10MHz;
		SYNC_IN_c1  <= "00" & s_raw_front_a & "00" & s_raw_front_b;
		DATA_1 		<= "00" & s_raw_front_a & "00" & s_raw_front_b;  
		DATA_2 		<= "00" & s_raw_rear_a  & "00" & s_raw_rear_b;  
		
	
	c0: entity work.chipscope_icon 
	  port map(
		CONTROL0 => CONTROL0,
		CONTROL1 => CONTROL1,
		CONTROL2 => CONTROL2
		);

		
	c1: entity work.chipscope_vio 
	  port map (
		CONTROL 	=> CONTROL0, 
		CLK 		=> CLK_c1,
		SYNC_IN 	=> SYNC_IN_c1,
		SYNC_OUT 	=> open	
	);


	c2: entity  work.chipscope_ila 
	port map (
		CONTROL 	=> CONTROL1,
		CLK 		=> CLK_c1,
		DATA 		=> DATA_1,
		TRIG0 		=> TRIG0_1
		);
		
	c3: entity  work.chipscope_ila 
	port map (
		CONTROL 	=> CONTROL2,
		CLK			=> CLK_c1,
		DATA 		=> DATA_2,
		TRIG0 		=> TRIG0_2
		);	
	
	
end block;	