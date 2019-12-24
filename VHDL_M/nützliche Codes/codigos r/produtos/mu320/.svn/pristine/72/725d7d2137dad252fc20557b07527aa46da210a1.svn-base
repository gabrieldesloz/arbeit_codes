-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : nom_freq_sel.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2013-05-07
-- Last update: 2013-05-15
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-07  1.0      lgs     Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;

entity nom_freq_sel is
  port (
    reset_n : in std_logic;
    sysclk  : in std_logic;

    clk            : in std_logic;
    avs_address    : in std_logic;
    avs_writedata  : in std_logic_vector(31 downto 0);
    avs_write      : in std_logic;
    avs_chipselect : in std_logic;

    freq_80_o             : out std_logic_vector((FREQ_BITS_80 -1) downto 0);
    step_low_80_o         : out std_logic_vector((STEP_LOW_BITS_80 -1) downto 0);
    step_normal_80_o      : out std_logic_vector((STEP_NORMAL_BITS_80 -1) downto 0);
    freq_default_std_80_o : out std_logic_vector((N -1) downto 0);
    k_default_std_80_o    : out std_logic_vector((N_BITS_NCO -1) downto 0);

    freq_256_o             : out std_logic_vector((FREQ_BITS_256 -1) downto 0);
    step_low_256_o         : out std_logic_vector((STEP_LOW_BITS_256 -1) downto 0);
    step_normal_256_o      : out std_logic_vector((STEP_NORMAL_BITS_256 -1) downto 0);
    freq_default_std_256_o : out std_logic_vector((N -1) downto 0);
    k_default_std_256_o    : out std_logic_vector((N_BITS_NCO -1) downto 0);

    sync_reset_o_n : out std_logic
    );
end nom_freq_sel;


architecture nom_freq_sel_rtl of nom_freq_sel is

  signal write_cfg_reg           : std_logic;
  signal frequency_selector_next : std_logic_vector(1 downto 0);
  signal frequency_selector_reg  : std_logic_vector(1 downto 0);
  signal sync_reset_reg          : std_logic;
  signal sync_reset_next         : std_logic;

  signal freq_80_reg              : std_logic_vector((FREQ_BITS_80 -1) downto 0);
  signal freq_80_next             : std_logic_vector((FREQ_BITS_80 -1) downto 0);
  signal step_low_80_reg          : std_logic_vector((STEP_LOW_BITS_80 -1) downto 0);
  signal step_low_80_next         : std_logic_vector((STEP_LOW_BITS_80 -1) downto 0);
  signal step_normal_80_reg       : std_logic_vector((STEP_NORMAL_BITS_80 -1) downto 0);
  signal step_normal_80_next      : std_logic_vector((STEP_NORMAL_BITS_80 -1) downto 0);
  signal freq_default_std_80_reg  : std_logic_vector((N -1) downto 0);
  signal freq_default_std_80_next : std_logic_vector((N -1) downto 0);
  signal k_default_std_80_reg     : std_logic_vector((N_BITS_NCO -1) downto 0);
  signal k_default_std_80_next    : std_logic_vector((N_BITS_NCO -1) downto 0);

  signal freq_256_reg              : std_logic_vector((FREQ_BITS_256 -1) downto 0);
  signal freq_256_next             : std_logic_vector((FREQ_BITS_256 -1) downto 0);
  signal step_low_256_reg          : std_logic_vector((STEP_LOW_BITS_256 -1) downto 0);
  signal step_low_256_next         : std_logic_vector((STEP_LOW_BITS_256 -1) downto 0);
  signal step_normal_256_reg       : std_logic_vector((STEP_NORMAL_BITS_256 -1) downto 0);
  signal step_normal_256_next      : std_logic_vector((STEP_NORMAL_BITS_256 -1) downto 0);
  signal freq_default_std_256_reg  : std_logic_vector((N -1) downto 0);
  signal freq_default_std_256_next : std_logic_vector((N -1) downto 0);
  signal k_default_std_256_reg     : std_logic_vector((N_BITS_NCO -1) downto 0);
  signal k_default_std_256_next    : std_logic_vector((N_BITS_NCO -1) downto 0);
  
