-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : digital_register.vhdl
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-09-14
-- Last update: 2013-02-11
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-14  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity digital_register is
  
  port (
    reset_n              : in  std_logic;
    sysclk               : in  std_logic;
    data_input_available : in  std_logic;
    data_input           : in  std_logic_vector(31 downto 0);
    data_output          : out std_logic_vector(15 downto 0);

    digital_clk        : in  std_logic;
    digital_address    : in  std_logic_vector(1 downto 0);
    digital_readdata   : out std_logic_vector(31 downto 0);
    digital_read       : in  std_logic;
    digital_chipselect : in  std_logic;
    digital_writedata  : in  std_logic_vector(31 downto 0);
    digital_write      : in  std_logic;
    digital_irq        : out std_logic

    );

end digital_register;


architecture digital_register_struct of digital_register is


  type DIGITAL_TYPE is (INIT, WAIT_GOOD_TO_GO, CHECK_DIFFERENCE_FLAG, DUMMY1);
  type DIGITAL_MEMORY is array (integer range <>) of std_logic_vector(31 downto 0);


  attribute ENUM_ENCODING                 : string;
  attribute ENUM_ENCODING of DIGITAL_TYPE : type is "00 01 10 11";


  signal digital_state      : DIGITAL_TYPE;
  signal digital_state_next : DIGITAL_TYPE;

  signal REGISTERS : DIGITAL_MEMORY(4 downto 0);

  signal input_register       : std_logic_vector(31 downto 0);
  signal input_register_next  : std_logic_vector(31 downto 0);
  signal output_register      : std_logic_vector(15 downto 0);
  signal output_register_next : std_logic_vector(15 downto 0);

  signal difference      : std_logic;
  signal difference_next : std_logic;


  signal wr_en : std_logic;
  signal rd_en : std_logic;

  signal irq      : std_logic;
  signal irq_next : std_logic;

  signal started      : std_logic;
  signal started_next : std_logic;

  alias control_reg : std_logic_vector(31 downto 0) is REGISTERS(0);
  alias status_reg  : std_logic_vector(31 downto 0) is REGISTERS(1);

  


  
begin  -- digital_register_struct

  wr_en <= '1' when digital_write = '1' and digital_chipselect = '1' else '0';
  rd_en <= '1' when digital_read = '1' and digital_chipselect = '1'  else '0';

  digital_irq <= irq;

  data_output <= output_register;

  process (digital_clk, reset_n)
  begin  -- process
    if reset_n = '0' then                -- asynchronous reset (active low)
      digital_readdata <= x"00000000";
      for i in 0 to REGISTERS'length-1 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i
    elsif rising_edge(digital_clk) then  -- rising clock edge
      REGISTERS(2) <= input_register;
      if rd_en = '1' then
        digital_readdata <= REGISTERS(to_integer(unsigned(digital_address)));
      end if;
      if wr_en = '1' then
        REGISTERS(to_integer(unsigned(digital_address))) <= digital_writedata;
      end if;

      if started = '1' then
        status_reg(1) <= '0';
      end if;
      status_reg(0) <= irq_next;
    end if;
  end process;


  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      digital_state   <= INIT;
      irq             <= '0';
      input_register  <= (others => '0');
      started         <= '0';
      difference      <= '0';
      output_register <= (others => '0');
    elsif rising_edge(sysclk) then      -- rising clock edge
      digital_state   <= digital_state_next;
      irq             <= irq_next;
      input_register  <= input_register_next;
      started         <= started_next;
      difference      <= difference_next;
      output_register <= output_register_next;
    end if;
  end process;

  process (REGISTERS, control_reg, data_input, data_input_available,
           difference, digital_state, input_register, input_register_next, irq,
           output_register, started, status_reg)
  begin  -- process
    digital_state_next   <= digital_state;
    irq_next             <= irq;
    input_register_next  <= input_register;
    started_next         <= started;
    difference_next      <= difference;
    output_register_next <= REGISTERS(3)(15 downto 0);

    if input_register_next /= input_register then
      difference_next <= '1';
    end if;

    if data_input_available = '1' then
      input_register_next <= data_input;
    end if;

    case digital_state is

      when INIT =>
        irq_next            <= '0';
        started_next        <= '0';
        input_register_next <= (others => '0');
        digital_state_next  <= WAIT_GOOD_TO_GO;
        
      when WAIT_GOOD_TO_GO =>
        if control_reg(0) = '1' then
          started_next       <= '1';
          digital_state_next <= CHECK_DIFFERENCE_FLAG;
        end if;

      when CHECK_DIFFERENCE_FLAG =>
        if status_reg(1) = '1' then
          irq_next     <= '0';
          started_next <= '1';
        end if;
        if control_reg(0) = '0' then
          digital_state_next <= INIT;
        end if;
        if difference = '1' then
          irq_next        <= '1';
          started_next    <= '0';
          difference_next <= '0';
        end if;

      when others =>
        digital_state_next <= INIT;
    end case;
  end process;
  


  
end digital_register_struct;
