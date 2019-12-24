-- procediemnto pra leitura de 256 palavras da memoria  


signal ndump,andump,rqdumparea,arqdumparea,ndumpf, s_grabpix : std_logic_vector(7 downto 0);
signal extpart : std_logic_vector (1 downto 0); -- 00:cam_A front, 01: cam_A rear, 10:cam_B front, 11:cam_B rear
signal extevent_req,extevent_flag,extevent,extclr,exttype : std_logic; -- tipo de acesso



  when "000000000010" => lumstp<="000000000100";
			                        busy_clr<='0';
			  
			  
			  
			  
			  -- read 256 words from Front-End memory
						  when X"45"  => if busy_flag='0' then lumstp<="000000000010"; 
														else
															s_cmd_last <= cmd_reg(7 downto 0);
															s_cmd_last_1 <= s_cmd_last;
															s_cmd_last_2 <= s_cmd_last_1;
															s_cmd_last_3 <= s_cmd_last_2;
															s_cmd_last_4 <= s_cmd_last_3;

															LED1 <= not(LED1);
								 
	when "000000000100" => lumstp<="000000001000"; 
	
								 
								 when X"45"  => ndumpf <= (others=>'0'); 
						                                extpart<=data_wr(15) & data_wr(5); -- qual camera ira acessar
							                             exttype<='0'; -- read -- tipo de acesso
							                             ext3bf<=data_wr(2 downto 0);  -- passado endereço  --- extaddr<= ext3bf & ndumpf; 
														 
							
							
	when "000000001000" => lumstp<="000000010000";						
							
							
							when X"45"  => extaddr <= ext3bf & ndumpf;  
							extevent <= '1'; -- acesso externo
									
																		
	
	when "000000010000" => lumstp<="000000100000";						
							
							when X"45"  => if extevent_req='0' then data_rd<=extdataread; busy_clr<='1'; else lumstp<="000000010000"; end if; 	
							
							
							
							
	 when "000000100000" => lumstp<="000001000000";						
							
							
							
							 when X"45"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
							 
	when "000001000000" => lumstp<="000010000000";
	
	
							 when X"45"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; 
											                                else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
																		
																		