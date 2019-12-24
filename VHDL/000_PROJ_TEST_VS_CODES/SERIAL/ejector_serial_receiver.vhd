BUFG_1sc : BUFG
   port map ( O => cxc,  I => cx); -- local clock
	
	-- package detection	
   process (cx,rx, reset, serend)
	begin
	    if (reset='1') or (serend='1') then
		    serst<='0';
	    elsif rising_edge(rx) and cx='1' then
		    serst<='1';
			 -- set the parity bit here
           txs <= not (sys_status(34) xor sys_status(33) xor sys_status(32) xor sys_status(31) xor sys_status(30) xor sys_status(29) xor sys_status(28) xor sys_status(27) xor sys_status(26) xor 
							       sys_status(25) xor sys_status(24) xor sys_status(23) xor sys_status(22) xor sys_status(21) xor sys_status(20) xor sys_status(19) xor sys_status(18) xor sys_status(17) xor 
									 sys_status(16) xor sys_status(15) xor sys_status(14) xor sys_status(13) xor sys_status(12) xor sys_status(11) xor sys_status(10) xor sys_status(9)  xor sys_status(8) xor 
									 sys_status(7)  xor sys_status(6)  xor sys_status(5)  xor sys_status(4)  xor sys_status(3)  xor sys_status(2)  xor sys_status(1)  xor sys_status(0)) 
					             & sys_status;
		 end if;
	end process;

	
	
-- receiving machine
   process (cxc,serst)
	variable nrx:integer range 0 to 63;
	variable rxpar : std_logic;
	begin
	  if (reset='1') or (serst='0') then
	     nrx:=0;
		  serend<='0';
		  rxpar:='0';
		  signal_tick_clock_serial <= '0';
	  elsif rising_edge(cxc) then
		 signal_tick_clock_serial <= '0'; -- test signal to check serial max speed
		 rxs<=rxs(34 downto 0) & rx;
		 if nrx=36 then 
		    serend<='1'; 
		    rxpar := rxs(35) xor rxs(34) xor rxs(33) xor rxs(32) xor rxs(31) xor rxs(30) xor rxs(29) xor rxs(28) xor rxs(27) xor rxs(26) xor 
					    rxs(25) xor rxs(24) xor rxs(23) xor rxs(22) xor rxs(21) xor rxs(20) xor rxs(19) xor rxs(18) xor rxs(17) xor rxs(16) xor 
					    rxs(15) xor rxs(14) xor rxs(13) xor rxs(12) xor rxs(11) xor rxs(10) xor rxs(9)  xor rxs(8)  xor rxs(7)  xor rxs(6) xor 
		             rxs(5)  xor rxs(4)  xor rxs(3)  xor rxs(2)  xor rxs(1)  xor rxs(0); 						 
			 if rxpar='1' then
		       signal_tick_clock_serial <= '1'; -- test signal to check serial max speed
			   vdata <= rxs(31 downto 0);
		       command <= rxs(34 downto 32); -- 3 bit command
			else
			  command <= "000"; -- null command
          end if;			 
		 end if;
		 nrx:=nrx+1;
	  end if;
	end process;
	
	
	
	
	 process (serst,cxc,reset) -- clock must be a little faster than SCLK
	variable partype:std_logic_vector(2 downto 0);
	variable sc : integer range 0 to 7;
	begin
	  if (reset='1') then
	    on_time_top <= "0000000000001010"; -- Default max on = 5 seconds
	    on_time_bot <= "0000000000100000"; -- Default cooldown = 10 seconds
		 incval <= "0000000000000100"; 		-- Default Increase value = 4
		 decval <= "0000000000000010"; 		-- Default Decrease value = 2
       set34<='0';
		 currentlimit<=900; --880; --850;
		 sys_status <= "111" & "00000000000000000000000000000000";
		 
	  elsif falling_edge(cxc) and serst='0' then
	  
		 partype:=vdata(31 downto 29); -- get the 3 bits for parameter type to use in the CASE
       set34<='0';
		     sc:=sc+1;
			  case sc is
			   when 0 => sys_status <= "000" & not(s_fus);
			   when 1 => sys_status <= "001" & "00000000000000000000000000000000";
			   when 2 => sys_status <= "010" & fpga_version & "00001111" & "11111000" & "0000000" & venn; --s_cutoff_times(7 downto 0)
			   when 3 => sys_status <= "011" & s_valve_limiter; --ontimerst;
			   when 4 => sys_status <= "100" & "0000000000000000000000" & s_ad_ibus1_sens_mean;
			   when 5 => sys_status <= "101" & "0000000000000000000000" & s_ad_ibus2_sens_mean;
			   when 6 => sys_status <= "110" & "0000000000000000000000" & s_ad_12vin_sens_mean;
			   when 7 => sys_status <= "111" & "0000000000000000000000" & s_ad_34vin_sens_mean;
			   when others => sys_status <= "111" & "00000000000000000000000000000000";
			  end case;
	

		     case command is
			   when "001" => valverx(31 downto 0) <= vdata;
				
				when "011" => --on_time_top <= vdata(31 downto 16); -- 16 bits 400ms max
				              --on_time_bot <= vdata(15 downto 0); -- 16 bits 
				when "100" => --decval <= vdata(31 downto 16);
				              --incval <= vdata(15 downto 0); -- 
				when "101" => currentlimit<=CONV_INTEGER(vdata(15 downto 0));
			   when "110" => -- parameter setup
				              case partype is
								   when "001" => set34<='1';
								   when "010" => venbit <= vdata(0);
								   when others =>
								  end case;
				when others =>
			  end case;

	  end if;
	end process;
	
end Behavioral;
	