--=============================
-- Listing 9.15 register file
--=============================
library ieee;
use ieee.std_logic_1164.all;
entity reg_file is
   port(
      clk, reset: in std_logic;
      wr_en: in std_logic;
      w_addr: in std_logic_vector(1 downto 0);
      w_data: in std_logic_vector(15 downto 0);
      r_addr0, r_addr1: in std_logic_vector(1 downto 0);
      r_data0, r_data1: out std_logic_vector(15 downto 0)
   );
end reg_file;

architecture no_loop_arch of reg_file is
   constant W: natural:=2; -- number of bits in address
   constant B: natural:=16; -- number of bits in data
   type reg_file_type is array (2**W-1 downto 0) of
        std_logic_vector(B-1 downto 0);
   signal array_reg: reg_file_type;
   signal array_next: reg_file_type;
   signal en: std_logic_vector(2**W-1 downto 0);
begin
   -- register
   process(clk,reset)
   begin
      if (reset='1') then
         array_reg(3) <= (others=>'0');
         array_reg(2) <= (others=>'0');
         array_reg(1) <= (others=>'0');
         array_reg(0) <= (others=>'0');
      elsif (clk'event and clk='1') then
         array_reg(3) <=  array_next(3);
         array_reg(2) <=  array_next(2);
         array_reg(1) <=  array_next(1);
         array_reg(0) <=  array_next(0);
      end if;
   end process;
   -- enable logic for register
   process(array_reg,en,w_data)
   begin
      array_next(3) <= array_reg(3);
      array_next(2) <= array_reg(2);
      array_next(1) <= array_reg(1);
      array_next(0) <= array_reg(0);
      if en(3)='1' then
         array_next(3) <= w_data;
      end if;
      if en(2)='1' then
         array_next(2) <= w_data;
      end if;
      if en(1)='1' then
         array_next(1) <= w_data;
      end if;
      if en(0)='1' then
         array_next(0) <= w_data;
      end if;
   end process;
   -- decoding for write address
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
   -- read multiplexing
   with r_addr0 select
      r_data0 <=  array_reg(0) when "00",
                  array_reg(1) when "01",
                  array_reg(2) when "10",
                  array_reg(3) when others;
   with r_addr1 select
      r_data1 <=  array_reg(0) when "00",
                  array_reg(1) when "01",
                  array_reg(2) when "10",
                  array_reg(3) when others;
end no_loop_arch;