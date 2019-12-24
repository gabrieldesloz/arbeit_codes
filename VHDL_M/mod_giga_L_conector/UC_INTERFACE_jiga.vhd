----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:15 09/10/2013 
-- Design Name: 
-- Module Name:    UC_INTERFACE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity UC_INTERFACE is
	Port (	
				--------------------------------------------------------------------------------
				--------------------------------------------------------------------------------
				--------------------------------------------------------------------------------
				LDATA : inout STD_LOGIC_VECTOR (15 downto 0);			-- 16 Bit interface
				LADDR : in STD_LOGIC;											-- Determines if the uC is reading or writing
				LCLKL : in std_logic;											-- Sinchrony clock signal
				LFRAME : in std_logic;
				LWR : in std_logic;
				LRD : in std_logic;
				FPGA_RSTCOM : in std_logic;

				RST_i : in STD_LOGIC;
				CLK_10MHz_i : in STD_LOGIC;
				CLK_60MHz_i : in STD_LOGIC;
				
				FPGA_BUSYCOM : out std_logic;
				--------------------------------------------------------------------------------
				EACK_i : in STD_LOGIC;
				EATXD_i : in STD_LOGIC;
				EBCK_i : in STD_LOGIC;
				EBTXD_i : in STD_LOGIC;
				
				ENABLE_EJECTORS_o: out STD_LOGIC;
				--------------------------------------------------------------------------------
				CCD_DIS1_i : in STD_LOGIC;
				CCD_CLK1_i : in STD_LOGIC;
				CCD_SI1_i  : in STD_LOGIC;

				CCD_DIS2_i  : in STD_LOGIC;
				CCD_CLK2_i  : in STD_LOGIC;
				CCD_SI2_i  : in STD_LOGIC;

				CCD_DIS3_i  : in STD_LOGIC;
				CCD_CLK3_i  : in STD_LOGIC;
				CCD_SI3_i : in STD_LOGIC;

				CCD_DIS4_i  : in STD_LOGIC;
				CCD_CLK4_i : in STD_LOGIC;
				CCD_SI4_i : in STD_LOGIC;
				--------------------------------------------------------------------------------
				TSYNC1_i : in STD_LOGIC;
				TSYNC2_i : in STD_LOGIC;
				
				RSYNC_o: out STD_LOGIC;
				--------------------------------------------------------------------------------
				ALARME_TEST_i : in STD_LOGIC;
				LIMP1_TEST_i : in STD_LOGIC;
				LIMP2_TEST_i : in STD_LOGIC;
				AQUEC_TEST_i : in STD_LOGIC;
				FREE_TEST_1_i : in STD_LOGIC;
				FREE_TEST_2_i : in STD_LOGIC;				
				
				IO_TEST_o: out STD_LOGIC;
				--------------------------------------------------------------------------------
				LED_OUTPUTS_o : out STD_LOGIC;
-------------------------------------------------------------------------
------------ Serial controller and FPGA 2 and 3 test signals ------------
-------------------------------------------------------------------------
-- Serial controller signals
				uC_REQUEST_o : out STD_LOGIC;
				uC_FPGA_SELECT_o : out STD_LOGIC;
				
				uC_COMMAND_o : out STD_LOGIC_VECTOR(7 downto 0);
				uC_DATA_o : out STD_LOGIC_VECTOR(31 downto 0);
				
				DATA_TO_uC_RECEIVED_o : out STD_LOGIC;
				DATA_TO_uC_READY_i : in STD_LOGIC;
-------------------------------------------------------------------------
-- FPGA 2 and 3 versions
				FPGA_2_VERSION_i : in STD_LOGIC_VECTOR(7 downto 0);
				FPGA_3_VERSION_i : in STD_LOGIC_VECTOR(7 downto 0);
-------------------------------------------------------------------------
-- R2R Digital to analog converter
				R2R_o : out STD_LOGIC_VECTOR(7 downto 0);
-------------------------------------------------------------------------
-- Illumination pins
				FRONT_LED_A_i : in STD_LOGIC;
				FRONT_LED_B_i : in STD_LOGIC;
				FRONT_LED_C_i : in STD_LOGIC;
				FRONT_LED_D_i : in STD_LOGIC;
					
				REAR_LED_A_i : in STD_LOGIC;
				REAR_LED_B_i : in STD_LOGIC;
				REAR_LED_C_i : in STD_LOGIC;
				REAR_LED_D_i : in STD_LOGIC;
				
				V_BCKGND_i : in STD_LOGIC;
-------------------------------------------------------------------------
-- Ejector Serial Activation
				EJET_SERIAL_TST_o: out std_logic_vector(31 downto 0);

-- Ejector board output status
				EJET_i : out STD_LOGIC_VECTOR(31 downto 0);				-- Returns ejectors activation (if ejector board outputs are active)
-------------------------------------------------------------------------
-- 12 Feeders board
				TEST_FED_OUT_i : in STD_LOGIC_VECTOR(11 downto 0);
-------------------------------------------------------------------------
-- Resistor board test signals
				R_COMP_i : in STD_LOGIC_VECTOR(31 downto 0);

-- Connector multiplexing;
				MUX_START_O: out std_logic;

-- Eejctors info from serial
				EJET_info_serial_i: in std_logic_vector(31 downto 0);		
				
				
				);
