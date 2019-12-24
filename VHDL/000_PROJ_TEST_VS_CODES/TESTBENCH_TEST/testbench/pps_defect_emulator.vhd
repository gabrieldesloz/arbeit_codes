library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;


entity pps_defect_emulator is
  generic (
    W_PERIOD : natural := 10;
    PPS_ON_P : natural := 20;
    W_ON     : boolean := true
    );

  port(
    ext_edge       : in  std_logic;
    clock, n_reset : in  std_logic;
    pps_in         : in  std_logic;
    pps_out        : out std_logic
    );
end pps_defect_emulator;


architecture pps_defect_emulator_RTL of pps_defect_emulator is

  type FSMD_STATE_TYPE is (WAIT_P, PPS_ON);
  attribute ENUM_ENCODING                    : string;
  attribute ENUM_ENCODING of FSMD_STATE_TYPE : type is "00 01";
  signal state_reg, state_next               : fsmd_state_type;
  signal c1_reg, c1_next                     : natural range 0 to 9000;
  signal c2_reg, c2_next                     : natural range 0 to 9000;
  signal wait_period_reg, wait_period_next   : natural range 0 to 9000;
  
begin
  
  process(clock, n_reset)
  begin
    if (n_reset = '0') then
      wait_period_reg <= W_PERIOD;
      state_reg       <= WAIT_P;
      c1_reg          <= 0;
      c2_reg          <= 0;
    elsif (clock'event and clock = '1') then
      wait_period_reg <= wait_period_next;
      state_reg       <= state_next;
      c1_reg          <= c1_next;
      c2_reg          <= c2_next;
    end if;
  end process;


  process(c1_reg, c2_reg, ext_edge, pps_in, state_reg, wait_period_reg)
  begin


    
    c1_next          <= c1_reg;
    c2_next          <= c2_reg;
    state_next       <= state_reg;
    wait_period_next <= wait_period_reg;
    case state_reg is
      when WAIT_P =>

        if W_ON then
          pps_out <= '0';
        else
          pps_out <= '1';
        end if;        

        if (ext_edge = '1') then
          c1_next <= c1_reg + 1;
        elsif c1_reg = wait_period_reg then
          wait_period_next <= wait_period_reg + 1;
          state_next       <= PPS_ON;
          c2_next          <= 0;
        end if;
        
      when PPS_ON =>

        pps_out <= pps_in;
        if ext_edge = '1' then
          c2_next <= c2_reg + 1;
        elsif (c2_reg = PPS_ON_P) then
          state_next <= WAIT_P;
          c1_next    <= 0;

        end if;
    end case;
  end process;
  
end pps_defect_emulator_RTL;
