----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: C.E.Bertagnolli
--
-- Create Date:    17:09:29 02/06/2012 
-- Design Name: 
-- Module Name:    TESTEJET - Behavioral 
-- Project Name: 
-- Target Devices: SP6 XC6SLX16
-- Tool versions: 
-- Description: Testejet generator
--
-- Dependencies: 
--
-- Revision: 
-- Revision   0.01 - File Created
-- 31.05.2012 0.02 - Test frequency changed from 15Hz to 100Hz
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.l_definitions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TESTEJET is
    Port ( 	CLK_1_i : IN std_logic;
				CLK_18_i : IN std_logic;
				RESET_i : IN std_logic;
				TEJET_CHUTE_i : IN std_logic;  -- qual chute
				TEJET_DWELL_i : IN std_logic_vector(9 downto 0); -- tempo elipse
				TEJETBUFF_i : IN std_logic_vector (31 downto 0);
				DO_TESTEJETA_o : out std_logic;
				DO_TESTEJETB_o : out std_logic;
				TJET_o : out std_logic_vector (31 downto 0)
				);
end TESTEJET;

architecture Behavioral of TESTEJET is
-- Testejet detect
signal s_istestejet : std_logic;

-- Output signal generator
signal s_tjet : std_logic_vector(31 downto 0);
signal s_pwm_release : std_logic;
signal s_pwm_active_release : std_logic;
signal s_tjet_state : integer range 0 to 7;
signal s_tjet_active_state : integer range 0 to 7;
signal s_tjet_inactive : integer range 0 to 65535;
signal s_tjet_before_pwm : integer range 0 to (TEJET_BEFORE_PWM_BITS**2)-1;
signal s_tjet_pwm_counter : integer range 0 to 511;
signal s_tjet_pwm_active_counter : integer range 0 to 511;
signal s_tjet_active : integer range 0 to 2047;
signal s_tjet_pwm_active : integer range 0 to 2047;
--signal s_active_time : integer range 0 to 511;

