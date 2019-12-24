-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : irig pulse decoder
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : irig_pulse_decoder.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2012-07-27
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:    decodes an irig pulse
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses

library ieee;
use ieee.STD_LOGIC_1164.all;

library work;
use work.mu320_constants.all;

entity irig_pulse_decoder is
  port (
    sysclk     : in  std_logic;
    n_reset    : in  std_logic;
    irig       : in  std_logic;         -- irig signal
    pps        : out std_logic;         -- 1 pulse per second
    new_pulse  : out std_logic;         -- signalizes a new pulse
    pulse_code : out std_logic_vector (1 downto 0)  --(00 - "0", 01 - "1", 10 - "P")
    );
end irig_pulse_decoder;
------------------------------------------------------------
architecture irig_pulse_decoder_RTL of irig_pulse_decoder is

-- Type declarations

  type IRIG_PULSE_STATE_TYPE is (RESET_IRIG_PULSE_STATE,
                                 WAIT_POS_EDGE_STATE,
                                 WAIT_NEG_EDGE_STATE,
                                 SIGNALIZE_PULSE_STATE
                                 );

  attribute ENUM_ENCODING                          : string;
  attribute ENUM_ENCODING of IRIG_PULSE_STATE_TYPE : type is "00 01 10 11";

  -- Constant declarations

  constant TEN_MS       : integer := CLK_FREQUENCY_MHZ * 10000;    -- 10 ms
  constant ZERO_L       : integer := CLK_FREQUENCY_MHZ * 1800;     -- 1.8 ms
  constant ZERO_U       : integer := CLK_FREQUENCY_MHZ * 2200;     -- 2.2 ms
  constant ONE_L        : integer := CLK_FREQUENCY_MHZ * 4800;     -- 4.8 ms
  constant ONE_U        : integer := CLK_FREQUENCY_MHZ * 5200;     -- 5.2 ms
  constant P_REF_L      : integer := CLK_FREQUENCY_MHZ * 7800;     -- 7.8 ms
  constant P_REF_U      : integer := CLK_FREQUENCY_MHZ * 8200;     -- 8.2 ms
  constant EIGHT_HUN_MS : integer := CLK_FREQUENCY_MHZ * 899999;   -- 870 ms
  constant ONE_SECOND   : integer := CLK_FREQUENCY_MHZ * 1000000;  -- 1 s


-- Local (internal to the model) signals declarations.

  signal irig_pulse_state  : IRIG_PULSE_STATE_TYPE;
  signal old_irig          : std_logic;
  signal irig_counter      : integer range 0 to (TEN_MS - 1);
  signal pps_counter       : integer range 0 to (ONE_SECOND - 1);
  signal new_pulse_int     : std_logic;
  signal p_counter         : integer range 0 to 2;
  signal start_pps_counter : std_logic;
  signal irig_int          : std_logic;
  signal pps_int           : std_logic;
  signal flag_start        : std_logic;


-- Component declarations

begin

-- concurrent signal assignment statements
  new_pulse <= (new_pulse_int and flag_start);
  pps       <= pps_int;

-- Processes

  sync_irig : process (sysclk)
  begin
    if rising_edge (sysclk) then
      irig_int <= irig;
    end if;
  end process sync_irig;



  pulse_decode : process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      new_pulse_int    <= '0';
      irig_counter     <= 0;
      pulse_code       <= "11";
      p_counter        <= 0;
      pps_int          <= '0';
      flag_start       <= '0';
      irig_pulse_state <= RESET_IRIG_PULSE_STATE;
    elsif rising_edge (sysclk) then
      case (irig_pulse_state) is
        when RESET_IRIG_PULSE_STATE =>
          old_irig <= irig_int;
          if (n_reset = '1') then
            flag_start       <= '0';
            irig_pulse_state <= WAIT_POS_EDGE_STATE;
          end if;
        when WAIT_POS_EDGE_STATE =>
          irig_counter  <= 0;
          new_pulse_int <= '0';
          if (old_irig /= irig_int) then
            old_irig <= irig_int;
            if (irig_int = '1') then
              if ((pps_counter > EIGHT_HUN_MS) and (p_counter = 1)) then
                pps_int    <= '1';
                flag_start <= '1';
              else
                flag_start <= flag_start;
                pps_int    <= '0';
              end if;
              irig_pulse_state <= WAIT_NEG_EDGE_STATE;
              if (p_counter = 2) then
                start_pps_counter <= '1';
              else
                start_pps_counter <= '0';
              end if;
            end if;
          end if;
        when WAIT_NEG_EDGE_STATE =>
          start_pps_counter <= '0';
          irig_counter      <= irig_counter + 1;
          if ((old_irig /= irig_int) and (irig_int = '0')) then
            old_irig         <= irig_int;
            irig_pulse_state <= SIGNALIZE_PULSE_STATE;
            new_pulse_int    <= '1';
            if ((irig_counter < ZERO_U) and (irig_counter > ZERO_L)) then
              pulse_code <= "00";
              p_counter  <= 0;
            elsif ((irig_counter < ONE_U) and (irig_counter > ONE_L)) then
              pulse_code <= "01";
              p_counter  <= 0;
            elsif ((irig_counter < P_REF_U) and (irig_counter > P_REF_L)) then
              pulse_code <= "10";
              p_counter  <= p_counter + 1;
            else
              pulse_code <= "11";
              p_counter  <= 0;
            end if;
          end if;
        when SIGNALIZE_PULSE_STATE =>
          new_pulse_int    <= '0';
          irig_pulse_state <= WAIT_POS_EDGE_STATE;

      end case;

    end if;
  end process pulse_decode;


  pps_counter_proc : process (n_reset, start_pps_counter, sysclk)
  begin
    if (n_reset = '0' or start_pps_counter = '1') then
      pps_counter <= 0;
    elsif rising_edge (sysclk) then
      if (pps_counter = (ONE_SECOND - 1)) then
        pps_counter <= 0;
      else
        pps_counter <= pps_counter + 1;
      end if;
    end if;
  end process pps_counter_proc;



end irig_pulse_decoder_RTL;

--eof $Id: irig_pulse_decoder.vhd 4687 2009-07-29 12:27:03Z cls $
