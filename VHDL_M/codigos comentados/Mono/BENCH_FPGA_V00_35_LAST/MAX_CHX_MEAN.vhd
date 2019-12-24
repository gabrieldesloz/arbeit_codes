----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:17:55 08/03/2011 
-- Design Name: 
-- Module Name:    MEAN_GAIN_TABLE - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAX_CHX_MEAN is
    Port ( REFLECT_MEAN_i : in  STD_LOGIC_VECTOR (63 downto 0);
			  TRANSLUC_MEAN_i : in  STD_LOGIC_VECTOR (63 downto 0);
			  EJETA_i : in STD_LOGIC_VECTOR(4 downto 0);
			  EJETB_i : in STD_LOGIC_VECTOR(4 downto 0);
           ADDR_RD_i : in  STD_LOGIC_VECTOR (4 downto 0);
			  POX_i : in  STD_LOGIC_VECTOR (7 downto 0);
			  BOUNDARIES_A_i : in STD_LOGIC_VECTOR (15 downto 0);
			  BOUNDARIES_B_i : in STD_LOGIC_VECTOR (15 downto 0);
			  GEN_TAB_i : in std_logic;
			  CANMAX_i : in STD_LOGIC;
			  IS_EXTACCESS_i : in std_logic;
			  CLK_i : in  STD_LOGIC;
			  CLK_INV_i : in STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  GEN_TAB_CLR_o : out std_logic;
           MAX_A_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  MAX_B_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  FINAL_MEAN_A_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  FINAL_MEAN_B_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  TABLE_READY_o : out STD_LOGIC);
end MAX_CHX_MEAN;

architecture Behavioral of MAX_CHX_MEAN is

COMPONENT MEM_32x64
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

COMPONENT MEM_ROMPIXVAL
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

signal s_table_ready, s_gen_tab_clr : std_logic;
signal s_we_a_int, s_we_b_int : std_logic;
signal s_boundaries_a, s_boundaries_b : std_logic;
signal s_we_max_a, s_we_max_b : std_logic_vector(0 downto 0);
signal st_max : std_logic_vector(4 downto 0);
signal s_rd_addr_a, s_rd_addr_b, s_addr_clr, s_mean_rd_addr_a, s_mean_rd_addr_b : std_logic_vector(4 downto 0);
signal s_wr_addr_a, s_wr_addr_b : std_logic_vector(4 downto 0);
signal s_max_a_in, s_max_b_in : std_logic_vector(63 downto 0);
signal s_max_a_in_int, s_max_b_in_int : std_logic_vector(63 downto 0);
signal s_max_a_out, s_max_b_out : std_logic_vector(63 downto 0);
signal s_acc_reflect_max, s_acc_transluc_max : std_logic_vector(15 downto 0);
signal s_acc2_reflect_max, s_acc2_transluc_max : std_logic_vector(15 downto 0);
signal s_accb_reflect_max, s_accb_transluc_max : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_max, s_acc2b_transluc_max : std_logic_vector(15 downto 0);
signal s_acc_reflect_max_int, s_acc_transluc_max_int : std_logic_vector(15 downto 0);
signal s_acc2_reflect_max_int, s_acc2_transluc_max_int : std_logic_vector(15 downto 0);
signal s_accb_reflect_max_int, s_accb_transluc_max_int : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_max_int, s_acc2b_transluc_max_int : std_logic_vector(15 downto 0);
signal s_acc_reflect_max_tst, s_acc_transluc_max_tst : std_logic_vector(15 downto 0);
signal s_acc2_reflect_max_tst, s_acc2_transluc_max_tst : std_logic_vector(15 downto 0);
signal s_accb_reflect_max_tst, s_accb_transluc_max_tst : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_max_tst, s_acc2b_transluc_max_tst : std_logic_vector(15 downto 0);
signal s_acc_reflect_mean, s_acc_transluc_mean : std_logic_vector(15 downto 0);
signal s_acc2_reflect_mean, s_acc2_transluc_mean : std_logic_vector(15 downto 0);
signal s_accb_reflect_mean, s_accb_transluc_mean : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_mean, s_acc2b_transluc_mean : std_logic_vector(15 downto 0);

