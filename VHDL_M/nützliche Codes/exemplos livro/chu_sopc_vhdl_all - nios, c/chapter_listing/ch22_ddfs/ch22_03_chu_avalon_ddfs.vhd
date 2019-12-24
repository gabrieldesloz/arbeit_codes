library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_ddfs is
   port (
      clk, reset: in  std_logic;
      -- external interface
      ddfs_data_out: out std_logic_vector(15 downto 0);
      -- avalon interface
      ddfs_address: in std_logic_vector(8 downto 0);     -- 9-bit address
      ddfs_chipselect: in std_logic; 
      ddfs_write: in std_logic;
      ddfs_writedata: in std_logic_vector(31 downto 0)
   );
end chu_avalon_ddfs;

architecture arch of chu_avalon_ddfs is
   signal fccw_reg, focw_reg: std_logic_vector(25 downto 0);
   signal pha_reg: std_logic_vector(25 downto 0);
   signal env_reg: std_logic_vector(15 downto 0);
   signal wr_en, wr_p2a_ram: std_logic;
   signal wr_fccw, wr_focw, wr_pha, wr_env: std_logic;
   
begin
   --=======================================================
   -- instantiation
   --=======================================================
   ddfs_unit: entity work.ddfs
   generic map(PW=>26)
   port map(
      clk=>clk, reset=>reset, 
      fccw=>fccw_reg, focw=>focw_reg,
      pha=>pha_reg, env=>env_reg, 
      -- p2a ram interface
      p2a_we=>wr_p2a_ram,
      p2a_waddr=>ddfs_address(7 downto 0),
      p2a_din=>ddfs_writedata(15 downto 0),
      -- ddfs output
      p2a_aout=>ddfs_data_out,
      p2a_pout=>open);
  
   --=======================================================
   -- decoding and registers
   --=======================================================
   process (clk, reset)
   begin
      if reset='1' then
         fccw_reg <= (others=>'0');
         focw_reg <= (others=>'0');
         pha_reg  <= (others=>'0');
         env_reg  <=   x"7fff";  -- almost 1.00
      elsif (clk'event and clk='1') then
         if wr_fccw='1' then
            fccw_reg <= ddfs_writedata(25 downto 0);
         end if;
         if wr_focw='1' then
            focw_reg <= ddfs_writedata(25 downto 0);
         end if;
         if wr_pha='1' then
            pha_reg <= ddfs_writedata(25 downto 0);
         end if;
         if wr_env='1' then
            env_reg <= ddfs_writedata(15 downto 0);
         end if;
      end if;
   end process;          
   wr_en <=
      '1' when ddfs_write='1' and ddfs_chipselect='1' else
      '0';
   wr_fccw <= 
      '1' when ddfs_address="000000000" and wr_en='1' else   
      '0';
   wr_focw <= 
      '1' when ddfs_address="000000001" and wr_en='1' else  
      '0';
   wr_pha <= 
      '1' when ddfs_address="000000010" and wr_en='1' else  
      '0';
   wr_env <= 
      '1' when ddfs_address="000000011" and wr_en='1' else  
      '0';
   wr_p2a_ram <= 
      '1' when  ddfs_address(8)='1' and wr_en='1' else '0';
   
end arch;
