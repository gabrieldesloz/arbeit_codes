----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:42:42 03/23/2011 
-- Design Name: 
-- Module Name:    ALL_IN_BUFF - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALL_IN_BUFF  is
    Port ( LENGTH_i : in  STD_LOGIC_VECTOR (191 downto 0);
           CH_NUM_i : in  STD_LOGIC_VECTOR (5 downto 0);
            C56MHz_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
           LENGTH_BUFF_o : out  STD_LOGIC_VECTOR (191 downto 0));
end ALL_IN_BUFF ;

architecture Behavioral of ALL_IN_BUFF  is

component IN_BUFF  is
    Port ( LENGTH_i : in  STD_LOGIC_VECTOR (2 downto 0);
           C56MHz_i : in  STD_LOGIC;
			  RST_i : in STD_LOGIC;
           CLEAR_FF_i : in  STD_LOGIC;
           LENGTH_o : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

signal s_EN_CHX : STD_LOGIC_VECTOR (63 downto 0);

begin

i_CH_SEL : process (CH_NUM_i,c56MHz_i)
begin
    if falling_edge(c56MHz_i) then
         s_EN_CHX <= "0000000000000000000000000000000000000000000000000000000000000000";
         s_EN_CHX(CONV_INTEGER(CH_NUM_i)) <= '1';
    end if;

end process;

-----------------------------------------------------
-------------	    INPUT BUFFER 1	  ---------------
-----------------------------------------------------
i_BUFF_CH_1 : IN_BUFF  port map (
	  LENGTH_i => LENGTH_i(2 downto 0),
	  CLEAR_FF_i => s_EN_CHX(01),
	  C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(2 downto 0)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 2	  ---------------
-----------------------------------------------------
i_BUFF_CH_2 : IN_BUFF  port map (
	  --IAM_CH_i => "000001",
	  LENGTH_i => LENGTH_i(5 downto 3),
	  CLEAR_FF_i => s_EN_CHX(02),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(5 downto 3)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 3	  ---------------
-----------------------------------------------------
i_BUFF_CH_3 : IN_BUFF  port map (
	  --IAM_CH_i => "000010",
	  LENGTH_i => LENGTH_i(8 downto 6),
	  CLEAR_FF_i => s_EN_CHX(03),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(8 downto 6)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 4	  ---------------
-----------------------------------------------------
i_BUFF_CH_4 : IN_BUFF  port map (
	  --IAM_CH_i => "000011",
	  LENGTH_i => LENGTH_i(11 downto 9),
	  CLEAR_FF_i => s_EN_CHX(04),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(11 downto 9)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 5	  ---------------
-----------------------------------------------------
i_BUFF_CH_5 : IN_BUFF  port map (
	  --IAM_CH_i => "000100",
	  LENGTH_i => LENGTH_i(14 downto 12),
	  CLEAR_FF_i => s_EN_CHX(05),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(14 downto 12)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 6	  ---------------
-----------------------------------------------------
i_BUFF_CH_6 : IN_BUFF  port map (
	  --IAM_CH_i => "000101",
	  LENGTH_i => LENGTH_i(17 downto 15),
	  CLEAR_FF_i => s_EN_CHX(06),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(17 downto 15)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 7	  ---------------
-----------------------------------------------------
i_BUFF_CH_7 : IN_BUFF  port map (
	  --IAM_CH_i => "000110",
	  LENGTH_i => LENGTH_i(20 downto 18),
	  CLEAR_FF_i => s_EN_CHX(07),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(20 downto 18)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 8	  ---------------
-----------------------------------------------------
i_BUFF_CH_8 : IN_BUFF  port map (
	  --IAM_CH_i => "000111",
	  LENGTH_i => LENGTH_i(23 downto 21),
	  CLEAR_FF_i => s_EN_CHX(08),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(23 downto 21)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 9	  ---------------
-----------------------------------------------------
i_BUFF_CH_9 : IN_BUFF  port map (
	  --IAM_CH_i => "001000",
	  LENGTH_i => LENGTH_i(26 downto 24),
	  CLEAR_FF_i => s_EN_CHX(09),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(26 downto 24)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 10	  ---------------
-----------------------------------------------------
i_BUFF_CH_10 : IN_BUFF  port map (
	  --IAM_CH_i => "001001",
	  LENGTH_i => LENGTH_i(29 downto 27),
	  CLEAR_FF_i => s_EN_CHX(10),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(29 downto 27)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 11	  ---------------
-----------------------------------------------------
i_BUFF_CH_11 : IN_BUFF  port map (
	  --IAM_CH_i => "001010",
	  LENGTH_i => LENGTH_i(32 downto 30),
	  CLEAR_FF_i => s_EN_CHX(11),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(32 downto 30)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 12	  ---------------
-----------------------------------------------------
i_BUFF_CH_12 : IN_BUFF  port map (
	  --IAM_CH_i => "001011",
	  LENGTH_i => LENGTH_i(35 downto 33),
	  CLEAR_FF_i => s_EN_CHX(12),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(35 downto 33)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 13	  ---------------
-----------------------------------------------------
i_BUFF_CH_13 : IN_BUFF  port map (
	  --IAM_CH_i => "001100",
	  LENGTH_i => LENGTH_i(38 downto 36),
	  CLEAR_FF_i => s_EN_CHX(13),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(38 downto 36)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 14	  ---------------
-----------------------------------------------------
i_BUFF_CH_14 : IN_BUFF  port map (
	  --IAM_CH_i => "001101",
	  LENGTH_i => LENGTH_i(41 downto 39),
	  CLEAR_FF_i => s_EN_CHX(14),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(41 downto 39)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 15	  ---------------
-----------------------------------------------------
i_BUFF_CH_15 : IN_BUFF  port map (
	  --IAM_CH_i => "001110",
	  LENGTH_i => LENGTH_i(44 downto 42),
	  CLEAR_FF_i => s_EN_CHX(15),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(44 downto 42)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 16	  ---------------
-----------------------------------------------------
i_BUFF_CH_16 : IN_BUFF  port map (
	  --IAM_CH_i => "001111",
	  LENGTH_i => LENGTH_i(47 downto 45),
	  CLEAR_FF_i => s_EN_CHX(16),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(47 downto 45)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 17	  ---------------
-----------------------------------------------------
i_BUFF_CH_17 : IN_BUFF  port map (
	  --IAM_CH_i => "010000",
	  LENGTH_i => LENGTH_i(50 downto 48),
	  CLEAR_FF_i => s_EN_CHX(17),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(50 downto 48)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 18	  ---------------
-----------------------------------------------------
i_BUFF_CH_18 : IN_BUFF  port map (
	  --IAM_CH_i => "010001",
	  LENGTH_i => LENGTH_i(53 downto 51),
	  CLEAR_FF_i => s_EN_CHX(18),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(53 downto 51)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 19	  ---------------
-----------------------------------------------------
i_BUFF_CH_19 : IN_BUFF  port map (
	  --IAM_CH_i => "010010",
	  LENGTH_i => LENGTH_i(56 downto 54),
	  CLEAR_FF_i => s_EN_CHX(19),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(56 downto 54)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 20	  ---------------
-----------------------------------------------------
i_BUFF_CH_20 : IN_BUFF  port map (
	  --IAM_CH_i => "010011",
	  LENGTH_i => LENGTH_i(59 downto 57),
	  CLEAR_FF_i => s_EN_CHX(20),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(59 downto 57)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 21	  ---------------
-----------------------------------------------------
i_BUFF_CH_21 : IN_BUFF  port map (
	  --IAM_CH_i => "010100",
	  LENGTH_i => LENGTH_i(62 downto 60),
	  CLEAR_FF_i => s_EN_CHX(21),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(62 downto 60)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 22	  ---------------
-----------------------------------------------------
i_BUFF_CH_22 : IN_BUFF  port map (
	  --IAM_CH_i => "010101",
	  LENGTH_i => LENGTH_i(65 downto 63),
	  CLEAR_FF_i => s_EN_CHX(22),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(65 downto 63)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 23	  ---------------
-----------------------------------------------------
i_BUFF_CH_23 : IN_BUFF  port map (
	  --IAM_CH_i => "010110",
	  LENGTH_i => LENGTH_i(68 downto 66),
	  CLEAR_FF_i => s_EN_CHX(23),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(68 downto 66)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 24	  ---------------
-----------------------------------------------------
i_BUFF_CH_24 : IN_BUFF  port map (
	  --IAM_CH_i => "010111",
	  LENGTH_i => LENGTH_i(71 downto 69),
	  CLEAR_FF_i => s_EN_CHX(24),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(71 downto 69)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 25	  ---------------
-----------------------------------------------------
i_BUFF_CH_25 : IN_BUFF  port map (
	  --IAM_CH_i => "011000",
	  LENGTH_i => LENGTH_i(74 downto 72),
	  CLEAR_FF_i => s_EN_CHX(25),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(74 downto 72)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 26	  ---------------
-----------------------------------------------------
i_BUFF_CH_26 : IN_BUFF  port map (
	  --IAM_CH_i => "011001",
	  LENGTH_i => LENGTH_i(77 downto 75),
	  CLEAR_FF_i => s_EN_CHX(26),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(77 downto 75)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 27	  ---------------
-----------------------------------------------------
i_BUFF_CH_27 : IN_BUFF  port map (
	  --IAM_CH_i => "011010",
	  LENGTH_i => LENGTH_i(80 downto 78),
	  CLEAR_FF_i => s_EN_CHX(27),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(80 downto 78)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 28	  ---------------
-----------------------------------------------------
i_BUFF_CH_28 : IN_BUFF  port map (
	  --IAM_CH_i => "011011",
	  LENGTH_i => LENGTH_i(83 downto 81),
	  CLEAR_FF_i => s_EN_CHX(28),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(83 downto 81)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 29	  ---------------
-----------------------------------------------------
i_BUFF_CH_29 : IN_BUFF  port map (
	  --IAM_CH_i => "011100",
	  LENGTH_i => LENGTH_i(86 downto 84),
	  CLEAR_FF_i => s_EN_CHX(29),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(86 downto 84)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 30	  ---------------
-----------------------------------------------------
i_BUFF_CH_30 : IN_BUFF  port map (
	  --IAM_CH_i => "011101",
	  LENGTH_i => LENGTH_i(89 downto 87),
	  CLEAR_FF_i => s_EN_CHX(30),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(89 downto 87)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 31	  ---------------
-----------------------------------------------------
i_BUFF_CH_31 : IN_BUFF  port map (
	  --IAM_CH_i => "011110",
	  LENGTH_i => LENGTH_i(92 downto 90),
	  CLEAR_FF_i => s_EN_CHX(31),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(92 downto 90)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 32	  ---------------
-----------------------------------------------------
i_BUFF_CH_32 : IN_BUFF  port map (
	  --IAM_CH_i => "011111",
	  LENGTH_i => LENGTH_i(95 downto 93),
	  CLEAR_FF_i => s_EN_CHX(32),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(95 downto 93)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 33	  ---------------
-----------------------------------------------------
i_BUFF_CH_33 : IN_BUFF  port map (
	  --IAM_CH_i => "100000",
	  LENGTH_i => LENGTH_i(98 downto 96),
	  CLEAR_FF_i => s_EN_CHX(33),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(98 downto 96)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 34	  ---------------
-----------------------------------------------------
i_BUFF_CH_34 : IN_BUFF  port map (
	  --IAM_CH_i => "100001",
	  LENGTH_i => LENGTH_i(101 downto 99),
	  CLEAR_FF_i => s_EN_CHX(34),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(101 downto 99)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 35	  ---------------
-----------------------------------------------------
i_BUFF_CH_35 : IN_BUFF  port map (
	  --IAM_CH_i => "100010",
	  LENGTH_i => LENGTH_i(104 downto 102),
	  CLEAR_FF_i => s_EN_CHX(35),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(104 downto 102)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 36	  ---------------
-----------------------------------------------------
i_BUFF_CH_36 : IN_BUFF  port map (
	  --IAM_CH_i => "100011",
	  LENGTH_i => LENGTH_i(107 downto 105),
	  CLEAR_FF_i => s_EN_CHX(36),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(107 downto 105)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 37	  ---------------
-----------------------------------------------------
i_BUFF_CH_37 : IN_BUFF  port map (
	  --IAM_CH_i => "100100",
	  LENGTH_i => LENGTH_i(110 downto 108),
	  CLEAR_FF_i => s_EN_CHX(37),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(110 downto 108)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 38	  ---------------
-----------------------------------------------------
i_BUFF_CH_38 : IN_BUFF  port map (
	  --IAM_CH_i => "100101",
	  LENGTH_i => LENGTH_i(113 downto 111),
	  CLEAR_FF_i => s_EN_CHX(38),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(113 downto 111)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 39	  ---------------
-----------------------------------------------------
i_BUFF_CH_39 : IN_BUFF  port map (
	  --IAM_CH_i => "100110",
	  LENGTH_i => LENGTH_i(116 downto 114),
	  CLEAR_FF_i => s_EN_CHX(39),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(116 downto 114)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 40	  ---------------
-----------------------------------------------------
i_BUFF_CH_40 : IN_BUFF  port map (
	  --IAM_CH_i => "100111",
	  LENGTH_i => LENGTH_i(119 downto 117),
	  CLEAR_FF_i => s_EN_CHX(40),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(119 downto 117)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 41	  ---------------
-----------------------------------------------------
i_BUFF_CH_41 : IN_BUFF  port map (
	  --IAM_CH_i => "101000",
	  LENGTH_i => LENGTH_i(122 downto 120),
	  CLEAR_FF_i => s_EN_CHX(41),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(122 downto 120)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 42	  ---------------
-----------------------------------------------------
i_BUFF_CH_42 : IN_BUFF  port map (
	  --IAM_CH_i => "101001",
	  LENGTH_i => LENGTH_i(125 downto 123),
	  CLEAR_FF_i => s_EN_CHX(42),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(125 downto 123)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 43	  ---------------
-----------------------------------------------------
i_BUFF_CH_43 : IN_BUFF  port map (
	  --IAM_CH_i => "101010",
	  LENGTH_i => LENGTH_i(128 downto 126),
	  CLEAR_FF_i => s_EN_CHX(43),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(128 downto 126)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 44	  ---------------
-----------------------------------------------------
i_BUFF_CH_44 : IN_BUFF  port map (
	  --IAM_CH_i => "101011",
	  LENGTH_i => LENGTH_i(131 downto 129),
	  CLEAR_FF_i => s_EN_CHX(44),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(131 downto 129)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 45	  ---------------
-----------------------------------------------------
i_BUFF_CH_45 : IN_BUFF  port map (
	  --IAM_CH_i => "101100",
	  LENGTH_i => LENGTH_i(134 downto 132),
	  CLEAR_FF_i => s_EN_CHX(45),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(134 downto 132)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 46	  ---------------
-----------------------------------------------------
i_BUFF_CH_46 : IN_BUFF  port map (
	  --IAM_CH_i => "101101",
	  LENGTH_i => LENGTH_i(137 downto 135),
	  CLEAR_FF_i => s_EN_CHX(46),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(137 downto 135)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 47	  ---------------
-----------------------------------------------------
i_BUFF_CH_47 : IN_BUFF  port map (
	  --IAM_CH_i => "101110",
	  LENGTH_i => LENGTH_i(140 downto 138),
	  CLEAR_FF_i => s_EN_CHX(47),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(140 downto 138)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 48	  ---------------
-----------------------------------------------------
i_BUFF_CH_48 : IN_BUFF  port map (
	  --IAM_CH_i => "101111",
	  LENGTH_i => LENGTH_i(143 downto 141),
	  CLEAR_FF_i => s_EN_CHX(48),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(143 downto 141)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 49	  ---------------
-----------------------------------------------------
i_BUFF_CH_49 : IN_BUFF  port map (
	  --IAM_CH_i => "110000",
	  LENGTH_i => LENGTH_i(146 downto 144),
	  CLEAR_FF_i => s_EN_CHX(49),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(146 downto 144)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 50	  ---------------
-----------------------------------------------------
i_BUFF_CH_50 : IN_BUFF  port map (
	  --IAM_CH_i => "110001",
	  LENGTH_i => LENGTH_i(149 downto 147),
	  CLEAR_FF_i => s_EN_CHX(50),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(149 downto 147)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 51	  ---------------
-----------------------------------------------------
i_BUFF_CH_51 : IN_BUFF  port map (
	  --IAM_CH_i => "110010",
	  LENGTH_i => LENGTH_i(152 downto 150),
	  CLEAR_FF_i => s_EN_CHX(51),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(152 downto 150)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 52	  ---------------
-----------------------------------------------------
i_BUFF_CH_52 : IN_BUFF  port map (
	  --IAM_CH_i => "110011",
	  LENGTH_i => LENGTH_i(155 downto 153),
	  CLEAR_FF_i => s_EN_CHX(52),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(155 downto 153)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 53	  ---------------
-----------------------------------------------------
i_BUFF_CH_53 : IN_BUFF  port map (
	  --IAM_CH_i => "110100",
	  LENGTH_i => LENGTH_i(158 downto 156),
	  CLEAR_FF_i => s_EN_CHX(53),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(158 downto 156)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 54	  ---------------
-----------------------------------------------------
i_BUFF_CH_54 : IN_BUFF  port map (
	  --IAM_CH_i => "110101",
	  LENGTH_i => LENGTH_i(161 downto 159),
	  CLEAR_FF_i => s_EN_CHX(54),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(161 downto 159)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 55	  ---------------
-----------------------------------------------------
i_BUFF_CH_55 : IN_BUFF  port map (
	  --IAM_CH_i => "110110",
	  LENGTH_i => LENGTH_i(164 downto 162),
	  CLEAR_FF_i => s_EN_CHX(55),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(164 downto 162)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 56	  ---------------
-----------------------------------------------------
i_BUFF_CH_56 : IN_BUFF  port map (
	  --IAM_CH_i => "110111",
	  LENGTH_i => LENGTH_i(167 downto 165),
	  CLEAR_FF_i => s_EN_CHX(56),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(167 downto 165)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 57	  ---------------
-----------------------------------------------------
i_BUFF_CH_57 : IN_BUFF  port map (
	  --IAM_CH_i => "111000",
	  LENGTH_i => LENGTH_i(170 downto 168),
	  CLEAR_FF_i => s_EN_CHX(57),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(170 downto 168)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 58	  ---------------
-----------------------------------------------------
i_BUFF_CH_58 : IN_BUFF  port map (
	  --IAM_CH_i => "111001",
	  LENGTH_i => LENGTH_i(173 downto 171),
	  CLEAR_FF_i => s_EN_CHX(58),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(173 downto 171)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 59	  ---------------
-----------------------------------------------------
i_BUFF_CH_59 : IN_BUFF  port map (
	  --IAM_CH_i => "111010",
	  LENGTH_i => LENGTH_i(176 downto 174),
	  CLEAR_FF_i => s_EN_CHX(59),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(176 downto 174)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 60	  ---------------
-----------------------------------------------------
i_BUFF_CH_60 : IN_BUFF  port map (
	  --IAM_CH_i => "111011",
	  LENGTH_i => LENGTH_i(179 downto 177),
	  CLEAR_FF_i => s_EN_CHX(60),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(179 downto 177)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 61	  ---------------
-----------------------------------------------------
i_BUFF_CH_61 : IN_BUFF  port map (
	  --IAM_CH_i => "111100",
	  LENGTH_i => LENGTH_i(182 downto 180),
	  CLEAR_FF_i => s_EN_CHX(61),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(182 downto 180)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 62	  ---------------
-----------------------------------------------------
i_BUFF_CH_62 : IN_BUFF  port map (
	  --IAM_CH_i => "111101",
	  LENGTH_i => LENGTH_i(185 downto 183),
	  CLEAR_FF_i => s_EN_CHX(62),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(185 downto 183)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 63	  ---------------
-----------------------------------------------------
i_BUFF_CH_63 : IN_BUFF  port map (
	  --IAM_CH_i => "111110",
	  LENGTH_i => LENGTH_i(188 downto 186),
	  CLEAR_FF_i => s_EN_CHX(63),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(188 downto 186)
);
-----------------------------------------------------
-------------	    INPUT BUFFER 64	  ---------------
-----------------------------------------------------
i_BUFF_CH_64 : IN_BUFF  port map (
	  --IAM_CH_i => "111111",
	  LENGTH_i => LENGTH_i(191 downto 189),
	  CLEAR_FF_i => s_EN_CHX(00),
	  --CH_NUM_i => --CH_NUM_i,
	   C56MHz_i =>  C56MHz_i,
	  RST_i    => RST_i,
	  LENGTH_o => LENGTH_BUFF_o(191 downto 189)
);

end Behavioral;

