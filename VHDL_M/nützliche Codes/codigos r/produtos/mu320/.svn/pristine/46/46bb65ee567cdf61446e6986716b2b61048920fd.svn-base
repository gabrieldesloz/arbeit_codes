-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : sv_packet_processor.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-05-24
-- Last update: 2013-04-16
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-05-24  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- library work
-- use work.mu320_contans.all

entity sv_packet_processor is
  
  generic (
    ERROR_LENGTH : natural := 1);

  port (
    reset_n : in std_logic;
    clk     : in std_logic;
    sysclk  : in std_logic;

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

    protection_analog_data_input : in std_logic_vector(511 downto 0);
    protection_analog_data_ready : in std_logic;

    monitoring_analog_data_input : in  std_logic_vector(511 downto 0);
    monitoring_analog_data_ready : in  std_logic;
    monitoring_analog_new_data   : out std_logic;

    irig_status : in std_logic_vector(7 downto 0);

    pps : in std_logic

    );

end sv_packet_processor;

architecture sv_packet_processor_struct of sv_packet_processor is

  
  type SV_PACKET_PROC_TYPE is (WAIT_GOOD_TO_GO, WAIT_START, GET_DATA, SET_CTRL_BUS,
                               VERIFY_READY, VERIFY_READY_LAST, INSERT_COUNTER, INSERT_COUNTER_2, INSERT_SMP_SYNC,
                               INSERT_VALUES, VERIFY, VERIFY_FULL_WORD, VERIFY_READY_2, VERIFY_READY_SMP);

  attribute ENUM_ENCODING                        : string;
  attribute ENUM_ENCODING of SV_PACKET_PROC_TYPE : type is "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111";

  constant SV_PACKET_SIZE : natural := 252;

  type SV_PACKET_PROC_MEMORY is array (SV_PACKET_SIZE - 1 downto 0) of std_logic_vector(31 downto 0);

  signal sv_packet_proc_state      : SV_PACKET_PROC_TYPE;
  signal sv_packet_proc_state_next : SV_PACKET_PROC_TYPE;

  signal memory_sv_packet_proc : SV_PACKET_PROC_MEMORY;

  signal ram_packet_address      : std_logic_vector(7 downto 0);
  signal ram_packet_address_next : std_logic_vector(7 downto 0);

  signal write_cfg    : std_logic;
  signal write_packet : std_logic;

  signal ram_packet_data : std_logic_vector(31 downto 0);

  signal type_packet           : std_logic;
  signal type_packet_next      : std_logic;
  signal good_to_go            : std_logic;
  signal good_to_go_next       : std_logic;
  signal counter_position      : std_logic_vector(15 downto 0);
  signal counter_position_next : std_logic_vector(15 downto 0);
  signal number_asdu           : std_logic_vector(7 downto 0);
  signal number_asdu_next      : std_logic_vector(7 downto 0);

  signal last_byte_position       : std_logic_vector(15 downto 0);
  signal last_byte_position_next  : std_logic_vector(15 downto 0);
  signal counter_data_offset      : std_logic_vector(7 downto 0);
  signal counter_data_offset_next : std_logic_vector(7 downto 0);

  signal data_value_size             : std_logic_vector(7 downto 0);
  signal data_value_size_next        : std_logic_vector(7 downto 0);
  signal counter_smpsync_offset      : std_logic_vector(7 downto 0);
  signal counter_smpsync_offset_next : std_logic_vector(7 downto 0);
  signal counter_offset              : std_logic_vector(15 downto 0);
  signal counter_offset_next         : std_logic_vector(15 downto 0);

  signal position_verify      : std_logic_vector(15 downto 0);
  signal position_verify_next : std_logic_vector(15 downto 0);

  signal tmp_insert_register      : std_logic_vector(31 downto 0);
  signal tmp_insert_register_next : std_logic_vector(31 downto 0);

  signal data_output      : std_logic_vector(31 downto 0);
  signal data_output_next : std_logic_vector(31 downto 0);
  signal sop              : std_logic;
  signal sop_next         : std_logic;
  signal eop              : std_logic;
  signal eop_next         : std_logic;
  signal empty            : std_logic_vector(1 downto 0);
  signal empty_next       : std_logic_vector(1 downto 0);
  signal valid            : std_logic;
  signal valid_next       : std_logic;

  signal counter       : std_logic_vector(15 downto 0);
  signal counter_next  : std_logic_vector(15 downto 0);
  signal smp_sync      : std_logic_vector(7 downto 0);
  signal smp_sync_next : std_logic_vector(7 downto 0);

  signal times_done      : std_logic_vector(3 downto 0);
  signal times_done_next : std_logic_vector(3 downto 0);

  signal qty_x           : std_logic_vector(1 downto 0);
  signal qty_x_next      : std_logic_vector(1 downto 0);
  signal vector_pos      : std_logic_vector(8 downto 0);
  signal vector_pos_next : std_logic_vector(8 downto 0);

  signal vector : std_logic_vector(511 downto 0);

  signal counter_asdu      : natural range 0 to 7;
  signal counter_asdu_next : natural range 0 to 7;

  signal counter_position_total         : std_logic_vector(19 downto 0);
  signal counter_position_total_next    : std_logic_vector(19 downto 0);
  signal data_value_position_total      : std_logic_vector(19 downto 0);
  signal data_value_position_total_next : std_logic_vector(19 downto 0);
  signal smp_sync_position_total        : std_logic_vector(19 downto 0);
  signal smp_sync_position_total_next   : std_logic_vector(19 downto 0);

  signal ask_new_data      : std_logic;
  signal ask_new_data_next : std_logic;

  signal pps_flag                         : std_logic;
  signal pps_flag_next                    : std_logic;
  signal pps_packet_started               : std_logic;
  signal pps_packet_started_next          : std_logic;
  signal packet_started                   : std_logic;
  signal packet_started_next              : std_logic;
  signal monitoring_analog_data_ready_reg : std_logic;
  signal protection_analog_data_ready_reg : std_logic;

  signal first_pps_flag      : std_logic;
  signal first_pps_flag_next : std_logic;
  

