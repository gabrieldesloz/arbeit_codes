-- Listing 5.24
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity altera_dual_port_ram_true is
   generic(
      ADDR_WIDTH: integer:=10;
      DATA_WIDTH:integer:=8
   );
   port(
      clk: in std_logic;
      we_a, we_b: in std_logic;
      addr_a: in std_logic_vector(ADDR_WIDTH-1 downto 0);
      addr_b: in std_logic_vector(ADDR_WIDTH-1 downto 0);
      d_a: in std_logic_vector(DATA_WIDTH-1 downto 0);
      d_b: in std_logic_vector(DATA_WIDTH-1 downto 0);
      q_a: out std_logic_vector(DATA_WIDTH-1 downto 0);
      q_b: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end altera_dual_port_ram_true;

architecture beh_arch of altera_dual_port_ram_true is
   type ram_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal ram: ram_type;
begin
   -- port a
   process(clk)
   begin
     if (clk'event and clk = '1') then
        if (we_a = '1') then
           ram(to_integer(unsigned(addr_a))) <= d_a;
           q_a <= d_a;
        else
           q_a <= ram(to_integer(unsigned(addr_a)));
        end if;
     end if;
   end process;
   -- port b
   process(clk)
   begin
     if (clk'event and clk = '1') then
        if (we_b = '1') then
           ram(to_integer(unsigned(addr_b))) <= d_b;
           q_b <= d_b;
        else
           q_b <= ram(to_integer(unsigned(addr_b)));
        end if;
     end if;
   end process;
end beh_arch;
