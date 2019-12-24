
library IEEE;
use IEEE.numeric_std.all;
use ieee.std_logic_1164.all;


entity edge_calculator is

  generic(
    FREQ_BITS      : natural;
    EDGE_TO_CHECK  : natural;
    PPS_DIFF       : natural;
    TIMEOUT_PPS    : natural;
    D              : natural;
    SYS_START_WAIT : natural
    );

  
  port (
    EDGE_TO_RESET     : in  std_logic_vector(FREQ_BITS-1 downto 0);
    set_edge_to_reset : in  std_logic;
    signal_in         : in  std_logic;
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    resync_pulse      : out std_logic;
    clear_dco_out     : out std_logic;
    clear_dco_in      : in  std_logic;
    sync_soc_int_in   : in  std_logic;
    sync_soc_int_out  : out std_logic
    );

end entity edge_calculator;


architecture edge_calculator_RTL of edge_calculator is


  type state_type is (WAIT_START, FILTERx);
  signal state_reg, state_next : state_type;


  type state_wa_type is (SYS_START, NORMAL_OP);
  signal state_wa_reg, state_wa_next : state_wa_type;



  attribute syn_encoding                  : string;
  attribute syn_encoding of state_type    : type is "safe";
  attribute syn_encoding of state_wa_type : type is "safe";



  signal pos_edges_next                                    : unsigned(FREQ_BITS-1 downto 0);
  signal pos_edges_reg                                     : unsigned(FREQ_BITS-1 downto 0);
  signal count_virtual_pps_reg, count_virtual_pps_next     : natural range 0 to SYS_START_WAIT+5;
  signal sync_soc_out_vect_reg, sync_soc_out_vect_next     : unsigned(3 downto 0);
  signal counter_next, counter_reg                         : unsigned(D-1 downto 0);
  signal clear_dco_edge_calc_reg, clear_dco_edge_calc_next : std_logic;
  signal start_filter_signal_in                            : std_logic;
  signal signal_in_int                                     : std_logic;
  signal jump_pulse_resync_filter                          : std_logic;
  signal resync_pulse_int_reg, resync_pulse_int_next       : std_logic;
  signal jump_ok_flag_reg, jump_ok_flag_next               : std_logic;
  signal clear_counter_reg, clear_counter_next             : std_logic;
  signal resync_pulse_to_start_conv                        : std_logic;


  signal test_1_reg, test_1_next, test_2_reg, test_2_next : unsigned(FREQ_BITS-1 downto 0);

  

  
begin  -- architecture edge_calculator_RTL


  clear_dco_out <= clear_dco_edge_calc_reg;






  registers : process(n_reset, sysclk)
  begin
    if n_reset = '0' then

      jump_ok_flag_reg        <= '0';
      resync_pulse_int_reg    <= '0';
      count_virtual_pps_reg   <= 0;
      state_reg               <= WAIT_START;
      state_wa_reg            <= SYS_START;
      sync_soc_out_vect_reg   <= (others => '0');
      pos_edges_reg           <= (others => '0');
      clear_dco_edge_calc_reg <= '0';
      clear_counter_reg       <= '0';
      counter_reg             <= (others => '0');

    elsif rising_edge(sysclk) then

      jump_ok_flag_reg        <= jump_ok_flag_next;
      resync_pulse_int_reg    <= resync_pulse_int_next;
      count_virtual_pps_reg   <= count_virtual_pps_next;
      state_reg               <= state_next;
      state_wa_reg            <= state_wa_next;
      sync_soc_out_vect_reg   <= sync_soc_out_vect_next;
      clear_dco_edge_calc_reg <= clear_dco_edge_calc_next;
      pos_edges_reg           <= pos_edges_next;
      clear_counter_reg       <= clear_counter_next;
      counter_reg             <= counter_next;
      
    end if;
  end process;


-- timeout --------------------------------------
  counter_next       <= counter_reg + 1 when (clear_counter_reg = '0') else (others => '0');
  clear_counter_next <= '1'             when set_edge_to_reset = '1'   else '0';