-- PWM counter
signal s_pwm_counter_end : std_logic;
signal s_pwm_active_counter_end : std_logic;
signal s_pwm_state : integer range 0 to 1;
signal s_pwm_active_state : integer range 0 to 1;
signal s_pwm_counter_max : std_logic_vector(15 downto 0);
signal s_pwm_active_counter_max : std_logic_vector(15 downto 0);
signal s_other_counter : std_logic_vector(15 downto 0);
signal s_other_active_counter : std_logic_vector(15 downto 0);

	
signal s_FIRST_PULSE_WIDTH_reg, s_FIRST_PULSE_WIDTH_next: std_logic_vector(TEJET_ACTIVE_TIME'range); -- > 1024 , max 2047
signal s_PWM_HIGH_WIDTH_reg, s_PWM_HIGH_WIDTH_next: std_logic_vector(TEJET_PWM_HIGH'range); -- max 511
signal s_PWM_ACTIVE_HIGH_WIDTH_reg, s_PWM_ACTIVE_HIGH_WIDTH_next: std_logic_vector(TEJET_PWM_HIGH'range); -- max 511
signal s_PWM_LOW_WIDTH_reg, s_PWM_LOW_WIDTH_next: std_logic_vector(TEJET_PWM_LOW'range);	-- max 511 
signal s_PWM_ACTIVE_LOW_WIDTH_reg, s_PWM_ACTIVE_LOW_WIDTH_next: std_logic_vector(TEJET_PWM_LOW'range);	-- max 511 
signal s_TEJET_BEFORE_PWM_next, s_TEJET_BEFORE_PWM_reg: integer range 0 to (TEJET_BEFORE_PWM_BITS**2)-1;

type STATE_TYPE is (START, RUN);
--attribute SYN_ENCODING of STATE_TYPE: type is "safe";
signal state_next, state_reg    : STATE_TYPE;

	signal pulse_stretcher_counter:	 	natural range 0 to 20;
	constant pulse_stretcher_counter_max: 	natural := 18;
	
	signal pulse_stretcher_active_counter:	 	natural range 0 to 20;
	constant pulse_stretcher_active_counter_max: 	natural := 18;
	
	
begin

	s_istestejet <= (TEJETBUFF_i(0) or TEJETBUFF_i(1) or TEJETBUFF_i(2) or TEJETBUFF_i(3) or TEJETBUFF_i(4) or TEJETBUFF_i(5) or TEJETBUFF_i(6) or TEJETBUFF_i(7) or
							TEJETBUFF_i(8) or TEJETBUFF_i(9) or TEJETBUFF_i(10) or TEJETBUFF_i(11) or TEJETBUFF_i(12) or TEJETBUFF_i(13) or TEJETBUFF_i(14) or TEJETBUFF_i(15) or 
							TEJETBUFF_i(16) or TEJETBUFF_i(17) or TEJETBUFF_i(18) or TEJETBUFF_i(19) or TEJETBUFF_i(20) or TEJETBUFF_i(21) or TEJETBUFF_i(22) or TEJETBUFF_i(23) or 
							TEJETBUFF_i(24) or TEJETBUFF_i(25) or TEJETBUFF_i(26) or TEJETBUFF_i(27) or TEJETBUFF_i(28) or TEJETBUFF_i(29) or TEJETBUFF_i(30) or TEJETBUFF_i(31));  
							
	DO_TESTEJETA_o <= (not(TEJET_CHUTE_i) and s_istestejet);
	DO_TESTEJETB_o <= (TEJET_CHUTE_i and s_istestejet);

	TJET_o <= s_tjet;
	
	
	
	
		
   process (CLK_1_i,RESET_i) -- 1MHz
	begin	
		if rising_edge(CLK_1_i) then
			if (RESET_i = '1') then
				s_pwm_release <= '0';
				s_pwm_active_release <= '0';
				s_tjet_before_pwm <= 0;
				s_tjet_pwm_active_counter <= 0;
				s_tjet_state <= 0;
				s_tjet_inactive <= 0;
				s_tjet_active <= 0;
				s_tjet <= (others => '0');	
			else
				case s_tjet_state is
					when 0 =>	
								s_tjet <= (others => '0');	
								if (s_tjet_inactive = TEJET_PERIOD) then	
									s_tjet_inactive <= 0;
									s_tjet_state <= 1;
								else
									s_tjet_state <= 0;
									s_tjet_inactive <= s_tjet_inactive + 1;
								end if;
								
					when 1 =>	
								s_tjet <= TEJETBUFF_i;	
								if (s_tjet_active = s_FIRST_PULSE_WIDTH_reg) then	
									s_tjet_state <= 2;
									s_pwm_active_release <= '1';	
									s_tjet_active <= 0;
								else
									s_tjet_state <= 1;	
									s_tjet_active <= s_tjet_active + 1;
									s_pwm_active_release <= '0';
								end if;
								
					
					when 2 =>	
								
								s_tjet <= (others => '0');
								
								if (s_pwm_active_counter_end = '1') then 
									s_pwm_active_release <= '0';
									s_tjet_state <= 4;
									s_tjet_pwm_active_counter <= 0;
									s_tjet <= (others => '0');
								else	
									s_tjet_state <= 2;
									if (s_tjet_pwm_active_counter = s_PWM_ACTIVE_LOW_WIDTH_reg) then 
										s_tjet_state <= 3;
										s_tjet <= s_tjet xor TEJETBUFF_i; 
										s_tjet_pwm_active_counter <= 0;
									else
										s_tjet_pwm_active_counter <= s_tjet_pwm_active_counter + 1;
									end if;
								end if;
					
					when 3 =>	
								if (s_pwm_active_counter_end = '1') then 
									s_tjet_state <= 4;
									s_pwm_active_release <= '0';
									s_tjet_pwm_active_counter <= 0;
									s_tjet <= (others => '0');
								else	
									s_tjet_state <= 3;
									if (s_tjet_pwm_active_counter = s_PWM_ACTIVE_HIGH_WIDTH_reg) then 
										s_tjet_state <= 2;
										s_tjet <= s_tjet xor TEJETBUFF_i; 
										s_tjet_pwm_active_counter <= 0;
									else
										s_tjet_pwm_active_counter <= s_tjet_pwm_active_counter + 1;
									end if;
								end if;
					
										
					when 4 =>									
								s_pwm_release <= '1';
								s_tjet <= (others => '0');	
								if (s_tjet_before_pwm = s_TEJET_BEFORE_PWM_reg) then	
									s_tjet_state <= 5;
									s_tjet_before_pwm <= 0;
								else
									s_tjet_state <= 4;
									s_tjet_before_pwm <= s_tjet_before_pwm + 1;
								end if;
								
					when 5 =>	
								
								if (s_pwm_counter_end = '1') then 
									s_pwm_release <= '0';
									s_tjet_state <= 0;
									s_tjet_pwm_counter <= 0;
									s_tjet <= (others => '0');
								else	
									s_tjet_state <= 5;
									if (s_tjet_pwm_counter = s_PWM_LOW_WIDTH_reg) then 
										s_tjet_state <= 6;
										s_tjet <= s_tjet xor TEJETBUFF_i; 
										s_tjet_pwm_counter <= 0;
									else
										s_tjet_pwm_counter <= s_tjet_pwm_counter + 1;
									end if;
								end if;
								
					
					when 6 =>	
								
								if (s_pwm_counter_end = '1') then 
									s_pwm_release <= '0';
									s_tjet_state <= 0;
									s_tjet_pwm_counter <= 0;
									s_tjet <= (others => '0');
								else	
									s_tjet_state <= 6;
									if (s_tjet_pwm_counter = s_PWM_HIGH_WIDTH_reg) then 
										s_tjet_state <= 5;
										s_tjet <= s_tjet xor TEJETBUFF_i; 
										s_tjet_pwm_counter <= 0;
									else
										s_tjet_pwm_counter <= s_tjet_pwm_counter + 1;
									end if;
								end if;
					
					when others =>
								s_tjet_state <= 0;
				end case;
				
			end if;
		end if;
	end process;
	
	
	
  process(CLK_1_i, RESET_i)
  begin
    if (RESET_i = '1') then	
	    state_reg <= START;
		s_FIRST_PULSE_WIDTH_reg 		<= (others => '0');		
		s_PWM_HIGH_WIDTH_reg    		<= (others => '0'); 
		s_PWM_ACTIVE_HIGH_WIDTH_reg    	<= (others => '0'); 
		s_PWM_LOW_WIDTH_reg     		<= (others => '0'); 
		s_PWM_ACTIVE_LOW_WIDTH_reg     	<= (others => '0');
		s_TEJET_BEFORE_PWM_reg 			<= 0;	
    elsif rising_edge(CLK_1_i) then
		state_reg <= state_next;
		s_FIRST_PULSE_WIDTH_reg 		<= s_FIRST_PULSE_WIDTH_next;
		s_PWM_HIGH_WIDTH_reg    		<= s_PWM_HIGH_WIDTH_next;
		s_PWM_ACTIVE_HIGH_WIDTH_reg    	<= s_PWM_ACTIVE_HIGH_WIDTH_next;
		s_PWM_LOW_WIDTH_reg     		<= s_PWM_LOW_WIDTH_next;			
		s_PWM_ACTIVE_LOW_WIDTH_reg     	<= s_PWM_ACTIVE_LOW_WIDTH_next;	
		s_TEJET_BEFORE_PWM_reg          <= s_TEJET_BEFORE_PWM_next;
    end if;
  end process;
  
    -- only when chiscope is inactive
	s_FIRST_PULSE_WIDTH_next 		<= TEJET_ACTIVE_TIME;  
	s_PWM_HIGH_WIDTH_next	 		<= TEJET_PWM_HIGH; -- 140 
	s_PWM_ACTIVE_HIGH_WIDTH_next	<= TEJET_PWM_HIGH; -- 140 
	s_PWM_LOW_WIDTH_next    		<= TEJET_PWM_LOW; -- 35
	s_PWM_ACTIVE_LOW_WIDTH_next     <= TEJET_PWM_LOW; -- 35
    s_TEJET_BEFORE_PWM_next 		<= conv_integer(TEJET_BEFORE_PWM); -- 63 max	- 6 bits

	--s_pwm_counter_max <= TEJET_DWELL_i & "000000";
	--s_pwm_counter_max <= "0100100110110100";  -- 18868 = 1 ms
	--s_pwm_active_counter_max <= "0111010111111000"; -- 30200 = 1.6 ms
	--s_pwm_counter_max <= "1101110100011100";  -- 56604 = 3 ms
	--s_pwm_active_counter_max <= "0100100110110100"; -- 18868 = 1 ms
	s_pwm_counter_max <= "1001001101101000";  -- 37736 = 2 ms
	s_pwm_active_counter_max <= "0010110000111001"; -- 11321 = 600 us
	

	
	-- chipscope_block: block  

		-- signal  CLK_c1: 	std_logic;		
		-- signal  CONTROL0: 	std_logic_vector(35 downto 0);			
		-- signal  s_SYNC_OUT: std_logic_vector(35 downto 0);
	
	
	-- begin
		
		-- CLK_c1 		<= CLK_1_i;	

	
	-- c0: entity work.chipscope_icon 
	  -- port map(
		-- CONTROL0 => CONTROL0		
		-- );

	-- c1: entity work.chipscope_vio 
	  -- port map (
		-- CONTROL 	=> CONTROL0, 
		-- CLK 		=> CLK_c1,
		-- SYNC_OUT 	=> s_SYNC_OUT	
	-- );

	
	
-- process (state_reg,s_FIRST_PULSE_WIDTH_reg,s_PWM_HIGH_WIDTH_reg,s_PWM_LOW_WIDTH_reg,s_SYNC_OUT)
  -- begin
  
    -- state_next <= state_reg;
	-- s_FIRST_PULSE_WIDTH_next <= s_FIRST_PULSE_WIDTH_reg;
	-- s_PWM_HIGH_WIDTH_next <= s_PWM_HIGH_WIDTH_reg;
	-- s_PWM_LOW_WIDTH_next <= s_PWM_LOW_WIDTH_reg;
	-- s_PWM_ACTIVE_HIGH_WIDTH_next <= s_PWM_ACTIVE_HIGH_WIDTH_reg;
	-- s_PWM_ACTIVE_LOW_WIDTH_next <= s_PWM_ACTIVE_LOW_WIDTH_reg;
	
	
    -- case state_reg is

      -- when START =>
	  
	
		-- s_FIRST_PULSE_WIDTH_next <= TEJET_ACTIVE_TIME; 		
		-- s_PWM_HIGH_WIDTH_next	 <= TEJET_PWM_HIGH; 
		-- s_PWM_LOW_WIDTH_next     <= TEJET_PWM_LOW; 
		-- s_TEJET_BEFORE_PWM_next  <= TEJET_BEFORE_PWM; 
		-- s_PWM_ACTIVE_HIGH_WIDTH_next <= TEJET_PWM_HIGH;
		-- s_PWM_ACTIVE_LOW_WIDTH_next  <= TEJET_PWM_LOW;
		
		-- if s_SYNC_OUT(35) = '1' then
			-- state_next 				 <= RUN;
		-- end if;

      -- when RUN =>

		-- if s_SYNC_OUT(35) = '0' then
			-- state_next 				<= START;
		-- end if; 
			
		-- s_FIRST_PULSE_WIDTH_next 		<= s_SYNC_OUT(28 downto 18);
		-- s_PWM_HIGH_WIDTH_next 			<= s_SYNC_OUT(17 downto 9);
		-- s_PWM_ACTIVE_HIGH_WIDTH_next 	<= s_SYNC_OUT(17 downto 9);
		-- s_PWM_LOW_WIDTH_next			<= s_SYNC_OUT(8 downto 0);
		-- s_PWM_ACTIVE_LOW_WIDTH_next		<= s_SYNC_OUT(8 downto 0);
		-- s_TEJET_BEFORE_PWM_next      	<= conv_integer(s_SYNC_OUT(34 downto 29));
		
      -- when others =>
	  
        -- state_next <= START;
		
    -- end case;

  -- end process; 
  
	
-- end block;	

	
	
	process (CLK_18_i,RESET_i) -- 18.75MHz
	begin
		if rising_edge(CLK_18_i) then
			if (RESET_i = '1') then
				s_other_active_counter <= "0000000000000000";
				s_pwm_active_counter_end <= '0';
				s_pwm_active_state <= 0;
			else
				case s_pwm_active_state is
					when 0 =>
								s_other_active_counter <= "0000000000000000";
							
							if s_pwm_active_release = '1' then
									s_pwm_active_state <= 1;
								else
									s_pwm_active_state <= 0;
								end if;
					when 1 =>
								s_pwm_active_counter_end <= '0';
								if s_other_active_counter = s_pwm_active_counter_max then	
									
									if pulse_stretcher_active_counter = pulse_stretcher_active_counter_max then
										pulse_stretcher_active_counter <= 0;
										s_pwm_active_state	 	<= 0;
										s_pwm_active_counter_end <= '0';
									else	
										s_pwm_active_state <= 1;
										s_pwm_active_counter_end <= '1';
										pulse_stretcher_active_counter <= pulse_stretcher_active_counter + 1;
									end if;
									
									
								else
									s_pwm_active_state <= 1;
									s_other_active_counter <= s_other_active_counter + '1';
								end if;
					when others =>
								s_pwm_active_state <= 0;
				end case;
			end if;
		end if;
	end process;
	
	
	
	
	process (CLK_18_i,RESET_i) -- 18.75MHz
	
	begin
		if rising_edge(CLK_18_i) then
			if (RESET_i = '1') then
				s_other_counter <= "0000000000000000";
				s_pwm_counter_end <= '0';
				s_pwm_state <= 0;
				pulse_stretcher_counter <= 0;
			else
				case s_pwm_state is
					when 0 =>
								s_other_counter <= "0000000000000000";
								if s_pwm_release = '1' then
									s_pwm_state <= 1;
								else
									s_pwm_state <= 0;
								end if;
					when 1 =>
								s_pwm_counter_end <= '0';
								if s_other_counter = s_pwm_counter_max then
									
									if pulse_stretcher_counter = pulse_stretcher_counter_max then
										pulse_stretcher_counter <= 0;
										s_pwm_counter_end 	<= '0';
										s_pwm_state 		<= 	0;
									else	
										s_pwm_state 	   	<= 1;
										s_pwm_counter_end 	<= '1';
										pulse_stretcher_counter <= pulse_stretcher_counter + 1;
									end if;
									
								else
									s_pwm_state <= 1;
									s_other_counter <= s_other_counter + '1';
								end if;
					when others =>
								s_pwm_state <= 0;
				end case;
			end if;
		end if;
	end process;
		
end Behavioral;

