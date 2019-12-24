divider_ip_inst : divider_ip PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		denom	 => denom_sig,
		numer	 => numer_sig,
		quotient	 => quotient_sig,
		remain	 => remain_sig
	);
