

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
--use work.teste_dma_constants.all;


entity adder is
  
  port (
    sysclk           : in  std_logic;
    reset_n          : in  std_logic;
    adder_chipselect : in  std_logic;
    adder_read       : in  std_logic;
    adder_write      : in  std_logic;
    adder_writedata  : in  std_logic_vector(31 downto 0);
    adder_readdata   : out std_logic_vector(31 downto 0);
    adder_address    : in  std_logic_vector(2 downto 0);
    adder_irq        : out std_logic);

end adder;


architecture adder_struct of adder is


  type ADDER_TYPE is (WAIT_START, ADD, INCREMENT, FINISH);

  attribute ENUM_ENCODING               : string;
  attribute ENUM_ENCODING of ADDER_TYPE : type is "00 01 10 11";

  signal adder_state      : ADDER_TYPE;
  signal adder_state_next : ADDER_TYPE;

  -- Registers
  type   BUFFER_R is array (integer range <>) of std_logic_vector(31 downto 0);
  signal REGISTERS : BUFFER_R (7 downto 0);

  alias number1_reg : std_logic_vector(31 downto 0) is REGISTERS(0);
  alias number2_reg : std_logic_vector(31 downto 0) is REGISTERS(1);
  alias result_reg  : std_logic_vector(31 downto 0) is REGISTERS(2);
  alias control_reg : std_logic_vector(31 downto 0) is REGISTERS(3);
  alias status_reg  : std_logic_vector(31 downto 0) is REGISTERS(4);

  -- Control Signals
  signal wr_en : std_logic;
  signal rd_en : std_logic;

  signal number1      : std_logic_vector(31 downto 0);
  signal number1_next : std_logic_vector(31 downto 0);
  signal number2      : std_logic_vector(31 downto 0);
  signal number2_next : std_logic_vector(31 downto 0);
  signal result       : std_logic_vector(32 downto 0);
  signal result_next  : std_logic_vector(32 downto 0);
  signal irq          : std_logic;
  signal irq_next     : std_logic;
  signal counter      : std_logic_vector(31 downto 0);
  signal counter_next : std_logic_vector(31 downto 0);
  signal started      : std_logic;
  signal started_next : std_logic;


  
begin  -- adder_struct

  wr_en <= '1' when adder_write = '1' and adder_chipselect = '1' else '0';
  rd_en <= '1' when adder_read = '1' and adder_chipselect = '1'  else '0';

  adder_irq <= irq;



  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      adder_readdata <= x"00000000";
      for i in 0 to REGISTERS'length-1 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i
    elsif rising_edge(sysclk) then      -- rising clock edge
      if rd_en = '1' then
        adder_readdata <= REGISTERS(to_integer(unsigned(adder_address)));
      end if;
      if wr_en = '1' then
        REGISTERS(to_integer(unsigned(adder_address))) <= adder_writedata;
      end if;
      if started = '1' then
        control_reg(0) <= '0';
        control_reg(1) <= '0';
      end if;
      status_reg(0) <= irq_next;
      result_reg    <= result(31 downto 0);
    end if;
  end process;



  -- State Machine Process
  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      adder_state <= WAIT_START;
      number1     <= (others => '0');
      number2     <= (others => '0');
      result      <= (others => '0');
      irq         <= '0';
      counter     <= (others => '0');
      started     <= '0';
    elsif rising_edge(sysclk) then      -- rising clock edge
      adder_state <= adder_state_next;
      number1     <= number1_next;
      number2     <= number2_next;
      result      <= result_next;
      irq         <= irq_next;
      counter     <= counter_next;
      started     <= started_next;
    end if;
  end process;


  process (adder_state, control_reg, counter, number1, number1_reg, number2,
           number2_reg, result, started, status_reg)
  begin  -- process
    adder_state_next <= adder_state;
    number1_next     <= number1;
    number2_next     <= number2;
    result_next      <= result;
    irq_next         <= status_reg(0);
    counter_next     <= counter;
    started_next     <= started;

    case adder_state is
      
      when WAIT_START =>
        if control_reg(1) = '1' then
          irq_next <= '0';
        end if;
        if control_reg(0) = '1' then
          started_next     <= '1';
          number1_next     <= number1_reg;
          number2_next     <= number2_reg;
          adder_state_next <= ADD;
        end if;

      when ADD =>
        result_next      <= std_logic_vector(signed('0' & number1) + signed('0' & number2));
        adder_state_next <= INCREMENT;


      when INCREMENT =>
        counter_next <= std_logic_vector(unsigned(counter) + 1);
        if counter = x"0000FFFE" then
          counter_next     <= (others => '0');
          adder_state_next <= FINISH;
        end if;

      when FINISH =>
        irq_next         <= '1';
        started_next     <= '0';
        adder_state_next <= WAIT_START;


        
      when others =>
        adder_state_next <= WAIT_START;
    end case;
    
  end process;
  
  



end adder_struct;
