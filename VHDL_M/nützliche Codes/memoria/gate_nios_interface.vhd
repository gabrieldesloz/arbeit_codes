-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : memory_interface - fateware - nios.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-05
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



--Registrador/memoria de acesso comum a 8 registradores de 32 bits
--linux precisa ler/escrever nestes registradores
--gateware precisa escrever nestes registradores 
--junï¿½ï¿½o atravï¿½s de um "or" - fora do componente
--ver o que significa cada posiï¿½ï¿½o de bit - ok 
--serï¿½ "empacotado" em cada SV um vetor de 32 bits com a informaï¿½ï¿½o de qualidade
--a interface enviara um wait request para nï¿½o haver escrita nem leitura simultaneamente
--memoria dual ram
--estabelecer um controlador ...:
--nï¿½o pode ler durante a escrita em um mesmo endereï¿½o
--entradas e saï¿½das
-- 1 leitura /1 escrita
-- waitrequest = '1' quando em reset
-- maquina de estados que inicia com o acesso do linux sobre os registradores
-- propriedades do componente -- tcl
-- Read-during-write on port A or B returns newly written data
-- Read-during-write on port A and B returns unknown data.
-- endereco de leitura e escrita das duas portas nao pode ser o mesmo


-- mem interface: memoria com acesso por dois clock domains, que impede o acesso
-- a ambos os clock domains
-- acesso entre as duas memorias necessita de no minimo dois periodos de clock 



-- casos de teste test bench - funcional / timing
-- leitura e escrita em ciclos separados portas a e b
-- leitura e escrita em ciclos iguais, porem enderecos diferentes
-- leitura e escrita em ciclos iguais, porem enderecos iguais
-- leitura e escrita em ciclos iguais, porem enderecos iguais e com diversos offsets
-- leitura e escrita com diferentes ciclos de clock





library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gate_nios_interface is

  generic (
    D_WIDTH : natural := 32;
    A_WIDTH : natural := 4
    );

  port (

    -- interface nios -- slow -- a 
    sysclk          : in  std_logic;
    reset_n         : in  std_logic;
    avs_chipselect  : in  std_logic;
    avs_address     : in  std_logic_vector(A_WIDTH-1 downto 0);
    avs_write       : in  std_logic;
    avs_read        : in  std_logic;
    avs_writedata   : in  std_logic_vector(D_WIDTH-1 downto 0);
    avs_readdata    : out std_logic_vector(D_WIDTH-1 downto 0);
    avs_waitrequest : out std_logic;

    -- interface gateware - fast - b
    coe_sysclk           : in  std_logic;
    coe_gate_address     : in  std_logic_vector(A_WIDTH-1 downto 0);
    coe_gate_write       : in  std_logic;
    coe_gate_read        : in  std_logic;
    coe_gate_writedata   : in  std_logic_vector(D_WIDTH-1 downto 0);
    coe_gate_readdata    : out std_logic_vector(D_WIDTH-1 downto 0);
    coe_gate_waitrequest : out std_logic

    );


end gate_nios_interface;


architecture rtl of gate_nios_interface is

  signal avs_address_reg, avs_address_next                   : std_logic_vector(A_WIDTH-1 downto 0);
  signal coe_gate_address_reg, coe_gate_address_next         : std_logic_vector(A_WIDTH-1 downto 0);
  signal coe_gate_writedata_reg, coe_gate_writedata_next     : std_logic_vector(D_WIDTH-1 downto 0);
  signal avs_writedata_reg, avs_writedata_next               : std_logic_vector(D_WIDTH-1 downto 0);
  signal we_a_reg, we_a_next                                 : std_logic;
  signal we_b_reg, we_b_next                                 : std_logic;
  signal avs_waitrequest_reg, avs_waitrequest_next           : std_logic;
  signal coe_gate_waitrequest_reg, coe_gate_waitrequest_next : std_logic;
  signal addr_a_int                                          : integer range 0 to (2**A_WIDTH)-1;
  signal addr_b_int                                          : integer range 0 to (2**A_WIDTH)-1;
  
  