begin  -- nom_freq_sel_rtl


  freq_80_o              <= freq_80_reg;
  step_low_80_o          <= step_low_80_reg;
  step_normal_80_o       <= step_normal_80_reg;
  freq_default_std_80_o  <= freq_default_std_80_reg;
  k_default_std_80_o     <= k_default_std_80_reg;
  freq_256_o             <= freq_256_reg;
  step_low_256_o         <= step_low_256_reg;
  step_normal_256_o      <= step_normal_256_reg;
  freq_default_std_256_o <= freq_default_std_256_reg;
  k_default_std_256_o    <= k_default_std_256_reg;
  sync_reset_o_n         <= sync_reset_reg;

  write_cfg_reg <= '1' when (avs_chipselect = '1' and avs_write = '1') else '0';

  process (clk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      frequency_selector_next <= frequency_selector_reg;
    elsif rising_edge(clk) then         -- rising clock edge
      if write_cfg_reg = '1' then
        frequency_selector_next <= avs_writedata(1 downto 0);
      end if;
    end if;
  end process;


  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      frequency_selector_reg   <= "00";
      sync_reset_reg           <= '0';
      freq_80_reg              <= FREQ_4800;
      step_low_80_reg          <= STEP_LOW_4800;
      step_normal_80_reg       <= STEP_NORMAL_4800;
      freq_default_std_80_reg  <= FREQUENCY_DEFAULT_STD_4800;
      k_default_std_80_reg     <= K_DEFAULT_STD_4800;
      freq_256_reg             <= FREQ_15360;
      step_low_256_reg         <= STEP_LOW_15360;
      step_normal_256_reg      <= STEP_NORMAL_15360;
      freq_default_std_256_reg <= FREQUENCY_DEFAULT_STD_15360;
      k_default_std_256_reg    <= K_DEFAULT_STD_15360;
    elsif rising_edge(sysclk) then      -- rising clock edge
      frequency_selector_reg   <= frequency_selector_next;
      sync_reset_reg           <= sync_reset_next;
      freq_80_reg              <= freq_80_next;
      step_low_80_reg          <= step_low_80_next;
      step_normal_80_reg       <= step_normal_80_next;
      freq_default_std_80_reg  <= freq_default_std_80_next;
      k_default_std_80_reg     <= k_default_std_80_next;
      freq_256_reg             <= freq_256_next;
      step_low_256_reg         <= step_low_256_next;
      step_normal_256_reg      <= step_normal_256_next;
      freq_default_std_256_reg <= freq_default_std_256_next;
      k_default_std_256_reg    <= k_default_std_256_next;
    end if;
  end process;

  process (freq_256_reg, freq_80_reg, freq_default_std_256_reg,
           freq_default_std_80_reg, frequency_selector_reg,
           k_default_std_256_reg, k_default_std_80_reg, step_low_256_reg,
           step_low_80_reg, step_normal_256_reg, step_normal_80_reg,
           sync_reset_reg)
  begin  -- process
    
    sync_reset_next           <= sync_reset_reg;
    freq_80_next              <= freq_80_reg;
    step_low_80_next          <= step_low_80_reg;
    step_normal_80_next       <= step_normal_80_reg;
    freq_default_std_80_next  <= freq_default_std_80_reg;
    k_default_std_80_next     <= k_default_std_80_reg;
    freq_256_next             <= freq_256_reg;
    step_low_256_next         <= step_low_256_reg;
    step_normal_256_next      <= step_normal_256_reg;
    freq_default_std_256_next <= freq_default_std_256_reg;
    k_default_std_256_next    <= k_default_std_256_reg;

    if frequency_selector_reg = "01" then     --50Hz
      sync_reset_next           <= '1';
      freq_80_next              <= FREQ_4000;
      step_low_80_next          <= STEP_LOW_4000;
      step_normal_80_next       <= STEP_NORMAL_4000;
      freq_default_std_80_next  <= FREQUENCY_DEFAULT_STD_4000;
      k_default_std_80_next     <= K_DEFAULT_STD_4000;
      freq_256_next             <= FREQ_12800;
      step_low_256_next         <= STEP_LOW_12800;
      step_normal_256_next      <= STEP_NORMAL_12800;
      freq_default_std_256_next <= FREQUENCY_DEFAULT_STD_12800;
      k_default_std_256_next    <= K_DEFAULT_STD_12800;
    elsif frequency_selector_reg = "10" then  --60Hz
      sync_reset_next           <= '1';
      freq_80_next              <= FREQ_4800;
      step_low_80_next          <= STEP_LOW_4800;
      step_normal_80_next       <= STEP_NORMAL_4800;
      freq_default_std_80_next  <= FREQUENCY_DEFAULT_STD_4800;
      k_default_std_80_next     <= K_DEFAULT_STD_4800;
      freq_256_next             <= FREQ_15360;
      step_low_256_next         <= STEP_LOW_15360;
      step_normal_256_next      <= STEP_NORMAL_15360;
      freq_default_std_256_next <= FREQUENCY_DEFAULT_STD_15360;
      k_default_std_256_next    <= K_DEFAULT_STD_15360;
    else
      sync_reset_next <= '0';
    end if;

  end process;

end nom_freq_sel_rtl;
