--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    16:19:57 08/28/08
-- Design Name:    
-- Module Name:    I2C - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity I2C is
    Port ( CLK50 : in std_logic;
           RST : in std_logic;
           LEDS : out std_logic_vector(7 downto 0);
			  TEMP_VCC,tp : out std_logic;
			  rx232 : in std_logic;
			  tx232 : out std_logic;
           SDA : inout std_logic;
           SCL : out std_logic);
end I2C;

architecture Behavioral of I2C is

signal sti2c,i2cbusy : std_logic;
signal ti2c : std_logic_vector(1 downto 0);
signal clk,clk2x,iclk,clk1,clk1u : std_logic;

signal dataA,dataB,dataRA,dataRB,dataWA,dataWB : std_logic_vector(7 downto 0);

signal TXDATA,RXDATA : STD_LOGIC_VECTOR (7 downto 0);
signal TXbusy,TXgo,RXrdy,RXrd  : std_logic;


component RS232 is
    Port ( clk50 : in  STD_LOGIC; -- 50MHz clock
           rst : in  STD_LOGIC; -- 1 is reset level
           RX232 : in  STD_LOGIC;
           TX232 : out  STD_LOGIC;
           TXDATA : in  STD_LOGIC_VECTOR (7 downto 0);
           TXbusy : out  STD_LOGIC; -- 1 informs there still bits in the TX shift register and caller cannot send new data
           TXgo : in  STD_LOGIC; -- a 1 pulse starts TX process
           RXDATA : out  STD_LOGIC_VECTOR (7 downto 0);
           RXrdy : out  STD_LOGIC; -- informs there is a new byte in RXDATA
			  RXrd  : in std_logic); -- caller must pulse this signal to inform the RXDATA byte was read
end component;

component I2C_A is
    Port ( CLK1 : in  STD_LOGIC; -- up to 100KHz
           rst : in  STD_LOGIC;
           SDA : inout  STD_LOGIC;
           SCL : out  STD_LOGIC;
           DATAA : in  STD_LOGIC_VECTOR (7 downto 0);
           DATAB : in  STD_LOGIC_VECTOR (7 downto 0);
           DATARA : out  STD_LOGIC_VECTOR (7 downto 0);
           DATARB : out  STD_LOGIC_VECTOR (7 downto 0);
           DATAWA : in  STD_LOGIC_VECTOR (7 downto 0);
           DATAWB : in  STD_LOGIC_VECTOR (7 downto 0);
           TI2C : in  STD_LOGIC_VECTOR (1 downto 0);
           STI2C : in  STD_LOGIC;
           I2Cbusy : out  STD_LOGIC);
end component;

begin


   TEMP_VCC <='1';

-- clocks do sistema --------------------------------------------------------------

-- duplica para obter clock de 20MHz para sincronismos

   -- DCM: Digital Clock Manager Circuit for Virtex-II/II-Pro and Spartan-3/3E
   -- Xilinx HDL Language Template version 7.1i

   DCM_inst : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 2, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 0.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 => iCLK,     -- 0 degree DCM CLK ouptput
      CLK180 => open, -- 180 degree DCM CLK output
      CLK270 => open, -- 270 degree DCM CLK output
      CLK2X => CLK2X,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => open,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, -- 180 degree CLK synthesis out
      LOCKED => tp, -- DCM LOCK status output
      PSDONE => open, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => CLK,   -- DCM clock feedback
      CLKIN => CLK50,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => '0',   -- Dynamic phase adjust clock input
      PSEN => '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
      RST => rst        -- DCM asynchronous reset input
   );

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => clk,  I => iclk); -- 50MHz

-- clock generation

   process (clk)
	variable dv0: integer range 0 to 511;
	begin
	  if rising_edge(clk) then
		  dv0:=dv0+1; if dv0=250 then dv0:=0; clk1u<=not clk1u; end if;	-- 10KHz
	  end if;
	end process;

   BUFG_100KHz : BUFG
   port map ( O => clk1,  I => clk1u); -- 100KHz



-------------------------------------------------------------------------------------------------------
-- porta serial RS232

 rs232cmp : rs232 port map (clk,rst,rx232,tx232,txdata,txbusy,txgo,rxdata,rxrdy,rxrd);

 i2c_comp : i2c_a port map (clk1,rst,sda,scl,dataa,datab,datara,datarb,datawa,datawb,ti2c,sti2c,i2cbusy);

 rxrd<=rxrdy;

-- maquina de estados gerencial
  process (rst,clk1) -- 100KHz
  variable x : integer range 0 to 63;
  begin
    if rst='1' then
	   x:=0;
		sti2c<='0';
	 elsif rising_edge(clk1) then
	   case x is
		  when   0 => x:=1; dataA<=x"90"; dataB<=X"00"; ti2c<="11"; -- read 2 bytes, endereco 90h
		  when   1 => sti2c<='1'; if i2cbusy='1' then x:=2; end if;
		  when   2 => sti2c<='0'; if i2cbusy='0' then x:=3; end if;
		  when   3 => x:=0; leds<=dataRA;
		  when others => x:=0;
		end case;
	 end if;
  end process;

end Behavioral;
