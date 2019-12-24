-- BIGR
	process(s_fus) 
	variable TMP : std_logic;
		begin
		TMP := '0';
		for i in s_fus'low to s_fus'high loop
			TMP := TMP or s_fus(i);
		end loop;
		or_s_fus <= TMP;
	end process;