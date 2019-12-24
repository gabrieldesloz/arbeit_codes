VHDL TEMPLATES


--  <-----Cut code below this line and paste into the architecture body---->

   -- IBUFGDS: Differential Global Clock Buffer (sourced by an external pin)
   --          Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   IBUFGDS_inst : IBUFGDS
   generic map (
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => O,  -- Clock buffer output
      I => I,  -- Diff_p clock buffer input
      IB => IB -- Diff_n clock buffer input
   );

   -- End of IBUFGDS_inst instantiation

   
   
   Library UNISIM;
use UNISIM.vcomponents.all;

-- <-----Cut code below this line and paste into the architecture body---->

   -- DCM_CLKGEN: Frequency Aligned Digital Clock Manager
   --             Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   DCM_CLKGEN_inst : DCM_CLKGEN
   generic map (
      CLKFXDV_DIVIDE => 2,       -- CLKFXDV divide value (2, 4, 8, 16, 32)
      CLKFX_DIVIDE => 1,         -- Divide value - D - (1-256)
      CLKFX_MD_MAX => 0.0,       -- Specify maximum M/D ratio for timing anlysis
      CLKFX_MULTIPLY => 4,       -- Multiply value - M - (2-256)
      CLKIN_PERIOD => 0.0,       -- Input clock period specified in nS
      SPREAD_SPECTRUM => "NONE", -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD", "CENTER_HIGH_SPREAD",
                                 -- "VIDEO_LINK_M0", "VIDEO_LINK_M1" or "VIDEO_LINK_M2" 
      STARTUP_WAIT => FALSE      -- Delay config DONE until DCM_CLKGEN LOCKED (TRUE/FALSE)
   )
   port map (
      CLKFX => CLKFX,         -- 1-bit output: Generated clock output
      CLKFX180 => CLKFX180,   -- 1-bit output: Generated clock output 180 degree out of phase from CLKFX.
      CLKFXDV => CLKFXDV,     -- 1-bit output: Divided clock output
      LOCKED => LOCKED,       -- 1-bit output: Locked output
      PROGDONE => PROGDONE,   -- 1-bit output: Active high output to indicate the successful re-programming
      STATUS => STATUS,       -- 2-bit output: DCM_CLKGEN status
      CLKIN => CLKIN,         -- 1-bit input: Input clock
      FREEZEDCM => FREEZEDCM, -- 1-bit input: Prevents frequency adjustments to input clock
      PROGCLK => PROGCLK,     -- 1-bit input: Clock input for M/D reconfiguration
      PROGDATA => PROGDATA,   -- 1-bit input: Serial data input for M/D reconfiguration
      PROGEN => PROGEN,       -- 1-bit input: Active high program enable
      RST => RST              -- 1-bit input: Reset input pin
   );

   -- End of DCM_CLKGEN_inst instantiation
	

-- <-----Cut code below this line and paste into the architecture body---->

   -- BUFG: Global Clock Buffer
   --       Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   BUFG_inst : BUFG
   port map (
      O => O, -- 1-bit output: Clock buffer output
      I => I  -- 1-bit input: Clock buffer input
   );

   -- End of BUFG_inst instantiation


