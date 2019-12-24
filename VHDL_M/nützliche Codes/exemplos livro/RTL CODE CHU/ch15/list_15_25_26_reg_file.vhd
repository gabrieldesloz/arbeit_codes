--=============================
-- Listing 15.25 register file
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;
entity reg_file_para is
   generic(
      W: natural;
      B: natural
   );
   port(
      clk, reset: in std_logic;
      wr_en: in std_logic;
      w_data: in std_logic_vector(B-1 downto 0);
      w_addr, r_addr: in std_logic_vector(W-1 downto 0);
      r_data: out std_logic_vector(B-1 downto 0)
   );
end reg_file_para;

architecture str_arch of reg_file_para is
   component mux2d is
     generic(
        P: natural; -- number of input ports
        B: natural  -- number of bits per port
     );
     port(
        a: in std_logic_2d(P-1 downto 0, B-1 downto 0);
        sel: in std_logic_vector(log2c(P)-1 downto 0);
        y: out std_logic_vector(B-1 downto 0)
     );
   end component;
   component tree_decoder is
      generic(WIDTH: natural);
      port(
         a: in std_logic_vector(WIDTH-1 downto 0);
         en: std_logic;
         code: out std_logic_vector(2**WIDTH-1 downto 0)
      );
   end component;
   constant W_SIZE: natural := 2**W;
   type reg_file_type is array (2**W-1 downto 0) of
        std_logic_vector(B-1 downto 0);
   signal array_reg: reg_file_type;
   signal array_next: reg_file_type;
   signal array_2d: std_logic_2d(2**W-1 downto 0,B-1 downto 0);
   signal en: std_logic_vector(2**W-1 downto 0);
begin
   -- register array
   process(clk,reset)
   begin
      if (reset='1') then
         array_reg <= (others=>(others=>'0'));
      elsif (clk'event and clk='1') then
         array_reg <= array_next;
      end if;
   end process;
   -- enable decoding logic for register array
   u_bin_decoder: tree_decoder
      generic map(WIDTH=>W)
      port map(en=>wr_en, a=>w_addr, code=>en);
   -- next-state logic of register file
   process(array_reg,en,w_data)
   begin
      for i in (2**W-1) downto 0 loop
         if en(i)='1' then
            array_next(i) <= w_data;
         else
            array_next(i) <= array_reg(i);
         end if;
      end loop;
   end process;
   -- convert to std_logic_2d
   process(array_reg)
   begin
      for r in (2**W-1) downto 0 loop
         for c in 0 to (B-1) loop
            array_2d(r,c)<=array_reg(r)(c);
         end loop;
      end loop;
   end process;
   -- read port multiplexing circuit
   read_mux: mux2d
      generic map(P=>2**W, B=>B)
      port map(a=>array_2d, sel=>r_addr, y=>r_data);
end str_arch;


--=============================
-- Listing 15.26
--=============================
architecture beh_arch of reg_file_para is
   type reg_file_type is array (2**W-1 downto 0) of
        std_logic_vector(B-1 downto 0);
   signal array_reg: reg_file_type;
   signal array_next: reg_file_type;
begin
   -- register array
   process(clk,reset)
   begin
      if (reset='1') then
         array_reg <= (others=>(others=>'0'));
      elsif (clk'event and clk='1') then
         array_reg <=  array_next;
      end if;
   end process;
   -- next-state logic for register array
   process(array_reg,wr_en,w_addr,w_data)
   begin
      array_next <= array_reg;
      if wr_en='1' then
         array_next(to_integer(unsigned(w_addr))) <= w_data;
      end if;
   end process;
   -- read port
   r_data <=  array_reg(to_integer(unsigned(r_addr)));
end beh_arch;