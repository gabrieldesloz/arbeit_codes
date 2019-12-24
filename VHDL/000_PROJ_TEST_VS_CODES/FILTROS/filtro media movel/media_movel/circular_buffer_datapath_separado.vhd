-------------------------------------------------------------------------------
-- Title : Frequency calculation using zero-crossing algorithm
-- Project : protective relay
-- File : frequency_zero_crossing.vhd
-- Author : Celso Luis de Souza
-- Company : Reason Tecnologia S.A.
-- Created : 2012-03-20
-- Last update : 2013-04-30
-- Target Device :
-- Standard : VHDL'93
-------------------------------------------------------------------------------
-- Description : Frequency algorithm implementation
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-- Revisions :
-- Date Version Author Description
-- 2013-03-20 1.0 CLS Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circular_buffer is
  
  generic (
    MEM_BUFFER_SIZE : natural := 20;
    SAMPLE_SIZE     : natural := 32
    ); 

  port (

    sysclk      : in  std_logic;
    reset_n     : in  std_logic;
    read_req_i  : in  std_logic;
    write_req_i : in  std_logic;
    sample_i    : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
    sample_o    : out std_logic_vector(SAMPLE_SIZE-1 downto 0);
    writing_o   : out std_logic;
    reading_o   : out std_logic

    );

end circular_buffer;


architecture circular_buffer_ARQ of circular_buffer is


  type MEM_BUFFER is array (0 to MEM_BUFFER_SIZE-1) of unsigned(SAMPLE_SIZE-1 downto 0);
  type STATE_TYPE is (START_RST, DECODE_REQ, WRITE_ST, WAIT_READ, READ_ST);

  signal m_freq_buffer                 : MEM_BUFFER;
  attribute syn_encoding               : string;
  attribute syn_encoding of STATE_TYPE : type is "safe";

  signal state_reg, state_next           : STATE_TYPE;
  signal write_ptr_next                  : natural range 0 to MEM_BUFFER_SIZE-1;
  signal write_ptr_reg                   : natural range 0 to MEM_BUFFER_SIZE-1;
  signal read_ptr_next                   : natural range 0 to MEM_BUFFER_SIZE-1;
  signal read_ptr_reg                    : natural range 0 to MEM_BUFFER_SIZE-1;
  signal mem_ptr_reg                     : natural range 0 to MEM_BUFFER_SIZE-1;
  signal mem_ptr_next                    : natural range 0 to MEM_BUFFER_SIZE-1;
  signal f_write                         : std_logic;
  signal sample_next, sample_reg         : unsigned(SAMPLE_SIZE-1 downto 0);
  signal sample_out_next, sample_out_reg : unsigned(SAMPLE_SIZE-1 downto 0);
  signal m_freq_mem                      : unsigned(SAMPLE_SIZE-1 downto 0);
  signal writing_reg, writing_next       : std_logic;
  signal reading_reg, reading_next       : std_logic;
  signal read_ptr_count, clear_rd_ptr    : std_logic;
  signal write_ptr_count, clear_wr_ptr   : std_logic;
  signal clear_mem_ptr                   : std_logic;
  signal load_wr_ptr                     : std_logic;
  signal load_rd_ptr                     : std_logic;

  
begin
  
  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      sample_reg     <= (others => '0');
      mem_ptr_reg    <= 0;
      write_ptr_reg  <= 0;
      state_reg      <= START_RST;
      writing_reg    <= '0';
      reading_reg    <= '0';
      sample_out_reg <= (others => '0');
      read_ptr_reg   <= 0;
    elsif rising_edge(sysclk) then
      read_ptr_reg   <= read_ptr_next;
      sample_out_reg <= sample_out_next;
      writing_reg    <= writing_next;
      reading_reg    <= reading_next;
      sample_reg     <= sample_next;
      mem_ptr_reg    <= mem_ptr_next;
      write_ptr_reg  <= write_ptr_next;
      state_reg      <= state_next;
    end if;
  end process;

  -- converte unsigned para std_logic_vector
  sample_o  <= std_logic_vector(sample_out_reg);
  writing_o <= writing_reg;
  reading_o <= reading_reg;



  -- control path
  
  main_fsm : process(m_freq_mem, read_ptr_reg, read_req_i, reading_reg,
                     sample_i, sample_out_reg, sample_reg, state_reg,
                     write_ptr_reg, write_req_i, writing_reg)

  begin
    f_write         <= '0';
    state_next      <= state_reg;
    writing_next    <= writing_reg;
    reading_next    <= reading_reg;
    sample_out_next <= sample_out_reg;
    sample_next     <= sample_reg;

    clear_mem_ptr <= '0';
    clear_wr_ptr  <= '0';
    clear_rd_ptr  <= '0';
    load_wr_ptr   <= '0';
    load_rd_ptr   <= '0';

    case state_reg is

      when START_RST =>
        clear_mem_ptr <= '1';
        clear_wr_ptr  <= '1';
        clear_rd_ptr  <= '1';
        state_next    <= DECODE_REQ;

      when DECODE_REQ =>
        
        

        if write_req_i = '1' then
          state_next   <= WRITE_ST;
          writing_next <= '1';
          -- converte std_logic_vector para unsigned
          sample_next  <= unsigned(sample_i);
          load_wr_ptr  <= '1';
          state_next   <= WRITE_ST;
        end if;

        if (read_req_i = '1' and write_req_i = '0') then
          state_next   <= WAIT_READ;
          reading_next <= '1';
          load_rd_ptr  <= '1';
        end if;


      when WRITE_ST =>
        f_write <= '1';
        if write_ptr_reg = MEM_BUFFER_SIZE-1 then
          clear_wr_ptr <= '1';
        else
          write_ptr_count <= '1';
        end if;
        writing_next <= '0';
        state_next   <= DECODE_REQ;

        
      when WAIT_READ =>
        state_next <= READ_ST;
        
        
      when READ_ST =>

        if read_ptr_reg = MEM_BUFFER_SIZE-1 then
          clear_rd_ptr <= '1';
        else
          read_ptr_count <= '1';
        end if;

        reading_next    <= '0';
        sample_out_next <= m_freq_mem;
        state_next      <= DECODE_REQ;

      when others =>
        state_next <= START_RST;
    end case;
  end process;


  -- datapath

  reader_pointer_counter : read_ptr_next  <= (read_ptr_reg + 1)  when (read_ptr_count = '1')  else 0 when (clear_rd_ptr = '1') else read_ptr_reg;
  writer_pointer_counter : write_ptr_next <= (write_ptr_reg + 1) when (write_ptr_count = '1') else 0 when (clear_wr_ptr = '1') else write_ptr_reg;
  mem_pointer_ctrl       : mem_ptr_next   <= write_ptr_reg       when (load_wr_ptr = '1')     else read_ptr_reg when (load_rd_ptr = '1') else 0 when (clear_mem_ptr = '1') else mem_ptr_reg;




  -- infere memoria da altera 
  memory_process : process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (f_write = '1') then
        m_freq_buffer(mem_ptr_reg) <= sample_reg;
      end if;
      m_freq_mem <= m_freq_buffer(mem_ptr_reg);
    end if;
  end process;



end circular_buffer_ARQ;

