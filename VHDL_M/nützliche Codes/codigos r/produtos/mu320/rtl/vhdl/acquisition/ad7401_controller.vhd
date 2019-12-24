-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : AD7401 controller
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : ad7401_controller.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2012-08-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:   ADC AD7401 controller - sinc3
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-25   1.0      CLS     Created
-------------------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mu320_constants.all;

entity ad7401_controller is

  
  port (
    -- general signals
    n_reset : in std_logic;
    sysclk  : in std_logic;

    -- delta sigma clock
    ds_clk : in std_logic;

    -- adc signals
    mdat : in std_logic;

    -- interface signals
    adc_data : out std_logic_vector(15 downto 0);  -- converted data
    ready    : out std_logic                       -- end of conversion
    );


end entity ad7401_controller;


architecture ad7401_controller_rtl of ad7401_controller is

  constant BOUT           : natural := 24;
  attribute ENUM_ENCODING : string;

  type DS_ERROR_STATE_TYPE is (NORMAL_STATE, FORBIDDEN_STATE);
  attribute ENUM_ENCODING of DS_ERROR_STATE_TYPE : type is "0 1";


  signal ds_error_state      : DS_ERROR_STATE_TYPE;
  signal ds_error_state_next : DS_ERROR_STATE_TYPE;
  signal adc_data_reg        : std_logic_vector(15 downto 0);
  signal adc_data_next       : std_logic_vector(15 downto 0);
  signal ready_reg           : std_logic;
  signal ready_next          : std_logic;
  signal ip_data1            : std_logic_vector((BOUT - 1) downto 0);
  signal acc1_reg            : std_logic_vector((BOUT - 1) downto 0);
  signal acc2_reg            : std_logic_vector((BOUT - 1) downto 0);
  signal acc3_reg            : std_logic_vector((BOUT - 1) downto 0);
  signal acc1_next           : std_logic_vector((BOUT - 1) downto 0);
  signal acc2_next           : std_logic_vector((BOUT - 1) downto 0);
  signal acc3_next           : std_logic_vector((BOUT - 1) downto 0);
  signal acc3_d_reg          : std_logic_vector((BOUT - 1) downto 0);
  signal diff1_reg           : std_logic_vector((BOUT - 1) downto 0);
  signal diff2_reg           : std_logic_vector((BOUT - 1) downto 0);
  signal diff3_reg           : std_logic_vector((BOUT - 1) downto 0);
  signal diff1_d_reg         : std_logic_vector((BOUT - 1) downto 0);
  signal diff2_d_reg         : std_logic_vector((BOUT - 1) downto 0);
  signal acc3_d_next         : std_logic_vector((BOUT - 1) downto 0);
  signal diff1_next          : std_logic_vector((BOUT - 1) downto 0);
  signal diff2_next          : std_logic_vector((BOUT - 1) downto 0);
  signal diff3_next          : std_logic_vector((BOUT - 1) downto 0);
  signal diff1_d_next        : std_logic_vector((BOUT - 1) downto 0);
  signal diff2_d_next        : std_logic_vector((BOUT - 1) downto 0);
  signal word_counter_reg    : natural range 0 to 255;
  signal word_counter_next   : natural range 0 to 255;

  signal adc_old_reg           : std_logic_vector(15 downto 0);
  signal adc_old_next          : std_logic_vector(15 downto 0);
  signal adc_data_checked_reg  : std_logic_vector(15 downto 0);
  signal adc_data_checked_next : std_logic_vector(15 downto 0);
  signal ready_checked_reg     : std_logic;
  signal ready_checked_next    : std_logic;

