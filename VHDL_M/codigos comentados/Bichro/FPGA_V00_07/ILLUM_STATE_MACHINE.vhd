----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:37:11 04/25/2013 
-- Design Name: 
-- Module Name:    ILLUM_STATE_MACHINE - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ILLUM_STATE_MACHINE is
	Port (
			clkaq : in std_logic;
			reset : in std_logic;
			floor : in std_logic
			);
end ILLUM_STATE_MACHINE;

architecture Behavioral of ILLUM_STATE_MACHINE is
signal sincin, sincout,clrsinc : std_logic;

-- Analog Front End 
signal afec : std_logic_vector (15 downto 0);
signal afeck, afeck0, afeck2 : std_logic;			
-- Front End state machine
signal pix : std_logic_vector (7 downto 0);-- Pixel counter
signal rled_counter, led_counter : std_logic_vector (1 downto 0);
signal proc : std_logic_vector (2 downto 0); -- scan line source for ALU process
signal multipmux : std_logic; 

signal fifoline,fifolinew : std_logic_vector (2 downto 0); -- points the previous line and current line being written on FIFO
signal canincfifoline : std_logic;
	 -- CCD interface
signal CCD_DIS1,CCD_DIS2,CCD_DIS3,CCD_DIS4 : std_logic;
signal CCD_CLK1,CCD_CLK2,CCD_CLK3,CCD_CLK4 : std_logic;
signal CCD_SI1,CCD_SI2,CCD_SI3,CCD_SI4 : std_logic;
signal CCD1, CCD2, CCD3, CCD4 : std_logic_vector(7 downto 0);

signal ledout,ledseq : STD_LOGIC_VECTOR (2 downto 0);
-- illumination interface
signal LED_duration : STD_LOGIC_VECTOR (7 downto 0);
  