-- Gain
signal s_we_gain_int : std_logic;
signal s_we_gain : std_logic_vector(0 downto 0);
signal s_rom_rd_addr : std_logic_vector(2 downto 0);
signal s_rec_mem_addr : std_logic_vector(7 downto 0);
signal s_acc_reflect_final_mean, s_acc_transluc_final_mean : std_logic_vector(15 downto 0);
signal s_acc2_reflect_final_mean, s_acc2_transluc_final_mean : std_logic_vector(15 downto 0);
signal s_accb_reflect_final_mean, s_accb_transluc_final_mean : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_final_mean, s_acc2b_transluc_final_mean : std_logic_vector(15 downto 0);
signal s_rec_mem_out : std_logic_vector(15 downto 0);
signal s_acc_reflect_rec, s_acc_transluc_rec : std_logic_vector(15 downto 0);
signal s_acc2_reflect_rec, s_acc2_transluc_rec : std_logic_vector(15 downto 0);
signal s_accb_reflect_rec, s_accb_transluc_rec : std_logic_vector(15 downto 0);
signal s_acc2b_reflect_rec, s_acc2b_transluc_rec : std_logic_vector(15 downto 0);
signal s_acc_reflect_32_mean, s_acc_transluc_32_mean : std_logic_vector(20 downto 0);
signal s_acc2_reflect_32_mean, s_acc2_transluc_32_mean : std_logic_vector(20 downto 0);
signal s_accb_reflect_32_mean, s_accb_transluc_32_mean : std_logic_vector(20 downto 0);
signal s_acc2b_reflect_32_mean, s_acc2b_transluc_32_mean : std_logic_vector(20 downto 0);
signal s_acc_reflect_gain_int, s_acc_transluc_gain_int : std_logic_vector(47 downto 0);
signal s_acc2_reflect_gain_int, s_acc2_transluc_gain_int : std_logic_vector(47 downto 0);
signal s_accb_reflect_gain_int, s_accb_transluc_gain_int : std_logic_vector(47 downto 0);
signal s_acc2b_reflect_gain_int, s_acc2b_transluc_gain_int : std_logic_vector(47 downto 0);
signal s_gain_a_in, s_gain_a_out : std_logic_vector(63 downto 0);
signal s_gain_b_in, s_gain_b_out : std_logic_vector(63 downto 0);