end UC_INTERFACE;

architecture Behavioral of UC_INTERFACE is
-------------------------------------------------------------------------
-- FPGA 1 version
constant c_version : std_logic_vector (3 downto 0) := X"7"; -- Version 1
-------------------------------------------------------------------------
-- microcontroller interface specific signals
signal microden, busy_flag, busy_clr, read_clr, halfrd, halfclr, busy_flag_pre: std_logic;
signal status_reg, cmd_reg, data_wr, data_rd : std_logic_vector (15 downto 0);
signal comrst, clr_cmd, comrstrq : std_logic;
signal datasel : std_logic_vector(1 downto 0);
signal lckk,lclk : std_logic;
signal lumstp : std_logic_vector(3 downto 0);

-- ejector high word, low word 
signal ejlword,ejhword : std_logic_vector(15 downto 0);
-- ejector register signals
signal ejet_serial_tst_next, ejet_serial_tst_reg: std_logic_vector(EJET_SERIAL_TST_o'length);

-- connector module mux
signal mux_start_reg, mux_start_next: std_logic;

begin

-- synchronization of external LCLK
	process (CLK_60MHz_i,RST_i)
	begin
	  if falling_edge(CLK_60MHz_i) then
			lckk<=lclkl;
	  end if;
	end process;
	
   BUFG_lck : BUFG
   port map ( O => lclk,  I => lckk); 

   datasel <= microden & laddr;
	
	process (CLK_60MHz_i,RST_i)
	begin
--	  if RST_i='1' then
--	    ldata <= "ZZZZZZZZZZZZZZZZ";
	  if falling_edge(CLK_60MHz_i) then
		  case datasel is
			 when "11"  => ldata<= status_reg;
			 when "10"  => ldata<=data_rd;
			 when others => ldata <= "ZZZZZZZZZZZZZZZZ";
		  end case;
	  end if;
	end process;
				
	status_reg <= "0000000000000000" when busy_flag='0' else "1111111111111111";
	
-- write process
   process (lclk,RST_i,lwr,laddr,clr_cmd,comrst,ldata)
	begin
	  if (RST_i='1') or (clr_cmd='1') or (comrst='1') then
	     cmd_reg<=X"0000";
	     data_wr<=X"0000";
	  elsif rising_edge(lclk) and lwr='1' then
		     if laddr='0' then 
			    data_wr<=ldata;
           else 
			    cmd_reg<=ldata;
           end if;			  
	  end if;
	end process;
	
	comrstrq <= FPGA_RSTCOM;
	FPGA_BUSYCOM <= busy_flag;
			  
-- busy flag
   process (lclk,RST_i,lwr,busy_clr,comrst,microden)
	begin
	  if (RST_i='1') or (busy_clr='1') or (comrst='1') then
	     busy_flag_pre<='0';
	  elsif rising_edge(lclk) then
	     if (lwr='1') or ((microden='1') and (laddr='0') and (cmd_reg/=X"0000")) then
	       busy_flag_pre<='1';
		  end if;
	  end if;
	end process;
	
   process (CLK_60MHz_i,RST_i)
	begin
	  if (RST_i='1') then
	     busy_flag<='0';
	  elsif rising_edge(CLK_60MHz_i) then
	     busy_flag<=busy_flag_pre;
	  end if;
	end process;
	
-- read process
   process (lclk,RST_i,read_clr,lrd)
	begin
	  if (RST_i='1') or (read_clr='1') then
	     halfrd<='0';
	  elsif rising_edge(lclk) then
	     halfrd<=lrd;
	  end if;
	end process;
	
   process (lclk,RST_i,read_clr,halfrd)
	begin
	  if (RST_i = '1') or (read_clr = '1') then
	     microden<='0';
		  read_clr<='0';
	  elsif falling_edge(lclk) then
	     microden<=halfrd;
		  read_clr<=halfclr;
	  end if;
	end process;

   process (lclk,RST_i,microden)
	begin
	  if RST_i='1' then
	     halfclr<='0';
	  elsif rising_edge(lclk) then
	     halfclr<=microden;
	  end if;
	end process;

	-- register for the ejector test word, input EJET_i
	register_0: process (CLK_10MHz_i,RST_i)
	begin
	  if RST_i='1' then	    
		mux_start_reg <= '0';
		ejet_serial_tst_reg <= (others => '0');	
		ejet_reg <= (others => '0');
	  elsif rising_edge(CLK_10MHz_i) then	
		ejet_reg <= EJET_info_serial_i;
		ejet_serial_tst_reg <= ejet_serial_tst_next;
		mux_start_reg <= mux_start_next;		
	  end if;
	end process;
	
	-- registered output
	EJET_SERIAL_TST_o <= ejet_serial_tst_reg;
	-- registered mux output 
	MUX_START_O <= mux_start_reg;
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- state machine for handling serial port debug & microcontroller interface state machine

	process (CLK_10MHz_i,RST_i) -- 9MHz
	variable lts : integer range 0 to 10000005;
	variable ltc,lct,debcnt : integer range 0 to 127;
	begin
		if RST_i='1' then
 
			lumstp<="0000";
			clr_cmd<='0';
			busy_clr<='0';
			
			LED_OUTPUTS_o <= '0';
			ENABLE_EJECTORS_o <= '0';
			RSYNC_o <= '0';
			IO_TEST_o <= '0';
			
			ejhword <= (others => '0');
			ejlword <= (others => '0');
			
			
		elsif rising_edge(CLK_10MHz_i) then -- 9.375MHz
		
		-- default action - maintain the same value
		ejet_serial_tst_next <= ejet_serial_tst_reg;
		
		-- mux_signal default -- keep the same value
		mux_start_next <= mux_start_reg;
		
   -- microcontroller defaults	  
			clr_cmd<='0';
	
	-- microcontroller communication reset management
			comrst<='0';
			if comrstrq='1' then 
				comrst<='1'; 
				lumstp<="0000";
			end if;
		 
-------------------------------------------------------------------------------------------------------------------
-------------- Luminary interface ***********************************************************************************

   -- decode the command from LUMINARY microcontroller

			case lumstp is
			
				when "0000" => clr_cmd <= '1'; lumstp <= "0001"; busy_clr <= '0';
				when "0001" => if busy_flag = '1' then lumstp <= "0010"; busy_clr <= '1'; end if;
				------------------------------------------------------------------------------------------------------
				when "0010" => lumstp <= "0011";
									busy_clr <= '0';

									case cmd_reg(7 downto 0) is
									
										-- Command 0x0000 - Sends back FPGA test version
										when X"00"  => 
															data_rd <= "000000001001" & c_version;
															lumstp <= "1111";
									
										-- Command 0x0001 - Sends 0x0000 to uC
										when X"01"  => 
															data_rd <= x"0000";
															lumstp <= "1111";
										
										-- Command 0x0002 - Sends 0xFFFF to uC
										when X"02"  => 
															data_rd <= x"FFFF"; 
															lumstp <= "1111";
															
										-- Command 0x0003 - Checks data_wr from uC
										when X"03"  => 
															if busy_flag='0' then 
																lumstp<="0010"; 
															end if;
										
										-- Command 0x0004 - Activate LED outputs
										when X"04"  => 
															if busy_flag='0' then 
																lumstp<="0010"; 
															end if;
															
										-- Command 0x0005 - Test Sorting board ejectors inputs (EARXD, EBRXD)
										when X"05"  => 
															if busy_flag='0' then 
																lumstp<="0010"; 
															end if;
															
										-- Command 0x0006	- Check Sorting board ejectors outputs
										when X"06"  => 
															data_rd(0) <= EACK_i;
															data_rd(1) <= EATXD_i;
															data_rd(2) <= EBCK_i;
															data_rd(3) <= EBTXD_i;
															lumstp<="1111"; 
															
										-- Command 0x0007	- Check CCD Control outputs
										when X"07"  => 
															data_rd(0) <= CCD_DIS1_i;
															data_rd(1) <= CCD_CLK1_i;
															data_rd(2) <= CCD_SI1_i;
															
															data_rd(3) <= CCD_DIS2_i;
															data_rd(4) <= CCD_CLK2_i;
															data_rd(5) <= CCD_SI2_i;
															
															data_rd(6) <= CCD_DIS3_i;
															data_rd(7) <= CCD_CLK3_i;
															data_rd(8) <= CCD_SI3_i;
															
															data_rd(9) <= CCD_DIS4_i;
															data_rd(10) <= CCD_CLK4_i;
															data_rd(11) <= CCD_SI4_i;
															
															lumstp<="1111"; 
															
										-- Command 0x0008 - Test Sync signals (RSYNC1-2 from sorting board)
										when X"08"  => 
															if busy_flag='0' then 
																lumstp<="0010"; 
															end if;
															
										-- Command 0x0009	- Check synchrony signals from sorting board (TSYNC1-2)
										when X"09"  => 
															data_rd(0) <= TSYNC1_i;
															data_rd(1) <= TSYNC2_i;
															lumstp<="1111"; 
															
										-- Command 0x000A - Enable IO Board Test input 
										when X"0A"  => 
															if busy_flag='0' then 
																lumstp<="0010"; 
															end if;
															
										-- Command 0x000B	- Check IO Board Test outputs 
										when X"0B"  => 
															data_rd(0) <= ALARME_TEST_i;
															data_rd(1) <= LIMP1_TEST_i;
															data_rd(2) <= LIMP2_TEST_i;
															data_rd(3) <= AQUEC_TEST_i;
															data_rd(4) <= FREE_TEST_1_i;
															data_rd(5) <= FREE_TEST_2_i;
															lumstp<="1111"; 
															
										-- Command 0x000C	- Read 256 CCD pixels -- FINALIZAR
										when X"0C"  => 
															lumstp<="1111"; 
										
										-- ejector module test										
										when X"49"  => 
														if busy_flag='0' then 
															lumstp <= "0011"; 
														end if;		
										
										-- read test word coming from ejector
										when X"50"  =>   
														-- low word
														data_rd <= ejet_reg(15 downto 0);
														lumstp <= "0011"; 
										
										

										when others => 
															lumstp <= "0000";
															busy_clr <= '0';
									
									end case;
				---------------------------------------------------------------------------------------------------
				when "0011" => lumstp <= "1111";

									case cmd_reg(7 downto 0) is
									
										-- Command 0x0003 - Checks data_wr from uC
										when X"03"  => 
															data_rd <= data_wr;
															lumstp <= "1111";
															
										-- Command 0x0004 - Activate LED outputs
										when X"04"  => 
															LED_OUTPUTS_o <= data_wr(0);
															lumstp <= "1111";
															
										-- Command 0x0005 - Test Sorting board ejectors inputs
										when X"05"  => 
															ENABLE_EJECTORS_o <= data_wr(0);
															lumstp <= "1111";
															
										-- Command 0x0008 - Test Sync signals (RSYNC1-2 from sorting board)
										when X"08"  => 
															RSYNC_o <= data_wr(0);
															lumstp <= "1111";
															
										-- Command 0x000A - Enable IO Board Test input 
										when X"0A"  => 
															IO_TEST_o <= data_wr(0);
															lumstp <= "1111";
										
										-- ejector module test							
										when X"49"  => 
										
													-- write low word
															busy_clr<='1';
															ejlword<=data_wr;
															lumstp <= "0100";
													
										-- read test word coming from ejector				
										when X"50"  =>   
														-- high word
														data_rd <= ejet_reg(31 downto 16);
														lumstp <= "1111"; 
									
										when others => 
															lumstp <= "0000";
															busy_clr <= '0';
									
									end case;
				
				when "0100" then lumstp <= "0101"; 
										-- ejector module test		
										busy_clr<='0'; 
										if busy_flag='0' then 
											lumstp <="0011"; 
										end if; 
														
													
														
				when "0101" then lumstp <= "1111";										
										-- ejector module test	
										-- write high word
										busy_clr <='1';
										ejhword  <= data_wr;
										lumstp <= "1111";
										
										-- turn on mux one clock cycle before
										mux_start_next <= '1'; 
				
				---------------------------------------------------------------------------------------------------
				when "1111" => 
									
								
								if cmd_reg = x"49" then 	
									ejet_serial_tst_next <= ejhword & ejlword; 								
																	
									--turn off mux when words == 0
									 if ((ejhword = x"0000") and (ejlword = x"0000")) then
										 mux_start_next <= '0';
									 end if								
								end if;	
									
									if busy_flag = '1' then 
										lumstp <= "0000"; 
										busy_clr <= '1'; 
									end if;
							
									
									
				when others =>
									lumstp <= "0000"; 
									busy_clr <= '1';
									mux_start_next <= '0';
									
			
			end case;
		
		end if;
		
	end process;
	

end Behavioral;