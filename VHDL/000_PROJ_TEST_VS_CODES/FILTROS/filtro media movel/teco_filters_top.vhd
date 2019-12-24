-------------------------------------------------------------------------------
-- Title      : Unidade "TOP LEVEL" Do projeto de integracao TECO - MU
-- Project    :
-------------------------------------------------------------------------------
-- File       : teco_filters_top.vhd
-- Author     :   <gdl@IXION>
-- Company    :
-- Created    : 2013-08-27
-- Last update: 2013-09-13
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: A unidade faz a reorganizacao dos vetores, enviando os canais
-- adequados para soma, divisao e media aritmetica atraves de um filtro de
-- mmedia movel. 
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-27  1.0      gdl     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



-------------------------------------------------------------------------------

entity teco_filters_top is

  generic (
    SAMPLE_SIZE      : natural := 32;
    MEM_BUFFER_SIZE  : natural := 128;
    ACC_BITS         : natural := 8;
    SHIFT_BITS       : natural := 14;
    SHIFT_DIV_BITS   : natural := 7;
    WAIT_START_COUNT : natural := 256
    );

  port (
    sysclk          : in  std_logic;
    reset_n         : in  std_logic;
    sample_adjust_i : in  std_logic_vector((16*SAMPLE_SIZE)-1 downto 0);
    teco_filters_o  : out std_logic_vector((16*SAMPLE_SIZE)-1 downto 0);
    sample_ok_i     : in  std_logic;
    sample_offset_ok : out std_logic
    );

end entity teco_filters_top;

-------------------------------------------------------------------------------

architecture RTL of teco_filters_top is

  signal sample_ok_i_reg : std_logic;

  signal channel_15_in, channel_14_in, channel_13_in, channel_12_in, channel_11_in, channel_10_in, channel_9_in, channel_8_in, channel_7_in,
    channel_6_in, channel_5_in, channel_4_in, channel_3_in, channel_2_in, channel_1_in, channel_0_in : std_logic_vector(SAMPLE_SIZE-1 downto 0);

  signal vx_a_vy, vx_a_vy_reg, vx_s_vy, vx_s_vy_reg : std_logic_vector(SAMPLE_SIZE-1 downto 0);

  signal input_from_smp_adjst_next, input_from_smp_adjst_reg : std_logic_vector(8*(SAMPLE_SIZE+SHIFT_BITS)-1 downto 0);

  signal save_input_from_smp_adjst : std_logic;

  signal ready_divider_mux : std_logic;
  signal start_first_div   : std_logic;

  signal d_ana_proc : std_logic_vector(4*(SAMPLE_SIZE+SHIFT_BITS)-1 downto 0);

  signal channel_0_divider_next, channel_1_divider_next, channel_2_divider_next, channel_3_divider_next : std_logic_vector((SAMPLE_SIZE+SHIFT_BITS)-1 downto 0);
  signal channel_0_divider_reg, channel_1_divider_reg, channel_2_divider_reg, channel_3_divider_reg     : std_logic_vector((SAMPLE_SIZE+SHIFT_BITS)-1 downto 0);

  signal save_first_div : std_logic;

  signal ready_arith_ctrl_0, ready_arith_ctrl_1, ready_arith_ctrl_2, ready_arith_ctrl_3 : std_logic;
  signal arith_ctrl_acc0, arith_ctrl_acc1, arith_ctrl_acc2, arith_ctrl_acc3             : std_logic_vector((SAMPLE_SIZE+SHIFT_BITS)-1 downto 0);

  signal ready_arith_ctrl_next : std_logic_vector(3 downto 0);

  signal ready_arith_ctrl_reg : std_logic_vector(3 downto 0);

  signal save_input_from_arith_ctrl : std_logic;

  signal avg_channel_3_reg, avg_channel_2_reg, avg_channel_1_reg, avg_channel_0_reg : std_logic_vector((SAMPLE_SIZE)-1 downto 0);

  signal save_result_subt_add : std_logic;

  signal channel_11_output, channel_10_output, channel_9_output, channel_8_output, channel_7_output, channel_6_output, channel_5_output, channel_4_output,
    channel_3_output, channel_2_output, channel_1_output, channel_0_output, channel_15_output, channel_14_output, channel_13_output,
    channel_12_output : std_logic_vector(SAMPLE_SIZE-1 downto 0);

  signal output_vector_next, output_vector_reg : std_logic_vector((16*SAMPLE_SIZE)-1 downto 0);
  signal start_arith                           : std_logic;
  signal send_output                           : std_logic;
  signal clear_out_reset_n_o                   : std_logic;


  
  
  