begin	

	i_MEM_REC : MEM_ROMPIXVAL
	  PORT MAP (
		 clka => CLK_INV_i,
		 addra => s_rec_mem_addr,
		 douta => s_rec_mem_out
	  );
	-------------------------------------------------------
	
	i_MEM_GAIN_A : MEM_32x64
	  PORT MAP (
		 clka => CLK_INV_i,
		 wea => s_we_gain,
		 addra => s_mean_rd_addr_a,
		 dina => s_gain_a_in,
		 clkb => CLK_INV_i,
		 addrb => ADDR_RD_i,
		 doutb => s_gain_a_out
	  );
	  	  
	  s_we_gain <= "1" when ((s_we_gain_int = '1') and (IS_EXTACCESS_i = '0')) else "0";
	-------------------------------------------------------
	
	i_MEM_GAIN_B : MEM_32x64
	  PORT MAP (
		 clka => CLK_INV_i,
		 wea => s_we_gain,
		 addra => s_mean_rd_addr_b,
		 dina => s_gain_b_in,
		 clkb => CLK_INV_i,
		 addrb => ADDR_RD_i,
		 doutb => s_gain_b_out
	  );
	  
	-----------------------------------------------------

	i_MEM_MAX_A : MEM_32x64
	  PORT MAP (
		 clka => CLK_INV_i,
		 wea => s_we_max_a,
		 addra => s_wr_addr_a,
		 dina => s_max_a_in,
		 clkb => CLK_INV_i,
		 addrb => s_rd_addr_a,
		 doutb => s_max_a_out
	  );
	  
		MAX_A_o <= s_gain_a_out;
	  
		s_we_max_a <= "1" when (((s_we_a_int = '1') and (IS_EXTACCESS_i = '0')) or (s_gen_tab_clr = '1')) else  "0";
	  
		s_rd_addr_a <= ADDR_RD_i when (IS_EXTACCESS_i = '1') else s_mean_rd_addr_a;
	  
	-------------------------------------------------------
	  
	i_MEM_MAX_B : MEM_32x64
	  PORT MAP (
		 clka => CLK_INV_i,
		 wea => s_we_max_b,
		 addra => s_wr_addr_b,
		 dina => s_max_b_in,
		 clkb => CLK_INV_i,
		 addrb => s_rd_addr_b,
		 doutb => s_max_b_out
	  );
	  	  
		MAX_B_o <= s_gain_b_out;
	  
		s_we_max_b <= "1" when (((s_we_b_int = '1') and (IS_EXTACCESS_i = '0')) or (s_gen_tab_clr = '1')) else  "0";
	  
		s_rd_addr_b <= ADDR_RD_i when (IS_EXTACCESS_i = '1') else s_mean_rd_addr_b;
	  
	-------------------------------------------------------
	-- Floor CTRL
	s_wr_addr_a <= s_addr_clr when (s_gen_tab_clr = '1') else EJETA_i;
	s_wr_addr_b <= s_addr_clr when (s_gen_tab_clr = '1') else EJETB_i;
	s_max_a_in <= (others=>'0') when (s_gen_tab_clr = '1') else s_max_a_in_int;
	s_max_b_in <= (others=>'0') when (s_gen_tab_clr = '1') else s_max_b_in_int;
	-------------------------------------------------------
	
	TABLE_READY_o <= s_table_ready;
	GEN_TAB_CLR_o <= s_gen_tab_clr;
	
	s_boundaries_a <= '1' when ((POX_i >= BOUNDARIES_A_i(15 downto 8)) and (POX_i <= BOUNDARIES_A_i(7 downto 0))) else '0';
	s_boundaries_b <= '1' when ((POX_i >= BOUNDARIES_B_i(15 downto 8)) and (POX_i <= BOUNDARIES_B_i(7 downto 0))) else '0';
	
	FINAL_MEAN_A_o <= 	s_acc_reflect_final_mean &
								s_acc2_reflect_final_mean &
								s_acc_transluc_final_mean &
								s_acc2_transluc_final_mean;
								
	FINAL_MEAN_B_o <= 	s_accb_reflect_final_mean &
								s_acc2b_reflect_final_mean &
								s_accb_transluc_final_mean &
								s_acc2b_transluc_final_mean;
		
	process (CLK_i, RST_i, GEN_TAB_i, CANMAX_i, POX_i, s_mean_rd_addr_a) 
	begin
	  if (RST_i = '1') then
	  
			st_max <= "00000";
			s_we_a_int <= '0';
			s_we_b_int <= '0';
			s_addr_clr <= (others=>'0');
			s_gen_tab_clr <= '0';
			s_table_ready <= '1';
			s_mean_rd_addr_a <= (others=>'0');
			s_mean_rd_addr_b <= (others=>'0');
			s_we_gain_int <= '0';
		  
	  elsif rising_edge (CLK_i) then
	  
