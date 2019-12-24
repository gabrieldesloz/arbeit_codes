----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:23:38 02/11/2011 
-- Design Name: 
-- Module Name:    memdef - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity memdef is
    Port ( defcont_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           wcont : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           wdefen : in  STD_LOGIC;
           rcont : out  STD_LOGIC_VECTOR (7 downto 0));
end memdef;

architecture Behavioral of memdef is

signal wen: std_logic_vector (0 downto 0);
--component BRAM256x8
--	port (
--	clka: in std_logic;
--	wea: in std_logic_vector(0 downto 0);
--	addra: in std_logic_vector(7 downto 0);
--	dina: in std_logic_vector(7 downto 0);
--	douta: out std_logic_vector(7 downto 0));
--end component;

-- 256x8 dsitribute RAM
component mem256x8
	port (
	a: in std_logic_vector(7 downto 0);
	d: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	we: in std_logic;
	qspo: out std_logic_vector(7 downto 0));
end component;

begin

wen(0) <= '1' when wdefen='1' else '0';

defect : mem256x8 port map (defcont_addr,wcont,clk,wdefen,rcont);
--defect : bram256x8 port map (clk,wen,defcont_addr,wcont,rcont);

end Behavioral;

