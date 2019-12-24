library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;



entity dds is
  generic(
    largura_ac      : natural := 24;
    largura_sen_rom : natural := 8;    -- não pode ser maior que largura pwm
    tabela_seno     : string  := "full_sin.txt";
    largura_pwm     : natural := 8;
    divisao_freq    : natural := 10
    );  
  -- master clock - 100E6 Hz
  port (

    reset         : in  std_logic;
    clk           : in  std_logic;
    FCW           : in  std_logic_vector(largura_ac-1 downto 0) := (others => '0');
    to_filter     : out std_logic;
    to_filter_dac : out std_logic;
    sen_out       : out std_logic_vector(largura_sen_rom-1 downto 0);
    square_out    : out std_logic
    );

end entity;


architecture teste_arq of dds is


-- dados
  signal BUS_A1po_A2addr : std_logic_vector(largura_ac-1 downto 0)  := (others => '0');
  signal BUS_A2qreg_A3d  : std_logic_vector(largura_pwm-1 downto 0) := (others => '0');

--
-- controle
-- 
  signal start_pwm       : std_logic;
  signal stop_pwm        : std_logic;
  signal slow_clock      : std_logic;


  
--configuração de arquiteturas




begin

  --saida onda quadrada
  square_out <= BUS_A1po_A2addr(BUS_A1po_A2addr'high);
  sen_out <= BUS_A2qreg_A3d;
  
  A1_acumulador : entity work.acumulador(acc_arq)
    generic map (largura_ac)
    port map (slow_clock, FCW, open, BUS_A1po_A2addr);
  
  A2_sen_rom : entity work.sen_rom(sen_rom_onda_completa)
    generic map (largura_sen_rom, tabela_seno)
    port map (
      clk   => clk,
      addr  => BUS_A1po_A2addr(largura_ac-1 downto largura_ac-largura_sen_rom),  -- mapeamento MSB 
      q     => open,
      q_reg => BUS_A2qreg_A3d(largura_sen_rom-1 downto 0)  -- mapeamento LSB                                                                                                            
      );

  A3_pwm : entity work.pwm(PWM_arq)
    generic map (largura_pwm)
    port map (
      start       => start_pwm,
      stop        => stop_pwm,
      reset       => reset,
      clk         => clk,
      d           => BUS_A2qreg_A3d,
      pwm_out     => open,
      pwm_reg_out => to_filter
      );                

  A0_clock_div : entity work.clock_div(divide)
    generic map (divisao_freq)
    port map (clk, slow_clock);
  
  
  
  dac : entity work.sigma_delta
    generic map (n => largura_pwm)
    port map (
      enable  => '1',
      CLK     => clk,
      CLR     => reset,
      input   => BUS_A2qreg_A3d,
      dac_out => to_filter_dac);

  
  
  start_pwm <= '1';
  stop_pwm  <= '0';
  
end teste_arq;










