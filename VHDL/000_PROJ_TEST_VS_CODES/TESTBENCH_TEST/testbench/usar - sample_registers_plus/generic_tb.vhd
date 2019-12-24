
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

-- test packages
--use work.RandomBasePkg.all;
--use work.RandomPkg.all;
--use work.CoveragePkg.all;
--use ieee.math_real.all;

-------------------------------------------------------------------------------

entity generic_tb is


end generic_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of generic_tb is


  -- component ports
  -- clock
  constant PERIOD_CLK_PPS    : time := 2 ms;     --  "1 s "
  constant SYS_CLK_PERIOD    : time := 10 ns;    -- 100 MHz
  constant SAMPLE_CLK_PERIOD : time := 65.1 us;  -- 15360 Hz
  constant NIOS_CLK_PERIOD   : time := 40 ns;    -- 25 MHz



-- uut signals

  signal reset_n              : std_logic                                                    := '0';
  signal data_input_available : std_logic                                                    := '0';
  signal data_input           : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0) := (others => '0');
  signal pps_input            : std_logic                                                    := '0';
  signal sample_address       : std_logic_vector(4 downto 0)                                 := (others => '0');
  signal sample_readdata      : std_logic_vector(31 downto 0)                                := (others => '0');
  signal sample_read          : std_logic                                                    := '0';
  signal sample_chipselect    : std_logic                                                    := '0';
  signal sample_writedata     : std_logic_vector(31 downto 0)                                := (others => '0');
  signal sample_write         : std_logic                                                    := '0';
  signal sample_irq           : std_logic                                                    := '0';

  signal clock_pps       : std_logic := '0';
  signal sysclk          : std_logic := '0';
  signal sample_clk      : std_logic := '0';
  signal sample_clk_sync : std_logic := '0';
  signal nios_clk        : std_logic := '0';
  signal nios_clk_sync   : std_logic := '0';
  signal clock_pps_sync  : std_logic := '0';



