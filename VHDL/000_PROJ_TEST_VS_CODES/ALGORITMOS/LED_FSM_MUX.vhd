library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity LED_FSM is
  port (
    ch_a_ok : in  std_logic;
    ch_b_ok : in  std_logic;
    ch_c_ok : in  std_logic;
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    led     : out std_logic
    );    

end entity LED_FSM;

architecture ARQ1 of LED_FSM is


  type state_type is (IDLE, DECISION, LED_ON, LED_OFF, WAITE);
  signal state_next, state_reg : state_type;
  signal led_next, led_reg     : std_logic;
  signal count_next, count_reg : natural range 0 to 16;
  signal ctrl_vect             : std_logic_vector(2 downto 0);
  signal clk_HS_pulse          : std_logic;
  
  
begin  -- architecture ARQ1

  ctrl_vect <= ch_a_ok & ch_b_ok & ch_c_ok;
  led       <= led_reg;

  --0.5 Hz Pulse Generator
  --dco_generic_1 : entity work.dco_generic
  --  generic map (
  --    N_BITS_NCO_GEN => 42)
  --  port map (
  --    n_reset    => n_reset,
  --    sysclk     => sysclk,
  --    sync       => '0',
  --    freq       => "00" & x"00000055E6",
  --    f_dco      => open,
  --    -- half second pulse
  --    f_dco_edge => clk_HS_pulse
  --    );

  -- 1 Hz Pulse generator
  dco_generic_1 : entity work.dco_generic
    generic map (
      N_BITS_NCO_GEN => 32)
    port map (
      n_reset    => n_reset,
      sysclk     => sysclk,
      sync       => '0',
      freq       => x"0000002B",
      f_dco      => open,
      -- half second pulse
      f_dco_edge => clk_HS_pulse
      );


-- main registers
  process(n_reset, sysclk)
  begin
    if n_reset = '0' then
      state_reg <= IDLE;
      led_reg   <= '0';
      count_reg <= 0;
    elsif rising_edge(sysclk) then
      if clk_HS_pulse = '1' then
        state_reg <= state_next;
        led_reg   <= led_next;
        count_reg <= count_next;
      end if;
    end if;
  end process;



-- main state machine
  process(count_reg, ctrl_vect, led_reg, state_reg)
  begin
    led_next   <= led_reg;
    count_next <= count_reg;
    state_next <= state_reg;

    case state_reg is

      when IDLE =>
        count_next <= 0;
        led_next   <= '0';
        state_next <= DECISION;

      when DECISION =>
        state_next <= LED_ON;

        -- input decoder
        case ctrl_vect is
          when "011" => count_next <= 1;
          when "101" => count_next <= 2;
          when "110" => count_next <= 3;
          when "111" => led_next   <= '0';
                        state_next <= DECISION;
          when "001" => count_next <= 4;
          when "010" => count_next <= 5;
          when "100" => count_next <= 6;
          when "000" => led_next   <= '1';
                        state_next <= DECISION;
          when others => state_next <= IDLE;
        end case;

      when LED_ON =>
        if count_reg = 0 then
          count_next <= 5;
          state_next <= WAITE;
        else
          led_next   <= '1';
          count_next <= count_reg - 1;
          state_next <= LED_OFF;
        end if;

      when LED_OFF =>
        led_next   <= '0';
        state_next <= LED_ON;

      when WAITE =>
        led_next <= '0';

        if count_reg = 0 then
          state_next <= DECISION;
        else
          count_next <= count_reg - 1;
        end if;
        
      when others =>
        state_next <= DECISION;
    end case;
  end process;
  

end architecture ARQ1;



