library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity spi is
   port (
      clk, reset: in  std_logic;
      din: in std_logic_vector(7 downto 0);
      dvsr: in std_logic_vector(7 downto 0);
      wr_sd: in std_logic;
      dout: out std_logic_vector(7 downto 0);
      spi_clk: out std_logic;
      spi_miso: in std_logic;
      spi_mosi: out std_logic;
      spi_done_tick, spi_idle: out std_logic
   );
end spi;

architecture arch of spi is
   type statetype is (idle, sclk0, sclk1);
   signal state_reg, state_next: statetype;
   signal c_reg, c_next: unsigned(7 downto 0);
   signal spi_clk_reg, spi_clk_next: std_logic;
   signal bit_reg, bit_next: unsigned(2 downto 0);
   signal sin_reg, sin_next: std_logic_vector(7 downto 0);
   signal sout_reg, sout_next: std_logic_vector(7 downto 0);
begin
   --=======================================================
   -- fsmd for transmitting one byte
   --=======================================================
   -- registers
   process (clk, reset)
   begin
      if reset='1' then
         state_reg <= idle;
         sin_reg <= (others=>'0');
         sout_reg <= (others=>'0');
         bit_reg <= (others=>'0');
         c_reg <=(others=>'0');
         spi_clk_reg <= '0';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         sin_reg <= sin_next;
         sout_reg <= sout_next;
         bit_reg <= bit_next;
         c_reg <=c_next;
         spi_clk_reg <= spi_clk_next;
      end if;
   end process;
   -- next-state logic
   process(state_reg,sin_reg,sout_reg,bit_reg,c_reg,
           din,dvsr,wr_sd,spi_miso)
   begin
      state_next <= state_reg;
      spi_idle <= '0';
      spi_done_tick <='0';
      sin_next <= sin_reg;
      sout_next <= sout_reg;
      bit_next <= bit_reg;
      c_next <= c_reg + 1;  -- timer runs continuouisely 
      case state_reg is
         when idle =>
            spi_idle <= '1';
            if wr_sd='1' then
               sout_next <= din;
               state_next <= sclk0;
               bit_next <= (others=>'0');
               c_next <= x"01";
            end if;
         when sclk0 =>      
            if c_reg=unsigned(dvsr) then  -- spi_clk 0-to-1
               state_next <= sclk1;
               sin_next <= sin_reg(6 downto 0) & spi_miso; 
               c_next <= x"01";
            end if;
         when sclk1 =>
            if c_reg=unsigned(dvsr) then   -- spi_clk 1-to-0
               if bit_reg=7 then
                  spi_done_tick <='1';
                  state_next <= idle;
               else      
                  sout_next <= sout_reg(6 downto 0) & '0';  
                  state_next <= sclk0;
                  bit_next <= bit_reg + 1;
                  c_next <= x"01";
               end if;
            end if;
      end case;
   end process;
   -- lookahead output decoding
   spi_clk_next <= '1' when state_next=sclk1 else '0';
   -- output
   dout <= sin_reg;
   spi_mosi <= sout_reg(7);
   spi_clk <= spi_clk_reg;
end arch;

   -- constant DVSR: integer := 7; --**** 6 introduces occasional errors (too fast?)
   -- tick  50M/2^6=785KHz
   --   spi_clk = 785/2=392K Hz (max 400K Hz during initialization)