begin
  
  true_dual_port_ram_dual_clock_1 :
    entity work.true_dual_port_ram_dual_clock

      generic map (
        DATA_WIDTH => D_WIDTH,
        ADDR_WIDTH => A_WIDTH)
      port map (
        clk_a  => sysclk,
        clk_b  => coe_sysclk,
        addr_a => addr_a_int,
        addr_b => addr_b_int,
        data_a => avs_writedata_reg,
        data_b => coe_gate_writedata_reg,
        we_a   => we_a_reg,
        we_b   => we_b_reg,
        q_a    => avs_readdata,
        q_b    => coe_gate_readdata);

  
  addr_a_int <= to_integer(unsigned(avs_address_reg));
  addr_b_int <= to_integer(unsigned(coe_gate_address_reg));

                 
avs_waitrequest <= avs_waitrequest_reg;
  coe_gate_waitrequest <= coe_gate_waitrequest_reg;

  avs_writedata_next      <= avs_writedata;
  coe_gate_writedata_next <= coe_gate_writedata;

  -- se leitura porta a � no mesmo endereco de escrita porta b, impedir leitura
  -- porta a com wait_request

  -- se leitura porta b � no mesmo endereco de escrita porta a, impedir leitura
  -- porta b 


  slow_regs : process (sysclk, reset_n)
  begin
    if (reset_n = '0') then
      we_a_reg            <= '0';
      avs_waitrequest_reg <= '0';
      avs_address_reg     <= (others => '0');
      avs_writedata_reg   <= (others => '0');
    elsif rising_edge(sysclk) then
      we_a_reg            <= we_a_next;
      avs_address_reg     <= avs_address_next;
      avs_waitrequest_reg <= avs_waitrequest_next;
      avs_writedata_reg   <= avs_writedata_next;
    end if;
  end process;


  fast_regs : process (coe_sysclk, reset_n)
  begin
    if (reset_n = '0') then
      we_b_reg                 <= '0';
      coe_gate_waitrequest_reg <= '0';
      coe_gate_address_reg     <= (others => '0');
      coe_gate_writedata_reg   <= (others => '0');
    elsif rising_edge(coe_sysclk) then
      we_b_reg                 <= we_b_next;
      coe_gate_address_reg     <= coe_gate_address_next;
      coe_gate_waitrequest_reg <= coe_gate_waitrequest_next;
      coe_gate_writedata_reg   <= coe_gate_writedata_next;
    end if;
  end process;



  -- avs instruction decoder
  avs_decod : process (avs_address, avs_address_reg, avs_chipselect, avs_read,
                       avs_write, coe_gate_address, coe_gate_write)
  begin
    --read_address_next <= manter o endereco se o endereco de leitura for o
    --mesmo de escrita e se estiver ocorrendo a escrita  

    -- tentativa de leitura pelo nios durante escrita gateware
    if avs_read = '1' and (coe_gate_write = '1') and (avs_address = coe_gate_address) then
      we_a_next            <= '0';
      avs_address_next     <= avs_address_reg;
      avs_waitrequest_next <= '1';
    else
      we_a_next            <= '0';
      avs_waitrequest_next <= '0';
      avs_address_next     <= avs_address;
    end if;

    -- escrita avs
    if avs_write = '1' and avs_chipselect = '1' then
      we_a_next            <= '1';
      avs_waitrequest_next <= '0';
      avs_address_next     <= avs_address;
    end if;
  end process;



  -- gateware instruction decoder
  gate_decod : process (avs_address, avs_chipselect, avs_write,
                        coe_gate_address, coe_gate_address_reg,
                        coe_gate_read, coe_gate_write)
  begin
    --read_address_next <= manter o endereco se o endereco de leitura for o
    --mesmo de escrita e se estiver ocorrendo a escrita  

    -- tentativa de leitura pelo gateware durante escrita nios
    if coe_gate_read = '1' and (avs_write = '1') and (avs_chipselect = '1')
      and (avs_address = coe_gate_address) then
      we_b_next                 <= '0';
      coe_gate_waitrequest_next <= '1';
      coe_gate_address_next     <= coe_gate_address_reg;
    else
      we_b_next                 <= '0';
      coe_gate_waitrequest_next <= '0';
      coe_gate_address_next     <= coe_gate_address;
    end if;

    -- escrita gateware
    if coe_gate_write = '1' then
      we_b_next                 <= '1';
      coe_gate_waitrequest_next <= '0';
      coe_gate_address_next     <= coe_gate_address;
    end if;
  end process;

end rtl;


-- configurations
