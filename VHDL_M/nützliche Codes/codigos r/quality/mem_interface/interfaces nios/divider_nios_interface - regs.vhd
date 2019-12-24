library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




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


  type BUFFER_R is array (integer range <>) of std_logic_vector (div_writedata'range);  -- ou div_readdata
  --signal BUFFER_REGS : BUFFER_R (0 to ((div_address'length)**2)-1);
  signal BUFFER_REGS : BUFFER_R (0 to 5);

  type STATE_TYPE is (WAIT_START, WAIT_DIVIDE, FINISH);
  signal state_next : STATE_TYPE;
  signal state_reg  : STATE_TYPE;

  attribute syn_encoding               : string;
  attribute syn_encoding of STATE_TYPE : type is "safe";



  -- alias

  alias num_mem     : std_logic_vector(div_writedata'range) is BUFFER_REGS(0);
  alias den_mem     : std_logic_vector(div_writedata'range) is BUFFER_REGS(1);
  alias quo_mem     : std_logic_vector(div_writedata'range) is BUFFER_REGS(2);
  alias rema_mem    : std_logic_vector(div_writedata'range) is BUFFER_REGS(3);
  alias control_mem : std_logic_vector(div_writedata'range) is BUFFER_REGS(4);
  alias status_mem  : std_logic_vector(div_writedata'range) is BUFFER_REGS(5);



-- internal signals - divisor

  signal done_tick : std_logic;
  signal div_start : std_logic;
  signal div_ready : std_logic;


  signal num_next : std_logic_vector(W-1 downto 0);
  signal num_reg  : std_logic_vector(W-1 downto 0);

  signal den_next : std_logic_vector(D-1 downto 0);
  signal den_reg  : std_logic_vector(D-1 downto 0);


  signal rema_dpth : std_logic_vector(W-1 downto 0);
  signal rema_next : std_logic_vector(W-1 downto 0);


  signal quo_dpth : std_logic_vector(W-1 downto 0);
  signal quo_next : std_logic_vector(W-1 downto 0);



-- control signals

  signal wr_num        : std_logic;
  signal wr_en         : std_logic;
  signal rd_en         : std_logic;
  signal wr_den        : std_logic;
  signal set_irq_reg   : std_logic;
  signal set_irq_next  : std_logic;
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
      quo     => quo_dpth,
      rema    => rema_dpth,
      -- flags and signaling
      start   => div_start,
      ready   => div_ready,
      done    => done_tick
      );


  div_done_irq <= set_irq_reg;

--=======================================================
-- Registers
--=======================================================

  process (clk, n_reset)
  begin

    if n_reset = '0' then

      div_readdata <= x"00000000";

      -- input
      num_reg     <= (others => '0');
      den_reg     <= (others => '0');
      -- output
      quo_mem     <= (others => '0');
      rema_mem    <= (others => '0');
      -- status/ctrl
      status_mem  <= (others => '0');
      control_mem <= (others => '0');

      set_irq_reg <= '0';
      state_reg   <= WAIT_START;

      -- zera os outros endereços da  memoria

      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i   
      
    elsif rising_edge(clk) then

      -- gravando sinais internos 

      num_reg <= num_next;
      den_reg <= den_next;

      quo_mem  <= quo_next;
      rema_mem <= rema_next;

      set_irq_reg <= set_irq_next;
      state_reg   <= state_next;

      -- prioridade para os sinais externos

      if wr_en = '1' then
        BUFFER_REGS(to_integer(unsigned(div_address))) <= div_writedata;
      end if;
      if rd_en = '1' then
        div_readdata <= BUFFER_REGS(to_integer(unsigned(div_address)));
      end if;
      
    end if;
  end process;



  --=======================================================
  -- MAIN FSM  
  --=======================================================
  -- ...


  process (control_mem, den_mem, den_reg,
           div_ready, done_tick, num_mem, num_reg, quo_dpth, quo_mem,
           rema_dpth, rema_mem, set_irq_reg, state_reg, status_mem)

  begin  -- process


    -- default
    
    num_next <= num_reg;
    den_next <= den_reg;


    quo_next  <= quo_mem;
    rema_next <= rema_mem;


    state_next   <= state_reg;
    set_irq_next <= set_irq_reg;


    -- controlpath    
    div_start <= '0';


    case state_reg is

      -- ready 1 ciclo antes
      -- done no mesmo ciclo
      -- que os dados estao prontos p/leitura
      
      
      when WAIT_START =>
        
        if control_mem(0) = '1' then
          status_mem(1) <= '0';         --- sinaliza ready = '0'
          num_next      <= num_mem;
          den_next      <= den_mem(D-1 downto 0);
          state_next    <= WAIT_DIVIDE;
          div_start     <= '1';         -- to datapath 
        end if;

        if control_mem(1) = '1' then
          set_irq_next <= '0';  --- limpa flag irq                                 

        end if;

      when WAIT_DIVIDE =>

        if done_tick = '1' then
          set_irq_next  <= '1';         --- sinaliza irq
          quo_next      <= quo_dpth;    --- from datapath
          rema_next     <= rema_dpth;   --- from datapath
          state_next    <= FINISH;
          status_mem(0) <= '1';         --- done = '1'
        end if;

      when FINISH =>

        -- IRQ no mesmo ciclo que os
        -- dados estao disponiveis
        -- div_ready 1 ciclo depois de done     
        status_mem(0) <= '0';           --- done = '0';

        state_next <= WAIT_START;
        if div_ready = '1' then         --- from datapath    
          state_next    <= WAIT_START;
          status_mem(1) <= '1';         --- ready = '1'
        end if;
        
        
      when others =>
        state_next <= WAIT_START;
    end case;
    
  end process;

  -- enable ----

  wr_en <= '1' when div_write = '1' and div_chipselect = '1' else '0';
  rd_en <= '1' when div_read = '1' and div_chipselect = '1'  else '0';
  

end architecture DNI;
