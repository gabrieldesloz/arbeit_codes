library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;




entity rndm_sys_interface is
  generic (
    SEED : natural := 666
    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;

    -- Avalon Interrupt Interface
    

    -- Avalon MM Slave - Interface
    rnd_read       : in  std_logic;
    rnd_address    : in  std_logic_vector(2 downto 0);
    rnd_chipselect : in  std_logic;
    rnd_readdata   : out std_logic_vector(31 downto 0)
    -- rnd_write                 : in  std_logic;
    -- rnd_writedata             : in  std_logic_vector(31 downto 0);  
    -- div_readdatavalid         : out  std_logic


    -- Conduit Interface
    -- leds, lcd etc


    );


end entity rndm_sys_interface;


architecture RNDM_NI of rndm_sys_interface is

-- signals, components declaration , types, constants, functions

-- internal signals - divisor

  signal random_vect       : std_logic_vector(31 downto 0);
  signal rnd_readdata_next : std_logic_vector(31 downto 0);
  signal rnd_readdata_reg  : std_logic_vector(31 downto 0);


-- control signals

  signal rd_en : std_logic;
  
  
begin  -- architecture DNI

-- interface com o hardware
  
  p_random_32_1 : entity work.p_random_32
    generic map (
      SEED => SEED)
    port map (
      clk         => clk,
      n_reset     => n_reset,
      random_vect => random_vect);


--=======================================================
-- Registers
--=======================================================
  
  process (clk, n_reset)
  begin

    if n_reset = '0' then
      rnd_readdata_reg <= (others => '0');
    elsif rising_edge(clk) then
      rnd_readdata_reg <= rnd_readdata_next;
    end if;
	 
  end process;


  --=======================================================
  -- Direct Nios interface communication
  --=======================================================
	rnd_readdata <= rnd_readdata_reg when rd_en = '1' else (others => '0');

  --=======================================================
  -- interrupt request signal
  --=======================================================



  --=======================================================
  -- write decoding logic - decoficacaoo do controle do divisor
  --=======================================================
  rd_en <= '1' when rnd_read = '1' and rnd_chipselect = '1' else '0';


  --=======================================================
  -- read multiplexing logic - demux bus de saida
  --=======================================================
  rnd_readdata_next <= random_vect when rd_en = '0' else rnd_readdata_reg;


  --=======================================================
  -- conduit signal
  --=======================================================
  -- ...

  
  


end architecture RNDM_NI;
