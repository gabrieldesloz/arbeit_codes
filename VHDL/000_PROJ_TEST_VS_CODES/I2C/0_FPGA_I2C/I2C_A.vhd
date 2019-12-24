----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:23:02 09/08/2008 
-- Design Name: 
-- Module Name:    I2C_A - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2C_A is
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
end I2C_A;

architecture Behavioral of I2C_A is


begin

-------------------------------------------------------------------------------------------------------
-- maquina I2C

  process (rst,clk1) -- 100KHz
  variable m : integer range 0 to 63;
  variable i : integer range 0 to 7;
  begin
    if rst='1' then
	   m:=0;
		scl<='1';
		sda<='Z';
		i2cbusy<='0';
	 elsif falling_edge(clk1) then
	   case m is
		  when   0 => if sti2c='1' then m:=1; i2cbusy<='1'; end if;   
		              scl<='1'; sda<='Z';
		  when   1 => m:=2; sda<='0'; -- start condition
		  when   2 => m:=3; scl<='0'; i:=7;
		  when   3 => m:=4; if dataA(i)='0' then sda<='0'; else sda<='Z'; end if; -- endereco I2C
		  when   4 => m:=5; scl<='1';
		  when   5 =>       scl<='0'; i:=i-1; if i=7 then m:=6; else m:=3; end if;
		  when   6 => m:=7; sda<='Z';
		  when   7 => m:=8;  scl<='1'; -- ack
		  when   8 => m:=9; scl<='0'; i:=7;

		  when   9 => m:=10; if dataB(i)='0' then sda<='0'; else sda<='Z'; end if; -- endereco dentro do chip
		  when  10 => m:=11; scl<='1';
		  when  11 =>        scl<='0'; i:=i-1; if i=7 then m:=12; else m:=9; end if;
		  when  12 => m:=13; sda<='0'; -- ack forcado pelo master
		  when  13 => m:=14; scl<='1'; --ack clk
		  when  14 =>        scl<='0'; i:=7;
		              if ti2c(1)='1' then m:=15; else m:=40; end if; -- se READ continua, se WRITE pula para 40
-- READ
        when  15 => m:=16; sda<='Z'; -- prepara novo Start
		  when  16 => m:=17; scl<='1'; -- 
		  when  17 => m:=18; sda<='0'; -- re-start condition

		  when  18 => m:=19; scl<='0'; i:=7;
		  when  19 => m:=20; if i=0 then sda<='Z'; elsif dataA(i)='0' then sda<='0'; else sda<='Z'; end if; -- endereco I2C
		  when  20 => m:=21; scl<='1';
		  when  21 =>        scl<='0'; i:=i-1; if i=7 then m:=22; else m:=19; end if;
		  when  22 => m:=23; sda<='Z';
		  when  23 => m:=24;  scl<='1'; -- ack
		  when  24 => m:=25; scl<='0'; i:=7;

		  when  25 => m:=26; scl<='1';
		  when  26 => m:=27; dataRA(i)<=sda;	 -- dado de leitura 1
		  when  27 =>        scl<='0'; i:=i-1; if i=7 then m:=28; else m:=25; end if;
		  when  28 => m:=29; if ti2c(0)='1' then sda<='0'; end if;
		  when  29 => m:=30;  scl<='1'; -- ack / nack
		  when  30 => m:=31; scl<='0'; i:=7; 
		              if ti2c(0)='0' then m:=36; end if; -- le apenas um byte e faz stop

		  when  31 => m:=32; scl<='1';
		  when  32 => m:=33; dataRB(i)<=sda;	 -- dado de leitura 2
		  when  33 =>        scl<='0'; i:=i-1; if i=7 then m:=34; else m:=31; end if;
		  when  34 => m:=35; scl<='1'; -- / nack
		  when  35 => m:=36; scl<='0'; i:=7; 

		  when  36 => m:=37; sda<='0'; -- prepara STOP
		  when  37 => m:=38; scl<='1'; -- 
		  when  38 => m:=0;  sda<='1'; i2cbusy<='0'; -- faz STOP

-- WRITE
		  when  40 => m:=41; if dataWA(i)='0' then sda<='0'; else sda<='Z'; end if; -- dado de escrita 1
		  when  41 => m:=42; scl<='1';
		  when  42 =>        scl<='0'; i:=i-1; if i=7 then m:=43; else m:=40; end if;
		  when  43 => m:=44; sda<='0'; -- ack forcado pelo master
		  when  44 => m:=45; scl<='1'; --ack clk
		  when  45 =>        scl<='0'; i:=7;
		              if ti2c(0)='1' then m:=46; else m:=36; end if; -- se 1 byte faz stop, se 2 bytes continua

		  when  46 => m:=47; if dataWB(i)='0' then sda<='0'; else sda<='Z'; end if; -- dado de escrita 1
		  when  47 => m:=48; scl<='1';
		  when  48 =>        scl<='0'; i:=i-1; if i=7 then m:=49; else m:=46; end if;
		  when  49 => m:=50; sda<='0'; -- ack forcado pelo master
		  when  50 => m:=41; scl<='1'; --ack clk
		  when  51 => m:=36; scl<='0'; -- STOP 
    
		  when others => m:=0;
		end case;
	 end if;
  end process;


end Behavioral;

