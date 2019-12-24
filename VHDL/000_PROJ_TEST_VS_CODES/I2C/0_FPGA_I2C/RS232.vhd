----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:10:08 09/08/2008 
-- Design Name: 
-- Module Name:    RS232 - Behavioral 
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

entity RS232 is
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
end RS232;

architecture Behavioral of RS232 is

signal tcc      : integer range 0 to 15;
signal notx     : std_logic;      -- controla envio de bytes
signal bdck     : std_logic;      -- clock mestre com 2 x baud-rate
signal stfall   : std_logic;      -- registra start bit foi reconhecido
signal waitbyte : std_logic;      -- reseta logica para esperar novo byte
signal bdref    : std_logic;      -- clock de referencia (igual ao baud-rate)
signal tsrx     : std_logic;      -- mascara de teste para sample
signal rxbin    : std_logic_vector (8 downto 0);



begin

-- gera clock de 38400*2
   process (clk50)
	variable zzzz:integer range 0 to 511;
	begin
	  if rising_edge(clk50) then
	    zzzz:=zzzz+1;
		 if zzzz>325 then zzzz:=0; bdck<=not bdck; end if;
	  end if;
	end process;


-- recebe dados pela serial ------------------------------------------------------------------------

	process (bdck) -- gera compasso de clock
	begin
	  if rising_edge(bdck) then
		  bdref<= not bdref;
	  end if;
	end process;


	process (rx232,rst,waitbyte) -- testa start bit na descida
	begin
	  if rst='1' or waitbyte='1' then
	     stfall<='0';
	  elsif falling_edge(rx232) then
	     if bdck='0' and bdref='0' then tsrx<='1'; end if;
	     if bdck='1' and bdref='0' then tsrx<='1'; end if;
	     if bdck='0' and bdref='1' then tsrx<='0'; end if;
	     if bdck='1' and bdref='1' then tsrx<='0'; end if;
	     stfall<='1'; 
	  end if;
	end process;



	process (bdck,rst,stfall,bdref,tsrx) -- maquina de recebimento
	variable rcc : integer range 0 to 10;
	begin
	  if rst='1' or stfall='0' then
	     rcc:=0;
	     waitbyte<='0';
	  elsif falling_edge(bdck) and bdref=tsrx then
	     rxbin(rcc)<=rx232;
		  rcc:=rcc+1;
		  if rcc=10 then
		    waitbyte<='1';
			 rxdata<=rxbin(8 downto 1);
		  end if;
	  end if;
	end process;
   
	process (waitbyte,rxrd,rst) -- avisa que recebeu um byte. Desliga aviso quando DTRD='1'
	begin
	  if rst='1' or rxrd='1' then
	     rxrdy<='0';
	  elsif rising_edge(waitbyte) then
	     rxrdy<='1';
	  end if;
	end process;


--------------------------------------------------
-- envia RS232


	process (txgo,tcc,rst) -- controla processo de envio
	begin
	  if (rst='1') or (tcc>11) then
	     notx<='1';
	  elsif rising_edge(txgo) then
	     notx<='0';
	  end if;
	end process;
	
	
   txbusy <= '0' when tcc=0 else '1';

	process (bdck,rst,notx,tcc,bdref) -- maquina de transmissao
	variable nbyte : integer range 0 to 255;
	begin
	  if (rst='1') or (notx='1') then
	     tcc<=0;
		  tx232<='1';
	  elsif falling_edge(bdck) and (bdref='1' and tcc<12) then
        case tcc is
		    when  0 => tx232<='1';
		    when  1 => tx232<='0';  -- start
			 when  2 => tx232<= txdata(0);
			 when  3 => tx232<= txdata(1);
			 when  4 => tx232<= txdata(2);
			 when  5 => tx232<= txdata(3);
			 when  6 => tx232<= txdata(4);
			 when  7 => tx232<= txdata(5);
			 when  8 => tx232<= txdata(6);
			 when  9 => tx232<= txdata(7);
		    when 11 => tx232<='1';
		    when others =>
		  end case;
		  tcc<=tcc+1;
	  end if;
	end process;


end Behavioral;