-- timeout --------------------------------------



  wrap_around_process : process
    (
      clear_dco_in,
      pos_edges_reg,
      set_edge_to_reset,
      signal_in_int,
      state_wa_reg,
      resync_pulse_int_reg,
      count_virtual_pps_reg,
      jump_ok_flag_reg,
      counter_reg,
      EDGE_TO_RESET
      )


  begin

    
    if counter_reg > TIMEOUT_PPS then
      jump_ok_flag_next <= '0';
    else
      jump_ok_flag_next <= jump_ok_flag_reg;
    end if;

    count_virtual_pps_next   <= count_virtual_pps_reg;
    pos_edges_next           <= pos_edges_reg;
    start_filter_signal_in   <= '0';
    state_wa_next            <= state_wa_reg;
    clear_dco_edge_calc_next <= '0';

    case state_wa_reg is

      when SYS_START =>

        -------------------------------------------
        -- condicao para "salto" de frequencia na inicializacao
        -- 2 pulsos pps

        if (set_edge_to_reset = '1') then
          jump_ok_flag_next <= '1';
          if jump_ok_flag_reg = '1' then
            jump_ok_flag_next        <= '0';
            count_virtual_pps_next   <= 0;
            start_filter_signal_in   <= '1';
            clear_dco_edge_calc_next <= '1';
            pos_edges_next           <= (others => '0');
            state_wa_next            <= NORMAL_OP;
          end if;
        else
          --se nao vier pps,  modo de funcionamento normal
          clear_dco_edge_calc_next <= clear_dco_in;

          if pos_edges_reg = unsigned(EDGE_TO_RESET) then
            pos_edges_next <= (others => '0');
          else
            if signal_in_int = '1' then
              pos_edges_next <= pos_edges_reg + 1;
            end if;
          end if;
        end if;
        ----------------------------------------


        -- conta pps virtual ate 30, se nao surgir o pps_real, vai para o
        -- estado normal de operacao -- condicao se o equipamento nao for
        -- ligado com sincronismo  

        if resync_pulse_int_reg = '1' then
          count_virtual_pps_next <= count_virtual_pps_reg + 1;
        end if;

        if count_virtual_pps_reg = SYS_START_WAIT then
          jump_ok_flag_next      <= '0';
          count_virtual_pps_next <= 0;
          state_wa_next          <= NORMAL_OP;
        end if;
        


      when NORMAL_OP =>


        -------------------------------------------
        -- condicao para "salto" de frequencia, 2 pulsos de pps
        if set_edge_to_reset = '1' and ((pos_edges_reg > PPS_DIFF) and (pos_edges_reg < (unsigned(EDGE_TO_RESET)-PPS_DIFF))) then
          jump_ok_flag_next <= '1';

          if jump_ok_flag_reg = '1' then
            jump_ok_flag_next        <= '0';
            start_filter_signal_in   <= '1';
            clear_dco_edge_calc_next <= '1';
            pos_edges_next           <= (others => '0');
            
          end if;
        else
          -- modo de funcionamento normal
          clear_dco_edge_calc_next <= clear_dco_in;

          if pos_edges_reg = unsigned(EDGE_TO_RESET) then
            pos_edges_next <= (others => '0');
          else
            if signal_in_int = '1' then
              pos_edges_next <= pos_edges_reg + 1;
            end if;
          end if;
        end if;
      ----------------------------------------          
      when others =>
        state_wa_next <= SYS_START;
    end case;
    
  end process;




-------------------------------------------------------------------------------
  -- multiplexador pulso frequencia dco - usa o resync_pulse interno como pulso
  -- externo da frequencia do oscilador ou o pulso do oscilador (anti-jitter)
  jitter_filter : sync_soc_int_out <= resync_pulse_to_start_conv when jump_pulse_resync_filter = '1' else sync_soc_int_in;



  ------------------------------------------------------------------------------
  -- filtro jitter / salto de frequencia / cria um edge virtual e filtra o externo

  edge_fix         : sync_soc_out_vect_next <= (clear_dco_edge_calc_reg & sync_soc_out_vect_reg(2 downto 0)) srl 1;
  dco_edge_filterx : signal_in_int          <= sync_soc_out_vect_reg(1) when (jump_pulse_resync_filter = '1') else signal_in;



  filter_fsm : process(start_filter_signal_in, state_reg, sync_soc_out_vect_reg)
  begin

    state_next <= state_reg;

    case state_reg is

      when WAIT_START =>
        jump_pulse_resync_filter <= '0';
        if start_filter_signal_in = '1' then
          state_next <= FILTERx;
        end if;

      when FILTERx =>
        jump_pulse_resync_filter <= '1';
        if sync_soc_out_vect_reg(0) = '1' then
          state_next <= WAIT_START;
        end if;

      when others =>
        state_next <= WAIT_START;
    end case;
  end process;
-------------------------------------------------------------------------------




  --resync pulse logic--
  resync_output : process
    (pos_edges_reg, signal_in_int)
  begin
    resync_pulse_int_next      <= '0';
    resync_pulse               <= '0';
    resync_pulse_to_start_conv <= '0';
    if ((pos_edges_reg = EDGE_TO_CHECK-1) and (signal_in_int = '1')) then
      resync_pulse               <= '1';
      resync_pulse_int_next      <= '1';
      resync_pulse_to_start_conv <= '1';
    end if;
  end process;




end architecture edge_calculator_RTL;
