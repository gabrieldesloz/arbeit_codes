-------------------------------------------------------------------------------
-- Title      : Jiga de testes Q30
-- Project    : 
-------------------------------------------------------------------------------
-- File       : measurement_module_top.vhd
-- Author     :   <gdl@IXION>
-- Company    : 
-- Created    : 2012-09-26
-- Last update: 2013-03-20
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: modulo de medição, calcula RMS e frequencia conforme valores
-- dos ADs  
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-26  1.0      gdl	Created
-------------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;


entity measurement_module_top is
  generic (
    ADC_BITS    : natural := 8;
    PERIOD_BITS : natural := 16
    );  

  port (
    sysclk  : in  std_logic;
    reset_n : in  std_logic;
    ch_in   : in  std_logic_vector(ADC_BITS-1 downto 0);
    period  : out std_logic_vector(PERIOD_BITS-1 downto 0);
    rel_mag : out std_logic_vector(ADC_BITS-1 downto 0)
    );

end entity measurement_module_top;



architecture mm_top_ARQ of measurement_module_top is

  signal period_int        : std_logic_vector(period'range);
  signal rel_mag_int       : std_logic_vector(ch_in'range);
  signal filter1_ch_in_reg : std_logic_vector(ch_in'range); 
  signal filter2_ch_in_reg : std_logic_vector(ch_in'range);
  signal filter3_ch_in_reg : std_logic_vector(ch_in'range);
  signal filter1_ch_in_next : std_logic_vector(ch_in'range);
  signal filter2_ch_in_next : std_logic_vector(ch_in'range);
  signal filter3_ch_in_next : std_logic_vector(ch_in'range);
  

begin


   process(sysclk,reset_n)
     begin
       if reset_n = '0' then
         filter1_ch_in_reg <= (others => '0');
         filter2_ch_in_reg <= (others => '0');
         filter3_ch_in_reg <= (others => '0');
       elsif rising_edge(sysclk) then
         filter1_ch_in_reg <= filter1_ch_in_next;
         filter2_ch_in_reg <= filter2_ch_in_next;
         filter3_ch_in_reg <= filter3_ch_in_next;        
       end if;
     end process;     
       

   period <= period_int;
   rel_mag <= rel_mag_int;

 
  frequency_zero_crossing_1 : entity work.frequency_zero_crossing
    generic map (
      N_POINTS_BITS => PERIOD_BITS
      )    
    port map (
      sysclk        => sysclk,
      reset_n       => reset_n,
      sample_signal => ch_in(ch_in'high),
      new_sample    => '1',
      period_out    => period_int,
      period_ok_out => open);

   
  rms_1 : entity work.rms
    generic map (
      N_BITS_INPUT  => ADC_BITS,
      N_POINTS_BITS => PERIOD_BITS
      )
    port map (
      sysclk          => sysclk,
      reset_n         => reset_n,
      data_input      => filter3_ch_in_reg ,
      data_available  => '1',
      n_point_samples => period_int,
      data_output     => rel_mag_int,
      data_ready      => open);



   ----------------------------------------------------------------------------
   -- Offset filter
   -- retira o offset (128)
   -- o conversor adc930e utiliza conversão straigh binary, portanto é necessário
   -- fazer o complemento de 2 (inverter bit mais significativo)
   ----------------------------------------------------------------------------

  dc_filter : process(filter1_ch_in_reg,ch_in)
  begin
    if ch_in >= 128 then
      filter1_ch_in_next <= (ch_in - 128) ;
      filter2_ch_in_next <= not filter1_ch_in_reg;
    else
      filter1_ch_in_next  <= ch_in;
      filter2_ch_in_next  <= filter1_ch_in_reg;
    end if;
  end process;

   filter3_ch_in_next <= ('0' & not filter2_ch_in_reg(6 downto 0)); 

  -----------------------------------------------------------------------------
   


end architecture mm_top_ARQ;



-- "10000000" xor ch_in
-- complement2_ch_in <= (not ch_in(ch_in'high)) & ch_in(ADC_BITS-2 downto 0); 

  --max_min_reg_1 : entity work.max_min_reg
  --  generic map (
  --    ADC_BITS => ADC_BITS)
  --  port map (
  --    wave_in => ch_in,
  --    n_reset => reset_n,
  --    sysclk  => sysclk,
  --    max     => max,
  --    min     => min);

--testes--
-- complement_ch_in <= not '1' & ch_in(ADC_BITS-2 downto 0);
-- complement_ch_in <= ch_in;
-- teste onda quadrada com aplitude máxima -- funciona

 
-- complement2_ch_in <= (max - min)  when ch_in(ch_in'high) = '1' else x"00";

  --invertendo a ordem dos bits
  --process(ch_in)
  --begin
  --  for i in ch_in'range loop
  --    inv_ch_in(inv_ch_in'left - i) <= ch_in(i);
  --  end loop;
  --end process;

  






