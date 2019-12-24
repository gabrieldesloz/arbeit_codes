-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-24
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;


entity gate_soft_interface is
  
  port (
    clk     : in std_logic;
    reset_n : in std_logic

    avs_address    : in std_logic_vector(3 downto 0);
    avs_writedata  : in std_logic_vector(31 downto 0);
    avs_write      : in std_logic; 
    avs_chipselect : in std_logic;

    coe_sysclk : in std_logic;

    quality_bus_o : out std_logic_vector((N_CHANNELS_ANA*Q_BITS/2)-1 downto 0);
    quality_bus_i : in  std_logic_vector((N_CHANNELS_ANA*Q_BITS/2)-1 downto 0)

    );

end quality;

architecture rtl of gate_soft_interface is

  
  type BUFFER_R is array (integer range <>) of std_logic_vector(avs_writedata'range);
  -- 8 registradores para 8 canais * 32 bits
  signal BUFFER_REGS                                                    : BUFFER_R (0 to (N_CHANNELS_ANA/2)-1);
  signal quality_bus_reg, quality_bus_next                              : std_logic_vector(quality_bus_i'range);
  signal write_gate_reg, write_gate_next, read_gate_reg, read_gate_next : std_logic;
  signal wr_en_reg, wr_en_next, rd_en_reg, rd_en_next                   : std_logic;
  

  
begin  -- quality_rtl


  fast : process (coe_sysclk, reset_n)
  begin
    if reset_n = '0' then
      write_gate_reg  <= '0';
      read_gate_reg   <= '0';
      quality_bus_reg <= (others => '0');
    elsif rising_edge(coe_sysclk) then  -- rising clock edge
      quality_bus_reg <= quality_bus_next;
      read_gate_reg   <= read_gate_next;
      write_gate_reg  <= write_gate_next;
    end if;
  end process;



  -- NIOS access control
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      avs_readdata <= (others => '0');
      wr_en_reg    <= '0';
      rd_en_reg    <= '0';
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i        
    elsif rising_edge(clk) then
      wr_en_reg <= wr_en_next;
      rd_en_reg <= rd_en_next;

      if rd_en_reg = '1' then
        avs_readdata <= BUFFER_REGS(to_integer(unsigned(avs_address)));
      else
        avs_readdata <= (others => '0');
      end if;

    end if;
  end process;

  rd_en_next <= '1' when avs_read = '1' and avs_chipselect = '1'  else '0';
  wr_en_next <= '1' when avs_write = '1' and avs_chipselect = '1' else '0';



  signal_align_1 : entity work.signal_align
    port map (
      fast_clk              => coe_sysclk,
      reset_n               => reset_n,
      slow_signal_i         => wr_en_reg,
      slow_signal_aligned_o => wr_en_reg_align
      );



-- fast clock
  process(BUFFER_REGS, quality_bus_i, quality_bus_reg,
          read_gate_reg, write_gate_reg, read_gate, wr_en_reg,
          avs_writedata)
  begin

    write_gate_next  <= write_gate;
    quality_bus_next <= quality_bus_i;
    read_gate_next   <= read_gate;

    if (wr_en_reg_align = '0') and (read_gate_reg = '1') then
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          quality_bus_next(i*32 + j) <= BUFFER_REGS(i)(j);
        end loop;  -- j
      end loop;  -- i
    end if;

    if (wr_en_reg_align = '0') and (write_gate_reg = '1') then
      for i in 0 to BUFFER_REGS'length-1 loop
        for j in 0 to 31 loop
          BUFFER_REGS(i)(j) <= quality_bus_reg(i*32 + j);
        end loop;  -- j
      end loop;  -- i                 
    end if;

    if (wr_en_reg = '1') then
      BUFFER_REGS(to_integer(unsigned(avs_address))) <= avs_writedata;
    end if;
    
  end process;


  quality_bus_o <= quality_bus_reg;

 
  
end rtl;

