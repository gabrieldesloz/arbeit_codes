--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:55:39 04/20/2012
-- Design Name:   
-- Module Name:   F:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_44_rev06/TB_TESTEJET.vhd
-- Project Name:  FPGA_V00_44_rev06
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TESTEJET
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TESTEJET IS
END TB_TESTEJET;
 
ARCHITECTURE behavior OF TB_TESTEJET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TESTEJET
    PORT(
         CLK_1_i : IN  std_logic;
         CLK_18_i : IN  std_logic;
         RESET_i : IN  std_logic;
         TEJET_CHUTE_i : IN  std_logic;
         TEJET_DWELL_i : IN  std_logic_vector(9 downto 0);
         TEJETBUFF_i : IN  std_logic_vector(31 downto 0);
         DO_TESTEJETA_o : OUT  std_logic;
         DO_TESTEJETB_o : OUT  std_logic;
         TJET_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1_i : std_logic := '0';
   signal CLK_18_i : std_logic := '0';
   signal CLK_10_i: std_logic := '0'; 
   signal RESET_i : std_logic := '0';
   signal TEJET_CHUTE_i : std_logic := '0';
   signal TEJET_DWELL_i : std_logic_vector(9 downto 0) := (others => '0');
   signal TEJETBUFF_i : std_logic_vector(31 downto 0) := (others => '0');
   signal EJECT_i: std_logic := '0'; 
 	--Outputs
   signal DO_TESTEJETA_o : std_logic;
   signal DO_TESTEJETB_o : std_logic;
   signal TJET_o : std_logic_vector(31 downto 0);
   signal EJECT_o: std_logic := '0'; 
   
    SIGNAL DATA_i       :   std_logic_vector(63 downto 0) := (others => '0');             
    SIGNAL D_VALID_i    :   std_logic_vector(63 downto 0) := (others => '0');             
	SIGNAL TX_DATA_o    :   std_logic;
    SIGNAL TX_D_VALID_o :   std_logic;
    SIGNAL TX_D_Latch_o :   std_logic;
	signal CLK_1us_i    : std_logic := '0';

   -- Clock period definitions
   constant CLK_1_i_period : time := 1 us;
   constant CLK_10MHz_period : time := 100 ns;
   constant CLK_18_i_period : time := 53 ns;
   constant CLK_1us_i_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   -- uut: TESTEJET PORT MAP (
          -- CLK_1_i => CLK_1_i,
          -- CLK_18_i => CLK_18_i,
          -- RESET_i => RESET_i,
          -- TEJET_CHUTE_i => TEJET_CHUTE_i,
          -- TEJET_DWELL_i => TEJET_DWELL_i,
          -- TEJETBUFF_i => TEJETBUFF_i,
          -- DO_TESTEJETA_o => DO_TESTEJETA_o,
          -- DO_TESTEJETB_o => DO_TESTEJETB_o,
          -- TJET_o => TJET_o
        -- );

   
   uut2: entity work.EJECT_SHAPER 
    Port map  ( 	
				CLK_i => CLK_10_i,	 		
				RESET_i => RESET_i, 
				EJECT_i => EJECT_i, 
				EJECT_o =>  EJECT_o
				);	

   
				
uut3: entity work.EJ_SERIAL_TX 
  port map (
    CLK_1us_i   	 => CLK_1us_i,                
    RESET_i 		 => RESET_i, 
    DATA_i      	 => DATA_i,             
    TX_DATA_o   	 => TX_DATA_o,
    TX_D_VALID_o	 => TX_D_VALID_o, 
    TX_D_Latch_o 	 => TX_D_Latch_o
    );

				

CH_X_EJET_TIMERr: block 
	
	signal LENGTH_MEM:  std_logic_vector(2 downto 0);
	signal s_rd_ptr   : std_logic_vector (5 downto 0);
	signal DEF_CNT   : std_logic_vector (15 downto 0);
	signal HAS_GRAIN   : std_logic_vector (63 downto 0);
	signal COUNT   : std_logic_vector (9 downto 0);
	signal PWMi:     std_logic;	
	signal ACTIVEi:  std_logic;	
	signal PROTEC_VALVE:  std_logic;	
	signal LENGTH_BUFF: std_logic_vector(191 downto 0);

begin
				
uut4: entity work.CH_X_EJET_TIMER

    Port map ( 	LENGTH_BUFF_i => LENGTH_BUFF,

				HAS_GRAIN_i => HAS_GRAIN,
				CH_NUM_i => s_rd_ptr,
				ACTIVE_i => ACTIVEi,
				PWM_i	=> PWMi,
				PROTEC_VALVE_i => PROTEC_VALVE,
				COUNT_i	=> COUNT,
				DEF_CNT_i => DEF_CNT,
				LENGTH_MEM_i => LENGTH_MEM, 				
				RETRIGGER_ON_i => '0',
		
				A_ELIPSE1_i => "1101001101",
				A_ELIPSE2_i => "0111001101",
				A_ELIPSE3_i => "1111001101",
				A_ELIPSE4_i => "0001110001",
				A_ELIPSE5_i => "0001110011",
				A_ELIPSE6_i => "0001110001",
				A_ELIPSE7_i => "0101110001",
				
				B_ELIPSE1_i => "1100001101",
				B_ELIPSE2_i => "1101101101",
				B_ELIPSE3_i => "1101101101",
				B_ELIPSE4_i => "1101111101",
				B_ELIPSE5_i => "1101001101",
				B_ELIPSE6_i => "1101001101",
				B_ELIPSE7_i => "1001000101",
				
				C18MHZ_i 	=> CLK_18_i,
				C3KHZ_i 	=> '0',
				RST_i		=> RESET_i,
				
				PROBE_o 				=> open,
				CH_OUT_o 				=> open,
				LENGTH_MEM_o 			=> LENGTH_MEM,
				COUNT_o					=> COUNT,
				ACTIVE_o				=> ACTIVEi,
				PWM_o					=> PWMi,
				DEF_CNT_o 				=> DEF_CNT,
				MAX_ACTIVE_COUNTER_o 	=> open,
				PROTEC_VALVE_o 			=> PROTEC_VALVE
				); 

				
				
	p_contador: process(CLK_18_i, RESET_i)
	begin	
		if rising_edge(CLK_18_i) then
			if (RESET_i = '1') then
				s_rd_ptr <= "000000";			
			else
				s_rd_ptr <= s_rd_ptr + 1;
			end if;
		end if;		
	end process;				

	
	
	     stim_proc4: process
   begin		
	 
		HAS_GRAIN 	<= (others => '0');		
		wait for 100 ns;	
		LENGTH_BUFF <= x"ABCDEF123456789ACEF893429BCA7912ABCDEF1234567000";
		HAS_GRAIN 	<= x"ACBD145890ABCDF0";				
		wait for 1 ms;
		HAS_GRAIN 	<= x"39815628ABDCA781";
		LENGTH_BUFF <= x"ABCDEF123456789ACEF893429BCA7912ABCDEF1234567000";
		wait for 1 ms;
		HAS_GRAIN 	<= x"ACBD145890ABCDF1";	
		LENGTH_BUFF <= x"ABCDEF123456789ACEF893429BCA7912ABCDEF12345678AA";			
		wait for 1 ms;
   
   end process;
	
end block;

				
   -- Clock process definitions
   CLK_1_i_process :process
   begin
		CLK_1_i <= '0';
		wait for CLK_1_i_period/2;
		CLK_1_i <= '1';
		wait for CLK_1_i_period/2;
   end process;
   
   
    -- Clock process definitions
   CLK_10_process :process
   begin
		CLK_10_i <= '0';
		wait for CLK_10MHz_period/2;
		CLK_10_i <= '1';
		wait for CLK_10MHz_period/2;
   end process;
   
   
   
     -- Clock process definitions
   CLK_1us_process :process
   begin
		CLK_1us_i <= '0';
		wait for CLK_1us_i_period/2;
		CLK_1us_i <= '1';
		wait for CLK_1us_i_period/2;
   end process;
 
 
 
 
   CLK_18_i_process :process
   begin
		CLK_18_i <= '0';
		wait for CLK_18_i_period/2;
		CLK_18_i <= '1';
		wait for CLK_18_i_period/2;
   end process;

   
  
   stim_proc2: process
   begin		
		EJECT_i <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
	   EJECT_i <= '1';
      wait for 4 ms;
	  EJECT_i <= '0';
	  wait for 1 ms;
	  EJECT_i <= '1';
	  wait for 10 ms;
      -- insert stimulus here 

      wait;
   end process;
   
   
   
   
    stim_proc3: process
   begin		
	 
		D_VALID_i 	<= (others => '0');
		DATA_i  	<= (others => '0');
		wait for 100 ns;	
		EJECT_i   <= '1';
		DATA_i    <= "1000000000000000000000000000111100000000000001000000000000000101";
		wait for 5 ms;      
		wait;
   
   end process;

  

  
   
   -- Stimulus process
   stim_proc: process
   begin		
		RESET_i <= '1';
		TEJET_DWELL_i <= "0000111011";
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		TEJETBUFF_i <= "10000000000000000000000000000000";
		RESET_i <= '0';

      wait for CLK_1_i_period*10;
      -- insert stimulus here 

      wait;
   end process;

END;