begin  -- architecture RTL


  reg_sample_ok : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      sample_ok_i_reg <= '0';
    elsif rising_edge(sysclk) then
      sample_ok_i_reg <= sample_ok_i;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- reorganização dos vetores
  -----------------------------------------------------------------------------  


  channel_15_in        <= sample_adjust_i((16*SAMPLE_SIZE)-1 downto 15*SAMPLE_SIZE);
  channel_14_in        <= sample_adjust_i((15*SAMPLE_SIZE)-1 downto 14*SAMPLE_SIZE);
  channel_13_in        <= sample_adjust_i((14*SAMPLE_SIZE)-1 downto 13*SAMPLE_SIZE);
  channel_12_in        <= sample_adjust_i((13*SAMPLE_SIZE)-1 downto 12*SAMPLE_SIZE);
  channel_11_in        <= sample_adjust_i((12*SAMPLE_SIZE)-1 downto 11*SAMPLE_SIZE);
  channel_10_in        <= sample_adjust_i((11*SAMPLE_SIZE)-1 downto 10*SAMPLE_SIZE);
  channel_9_in        <= sample_adjust_i((10*SAMPLE_SIZE)-1 downto 9*SAMPLE_SIZE);
  channel_8_in        <= sample_adjust_i((9*SAMPLE_SIZE)-1 downto 8*SAMPLE_SIZE);
  add_vx_vy : vx_a_vy <= std_logic_vector(signed(channel_6_in) + signed(channel_7_in));
  sub_vx_vy : vx_s_vy <= std_logic_vector(signed(channel_6_in) - signed(channel_7_in));
  channel_7_in        <= sample_adjust_i((8*SAMPLE_SIZE)-1 downto 7*SAMPLE_SIZE);
  channel_6_in        <= sample_adjust_i((7*SAMPLE_SIZE)-1 downto 6*SAMPLE_SIZE);
  channel_5_in       <= sample_adjust_i((6*SAMPLE_SIZE)-1 downto 5*SAMPLE_SIZE);
  channel_4_in       <= sample_adjust_i((5*SAMPLE_SIZE)-1 downto 4*SAMPLE_SIZE);
  channel_3_in       <= sample_adjust_i((4*SAMPLE_SIZE)-1 downto 3*SAMPLE_SIZE);
  channel_2_in       <= sample_adjust_i((3*SAMPLE_SIZE)-1 downto 2*SAMPLE_SIZE);
  channel_1_in       <= sample_adjust_i((2*SAMPLE_SIZE)-1 downto 1*SAMPLE_SIZE);
  channel_0_in       <= sample_adjust_i((1*SAMPLE_SIZE)-1 downto 0*SAMPLE_SIZE);

