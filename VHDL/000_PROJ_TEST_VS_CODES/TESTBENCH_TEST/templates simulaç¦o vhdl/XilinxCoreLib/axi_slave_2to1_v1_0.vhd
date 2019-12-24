-- $Header: /devl/xcs/repo/env/Databases/ip/src2/M/axi_utils_v1_0/simulation/axi_slave_2to1_v1_0.vhd,v 1.3 2011/02/14 14:17:58 ccleg Exp $
------------------------------------------------------------
--  (c) Copyright 2010 Xilinx, Inc. All rights reserved.
--
--  This file contains confidential and proprietary information
--  of Xilinx, Inc. and is protected under U.S. and
--  international copyright and other intellectual property
--  laws.
--
--  DISCLAIMER
--  This disclaimer is not a license and does not grant any
--  rights to the materials distributed herewith. Except as
--  otherwise provided in a valid license issued to you by
--  Xilinx, and to the maximum extent permitted by applicable
--  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
--  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
--  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
--  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
--  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
--  (2) Xilinx shall not be liable (whether in contract or tort,
--  including negligence, or under any other theory of
--  liability) for any loss or damage of any kind or nature
--  related to, arising under or in connection with these
--  materials, including for any direct, or any indirect,
--  special, incidental, or consequential loss or damage
--  (including loss of data, profits, goodwill, or any type of
--  loss or damage suffered as a result of any action brought
--  by a third party) even if such damage or loss was
--  reasonably foreseeable or Xilinx had been advised of the
--  possibility of the same.
--
--  CRITICAL APPLICATIONS
--  Xilinx products are not designed or intended to be fail-
--  safe, or for use in any application requiring fail-safe
--  performance, such as life-support or safety devices or
--  systems, Class III medical devices, nuclear facilities,
--  applications related to the deployment of airbags, or any
--  other applications that could lead to death, personal
--  injury, or severe property or environmental damage
--  (individually and collectively, "Critical
--  Applications"). Customer assumes the sole risk and
--  liability of any use of Xilinx products in Critical
--  Applications, subject only to applicable laws and
--  regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
--  PART OF THIS FILE AT ALL TIMES.
------------------------------------------------------------
-- axi_slave_2to1_v1_0.vhd
-- A 2 to 1 AXI slave channel synchronizer.
-- Provides 2 AXI slave interfaces for input channels
-- and 1 AXI master interface for connection to a core.
-- A transaction must be received on each slave interface
-- before a transaction is created on the master interface.
-- Latency = 1 while m_axis_z_tready is high (full throughput).
-- The master interface TREADY is optional (it is typically the
-- logical AND of the core's RFD and the output FIFO's TREADY).
-- Payload signals (TDATA, TUSER, TLAST) are not combined,
-- and are presented synchronized but separately on the
-- master interface.
--
-- Slave interfaces: A, B
-- Master interface: Z
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity axi_slave_2to1_v1_0 is
  generic (
    C_A_TDATA_WIDTH : positive := 8;      -- Width of s_axis_a_tdata in bits
    C_HAS_A_TUSER   : boolean  := false;  -- Indicates if s_axis_a_tuser signal is used
    C_A_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_a_tuser in bits (if C_HAS_A_TUSER = true)
    C_HAS_A_TLAST   : boolean  := false;  -- Indicates if s_axis_a_tlast signal is used
    C_B_TDATA_WIDTH : positive := 8;      -- Width of s_axis_b_tdata in bits
    C_HAS_B_TUSER   : boolean  := false;  -- Indicates if s_axis_b_tuser signal is used
    C_B_TUSER_WIDTH : natural  := 1;      -- Width of s_axis_b_tuser in bits (if C_HAS_B_TUSER = true)
    C_HAS_B_TLAST   : boolean  := false;  -- Indicates if s_axis_b_tlast signal is used
    C_HAS_Z_TREADY  : boolean  := true    -- Indicates if m_axis_z_tready signal is used
    );
  port (
    aclk   : in std_logic := '0';       -- Clock
    aclken : in std_logic := '1';       -- Clock enable
    sclr   : in std_logic := '0';       -- Reset, active HIGH

    -- AXI slave interface A
    s_axis_a_tready : out std_logic                                    := '0';              -- TREADY for channel A
    s_axis_a_tvalid : in  std_logic                                    := '0';              -- TVALID for channel A
    s_axis_a_tdata  : in  std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel A
    s_axis_a_tuser  : in  std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel A
    s_axis_a_tlast  : in  std_logic                                    := '0';              -- TLAST for channel A

    -- AXI slave interface B
    s_axis_b_tready : out std_logic                                    := '0';              -- TREADY for channel B
    s_axis_b_tvalid : in  std_logic                                    := '0';              -- TVALID for channel B
    s_axis_b_tdata  : in  std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- TDATA for channel B
    s_axis_b_tuser  : in  std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- TUSER for channel B
    s_axis_b_tlast  : in  std_logic                                    := '0';              -- TLAST for channel B

    -- Read interface to core
    m_axis_z_tready  : in  std_logic                                    := '1';              -- TREADY for channel Z
    m_axis_z_tvalid  : out std_logic                                    := '0';              -- TVALID for channel Z
    m_axis_z_tdata_a : out std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from A
    m_axis_z_tuser_a : out std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from A
    m_axis_z_tlast_a : out std_logic                                    := '0';              -- Channel Z TLAST from A
    m_axis_z_tdata_b : out std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TDATA from B
    m_axis_z_tuser_b : out std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Channel Z TUSER from B
    m_axis_z_tlast_b : out std_logic                                    := '0'               -- Channel Z TLAST from B
    );

end entity;


------------------------------------------------------------

architecture xilinx of axi_slave_2to1_v1_0 is

  -- Internal versions of A and B input channels signals
  signal a_valid : std_logic;  -- Internal version of s_axis_a_tvalid;
  signal b_valid : std_logic;  -- Internal version of s_axis_b_tvalid;

  -- Identify when a transaction is being accepted on input channels A and B
  signal a_tx : std_logic;  -- Transaction is being accepted on input channel A
  signal b_tx : std_logic;  -- Transaction is being accepted on input channel B
  signal z_tx : std_logic;  -- Transaction is being accepted on output channel Z

  -- Reg1 handshake and control signals
  signal reg1_a_ready     : std_logic := '1';  -- Reg1 A ready to receive data
  signal reg1_b_ready     : std_logic := '1';  -- Reg1 B ready to receive data
  signal reg1_a_ready_nxt : std_logic;         -- Reg1 A ready to receive data, next value
  signal reg1_b_ready_nxt : std_logic;         -- Reg1 B ready to receive data, next value
  signal reg1_a_wr        : std_logic;         -- Write new data into reg1 A
  signal reg1_b_wr        : std_logic;         -- Write new data into reg1 B
  signal reg1_a_valid     : std_logic := '0';  -- Reg1 A contains valid data
  signal reg1_b_valid     : std_logic := '0';  -- Reg1 B contains valid data
  signal reg1_a_valid_nxt : std_logic;         -- Reg1 A contains valid data, next value
  signal reg1_b_valid_nxt : std_logic;         -- Reg1 B contains valid data, next value

  -- Reg1 data signals
  signal reg1_a_tdata : std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Reg1 A TDATA register
  signal reg1_a_tuser : std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Reg1 A TUSER register
  signal reg1_a_tlast : std_logic                                    := '0';              -- Reg1 A TLAST register
  signal reg1_b_tdata : std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Reg1 B TDATA register
  signal reg1_b_tuser : std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Reg1 B TUSER register
  signal reg1_b_tlast : std_logic                                    := '0';              -- Reg1 B TLAST register

  -- Reg2 handshake and control signals
  signal reg2_a_ready     : std_logic;         -- Reg2 A ready to receive data
  signal reg2_b_ready     : std_logic;         -- Reg2 B ready to receive data
  signal reg2_a_valid     : std_logic := '0';  -- Reg2 A contains valid data
  signal reg2_b_valid     : std_logic := '0';  -- Reg2 B contains valid data
  signal reg2_a_valid_nxt : std_logic;         -- Reg2 A contains valid data, next value
  signal reg2_b_valid_nxt : std_logic;         -- Reg2 B contains valid data, next value

  -- Reg2 data signals
  signal reg2_a_tdata : std_logic_vector(C_A_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Reg2 A TDATA register
  signal reg2_a_tuser : std_logic_vector(C_A_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Reg2 A TUSER register
  signal reg2_a_tlast : std_logic                                    := '0';              -- Reg2 A TLAST register
  signal reg2_b_tdata : std_logic_vector(C_B_TDATA_WIDTH-1 downto 0) := (others => '0');  -- Reg2 B TDATA register
  signal reg2_b_tuser : std_logic_vector(C_B_TUSER_WIDTH-1 downto 0) := (others => '0');  -- Reg2 B TUSER register
  signal reg2_b_tlast : std_logic                                    := '0';              -- Reg2 B TLAST register

  -- Z output channel signals
  signal z_ready : std_logic;           -- Internal version of m_axis_z_tready;
  signal z_valid : std_logic := '0';    -- Internal version of m_axis_z_tvalid;

begin

  -- There is a small amount of common code between C_HAS_Z_TREADY = 0 or 1, but not very much.
  -- For simplicity and ease of understanding, keep everything separate.

  --------------------------------------------------------------------------------
  -- Using m_axis_z_tready (probably the most common case; requires more resources)
  --------------------------------------------------------------------------------

  gen_has_z_tready : if C_HAS_Z_TREADY generate

    -- Drive TREADY outputs for input channels A and B
    s_axis_a_tready <= reg1_a_ready;
    s_axis_b_tready <= reg1_b_ready;

    -- Connect internal versions of TVALID inputs for input channels A and B
    a_valid <= s_axis_a_tvalid;
    b_valid <= s_axis_b_tvalid;

    -- Identify when a transaction is being accepted on input channels A and B, and on output channel Z
    a_tx <= a_valid and reg1_a_ready;
    b_tx <= b_valid and reg1_b_ready;
    z_tx <= z_valid and z_ready;

    --------------------------------------------------------------------------------
    -- Reg1
    --------------------------------------------------------------------------------

    -- reg1 A and B are ready to receive data if they are not holding valid data,
    -- and are not ready if reg2 holds valid data but reg2 of the other A/B does not.
    -- These ready signals must be registered as they are also input channel A and B ready signals.
    reg1_a_ready_nxt <= not reg1_a_valid_nxt and not (reg2_a_valid_nxt and not reg2_b_valid_nxt);
    reg1_b_ready_nxt <= not reg1_b_valid_nxt and not (reg2_b_valid_nxt and not reg2_a_valid_nxt);
    reg1_ready : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          reg1_a_ready <= '0';
          reg1_b_ready <= '0';
        elsif aclken = '1' then
          reg1_a_ready <= reg1_a_ready_nxt;
          reg1_b_ready <= reg1_b_ready_nxt;
        end if;
      end if;
    end process reg1_ready;

    -- Write new data into reg1 A and B if reg1 is ready and the input channel is valid, but not if reg2 is ready:
    -- note that if reg1 and reg2 are both ready when the input channel is valid, then only reg2 receives the data
    reg1_a_wr <= a_tx and not reg2_a_ready;
    reg1_b_wr <= b_tx and not reg2_b_ready;

    -- Data for reg1 comes from the input channel
    reg1 : process(aclk)
    begin
      if rising_edge(aclk) then
        -- no need for reset on these datapath registers
        if aclken = '1' then
          if reg1_a_wr = '1' then
            reg1_a_tdata <= s_axis_a_tdata;
            reg1_a_tuser <= s_axis_a_tuser;
            reg1_a_tlast <= s_axis_a_tlast;
          end if;
          if reg1_b_wr = '1' then
            reg1_b_tdata <= s_axis_b_tdata;
            reg1_b_tuser <= s_axis_b_tuser;
            reg1_b_tlast <= s_axis_b_tlast;
          end if;
        end if;
      end if;
    end process reg1;

    -- reg1 A and B become valid when they receive data, and stop being valid when their data is sent to reg2
    reg1_a_valid_nxt <= (reg1_a_valid and not (reg2_a_valid and reg2_a_ready)) or reg1_a_wr;
    reg1_b_valid_nxt <= (reg1_b_valid and not (reg2_b_valid and reg2_b_ready)) or reg1_b_wr;
    reg1_valid : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          reg1_a_valid <= '0';
          reg1_b_valid <= '0';
        elsif aclken = '1' then
          reg1_a_valid <= reg1_a_valid_nxt;
          reg1_b_valid <= reg1_b_valid_nxt;
        end if;
      end if;
    end process reg1_valid;

    --------------------------------------------------------------------------------
    -- Reg2
    --------------------------------------------------------------------------------

    -- reg2 A and B are ready to receive data if Z channel is ready or reg2 is not holding valid data,
    -- and are not ready if reg2 holds valid data but reg2 of the other A/B does not
    reg2_a_ready <= (z_ready or not reg2_a_valid) and not (reg2_a_valid and not reg2_b_valid);
    reg2_b_ready <= (z_ready or not reg2_b_valid) and not (reg2_b_valid and not reg2_a_valid);

    -- Data for reg2 comes from reg1 if reg1 is valid, or from the input channel if a transaction is received on it
    reg2 : process(aclk)
    begin
      if rising_edge(aclk) then
        -- no need for reset on these datapath registers
        if aclken = '1' then
          if reg2_a_ready = '1' then
            if reg1_a_valid = '1' then
              reg2_a_tdata <= reg1_a_tdata;
              reg2_a_tuser <= reg1_a_tuser;
              reg2_a_tlast <= reg1_a_tlast;
            elsif a_tx = '1' then
              reg2_a_tdata <= s_axis_a_tdata;
              reg2_a_tuser <= s_axis_a_tuser;
              reg2_a_tlast <= s_axis_a_tlast;
            end if;
          end if;
          if reg2_b_ready = '1' then
            if reg1_b_valid = '1' then
              reg2_b_tdata <= reg1_b_tdata;
              reg2_b_tuser <= reg1_b_tuser;
              reg2_b_tlast <= reg1_b_tlast;
            elsif b_tx = '1' then
              reg2_b_tdata <= s_axis_b_tdata;
              reg2_b_tuser <= s_axis_b_tuser;
              reg2_b_tlast <= s_axis_b_tlast;
            end if;
          end if;
        end if;
      end if;
    end process reg2;

    -- reg2 A and B become valid when they receive data, and stop being valid when their data is sent on the Z channel
    reg2_a_valid_nxt <= (reg2_a_valid and not z_tx) or (reg2_a_ready and (reg1_a_valid or a_tx));
    reg2_b_valid_nxt <= (reg2_b_valid and not z_tx) or (reg2_b_ready and (reg1_b_valid or b_tx));
    reg2_valid : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          reg2_a_valid <= '0';
          reg2_b_valid <= '0';
        elsif aclken = '1' then
          reg2_a_valid <= reg2_a_valid_nxt;
          reg2_b_valid <= reg2_b_valid_nxt;
        end if;
      end if;
    end process reg2_valid;

    --------------------------------------------------------------------------------
    -- Z channel (output master interface)
    --------------------------------------------------------------------------------

    -- Connect internal version of m_axis_z_tready
    z_ready <= m_axis_z_tready;

    -- Assign Z channel outputs from internal signals
    m_axis_z_tvalid    <= z_valid;
    m_axis_z_tdata_a   <= reg2_a_tdata;
    GEN_A_TUSER : if C_HAS_A_TUSER generate
      m_axis_z_tuser_a <= reg2_a_tuser;
    end generate GEN_A_TUSER;
    NO_A_TUSER : if not C_HAS_A_TUSER generate
      m_axis_z_tuser_a <= (others => '0');
    end generate NO_A_TUSER;
    GEN_A_TLAST : if C_HAS_A_TLAST generate
      m_axis_z_tlast_a <= reg2_a_tlast;
    end generate GEN_A_TLAST;
    NO_A_TLAST : if not C_HAS_A_TLAST generate
      m_axis_z_tlast_a <= '0';
    end generate NO_A_TLAST;
    m_axis_z_tdata_b   <= reg2_b_tdata;
    GEN_B_TUSER : if C_HAS_B_TUSER generate
      m_axis_z_tuser_b <= reg2_b_tuser;
    end generate GEN_B_TUSER;
    NO_B_TUSER : if not C_HAS_B_TUSER generate
      m_axis_z_tuser_b <= (others => '0');
    end generate NO_B_TUSER;
    GEN_B_TLAST : if C_HAS_B_TLAST generate
      m_axis_z_tlast_b <= reg2_b_tlast;
    end generate GEN_B_TLAST;
    NO_B_TLAST : if not C_HAS_B_TLAST generate
      m_axis_z_tlast_b <= '0';
    end generate NO_B_TLAST;

    -- Z channel payload is valid if reg2 A and B are both valid
    reg_z_valid : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          z_valid <= '0';
        elsif aclken = '1' then
          z_valid <= reg2_a_valid_nxt and reg2_b_valid_nxt;
        end if;
      end if;
    end process reg_z_valid;

    -- Drive TVALID output for Z channel
    m_axis_z_tvalid <= z_valid;

    -- End of code using m_axis_z_tready
  end generate gen_has_z_tready;

  --------------------------------------------------------------------------------
  -- Not using m_axis_z_tready (less common, fewer resources)
  --------------------------------------------------------------------------------

  gen_no_z_tready : if not C_HAS_Z_TREADY generate

    -- Drive TREADY outputs for input channels A and B
    s_axis_a_tready <= reg1_a_ready;
    s_axis_b_tready <= reg1_b_ready;

    -- Connect internal versions of TVALID inputs for input channels A and B
    a_valid <= s_axis_a_tvalid;
    b_valid <= s_axis_b_tvalid;

    -- Identify when a transaction is being accepted on input channels A and B
    a_tx <= a_valid and reg1_a_ready;
    b_tx <= b_valid and reg1_b_ready;

    --------------------------------------------------------------------------------
    -- Reg1 (only register in this case)
    --------------------------------------------------------------------------------

    -- reg1 A and B are ready except if holding valid data but the other A/B reg1 is not
    reg1_a_ready_nxt <= not (reg1_a_valid_nxt and not reg1_b_valid_nxt);
    reg1_b_ready_nxt <= not (reg1_b_valid_nxt and not reg1_a_valid_nxt);
    reg1_ready : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          reg1_a_ready <= '0';
          reg1_b_ready <= '0';
        elsif aclken = '1' then
          reg1_a_ready <= reg1_a_ready_nxt;
          reg1_b_ready <= reg1_b_ready_nxt;
        end if;
      end if;
    end process reg1_ready;

    -- Write new data into reg1 A and B when a transaction is accepted
    -- Data for reg1 comes from the input channel
    reg1 : process(aclk)
    begin
      if rising_edge(aclk) then
        -- no need for reset on these datapath registers
        if aclken = '1' then
          if a_tx = '1' then
            reg1_a_tdata <= s_axis_a_tdata;
            reg1_a_tuser <= s_axis_a_tuser;
            reg1_a_tlast <= s_axis_a_tlast;
          end if;
          if b_tx = '1' then
            reg1_b_tdata <= s_axis_b_tdata;
            reg1_b_tuser <= s_axis_b_tuser;
            reg1_b_tlast <= s_axis_b_tlast;
          end if;
        end if;
      end if;
    end process reg1;

    -- reg1 A and B become valid when they receive data, and stop being valid when their data is sent on the Z channel
    reg1_a_valid_nxt <= (reg1_a_valid and not z_valid) or a_tx;
    reg1_b_valid_nxt <= (reg1_b_valid and not z_valid) or b_tx;
    reg1_valid : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          reg1_a_valid <= '0';
          reg1_b_valid <= '0';
        elsif aclken = '1' then
          reg1_a_valid <= reg1_a_valid_nxt;
          reg1_b_valid <= reg1_b_valid_nxt;
        end if;
      end if;
    end process reg1_valid;

    --------------------------------------------------------------------------------
    -- Z channel (output master interface)
    --------------------------------------------------------------------------------

    -- Assign Z channel outputs from internal signals
    m_axis_z_tvalid    <= z_valid;
    m_axis_z_tdata_a   <= reg1_a_tdata;
    GEN_A_TUSER : if C_HAS_A_TUSER generate
      m_axis_z_tuser_a <= reg1_a_tuser;
    end generate GEN_A_TUSER;
    NO_A_TUSER : if not C_HAS_A_TUSER generate
      m_axis_z_tuser_a <= (others => '0');
    end generate NO_A_TUSER;
    GEN_A_TLAST : if C_HAS_A_TLAST generate
      m_axis_z_tlast_a <= reg1_a_tlast;
    end generate GEN_A_TLAST;
    NO_A_TLAST : if not C_HAS_A_TLAST generate
      m_axis_z_tlast_a <= '0';
    end generate NO_A_TLAST;
    m_axis_z_tdata_b   <= reg1_b_tdata;
    GEN_B_TUSER : if C_HAS_B_TUSER generate
      m_axis_z_tuser_b <= reg1_b_tuser;
    end generate GEN_B_TUSER;
    NO_B_TUSER : if not C_HAS_B_TUSER generate
      m_axis_z_tuser_b <= (others => '0');
    end generate NO_B_TUSER;
    GEN_B_TLAST : if C_HAS_B_TLAST generate
      m_axis_z_tlast_b <= reg1_b_tlast;
    end generate GEN_B_TLAST;
    NO_B_TLAST : if not C_HAS_B_TLAST generate
      m_axis_z_tlast_b <= '0';
    end generate NO_B_TLAST;

    -- Z channel payload is valid if reg1 A and B are both valid
    reg_z_valid : process(aclk)
    begin
      if rising_edge(aclk) then
        if sclr = '1' then
          z_valid <= '0';
        elsif aclken = '1' then
          z_valid <= reg1_a_valid_nxt and reg1_b_valid_nxt;
        end if;
      end if;
    end process reg_z_valid;

    -- Drive TVALID output for Z channel
    m_axis_z_tvalid <= z_valid;

    -- End of code not using m_axis_z_tready
  end generate gen_no_z_tready;

end architecture xilinx;