--			s_we_int <= '0';
			
			s_addr_clr <= s_addr_clr + 1;
	  
			case st_max is
			-------------------------- 0 --------------------------
				when "00000" =>	s_mean_rd_addr_a <= (others=>'0'); 
										s_mean_rd_addr_b <= (others=>'0');
										s_rom_rd_addr <= (others=>'0');
																														
										if (GEN_TAB_i = '1') then
											s_table_ready <= '0';
											if (POX_i = X"00") then
												st_max <= "00001";
											else
												st_max <= "00000";
											end if;
										else
											st_max <= "00000";
										end if;
			-------------------------- 1 --------------------------
				when "00001" =>	s_mean_rd_addr_a <= EJETA_i; 
										s_mean_rd_addr_b <= EJETB_i; 
										s_we_a_int <= '0';
										s_we_b_int <= '0';
										
										--63------47-------31------15-------
										-- ACCR -- ACC2R -- ACCT -- ACC2T --
										------------------------------------
										
										--63-------47--------31-------15--------
										-- ACCBR -- ACC2BR -- ACCBT -- ACC2BT --
										----------------------------------------
									
									-- ACC
										s_acc_reflect_max <=	s_max_a_out(63 downto 48);
										s_acc_reflect_mean <= REFLECT_MEAN_i(63 downto 48);
										s_acc_transluc_max <= s_max_a_out(31 downto 16);
										s_acc_transluc_mean <= TRANSLUC_MEAN_i(63 downto 48);
									-- ACC2
										s_acc2_reflect_max <= s_max_a_out(47 downto 32);
										s_acc2_reflect_mean <= REFLECT_MEAN_i(47 downto 32);
										s_acc2_transluc_max <= s_max_a_out(15 downto 0);
										s_acc2_transluc_mean <= TRANSLUC_MEAN_i(47 downto 32);
									-- ACCB
										s_accb_reflect_max <= s_max_b_out(63 downto 48);
										s_accb_reflect_mean <= REFLECT_MEAN_i(31 downto 16);
										s_accb_transluc_max <= s_max_b_out(31 downto 16);
										s_accb_transluc_mean <= TRANSLUC_MEAN_i(31 downto 16);
									-- ACC2B
										s_acc2b_reflect_max <= s_max_b_out(47 downto 32);
										s_acc2b_reflect_mean <= REFLECT_MEAN_i(15 downto 0);
										s_acc2b_transluc_max <= s_max_b_out(15 downto 0);
										s_acc2b_transluc_mean <= TRANSLUC_MEAN_i(15 downto 0);
																			
									if CANMAX_i = '1' then
										st_max <= "00010";
									else
										st_max <= "00001";
									end if;
			-------------------------- 2 --------------------------
				when "00010" => 
									-- ACC
										if (s_acc_reflect_mean > s_acc_reflect_max) then
											s_acc_reflect_max <= s_acc_reflect_mean;
										else
											s_acc_reflect_max <= s_acc_reflect_max;
										end if;
										
										if (s_acc_transluc_mean > s_acc_transluc_max) then
											s_acc_transluc_max <= s_acc_transluc_mean;
										else
											s_acc_transluc_max <= s_acc_transluc_max;
										end if;
										
									-- ACC2
										if (s_acc2_reflect_mean > s_acc2_reflect_max) then
											s_acc2_reflect_max <= s_acc2_reflect_mean;
										else
											s_acc2_reflect_max <= s_acc2_reflect_max;
										end if;
										
										if (s_acc2_transluc_mean > s_acc2_transluc_max) then
											s_acc2_transluc_max <= s_acc2_transluc_mean;
										else
											s_acc2_transluc_max <= s_acc2_transluc_max;
										end if;
										
									-- ACCB
										if (s_accb_reflect_mean > s_accb_reflect_max) then
											s_accb_reflect_max <= s_accb_reflect_mean;
										else
											s_accb_reflect_max <= s_accb_reflect_max;
										end if;
										
										if (s_accb_transluc_mean > s_accb_transluc_max) then
											s_accb_transluc_max <= s_accb_transluc_mean;
										else
											s_accb_transluc_max <= s_accb_transluc_max;
										end if;
										
									-- ACC2B
										if (s_acc2b_reflect_mean > s_acc2b_reflect_max) then
											s_acc2b_reflect_max <= s_acc2b_reflect_mean;
										else
											s_acc2b_reflect_max <= s_acc2b_reflect_max;
										end if;
										
										if (s_acc2b_transluc_mean > s_acc2b_transluc_max) then
											s_acc2b_transluc_max <= s_acc2b_transluc_mean;
										else
											s_acc2b_transluc_max <= s_acc2b_transluc_max;
										end if;
										
										st_max <= "00011";
			-------------------------- 3 --------------------------
				when "00011" =>	s_max_a_in_int <= s_acc_reflect_max & s_acc2_reflect_max & s_acc_transluc_max & s_acc2_transluc_max;
										s_max_b_in_int <= s_accb_reflect_max & s_acc2b_reflect_max & s_accb_transluc_max & s_acc2b_transluc_max;	
										st_max <= "00100";
			-------------------------- 4 --------------------------
				when "00100" =>	s_we_a_int <= s_boundaries_a;
										s_we_b_int <= s_boundaries_b;
										st_max <= "00101";
			-------------------------- 5 --------------------------
				when "00101" =>	st_max <= "00110";
			-------------------------- 6 --------------------------
				when "00110" =>	if (POX_i = X"FE") then
											st_max <= "00111";
											s_mean_rd_addr_a <= (others => '0');
											s_mean_rd_addr_b <= (others => '0');
											
											s_we_a_int <= '0';
											s_we_b_int <= '0';

											-- ACC
												s_acc_reflect_32_mean <= (others => '0');
												s_acc_transluc_32_mean <= (others => '0');
											-- ACC2
												s_acc2_reflect_32_mean <= (others => '0');
												s_acc2_transluc_32_mean <= (others => '0');
											-- ACCB
												s_accb_reflect_32_mean <= (others => '0');
												s_accb_transluc_32_mean <= (others => '0');
											-- ACC2B
												s_acc2b_reflect_32_mean <= (others => '0');
												s_acc2b_transluc_32_mean <= (others => '0');
												
										else
											st_max <= "00001";
										end if;
														
			-------------------------- 7 --------------------------
				when "00111" =>	st_max <= "01000";
			-------------------------- 8 --------------------------
				when "01000" =>	
									-- ACC
										s_acc_reflect_max_int <= s_max_a_out(63 downto 48);
										s_acc_transluc_max_int <= s_max_a_out(31 downto 16);
									-- ACC2
										s_acc2_reflect_max_int <= s_max_a_out(47 downto 32);
										s_acc2_transluc_max_int <= s_max_a_out(15 downto 0);
									-- ACCB
										s_accb_reflect_max_int <= s_max_b_out(63 downto 48);
										s_accb_transluc_max_int <= s_max_b_out(31 downto 16);
									-- ACC2B
										s_acc2b_reflect_max_int <= s_max_b_out(47 downto 32);
										s_acc2b_transluc_max_int <= s_max_b_out(15 downto 0);
										
										st_max <= "01001";
			-------------------------- 9 --------------------------
				when "01001" =>	
									-- ACC
										s_acc_reflect_32_mean <= s_acc_reflect_32_mean + ("00000" & s_acc_reflect_max_int);
										s_acc_transluc_32_mean <= s_acc_transluc_32_mean + ("00000" & s_acc_transluc_max_int);
									-- ACC2
										s_acc2_reflect_32_mean <= s_acc2_reflect_32_mean + ("00000" & s_acc2_reflect_max_int);
										s_acc2_transluc_32_mean <= s_acc2_transluc_32_mean + ("00000" & s_acc2_transluc_max_int);
									-- ACCB
										s_accb_reflect_32_mean <= s_accb_reflect_32_mean + ("00000" & s_accb_reflect_max_int);
										s_accb_transluc_32_mean <= s_accb_transluc_32_mean + ("00000" & s_accb_transluc_max_int);
									-- ACC2B
										s_acc2b_reflect_32_mean <= s_acc2b_reflect_32_mean + ("00000" & s_acc2b_reflect_max_int);
										s_acc2b_transluc_32_mean <= s_acc2b_transluc_32_mean + ("00000" & s_acc2b_transluc_max_int);
				
										st_max <= "01010";
			-------------------------- 10 -------------------------
				when "01010" =>	
										if	(s_mean_rd_addr_a = "11111") then
											s_mean_rd_addr_a <= (others => '0');
											s_mean_rd_addr_b <= (others => '0');
											st_max <= "01011";
										else
											s_mean_rd_addr_a <= s_mean_rd_addr_a + 1;
											s_mean_rd_addr_b <= s_mean_rd_addr_b + 1;
											st_max <= "00111";
										end if;
			-------------------------- 11 -------------------------
				when "01011" =>	
									-- ACC
										s_acc_reflect_final_mean <= s_acc_reflect_32_mean(18 downto 3);
										s_acc_transluc_final_mean <= s_acc_transluc_32_mean(18 downto 3);
									-- ACC2
										s_acc2_reflect_final_mean <= s_acc2_reflect_32_mean(18 downto 3);
										s_acc2_transluc_final_mean <= s_acc2_transluc_32_mean(18 downto 3);
									-- ACCB
										s_accb_reflect_final_mean <= s_accb_reflect_32_mean(18 downto 3);
										s_accb_transluc_final_mean <= s_accb_transluc_32_mean(18 downto 3);
									-- ACC2B
										s_acc2b_reflect_final_mean <= s_acc2b_reflect_32_mean(18 downto 3);
										s_acc2b_transluc_final_mean <= s_acc2b_transluc_32_mean(18 downto 3);	

										st_max <= "01100";
			-------------------------- 12 -------------------------
				when "01100" =>	st_max <= "01101";
			-------------------------- 13 -------------------------
				when "01101" =>	case s_rom_rd_addr is
											when "000" => s_rec_mem_addr <= s_max_a_out(61 downto 54);
											when "001" => s_rec_mem_addr <= s_max_a_out(29 downto 22);
											when "010" => s_rec_mem_addr <= s_max_a_out(45 downto 38);
											when "011" => s_rec_mem_addr <= s_max_a_out(13 downto 6);
											when "100" => s_rec_mem_addr <= s_max_b_out(61 downto 54);
											when "101" => s_rec_mem_addr <= s_max_b_out(29 downto 22);
											when "110" => s_rec_mem_addr <= s_max_b_out(45 downto 38);
											when "111" => s_rec_mem_addr <= s_max_b_out(13 downto 6);
											when others => 
										end case;
										
										st_max <= "01110";
			-------------------------- 14 -------------------------
				when "01110" =>	st_max <= "01111";
			-------------------------- 15 -------------------------
				when "01111" =>	case s_rom_rd_addr is
											when "000" => s_acc_reflect_rec <= s_rec_mem_out;
											when "001" => s_acc_transluc_rec <= s_rec_mem_out;
											when "010" => s_acc2_reflect_rec <= s_rec_mem_out;	
											when "011" => s_acc2_transluc_rec <= s_rec_mem_out;											
											when "100" => s_accb_reflect_rec <= s_rec_mem_out;
											when "101" => s_accb_transluc_rec <= s_rec_mem_out;
											when "110" => s_acc2b_reflect_rec <= s_rec_mem_out;
											when "111" => s_acc2b_transluc_rec <= s_rec_mem_out;
											when others => 
										end case;
										
										st_max <= "10000";
			-------------------------- 16 -------------------------
				when "10000" =>	if (s_rom_rd_addr = "111") then
											s_rom_rd_addr <= "000";
											st_max <= "10001";
										else
											s_rom_rd_addr <= s_rom_rd_addr + 1;
											st_max <= "01100";
										end if;
			-------------------------- 17 -------------------------
				when "10001" =>	
									-- ACC
										s_acc_reflect_gain_int <= (s_acc_reflect_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc_reflect_rec);
										s_acc_transluc_gain_int <= (s_acc_transluc_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc_transluc_rec);
									-- ACC2
										s_acc2_reflect_gain_int <= (s_acc2_reflect_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc2_reflect_rec);
										s_acc2_transluc_gain_int <= (s_acc2_transluc_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc2_transluc_rec);
									-- ACC2
										s_accb_reflect_gain_int <= (s_accb_reflect_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_accb_reflect_rec);
										s_accb_transluc_gain_int <= (s_accb_transluc_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_accb_transluc_rec);
									-- ACC2B
										s_acc2b_reflect_gain_int <= (s_acc2b_reflect_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc2b_reflect_rec);
										s_acc2b_transluc_gain_int <= (s_acc2b_transluc_final_mean(15 downto 8) & "0000000000000000") * ("00000000" & s_acc2b_transluc_rec);
										
										st_max <= "10010";
			-------------------------- 18 -------------------------
				when "10010" =>	st_max <= "10011";
			-------------------------- 19 -------------------------
				when "10011" =>	s_gain_a_in <= s_acc_reflect_gain_int(39 downto 24) & s_acc2_reflect_gain_int(39 downto 24) & s_acc_transluc_gain_int(39 downto 24) & s_acc2_transluc_gain_int(39 downto 24);
										s_gain_b_in <= s_accb_reflect_gain_int(39 downto 24) & s_acc2b_reflect_gain_int(39 downto 24) & s_accb_transluc_gain_int(39 downto 24) & s_acc2b_transluc_gain_int(39 downto 24);
										st_max <= "10100";
			-------------------------- 20 -------------------------
				when "10100" =>	s_we_gain_int <= '1';
										st_max <= "10101";
			-------------------------- 21 -------------------------
				when "10101" =>	st_max <= "10110";
			-------------------------- 22 -------------------------
				when "10110" =>	s_we_gain_int <= '0';
										if (s_mean_rd_addr_a = "11111") then
											st_max <= "10111";
										else
											s_mean_rd_addr_a <= s_mean_rd_addr_a + 1;
											s_mean_rd_addr_b <= s_mean_rd_addr_b + 1;
											st_max <= "01100";
										end if;
			-------------------------- 23 -------------------------
				when "10111" =>	s_gen_tab_clr <= '1';
										s_table_ready <= '1';

										st_max <= "11000";
			-------------------------- 20 -------------------------
				when "11000" =>	if (GEN_TAB_i = '0') then
											st_max <= "00000";
											s_gen_tab_clr <= '0';
										else
											st_max <= "11000";
										end if; 												
			------------------------ others -----------------------
				when others => st_max <= "00000";
			
		  end case;
	  end if;
	end process;

end Behavioral;

