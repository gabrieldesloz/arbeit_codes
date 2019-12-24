-- Listing 5.8
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity async_sram is
   generic(
      ADDR_WIDTH: integer:=2;
      DATA_WIDTH:integer:=8
   );
   port(
      wr_en: in std_logic;
      w_addr: in std_logic_vector (ADDR_WIDTH-1 downto 0);
      r_addr: in std_logic_vector (ADDR_WIDTH-1 downto 0);
      d: in std_logic_vector (DATA_WIDTH-1 downto 0);
      q: out std_logic_vector (DATA_WIDTH-1 downto 0)
   );
end async_sram;

architecture not_use_arch of async_sram is
   type mem_2d_type is array (2**ADDR_WIDTH-1 downto 0) of
        std_logic_vector(DATA_WIDTH-1 downto 0);
   signal array_reg: mem_2d_type;
begin
   process(wr_en, w_addr, d)
   begin
      if wr_en='1' then
         array_reg(to_integer(unsigned(w_addr))) <= d;
      end if;
   end process;
   q <= array_reg(to_integer(unsigned(r_addr)));
end not_use_arch;