-------------------------------------------------------------------------------




  reg_subt_add : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      vx_a_vy_reg <= (others => '0');
      vx_s_vy_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if save_result_subt_add = '1' then
        vx_a_vy_reg <= vx_a_vy;
        vx_s_vy_reg <= vx_s_vy;
      end if;
    end if;
  end process;



  -- organização dos vetores para a entrada do multiplixador de divisão. É
  -- aplicado um ganho em algumas entradas para que os numeradores sejam maiores
  -- que os denominadores

  input_from_smp_adjst_next <=
    std_logic_vector(

      -- multiplicação do numerador (shift_left) e redimensionamento com copia do bit mais significativo (resize signed)                                                 
      shift_left(resize(signed(channel_1_in), SAMPLE_SIZE+SHIFT_BITS), SHIFT_BITS)
      --resize(signed(channel_1_in), SAMPLE_SIZE+SHIFT_BITS)
      & resize(signed(channel_0_in), SAMPLE_SIZE+SHIFT_BITS)
      & shift_left(resize(signed(channel_3_in), SAMPLE_SIZE+SHIFT_BITS), SHIFT_BITS)
      & resize(signed(channel_2_in), SAMPLE_SIZE+SHIFT_BITS)
      & shift_left(resize(signed(channel_5_in), SAMPLE_SIZE+SHIFT_BITS), SHIFT_BITS)
      & resize(signed(channel_4_in), SAMPLE_SIZE+SHIFT_BITS)
      & shift_left(resize(signed(vx_s_vy_reg), SAMPLE_SIZE+SHIFT_BITS), SHIFT_BITS)
      & resize(signed(vx_a_vy_reg), SAMPLE_SIZE+SHIFT_BITS)
      );


  reg_in : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      input_from_smp_adjst_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if save_input_from_smp_adjst = '1' then
        input_from_smp_adjst_reg <= input_from_smp_adjst_next;
      end if;
    end if;
  end process;



  divider_mux_1 : entity work.divider_mux
    generic map (
      N_CHANNELS_ANA => 8,
      N_BITS_ADC     => SAMPLE_SIZE+SHIFT_BITS)
    port map (
      sysclk            => sysclk,
      n_reset           => reset_n,
      d_ana_i           => input_from_smp_adjst_reg,
      d_ana_proc_o      => d_ana_proc,
      ready_data_o      => ready_divider_mux,
      start_div_i       => start_first_div,
      one_division_done => open);


--reorganização dos canais para os modulos de aritmética
  
  channel_3_divider_next <= d_ana_proc((1*(SAMPLE_SIZE+SHIFT_BITS))-1 downto 0*(SAMPLE_SIZE+SHIFT_BITS));
  channel_2_divider_next <= d_ana_proc((2*(SAMPLE_SIZE+SHIFT_BITS))-1 downto 1*(SAMPLE_SIZE+SHIFT_BITS));
  channel_1_divider_next <= d_ana_proc((3*(SAMPLE_SIZE+SHIFT_BITS))-1 downto 2*(SAMPLE_SIZE+SHIFT_BITS));
  channel_0_divider_next <= d_ana_proc((4*(SAMPLE_SIZE+SHIFT_BITS))-1 downto 3*(SAMPLE_SIZE+SHIFT_BITS));




  reg_channel : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      channel_3_divider_reg <= (others => '0');
      channel_2_divider_reg <= (others => '0');
      channel_1_divider_reg <= (others => '0');
      channel_0_divider_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if save_first_div = '1' then
        channel_3_divider_reg <= channel_3_divider_next;
        channel_2_divider_reg <= channel_2_divider_next;
        channel_1_divider_reg <= channel_1_divider_next;
        channel_0_divider_reg <= channel_0_divider_next;
      end if;
    end if;
  end process;


  -- component instantiation
  arith_ctrl_0 : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => (SAMPLE_SIZE+SHIFT_BITS),
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => channel_3_divider_reg,
      sample_available_i => start_arith,
      ready_sample_n_o   => ready_arith_ctrl_3,
      average_offset_n_o => arith_ctrl_acc3);


  arith_ctrl_1 : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => (SAMPLE_SIZE+SHIFT_BITS),
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => channel_2_divider_reg,
      sample_available_i => start_arith,
      ready_sample_n_o   => ready_arith_ctrl_2,
      average_offset_n_o => arith_ctrl_acc2);



  arith_ctrl_2 : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => (SAMPLE_SIZE+SHIFT_BITS),
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => channel_1_divider_reg,
      sample_available_i => start_arith,
      ready_sample_n_o   => ready_arith_ctrl_1,
      average_offset_n_o => arith_ctrl_acc1);


  arith_ctrl_3 : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => (SAMPLE_SIZE+SHIFT_BITS),
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => channel_0_divider_reg,
      sample_available_i => start_arith,
      ready_sample_n_o   => ready_arith_ctrl_0,
      average_offset_n_o => arith_ctrl_acc0);  



  ready_arith_ctrl_next <= (ready_arith_ctrl_0 & ready_arith_ctrl_1 & ready_arith_ctrl_2 & ready_arith_ctrl_3);


  reg_arith_ready : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      ready_arith_ctrl_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      ready_arith_ctrl_reg <= ready_arith_ctrl_next;
    end if;
  end process;

  reg_arith_ctrl : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      avg_channel_3_reg <= (others => '0');
      avg_channel_2_reg <= (others => '0');
      avg_channel_1_reg <= (others => '0');
      avg_channel_0_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if save_input_from_arith_ctrl = '1' then
        -- sinal & parte inteira & parte fracionaria
        avg_channel_3_reg <= arith_ctrl_acc3((SHIFT_BITS+SAMPLE_SIZE)-1) & arith_ctrl_acc3(SAMPLE_SIZE-2 downto SHIFT_BITS) & arith_ctrl_acc3(SHIFT_BITS-1 downto 0);
        avg_channel_2_reg <= arith_ctrl_acc2((SHIFT_BITS+SAMPLE_SIZE)-1) & arith_ctrl_acc2(SAMPLE_SIZE-2 downto SHIFT_BITS) & arith_ctrl_acc2(SHIFT_BITS-1 downto 0);
        avg_channel_1_reg <= arith_ctrl_acc1((SHIFT_BITS+SAMPLE_SIZE)-1) & arith_ctrl_acc1(SAMPLE_SIZE-2 downto SHIFT_BITS) & arith_ctrl_acc1(SHIFT_BITS-1 downto 0);
        avg_channel_0_reg <= arith_ctrl_acc0((SHIFT_BITS+SAMPLE_SIZE)-1) & arith_ctrl_acc0(SAMPLE_SIZE-2 downto SHIFT_BITS) & arith_ctrl_acc0(SHIFT_BITS-1 downto 0);
      end if;
    end if;
  end process;



