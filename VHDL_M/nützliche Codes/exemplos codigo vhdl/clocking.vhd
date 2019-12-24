library UNISIM;
use UNISIM.VComponents.all;  
  
  
  
  
   DCM_inst : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 xor 16.0
      CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 4, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 0.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED xor VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X xor 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS xor
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH xor LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH xor LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE xor FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 => iCLK,     -- 0 degree DCM CLK ouptput
      CLK180 => open, -- 180 degree DCM CLK output
      CLK270 => open, -- 270 degree DCM CLK output
      CLK2X => open,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => clk2x,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, -- 180 degree CLK synthesis out
      LOCKED => open, -- DCM LOCK status output                          <OPEN ????>
      PSDONE => open, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => CLK,   -- DCM clock feedback
      CLKIN => CLK37,   -- Clock input (from IBUFG, BUFG xor DCM)
      PSCLK => '0',   -- Dynamic phase adjust clock input
      PSEN => '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
      RST => not INITIN        -- DCM asynchronous reset input (INIT pin becomes 1 after configuration)
   );

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => clk,  I => iclk); -- 37.5MHz
   
   
   
  
  process (clk2x) -- clock generation with (150MHz)
	variable dv0,dv1,dv2,dv3: integer range 0 to 127 := 0;
	variable dv5: integer range 0 to 40 := 0;
	variable dv4: integer range 0 to 255 := 0;
	begin
	  if rising_edge(clk2x) then
		  dv0:=dv0+1; 
		  if (dv0>=12) and (clkxx='0') then dv0:=0; clkxx<='1'; end if;--
		  if (dv0>=12) and (clkxx='1') then dv0:=0; clkxx<='0'; end if;--

		  dv1:=dv1+1; 
		  if (dv1>=100) and (ck1us='0') then dv1:=0; ck1us<='1'; end if;--50
		  if (dv1>=50) and (ck1us='1') then dv1:=0; ck1us<='0'; end if;--25

		  dv2:=dv2+1; 
		  if (dv2>=7) and (clk12='0') then dv2:=0; clk12<='1'; end if;--
		  if (dv2>=8) and (clk12='1') then dv2:=0; clk12<='0'; end if;--

		  dv3:=dv3+1; 
		  if (dv3>=3) and (clk2='0') then dv3:=0; clk2<='1'; end if;--
		  if (dv3>=3) and (clk2='1') then dv3:=0; clk2<='0'; end if;--
		  
		  dv4:=dv4+1; 
		  if (dv4>=250) and (c3='0') then dv4:=0; c3<='1'; end if;--
		  if (dv4>=250) and (c3='1') then dv4:=0; c3<='0'; end if;--
		  
		  dv5:=dv5+1; 
		  if (dv5>=38) and (clock2MHz='0') then dv5:=0; clock2MHz <='1'; end if;--
		  if (dv5>=37) and (clock2MHz='1') then dv5:=0; clock2MHz <='0'; end if;--
		  
	  end if;
	end process;
	

   BUFG_1u : BUFG
   port map ( O => c1us,  I => ck1us); -- 1MHz
   BUFG_1x : BUFG
   port map ( O => clkx,  I => clkxx); -- 150/24 = 6.25MHz
   BUFG_1z : BUFG
   port map ( O => c10MHz,  I => clk12); -- 150/15 = 10.MHz not 50/50 duty cycle

   BUFG_2z : BUFG
   port map ( O => c25MHz,  I => clk2); -- 150/6 = 25MHz