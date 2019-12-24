-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : dig_goose_processor.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-23
-- Last update: 2012-08-29
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-23  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mu320_constants.all;



entity dig_goose_processor is
  
  generic (
    ERROR_LENGTH : natural := 1);

  port (
    reset_n : in std_logic;
    sysclk  : in std_logic;
    clk     : in std_logic;

    address    : in std_logic_vector(7 downto 0);
    byteenable : in std_logic_vector(3 downto 0);
    writedata  : in std_logic_vector(31 downto 0);
    write      : in std_logic;
    chipselect : in std_logic;

    source_ready : in  std_logic;
    source_valid : out std_logic;
    source_data  : out std_logic_vector(31 downto 0);
    source_empty : out std_logic_vector(1 downto 0);
    source_sop   : out std_logic;
    source_eop   : out std_logic;
    source_err   : out std_logic_vector((ERROR_LENGTH - 1) downto 0);

    digital_in : in std_logic_vector(15 downto 0);

    pps : in std_logic
    );

end dig_goose_processor;


architecture dig_goose_processor_struct of dig_goose_processor is

  type DIG_GOOSE_PROC_TYPE is (WAIT_TRANSFER_GO, INCREMENT, VERIFY, FINISH);
  type GOOSE_TIMING_TYPE is (INCREMENT, VERIFY_PPS, VERIFY_MILI, VERIFY_TIME);


  attribute ENUM_ENCODING                        : string;
  attribute ENUM_ENCODING of DIG_GOOSE_PROC_TYPE : type is "00 01 10 11";
  attribute ENUM_ENCODING of GOOSE_TIMING_TYPE   : type is "00 01 10 11";

  signal goose_timing_state      : GOOSE_TIMING_TYPE;
  signal goose_timing_state_next : GOOSE_TIMING_TYPE;

  signal timestamp_second_counter      : natural range 0 to ONE_SECOND + 100;
  signal timestamp_second_counter_next : natural range 0 to ONE_SECOND + 100;
  signal timestamp_mili_counter        : natural range 0 to MILI_SECOND + 100;
  signal timestamp_mili_counter_next   : natural range 0 to MILI_SECOND + 100;
  signal timestamp_high_part_reg       : natural range 0 to ONE_SECOND + 100;
  signal timestamp_high_part_reg_next  : natural range 0 to ONE_SECOND + 100;
  signal timestamp_low_part_reg        : natural range 0 to ONE_SECOND + 100;
  signal timestamp_low_part_reg_next   : natural range 0 to ONE_SECOND + 100;
  signal sixty_nano_counter            : std_logic_vector(2 downto 0);
  signal sixty_nano_counter_next       : std_logic_vector(2 downto 0);
  signal mili_counter                  : std_logic_vector(15 downto 0);
  signal mili_counter_next             : std_logic_vector(15 downto 0);
  signal t1_temp                       : std_logic_vector(15 downto 0);
  signal t1_temp_next                  : std_logic_vector(15 downto 0);
  signal t0                            : std_logic_vector(15 downto 0);
  signal t1                            : std_logic_vector(15 downto 0);
  signal transfer                      : std_logic;
  signal transfer_next                 : std_logic;
  signal pps_flag                      : std_logic;
  signal pps_flag_next                 : std_logic;
  signal previous_digital_in           : std_logic_vector(15 downto 0);
  signal previous_digital_in_next      : std_logic_vector(15 downto 0);
  
