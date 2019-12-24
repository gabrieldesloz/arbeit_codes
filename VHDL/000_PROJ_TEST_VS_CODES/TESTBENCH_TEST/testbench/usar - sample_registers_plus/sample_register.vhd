

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity sample_register is

  generic (
    SAMPLE_MEMORY_SIZE : natural := 20
    );

  port (
    reset_n              : in std_logic;
    coe_clk              : in std_logic;
    coe_data_available_i : in std_logic;
    coe_data_i           : in std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
    coe_pps_edge_i       : in std_logic;

    clk            : in  std_logic;
    avs_address    : in  std_logic_vector(4 downto 0);
    avs_readdata   : out std_logic_vector(31 downto 0);
    avs_read       : in  std_logic;
    avs_chipselect : in  std_logic;
    avs_writedata  : in  std_logic_vector(31 downto 0);
    avs_write      : in  std_logic;
    ins_irq        : out std_logic

    );

end sample_register;


architecture sample_register_struct of sample_register is


  signal addr_a_tmp : integer range 0 to (avs_address'length**2)-1;

  type SAMPLE_MEMORY is array (integer range <>) of std_logic_vector(31 downto 0);
  signal REGISTERS : SAMPLE_MEMORY(SAMPLE_MEMORY_SIZE-1 downto 0);


-- maquina 1
  type SAMPLE_TYPE is (INIT, SYNC, WAIT_GOOD_TO_GO, WAIT_COUNTER, ACQUIRE, IRQ_GEN);

  signal sample_state      : SAMPLE_TYPE;
  signal sample_state_next : SAMPLE_TYPE;

  attribute syn_encoding                : string;
  attribute syn_encoding of SAMPLE_TYPE : type is "safe";

-- maquina 2 - pps flag
  type STATE_PPS_TYPE is (WAIT_PPS, WAIT_NEW_SAMPLE, WAIT_CLEAR_FLAG);

  signal state_pps_reg  : STATE_PPS_TYPE;
  signal state_pps_next : STATE_PPS_TYPE;

  attribute syn_encoding of STATE_PPS_TYPE : type is "safe";


  signal input_register      : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
  signal input_register_next : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);


  signal wr_en : std_logic;
  signal rd_en : std_logic;

  signal irq      : std_logic;
  signal irq_next : std_logic;

  signal counter      : std_logic_vector(3 downto 0);
  signal counter_next : std_logic_vector(3 downto 0);

  signal started      : std_logic;
  signal started_next : std_logic;

  alias control_reg : std_logic_vector(31 downto 0) is REGISTERS(0);
  alias status_reg  : std_logic_vector(31 downto 0) is REGISTERS(1);

  signal pps_pulse_next, pps_pulse_reg             : std_logic;
  signal counter_samples_reg, counter_samples_next : std_logic_vector(63 downto 0);

  signal sampled_data_available : std_logic;
  
  
