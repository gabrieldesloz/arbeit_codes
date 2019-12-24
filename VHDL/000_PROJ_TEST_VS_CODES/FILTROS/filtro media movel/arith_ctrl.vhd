-------------------------------------------------------------------------------
-- Title : Memoria circular
-- Project : Merging Unit - TECO
-- File : circular_buffer.vhd
-- Author : Gabriel Deschamps Lozano
-- Company : Reason Tecnologia S.A.
-- Created : 2013-08-27
-- Last update : 2013-08-27
-- Target Device :
-- Standard : VHDL'93
-------------------------------------------------------------------------------
-- Description : Controlador da memória circular - acumulador
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-- Revisions :
-- Date       Version Author Description
-- 2013-08-27 1.0     GDL    Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity arith_ctrl is

  generic (
    MEM_BUFFER_SIZE : natural := 20;
    SAMPLE_SIZE     : natural := 32;
    ACC_BITS        : natural := 8
    );

  port (

    sysclk           : in  std_logic;
    reset_n          : in  std_logic;
    data_i           : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
    data_o           : out std_logic_vector(SAMPLE_SIZE+ACC_BITS-1 downto 0);
    data_available_i : in  std_logic;
    ready_o          : out std_logic

    );

end arith_ctrl;


architecture arith_ctrl_ARQ of arith_ctrl is

  type STATE_TYPE is (IDLE, WRITE_ST, INIT_READ, READ_CTRL);
  signal state_reg, state_next                   : STATE_TYPE;
  signal data_input_next, data_input_reg         : std_logic_vector(SAMPLE_SIZE-1 downto 0);
  signal data_available_reg, data_available_next : std_logic;


  signal sample_i                            : std_logic_vector(SAMPLE_SIZE-1 downto 0);
  signal sample_o                            : std_logic_vector(SAMPLE_SIZE-1 downto 0);
  signal acc_next, acc_reg                   : signed(SAMPLE_SIZE+ACC_BITS-1 downto 0);
  signal read_counter_reg, read_counter_next : integer range 0 to MEM_BUFFER_SIZE;
  signal read_req_i                          : std_logic;
  signal write_req_i                         : std_logic;
  signal writing_o                           : std_logic;
  signal reading_o                           : std_logic;
  signal do_acc                              : std_logic;
  signal ok_div_next, ok_div_reg             : std_logic;
  signal clear_acc                           : std_logic;



begin

  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      state_reg          <= IDLE;
      data_available_reg <= '0';
      data_input_reg     <= (others => '0');
      read_counter_reg   <= 0;
      acc_reg            <= (others => '0');
      ok_div_reg         <= '0';
    elsif rising_edge(sysclk) then
      ok_div_reg         <= ok_div_next;
      acc_reg            <= acc_next;
      data_input_reg     <= data_input_next;
      data_available_reg <= data_available_next;
      state_reg          <= state_next;
      read_counter_reg   <= read_counter_next;
    end if;
  end process;


  -- registrando as entradas
  -- converte std_logiv_vector para unsigned
  data_available_next <= data_available_i;
  data_input_next     <= data_i;
  ready_o             <= ok_div_reg;
  data_o              <= std_logic_vector(acc_reg);





  main_fsm : process(data_available_reg, data_input_reg, read_counter_reg,
                     reading_o, state_reg)

  begin

    do_acc            <= '0';
    write_req_i       <= '0';
    state_next        <= state_reg;
    sample_i          <= (others => '0');
    read_req_i        <= '0';
    read_counter_next <= read_counter_reg;
    ok_div_next       <= '0';
    clear_acc         <= '0';

    case state_reg is

      when IDLE =>

        if data_available_reg = '1' then
          clear_acc         <= '1';
          sample_i          <= data_input_reg;
          state_next        <= WRITE_ST;
          write_req_i       <= '1';
          read_counter_next <= 0;
        end if;


      when WRITE_ST =>
        state_next <= INIT_READ;


      when INIT_READ =>
        if reading_o = '0' then
          read_req_i <= '1';
          state_next <= READ_CTRL;
        end if;

      when READ_CTRL =>


        if read_counter_reg = MEM_BUFFER_SIZE then
          ok_div_next <= '1';
          state_next  <= IDLE;
        end if;


        if (reading_o = '0') and (read_counter_reg /= MEM_BUFFER_SIZE) then
          read_req_i        <= '1';
          read_counter_next <= read_counter_reg + 1;
          do_acc            <= '1';
        end if;


      when others =>
        state_next <= IDLE;
    end case;
  end process;



  acc : acc_next <= acc_reg + signed(sample_o) when (do_acc = '1') else (others => '0') when clear_acc = '1' else acc_reg;



  circular_buffer_1 : entity work.circular_buffer
    generic map (
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SAMPLE_SIZE     => SAMPLE_SIZE)
    port map (
      sysclk      => sysclk,
      reset_n     => reset_n,
      read_req_i  => read_req_i,
      write_req_i => write_req_i,
      sample_i    => sample_i,
      sample_o    => sample_o,
      writing_o   => writing_o,
      reading_o   => reading_o
      );



end arith_ctrl_ARQ;

