--=============================
-- Listing 9.18 cam key file
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity key_file is
   port(
      clk, reset: in std_logic;
      wr_en: in std_logic;
      key_in: in std_logic_vector(15 downto 0);
      hit: out std_logic;
      addr_out: out std_logic_vector(1 downto 0)
   );
end key_file;

architecture no_loop_arch of key_file is
   constant WORD: natural:=2;
   constant BIT: natural:=16;
   type reg_file_type is array (2**WORD-1 downto 0) of
        std_logic_vector(BIT-1 downto 0);
   signal array_reg: reg_file_type;
   signal array_next: reg_file_type;
   signal en: std_logic_vector(2**WORD-1 downto 0);
   signal match: std_logic_vector(2**WORD-1 downto 0);
   signal rep_reg, rep_next: unsigned(WORD-1 downto 0);
   signal addr_match: std_logic_vector(WORD-1 downto 0);
   signal wr_key, hit_flag: std_logic;
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
   process(array_reg,en,key_in)
   begin
      array_next(3) <= array_reg(3);
      array_next(2) <= array_reg(2);
      array_next(1) <= array_reg(1);
      array_next(0) <= array_reg(0);
      if en(3)='1' then
         array_next(3) <= key_in;
      end if;
      if en(2)='1' then
         array_next(2) <= key_in;
      end if;
      if en(1)='1' then
         array_next(1) <= key_in;
      end if;
      if en(0)='1' then
         array_next(0) <= key_in;
      end if;
   end process;

   -- decoding for write address
   wr_key <= '1' when (wr_en='1' and hit_flag='0') else
             '0';
   process(wr_key,rep_reg)
   begin
      if (wr_key='0') then
         en <= (others=>'0');
      else
         case rep_reg  is
            when "00" =>   en <= "0001";
            when "01" =>   en <= "0010";
            when "10" =>   en <= "0100";
            when others => en <= "1000";
         end case;
      end if;
   end process;

   -- replacement pointer
   process(clk,reset)
   begin
      if (reset='1') then
         rep_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         rep_reg <= rep_next;
      end if;
   end process;
   rep_next <= rep_reg + 1 when wr_key='1' else
               rep_reg;

   -- key comparison
   process(array_reg,key_in)
   begin
      match <= (others=>'0');
      if array_reg(3)=key_in then
         match(3) <= '1';
      end if;
      if array_reg(2)=key_in then
         match(2) <= '1';
      end if;
      if array_reg(1)=key_in then
         match(1) <= '1';
      end if;
      if array_reg(0)=key_in then
         match(0) <= '1';
      end if;
   end process;
   -- encoding
   with match select
      addr_match <=
         "00" when "0001",
         "01" when "0010",
         "10" when "0100",
         "11" when others;
   -- hit
   hit_flag <= '1' when match /="0000" else '0';
   --output
   hit <= hit_flag;
   addr_out <= addr_match when (hit_flag='1') else
               std_logic_vector(rep_reg);
end no_loop_arch;
