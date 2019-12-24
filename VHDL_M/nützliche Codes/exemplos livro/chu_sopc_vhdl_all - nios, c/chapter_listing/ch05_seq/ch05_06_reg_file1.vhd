-- Listing 5.6
library ieee;
use ieee.std_logic_1164.all;
entity reg_file_4x8 is
   port(
      clk: in std_logic;
      wr_en: in std_logic;
      w_addr, r_addr: in std_logic_vector(1 downto 0);
      w_data: in std_logic_vector(7 downto 0);
      r_data: out std_logic_vector(7 downto 0)
   );
end reg_file_4x8;

architecture explicit_arch of reg_file_4x8 is
   constant ADDR_WIDTH: natural:=2; -- bits in address
   constant DATA_WIDTH: natural:=8; -- bits in data
   type mem_2d_type is array (0 to 2**ADDR_WIDTH-1) of
        std_logic_vector(DATA_WIDTH-1 downto 0);
   signal array_reg: mem_2d_type;
   signal en: std_logic_vector(2**ADDR_WIDTH-1 downto 0);
begin
   -- 4 registers 
   process(clk)
   begin
      if (clk'event and clk='1') then
         if en(3)='1' then
            array_reg(3) <= w_data;
         end if;
         if en(2)='1' then
            array_reg(2) <= w_data;
         end if;
         if en(1)='1' then
            array_reg(1) <= w_data;
         end if;
         if en(0)='1' then
            array_reg(0) <= w_data;
         end if;        
      end if;
   end process;
   -- decoding logic for write address
   process(wr_en,w_addr)
   begin
      if (wr_en='0') then
         en <= (others=>'0');
      else
         case w_addr  is
            when "00" =>   en <= "0001";
            when "01" =>   en <= "0010";
            when "10" =>   en <= "0100";
            when others => en <= "1000";
         end case;
      end if;
   end process;
   -- read multiplexing circuit
   with r_addr select
      r_data <=  array_reg(0) when "00",
                 array_reg(1) when "01",
                 array_reg(2) when "10",
                 array_reg(3) when others;

end explicit_arch;