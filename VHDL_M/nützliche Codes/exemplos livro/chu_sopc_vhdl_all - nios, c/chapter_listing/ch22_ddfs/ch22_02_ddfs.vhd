library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ddfs is
   generic(PW: integer:=26); -- width of phase accumulator
   port (
      clk, reset: in  std_logic;
      fccw: in std_logic_vector(PW-1 downto 0); -- carrier frequency control word
      focw: in std_logic_vector(PW-1 downto 0); -- frequency offset control word
      pha: in std_logic_vector(PW-1 downto 0); -- phase offset
      env: in std_logic_vector(15 downto 0);  -- envelop 
      -- p2a ram interface
      p2a_we: in std_logic;
      p2a_waddr: in std_logic_vector(7 downto 0);
      p2a_din: in std_logic_vector(15 downto 0);
      p2a_aout: out std_logic_vector(15 downto 0);
      p2a_pout: out std_logic_vector(PW-1 downto 0)
       );
end ddfs;

architecture arch of ddfs is
   signal fcw, p_reg, p_next, pcw: unsigned(PW-1 downto 0);
   signal p2a_raddr: std_logic_vector(7 downto 0);
   signal amp: std_logic_vector(15 downto 0);
   signal modu: signed(31 downto 0); 

begin
   -- instantiate sin ROM
   p2a_ram: entity work.altera_ram_lut 
   port map(
     clk=>clk, we=> p2a_we, addr_w=>p2a_waddr, din=>p2a_din, 
     addr_r=>p2a_raddr, dout=>amp);
   -- phase register
   process (clk, reset)
   begin
      if reset='1' then
         p_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         p_reg <= p_next;
      end if;
   end process;
   -- frequency modulation
   fcw <= unsigned(fccw) + unsigned(focw);
   -- phase accumulation 
   p_next <= p_reg + fcw;
   -- phase modulation
   pcw <= p_reg + unsigned(pha);   
   -- phase to amplitude mapping address
   p2a_raddr <= std_logic_vector(pcw(PW-1 downto PW-8));
   -- amplitude modulation 
   -- Q16.0 * Q1.15 => modu is Q17.15
   -- However the -1 is not used and thus MSB of modu is always 0
   modu <= signed(env) *  signed(amp);  -- modulated output 
   p2a_aout <= std_logic_vector(modu(30 downto 15));
   p2a_pout <= std_logic_vector(p_reg);
end arch;
   
   
--   p_next <= (others=>'0') when unsigned(fcw)=0 else
--              p_reg + unsigned(fcw);
--   p_acc <= p_reg + unsigned(phase);         
--   addr_r <= std_logic_vector(p_reg(PW-1 downto PW-8));
--   p2a_aout <= (others=>'0') when unsigned(fcw)=0 else 
--               std_logic_vector(modu(30 downto 15));
--   p2a_aout <= (others=>'0') when unsigned(fcw)=0 else 
--               std_logic_vector(dout);
--   p2a_pout <= std_logic_vector(p_acc);
