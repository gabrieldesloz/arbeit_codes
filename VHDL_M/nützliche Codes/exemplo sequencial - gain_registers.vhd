-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : gain_registers.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-03-07
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0      lgs	Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.mu320_constants.all;


-- entity declaration
entity gain_registers is
  port(
    -- avalon signals
    clk        : in std_logic;
    reset_n    : in std_logic;
    address    : in std_logic_vector(3 downto 0);
    byteenable : in std_logic_vector(1 downto 0);
    writedata  : in std_logic_vector(15 downto 0);
    write      : in std_logic;
    chipselect : in std_logic;

    -- Module Signals
    sysclk         : in  std_logic;
    data_input     : in  std_logic_vector(127 downto 0);
    data_available : in  std_logic;
    data_output    : out std_logic_vector(127 downto 0);
    data_ready     : out std_logic
    );
end gain_registers;


architecture rtl_gain_registers of gain_registers is

-- Type and enumeration declarations 
  type BUFFER_R is array (integer range <>) of std_logic_vector(15 downto 0);
  type CALIBRATION_TYPE is (WAIT_READY_FIR, APPLY_GAIN,
                            APPLY_OFFSET,
                            INCREMENT);

  attribute ENUM_ENCODING                     : string;
  attribute ENUM_ENCODING of CALIBRATION_TYPE : type is "00 01 10 11";

  signal calibration_state      : CALIBRATION_TYPE;
  signal calibration_state_next : CALIBRATION_TYPE;

-- Internal signals
  signal gain_register      : BUFFER_R((N_CHANNELS_ANA/2 - 1) downto 0);
  signal offset_register    : BUFFER_R((N_CHANNELS_ANA/2 - 1) downto 0);
  signal write_register     : std_logic;
  signal data_register      : std_logic_vector(127 downto 0);
  signal data_register_next : std_logic_vector(127 downto 0);
  signal counter            : std_logic_vector(2 downto 0);
  signal counter_next       : std_logic_vector(2 downto 0);
  signal acc_reg            : std_logic_vector(32 downto 0);
  signal acc_reg_next       : std_logic_vector(32 downto 0);
  signal data_ready_reg : std_logic;
  signal data_ready_next : std_logic;
  
begin

  data_output <= data_register;
  data_ready <= data_ready_reg;
  write_register <= '1' when ((chipselect = '1') and (write = '1')) else '0';

  process (clk)
  begin  -- process    
    if rising_edge(clk) then
      if (reset_n = '0') then
        for i in 0 to N_CHANNELS_ANA/2 - 1 loop
          gain_register(i)   <= (others => '0');
          offset_register(i) <= (others => '0');
        end loop;  -- i
      elsif (write_register = '1') then
        case address(3) is
          when '0' =>
            gain_register(CONV_INTEGER('0' & address(2 downto 0))) <= writedata;
          when '1' =>
            offset_register(CONV_INTEGER('0' & address(2 downto 0))) <= writedata;
          when others => null;
        end case;
      end if;
    end if;
  end process;


  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      calibration_state <= WAIT_READY_FIR;
      data_register     <= (others => '0');
      counter           <= (others => '0');
      acc_reg           <= (others => '0');
      data_ready_reg <= '0';
    elsif rising_edge(sysclk) then  -- rising clock edge
      calibration_state <= calibration_state_next;
      data_register     <= data_register_next;
      counter           <= counter_next;
      acc_reg           <= acc_reg_next;
      data_ready_reg <= data_ready_next;
    end if;
  end process;

  process (acc_reg, calibration_state, counter, data_available, data_input,
           data_register, gain_register, offset_register)
  begin  -- process
    calibration_state_next <= calibration_state;
    data_register_next     <= data_register;
    counter_next           <= counter;
    acc_reg_next           <= acc_reg;
    data_ready_next <= data_ready_reg;

    case calibration_state is
      
      when WAIT_READY_FIR =>
        data_ready_next   <= '0';
        counter_next <= (others => '0');
        if data_available = '1' then
          --registra entrada
          data_register_next     <= data_input;
          calibration_state_next <= APPLY_GAIN;
        end if;
        
      when APPLY_GAIN =>        

        -- aplica ganho multiplicando a entrada (data input) pelo registrador
        -- de ganho (gain register)
        acc_reg_next           <= data_register(((CONV_INTEGER('0' & counter)*16)+15) downto CONV_INTEGER('0' & counter)*16) *('0' & gain_register(CONV_INTEGER('0' & counter)));
        calibration_state_next <= APPLY_OFFSET;
        
      when APPLY_OFFSET =>
        -- aplica deslocamento no valor da enrrada com ganho 
        data_register_next(((CONV_INTEGER('0' & counter)*16)+15) downto CONV_INTEGER('0' & counter)*16) <= (acc_reg(32) & acc_reg(29 downto 15)) + offset_register(CONV_INTEGER('0' & counter));
        calibration_state_next                                                              <= INCREMENT;
        
      when INCREMENT =>
        -- controle sequencial
        if ('0' & counter) < "0111" then
          counter_next           <= counter + '1';
          calibration_state_next <= APPLY_GAIN;
        else
          --data_output            <= data_register;
          data_ready_next             <= '1';
          calibration_state_next <= WAIT_READY_FIR;
        end if;
        
      when others =>
        calibration_state_next <= WAIT_READY_FIR;
        
    end case;
    
  end process;
  

end rtl_gain_registers;

