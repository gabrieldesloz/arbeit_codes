-------------------------------------------------------------------------------
-- $Id: shift_register.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/shift_register.vhd $
-- Written by Celso Souza on 10/2007
-- Last update: 2012-09-17
-- Description: controls shift-register 74HC594
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use work.mu320_constants.all;
entity shift_register is

  port (

    -- system signals
    n_reset : in std_logic;
    sysclk  : in std_logic;

    -- value to be updated
    led : in std_logic_vector ((N_LEDS - 1) downto 0);

    -- handshaking signals
    start : in  std_logic;
    busy  : out std_logic;

    -- 74HC594D control signals
    srclk   : out std_logic;
    rclk    : out std_logic;
    n_srclr : out std_logic;
    n_rclr  : out std_logic;
    ser     : out std_logic


    );

end entity shift_register;
-----------------------------------------------------------------
architecture shift_register_rtl of shift_register is

  type STATE_UPDATE_TYPE is (WAIT_START_STATE, DOWN_SRCLK_STATE,
                             UP_SRCLK_STATE, UP_RCLK_STATE);
  attribute ENUM_ENCODING                      : string;
  attribute ENUM_ENCODING of STATE_UPDATE_TYPE : type is "00 01 10 11";


  signal en_div            : std_logic;
  signal state_update      : STATE_UPDATE_TYPE;
  signal state_update_next : STATE_UPDATE_TYPE;
  signal led_counter       : natural range 0 to (N_LEDS - 1);
  signal led_counter_next  : natural range 0 to (N_LEDS - 1);
  signal srclk_int         : std_logic;
  signal rclk_int          : std_logic;
  signal ser_int           : std_logic;
  signal start_int         : std_logic;
  signal busy_int          : std_logic;

begin
  
  busy <= busy_int;

  clk_divider_inst : entity work.clk_divider
    generic map (DES_FREQ_MHZ => 4)
    port map(
      sysclk  => sysclk,
      n_reset => n_reset,
      en_div  => en_div
      );


  -- update led
  process (sysclk, n_reset) is
  begin
    if (n_reset = '0') then
      led_counter  <= 0;
      state_update <= WAIT_START_STATE;
    elsif rising_edge(sysclk) then
      if (en_div = '1') then
        led_counter  <= led_counter_next;
        state_update <= state_update_next;
      end if;
    end if;
  end process;


  process (state_update, led_counter, led, start_int)

  begin
    srclk_int        <= '0';
    rclk_int         <= '0';
    ser_int          <= led (N_LEDS - led_counter - 1);
    busy_int         <= '0';
    led_counter_next <= led_counter;
    case state_update is
      
      when WAIT_START_STATE =>
        state_update_next <= WAIT_START_STATE;
        if (start_int = '1') then
          state_update_next <= DOWN_SRCLK_STATE;
        end if;

      when DOWN_SRCLK_STATE =>
        busy_int          <= '1';
        state_update_next <= UP_SRCLK_STATE;

      when UP_SRCLK_STATE =>
        srclk_int <= '1';
        busy_int  <= '1';
        if (led_counter = (N_LEDS - 1)) then
          state_update_next <= UP_RCLK_STATE;
          led_counter_next  <= 0;
        else
          state_update_next <= DOWN_SRCLK_STATE;
          led_counter_next  <= led_counter + 1;
        end if;
        
      when UP_RCLK_STATE =>
        busy_int          <= '1';
        rclk_int          <= '1';
        led_counter_next  <= 0;
        state_update_next <= WAIT_START_STATE;
        
    end case;
  end process;

  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      srclk   <= '0';
      rclk    <= '0';
      ser     <= '0';
      n_srclr <= '0';
      n_rclr  <= '0';
    elsif rising_edge (sysclk) then
      srclk   <= srclk_int;
      rclk    <= rclk_int;
      ser     <= ser_int;
      n_srclr <= '1';
      n_rclr  <= '1';
    end if;
  end process;


  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      start_int <= '0';
    elsif rising_edge(sysclk) then
      if (start = '1') then
        start_int <= '1';
      elsif (busy_int = '1') then
        start_int <= '0';
      end if;
    end if;
  end process;
  
end architecture shift_register_rtl;

-- eof $Id: shift_register.vhd 3646 2007-11-12 20:54:13Z cls $
