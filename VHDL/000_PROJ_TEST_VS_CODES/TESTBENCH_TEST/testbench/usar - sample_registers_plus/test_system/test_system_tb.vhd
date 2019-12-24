
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------

entity test_system_tb is


end test_system_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of test_system_tb is


  signal coe_data_input1     : std_logic_vector(127 downto 0);
  signal coe_data_output1    : std_logic_vector(127 downto 0);
  signal coe_data_ready_out1 : std_logic;
  signal coe_data_input2     : std_logic_vector(127 downto 0);
  signal coe_data_output2    : std_logic_vector(127 downto 0);
  signal coe_data_ready_out2 : std_logic;


  signal data_output : std_logic_vector(255 downto 0);
  signal data_ready  : std_logic;


  signal data_in           : std_logic_vector(255 downto 0);
  signal data_in_available : std_logic;


  
begin


  gain_registers_tb_1 : entity work.gain_registers_tb
    port map (
      data_output => data_output,
      data_ready  => data_ready);

  


  board1 : entity work.phase_sum_tb
    port map (
      coe_data_input     => coe_data_input1,
      coe_data_output    => coe_data_output1,
      coe_data_ready_in  => data_ready,
      coe_data_ready_out => coe_data_ready_out1
      );


  board2 : entity work.phase_sum_tb
    port map (
      coe_data_input     => coe_data_input2,
      coe_data_output    => coe_data_output2,
      coe_data_ready_in  => data_ready,
      coe_data_ready_out => coe_data_ready_out2
      );



  sample_adjust_tb_1 : entity work.sample_adjust_tb
    port map (
      data_in           => data_in,
      data_in_available => data_in_available);


  coe_data_input1   <= data_output(127 downto 0);
  coe_data_input2   <= data_output(255 downto 128);
  data_in           <= (coe_data_output1 & coe_data_output2);
  data_in_available <= (coe_data_ready_out1 and coe_data_ready_out2);


  
  
end generic_tb_rtl;
