library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;




entity divider_nios_interface is
  generic (
    -- data width (32 bits maximum Avalon interface)
    W : natural := 32;
    -- dividend size, D < W
    D : natural := 28

    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    n_reset : in std_logic;


    -- Avalon Interrupt Interface
    div_done_irq : out std_logic;



    -- Avalon MM Slave - Interface
    div_read       : in  std_logic;
    div_address    : in  std_logic_vector(2 downto 0);
    div_chipselect : in  std_logic;
    div_write      : in  std_logic;
    div_writedata  : in  std_logic_vector(31 downto 0);  -- (W-1)
    div_readdata   : out std_logic_vector(31 downto 0)   -- (W-1)
    --div_readdatavalid         : out  std_logic


    -- Conduit Interface
    -- leds, lcd etc


    );


end entity divider_nios_interface;



architecture DNI of divider_nios_interface is

  --signals, components declaration , types, constants, functions

-- internal signals - divisor

  signal set_done_tick : std_logic;
  signal div_start     : std_logic;
  signal num_reg       : std_logic_vector(W-1 downto 0);
  signal den_reg       : std_logic_vector(D-1 downto 0);
  signal rema          : std_logic_vector(W-1 downto 0);
  signal quo           : std_logic_vector(W-1 downto 0);
  signal div_ready     : std_logic;

-- control signals

  signal wr_num        : std_logic;
  signal wr_en         : std_logic;
  signal rd_en         : std_logic;
  signal wr_den        : std_logic;
  signal done_tick_reg : std_logic;
  signal clr_done_tick : std_logic;
  
  
  
  
begin  -- architecture DNI


-- interface com o hardware
  
  divider_1 : entity work.divider
    generic map (
      N => W,
      D => D)
    port map (
      -- clock and reset interface
      sysclk  => clk,
      n_reset => n_reset,
      -- data ports
      num     => num_reg,
      den     => den_reg,
      quo     => quo,
      rema    => rema,
      -- flags and signaling
      start   => div_start,
      ready   => div_ready,
      done    => set_done_tick
      );



--=======================================================
-- Registers
--=======================================================
  
  process (clk, n_reset)
  begin

    if n_reset = '0' then
      num_reg       <= (others => '0');
      den_reg       <= (others => '0');

      done_tick_reg <= '0';
      
    elsif rising_edge(clk) then
      --seleciona quando a operacao sera de leitura ou de escrita
      if wr_den = '1' then
        den_reg <= div_writedata(D-1 downto 0);
      end if;
      if wr_num = '1' then
        num_reg <= div_writedata;
      end if;
		
		
		--- sinalizaçao IRQ ---		
      -- limpa / seta flags (done_tick)
      if (set_done_tick = '1') then
        done_tick_reg <= '1';
      elsif (clr_done_tick = '1') then
        done_tick_reg <= '0';
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
  div_done_irq <= done_tick_reg;



  --=======================================================
  -- write decoding logic - decoficacaoo do controle do divisor
  --=======================================================
  wr_en         <= '1' when div_write = '1' and div_chipselect = '1' else '0';  
  rd_en         <= '1' when div_read  = '1' and div_chipselect = '1' else '0';  
  wr_num        <= '1' when div_address = "000" and wr_en = '1'      else '0';  --//--  endereço 0
  wr_den        <= '1' when div_address = "001" and wr_en = '1'      else '0';  --//--  endereço 1
  div_start     <= '1' when div_address = "010" and wr_en = '1'      else '0';  --//--  endereço 2
  clr_done_tick <= '1' when div_address = "011" and wr_en = '1'      else '0';  --//-- para IRQ, endereço 3





  --=======================================================
  -- read multiplexing logic - demux bus de saida
  --=======================================================
  div_readdata <=
    quo                            				when div_address = "100" and rd_en = '1' else
    rema                           				when div_address = "101" and rd_en = '1' else
    x"0000000" & "000" & div_ready 				when div_address = "110" and rd_en = '1' else
    x"0000000" & "000" & done_tick_reg       when div_address = "111" and rd_en = '1' else     
	 (others => '0') ; 		


  --=======================================================
  -- conduit signal
  --=======================================================
  -- ...

  
  


end architecture DNI;
