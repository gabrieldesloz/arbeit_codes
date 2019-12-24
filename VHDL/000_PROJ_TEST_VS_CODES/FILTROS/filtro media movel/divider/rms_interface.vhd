library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;




entity rms_interface is
 
  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;


    -- Avalon Interrupt Interface
    rms_irq : out std_logic;



    -- Avalon MM Slave - Interface
    rms_read       : in  std_logic;
    rms_address    : in  std_logic_vector(1 downto 0);
    rms_chipselect : in  std_logic;
    rms_write      : in  std_logic;
    rms_writedata  : in  std_logic_vector(31 downto 0);  -- (W-1)
    rms_readdata   : out std_logic_vector(31 downto 0)   -- (W-1)
    --div_readdatavalid         : out  std_logic


    -- Conduit Interface
    -- leds, lcd etc


    );


end entity rms_interface;



architecture RMS of rms_interface is

  -- signals, components declaration , types, constants, functions


  -- control signals

  signal wr_data_input      : std_logic;
  signal wr_en              : std_logic;
  signal rd_en              : std_logic;
  signal wr_n_point_samples : std_logic;
  signal irq_tick_reg       : std_logic;
  signal clr_tick_tick      : std_logic;



  -- datapath -

  signal data_input      : std_logic_vector(N_BITS_INPUT-1 downto 0);
  signal data_available  : std_logic;
  signal n_point_samples : std_logic_vector(N_POINTS_BITS-1 downto 0);
  signal data_output     : std_logic_vector((N_BITS_INPUT-1) downto 0);
  signal data_ready      : std_logic;
  signal rms_start       : std_logic;
  


  
  
begin  -- architecture DNI


-- interface com o hardware
  
  rms_1 : entity work.rms
    generic map (
      N_BITS_INPUT  => 8,
      N_POINTS_BITS => 16)
    port map (
      sysclk          => clk,
      reset_n         => n_reset,
      data_input      => data_input,
      data_available  => rms_start,
      n_point_samples => n_point_samples,
      data_output     => data_output,
      data_ready      => data_ready);


--=======================================================
-- Registers
--=======================================================
  
  process (clk, n_reset)
  begin

    if n_reset = '0' then
      data_input      <= (others => '0');
      n_point_samples <= (others => '0');
      irq_tick_reg    <= '0';
      
    elsif rising_edge(clk) then

      if wr_data_input = '1' then
        data_input <= rms_writedata(7 downto 0);
      end if;
      if wr_n_point_samples = '1' then
        n_point_samples <= rms_writedata(15 downto 0);
      end if;

      -- IRQ
      if (data_ready = '1') then
        irq_tick_reg <= '1';
      elsif (clr_irq_tick = '1') then
        irq_tick_reg <= '0';
      end if;
    end if;
  end process;



  --=======================================================
  -- Direct Nios interface communication
  --=======================================================

  --div_readdatavalid <= done_tick_reg;

  --=======================================================
  -- interrupt request signal
  --=======================================================
  rms_irq <= irq_tick_reg;



  --=======================================================
  -- write decoding logic - decoficacaoo do controle do divisor
  --=======================================================
  wr_en <= '1' when rms_write = '1' and rms_chipselect = '1' else '0';
  rd_en <= '1' when rms_read = '1' and rms_chipselect = '1'  else '0';

  wr_n_point_samples <= '1' when rms_address = "00" and wr_en = '1' else '0';
  wr_data_input      <= '1' when rms_address = "01" and wr_en = '1' else '0';

  -- inicia o algoritmo quando valor for escrito
  rms_start <= '1' when rms_address = "11" else '0';

  -- limpa a condição de flag quando o resultado for lido
  clr_done_tick <= '1' when rms_address = "10" and rd_en = '1' else '0';


  --=======================================================
  -- read multiplexing logic - demux bus de saida
  --=======================================================
  rms_readdata <= data_output when rms_address = "10" and rd_en = '1' else (others => '0');


  --=======================================================
  -- conduit signal
  --=======================================================
  -- ...

  
  


end architecture RMS;
