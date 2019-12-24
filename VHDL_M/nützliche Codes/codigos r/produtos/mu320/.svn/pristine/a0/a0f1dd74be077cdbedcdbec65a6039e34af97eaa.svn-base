-------------------------------------------------------------------------------
-- Title   : Watchdog Instrument
-- Project : MU_320
-------------------------------------------------------------------------------
-- File          : watchdog_instrument.vhd
-- Author        : Gabriel Lozano
-- Company       : Reason Tecnologia S.A.
-- Created       : 2013-06-
-- Last update   : 2013-06-
-- Target Device :
-- Standard      : VHDL'93
-------------------------------------------------------------------------------
-- Description   : Somador de fases: Va, Vb, Vc, tendo o resultado armazenado
--                 no canal apropriado. 
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions     :
-- Date          Version Author Description
-- 2013-06-18    1.0     GDL    Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

entity phase_sum is
  generic (
    N_CHANNELS_ANA_BOARD : natural := 8;
    COE_IN_OUT_BITS      : natural := 128
    );
  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    reset_n :    std_logic;

    -- Avalon MM Slave - Interface
    avs_read       : in  std_logic;
    avs_address    : in  std_logic_vector(1 downto 0);
    avs_chipselect : in  std_logic;
    avs_write      : in  std_logic;
    avs_writedata  : in  std_logic_vector(31 downto 0);
    avs_readdata   : out std_logic_vector(31 downto 0);


    -- Conduit Interface
    coe_sysclk         : in  std_logic; 
    coe_data_input     : in  std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
    coe_data_output    : out std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
    coe_data_ready_in  : in  std_logic;
    coe_data_ready_out : out std_logic


    );

end phase_sum;

architecture rtl of phase_sum is


  type FSM_STATE_TYPE is (ST_FSM_NORMAL, ST_FSM_SUM);
  attribute syn_encoding                   : string;
  attribute syn_encoding of FSM_STATE_TYPE : type is "safe";
  signal fsm_state_reg, fsm_state_next     : FSM_STATE_TYPE;



  signal va_signed                         : signed(N_BITS_ADC-1 downto 0);
  signal vb_signed                         : signed(N_BITS_ADC-1 downto 0);
  signal vc_signed                         : signed(N_BITS_ADC-1 downto 0);
  signal data_output_reg, data_output_next : std_logic_vector(coe_data_input'range);



-- sinais de controle

  signal do_sum                          : std_logic;
  signal control_reg, control_next       : std_logic;
  signal write_ok, read_ok               : std_logic;
  signal data_ready_next, data_ready_reg : std_logic;


-- definicao dos canais de tensao
  alias va_in  : std_logic_vector(N_BITS_ADC-1 downto 0) is coe_data_input(((VA_CHANNEL)* N_BITS_ADC)+(N_BITS_ADC-1) downto ((VA_CHANNEL)*N_BITS_ADC));
  alias vb_in  : std_logic_vector(N_BITS_ADC-1 downto 0) is coe_data_input(((VB_CHANNEL)* N_BITS_ADC)+(N_BITS_ADC-1) downto ((VB_CHANNEL)*N_BITS_ADC));
  alias vc_in  : std_logic_vector(N_BITS_ADC-1 downto 0) is coe_data_input(((VC_CHANNEL)* N_BITS_ADC)+(N_BITS_ADC-1) downto ((VC_CHANNEL)*N_BITS_ADC));
  alias vn_in  : std_logic_vector(N_BITS_ADC-1 downto 0) is coe_data_input(((N_CHANNEL)* N_BITS_ADC)+(N_BITS_ADC-1) downto ((N_CHANNEL)*N_BITS_ADC));
  alias vn_out : std_logic_vector(N_BITS_ADC-1 downto 0) is data_output_next(((N_CHANNEL)* N_BITS_ADC)+(N_BITS_ADC-1) downto ((N_CHANNEL)*N_BITS_ADC));


-- datapath
  signal adder : signed(N_BITS_ADC-1 downto 0);
  
  
begin

  -- conversoes
  va_signed <= signed(va_in);
  vb_signed <= signed(vb_in);
  vc_signed <= signed(vc_in);


  -- datapath
  adder <= va_signed + vb_signed + vc_signed;


  -- controle nios

  do_sum       <= control_reg;
  control_next <= avs_writedata(0)                 when (write_ok = '1' and (unsigned(avs_address) = 0)) else control_reg;
  write_ok     <= '1'                              when (avs_write = '1' and avs_chipselect = '1')       else '0';
  read_ok      <= '1'                              when (avs_read = '1' and avs_chipselect = '1')        else '0';
  avs_readdata <= x"0000000" & "000" & control_reg when (read_ok = '1' and (unsigned(avs_address) = 0))  else (others => '0');


  -- registradores nios - dominio de relogio do nios
  process(clk, reset_n)
  begin
    if reset_n = '0' then 
      control_reg     <= '0';
    elsif rising_edge(clk) then
      control_reg     <= control_next;
    end if;
  end process;



  -- FSM 
  process(do_sum, fsm_state_reg)
  begin   
    fsm_state_next <= fsm_state_reg;

    case fsm_state_reg is
      when ST_FSM_NORMAL =>
        
        if do_sum = '1' then          
          fsm_state_next <= ST_FSM_SUM;
        end if;

      when ST_FSM_SUM =>
        if do_sum = '0' then       
          fsm_state_next <= ST_FSM_NORMAL;
        end if;
        
      when others =>
        fsm_state_next <= ST_FSM_NORMAL;
    end case;
  end process;

  
  -- registradores modulo - dominio de relogio do fpga
  process(coe_sysclk, reset_n)
  begin
    if reset_n = '0' then
      fsm_state_reg   <= ST_FSM_NORMAL;
      data_output_reg <= (others => '0');
      data_ready_reg  <= '0';
    elsif rising_edge(coe_sysclk) then
      fsm_state_reg   <= fsm_state_next;   
      data_output_reg <= data_output_next;
      data_ready_reg  <= data_ready_next;
    end if;
  end process;

  

  -- atribuicao dos canais

  channel_generate : for i in 0 to (N_CHANNELS_ANA_BOARD - 1) generate  --  
    a : if (i /= (N_CHANNEL)) generate
      data_output_next(((i*N_BITS_ADC)+(N_BITS_ADC-1)) downto (i*N_BITS_ADC)) <= coe_data_input(((i*N_BITS_ADC)+(N_BITS_ADC-1)) downto (i*N_BITS_ADC));
    end generate a;

    b : if (i = (N_CHANNEL)) generate
      vn_out <= std_logic_vector(adder) when (fsm_state_reg = ST_FSM_SUM) else vn_in;
    end generate b;
  end generate channel_generate;  -- i


  coe_data_output    <= data_output_reg;
  data_ready_next    <= coe_data_ready_in;
  coe_data_ready_out <= data_ready_reg;

end rtl;