begin  -- sample_register_struct

  wr_en <= '1' when avs_write = '1' and avs_chipselect = '1' else '0';
  rd_en <= '1' when avs_read = '1' and avs_chipselect = '1'  else '0';

  ins_irq <= irq;

  process (clk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      avs_readdata <= x"00000000";

      for i in 0 to REGISTERS'length-1 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i
      
    elsif rising_edge(clk) then         -- rising clock edge      

      -- assinalamento range mais significativo - com flag de pps codificado
      REGISTERS(SAMPLE_MEMORY_SIZE-1) <= counter_samples_reg(63 downto 32);
      -- range menos significativo
      REGISTERS(SAMPLE_MEMORY_SIZE-2) <= counter_samples_reg(31 downto 0);

      -- assinalamento do restante dos vetores
      for i in 2 to REGISTERS'length-3 loop
        for j in 0 to 31 loop
          REGISTERS(i)(j) <= input_register(((i-2)*32)+j);
        end loop;  -- j
      end loop;  -- i

      -- acesso aos registradores
      if rd_en = '1' then
        avs_readdata <= REGISTERS(to_integer(unsigned(avs_address)));
      end if;

      if wr_en = '1' then
        REGISTERS(to_integer(unsigned(avs_address))) <= avs_writedata;
      end if;

      if started = '1' then
        status_reg(1) <= '0';
      end if;
      status_reg(0) <= irq_next;
      
    end if;
  end process;


  process (coe_clk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      pps_pulse_reg       <= '0';
      sample_state        <= INIT;
      state_pps_reg       <= WAIT_PPS;
      irq                 <= '0';
      counter             <= (others => '0');
      input_register      <= (others => '0');
      started             <= '0';
      counter_samples_reg <= (others => '0');
    elsif rising_edge(coe_clk) then     -- rising clock edge
      state_pps_reg       <= state_pps_next;
      pps_pulse_reg       <= pps_pulse_next;
      sample_state        <= sample_state_next;
      irq                 <= irq_next;
      counter             <= counter_next;
      input_register      <= input_register_next;
      started             <= started_next;
      counter_samples_reg <= counter_samples_next;
    end if;
  end process;

  process (control_reg, counter, counter_samples_reg,
           coe_data_i, coe_data_available_i, input_register, irq,
           pps_pulse_reg, sample_state, started, status_reg, coe_pps_edge_i)

    
  begin  -- process
    sample_state_next      <= sample_state;
    irq_next               <= irq;
    counter_next           <= counter;
    input_register_next    <= input_register;
    started_next           <= started;
    counter_samples_next   <= counter_samples_reg;
    sampled_data_available <= '0';

    case sample_state is

      when INIT =>
        irq_next            <= '0';
        started_next        <= '0';
        counter_next        <= (others => '0');
        input_register_next <= (others => '0');
        sample_state_next   <= WAIT_GOOD_TO_GO;

      when WAIT_GOOD_TO_GO =>
        if control_reg(0) = '1' then
          if control_reg(1) = '1' then
            sample_state_next <= SYNC;
          else
            sample_state_next <= WAIT_COUNTER;
          end if;
        end if;
        -- Le o bit0 do registrador de controle para saber se pode iniciar e
        -- vai para o sync

      when SYNC =>
        -- espera a sincronia
        if coe_pps_edge_i = '1' then
          sample_state_next <= WAIT_COUNTER;
          -- comeÁa j· aquisitando uma amostra
          if control_reg(2) = '0' then
            counter_next <= "0100";
          else
            counter_next <= "1111";
          end if;
        end if;

        

      when WAIT_COUNTER =>
        -- Conta o numero de amostras que v√£o ser deixadas antes de aquisitar
        -- entao vai pro estado que faz a aquisi√ß√£o
        

        if status_reg(1) = '1' then
          irq_next     <= '0';
          started_next <= '1';
        end if;

        if control_reg(0) = '0' then
          sample_state_next <= INIT;
        elsif coe_data_available_i = '1' then
          
          if counter = "0100" and control_reg(2) = '0' then
            sampled_data_available <= '1';
            sample_state_next      <= ACQUIRE;
            started_next           <= '1';
          elsif counter = "1111" and control_reg(2) = '1' then
            sampled_data_available <= '1';
            sample_state_next      <= ACQUIRE;
            started_next           <= '1';
          else
            counter_next <= std_logic_vector(unsigned(counter) + 1);
          end if;
        end if;


      when ACQUIRE =>
        -- Salva a entrada nos lugares certos da memoria e vai pra geracao da interrupcao
        -- contador das amostras
        counter_samples_next <= pps_pulse_reg & std_logic_vector(unsigned(counter_samples_reg(62 downto 0)) + 1);

        input_register_next <= coe_data_i;
        sample_state_next   <= IRQ_GEN;


      when WRITE =>
        


      when IRQ_GEN =>
        -- Seta o sinal da IRQ e depois vai pro WAIT_COUNTER        
        irq_next          <= '1';
        counter_next      <= (others => '0');
        started_next      <= '0';
        sample_state_next <= WAIT_COUNTER;


      when others =>
        sample_state_next <= INIT;
    end case;
  end process;



-- maquina que processa o flag pps
  process(coe_data_available_i, pps_pulse_reg, state_pps_reg,
          coe_pps_edge_i, sampled_data_available)
  begin

    state_pps_next <= state_pps_reg;
    pps_pulse_next <= pps_pulse_reg;

    case state_pps_reg is
      when WAIT_PPS =>

        if coe_pps_edge_i = '1' then
          state_pps_next <= WAIT_NEW_SAMPLE;
        end if;

      when WAIT_NEW_SAMPLE =>

        if sampled_data_available = '1' then
          pps_pulse_next <= '1';
          state_pps_next <= WAIT_CLEAR_FLAG;
        end if;

      when WAIT_CLEAR_FLAG =>

        if coe_data_available_i = '1' then
          pps_pulse_next <= '0';
          state_pps_next <= WAIT_PPS;
        end if;
        
      when others =>
        state_pps_next <= WAIT_PPS;
    end case;

  end process;





  --sample_register_fifo_1 : entity work.sample_register_fifo
  --  port map (
  --    aclr  => '0',
  --    wrreq => sampled_data_available,
  --    data  => coe_data_i,
  --    wrclk => coe_clk,

  --    rdclk => clk,
  --    rdreq => rd_en,
  --    q     => open);




--  -- evitar conflito na escrita quando o mesmo endereÁo È acessado nas duas portas
--  true_dual_port_ram_dual_clock_1 : entity work.true_dual_port_ram_dual_clock
--    generic map (
--      DATA_WIDTH => 32,
--      ADDR_WIDTH => 20)
--    port map (
--      clk_a  => clk,
--      addr_a => addr_a_tmp,
--      data_a => avs_writedata,
--      we_a   => wr_a,
--      q_a    => q_a,

--      clk_b  => coe_clk,
--      addr_b => addr_b_tp,
--      data_b => coe_data_i(31 downto 0),
--      we_b   => sampled_data_available,
--      q_b    => q_b);




---- 
---- decodificador de prioridade para a escrita na memoria
---- regula a escrita na memoria
----
  
--  process()
--  begin
--    if (addr_a_tmp = addr_b_tmp) then
--      if wr_en = '1' then
--        we_a <= '1';
--        we_b <= '0';
--      else
--        we_a <= '0';
--        we_b <= '1';
--      end if;      
--    else
--      we_a <= sampled_data_available;
--      we_b <= wr_en;
--    end if;
--  end process;




--  --   
--  ---- regular a leitura na memoria
--  --   





--process()
--  begin


--    case read_state_fsm is
--      when  IDLE => ;
--         if coe_pps_edge then
                    
--          end if;           
--      when others => null;
--    end case;

 
--  avs_readdata <= q_a when rd_en = '1' else (others => '0');
--  addr_a_tmp   <= to_integer(unsigned(avs_address));
--  addr_b_tmp   <= to_integer(unsigned(vhdl_address));
  

 end sample_register_struct;