component CAMERA_SIMULATOR is
    Port (  SI_i : in  STD_LOGIC;
				CLK_i : in  STD_LOGIC;
				RESET_i : in  STD_LOGIC;
				CCD_o : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal s_ccd_img : std_logic_vector(7 downto 0);

begin

i_CAMERA_SIMULATOR : CAMERA_SIMULATOR 
    Port map ( SI_i => CCD_SI1,
					CLK_i => CCD_CLK1,
					RESET_i => reset,
					CCD_o => s_ccd_img);

   process(clkaq,reset) -- 56.25MHz
	variable flag_si : std_logic;
   begin
	  if reset='1' then
	  	sincout <= '0';	
	    clrsinc<='0';
		 
	    afec <= "0000000000000001";
		 afeck2<='0';
		 afeck0<='0';
           CCD_CLK1<= '0';
			  CCD_CLK2<= '0';
			  CCD_CLK3<= '0';
			  CCD_CLK4<= '0';
			  CCD_SI1<= '0';
			  CCD_SI2<= '0';
			  CCD_SI3<= '0';
			  CCD_SI4<= '0';
		 flag_si:='0';	  
		 proc<="111"; -- default addressing gain correctiondata
		 multipmux<='0'; -- multiplier source is memory
		 ledseq<="001";
		 led_counter<="00";
		 led_duration<=X"8C"; --led_duration_rear;
		 ledout<="010";
		 pix<=x"00";
	    canincfifoline<='0';
	  elsif rising_edge(clkaq) then 
		 
		 proc<="111"; -- default addressing gain correctiondata
		 
	    case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
		   when "0000000000000001" => afec <= "0000000000000010";
			-- AFE
			   afeck2<='1'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			
			  case led_counter is
			    when "00" => proc<="100"; when "01" => proc<="101"; when "10" => proc<="110"; when others => proc<="111";
			  end case;	 

         -- board synch			
			  sincout<='0';

-- 1 ----------------------------------------------------------- --------------------------------------
		   when "0000000000000010" => afec <= "0000000000000100";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;

			  case led_counter is
			    when "00" => proc<="100"; when "01" => proc<="101"; when "10" => proc<="110"; when others => proc<="111";
			  end case;	 
         -- Line FIFO
			if canincfifoline='1' then
 			  fifoline<=fifoline+1;
			end if;  
				
-- 2 ----------------------------------------------------------- -----------------------------
		   when "0000000000000100" => afec <= "0000000000001000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  case led_counter is
			    when "00" => proc<="000"; when "01" => proc<="001"; when "10" => proc<="010"; when others => proc<="111";
			  end case;	 

			-- Line FIFO
			if canincfifoline='1' then
			  canincfifoline<='0'; -- this will release the sorting state machine
			end if;  
			  
         -- Illumination	
			   if LED_duration>X"00" then
               LED_duration<=LED_duration-1;		
				else
					LEDOUT <= "000"; -- turn OFF all lEDs
				end if;
				
-- 3 ----------------------------------------------------------- --------------------------
		   when "0000000000001000" => afec <= "0000000000010000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;

			  case led_counter is
			    when "00" => proc<="000"; when "01" => proc<="001"; when "10" => proc<="010"; when others => proc<="111";
			  end case;	 

-- 4 ----------------------------------------------------------- ----------------------------------------
		   when "0000000000010000" => afec <= "0000000000100000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
				
--			   ccd1(13 downto 6)<=adc1; 
--				ccd1(15 downto 14)<="00";
--				ccd3(13 downto 6)<=adc2; 
--				ccd3(15 downto 14)<="00";
				
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  -- select gain table according to illumination process
			  case led_counter is
			    when "00" => proc<="111"; 									
				 when "01" => proc<="011"; 
				 when "10" => proc<="111"; 
				 when others => proc<="111";
			  end case;	 

			  multipmux<='0'; -- multiplier source is memory

-- 5 ----------------------------------------------------------- -----------------------
		   when "0000000000100000" => afec <= "0000000001000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  -- select gain table according to illumination process
			  case led_counter is
			    when "00" => proc<="111"; 
				 when "01" => proc<="011"; 
				 when "10" => proc<="111"; 
				 when others => proc<="111";
			  end case;

-- 6 ----------------------------------------------------------- ------------------------
		   when "0000000001000000" => afec <= "0000000010000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
				
			   ccd1(7 downto 0)<=s_ccd_img;
				ccd3(7 downto 0)<=s_ccd_img; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;

-- 7 ----------------------------------------------------------- ---------------------
		   when "0000000010000000" => afec <= "0000000100000000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;

				multipmux<='1'; -- next multiplier source is group_gain

-- 8 ----------------------------------------------------------- ----------------------
		   when "0000000100000000" => afec <= "0000001000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='0';
				
--			   ccd2(13 downto 6)<=adc1; 
--				ccd2(15 downto 14)<="00";
--				ccd4(13 downto 6)<=adc2; 
--				ccd4(15 downto 14)<="00";

			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;

-- 9 ----------------------------------------------------------- -------------------------
		   when "0000001000000000" => afec <= "0000010000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
		
		
-- 10 ----------------------------------------------------------- -------------------------
		   when "0000010000000000" => afec <= "0000100000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
				
			   ccd2(7 downto 0)<=s_ccd_img; 
				ccd4(7 downto 0)<=s_ccd_img; 
				
			-- CCD
            CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			   if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				               else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			   end if;

         -- front end memory & illumination
			  if flag_si='1'then flag_si:='0'; end if; -- finish CCD_SI pulse
       
--		   -- sinc generation
			  if pix=X"FF" then
             case LEDSEQ is
	            when "100" => sincout<='1'; 
	 	         when others => sincout<='0';
	          end case;
			  else
             sincout<='0';			  
			  end if;
			  
-- 11 ----------------------------------------------------------- 
		   when "0000100000000000" => afec <= "0000000000000001";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
         -- front end memory & illumination & FIFO
								
			  pix<=pix+1;
			  
			  if pix=X"FE" then
			    flag_si:='1'; -- start CCD_SI pulse once every 256 pixels
			  end if;
			  
			  if pix=X"FF" then

             case LEDSEQ is
	            when "001" => LEDSEQ<="010"; 
					              LEDOUT <= "001"; 
									  led_counter<="01"; -- illum front ON, store REAR
									  LED_duration<=X"8C";
									  
	            when "010" => LEDSEQ<="100"; 
					              if (floor='1') then
					              LEDOUT <= "000"; 
									  led_counter<="10"; -- illum bckgnd OFF, store FRONT
									  else
					              LEDOUT <= "100"; 
									  led_counter<="10"; -- illum bckgnd ON, store FRONT
									  end if;
									  LED_duration<=X"8C";
	            when "100" => LEDSEQ<="001"; 
					              LEDOUT <= "010"; 
									  led_counter<="00"; -- illum rear ON, store BackGnd
									  LED_duration<=X"8C";
									  sincout<='1';

                             canincfifoline<='1';
									  
	 	         when others => LEDOUT <= "000"; led_counter<="00"; LEDSEQ<="001";
	          end case;
			  else
             sincout<='0';			  
			  end if;


-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
		   when "0001000000000000" => afec <= "0000000000000001";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
				 
				pix<=X"00";
	         LEDSEQ<="001"; 
				LEDOUT <= "010"; 
				led_counter<="00"; -- illum rear ON, store BackGnd
				LED_duration<=X"8C";

            canincfifoline<='1';

            sincout<='0';

		   when others => afec <= "0000000000000001";
		 end case;
		 
	-- board synch	 
		 clrsinc<='0';
		 if sincin='1' then
		  afec <= "0001000000000000"; -- synch phantom step
		  clrsinc<='1';
		 end if;
		 
     end if;	  
   end process;	
	
end Behavioral;

