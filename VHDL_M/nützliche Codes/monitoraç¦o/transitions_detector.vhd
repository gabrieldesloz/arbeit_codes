--=============================
 -- Übergangsdetektor
--=============================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity transitions_detector is
  generic (
    BITS : natural := 16
    );
  port
    (
    clk, reset_n      : in  std_logic;
    strobe            : in  std_logic;
    pulse             : out std_logic;
    pps               : in  std_logic;
    transitions_p_sec : out std_logic_vector(BITS-1 downto 0);
    transitions       : out std_logic_vector(BITS-1 downto 0)
    );
end transitions_detector;

architecture direct_arch of transitions_detector is
  signal delay_reg                                         : std_logic;
  signal transitions_reg, transitions_next                 : unsigned(BITS-1 downto 0);
  signal transitions_p_sec_next, transitions_p_sec_reg     : unsigned(BITS-1 downto 0);
  signal transitions_p_sec_o_reg, transitions_p_sec_o_next : unsigned(BITS-1 downto 0);
  
begin


-- delay register
  process(clk, reset)
  begin
    if (reset_n = '0') then

      delay_reg               <= '0';
      transitions_reg         <= (others => '0');
      transitions_p_sec_reg   <= (others => '0');
      transitions_p_sec_o_reg <= (others => '0');
      
    elsif rising_edge(clk) then
      
      transitions_p_sec_o_reg <= transitions_p_sec_o_next;
      transitions_p_sec_reg   <= transitions_p_sec_next;
      transitions_reg         <= transitions_next;
      delay_reg               <= strobe;

    end if;
  end process;


-- detector ----------------------------------------------------------
  pulse                  <= pulse_int;
  pulse_int              <= delay_reg xor strobe;
----------------------------------------------------------------------  


  transitions            <= std_logic_vector(transitions_reg);
  transitions_p_sec      <= std_logic_vector(transitions_p_sec_o_reg);


  
-- counters ------------------------------------------------------------------
  transitions_next       <= transitions_reg + 1       when (pulse_int = '1') else transitions_reg;
  transitions_p_sec_next <= transitions_p_sec_reg + 1 when (pulse_int = '1') else (others => '0')
                            when (pps_pulse = '1')
                            else transitions_p_sec_reg;
  transitions_p_sec_o_next <= transitions_p_sec_reg when (pps_pulse = '1') else transitions_p_sec_o_reg;
-------------------------------------------------------------------------------  
  
end direct_arch;