-- procedures e functions

  
begin


  -- clock generation
  sample_clk      <= not sample_clk       after SAMPLE_CLK_PERIOD/2;
  sample_clk_sync <= transport sample_clk after SYS_CLK_PERIOD/2;
  sysclk          <= not sysclk           after SYS_CLK_PERIOD/2;
  nios_clk        <= not nios_clk         after NIOS_CLK_PERIOD/2;
  nios_clk_sync   <= transport nios_clk   after SYS_CLK_PERIOD/2;
  clock_pps_sync  <= transport clock_pps  after SYS_CLK_PERIOD/2;


  -- geração do clock do pps
  clock_pps_gen : process
  begin
    clock_pps <= '0';
    wait for (PERIOD_CLK_PPS-SYS_CLK_PERIOD);
    clock_pps <= '1';
    wait for (SYS_CLK_PERIOD);
  end process;

  ---- geração das amostras 
  --p_random_generic_1 : entity work.p_random_generic
  --  generic map (
  --    SEED => 666,
  --    N    => (N_CHANNELS_ANA*N_BITS_ADC*2)
  --    )
  --  port map (
  --    clk         => sample_clk_sync,
  --    n_reset     => reset_n,
  --    random_vect => data_input);


  ---- gera um pulso de SYS_CLK_PERIOD quando ocorre uma mudança nas amostras
  --stimuli : process
  --begin
  --  wait until data_input'event;
  --  wait for SYS_CLK_PERIOD;
  --  data_input_available <= '1';
  --  wait for SYS_CLK_PERIOD;
  --  data_input_available <= '0';
  --end process;



  --WaveGen_Proc : process

  --  -- inicia - amostragem 5 e com sincronia
  --  procedure start_sync_5(do : in std_logic) is
  --  begin
  --    sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0011";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_sync_5;


    -- inicia - amostragem 16 e com sincronia
    procedure start_sync_16(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0111";
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_sync_16;


    -- inicia - limpa irq
    procedure limpa_irq(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(1, 5));
      sample_writedata <= x"0000000" & "0010";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure limpa_irq;



    -- inicia - para execução
    procedure para(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0000";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure para;



    -- inicia - para execução
    procedure start_nsync_5(do : in std_logic) is
    begin
      sample_address  <= std_logic_vector(to_unsigned(0, 5));
      sample_readdata <= x"0000000" & "0001";
      sample_read     <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_nsync_5;


    -- inicia - para execução
    procedure read_reg(do : in std_logic; address : in integer) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(address, 5));
      sample_writedata <= x"00000000";
      sample_write     <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_read       <= '1';
      else
        sample_chipselect <= '0';
        sample_read       <= '0';
      end if;
    end procedure read_reg;

    
    
  begin
    
    wait until reset_n = '1';
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    start_sync_16('1');
    --requisição com 1 periodos de clk
    wait for 2*NIOS_CLK_PERIOD;
    start_sync_16('0');
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    read_reg('1', 19);
    wait for 2*NIOS_CLK_PERIOD;
    read_reg('0', 19);
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    limpa_irq('1');
    wait for 2*NIOS_CLK_PERIOD;
    limpa_irq('0');
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    para('1');
    wait for 2*NIOS_CLK_PERIOD;
    para('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    start_nsync_5('1');
    wait for 2*NIOS_CLK_PERIOD;
    start_nsync_5('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    limpa_irq('1');
    wait for 2*NIOS_CLK_PERIOD;
    limpa_irq('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    para('1');
    report "PARA" severity note;
    wait for 2*NIOS_CLK_PERIOD;
    para('0');
    wait for 1 ms;
    
    
  end process;



  sample_register_1 : entity work.sample_register
    generic map (
      SAMPLE_MEMORY_SIZE => 20)
    port map
    (
      reset_n              => reset_n,
      coe_clk              => sysclk,
      coe_data_available_i => data_input_available,
      coe_data_i           => data_input,
      coe_pps_edge_i       => clock_pps_sync,


      clk            => nios_clk_sync,  -- clock do nios
      avs_address    => sample_address,
      avs_read       => sample_read,
      avs_readdata   => open,
      ins_irq        => open,
      avs_chipselect => sample_chipselect,
      avs_writedata  => sample_writedata,
      avs_write      => sample_write
      );



-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => reset_n
      );


-------------------------------------------------------------------------------
-- random time stimulus - reset
-------------------------------------------------------------------------------
  -- random_p : process
    -- variable seed1, seed2 	: positive;
    -- variable r		  		: real;
    -- variable int_rand	  	: integer;
    -- variable s_r_var 		: integer := 0; 
  -- begin
    -- uniform(seed1, seed2, r);
    -- s_r_var := integer(trunc(10.0*r));
    -- s_r <= s_r_var * 1 ms;
	-- wait until clkaq = '1';	
  -- end process;
 
  
  -- continuous and random reset generation
  -- reset_int_p : process
  -- begin
    -- wait until clkaq = '1';
    -- reset_int <= '0';
    -- wait for s_r;
    -- reset_int <= '1';
    -- wait for (2*CLK_AQ_PERIOD);
  -- end process;
  
    
  -- reset
  -- reset <= reset_int or reset_start;

  -- clock generation  
  -- clkaq <= not clkaq after CLK_AQ_PERIOD/2;

  ----initial reset generation
  -- reset_n_proc : process
  -- begin
    -- reset_start <= '1';
    -- wait for 10*CLK_AQ_PERIOD;
    -- reset_start <= '0';
    -- wait for 50_000 ms;
  -- end process;
  
  
 --reset_n_proc : process
 -- begin
 --   reset_n <= '0';
 --   wait for 10*SYS_CLK_PERIOD;
 --   reset_n <= '1';
 --   wait for 50_000 ms;
 -- end process;

--reset_n:  process
--  begin    
--    reset_n <= '0';
--    wait for 10*SYS_CLK_PERIOD;
--    reset_n <= '1';
--    wait for 50_000 ms;
--  end process;
    

	

end generic_tb_rtl;

-------------------------------------------------------------------------------
-- forma de onda triangular

  --estimulo : process(sysclk)
  --  constant COUNT_MAX : natural := (MAX_VALUE);
  --  variable counter   : integer := 0;
  --  variable sample    : natural := 0;
  --  variable operador  : integer := 0;

  --begin
  --  if rising_edge(sysclk) then
  --    if sample_available_i = '1' then
  --      counter := counter + operador;
  --      if counter = COUNT_MAX then
  --        operador := -1;
  --      elsif counter = 0 then
  --        operador := 1;
  --      end if;
  --    end if;
  --    amostra <= std_logic_vector(to_unsigned(counter, SAMPLE_SIZE));
  --  end if;
  --end process estimulo;





-------------------------------------------------------------------------------
-- exemplo clock com jitter - bilbioteca math_real
-------------------------------------------------------------------------------
--signal d : time := 0 ns;
--signal clock : std_logic := '0';
--signal sys_clk : std_logic := '0';
--constant SYS_CLK_PERIOD: time:= 10 ns;


--  sys_clk_process:  process
--    -- variables for uniform
--     variable seed1, seed2 : positive;
--     variable r : real;
--     variable int_rand : integer;

--  begin
--    int_rand := integer(trunc(r*3.0));
--    uniform(seed1, seed2, r);
--    d <= int_rand * 1 ns;
--    wait for SYS_CLK_PERIOD/2;
--    clock <= '0';
--    wait for SYS_CLK_PERIOD/2;
--    clock <= '1'; 
--end process;

--sys_clk <= transport clock after d ;

-------------------------------------------------------------------------------
-- clock com jitter
------------------------------------------------------------------------------- 
	
	-- sys_clk_process:  process
		-- variable seed5, seed6 : positive;
		-- variable r : real;
		-- variable int_rand : integer;
	-- begin
		-- int_rand := integer(trunc(r*3.0));
		-- uniform(seed5, seed6, r);
		-- d <= int_rand * 1 ns;
		-- wait for CLK_AQ_PERIOD/2;
		-- clock <= '0';
		-- wait for CLK_AQ_PERIOD/2;
		-- clock <= '1'; 
	-- end process sys_clk_process;
	
	-- clkaq_jitter <=  transport (not clock) after d;	 

-----------------------------------------------------------------------------------------------
-- Testbench Clock Generation
-----------------------------------------------------------------------------------------------
--clk_gen : process
--begin
--   loop
--       clk<='0' ,
--           '1'  after HALF_CYCLE;
--       wait for HALF_CYCLE*2;
--   end loop;
--end process;



-----------------------------------------------------------------------------------------------
-- Output text file
-----------------------------------------------------------------------------------------------
--testbench_o : process(clk) 
--file sin_file                 : text open write_mode is "fsin_o_vhdl_nco_altera.txt";
--variable ls                   : line;
--variable sin_int      : integer ;

--  begin
--    if rising_edge(clk) then
--      if(reset_n='1' and out_valid='1') then
--        sin_int := conv_integer(sin_val);
--        write(ls,sin_int);
--        writeline(sin_file,ls);
--     end if;          
--      end if;         
--end process testbench_o;

-------------------------------------------------------------------------------
-- random time stimulus - sincin
-------------------------------------------------------------------------------
  -- random_s : process
    -- variable seed3, seed4 : positive;
    -- variable r		  	: real;
    -- variable int_rand	  : integer;
    -- variable s_r_var : integer := 0; 
  -- begin
    -- uniform(seed3, seed4, r);
    -- s_r_var := integer(trunc(1000.0*r));
    -- s_sincin <= s_r_var * 1 us;
	-- wait until clkaq = '1';	
  -- end process;  
  
----sincin stimulus
  -- sincin_stim : process
  -- begin
    -- wait until clkaq = '1';
    -- sincin_i <= '0';
    -- wait for s_sincin;
    -- sincin_i <= '1';
    -- wait for 1*CLK_AQ_PERIOD;
    -- sincin_i <= '0';  
  -- end process;	
	

-----------------------------------------------------------------------------------------------
-- Geraçao de estimulos -  exemplos 
-----------------------------------------------------------------------------------------------


--wait on teste;
--wait until x = 5; -- espera ate que a condição x = 5 seja verdadeira (espera
--mudança)
--wait for 25 ns;
--wait until now = t;
--wait on s until p = '1' for t;  -- espera mudança em s enquanto p diferente de '1', ou até t
--wait on s until s = '1' – rising_edge



--WaveGen_Proc : process
--begin
--  wait until n_reset = '1';
--  n_point_samples <= "10000000000";     -- 1024
--  for i in 1 to maxN_Points+1 loop      -- manda 1025 amostras
--    wait for sys_clk_period;
--    data_input     <= x"FFFFFFFF";
--    wait for sys_clk_period;
--    data_available <= '1';
--    wait for sys_clk_period;
--    data_available <= '0';
--  end loop;
--  wait for 1 ms;
--end process;


--WaveGen_Proc : process
--begin
--  wait until n_reset = '1';
--  n_point_samples <= "00000000010";     -- 2 amostras
--  for i in 1 to maxN_Points+1 loop      -- manda 3 amostras
--    wait for sys_clk_period;
--    data_input     <= x"00000005";
--    wait for sys_clk_period;
--    data_available <= '1';
--    wait for sys_clk_period;
--    data_available <= '0';
--  end loop;
--  wait for 1 ms;
--end process;



--Char: std_logic_vector(c-1 downto 0):= (OTHERS => '0');
--...
--gen_stimuli1: process
--      begin     
--              for i in 0 to (2**c)-1 loop
--                      char <= std_logic_vector(unsigned(char) + 1);
--              end loop;  
--              wait for 10 ns;  
--end process; 
--...


--Geraçao de relogio com razao ciclica diferente de 0,5 – exemplo

--...
--constant PERIOD: TIME := 1 ms; 
--constant DUTY_CYCLE: REAL := 0.4; 
--...

--clock: process
--      begin
--      clockdiv <= '0';
--      wait for (PERIOD-(PERIOD*DUTY_CYCLE));
--      clockdiv <= '1';
--      wait for (PERIOD*DUTY_CYCLE);
--end process;


-- geração de um pulso com tamanho e periodicidade ajustaveis

--...
--constant PERIOD: TIME := 1 ms; 
--constant PULSE_PERIOD: TIME := 10 ns; 
--...

--clock: process
--      begin
--      clockdiv <= '0';
--      wait for (PERIOD-PULSE_PERIOD);
--      clockdiv <= '1';
--      wait for (PULSE_PERIOD);
--end process;


-----------------------------------------------------------------------------------------------
-- Monitoramento da saida
-----------------------------------------------------------------------------------------------
--monitor : process
--begin
--  wait until rising_edge(a);
--  wait for 2 ns;                        -- simulacao do atraso de propagacao
--  case cont_vect is
--    when 1      => assert y = '0' report "y diferente do valor esperado" severity warning;
--    when 2      => assert y = '1' report "y diferente do valor esperado" severity warning;
--    when 3      => assert y = '0' report "y diferente do valor esperado" severity warning;
--    when 4      => assert y = '0' report "y diferente do valor esperado" severity warning;
--    when others => null;
--  end case;

--end process monitor;



---- verificação
--verification : process
--begin
--  wait until (coe_data_ready_in = '1');
--  wait for 5*sys_clk_period;
--  if avs_writedata(0) = '1' then
--    assert signed(vn_out) = (signed(va_in) + signed(vb_in) + signed(vc_in)) report "Problema na soma após a requisição para somar do linux" severity error;
--  end if;
--end process;



--process
--begin
--      assert a = b 
--              report "a e b não são iguais"
--                      severity WARNING;
--      wait on a,b;
--end process;



-- função de leitura de arquivos 
--impure function input_txt (ram_file_name : in string) return matrix is   
--   file ram_file  : text is in ram_file_name; 
--      variable linha : line;                                 
--      variable i: natural := 1;      
--      variable str: std_logic_vector(largura-1 downto 0);  
--      variable matriz: matrix;                        
--            begin
--              loop1: while not endfile(ram_file) loop                                                 
--                escr_linha: for i in 1 to altura loop                                         
--                 readline(ram_file,linha);
--                      read (linha, str);
--                      matriz(i) := str;
--                     end loop escr_linha;                                                     
--              end loop loop1;            
--              return matriz;            
--       end function input_txt;


-- procedimento de escrita de arquivos
--procedure output_txt (ram_file_name : in string;  vetor: in std_logic_vector(largura-1 downto 0);
--              cont: in natural range 1 to altura; agora: time) is     
--      file file_out : TEXT open APPEND_MODE is ram_file_name; --WRITE_MODE ou READ_MODE    
--      variable linha : line;          
--      begin                                   
--              write(linha, vetor); 
--              write(linha, string'(" @ "));
--              write(linha, agora);
--                writeline(file_out, linha);           
--              if  cont = altura then           
--              write(linha, string'("Fim do arquivo de estimulos"));
--              writeline(file_out, linha);
--              end if;                          
-- end procedure output_txt;    







configuration generic_tb_rms_tb_rtl_cfg of generic_tb is
  for generic_tb_rtl
  end for;
end generic_tb_rms_tb_rtl_cfg;
