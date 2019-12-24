-- top-level Avalon wrapper
-- the cpu read data is available either two or three clock cycles,
-- set readWaittime=2 in SOPC editor 

 --***********************************************************************
 --*  Address map : 20 bits
 --***********************************************************************
 --* Read (data to cpu):
 --*   x0x..x: SRAM 8-bit  (512K)
 --*   x11..1: read x/y counter
 --* Write (data from cpu):
 --*
 --***********************************************************************/
--=====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity chu_avalon_vga is
   port (
      clk, reset: in  std_logic;
      -- to vga monitor
      hsync, vsync: out std_logic;
      rgb: out std_logic_vector(11 downto 0);
      -- to/from SRAM chip
      sram_addr: out std_logic_vector(17 downto 0);
      sram_dq: inout std_logic_vector(15 downto 0);
      sram_we_n, sram_oe_n: out std_logic;
      sram_ce_n, sram_ub_n, sram_lb_n: out std_logic;
      -- avalon interface
      vga_address: in  std_logic_vector(19 downto 0);     
      vga_chipselect: in  std_logic; 
      vga_write: in std_logic;
      vga_read: in std_logic;
      vga_writedata: in std_logic_vector(31 downto 0);
      vga_readdata: out std_logic_vector(31 downto 0)
 );
end chu_avalon_vga;

architecture arch of chu_avalon_vga is
   signal video_on_reg,video_on_i: std_logic;
   signal vsync_i, hsync_i: std_logic;
   signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
   signal p_tick: std_logic;
   signal cpu_rd_data: std_logic_vector(7 downto 0);
   signal vga_rd_data: std_logic_vector(7 downto 0);
   signal color: std_logic_vector(11 downto 0);
   signal wr_vram, rd_vram: std_logic;
begin
   -- instantiate VGA sync circuit
   vga_sync_unit: entity work.vga_sync
      port map(clk=>clk, reset=>reset, 
               hsync_i=>hsync_i, vsync_i=>vsync_i, 
               video_on_i=>video_on_i, p_tick=>p_tick, 
               pixel_x=>pixel_x, pixel_y=>pixel_y);
   -- instantiate video SRAM control
   vram_unit: entity work.vram_ctrl 
   port map (
      clk=>clk, reset=>reset,
      -- from video sync
      pixel_x=>pixel_x, pixel_y=>pixel_y,
      p_tick=>p_tick, 
      -- avalon bus interface 
      vga_rd_data=>vga_rd_data,
      cpu_rd_data=>cpu_rd_data,
      cpu_wr_data=>vga_writedata(7 downto 0),      
      cpu_addr=>vga_address(18 downto 0),      
      cpu_mem_wr=>wr_vram,
      cpu_mem_rd=>rd_vram,
      -- to/from SRAM chip
      sram_addr=>sram_addr,sram_dq=>sram_dq,
      sram_we_n=>sram_we_n, sram_oe_n=>sram_oe_n,
      sram_ce_n=>sram_ce_n, sram_ub_n=>sram_ub_n, 
      sram_lb_n=>sram_lb_n
   );
   -- instantiate palette table (8-bit to 12-bit conversion)
   palet_unit: entity work.palette 
   port map (
      color_in=>vga_rd_data,
      color_out=>color);
   -- delay vga sync to accomodate memory access 
   process (clk)
   begin
      if (clk'event and clk='1') then
         if (p_tick='1') then
            vsync <= vsync_i;
            hsync <= hsync_i;
            video_on_reg <= video_on_i;
         end if; 
      end if;
   end process;
   -- memory read/write decoding
   wr_vram <= 
      '1' when vga_write='1' and vga_chipselect='1' and 
               vga_address(19)='0' else
      '0';             
   rd_vram <= 
      '1' when vga_read='1' and vga_chipselect='1' and 
               vga_address(19)='0' else
      '0';             
   -- input data mux
   vga_readdata <= x"000000" & cpu_rd_data when vga_address(19)='0' else
                   x"000" & pixel_y & pixel_x;                
   rgb <= (others=>'0') when video_on_reg='0' else color;              
end arch;
