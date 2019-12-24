TRIGGER : block is
		
	constant MAX_LIMIT : integer := 100_000_000; -- 3,34 s 	
    signal timer_reg : integer;	
	signal reset_counter: std_logic;
	--SIGNAL conditions_ok: STD_LOGIC;	
	
      begin	

    SEND_DATA : process(s_clk_60MHz, s_reset)
      variable state_counter  : natural range 0 to 10	:= 0;
    begin
      
      if s_reset = '1' then
		state_counter  := 0;
		reset_counter <= '1';
		conditions_ok <= '0';
		timer_reg <= 0;
	
      elsif rising_edge(s_clk_60MHz) then	
		
		
		
		if timer_reg = 	MAX_LIMIT  then 
		    timer_reg <= 0;
			state_counter := 0;	
		end if;
		
		if reset_counter = '1' then 
			timer_reg <= 0;
		else 
			timer_reg <= timer_reg + 1;
		end if;
		
		reset_counter <= '0';
		state_counter  := state_counter;
		conditions_ok <= '0';

			case state_counter is
			  when 0 =>				
			  
			    if command_from_master = x"16" then
					reset_counter <= '1';
					state_counter  := state_counter + 1;
				end if;
				

			  when 1 =>			
			  
			  if data_from_master = "0000000000000000000000000000001" then 
			    reset_counter <= '1';				
				state_counter := state_counter + 1;
			  end if; 	

			  when 2 =>	
				 state_counter := state_counter + 1;				

			  when 3 =>			-- END
				conditions_ok <= '1';

			  when others => null;
					 
			end case;
      end if;
    end process SEND_DATA;

	
	
  end block TRIGGER;  
  
  
  
  TRIGGER : block is
		
		constant MAX_LIMIT : integer := 200_000_000; -- 3,34 s 	
		signal timer_reg : integer;	
		signal reset_counter: std_logic;
		--SIGNAL conditions_ok: STD_LOGIC;	
		
		  begin	

	SEND_DATA : process(s_clk_60MHz, s_reset)
		begin
		  
		  if s_reset = '1' then
		
			reset_counter <= '0';
			conditions_ok <= '0';
			timer_reg <= 0;
		
		  elsif rising_edge(s_clk_60MHz) then	
			
			if timer_reg = 	MAX_LIMIT  then 
				timer_reg <= 0;
				conditions_ok <= '0';
			end if;
			
			if reset_counter = '1' then 
				timer_reg <= 0;
			else 
				timer_reg <= timer_reg + 1;
			end if;
			
			reset_counter <= '0';			
			
			if R_COMP(0) = '1' then
				reset_counter <= '1';
				conditions_ok <= '1';
			end if;
		end if;	
			
end process SEND_DATA;

end block TRIGGER; 