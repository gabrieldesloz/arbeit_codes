-------------------------------------------------------------------------------
--
-- Title       : Fub1
-- Design      : clocking_mono
-- Author      : Unknown
-- Company     : Unknown
--
-------------------------------------------------------------------------------
--
-- File        : m:\vhdl\Tests\clocking_mono\compile\Fub1.vhd
-- Generated   : Tue Oct  7 16:13:18 2014
-- From        : m:\vhdl\Tests\clocking_mono\src\Fub1.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;


entity Fub1 is
  port(
       extevent_flag : in std_logic;
       extfloor : in std_logic;
       extpart : in std_logic_vector(1 downto 0);
       exttype : in std_logic;
       s_bgnd_floor : in std_logic;
       s_illum_floor : in std_logic;
       ad1 : out std_logic;
       ad2 : out std_logic;
       ad3 : out std_logic;
       ad4 : out std_logic;
       dt1 : out std_logic;
       dt2 : out STD_LOGIC;
       dt3 : out STD_LOGIC;
       dt4 : out STD_LOGIC
  );
end Fub1;

architecture Fub1 of Fub1 is

begin

---- Processes ----

Process_1 :
process (extevent_flag, exttype, extpart, s_bgnd_floor, s_illum_floor, extfloor)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations
begin
-- statements
end process Process_1;

end Fub1;
