
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity arith_ctrl_tb is


end arith_ctrl_tb;

-------------------------------------------------------------------------------

architecture arith_ctrl_tb_ARQ of arith_ctrl_tb is


  -- component ports
  -- clock
  
  constant SYS_CLK_PERIOD    : time := 10 ns;     -- 100 MHz
  constant SAMPLE_CLK_PERIOD : time := 208.3 us;  -- 4800 Hz


-- uut signals


  constant MEM_BUFFER_SIZE : natural := 4;
  constant SAMPLE_SIZE     : natural := 8;



  signal sysclk      : std_logic                                := '0';
  signal reset_n     : std_logic                                := '0';
  signal sample_i    : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');
  signal read_req_i  : std_logic                                := '0';
  signal write_req_i : std_logic                                := '0';
  signal sample_out  : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');
  signal writing     : std_logic                                := '0';
  signal reading     : std_logic                                := '0';



  signal sample_clk           : std_logic := '0';
  signal sample_clk_sync      : std_logic := '0';
  signal data_input_available : std_logic := '0';
  signal data_input           : std_logic_vector(SAMPLE_SIZE-1 downto 0);


  
begin

 
  process
  begin
    loop
      wait until sysclk = '1';    
      data_input_available <= '1';
      wait for SYS_CLK_PERIOD;
      data_input_available <= '0';
      wait for 15 us;
    end loop;
  end process;


  -- clock generation
  sysclk          <= not sysclk           after SYS_CLK_PERIOD/2;
  sample_clk      <= not sample_clk       after SAMPLE_CLK_PERIOD/2;
  sample_clk_sync <= transport sample_clk after SYS_CLK_PERIOD/2;


  -- geração das amostras 
  p_random_generic_1 : entity work.p_random_generic
    generic map (
      SEED => 200,
      N    => (SAMPLE_SIZE)
      )
    port map (
      clk         => sample_clk_sync,
      n_reset     => reset_n,
      random_vect => data_input);

  

  arith_ctrl_1 : entity work.arith_ctrl
    generic map (
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SAMPLE_SIZE     => SAMPLE_SIZE,
      ACC_BITS        => 8)
    port map (
      sysclk           => sysclk,
      reset_n          => reset_n,
      data_i           => data_input,
      data_o           => open,
      data_available_i => data_input_available,
      ready            => open);



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


end arith_ctrl_tb_ARQ;

-------------------------------------------------------------------------------



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