begin

  
  adc_data <= adc_data_checked_reg;
  ready    <= ready_checked_reg;


  -- purpose: perform the sinc action
  process (mdat) is
  begin
    if (mdat = '0') then
      ip_data1 <= (others => '0');  -- change from a 0 to a -1 for 2's comp                                        
    else
      ip_data1 <= (others => '1');
    end if;
  end process;


  -- ACCUMULATOR (INTEGRATOR) Perform the accumulation (IIR) at the speed of the modulator.
  -- Z = one sample delay MCLKOUT = modulators conversion bit rate

  process (n_reset, sysclk) is
  begin
    if (n_reset = '0') then
      acc1_reg <= (others => '0');      -- initialize acc registers on reset
      acc2_reg <= (others => '0');
      acc3_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if (ds_clk = '1') then
        acc1_reg <= acc1_next;
        acc2_reg <= acc2_next;
        acc3_reg <= acc3_next;
      end if;
    end if;
  end process;

  process (acc1_reg, acc2_reg, acc3_reg, ip_data1) is
  begin
    acc1_next <= acc1_reg + ip_data1;   -- perform accumulation process
    acc2_next <= acc2_reg + acc1_reg;
    acc3_next <= acc3_reg + acc2_reg;
  end process;


  -- DIFFERENTIATOR ( including decimation stage) Perform the differentiation stage (FIR) at a lower speed.
  -- Z = one sample delay WORD_CLK = output word rate */

  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (n_reset = '0') then
        word_counter_reg <= 0;
        acc3_d_reg       <= (others => '0');
        diff1_d_reg      <= (others => '0');
        diff2_d_reg      <= (others => '0');
        diff1_reg        <= (others => '0');
        diff2_reg        <= (others => '0');
        diff3_reg        <= (others => '0');
        adc_data_reg     <= (others => '0');
        ready_reg        <= '0';
      else
        word_counter_reg <= word_counter_next;
        acc3_d_reg       <= acc3_d_next;
        diff1_d_reg      <= diff1_d_next;
        diff2_d_reg      <= diff2_d_next;
        diff1_reg        <= diff1_next;
        diff2_reg        <= diff2_next;
        diff3_reg        <= diff3_next;
        adc_data_reg     <= adc_data_next;
        ready_reg        <= ready_next;
      end if;
    end if;
  end process;

  process (acc3_d_reg, acc3_reg, diff1_d_reg, diff1_reg, diff2_d_reg,
           diff2_reg, diff3_reg, ds_clk, word_counter_reg) is
  begin
    word_counter_next          <= word_counter_reg;
    acc3_d_next                <= acc3_d_reg;
    diff1_d_next               <= diff1_d_reg;
    diff2_d_next               <= diff2_d_reg;
    diff1_next                 <= acc3_reg - acc3_d_reg;
    diff2_next                 <= diff1_reg - diff1_d_reg;
    diff3_next                 <= diff2_reg - diff2_d_reg;
    adc_data_next(15 downto 0) <= not diff3_reg ((BOUT - 1) downto (BOUT - 16));
    ready_next                 <= '0';
    if (ds_clk = '1') then
      if (word_counter_reg < 255) then
        word_counter_next <= word_counter_reg + 1;
        if (word_counter_reg = 127) then
          acc3_d_next  <= acc3_reg;
          diff1_d_next <= diff1_reg;
          diff2_d_next <= diff2_reg;
          ready_next   <= '1';
        end if;
      else
        word_counter_next <= 0;
      end if;
    end if;

  end process;

-- detects and correct delta-sigma errors when it is close to saturation 
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      adc_old_reg          <= x"7FFF";
      ds_error_state       <= NORMAL_STATE;
      adc_data_checked_reg <= x"7FFF";
      ready_checked_reg    <= '0';
    elsif rising_edge (sysclk) then
      adc_old_reg          <= adc_old_next;
      ds_error_state       <= ds_error_state_next;
      adc_data_checked_reg <= adc_data_checked_next;
      ready_checked_reg    <= ready_checked_next;
    end if;
  end process;

  process (adc_data_checked_reg, adc_data_reg, adc_old_reg, ds_error_state,
           ready_reg)
  begin
    adc_old_next          <= adc_old_reg;
    ds_error_state_next   <= ds_error_state;
    ready_checked_next    <= '0';
    adc_data_checked_next <= adc_data_checked_reg;
    case (ds_error_state) is
      when NORMAL_STATE =>
        if (ready_reg = '1') then
          if (adc_data_reg < FORBIDDEN) or (adc_data_reg > (not FORBIDDEN)) then
            adc_old_next        <= adc_data_reg;
            ds_error_state_next <= FORBIDDEN_STATE;
          end if;
          ready_checked_next    <= '1';
          adc_data_checked_next <= adc_data_reg;
        end if;
        
      when FORBIDDEN_STATE =>
        if (ready_reg = '1') then
          if (adc_data_reg >= FORBIDDEN) and (adc_data_reg <= (not FORBIDDEN)) then
            ds_error_state_next   <= NORMAL_STATE;
            adc_data_checked_next <= adc_data_reg;
          elsif (adc_old_reg(15) /= adc_data_reg(15)) then
            adc_data_checked_next <= not (adc_data_reg);
            adc_old_next          <= not (adc_data_reg);
          else
            adc_data_checked_next <= adc_data_reg;
            adc_old_next          <= adc_data_reg;
          end if;
          ready_checked_next <= '1';
        end if;
    end case;
  end process;



end architecture ad7401_controller_rtl;


--eof $Id:
