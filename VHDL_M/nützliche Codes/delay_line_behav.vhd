-------------------------------------------------------------------------------
-- delay line parametrizavel (estrutura generate)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- delay_ctrl_int: subtração: atrasa-se o sinal, soma, adianta-se o sinal
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



library work;
use work.rl131_constants.all;

library lpm;
use lpm.lpm_components.all;


entity delay_line_behav is
  port
    (

      clock      : in  std_logic;
      n_reset    : in  std_logic;
      serial_in  : in  std_logic;
      serial_out : out std_logic;  
      delay_ctrl : in  std_logic_vector(DLC_BITS-1 downto 0)


      );

end delay_line_behav;

architecture delay_line_behav_RTL of delay_line_behav is
  

  type sr_length is array ((DLC_SIZE-1) downto 0) of std_logic;
  signal sr : sr_length;
  signal delay_ctrl_int : integer range 0 to DLC_SIZE-1;
    
begin

  delay_ctrl_int <= to_integer(unsigned(delay_ctrl));
  

  process (clock, n_reset)
  begin
    if (n_reset = '0') then
      sr <= (others => '0');
    elsif (rising_edge(clock)) then
      sr((DLC_SIZE-1) downto 1) <= sr((DLC_SIZE-2) downto 0);
      sr(0)                       <= serial_in;
    end if;
  end process;

  
  serial_out <= sr(delay_ctrl_int);



  

end delay_line_behav_RTL;


