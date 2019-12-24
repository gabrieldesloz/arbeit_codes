-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : get irig ram
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : get_irig_data.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2012-09-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  gets irig codes and generates t-mark
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;

entity get_irig_data is
  port (
    sysclk     : in  std_logic;                      -- system clock
    n_reset    : in  std_logic;                      -- system reset
    irig       : in  std_logic;                      -- irig-b signal
    t_mark     : out std_logic;                      -- one pulse per second
    irig_ready : out std_logic;                      -- new irig data is ready
    irig_data  : out std_logic_vector(223 downto 0)  -- irig data   
    );
end get_irig_data;

------------------------------------------------------------------------------

architecture get_irig_data_RTL of get_irig_data is

-- Type declarations



  type DECODE_IRIG_STATE_TYPE is (RESET_DECODE_IRIG_STATE,
                                  WAIT_FIRST_TMARK_STATE,
                                  WAIT_ACK_STATE,
                                  READ_IRIG_BITS_STATE,
                                  WAIT_NEXT_TMARK_STATE,
                                  D1, D2, D3
                                  );
  attribute ENUM_ENCODING                           : string;
  attribute ENUM_ENCODING of DECODE_IRIG_STATE_TYPE : type is "000 001 010 011 100 101 110 111";
  

  type READ_CODES_STATE_TYPE is (WAIT_START_STATE,
                                 READ_PULSES_STATE
                                 );

  attribute ENUM_ENCODING of READ_CODES_STATE_TYPE : type is "0 1";

  type RAM is array (integer range <>) of std_logic_vector (2 downto 0);

-- constant declarations


-- Local (internal to the model) signals declarations.
  signal decode_irig_state     : DECODE_IRIG_STATE_TYPE;
  signal code_counter          : natural range 0 to 99;
  signal code_counter_next     : natural range 0 to 99;
  signal read_codes_state      : READ_CODES_STATE_TYPE;
  signal read_codes_state_next : READ_CODES_STATE_TYPE;
  signal irig_store_reg        : RAM(99 downto 0);
  signal irig_store_next       : RAM(99 downto 0);
  signal irig_ready_reg        : std_logic;
  signal irig_ready_next       : std_logic;

  signal t_mark_int       : std_logic;
  signal new_pulse        : std_logic;
  signal pulse_code       : std_logic_vector (1 downto 0);
  signal start_read_codes : std_logic;


-- Component declarations



begin

-- Component instantiations
  irig_pulse_decoder_inst : entity work.irig_pulse_decoder
    port map(
      sysclk     => sysclk,
      n_reset    => n_reset,
      irig       => irig,
      pps        => t_mark_int,
      new_pulse  => new_pulse,
      pulse_code => pulse_code
      );


-- concurrent signal assignment statements
  t_mark     <= t_mark_int;
  irig_ready <= irig_ready_reg;

  -- Processes

  -- generates start_read_codes signal
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then             -- reset all counters and controls
      decode_irig_state <= RESET_DECODE_IRIG_STATE;
      start_read_codes  <= '0';
    elsif rising_edge(sysclk) then
      case (decode_irig_state) is

        when RESET_DECODE_IRIG_STATE =>
          if (n_reset = '1') then
            decode_irig_state <= WAIT_FIRST_TMARK_STATE;
          end if;
        when WAIT_FIRST_TMARK_STATE =>    -- wait 1st PPS to start reading bits          
          if (t_mark_int = '1') then
            decode_irig_state <= READ_IRIG_BITS_STATE;
          end if;
        when READ_IRIG_BITS_STATE =>
          start_read_codes <= '0';
          if (t_mark_int = '0') then
            decode_irig_state <= WAIT_NEXT_TMARK_STATE;
          end if;
        when WAIT_NEXT_TMARK_STATE =>
          if (t_mark_int = '1') then
            start_read_codes  <= '1';   -- start reading bits;
            decode_irig_state <= READ_IRIG_BITS_STATE;
          end if;
        when others =>
          decode_irig_state <= RESET_DECODE_IRIG_STATE;
      end case;
    end if;
  end process;




-- read irig codes and put then on a record
  process (n_reset, sysclk) is
  begin  -- process
    if (n_reset = '0') then
      read_codes_state <= WAIT_START_STATE;
      code_counter     <= 0;
      for i in 0 to 99 loop
        irig_store_reg(i) <= (others => '0');
      end loop;
      irig_ready_reg <= '0';
    elsif rising_edge(sysclk) then
      read_codes_state <= read_codes_state_next;
      code_counter     <= code_counter_next;
      irig_store_reg   <= irig_store_next;
      irig_ready_reg   <= irig_ready_next;
    end if;
  end process;

  process (code_counter, irig_ready_reg, irig_store_reg, new_pulse, pulse_code,
           read_codes_state, start_read_codes) is
  begin
    read_codes_state_next <= read_codes_state;
    code_counter_next     <= code_counter;
    irig_store_next       <= irig_store_reg;
    irig_ready_next       <= irig_ready_reg;
    case read_codes_state is
      when WAIT_START_STATE =>
        code_counter_next <= 0;
        if (start_read_codes = '1') then
          irig_ready_next       <= '0';
          read_codes_state_next <= READ_PULSES_STATE;
        end if;

      when READ_PULSES_STATE =>
        if (new_pulse = '1') then
          irig_store_next(code_counter) <= pulse_code;
          if (code_counter = 99) then
            irig_ready_next       <= '1';
            read_codes_state_next <= WAIT_START_STATE;
          else
            code_counter_next <= code_counter + 1;
          end if;
        end if;
        
      when others => null;
    end case;
  end process;


  -- transfer data from record to vector
  process (irig_store_reg) is
  begin  -- process
    for i in 0 to 99 loop
      irig_data(2*i)     <= irig_store_reg(i)(0);
      irig_data(2*i + 1) <= irig_store_reg(i)(1);
    end loop;
  end process;
  irig_data(223 downto 200) <= (others => '1');
  
end get_irig_data_RTL;


--eof $Id: get_irig_data.vhd 4667 2009-07-21 13:15:07Z cls $
