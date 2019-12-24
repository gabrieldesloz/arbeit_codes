
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
--use work.my_types_pkg.all;


-------------------------------------------------------------------------------

entity serial_comm_jiga_tb is


end serial_comm_jiga_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of serial_comm_jiga_tb is


  -- component ports
  -- clock
  constant CLKi_PERIOD   : time := 16.6666666 ns;  -- 60 MHz
  constant CLK_EN_period : time := 1 us;           -- 1 MHz

  constant END_OF_TIMES : time := 50 ms;


-- uut signals




  signal RX_i          : STD_LOGIC := '0';
  signal TX_DATA_i     : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
  signal SEND_i        : STD_LOGIC := '0';
  signal CLK_i   : STD_LOGIC := '0';
  signal CLK_EN_i : STD_LOGIC := '0';
  signal reset         : STD_LOGIC := '0';
  signal TX_o          : STD_LOGIC := '0';
  signal SENT_o        : STD_LOGIC := '0';
  signal FAIL_o        : STD_LOGIC := '0';
  signal READY_o       : STD_LOGIC := '0';
  signal RX_DATA_o     : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');


begin

  -- 60 MHz
  CLK_i    <= not CLK_i    after CLKi_PERIOD/2;
  CLK_EN_i <= not CLK_EN_i after CLK_EN_period/2;

  -- reset generation
  reset_n_proc : process
  begin
    reset <= '1';
    wait for 10*CLKi_PERIOD;
    reset <= '0';
    wait for END_OF_TIMES;
  end process;


  
  SERIAL_COMMUNICATION_1: entity work.SERIAL_COMMUNICATION_fpga_1
    port map (
      RX_i          => '0', --RX_i,
      TX_DATA_i     => TX_DATA_i,
      SEND_i        => SEND_i,
      CLK_60MHz_i   => CLK_i,
      CLK_EN_1MHz_i => CLK_EN_i,
      RST_i         => reset,
	  
      TX_o          => TX_o,
      SENT_o        => SENT_o,
      FAIL_o        => FAIL_o,
      READY_o       => READY_o,
      RX_DATA_o     => RX_DATA_o);


  

  sending_state_machine : process(CLK_i, reset)
    constant STATE_END    : natural := 500;
    variable time_counter : unsigned(31 downto 0);
  begin
    if reset = '1' then
      time_counter := (others => '0');
      TX_DATA_i    <= (others => '0');
      SEND_i       <= '0';
      
      
    elsif rising_edge(CLK_i) then

      -- default 
      time_counter := time_counter + 1;
      SEND_i       <= '0';
      ---------------------

      if time_counter = 100 then
        SEND_i    <= '1';
        TX_DATA_i <= x"AB";
      end if;



      if time_counter = 200 then
        SEND_i    <= '1';
        TX_DATA_i <= x"BA";
      end if;
	  
	  
	  
	   if time_counter = 300 then
        SEND_i    <= '1';
        TX_DATA_i <= x"FF";
      end if;
	  
	  
	  
	   if time_counter = 400 then
        SEND_i    <= '1';
        TX_DATA_i <= x"01";
      end if;


      -- end condition 
      if time_counter = STATE_END then
        time_counter := (others => '0');
      end if;
      -------- 
    end if;
  end process;



end generic_tb_rtl;



-- LocalWords:  microcontrolador ativa envio