--  <-----Cut code below this line and paste into the architecture body---->

   -- IBUFG: Global Clock Buffer (sourced by an external pin)
   --        Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   IBUFG_inst : IBUFG
   generic map (
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => O, -- Clock buffer output
      I => I  -- Clock buffer input (connect directly to top-level port)
   );

   -- End of IBUFG_inst instantiation
   
   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- IBUFG: Global Clock Buffer (sourced by an external pin)
   --        Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   IBUFG_inst : IBUFG
   generic map (
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => O, -- Clock buffer output
      I => I  -- Clock buffer input (connect directly to top-level port)
   );

   -- End of IBUFG_inst instantiation

   
   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- IBUFDS: Differential Input Buffer
   --         Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   IBUFDS_inst : IBUFDS
   generic map (
      DIFF_TERM => FALSE, -- Differential Termination 
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => O,  -- Buffer output
      I => I,  -- Diff_p buffer input (connect directly to top-level port)
      IB => IB -- Diff_n buffer input (connect directly to top-level port)
   );

   -- End of IBUFDS_inst instantiation
   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- IBUFDS_DIFF_OUT: Differential Input Buffer with Differential Output
   --                  Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   IBUFDS_DIFF_OUT_inst : IBUFDS_DIFF_OUT
   generic map (
      DIFF_TERM => FALSE, -- Differential Termination 
      IOSTANDARD => "DEFAULT") -- Specify the input I/O standard
   port map (
      O => O,     -- Buffer diff_p output
      OB => OB,   -- Buffer diff_n output
      I => I,  -- Diff_p buffer input (connect directly to top-level port)
      IB => IB -- Diff_n buffer input (connect directly to top-level port)
   );

   -- End of IBUFDS_DIFF_OUT_inst instantiation
   
   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- PULLDOWN: I/O Buffer Weak Pull-down
   --           Spartan-6
   -- Xilinx HDL Language Template, version 14.1
   
   PULLDOWN_inst : PULLDOWN
   port map (
      O => O     -- Pulldown output (connect directly to top-level port)
   );
  
   -- End of PULLDOWN_inst instantiation

   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- PULLUP: I/O Buffer Weak Pull-up
   --         Spartan-6
   -- Xilinx HDL Language Template, version 14.1
   
   PULLUP_inst : PULLUP
   port map (
      O => O     -- Pullup output (connect directly to top-level port)
   );
  
   -- End of PULLUP_inst instantiation
   
   
   --  <-----Cut code below this line and paste into the architecture body---->

   -- RAM128X1D: 128-deep by 1-wide positive edge write, asynchronous read 
   --            dual-port distributed LUT RAM
   --            Spartan-6
   -- Xilinx HDL Language Template, version 14.1

   RAM128X1D_inst : RAM128X1D
   generic map (
      INIT => X"00000000000000000000000000000000")
   port map (
      DPO => DPO,     -- Read/Write port 1-bit ouput
      SPO => SPO,     -- Read port 1-bit output
      A => A,         -- Read/Write port 7-bit address input
      D => D,         -- RAM data input
      DPRA => DPRA,   -- Read port 7-bit address input
      WCLK => WCLK,   -- Write clock input
      WE => WE        -- RAM data input
   );

   -- End of RAM128X1D_inst instantiation
   
   component MAIN_RESET is
    Port ( 	CH1_i : in  STD_LOGIC;			-- Button input (0 when pressed "Pull-down")
				CLKSEL_i : in STD_LOGIC;		-- Jumper that sets if this is the main board or not
				RSYNC2_i : in STD_LOGIC;		-- Sync input
				C1US_i : in  STD_LOGIC;			-- 1us clock input
				RESET_o : out  STD_LOGIC);	-- Reset output
end component;


 BUFG_1u : BUFG
   port map ( O => c1us,  I => ck1us); -- 1.0046MHz
   BUFG_1z : BUFG
   port map ( O => clkz,  I => clkxxx); -- 18.75MHz
   BUFG_1x : BUFG
   port map ( O => clkx,  I => clkxx); -- 9.375MHz
   
   
   ----------------------------------------------------------------------------------------			  
-- FLAG FLAG FLAG 
----------------------------------------------------------------------------------------			  
   process (extevent,extclr)
	begin
	  if extclr='1' then
	     extevent_req<='0';
	  elsif rising_edge(extevent) then 
	     extevent_req<='1';
	  end if;
	end process;

	
	-- address muxes
   with ad1 select -- front chute A
	addra <= '1' & led_counter & pix when "00",
	         '0' & led_counter & pix when "01",
				            "011" & pix when "10",
								    extaddrw when others;