--avg_channel_1_reg <= std_logic_vector(shift_right(resize(signed(arith_ctrl_acc1), SAMPLE_SIZE), SHIFT_BITS));




  -------------------------------------------------------------------------------
-- reorganização dos vetores
-------------------------------------------------------------------------------

  channel_0_output <= avg_channel_0_reg;
  channel_1_output <= avg_channel_1_reg;
  channel_2_output <= avg_channel_2_reg;
  channel_3_output <= avg_channel_3_reg;

  channel_4_output  <= channel_12_in;
  channel_5_output  <= channel_13_in;
  channel_6_output  <= channel_14_in;
  channel_7_output  <= channel_15_in;
  channel_8_output  <= channel_8_in;
  channel_9_output  <= channel_9_in;
  channel_10_output <= channel_10_in;
  channel_11_output <= channel_11_in;
  channel_12_output <= channel_12_in;
  channel_13_output <= channel_13_in;
  channel_14_output <= channel_14_in;
  channel_15_output <= channel_15_in;


  output_vector_next <= channel_15_output &
                        channel_14_output &
                        channel_13_output &
                        channel_12_output &
                        channel_11_output &
                        channel_10_output &
                        channel_9_output &
                        channel_8_output &
                        channel_7_output &
                        channel_6_output &
                        channel_5_output &
                        channel_4_output &
                        channel_3_output &
                        channel_2_output &
                        channel_1_output &
                        channel_0_output;

-------------------------------------------------------------------------------
  
  reg_out_ctrl : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      output_vector_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if send_output = '1' then
        output_vector_reg <= output_vector_next;
      elsif clear_out_reset_n_o = '0' then
        output_vector_reg <= (others => '0');
      end if;
    end if;
  end process;

  teco_filters_o <= output_vector_reg;


  control_path : entity work.main_fsm

    generic map (
      WAIT_START_COUNT => WAIT_START_COUNT
      )    

    port map (

      sysclk  => sysclk,
      reset_n => reset_n,

      save_result_subt_add       => save_result_subt_add,
      save_input_from_smp_adjst  => save_input_from_smp_adjst,
      save_first_div             => save_first_div,
      save_input_from_arith_ctrl => save_input_from_arith_ctrl,
      send_output_o              => send_output,

      sample_ok_i_reg      => sample_ok_i_reg,
      ready_divider_mux    => ready_divider_mux,
      ready_arith_ctrl_reg => ready_arith_ctrl_reg,
      start_first_div      => start_first_div,
      start_arith          => start_arith,
      clear_out_reset_n_o  => clear_out_reset_n_o,

      sample_offset_ok     => sample_offset_ok


      ); 


end architecture RTL;
