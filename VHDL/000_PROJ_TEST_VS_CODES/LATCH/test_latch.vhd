library ieee;
use ieee.std_logic_1164.all;

entity reverser is
  generic (nbits : positive := 4);
  port (vi : in std_logic_vector(nbits-1 downto 0);
        en : std_logic;
        vo : out std_logic_vector(nbits-1 downto 0);
		  clk : in std_logic
		  );
		  
end entity reverser;

architecture RTL of reverser is
begin

  process(clk, vi, en)
  begin
  
  if rising_edge(clk) then  
    if en = '1' then
      for i in vi'range loop
        vo(i) <= vi(nbits-1 - i);
      end loop;
		else
		 for i in vi'range loop
        vo(i) <= '0';
      end loop;
    end if;
	end if; 
	 
  end process;

end architecture RTL;






--library ieee;
--use ieee.std_logic_1164.all;
--
--entity reverser is
--  generic (nbits : positive := 4);
--  port (vi : in std_logic_vector(nbits-1 downto 0);
--        en : std_logic;
--        vo : out std_logic_vector(nbits-1 downto 0));
--end entity reverser;
--
--architecture RTL of reverser is
--begin
--
--  process(vi, en)
--  begin
--    if en = '1' then
--      for i in vi'range loop
--        vo(i) <= vi(nbits-1 - i);
--      end loop;
--    end if;
--  end process;
--
--end architecture RTL;


