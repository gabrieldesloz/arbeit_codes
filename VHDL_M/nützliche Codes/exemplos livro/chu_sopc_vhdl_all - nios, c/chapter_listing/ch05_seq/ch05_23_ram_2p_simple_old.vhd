-- Listing 5.23
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity altera_dual_port_ram_simple is
   generic(
      ADDR_WIDTH: integer:=10;
      DATA_WIDTH:integer:=8
   );
   port(
      clk: in std_logic;
      we: in std_logic;
      w_addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
      r_addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
      d: in std_logic_vector(DATA_WIDTH-1 downto 0);
      q: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end altera_dual_port_ram_simple;

--*********************************************************
--  - if w_addr and r_addr address are the same, 
--    q gets the previously stored data (old data) 
--*********************************************************
architecture old_data_arch of altera_dual_port_ram_simple is
   type mem_2d_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal ram: mem_2d_type;
   signal data_reg: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
   process (clk)
   begin
      if (clk'event and clk = '1') then
         if (we='1') then
            ram(to_integer(unsigned(w_addr))) <= d;
         end if;
         data_reg <= ram(to_integer(unsigned(r_addr)));
      end if;
   end process;
   q <= data_reg;
end old_data_arch;




