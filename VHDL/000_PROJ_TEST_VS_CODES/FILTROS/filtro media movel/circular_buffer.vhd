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
-- Description : Mem�ria Circular
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-- Revisions :
-- Date       Version Author Description
-- 2013-08-27 1.0     GDL    Created
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
  type STATE_TYPE is (INIT_ZERO_1, INIT_ZERO_2, START_RST, DECODE_REQ, WRITE_ST, WAIT_READ, READ_ST);

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

  
begin
  
  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      sample_reg     <= (others => '0');
      mem_ptr_reg    <= 0;
      write_ptr_reg  <= 0;
      state_reg      <= INIT_ZERO_1;
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

  main_fsm : process(m_freq_mem, mem_ptr_reg, read_ptr_reg, read_req_i,
                     reading_reg, sample_i, sample_out_reg, sample_reg,
                     state_reg, write_ptr_reg, write_req_i, writing_reg)

  begin
    mem_ptr_next    <= mem_ptr_reg;
    write_ptr_next  <= write_ptr_reg;
    f_write         <= '0';
    state_next      <= state_reg;
    writing_next    <= writing_reg;
    reading_next    <= reading_reg;
    sample_out_next <= sample_out_reg;
    read_ptr_next   <= read_ptr_reg;
    sample_next     <= sample_reg;


    case state_reg is


      --memory clear ---------------------------
      when INIT_ZERO_1 =>
        mem_ptr_next <= MEM_BUFFER_SIZE-1;
        sample_next  <= to_unsigned(0, SAMPLE_SIZE);
        state_next   <= INIT_ZERO_2;
        writing_next <= '1';

      when INIT_ZERO_2 =>

        sample_next <= to_unsigned(0, SAMPLE_SIZE);
        f_write     <= '1';


        if mem_ptr_reg = 0 then
          state_next <= START_RST;
        else
          mem_ptr_next <= mem_ptr_reg - 1;
        end if;
        ----------------------------------------


      when START_RST =>
        writing_next   <= '0';
        mem_ptr_next   <= 0;
        write_ptr_next <= 0;
        read_ptr_next  <= 0;
        state_next     <= DECODE_REQ;

      when DECODE_REQ =>
        

        if write_req_i = '1' then
          state_next   <= WRITE_ST;
          writing_next <= '1';
          -- converte std_logic_vector para unsigned
          sample_next  <= unsigned(sample_i);
          mem_ptr_next <= write_ptr_reg;
          state_next   <= WRITE_ST;
        end if;

        if (read_req_i = '1' and write_req_i = '0') then
          state_next   <= WAIT_READ;
          reading_next <= '1';
          mem_ptr_next <= read_ptr_reg;
        end if;


      when WRITE_ST =>
        f_write <= '1';
        if write_ptr_reg = MEM_BUFFER_SIZE-1 then
          write_ptr_next <= 0;
        else
          write_ptr_next <= write_ptr_reg + 1;
        end if;
        writing_next <= '0';
        state_next   <= DECODE_REQ;

        
      when WAIT_READ =>
        state_next <= READ_ST;
        
        
      when READ_ST =>

        if read_ptr_reg = MEM_BUFFER_SIZE-1 then
          read_ptr_next <= 0;
        else
          read_ptr_next <= read_ptr_reg + 1;
        end if;

        reading_next    <= '0';
        sample_out_next <= m_freq_mem;
        state_next      <= DECODE_REQ;

      when others =>
        state_next <= START_RST;
    end case;
  end process;


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

