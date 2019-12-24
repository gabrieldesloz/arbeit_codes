library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vram_ctrl is
   port (
      clk, reset: in std_logic;
      -- from video sync
      pixel_x, pixel_y: in std_logic_vector(9 downto 0);
      p_tick: in std_logic;
      -- memory interface to vga read 
      vga_rd_data: out std_logic_vector(7 downto 0);
      -- memory interface to cpu
      cpu_rd_data: out std_logic_vector(7 downto 0);
      cpu_wr_data: in std_logic_vector(7 downto 0);      
      cpu_addr: in std_logic_vector(18 downto 0);      
      cpu_mem_wr: in std_logic;      
      cpu_mem_rd: in std_logic;      
      -- to/from SRAM chip
      sram_addr: out std_logic_vector(17 downto 0);
      sram_dq: inout std_logic_vector(15 downto 0);
      sram_we_n, sram_oe_n: out std_logic;
      sram_ce_n, sram_ub_n, sram_lb_n: out std_logic
   );
end vram_ctrl;

architecture arch of vram_ctrl is
   type wr_state_type is (idle, waitr, rd, fetch, waitw, wr);
   signal state_reg, state_next: wr_state_type;
   signal vga_rd_data_reg: std_logic_vector(7 downto 0);
   signal cpu_addr_reg, cpu_addr_next: std_logic_vector(18 downto 0);
   signal wr_data_reg, wr_data_next: std_logic_vector(7 downto 0);
   signal cpu_rd_data_reg, cpu_rd_data_next: 
          std_logic_vector(7 downto 0);
   signal we_n_reg, we_n_next: std_logic;
   signal y_offset: unsigned(18 downto 0);   
   signal vga_addr, mem_addr: std_logic_vector(18 downto 0);   
   signal byte_from_sram: std_logic_vector(7 downto 0);
   signal vga_cycle: std_logic;
begin 
   -- p_tick asserted every 2 clock cycles; 
   vga_cycle <= p_tick;     
   --==================================================================
   -- VGA port SRAM read operation 
   --==================================================================
   -- VGA port read SRAM continuousely 
   -- read registers 
   process (clk)
   begin
      if (clk'event and clk='1') then
         if (vga_cycle='1') then
            vga_rd_data_reg <= byte_from_sram;
         end if; 
      end if;
   end process;
   -- VGA port address offset = 640*y + x = 512*y + 128*y + x
   y_offset <= unsigned('0'& pixel_y(8 downto 0) & "000000000") + 
               unsigned("000" & pixel_y(8 downto 0) & "0000000");
   vga_addr <= std_logic_vector(y_offset + unsigned(pixel_x));
   vga_rd_data <= vga_rd_data_reg;
   --==================================================================
   -- CPU port SRAM read/write operation 
   --==================================================================
   -- FSMD state & data registers
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
         cpu_addr_reg <= (others=>'0');
         wr_data_reg <= (others=>'0');
         cpu_rd_data_reg <= (others=>'0');
         we_n_reg <= '1';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         cpu_addr_reg <= cpu_addr_next;
         wr_data_reg <= wr_data_next;
         cpu_rd_data_reg <= cpu_rd_data_next;
         we_n_reg <= we_n_next;
      end if;
   end process;
   cpu_rd_data <= cpu_rd_data_reg;
   -- next-state logic
   process(state_reg,cpu_addr_reg,wr_data_reg,byte_from_sram,
           cpu_rd_data_reg,cpu_mem_wr,cpu_mem_rd,vga_cycle,
           cpu_addr,cpu_wr_data)
   begin
      state_next <= state_reg;
      cpu_addr_next <= cpu_addr_reg;
      wr_data_next <= wr_data_reg;
      cpu_rd_data_next <= cpu_rd_data_reg;
      case state_reg is
         when idle =>
            if cpu_mem_wr='1' then
               cpu_addr_next <= cpu_addr;
               wr_data_next <= cpu_wr_data;
               if vga_cycle = '1' then
                  state_next <= wr;
               else 
                  state_next <= waitw;
               end if;   
            elsif cpu_mem_rd='1' then 
               if vga_cycle = '1' then  
                  state_next <= rd;
               else                     
                  cpu_rd_data_next <= byte_from_sram;
                  state_next <= waitr;
               end if;   
            end if;   
         when rd =>
            cpu_rd_data_next <= byte_from_sram;
            state_next <= fetch;
         when waitr =>
            state_next <= fetch;
         when fetch =>
            state_next <= idle;
         when waitw =>
            state_next <= wr;
         when wr =>
            state_next <= idle;
      end case;
   end process;
   -- look-ahead output
   we_n_next <= '0' when state_next=wr else '1'; 
   --==================================================================
   -- SRAM interface signals 
   --==================================================================
   -- configure SRAM as 512K-by-8  
   mem_addr <= vga_addr when vga_cycle='1' else     
               cpu_addr_reg when we_n_reg='0' else 
               cpu_addr;                           
   sram_addr <= mem_addr(18 downto 1);
   sram_lb_n <= '0' when mem_addr(0)='0' else '1'; 
   sram_ub_n <= '0' when mem_addr(0)='1' else '1';              
   sram_ce_n <= '0';
   sram_oe_n <= '0'; 
   sram_we_n <= we_n_reg;
   sram_dq <= wr_data_reg & wr_data_reg when we_n_reg='0' else    
             (others=>'Z');
   -- LSB control lb ub
   byte_from_sram <= sram_dq(15 downto 8) when mem_addr(0)='1' else            
                     sram_dq(7 downto 0);
end arch;