


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

entity phase_sum is
  generic (
    N_CHANNELS_ANA_BOARD : natural := 8;
    COE_IN_OUT_BITS      : natural := 256;
    N_BITS               : natural := 32

    );
  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    reset_n :    std_logic;

    -- Avalon MM Slave - Interface
    avs_address    : in std_logic;
    avs_chipselect : in std_logic;
    avs_write      : in std_logic;
    avs_writedata  : in std_logic_vector(31 downto 0);

    -- Conduit Interface
    coe_sysclk         : in  std_logic;
    coe_data_input     : in  std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
    coe_data_output    : out std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
    coe_data_ready_in  : in  std_logic;
    coe_data_ready_out : out std_logic;

    -- quality output
    coe_phase_sum_ovf_o : out std_logic_vector(1 downto 0)

    );

end phase_sum;

architecture rtl of phase_sum is


  type FSM_STATE_TYPE is (ST_FSM_NORMAL, ST_FSM_SUM);
  attribute syn_encoding                   : string;
  attribute syn_encoding of FSM_STATE_TYPE : type is "safe";
  signal fsm_state_reg, fsm_state_next     : FSM_STATE_TYPE;


  signal data_output_reg, data_output_next : std_logic_vector(coe_data_input'range);

-- datapath signals

  signal control_reg, control_next       : std_logic_vector(1 downto 0);
  signal data_ready_next, data_ready_reg : std_logic;
  signal write_ok                        : std_logic;



  alias a2_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((A2_CHANNEL)* N_BITS)+(N_BITS-1) downto ((A2_CHANNEL)*N_BITS));
  alias b2_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((B2_CHANNEL)* N_BITS)+(N_BITS-1) downto ((B2_CHANNEL)*N_BITS));
  alias c2_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((C2_CHANNEL)* N_BITS)+(N_BITS-1) downto ((C2_CHANNEL)*N_BITS));
  alias n2_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input (((N2_CHANNEL)* N_BITS)+(N_BITS-1) downto ((N2_CHANNEL)*N_BITS));
  alias n2_out : std_logic_vector(N_BITS-1 downto 0) is data_output_next(((N2_CHANNEL)* N_BITS)+(N_BITS-1) downto ((N2_CHANNEL)*N_BITS));

  alias a1_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((A1_CHANNEL)* N_BITS)+(N_BITS-1) downto ((A1_CHANNEL)*N_BITS));
  alias b1_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((B1_CHANNEL)* N_BITS)+(N_BITS-1) downto ((B1_CHANNEL)*N_BITS));
  alias c1_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input(((C1_CHANNEL)* N_BITS)+(N_BITS-1) downto ((C1_CHANNEL)*N_BITS));
  alias n1_in  : std_logic_vector(N_BITS-1 downto 0) is coe_data_input (((N1_CHANNEL)* N_BITS)+(N_BITS-1) downto ((N1_CHANNEL)*N_BITS));
  alias n1_out : std_logic_vector(N_BITS-1 downto 0) is data_output_next(((N1_CHANNEL)* N_BITS)+(N_BITS-1) downto ((N1_CHANNEL)*N_BITS));

  signal ovf_next, ovf_reg  : std_logic_vector(1 downto 0);
  signal adder_n1, adder_n2 : std_logic_vector(N_BITS-1 downto 0);
  signal done_o_1, done_o_2 : std_logic;
 
  
begin

  -- adders --
  
  adder_ovf_1 : entity work.adder_ovf
    generic map (
      N => N_BITS)
    port map (
      sysclk       => coe_sysclk,
      reset_n      => reset_n,
      start_calc_i => coe_data_ready_in,
      val_1_i      => a1_in,
      val_2_i      => b1_in,
      val_3_i      => c1_in,
      val_o        => adder_n1,
      done_o       => done_o_1,
      ovf_o        => ovf_next(0)
      );


  adder_ovf_2 : entity work.adder_ovf
    generic map (
      N => N_BITS)
    port map (
      sysclk       => coe_sysclk,
      reset_n      => reset_n,
      start_calc_i => coe_data_ready_in,
      val_1_i      => a2_in,
      val_2_i      => b2_in,
      val_3_i      => c2_in,
      val_o        => adder_n2,
      done_o       => done_o_2,
      ovf_o        => ovf_next(1)
      );

  data_ready_next <= done_o_2 and done_o_1;

-- controle nios

  control_next <= avs_writedata(1 downto 0) when (write_ok = '1' and (avs_address = '0'))   else control_reg;
  write_ok     <= '1'                       when (avs_write = '1' and avs_chipselect = '1') else '0';


  -- registradores nios - dominio de relogio do nios
  process(clk, reset_n)
  begin
    if reset_n = '0' then
      control_reg <= (others => '0');
    elsif rising_edge(clk) then
      control_reg <= control_next;
    end if;
  end process;


  -- FSM 
  process(control_reg, fsm_state_reg)
  begin
    fsm_state_next <= fsm_state_reg;

    case fsm_state_reg is
      when ST_FSM_NORMAL =>
        
        if control_reg(1 downto 0) /= "00" then
          fsm_state_next <= ST_FSM_SUM;
        end if;

      when ST_FSM_SUM =>
        if control_reg(1 downto 0) = "00" then
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
      ovf_reg         <= (others => '0');
    elsif rising_edge(coe_sysclk) then
      fsm_state_reg   <= fsm_state_next;
      data_output_reg <= data_output_next;
      data_ready_reg  <= data_ready_next;
      ovf_reg         <= ovf_next;
    end if;
  end process;



  -- atribuicao dos canais

  channel_generate : for i in 0 to (N_CHANNELS_ANA_BOARD - 1) generate  --  
    a : if ((i /= (N2_CHANNEL)) and (i /= (N1_CHANNEL))) generate
      data_output_next(((i*N_BITS)+(N_BITS-1)) downto (i*N_BITS)) <= coe_data_input(((i*N_BITS)+(N_BITS-1)) downto (i*N_BITS));
    end generate a;

    b : if (i = (N2_CHANNEL)) generate
      n2_out <= std_logic_vector(adder_n2) when ((fsm_state_reg = ST_FSM_SUM) and (control_reg(1) = '1')) else n2_in;
    end generate b;

    c : if (i = (N1_CHANNEL)) generate
      n1_out <= std_logic_vector(adder_n1) when ((fsm_state_reg = ST_FSM_SUM) and (control_reg(0) = '1')) else n1_in;
    end generate c;

    
    
  end generate channel_generate;  -- i


  coe_data_output     <= data_output_reg;
  coe_data_ready_out  <= data_ready_reg;
  coe_phase_sum_ovf_o <= ovf_reg;

end rtl;
