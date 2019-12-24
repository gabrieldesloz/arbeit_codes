

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_tx_controller is

  generic (
    N_WORDS      : natural := 7;
    DATA_i_WIDTH : natural := 7*8
    );

  port (
    START_i  : in  std_logic;
    CLK_i    : in  std_logic;
    CLK_EN_i : in  std_logic;
    RST_i    : in  std_logic;
    DATA_i   : in  std_logic_vector(DATA_i_WIDTH-1 downto 0);
    TX_o     : out std_logic;
    SENT_o   : out std_logic
    );

end serial_tx_controller;


architecture RTL of serial_tx_controller is

  constant W_WIDTH : natural := 8;

  type IN_ARRAY_TYPE is array (integer range <>) of std_logic_vector(W_WIDTH-1 downto 0);
  signal in_array_s   : IN_ARRAY_TYPE(0 to N_WORDS-1);
  signal word_counter : natural range 0 to N_WORDS;


  signal data_to_send    : std_logic_vector (W_WIDTH-1 downto 0);  --
  signal s_SEND_i        : std_logic;                              --
  signal s_PACKET_SENT_o : std_logic;                              --
  signal s_START_reg1    : std_logic;
  signal s_START_reg2    : std_logic;
  signal s_SERIAL_TX     : std_logic;
  signal state           : natural range 0 to 10 := 0;
  signal reset_n         : std_logic;
  signal s_TX_o          : std_logic;


begin

  TX_o <= s_TX_o;

  register_in : process(CLK_i, RST_i)
  begin
    if (RST_i = '1') then
      in_array_s   <= (others => (others => '0'));
      s_START_reg1 <= '0';
      s_START_reg2 <= '0';
    elsif (rising_edge(CLK_i)) then
      s_START_reg1 <= START_i;
      s_START_reg2 <= s_START_reg1;

      for i in 0 to (N_WORDS - 1) loop
        in_array_s(i) <= DATA_i(((i+1)*W_WIDTH)-1 downto i*W_WIDTH);
      end loop;

    end if;
  end process;


  SERIAL_TX_1 : entity work.SERIAL_TX
    port map (
      TX_DATA_i     => data_to_send,    --
      SEND_i        => s_SEND_i,        --
      CLK_i         => CLK_i,           --
      CLK_EN_i      => CLK_EN_i,        --
      RST_i         => RST_i,           --
      PACKET_SENT_o => s_PACKET_SENT_o,
      TX_o          => s_SERIAL_TX);    --




  controller : process(CLK_i, RST_i, START_i, s_PACKET_SENT_o)
  begin

    if RST_i = '1' then
      state        <= 0;
      word_counter <= 0;
      data_to_send <= (others => '0');
      s_SEND_i     <= '0';
      SENT_o       <= '0';
      s_TX_o       <= '0';
    elsif rising_edge(CLK_i) then
      -- default
      state        <= state;
      word_counter <= word_counter;
      s_SEND_i     <= '0';
      SENT_o       <= '0';
      s_TX_o       <= s_SERIAL_TX;

      case state is

        when 0 =>                       -- begin

          if s_START_reg2 = '1' then

            state        <= 5;          -- jumps directly to state 5
            word_counter <= N_WORDS-1;
          end if;

        -- start of the frame           -- synch (not used)
        when 1 => state <= 2;
                  s_TX_o <= '1';
        when 2 => state <= 3;
                  s_TX_o <= '0';
        when 3 => state <= 4;
                  s_TX_o <= '1';
        when 4 => state <= 5;
                  s_TX_o <= '0';
                  ------------------------------

        when 5 =>                       -- load

          if CLK_EN_i = '1' then
            s_SEND_i     <= '1';
            data_to_send <= in_array_s(word_counter);
            state        <= 6;
          end if;


        when 6 =>                       -- WAIT

          if s_PACKET_SENT_o = '1' then
            state <= 7;
          end if;

        when 7 =>

          if CLK_EN_i = '1' then
            if word_counter = 0 then
              state <= 8;

              SENT_o <= '1';
            else
              word_counter <= word_counter - 1;
              state        <= 5;
            end if;
          end if;

        when 8 =>

          if CLK_EN_i = '1' then
            state <= 9;
          end if;

        when 9 =>

          if CLK_EN_i = '1' then
            state <= 0;
          end if;


        when others =>
          state <= 0;
      end case;
    end if;
  end process controller;






end RTL;


-- configurations
