----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:53:37 10/31/2013 
-- Design Name: 
-- Module Name:    DCM_CLOCK - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCM_CLOCK is
  port (		CLK_37MHZ_i : in  std_logic;
				CLK_37MHZ_buf_o: out std_logic;
                RST_i       : in  std_logic;
                CLK_60MHz_o : out std_logic;
                CLK_56MHz_o : out std_logic;
                CLK_30MHz_o  : out std_logic;
                EN_10MHz_o  : out std_logic;
                EN_1MHz_o   : out std_logic;
                EN_100kHz_o : out std_logic;
                EN_10kHz_o  : out std_logic;
				DEBUG_o     : out std_logic_vector(3 downto 0)

                );
end DCM_CLOCK;


architecture Behavioral of DCM_CLOCK is
  signal s_30MHz_en, s_10MHz_en, s_1MHz_en, s_100kHz_en,   s_10kHz_en   : std_logic    := '0';
  signal s_CLK_60MHz_o                                                : std_logic;
  signal s_clk_fb, s_clk_fb_buf                                         : std_logic;
  signal clk_60MHz                                                      : std_logic;
  signal s_1MHz_en_cnt, s_10kHz_en_cnt, s_100kHz_en_cnt, s_10MHz_en_cnt : integer range 0 to 100_000 := 0;


begin


  dcms : entity work.cascaded_dcms
    port map
      (				U1_CLKIN_IN        => CLK_37MHZ_i,
                  U1_RST_IN          => RST_i,
                  U1_CLKFX_OUT       => CLK_56MHz_o,    -- 56.25 MHz
                  U1_CLKIN_IBUFG_OUT => CLK_37MHZ_buf_o,
                  U1_CLK0_OUT        => open,
                  U1_STATUS_OUT      => open,
                  U2_CLKFX_OUT       => s_CLK_60MHz_o,  -- 60 MHz
                  U2_CLK0_OUT        => open,
                  U2_LOCKED_OUT      => open,
                  U2_STATUS_OUT      => open
                  );


    CLK_30MHz_o <= s_30MHz_en;
    EN_10MHz_o  <= s_10MHz_en;
    EN_1MHz_o   <= s_1MHz_en;
    EN_100kHz_o <= s_100kHz_en;
	 EN_10kHz_o  <=  s_10kHz_en; 
    CLK_60MHz_o <= s_CLK_60MHz_o;

    process (s_CLK_60MHz_o, RST_i)
    begin
      
      if RST_i = '1' then
        s_30MHz_en      <= '0';
        s_10MHz_en      <= '0';
        s_100kHz_en     <= '0';
		s_10kHz_en      <= '0'; 
        s_10MHz_en_cnt  <= 0;
        s_1MHz_en_cnt   <= 0;
        s_100kHz_en_cnt <= 0;
		s_10kHz_en_cnt <= 0;
        
      elsif rising_edge(s_CLK_60MHz_o) then
        
        s_30MHz_en <= not(s_30MHz_en);  -- Assures 30MHz enable signal is 0 every cycle

        ---------------------------------------------------

        s_10MHz_en <= '0';  -- Assures 10MHz enable signal is 0 every cycle

        if (s_10MHz_en_cnt = 5) then    -- If counter has reached 9
          s_10MHz_en_cnt <= 0;          -- Set counter to 0
          s_10MHz_en     <= '1';        -- Set enable signal to 1
        else
          s_10MHz_en_cnt <= s_10MHz_en_cnt + 1;  -- Increase 10MHz enable counter
        end if;

        ---------------------------------------------------

        s_1MHz_en <= '0';

        if (s_1MHz_en_cnt = 59) then
          s_1MHz_en_cnt <= 0;
          s_1MHz_en     <= '1';
        else
          s_1MHz_en_cnt <= s_1MHz_en_cnt + 1;
        end if;

        s_100kHz_en <= '0';

        if (s_100kHz_en_cnt = 599) then
          s_100kHz_en_cnt <= 0;
          s_100kHz_en     <= '1';
        else
          s_100kHz_en_cnt <= s_100kHz_en_cnt + 1;
        end if;

		 
		s_10kHz_en <= '0';
		 
        if (s_10kHz_en_cnt = 5999) then
          s_10kHz_en_cnt <= 0;          -- Set counter to 0
          s_10kHz_en     <= '1';        -- Set enable signal to 1
        else
          s_10kHz_en_cnt <= s_10kHz_en_cnt + 1;
        end if;

        
        
      end if;
    end process;

  end Behavioral;
