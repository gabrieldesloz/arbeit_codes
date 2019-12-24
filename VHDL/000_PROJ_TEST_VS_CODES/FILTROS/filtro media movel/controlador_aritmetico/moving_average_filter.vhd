library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity moving_average_filter is
  
  generic (
    F               : natural;
    MEM_BUFFER_SIZE : natural
    ); 

  port (

    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    m_freq_in         : in  std_logic_vector(F-1 downto 0);
    m_freq_out        : out std_logic_vector(F-1 downto 0);
    CLK_FREQUENCY_STD : in  std_logic_vector(F-1 downto 0);
    pps_edge          : in  std_logic

    );
end moving_average_filter;


architecture moving_average_ARQ of moving_average_filter is

  constant sum_expand : natural := 10;
  constant wait_time  : natural := 5;

  type FREQUENCY_BUFFER is array (0 to MEM_BUFFER_SIZE-1) of unsigned(F-1 downto 0);
  type STATE_TYPE_M_FREQ is (INIT_ZERO_1,
                             INIT_ZERO_2,
                             INIT_WRITE_MEM,
                             WAIT_RD_MEM,
                             WRITE_MEM,
                             SAVE_POINTER,
                             READ_SUM,
                             WAIT_RD,
                             LOAD_POINTER,
                             DO_AVG,
                             SAVE_AVG);

  attribute syn_encoding                      : string;
  attribute syn_encoding of STATE_TYPE_M_FREQ : type is "safe";

  signal m_freq_buffer                           : FREQUENCY_BUFFER;
  signal f_write_next, f_write_reg               : std_logic;
  signal m_freq_mem                              : unsigned(F-1 downto 0);
  signal m_freq_out_next, m_freq_out_reg         : unsigned(F-1 downto 0);
  signal median_average_next, median_average_reg : unsigned(F-1 downto 0);
  signal m_freq_in_int_next, m_freq_in_int_reg   : unsigned(F-1 downto 0);
  signal sum_next, sum_reg                       : unsigned(F+sum_expand downto 0);
  signal count_wait_reg, count_wait_next         : natural range 0 to wait_time;
  signal do_avg_reg, do_avg_next                 : std_logic;


  signal state_reg, state_next  : STATE_TYPE_M_FREQ;
  signal write_mem_pointer_next : natural range 0 to MEM_BUFFER_SIZE-1;
  signal write_mem_pointer_reg  : natural range 0 to MEM_BUFFER_SIZE-1;
  signal mem_pointer_next       : natural range 0 to MEM_BUFFER_SIZE-1;
  signal mem_pointer_reg        : natural range 0 to MEM_BUFFER_SIZE-1;

  