begin  -- sv_packet_processor_struct

  source_err   <= (others => '0');
  source_eop   <= eop;
  source_sop   <= sop;
  source_empty <= empty;
  source_data  <= data_output;
  source_valid <= valid;

  monitoring_analog_new_data <= ask_new_data;


  write_cfg <= '1' when ((chipselect = '1') and (write = '1') and (address(7 downto 2) = "000000")) else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      if (write_cfg = '1') then
        case address(1 downto 0) is
          when "00" =>
            good_to_go_next             <= writedata(0);
            type_packet_next            <= writedata(1);
            counter_smpsync_offset_next <= writedata(15 downto 8);
            counter_data_offset_next    <= writedata(23 downto 16);
            number_asdu_next            <= writedata(31 downto 24);
            
          when "01" =>
            counter_position_next <= writedata(15 downto 0);
            counter_offset_next   <= writedata(31 downto 16);

          when "10" =>
            last_byte_position_next <= writedata(15 downto 0);
            
          when others => null;
        end case;
      end if;
    end if;
  end process;



  write_packet <= '1' when ((chipselect = '1') and (write = '1') and (address(7 downto 2) /= "000000")) else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      if (write_packet = '1') then
        memory_sv_packet_proc(CONV_INTEGER(address) - 4) <= writedata;
      else
        ram_packet_data <= memory_sv_packet_proc(CONV_INTEGER(ram_packet_address));
      end if;
    end if;
  end process;

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      pps_flag                         <= '1';
      monitoring_analog_data_ready_reg <= '1';
      protection_analog_data_ready_reg <= '1';
    elsif rising_edge(sysclk) then      -- rising clock edge
      if pps = '0' then
        pps_flag <= '1';
      end if;
      if pps_packet_started = '1' then
        pps_flag <= '0';
      end if;
      if monitoring_analog_data_ready = '0' then
        for I in 0 to 7 loop
          for J in 0 to 63 loop
            vector((I*64)+J) <= monitoring_analog_data_input(((7-I)*64)+J);
          end loop;  -- J
        end loop;  -- I
        smp_sync_next                    <= irig_status;
        monitoring_analog_data_ready_reg <= '0';
      end if;
      if protection_analog_data_ready = '0' then
        for I in 0 to 7 loop
          for J in 0 to 63 loop
            vector((I*64)+J) <= protection_analog_data_input(((7-I)*64)+J);
          end loop;  -- J
        end loop;  -- I
        smp_sync_next                    <= irig_status;
        protection_analog_data_ready_reg <= '0';
      end if;
      if packet_started = '1' then
        monitoring_analog_data_ready_reg <= '1';
        protection_analog_data_ready_reg <= '1';
      end if;
    end if;
  end process;



  process (clk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      sv_packet_proc_state      <= WAIT_GOOD_TO_GO;
      ram_packet_address        <= (others => '0');
      type_packet               <= '0';
      good_to_go                <= '0';
      counter_position          <= (others => '0');
      number_asdu               <= (others => '0');
      last_byte_position        <= (others => '0');
      counter_data_offset       <= (others => '0');
      data_value_size           <= (others => '0');
      counter_smpsync_offset    <= (others => '0');
      counter_offset            <= (others => '0');
      position_verify           <= (others => '0');
      tmp_insert_register       <= (others => '0');
      data_output               <= (others => '0');
      sop                       <= '0';
      eop                       <= '0';
      empty                     <= (others => '0');
      valid                     <= '0';
      counter                   <= (others => '0');
      smp_sync                  <= (others => '0');
      times_done                <= (others => '0');
      qty_x                     <= (others => '0');
      vector_pos                <= (others => '1');
      counter_asdu              <= 0;
      counter_position_total    <= (others => '0');
      data_value_position_total <= (others => '0');
      smp_sync_position_total   <= (others => '0');
      ask_new_data              <= '0';
      packet_started            <= '0';
      first_pps_flag            <= '0';
      
    elsif rising_edge(clk) then         -- rising clock edge
      sv_packet_proc_state      <= sv_packet_proc_state_next;
      ram_packet_address        <= ram_packet_address_next;
      type_packet               <= type_packet_next;
      good_to_go                <= good_to_go_next;
      counter_position          <= counter_position_next;
      number_asdu               <= number_asdu_next;
      last_byte_position        <= last_byte_position_next;
      counter_data_offset       <= counter_data_offset_next;
      data_value_size           <= data_value_size_next;
      counter_smpsync_offset    <= counter_smpsync_offset_next;
      counter_offset            <= counter_offset_next;
      position_verify           <= position_verify_next;
      tmp_insert_register       <= tmp_insert_register_next;
      data_output               <= data_output_next;
      sop                       <= sop_next;
      eop                       <= eop_next;
      empty                     <= empty_next;
      valid                     <= valid_next;
      counter                   <= counter_next;
      smp_sync                  <= smp_sync_next;
      times_done                <= times_done_next;
      qty_x                     <= qty_x_next;
      vector_pos                <= vector_pos_next;
      counter_asdu              <= counter_asdu_next;
      counter_position_total    <= counter_position_total_next;
      data_value_position_total <= data_value_position_total_next;
      smp_sync_position_total   <= smp_sync_position_total_next;
      ask_new_data              <= ask_new_data_next;
      pps_packet_started        <= pps_packet_started_next;
      packet_started            <= packet_started_next;
      first_pps_flag            <= first_pps_flag_next;
      
    end if;
  end process;


  process (ask_new_data, counter, counter_asdu, counter_data_offset,
           counter_offset, counter_position, counter_position_total,
           counter_smpsync_offset, data_output, data_value_position_total,
           data_value_position_total_next, empty, eop, good_to_go,
           last_byte_position, monitoring_analog_data_ready,
           monitoring_analog_data_ready_reg, position_verify, pps_flag,
           protection_analog_data_ready, protection_analog_data_ready_reg,
           qty_x, ram_packet_address, ram_packet_data, smp_sync,
           smp_sync_position_total, sop, source_ready, sv_packet_proc_state,
           times_done, tmp_insert_register, type_packet, valid, vector,
           vector_pos)
  begin  -- process

    sv_packet_proc_state_next      <= sv_packet_proc_state;
    ram_packet_address_next        <= ram_packet_address;
    position_verify_next           <= position_verify;
    tmp_insert_register_next       <= tmp_insert_register;
    data_output_next               <= data_output;
    sop_next                       <= sop;
    eop_next                       <= eop;
    empty_next                     <= empty;
    valid_next                     <= valid;
    counter_next                   <= counter;
    times_done_next                <= times_done;
    qty_x_next                     <= qty_x;
    vector_pos_next                <= vector_pos;
    counter_asdu_next              <= counter_asdu;
    counter_position_total_next    <= counter_position_total;
    data_value_position_total_next <= data_value_position_total;
    smp_sync_position_total_next   <= smp_sync_position_total;
    ask_new_data_next              <= ask_new_data;
    pps_packet_started_next        <= '0';
    packet_started_next            <= '0';
    first_pps_flag_next            <= first_pps_flag;

    if good_to_go = '0' then
        first_pps_flag_next <= '0';
        pps_packet_started_next <= '1';
        packet_started_next <= '1';
      end if;

    case sv_packet_proc_state is

      
      when WAIT_GOOD_TO_GO =>
        times_done_next                <= (others => '0');
        counter_position_total_next    <= (counter_position + (counter_offset * times_done));
        data_value_position_total_next <= ((counter_position + counter_data_offset) + (counter_offset * times_done));
        smp_sync_position_total_next   <= ((counter_position + counter_smpsync_offset) + (counter_offset * times_done));
        ram_packet_address_next        <= (others => '0');
        if good_to_go = '1' and protection_analog_data_ready = '1' and monitoring_analog_data_ready = '1' and (pps_flag = '1' or first_pps_flag = '1') then
          packet_started_next <= '1';
          first_pps_flag_next       <= '1';
          sv_packet_proc_state_next <= WAIT_START;
        end if;

      when WAIT_START =>
        if pps_flag = '1' then
          pps_packet_started_next <= '1';
          counter_next            <= (others => '0');
        end if;
        if type_packet = '0' then
          if protection_analog_data_ready_reg = '0' and good_to_go = '1' then
            packet_started_next       <= '1';
            sv_packet_proc_state_next <= GET_DATA;
          end if;
        elsif type_packet = '1' then
          if monitoring_analog_data_ready_reg = '0' and good_to_go = '1' then
            packet_started_next       <= '1';
            sv_packet_proc_state_next <= GET_DATA;
          end if;
        end if;

      when GET_DATA =>
        if ram_packet_address = counter_position_total(9 downto 2) then
          data_output_next <= ram_packet_data;
          if counter_position_total(1 downto 0) < "11" then
            sv_packet_proc_state_next <= INSERT_COUNTER;
          else
            ram_packet_address_next   <= ram_packet_address + 1;
            sv_packet_proc_state_next <= INSERT_COUNTER_2;
          end if;
        elsif ram_packet_address = data_value_position_total_next(9 downto 2) then
          data_output_next          <= ram_packet_data;
          qty_x_next                <= data_value_position_total_next(1 downto 0);
          sv_packet_proc_state_next <= INSERT_VALUES;
        elsif ram_packet_address = smp_sync_position_total(9 downto 2) then
          data_output_next          <= ram_packet_data;
          sv_packet_proc_state_next <= INSERT_SMP_SYNC;
        else
          data_output_next          <= ram_packet_data;
          sv_packet_proc_state_next <= SET_CTRL_BUS;
        end if;

      when SET_CTRL_BUS =>
        if ram_packet_address = 0 then
          sop_next <= '1';
        end if;
        if ram_packet_address >= last_byte_position(9 downto 2) then
          eop_next                  <= '1';
          sv_packet_proc_state_next <= VERIFY_READY_LAST;
          if last_byte_position(1 downto 0) < "11" then
            empty_next <= not(last_byte_position(1 downto 0));
          end if;
        else
          sv_packet_proc_state_next <= VERIFY_READY;
        end if;
        valid_next                     <= '1';
        vector_pos_next                <= (others => '1');
        ram_packet_address_next        <= ram_packet_address + 1;
        counter_position_total_next    <= (counter_position + (counter_offset * times_done));
        data_value_position_total_next <= ((counter_position + counter_data_offset) + (counter_offset * times_done));
        smp_sync_position_total_next   <= ((counter_position + counter_smpsync_offset) + (counter_offset * times_done));
        ask_new_data_next              <= '0';

      when VERIFY_READY =>
        if source_ready = '1' then
          valid_next                <= '0';
          sop_next                  <= '0';
          eop_next                  <= '0';
          sv_packet_proc_state_next <= GET_DATA;
        end if;

      when VERIFY_READY_LAST =>
        if source_ready = '1' then
          valid_next                <= '0';
          sop_next                  <= '0';
          eop_next                  <= '0';
          empty_next                <= (others => '0');
          sv_packet_proc_state_next <= WAIT_GOOD_TO_GO;
        end if;

      when INSERT_COUNTER =>
        data_output_next((((CONV_INTEGER(not(counter_position_total(1 downto 0))) + 1)*8)-1) downto ((CONV_INTEGER(not(counter_position_total(1 downto 0)))-1)*8)) <= counter;
        if counter = x"FFFF" then
          counter_next <= (others => '0');
        else
          counter_next <= counter + '1';
        end if;
        valid_next                <= '1';
        ram_packet_address_next   <= ram_packet_address + 1;
        sv_packet_proc_state_next <= VERIFY_READY;

      when INSERT_COUNTER_2 =>
        data_output_next(7 downto 0) <= counter(15 downto 8);
        valid_next                   <= '1';
        sv_packet_proc_state_next    <= VERIFY_READY_2;

      when INSERT_SMP_SYNC =>
        data_output_next((((CONV_INTEGER(not(smp_sync_position_total(1 downto 0))) + 1)*8)-1) downto ((CONV_INTEGER(not(smp_sync_position_total(1 downto 0))))*8)) <= smp_sync;
        valid_next                                                                                                                                                 <= '1';
        ram_packet_address_next                                                                                                                                    <= ram_packet_address + 1;
        sv_packet_proc_state_next                                                                                                                                  <= VERIFY_READY;

      when INSERT_VALUES =>
        if qty_x = "00" and vector_pos >= "000011111" then
          data_output_next          <= vector((CONV_INTEGER(vector_pos)) downto (CONV_INTEGER(vector_pos) - 31));
          sv_packet_proc_state_next <= VERIFY_FULL_WORD;
        else
          if qty_x = "00" then
            data_output_next <= ram_packet_data;
          end if;
          data_output_next((((CONV_INTEGER(not(qty_x))+1)*8)-1) downto ((CONV_INTEGER(not(qty_x)))*8)) <= vector((CONV_INTEGER(vector_pos)) downto (CONV_INTEGER(vector_pos) - 7));
          sv_packet_proc_state_next                                                                    <= VERIFY;
        end if;

      when VERIFY =>
        if vector_pos = "000000111" then
          sv_packet_proc_state_next <= SET_CTRL_BUS;
          ask_new_data_next         <= '1';
          times_done_next           <= times_done + '1';
        elsif qty_x = "11" then
          valid_next                <= '1';
          qty_x_next                <= "00";
          ram_packet_address_next   <= ram_packet_address + 1;
          vector_pos_next           <= vector_pos - "1000";                                                     
          sv_packet_proc_state_next <= VERIFY_READY_SMP;
        else
          vector_pos_next           <= vector_pos - "1000";                                                     
          qty_x_next                <= qty_x + '1';
          sv_packet_proc_state_next <= INSERT_VALUES;
        end if;

      when VERIFY_FULL_WORD =>
        if vector_pos = "000011111" then
          sv_packet_proc_state_next <= SET_CTRL_BUS;
          ask_new_data_next         <= '1';
          times_done_next           <= times_done + '1';
        else
          valid_next                <= '1';
          ram_packet_address_next   <= ram_packet_address + 1;
          vector_pos_next           <= vector_pos - "100000";                                                     
          sv_packet_proc_state_next <= VERIFY_READY_SMP;
        end if;

        
      when VERIFY_READY_2 =>
        if source_ready = '1' then
          valid_next       <= '0';
          sop_next         <= '0';
          eop_next         <= '0';
          data_output_next <= counter(7 downto 0) & ram_packet_data(23 downto 0);
          counter_next     <= counter + '1';
          if counter = x"FFFF" then
            counter_next <= (others => '0');
          else
            counter_next <= counter + '1';
          end if;
          sv_packet_proc_state_next <= SET_CTRL_BUS;
        end if;

      when VERIFY_READY_SMP =>
        if source_ready = '1' then
          valid_next                <= '0';
          sop_next                  <= '0';
          eop_next                  <= '0';
          sv_packet_proc_state_next <= INSERT_VALUES;
        end if;

      when others =>
        sv_packet_proc_state_next <= WAIT_GOOD_TO_GO;
        
    end case;

    
  end process;


end sv_packet_processor_struct;
