


-- armazenamento em forma de registradores
-- disponibilização ao SO de amostras analogicas, seleção entre amostras de
-- proteção e monitoração
-- qual o efeito do registro de todos os sinais de entrada?


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

--- analog channel constants
--  constant N_CHANNELS_ANA          : natural := 16;
--  constant N_CHANNELS_COUNTER_BITS : natural := 4;
--  constant N_BITS_ADC              : natural := 16;

entity sample_register is
  
  port (
    reset_n              : in std_logic;
    sysclk               : in std_logic;
    data_input_available : in std_logic;
    data_input           : in std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
    --data_input           : in std_logic_vector((512 - 1) downto 0);
    pps_input            : in std_logic;

    sample_clk        : in  std_logic;
    sample_address    : in  std_logic_vector(4 downto 0);
    sample_readdata   : out std_logic_vector(31 downto 0);
    sample_read       : in  std_logic;
    sample_chipselect : in  std_logic;
    sample_writedata  : in  std_logic_vector(31 downto 0);
    sample_write      : in  std_logic;
    sample_irq        : out std_logic

    );

end sample_register;


architecture sample_register_struct of sample_register is


  type SAMPLE_TYPE is (INIT, WAIT_GOOD_TO_GO, SYNC, WAIT_COUNTER, ACQUIRE, IRQ_GEN, DUMMY1, DUMMY0);
  type SAMPLE_MEMORY is array (integer range <>) of std_logic_vector(31 downto 0);
  signal sample_state      : SAMPLE_TYPE;
  signal sample_state_next : SAMPLE_TYPE;

  -- criação da matriz de registradores
  signal REGISTERS : SAMPLE_MEMORY(17 downto 0);  -- matriz de 2**18 posições (262_144)
                                                  -- de 32 bits

  signal input_register      : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
  signal input_register_next : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);


  signal wr_en : std_logic;
  signal rd_en : std_logic;

  signal irq      : std_logic;
  signal irq_next : std_logic;

  signal counter      : std_logic_vector(3 downto 0);
  signal counter_next : std_logic_vector(3 downto 0);

  -- indica que o algoritmo iniciou (FSM)
  signal started      : std_logic;
  signal started_next : std_logic;


  --atribui com alias, os dois primeiros registradores como os de cotnrole e status
  alias control_reg : std_logic_vector(31 downto 0) is REGISTERS(0);
  alias status_reg  : std_logic_vector(31 downto 0) is REGISTERS(1);

  


  
begin

  -- habilita a escrita
  wr_en <= '1' when sample_write = '1' and sample_chipselect = '1' else '0';
  -- habilita a leitura
  rd_en <= '1' when sample_read = '1' and sample_chipselect = '1'  else '0';

  --irg
  sample_irq <= irq;


  -- registrador sample_data
  -- atribuição de "zeros" e valores de proximo estado

  process (sample_clk, reset_n)
  begin
    if reset_n = '0' then

      --zera saida
      sample_readdata <= x"00000000";

      -- zera matriz de vetores
      for i in 0 to REGISTERS'length-1 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i
      
    elsif rising_edge(sample_clk) then  -- rising clock edge

      for i in 2 to REGISTERS'length-1 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= input_register(((i-2)*32)+j);
        end loop;  -- j
      end loop;  -- i

      -- habilita a leitura do registrador conforme o endereço passado pelo
      -- nios (sample_address) 
      if rd_en = '1' then
        sample_readdata <= REGISTERS(to_integer(unsigned(sample_address)));
      end if;

      -- habilita a escrita no registrador
      if wr_en = '1' then
        REGISTERS(to_integer(unsigned(sample_address))) <= sample_writedata;
      end if;

      if started = '1' then
        status_reg(1) <= '0';
      end if;
      status_reg(0) <= irq_next;
    end if;
  end process;



  -- registrador sinais de controle
  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then
      sample_state   <= INIT;
      irq            <= '0';
      counter        <= (others => '0');
      input_register <= (others => '0');
      started        <= '0';
    elsif rising_edge(sysclk) then
      sample_state   <= sample_state_next;
      irq            <= irq_next;
      counter        <= counter_next;
      input_register <= input_register_next;
      started        <= started_next;
    end if;
  end process;


  process (control_reg, counter, data_input, data_input_available,
           input_register, irq, pps_input, sample_state, started, status_reg)
  begin  -- process
    sample_state_next   <= sample_state;
    irq_next            <= irq;
    counter_next        <= counter;
    input_register_next <= input_register;
    started_next        <= started;

    case sample_state is

      when INIT =>

        -- Inicializa as variaveis e vai pro GOOD_TO_GO
        
        irq_next            <= '0';
        started_next        <= '0';
        counter_next        <= (others => '0');
        input_register_next <= (others => '0');
        sample_state_next   <= WAIT_GOOD_TO_GO;
        
        
      when WAIT_GOOD_TO_GO =>


        -- Le o bit0 do registrador de controle para saber se pode iniciar e
        -- vai para o sync


        if control_reg(0) = '1' then
          if control_reg(1) = '1' then
            sample_state_next <= SYNC;
          else
            sample_state_next <= WAIT_COUNTER;
          end if;
        end if;

      when SYNC =>


        -- Espera chegar um PPS e pula direto pro cara que pega a amostra
        if pps_input = '1' then
          sample_state_next <= WAIT_COUNTER;
          if control_reg(2) = '0' then
            counter_next <= "0100";
          else
            counter_next <= "1111";
          end if;
          
        end if;


      when WAIT_COUNTER =>

        -- inicia depois de limpar
        if status_reg(1) = '1' then
          irq_next     <= '0';
          started_next <= '1';
        end if;


        -- se o modulo nao estiver habilitado, volta para o inicio
        if control_reg(0) = '0' then
          sample_state_next <= INIT;
        -- se houver uma nova informação na entrada
        elsif data_input_available = '1' then

          -- amostra a cada 4 / 16 amostras, conforme controle
          if counter = "0100" and control_reg(2) = '0' then
            sample_state_next <= ACQUIRE;
            started_next      <= '1';
          elsif counter = "1111" and control_reg(2) = '1' then
            sample_state_next <= ACQUIRE;
            started_next      <= '1';
          else
            counter_next <= std_logic_vector(unsigned(counter) + 1);
          end if;
        end if;
        -- Conta o numero de amostras que vão ser deixadas antes de aquisitar
        -- dai vai pro cara que aquisita de verdade

      when ACQUIRE =>
        -- faz a aquisição
        input_register_next <= data_input;
        sample_state_next   <= IRQ_GEN;
        -- Salva a entrada nos lugares certos da memoria e vai pra geração da interrupção

      when IRQ_GEN =>
        -- gera o irq
        irq_next          <= '1';
        counter_next      <= (others => '0');
        started_next      <= '0';
        sample_state_next <= WAIT_COUNTER;
        -- Seta o sinal da IRQ e depois vai pro WAIT_COUNTER


      when others =>
        sample_state_next <= INIT;
    end case;
  end process;
  


  
end sample_register_struct;