begin
  
  process (n_reset, sysclk, CLK_FREQUENCY_STD) is
  begin
    if (n_reset = '0') then
      sum_reg               <= (others => '0');
      state_reg             <= INIT_ZERO_1;
      m_freq_out_reg        <= unsigned(CLK_FREQUENCY_STD);
      m_freq_in_int_reg     <= (others => '0');
      median_average_reg    <= (others => '0');
      f_write_reg           <= '0';
      mem_pointer_reg       <= 0;
      write_mem_pointer_reg <= 0;
      count_wait_reg        <= 0;
      do_avg_reg            <= '0';
      
    elsif rising_edge(sysclk) then
      do_avg_reg            <= do_avg_next;
      median_average_reg    <= median_average_next;
      count_wait_reg        <= count_wait_next;
      sum_reg               <= sum_next;
      m_freq_in_int_reg     <= m_freq_in_int_next;
      state_reg             <= state_next;
      m_freq_out_reg        <= m_freq_out_next;
      mem_pointer_reg       <= mem_pointer_next;
      f_write_reg           <= f_write_next;
      write_mem_pointer_reg <= write_mem_pointer_next;
    end if;
  end process;

  m_freq_out <= std_logic_vector(m_freq_out_reg);

  process(
    count_wait_reg,
    m_freq_in,
    m_freq_in_int_reg,
    m_freq_mem,
    m_freq_out_reg,
    mem_pointer_reg,
    pps_edge,
    state_reg,
    sum_reg,
    write_mem_pointer_reg,
    do_avg_reg,
    median_average_reg
    )


  begin

    m_freq_in_int_next     <= m_freq_in_int_reg;
    mem_pointer_next       <= mem_pointer_reg;
    f_write_next           <= '0';
    state_next             <= state_reg;
    m_freq_out_next        <= m_freq_out_reg;
    write_mem_pointer_next <= write_mem_pointer_reg;
    count_wait_next        <= count_wait_reg;
    sum_next               <= sum_reg;
    do_avg_next            <= '0';


    case state_reg is


      --memory clear ---------------------------
      when INIT_ZERO_1 =>
        mem_pointer_next   <= MEM_BUFFER_SIZE-1;
        m_freq_in_int_next <= to_unsigned(0, F);
        f_write_next       <= '1';
        state_next         <= INIT_ZERO_2;


      when INIT_ZERO_2 =>
        f_write_next <= '1';

        if mem_pointer_reg = 0 then
          m_freq_in_int_next <= to_unsigned(0, F);
          state_next         <= INIT_WRITE_MEM;
        else
          mem_pointer_next <= mem_pointer_reg - 1;
        end if;
        ----------------------------------------
        
        
      when INIT_WRITE_MEM =>

        
        if pps_edge = '1' then
          f_write_next       <= '1';
          m_freq_in_int_next <= unsigned(m_freq_in);
          mem_pointer_next   <= MEM_BUFFER_SIZE-1;
          state_next         <= WRITE_MEM;
        end if;

        
      when WRITE_MEM =>
        
        if pps_edge = '1' then
          f_write_next       <= '1';
          state_next         <= SAVE_POINTER;
          m_freq_in_int_next <= unsigned(m_freq_in);

          if (mem_pointer_reg = 0) then
            mem_pointer_next <= MEM_BUFFER_SIZE-1;
          else
            mem_pointer_next <= mem_pointer_reg - 1;
          end if;
        end if;
        
      when SAVE_POINTER =>


        ---delay-------------------------------
        if count_wait_reg = 1 then

          -- salva e limpa ponteiro       

          write_mem_pointer_next <= mem_pointer_reg;
          mem_pointer_next       <= MEM_BUFFER_SIZE-1;


          state_next      <= WAIT_RD_MEM;
          count_wait_next <= 0;
        else
          count_wait_next <= count_wait_reg + 1;
        end if;
        ---------------------------------------


      when WAIT_RD_MEM =>
        state_next <= READ_SUM;
        
        
      when READ_SUM =>

        sum_next <= sum_reg + m_freq_mem;


        if (mem_pointer_reg = 0) then
          state_next       <= LOAD_POINTER;
          mem_pointer_next <= mem_pointer_reg;
        else
          state_next       <= WAIT_RD_MEM;
          mem_pointer_next <= mem_pointer_reg - 1;
        end if;

        
      when LOAD_POINTER =>
        
        do_avg_next      <= '1';
        mem_pointer_next <= write_mem_pointer_reg;
        state_next       <= DO_AVG;

      when DO_AVG =>
        sum_next   <= (others => '0');
        state_next <= SAVE_AVG;

      when SAVE_AVG =>
        m_freq_out_next <= median_average_reg;
        state_next      <= WRITE_MEM;


      when others =>
        state_next <= WRITE_MEM;
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
        m_freq_buffer(mem_pointer_reg) <= m_freq_in_int_reg;
      end if;
      m_freq_mem <= m_freq_buffer(mem_pointer_reg);
    end if;
  end process;



------------------------------------------------------------------------------
-- valor medio
-------------------------------------------------------------------------------

  -- divisao 
  median_average_next <= resize((sum_reg srl 4), median_average_reg'length) when (do_avg_reg = '1') else median_average_reg;



  
end moving_average_ARQ;

