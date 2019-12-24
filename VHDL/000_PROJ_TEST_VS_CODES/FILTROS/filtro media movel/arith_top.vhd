
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity arith_top is
  generic (
    SAMPLE_SIZE     : natural   := 46;
    ACC_BITS        : natural   := 8;
    MEM_BUFFER_SIZE : natural   := 128;
    SHIFT_DIV_BITS  : natural   := 7    -- log2(MEM_BUFFER_SIZE)
    );
  port (
    sysclk             : in  std_logic;
    reset_n            : in  std_logic;
    sample_available_i : in  std_logic;
    ready_sample_n_o   : out std_logic;
    sample_n_i         : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
    average_offset_n_o : out std_logic_vector(SAMPLE_SIZE-1 downto 0)

    );

end arith_top;

-------------------------------------------------------------------------------

architecture arith_top_rtl of arith_top is


  signal arith_result, arith_result_reg, 
			shift_result_tmp : std_logic_vector((SAMPLE_SIZE+ACC_BITS)-1 downto 0);
  signal subt_result, subt_result_reg                                   : std_logic_vector((SAMPLE_SIZE+ACC_BITS)-1 downto 0);
  signal shift_result_reg                                               : std_logic_vector((SAMPLE_SIZE+ACC_BITS)-1 downto 0);
  signal sample_n_i_reg                                                 : std_logic_vector(SAMPLE_SIZE-1 downto 0);
  signal sample_available_i_reg                                         : std_logic;
  signal ready_arith_reg, ready_arith                                   : std_logic;
  signal ready_div_1_reg                                                : std_logic;
  signal ready_subt_reg                                                 : std_logic;


  signal ready_div_1, do_subtraction, save_div, ready_offset, save_arith : std_logic;



begin

  reg_1 : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      sample_available_i_reg <= '0';
      sample_n_i_reg         <= (others => '0');
    elsif rising_edge(sysclk) then
      sample_n_i_reg         <= sample_n_i;
      sample_available_i_reg <= sample_available_i;
    end if;
  end process;


  arith_ctrl_1 : entity work.arith_ctrl
    generic map (
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SAMPLE_SIZE     => SAMPLE_SIZE,
      ACC_BITS        => ACC_BITS)
    port map (
      sysclk           => sysclk,
      reset_n          => reset_n,
      data_i           => sample_n_i_reg,
      data_o           => arith_result,
      data_available_i => sample_available_i_reg,
      ready_o          => ready_arith);

  

	  
  reg_2 : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      arith_result_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if save_arith = '1' then
        arith_result_reg <= arith_result;
      end if;
    end if;
  end process;
 

--divisao 
shift_result_tmp <= std_logic_vector(shift_right(signed(arith_result_reg),SHIFT_DIV_BITS));

  
  
  
  process(reset_n, sysclk)
  begin
      if (reset_n = '0') then
        shift_result_reg <= (others => '0');
      elsif rising_edge(sysclk) then
        if save_div = '1' then
          shift_result_reg <= shift_result_tmp;
        end if;
      end if;
  end process;	  
	   

  --subtracao - remocao do offset
  subt_result <= std_logic_vector(signed(sample_n_i_reg) - signed(shift_result_reg));


  reg_4 : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      subt_result_reg <= (others => '0');
    elsif rising_edge(sysclk) then
      if do_subtraction = '1' then
        subt_result_reg <= subt_result;
      end if;
    end if;
  end process;


  average_offset_n_o <= std_logic_vector(resize(signed(subt_result_reg), SAMPLE_SIZE));
  ready_sample_n_o   <= ready_offset;


  arith_top_fsm_1 : entity work.arith_top_fsm

    port map (
      sysclk  => sysclk,
      reset_n => reset_n,

      ready_arith_i   => ready_arith,
      sample_ok_reg_i => sample_available_i_reg,


      save_arith_o     => save_arith,
      save_div_o       => save_div,
      do_subtraction_o => do_subtraction,
      ready_o          => ready_offset

      );



  
 --arith_ctrl_1 : entity work.arith_ctrl
 --   generic map (
 --     MEM_BUFFER_SIZE => MEM_BUFFER_SIZE_TESTE,
 --     SAMPLE_SIZE     => SAMPLE_SIZE,
 --     ACC_BITS        => ACC_BITS)
 --   port map (
 --     sysclk           => sysclk,
 --     reset_n          => reset_n,
 --     data_i           => sample_n_i_reg,
 --     data_o           => arith_result_test,
 --     data_available_i => sample_available_i_reg,
 --     ready_o          => ready_arith_test);
  

 --  teste divisor

 -- divider_1: entity work.divider
 --   generic map (
 --     SIGN => '1',
 --     N    => SAMPLE_SIZE,
 --     D    => SAMPLE_SIZE)
 --   port map (
 --     sysclk  => sysclk,
 --     n_reset => reset_n,
 --     start   => ready_arith_test,
 --     num     => arith_result_test,
 --     den     => MEM_BUFFER_SIZE_TEST,
 --     quo     => quo_result_test,
 --     rema    => open,
 --     ready   => open,
 --     done    => open);



 -- subt_result_test <= std_logic_vector(signed(sample_n_i_reg) - signed(shift_result_reg)) when done_test = '1' else
 --   subt_result_test;
  

 -- signal done_test : std_logic;
 -- signal subt_result_test : std_logic_vector(subt_result'range);
 -- signal quo_result_test : std_logic_vector(shift_result_tmp'range);
 -- signal arith_result_test : std_logic_vector(arith_result'range);
 -- signal ready_arith_test : std_logic;
 -- constant MEM_BUFFER_SIZE_TESTE : natural := 80;
  
  
  
  
  
end arith_top_rtl;

