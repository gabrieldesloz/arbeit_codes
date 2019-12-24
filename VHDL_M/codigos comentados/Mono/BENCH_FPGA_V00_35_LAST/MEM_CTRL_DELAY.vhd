----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:51:45 03/10/2011 
-- Design Name: 
-- Module Name:    MEM_CTRL - Behavioral 
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
-- a cada 20us o ponteiro das memorias é incrementado  em 1 + sinal de sincronia SYNC_XX_0_i


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MEM_CTRL_DELTA is
    Port ( C20US_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
		      -- entrada do asionamento das ejetoras 
			  CH_EJ_i : in  STD_LOGIC_VECTOR (63 downto 0);
			  CH_EJ_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  SYNC_31_0_i : in  STD_LOGIC_VECTOR (8 downto 0);
			  SYNC_63_32_i : in  STD_LOGIC_VECTOR (8 downto 0));
end MEM_CTRL_DELTA;

architecture Behavioral of MEM_CTRL_DELTA is

-- Memoria 32x512
component MEM_SYNC
	port (
	clka: in std_logic;
	wea: in std_logic_vector(0 downto 0);
	addra: in std_logic_vector(8 downto 0);
	dina: in std_logic_vector(31 downto 0);
	clkb: in std_logic;
	addrb: in std_logic_vector(8 downto 0);
	doutb: out std_logic_vector(31 downto 0));
end component;

-- Synplicity black box declaration
attribute syn_black_box : boolean;
attribute syn_black_box of MEM_SYNC: component is true;

signal s_wr_ptr_31_0 : STD_LOGIC_VECTOR (8 downto 0); 
signal s_wr_ptr_63_32 : STD_LOGIC_VECTOR (8 downto 0); 

signal s_rd_ptr : STD_LOGIC_VECTOR (8 downto 0); 

begin

i_MEM_SYNC1 : MEM_SYNC
		port map (
			clka => C20US_i,
			wea => "1",
			addra => s_wr_ptr_31_0,
			dina => CH_EJ_i(31 downto 0),
			clkb => C20US_i,
			addrb => s_rd_ptr,
			doutb => CH_EJ_o(31 downto 0)
			);
			
i_MEM_SYNC2 : MEM_SYNC
		port map (
			clka => C20US_i,
			wea => "1",
			addra => s_wr_ptr_63_32,
			dina => CH_EJ_i(63 downto 32),
			clkb => C20US_i,
			addrb => s_rd_ptr,
			doutb => CH_EJ_o(63 downto 32)
			);

s_wr_ptr_31_0 <= s_rd_ptr + SYNC_31_0_i;
s_wr_ptr_63_32 <= s_rd_ptr + SYNC_63_32_i;



p_CONTROL : process (RST_i, C20US_i)
begin

	if (RST_i = '1') then
		s_rd_ptr <= "000000000";
	elsif rising_edge(C20US_i) then
		s_rd_ptr <= s_rd_ptr + 1;

	end if;
		
end process;

end Behavioral;

