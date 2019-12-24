-------------------------------------------------------------------------------
-- $Id: dco_generic.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/dco_generic.vhd $
-- Written by Celso Souza on 01/2007
-- Last update: 2012-10-01
-- Description: A VHDL module for a numeric controlled oscillator
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------


-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.lpm_components.all;

entity dco_generic is

  generic(
    N_BITS_NCO_GEN : natural := 40
    );

  port (
    n_reset    : in  std_logic;
    sysclk     : in  std_logic;
    sync       : in  std_logic;
    freq       : in  std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0);
    f_dco      : out std_logic;
    f_dco_edge : out std_logic
    );

end dco_generic;
------------------------------------------------------------
architecture dco_generic_RTL of dco_generic is



-- Local (internal to the model) signals declarations.
  signal phase     : std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0);
  signal add       : std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0);
  signal f_dco_int : std_logic;

-- Component declarations

  component lpm_add_sub
    generic (
      lpm_width     : natural;
      lpm_direction : string;
      lpm_type      : string;
      lpm_hint      : string
      );
    port (
      dataa  : in  std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0);
      datab  : in  std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0);
      cout   : out std_logic;
      result : out std_logic_vector ((N_BITS_NCO_GEN - 1) downto 0)
      );
  end component;


begin

-- component instantiations

  U1 : lpm_add_sub
    generic map (
      lpm_width     => N_BITS_NCO_GEN,
      lpm_direction => "ADD",
      lpm_type      => "LPM_ADD_SUB",
      lpm_hint      => "ONE_INPUT_IS_CONSTANT = NO"
      )
    port map (
      dataa  => freq,
      datab  => phase,
      result => add
      );

  edge_detector_inst : entity work.edge_detector
    port map(
      n_reset  => n_reset,
      sysclk   => sysclk,
      f_in     => f_dco_int,
      pos_edge => f_dco_edge
      );


  f_dco_int <= not phase(N_BITS_NCO_GEN - 1);
  f_dco     <= f_dco_int;

--Processes


  dco_proc : process (n_reset, sysclk)
  begin
    if n_reset = '0' then
      phase <= (others => '0');
    elsif rising_edge (sysclk) then
      if sync = '1' then
        phase <= (others => '0');
      else
        phase <= add;
      end if;
    end if;
  end process dco_proc;

  


end dco_generic_RTL;

-- eof $id:$
