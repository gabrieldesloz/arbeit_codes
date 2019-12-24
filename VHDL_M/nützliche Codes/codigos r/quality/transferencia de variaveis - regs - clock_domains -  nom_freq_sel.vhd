-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : nom_freq_sel.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2013-05-07
-- Last update: 2014-02-20
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
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity nom_freq_sel is
  port (
    reset_n : in std_logic;
    clk  : in std_logic;

    avs_address    : in std_logic_vector(3 downto 0);
    avs_writedata  : in std_logic_vector(31 downto 0);
    avs_write      : in std_logic;
    avs_chipselect : in std_logic;

    coe_clk_sys : in std_logic;

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
  signal wr_en_reg, wr_en_next     : std_logic;

  signal sync_reset_o_n_reg, sync_reset_o_n_next : std_logic;

  type BUFFER_R is array (integer range <>) of std_logic_vector(avs_writedata'range);
  signal BUFFER_REGS : BUFFER_R (0 to 14);
  
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
  sync_reset_o_n         <= sync_reset_o_n_reg;

--=======================================================
-- Registradores
--=======================================================

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      wr_en_reg <= '0';
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i   
      
    elsif rising_edge(clk) then
      wr_en_reg <= wr_en_next;
      if wr_en_reg = '1' then
        BUFFER_REGS(to_integer(unsigned(avs_address))) <= avs_writedata;
      end if;
      
    end if;
  end process;




  process(coe_clk_sys, reset_n)
  begin
    if reset_n = '0' then
      freq_80_reg              <= (others => '0');
      step_low_80_reg          <= (others => '0');
      step_normal_80_reg       <= (others => '0');
      freq_default_std_80_reg  <= (others => '0');
      k_default_std_80_reg     <= (others => '0');
      freq_256_reg             <= (others => '0');
      step_low_256_reg         <= (others => '0');
      step_normal_256_reg      <= (others => '0');
      freq_default_std_256_reg <= (others => '0');
      k_default_std_256_reg    <= (others => '0');
      sync_reset_o_n_reg       <= '0';
      

    elsif rising_edge(coe_clk_sys) then
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
      sync_reset_o_n_reg       <= sync_reset_o_n_next;
      
      
    end if;
  end process;



  -- mudar a ordem dos vetores
  -- sincronizador
  process(BUFFER_REGS, freq_256_reg, freq_80_reg,
          freq_default_std_256_reg, freq_default_std_80_reg,
          k_default_std_256_reg, k_default_std_80_reg, step_low_256_reg,
          step_low_80_reg, step_normal_256_reg, step_normal_80_reg, wr_en_reg,sync_reset_o_n_reg)
  begin

    sync_reset_o_n_next <= sync_reset_o_n_reg;

    if (wr_en_reg = '0') then
      freq_80_next              <= std_logic_vector(resize(unsigned(BUFFER_REGS(0)), FREQ_BITS_80));
      step_low_80_next          <= std_logic_vector(resize(unsigned(BUFFER_REGS(1)), STEP_LOW_BITS_80));
      step_normal_80_next       <= std_logic_vector(resize(unsigned(BUFFER_REGS(2)), STEP_NORMAL_BITS_80));
      freq_default_std_80_next  <= std_logic_vector(resize(unsigned(BUFFER_REGS(4)), 28))
                                  & std_logic_vector(resize(unsigned(BUFFER_REGS(3)), 32));
      k_default_std_80_next     <= std_logic_vector(resize(unsigned(BUFFER_REGS(6)), 12))
                                  & std_logic_vector(resize(unsigned(BUFFER_REGS(5)), 32));
      freq_256_next             <= std_logic_vector(resize(unsigned(BUFFER_REGS(7)), FREQ_BITS_256));
      step_low_256_next         <= std_logic_vector(resize(unsigned(BUFFER_REGS(8)), STEP_LOW_BITS_256));
      step_normal_256_next      <= std_logic_vector(resize(unsigned(BUFFER_REGS(9)), STEP_NORMAL_BITS_256));
      freq_default_std_256_next <= std_logic_vector(resize(unsigned(BUFFER_REGS(11)), 28))
                                  & std_logic_vector(resize(unsigned(BUFFER_REGS(10)), 32));
      k_default_std_256_next    <= std_logic_vector(resize(unsigned(BUFFER_REGS(13)), 12))
                                  & std_logic_vector(resize(unsigned(BUFFER_REGS(12)), 32));
      
      sync_reset_o_n_next <= BUFFER_REGS(14)(0);
      
      
    else
      
      sync_reset_o_n_next       <= sync_reset_o_n_reg;
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
      
    end if;
  end process;
 
  wr_en_next <= '1' when avs_write = '1' and avs_chipselect = '1' else '0';    

end nom_freq_sel_rtl;


