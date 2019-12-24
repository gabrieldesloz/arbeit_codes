-------------------------------------------------------------------------------
-- Title      : Frequency calculation using zero-crossing algorithm 
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : frequency_zero_crossing.vhd
-- Author     : Celso Luis de Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-03-20
-- Last update: 2013-05-07
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:  Frequency algorithm implementation
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-03-20  1.0      CLS     Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rl131_constants_pkg.all;


-- entity declaration
entity frequency_zero_crossing is
  port(
    -- system signals
    sysclk    : in std_logic;
    a_reset_n : in std_logic;

    -- interface signals
    sample_signal_v_i : in std_logic_vector(5 downto 0);
    new_sample_i      : in std_logic;

    -- output signals
    period_o    : out std_logic_vector(95 downto 0);
    period_ok_o : out std_logic_vector(5 downto 0)

    );
end frequency_zero_crossing;


architecture rtl_frequency_zero_crossing of frequency_zero_crossing is
  
  type PERIOD_SUM_ST_TYPE is (ST_PERIOD_SUM_CLEAR_MEMORY_1,
                              ST_PERIOD_SUM_CLEAR_MEMORY_2,
                              ST_PERIOD_SUM_CLEAR_MEMORY_3,
                              ST_PERIOD_SUM_CHECK_PERIOD_OK,
                              ST_PERIOD_SUM_UPDATE,
                              ST_PERIOD_SUM_WRITE,
                              ST_PERIOD_SUM_ACC_1, ST_PERIOD_SUM_ACC_2,
                              ST_PERIOD_SUM_INC_CHANNEL);

  type FREQUENCY_BUFFER_TYPE is array (8*FREQUENCY_BUFFER_SIZE-1 downto 0)
    of unsigned (15 downto 0);
  type PERIOD_BUFFER_TYPE is array (5 downto 0) of unsigned(15 downto 0);
  type COUNTER_SINGLE_PERIOD_BUFFER_TYPE is array (5 downto 0)
    of natural range 0 to (FREQUENCY_BUFFER_SIZE - 1);


  attribute SYN_ENCODING                       : string;
  attribute SYN_ENCODING of PERIOD_SUM_ST_TYPE : type is "safe";




  -- Internal Signals
  signal period_sum_st         : PERIOD_SUM_ST_TYPE;
  signal period_sum_st_next    : PERIOD_SUM_ST_TYPE;
  signal period_buffer_v_reg   : PERIOD_BUFFER_TYPE;
  signal period_buffer_v_next  : PERIOD_BUFFER_TYPE;
  signal single_period_v       : PERIOD_BUFFER_TYPE;
  signal single_period_ok_v    : std_logic_vector(5 downto 0);
  signal period_ok_out_v_reg   : std_logic_vector(5 downto 0);
  signal period_ok_out_v_next  : std_logic_vector(5 downto 0);
  signal period_read_v_reg     : std_logic_vector(5 downto 0);
  signal period_read_v_next    : std_logic_vector(5 downto 0);
  signal flag_period_ok_v_reg  : std_logic_vector(5 downto 0);
  signal flag_period_ok_v_next : std_logic_vector(5 downto 0);



  signal period_sum, period_sum_next : unsigned(15 downto 0);


  signal f_buffer                   : FREQUENCY_BUFFER_TYPE;
  signal f_address_full_rd          : unsigned((F_BUFFER_BITS + 3 - 1) downto 0);
  signal f_address_full_wr          : unsigned((F_BUFFER_BITS + 3 - 1) downto 0);
  signal f_write_reg                : std_logic;
  signal f_write_next               : std_logic;
  signal d_in_reg, d_in_next        : unsigned(15 downto 0);
  signal d_out                      : unsigned(15 downto 0);
  signal channel_unsigned           : unsigned(2 downto 0);
  signal single_period_unsigned     : unsigned((F_BUFFER_BITS - 1) downto 0);
  signal counter_channel_reg        : natural range 0 to 5;
  signal counter_channel_next       : natural range 0 to 5;
  signal counter_single_period_reg  : COUNTER_SINGLE_PERIOD_BUFFER_TYPE;
  signal counter_single_period_next : COUNTER_SINGLE_PERIOD_BUFFER_TYPE;
  signal aux_reg_counter_reg        : natural range 0 to (FREQUENCY_BUFFER_SIZE - 1);
  signal aux_reg_counter_next       : natural range 0 to (FREQUENCY_BUFFER_SIZE - 1);
  signal single_period_memory_nat   : natural range 0 to 65535;
  alias single_period_memory_reg    : unsigned(15 downto 0) is d_in_reg(15 downto 0);
  alias single_period_memory_next   : unsigned(15 downto 0) is d_in_next(15 downto 0);
  alias single_period_memory        : unsigned(15 downto 0) is d_out(15 downto 0);
  
  
  
