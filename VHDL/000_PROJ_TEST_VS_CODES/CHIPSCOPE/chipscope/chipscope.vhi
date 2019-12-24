
-- VHDL Instantiation Created from source file chipscope.vhd -- 11:07:02 08/07/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT chipscope
	PORT(
		clk : IN std_logic;
		TRIG0 : IN std_logic_vector(31 downto 0);       
		);
	END COMPONENT;

	Inst_chipscope: chipscope PORT MAP(
		clk => ,
		TRIG0 => 
	);