begin  -- dig_goose_processor_struct

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      goose_timing_state       <= INCREMENT;
      timestamp_second_counter <= 0;
      timestamp_mili_counter   <= 0;
      mili_counter             <= (others => '0');
      t1_temp                  <= x"0001";
      transfer                 <= '0';
      t0                       <= x"00C8";
      t1                       <= x"0001";
      sixty_nano_counter       <= (others => '0');
      timestamp_high_part_reg  <= 0;
      timestamp_low_part_reg   <= 0;
      pps_flag                 <= '0';
      previous_digital_in      <= (others => '0');
      
    elsif rising_edge(sysclk) then      -- rising clock edge
      goose_timing_state       <= goose_timing_state_next;
      timestamp_second_counter <= timestamp_second_counter_next;
      timestamp_mili_counter   <= timestamp_mili_counter_next;
      mili_counter             <= mili_counter_next;
      t1_temp                  <= t1_temp_next;
      transfer                 <= transfer_next;
      sixty_nano_counter       <= sixty_nano_counter_next;
      timestamp_high_part_reg  <= timestamp_high_part_reg_next;
      timestamp_low_part_reg   <= timestamp_low_part_reg_next;
      pps_flag                 <= pps_flag_next;
      previous_digital_in      <= previous_digital_in_next;
      
    end if;
  end process;

  process (digital_in, goose_timing_state, mili_counter, pps, pps_flag,
           previous_digital_in, sixty_nano_counter, t0, t1, t1_temp,
           timestamp_high_part_reg, timestamp_low_part_reg,
           timestamp_mili_counter, timestamp_second_counter)
  begin  -- process

    goose_timing_state_next       <= goose_timing_state;
    timestamp_second_counter_next <= timestamp_second_counter + 1;
    timestamp_mili_counter_next   <= timestamp_mili_counter + 1;
    timestamp_high_part_reg_next  <= timestamp_high_part_reg;
    timestamp_low_part_reg_next   <= timestamp_low_part_reg;
    sixty_nano_counter_next       <= sixty_nano_counter + '1';
    mili_counter_next             <= mili_counter;
    t1_temp_next                  <= t1_temp;
    transfer_next                 <= '0';
    --timestamp_low_part_reg_next   <= timestamp_low_part_reg + 166;
    pps_flag_next                 <= pps_flag;
    previous_digital_in_next      <= previous_digital_in;

    if(sixty_nano_counter >= "101") then
      sixty_nano_counter_next     <= (others => '0');
      timestamp_low_part_reg_next <= timestamp_low_part_reg + 1;
    end if;
    if(pps = '1') then
      pps_flag_next <= '1';
    end if;
    if(previous_digital_in /= digital_in) then
      t1_temp_next                <= t1;
      mili_counter_next           <= (others => '0');
      transfer_next               <= '1';
      timestamp_mili_counter_next <= 0;
      previous_digital_in_next    <= digital_in;
    end if;

    case goose_timing_state is
      
      when INCREMENT =>
        if(t1_temp > t0) then
          t1_temp_next <= t0;
        end if;
        if(pps_flag = '1') then
          timestamp_second_counter_next <= 0;
          timestamp_low_part_reg_next   <= 0;
          --timestamp_mili_counter_next   <= 0;
          timestamp_high_part_reg_next  <= timestamp_high_part_reg + 1;
          pps_flag_next                 <= '0';
          
        end if;
        goose_timing_state_next <= VERIFY_MILI;
        
      when VERIFY_PPS =>
        goose_timing_state_next <= INCREMENT;

      when VERIFY_MILI =>
        if(timestamp_low_part_reg >= x"FE49A8") then
          timestamp_low_part_reg_next <= 0;
        end if;
        if(timestamp_mili_counter >= MILI_SECOND) then
          mili_counter_next           <= mili_counter + '1';
          timestamp_mili_counter_next <= 0;
          goose_timing_state_next     <= VERIFY_TIME;
        else
          goose_timing_state_next <= INCREMENT;
        end if;

      when VERIFY_TIME =>
        if(mili_counter = t1_temp) then
          transfer_next     <= '1';
          t1_temp_next      <= t1_temp(14 downto 0) & '0';
          mili_counter_next <= (others => '0');
        end if;
        goose_timing_state_next <= INCREMENT;
        
        
      when others =>
        goose_timing_state_next <= INCREMENT;
    end case;
  end process;

  
end dig_goose_processor_struct;