begin

  -- instances
  GEN_ZERO_CROSSING : for i in 0 to 5 generate
    frequency_zero_crossing_detection_inst : entity work.frequency_zero_crossing_detection
      port map (
        sysclk                      => sysclk,
        a_reset_n                   => a_reset_n,
        sample_signal_i             => sample_signal_v_i(i),
        new_sample_i                => new_sample_i,
        unsigned(single_period_v_o) => single_period_v(i),
        single_period_ok_o          => single_period_ok_v(i),
        period_read_i               => period_read_v_reg(i));                  
  end generate GEN_ZERO_CROSSING;


  period_ok_o            <= period_ok_out_v_reg;
  -- converts natural to unsigned
  channel_unsigned       <= TO_UNSIGNED(counter_channel_reg, 3);
  single_period_unsigned <= TO_UNSIGNED(counter_single_period_reg(counter_channel_reg), F_BUFFER_BITS);

  -- converts unsigned to natural

  f_address_full_rd <= (channel_unsigned & single_period_unsigned);
  f_address_full_wr <= (channel_unsigned & single_period_unsigned);


  -- convert period buffer to array
  process (period_buffer_v_reg) is
  begin
    for i in 0 to 5 loop
      period_o(((i+1)*16 - 1) downto i*16) <= std_logic_vector(period_buffer_v_reg(i));
    end loop;
  end process;


  -- checks if periods are ok
  process (a_reset_n, sysclk) is
  begin
    if (a_reset_n = '0') then
      for i in 0 to 5 loop
        period_buffer_v_reg(i)       <= (others => '0');
        counter_single_period_reg(i) <= 0;
      end loop;
      period_sum_st        <= ST_PERIOD_SUM_CLEAR_MEMORY_1;
      period_sum           <= (others => '0');
      counter_channel_reg  <= 0;
      period_read_v_reg    <= (others => '0');
      period_ok_out_v_reg  <= (others => '0');
      d_in_reg             <= (others => '0');
      f_write_reg          <= '0';
      aux_reg_counter_reg  <= 0;
      flag_period_ok_v_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      period_buffer_v_reg       <= period_buffer_v_next;
      period_sum_st             <= period_sum_st_next;
      period_sum                <= period_sum_next;
      counter_channel_reg       <= counter_channel_next;
      counter_single_period_reg <= counter_single_period_next;
      period_read_v_reg         <= period_read_v_next;
      period_ok_out_v_reg       <= period_ok_out_v_next;
      d_in_reg                  <= d_in_next;
      f_write_reg               <= f_write_next;
      aux_reg_counter_reg       <= aux_reg_counter_next;
      flag_period_ok_v_reg      <= flag_period_ok_v_next;
    end if;
  end process;

  process (counter_channel_reg, counter_single_period_reg, d_in_reg,
           period_buffer_v_reg, period_ok_out_v_reg,
           period_read_v_reg, period_sum, period_sum_st,
           single_period_v, single_period_ok_v, aux_reg_counter_reg,
           flag_period_ok_v_reg) is
  begin
    period_buffer_v_next       <= period_buffer_v_reg;
    period_sum_st_next         <= period_sum_st;
    period_sum_next            <= period_sum;
    counter_channel_next       <= counter_channel_reg;
    counter_single_period_next <= counter_single_period_reg;
    period_read_v_next         <= period_read_v_reg;
    period_ok_out_v_next       <= (others => '0');
    d_in_next                  <= d_in_reg;
    aux_reg_counter_next       <= aux_reg_counter_reg;
    f_write_next               <= '0';
    flag_period_ok_v_next      <= flag_period_ok_v_reg;

    case period_sum_st is
      
      when ST_PERIOD_SUM_CLEAR_MEMORY_1 =>
        d_in_next          <= (others => '0');
        f_write_next       <= '1';
        period_sum_st_next <= ST_PERIOD_SUM_CLEAR_MEMORY_2;
        
      when ST_PERIOD_SUM_CLEAR_MEMORY_2 =>
        period_sum_st_next <= ST_PERIOD_SUM_CLEAR_MEMORY_3;
        
      when ST_PERIOD_SUM_CLEAR_MEMORY_3 =>
        period_sum_st_next <= ST_PERIOD_SUM_CLEAR_MEMORY_1;
        if counter_single_period_reg(counter_channel_reg) < (FREQUENCY_BUFFER_SIZE - 1) then
          counter_single_period_next(counter_channel_reg) <= counter_single_period_reg(counter_channel_reg) + 1;
        else
          counter_single_period_next(counter_channel_reg) <= 0;
          if (counter_channel_reg < 5) then
            counter_channel_next <= counter_channel_reg + 1;
          else
            counter_channel_next <= 0;
            period_sum_st_next   <= ST_PERIOD_SUM_CHECK_PERIOD_OK;
          end if;
        end if;
        

      when ST_PERIOD_SUM_CHECK_PERIOD_OK =>
        if (single_period_ok_v(counter_channel_reg) = '1') then
          period_sum_st_next <= ST_PERIOD_SUM_UPDATE;
        else
          period_sum_st_next <= ST_PERIOD_SUM_INC_CHANNEL;
        end if;

      when ST_PERIOD_SUM_UPDATE =>
        period_read_v_next(counter_channel_reg) <= '1';
        if (counter_single_period_reg(counter_channel_reg) = (FREQUENCY_BUFFER_SIZE - 1)) then
          counter_single_period_next(counter_channel_reg) <= 0;
          flag_period_ok_v_next(counter_channel_reg)      <= '1';
        else
          counter_single_period_next(counter_channel_reg) <= counter_single_period_reg(counter_channel_reg) + 1;
        end if;
        single_period_memory_next <= single_period_v(counter_channel_reg);
        f_write_next              <= '1';
        period_sum_st_next        <= ST_PERIOD_SUM_WRITE;  -- tem que garantir o fim de single_period_ok_v...
        
      when ST_PERIOD_SUM_WRITE =>
        period_read_v_next(counter_channel_reg)         <= '0';
        period_buffer_v_next(counter_channel_reg)       <= (others => '0');
        aux_reg_counter_next                            <= counter_single_period_reg(counter_channel_reg);
        counter_single_period_next(counter_channel_reg) <= 0;
        period_sum_st_next                              <= ST_PERIOD_SUM_ACC_1;

        
      when ST_PERIOD_SUM_ACC_1 =>
        period_buffer_v_next(counter_channel_reg) <= period_buffer_v_reg(counter_channel_reg) + single_period_memory;
        if (flag_period_ok_v_reg(counter_channel_reg) = '1') then
          period_ok_out_v_next(counter_channel_reg) <= '1';
        end if;
        if (counter_single_period_reg(counter_channel_reg) = (FREQUENCY_BUFFER_SIZE - 1)) then
          counter_single_period_next(counter_channel_reg) <= aux_reg_counter_reg;
          period_sum_st_next                              <= ST_PERIOD_SUM_INC_CHANNEL;
        else
          counter_single_period_next(counter_channel_reg) <= counter_single_period_reg(counter_channel_reg) + 1;
          period_sum_st_next                              <= ST_PERIOD_SUM_ACC_2;
        end if;

      when ST_PERIOD_SUM_ACC_2 =>
        period_sum_st_next <= ST_PERIOD_SUM_ACC_1;
        
      when ST_PERIOD_SUM_INC_CHANNEL =>
        if (counter_channel_reg = 5) then
          counter_channel_next <= 0;
        else
          counter_channel_next <= counter_channel_reg + 1;
        end if;
        period_sum_st_next <= ST_PERIOD_SUM_CHECK_PERIOD_OK;
        
        
      when others =>
        period_sum_st_next <= ST_PERIOD_SUM_CLEAR_MEMORY_1;
    end case;
  end process;


  --* --------------------------------------------------------------------------------------------------------------------------------------
--* Dual-Port RAM generation
--* Generate the simple dual-port RAM
--* Input      : f_address_wr, f_address_rd, period_counter, f_write
--* Output     : d_out
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (f_write_reg = '1') then
        f_buffer(TO_INTEGER(f_address_full_wr)) <= d_in_reg;
      end if;
      d_out <= f_buffer(TO_INTEGER(f_address_full_rd));
    end if;
  end process;



end rtl_frequency_zero_crossing;

