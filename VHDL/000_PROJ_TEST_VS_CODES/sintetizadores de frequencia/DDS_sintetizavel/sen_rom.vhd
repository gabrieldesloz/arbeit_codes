
library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity sen_rom is
  generic
    (
      DATA_WIDTH  : natural := 10;
      arq_escrita : string  := "full_sin.txt"
      );

  port(
    clk   : in  std_logic;
    addr  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    q     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    q_reg : out std_logic_vector(DATA_WIDTH-1 downto 0));

end entity sen_rom;

architecture sen_rom_arq_1_4 of sen_rom is
  
  type MAT_SEN is array (0 to 2**DATA_WIDTH-1)
    of unsigned(DATA_WIDTH-1 downto 0);
  signal TAB_SEN     : MAT_SEN;
  constant max_value : integer := 2**DATA_WIDTH;
begin
  
  TAB_SENO : for i in 0 to max_value-1 generate
    constant t3 : real                            := real(max_value);
    constant t2 : real                            := MATH_PI/2.0;  --2*pi
    constant t1 : real                            := real(i);
    constant t0 : real                            := sin((t1*t2) / t3);
    constant z1 : integer                         := integer(t0 * real(max_value));
    constant z2 : unsigned                        := to_unsigned(z1, DATA_WIDTH);
    constant z0 : unsigned(DATA_WIDTH-1 downto 0) := z2;
  begin
    TAB_SEN(i) <= z0;
  end generate;

  q <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));

  process(clk)
  begin
    if(rising_edge(clk)) then
      q_reg <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));
    end if;
  end process;
  
end sen_rom_arq_1_4;

architecture sen_rom_onda_completa of sen_rom is

-- seno onda completa com perda de resolu��o    
  type MAT_SEN is array (0 to 2**DATA_WIDTH-1)
    of unsigned(DATA_WIDTH-1 downto 0);
  signal TAB_SEN      : MAT_SEN;
-- valor maximo (255 para n�o haver descontinuidade em z2)
  constant max_value  : integer := (2**DATA_WIDTH)-1;
  constant half_value : integer := ((max_value+1)/2)-1;  
  constant offset     : integer := max_value/2;

begin
  
  TAB_SENO : for i in 0 to max_value generate
    constant t3 : real                            := real(max_value);
    constant t2 : real                            := MATH_PI*2.0;  -- 2*pi --> onda completa
    constant t1 : real                            := real(i);
    constant t0 : real                            := sin((t1*t2) / t3);
    -- ajuste da onda senoidal para eliminar valores negativos
    constant z1 : integer                         := integer(t0 * real(half_value)) + offset;
    constant z2 : unsigned                        := to_unsigned(z1, DATA_WIDTH);
    constant z0 : unsigned(DATA_WIDTH-1 downto 0) := z2;
  begin
    TAB_SEN(i) <= z0;
  end generate;

  q <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));

  process(clk)
  begin
    if(rising_edge(clk)) then
      q_reg <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));
    end if;
  end process;
  
end sen_rom_onda_completa;


architecture cos_rom_onda_completa of sen_rom is

-- seno onda completa com perda de resolu��o    
  type MAT_SEN is array (0 to 2**DATA_WIDTH-1)
    of unsigned(DATA_WIDTH-1 downto 0);
  signal TAB_SEN      : MAT_SEN;
-- valor maximo (255 para n�o haver descontinuidade em z2)
  constant max_value  : integer := (2**DATA_WIDTH)-1;
  constant half_value : integer := ((max_value+1)/2)-1;  
  constant offset     : integer := max_value/2;

begin
  
  TAB_SENO : for i in 0 to max_value generate
    constant t3 : real                            := real(max_value);
    constant t2 : real                            := MATH_PI*2.0;  -- 2*pi --> onda completa
    constant t1 : real                            := real(i);
    constant t0 : real                            := cos((t1*t2) / t3);
    -- ajuste da onda senoidal para eliminar valores negativos
    constant z1 : integer                         := integer(t0 * real(half_value)) + offset;
    constant z2 : unsigned                        := to_unsigned(z1, DATA_WIDTH);
    constant z0 : unsigned(DATA_WIDTH-1 downto 0) := z2;
  begin
    TAB_SEN(i) <= z0;
  end generate;

  q <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));

  process(clk)
  begin
    if(rising_edge(clk)) then
      q_reg <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));
    end if;
  end process;
  
end cos_rom_onda_completa;



architecture full_sin_proc of sen_rom is
  -- arquitetura que tem a finalidade de escrever o seno em um arquivo txt
  --procedimento de escrita de arquivos
  procedure full_sin (file_name : in string) is
    
    file file_out  : text open append_mode is file_name;  --WRITE_MODE ou READ_MODE 
    variable linha : line;

    -- valor maximo     (255 para n�o haver descontinuidade em z2)
    constant max_value  : integer := (2**DATA_WIDTH)-1;
    constant half_value : integer := ((max_value+1)/2)-1;
    constant offset     : integer := max_value/2;
    constant t3         : real    := real(max_value);
    constant t2         : real    := MATH_PI*2.0;  -- 2*pi --> onda completa                
    variable t1         : real;
    variable t0         : real;
    variable z1         : integer;
    variable z2         : unsigned(DATA_WIDTH-1 downto 0);
    --convers�o para std_logic_vector por causa da compatibilidade da biblioteca text.io
    variable z3         : std_logic_vector(DATA_WIDTH-1 downto 0);
    
  begin
    
    for i in 0 to max_value loop
      t1 := real(i);
      t0 := sin((t1*t2) / t3);
      z1 := integer(t0 * real(half_value)) + offset;
      z2 := to_unsigned(z1, DATA_WIDTH);
      z3 := std_logic_vector(z2);

      write(linha, z3);
      writeline(file_out, linha);
      
    end loop;
    
  end procedure full_sin;
  
begin
  --simular para que seja criado o arquivo
  grava_arquivo : full_sin(arq_escrita);
  
end full_sin_proc;



architecture full_sin_read of sen_rom is
  -- arquitetura que tem a finalidade de ler os valores seno de um arquivo txt
  
  type MAT_SEN is array (0 to 2**DATA_WIDTH-1)
    of std_logic_vector(DATA_WIDTH-1 downto 0);
  
  
  impure function input_txt (file_name : in string) return MAT_SEN is  -- retorna o tipo
    
    file file_in    : text open read_mode is file_name;
    variable linha  : line;
    variable i      : natural := 0;
    variable str    : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable matriz : MAT_SEN;
  begin
    loop1 : while not endfile(file_in) loop
      ler_linha : for i in 0 to (2**(DATA_WIDTH)-1) loop
        readline(file_in, linha);
        read (linha, str);
        matriz(i) := str;
      end loop ler_linha;
    end loop loop1;
    return matriz;
  end function input_txt;

  signal TAB_SEN : MAT_SEN := input_txt(arq_escrita);
  
begin
  
  q <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));

  process(clk)
  begin
    if(rising_edge(clk)) then
      q_reg <= std_logic_vector(TAB_SEN(to_integer(unsigned(addr))));
    end if;
  end process;
  
end full_sin_read;



architecture full_sin_proc_virg of sen_rom is
  -- arquitetura que tem a finalidade de escrever o seno em um arquivo txt
  --procedimento de escrita de arquivos
  procedure full_sin (file_name : in string) is
    
    file file_out  : text open append_mode is file_name;  --WRITE_MODE ou READ_MODE 
    variable linha : line;

    -- valor maximo     (255 para n�o haver descontinuidade em z2)
    constant max_value  : integer   := (2**DATA_WIDTH)-1;
    constant half_value : integer   := ((max_value+1)/2)-1;
    constant offset     : integer   := max_value/2;
    constant t3         : real      := real(max_value);
    constant t2         : real      := MATH_PI*2.0;  -- 2*pi --> onda completa                
    variable t1         : real;
    variable t0         : real;
    variable z1         : integer;
    variable z2         : unsigned(DATA_WIDTH-1 downto 0);
    --convers�o para std_logic_vector por causa da compatibilidade da biblioteca text.io
    variable z3         : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable t          : character := '"';    
    
  begin
    
    for i in 0 to max_value loop
      t1 := real(i);
      t0 := sin((t1*t2) / t3);
      z1 := integer(t0 * real(half_value)) + offset;
      z2 := to_unsigned(z1, DATA_WIDTH);
      z3 := std_logic_vector(z2);

      write(linha, t);
      write(linha, z3);
      write(linha, t);
      write(linha, string'(","));
      writeline(file_out, linha);
      
    end loop;
    
  end procedure full_sin;
  
begin
  --simular para que seja criado o arquivo
  grava_arquivo : full_sin(arq_escrita);
  
end full_sin_proc_virg;


architecture full_sin_mif_altera of sen_rom is
-- arquitetura que tem a finalidade de escrever o seno em um arquivo txt, para ser usado nos 
-- n�cleos de mem�ria da Altera, LPM_RAM/LPM_ROM
  


  procedure HWRITE(L         : inout line; VALUE : in std_logic_vector;
                   JUSTIFIED : in    side := right; FIELD : in WIDTH := 0) is
    variable quad : std_logic_vector(0 to 3);
    constant ne   : integer                               := value'length/4;
    variable bv   : std_logic_vector(0 to value'length-1) := value;
    variable s    : string(1 to ne);
  begin
    if value'length mod 4 /= 0 then
      assert false report
        "HWRITE Error: Trying to read vector " &
        "with an odd (non multiple of 4) length";
      return;
    end if;

    for i in 0 to ne-1 loop
      quad := bv(4*i to 4*i+3);
      case quad is
        when x"0"   => s(i+1) := '0';
        when x"1"   => s(i+1) := '1';
        when x"2"   => s(i+1) := '2';
        when x"3"   => s(i+1) := '3';
        when x"4"   => s(i+1) := '4';
        when x"5"   => s(i+1) := '5';
        when x"6"   => s(i+1) := '6';
        when x"7"   => s(i+1) := '7';
        when x"8"   => s(i+1) := '8';
        when x"9"   => s(i+1) := '9';
        when x"A"   => s(i+1) := 'A';
        when x"B"   => s(i+1) := 'B';
        when x"C"   => s(i+1) := 'C';
        when x"D"   => s(i+1) := 'D';
        when x"E"   => s(i+1) := 'E';
        when x"F"   => s(i+1) := 'F';
        when others => null;
      end case;
    end loop;
    write(L, s, JUSTIFIED, FIELD);
  end HWRITE;


  procedure full_sin (file_name : in string) is
    
    file file_out  : text open append_mode is file_name;  --WRITE_MODE ou READ_MODE 
    variable linha : line;


    constant max_value  : integer   := (2**DATA_WIDTH)-1;
    constant half_value : integer   := ((max_value+1)/2)-1;
    constant offset     : integer   := max_value/2;
    constant t3         : real      := real(max_value);
    constant t2         : real      := MATH_PI*2.0;  -- 2*pi --> onda completa                
    variable t1         : real;
    variable t0         : real;
    variable z1         : integer;
    variable z2         : unsigned(DATA_WIDTH-1 downto 0);
    variable z3         : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable t          : character := ';';
    variable y          : character := ' ';
    variable z          : character := ':';
    
  begin
    
    write(linha, string'("WIDTH="));
    write(linha, DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("DEPTH="));
    write(linha, 2**DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("ADDRESS_RADIX=HEX;"));
    writeline(file_out, linha);
    write(linha, string'("DATA_RADIX = BIN;"));
    writeline(file_out, linha);
    write(linha, string'("CONTENT BEGIN"));
    writeline(file_out, linha);
    writeline(file_out, linha);

    for i in 0 to max_value loop
      t1 := real(i);
      t0 := sin((t1*t2) / t3);
      z1 := integer(t0 * real(half_value)) + offset;
      z2 := to_unsigned(z1, DATA_WIDTH);
      z3 := std_logic_vector(z2);

      -- converte o vetor em hexadecimal -- usa procedure adaptado, s� funciona com mult de 4
      hwrite(linha, std_logic_vector(to_unsigned(i, 12)));  -- 12 - multiplo de 4 
      write(linha, y);
      write(linha, z);
      write(linha, y);
      write(linha, z3);
      write(linha, t);
      writeline(file_out, linha);
    end loop;
    writeline(file_out, linha);
    write(linha, string'("END;"));
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    
  end procedure full_sin;
  
begin
  --simular para que seja criado o arquivo
  grava_arquivo : full_sin("full_sin.mif");
  
end full_sin_mif_altera;

architecture full_sincos_mif_altera of sen_rom is
-- arquitetura que tem a finalidade de escrever o seno em um arquivo txt, para ser usado nos 
-- n�cleos de mem�ria da Altera, LPM_RAM/LPM_ROM
  


  procedure HWRITE(L         : inout line; VALUE : in std_logic_vector;
                   JUSTIFIED : in    side := right; FIELD : in WIDTH := 0) is
    variable quad : std_logic_vector(0 to 3);
    constant ne   : integer                               := value'length/4;
    variable bv   : std_logic_vector(0 to value'length-1) := value;
    variable s    : string(1 to ne);
  begin
    if value'length mod 4 /= 0 then
      assert false report
        "HWRITE Error: Trying to read vector " &
        "with an odd (non multiple of 4) length";
      return;
    end if;

    for i in 0 to ne-1 loop
      quad := bv(4*i to 4*i+3);
      case quad is
        when x"0"   => s(i+1) := '0';
        when x"1"   => s(i+1) := '1';
        when x"2"   => s(i+1) := '2';
        when x"3"   => s(i+1) := '3';
        when x"4"   => s(i+1) := '4';
        when x"5"   => s(i+1) := '5';
        when x"6"   => s(i+1) := '6';
        when x"7"   => s(i+1) := '7';
        when x"8"   => s(i+1) := '8';
        when x"9"   => s(i+1) := '9';
        when x"A"   => s(i+1) := 'A';
        when x"B"   => s(i+1) := 'B';
        when x"C"   => s(i+1) := 'C';
        when x"D"   => s(i+1) := 'D';
        when x"E"   => s(i+1) := 'E';
        when x"F"   => s(i+1) := 'F';
        when others => null;
      end case;
    end loop;
    write(L, s, JUSTIFIED, FIELD);
  end HWRITE;


  procedure full_sin (file_name : in string) is
    
    file file_out  : text open append_mode is file_name;  --WRITE_MODE ou READ_MODE 
    variable linha : line;


    constant max_value  : integer   := (2**DATA_WIDTH)-1;
    constant half_value : integer   := ((max_value+1)/2)-1;
    constant offset     : integer   := max_value/2;
    constant t3         : real      := real(max_value);
    constant t2         : real      := MATH_PI*2.0;  -- 2*pi --> onda completa                
    variable t1         : real;
    variable t0         : real;
    variable z1         : integer;
    variable z2         : unsigned(DATA_WIDTH-1 downto 0);
    variable z3         : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable t          : character := ';';
    variable y          : character := ' ';
    variable z          : character := ':';
    --variable address                  : std_logic_vector(9 downto 0):=X"00"; 
    
  begin
    
    write(linha, string'("WIDTH="));
    write(linha, DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("DEPTH="));
    write(linha, 2**DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("ADDRESS_RADIX=HEX;"));
    writeline(file_out, linha);
    write(linha, string'("DATA_RADIX = BIN;"));
    writeline(file_out, linha);
    write(linha, string'("CONTENT BEGIN"));
    writeline(file_out, linha);
    writeline(file_out, linha);

    for i in 0 to max_value + ((2**DATA_WIDTH)/4) loop  -- + 90 graus -- 10bits: 1280 posi��es, 11bits de endere�o 
      t1 := real(i);
      t0 := sin((t1*t2) / t3);
      z1 := integer(t0 * real(half_value)) + offset;
      z2 := to_unsigned(z1, DATA_WIDTH);
      z3 := std_logic_vector(z2);

      -- converte o vetor em hexadecimal -- usa procedure adaptado, s� funciona com mult de 4
      hwrite(linha, std_logic_vector(to_unsigned(i, 12)));  -- 12 - multiplo de 4 
      write(linha, y);
      write(linha, z);
      write(linha, y);
      write(linha, z3);
      write(linha, t);
      writeline(file_out, linha);
    end loop;
    writeline(file_out, linha);
    write(linha, string'("END;"));
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    
  end procedure full_sin;
  
begin
  --simular para que seja criado o arquivo
  grava_arquivo : full_sin("full_sin.mif");
  
end full_sincos_mif_altera;


architecture sin1_4_mif_altera of sen_rom is
-- arquitetura que tem a finalidade de escrever o seno em um arquivo txt, para ser usado nos 
-- n�cleos de mem�ria da Altera, LPM_RAM/LPM_ROM
  


  procedure HWRITE(L         : inout line; VALUE : in std_logic_vector;
                   JUSTIFIED : in    side := right; FIELD : in WIDTH := 0) is
    variable quad : std_logic_vector(0 to 3);
    constant ne   : integer                               := value'length/4;
    variable bv   : std_logic_vector(0 to value'length-1) := value;
    variable s    : string(1 to ne);
  begin
    if value'length mod 4 /= 0 then
      assert false report
        "HWRITE Error: Trying to read vector " &
        "with an odd (non multiple of 4) length";
      return;
    end if;

    for i in 0 to ne-1 loop
      quad := bv(4*i to 4*i+3);
      case quad is
        when x"0"   => s(i+1) := '0';
        when x"1"   => s(i+1) := '1';
        when x"2"   => s(i+1) := '2';
        when x"3"   => s(i+1) := '3';
        when x"4"   => s(i+1) := '4';
        when x"5"   => s(i+1) := '5';
        when x"6"   => s(i+1) := '6';
        when x"7"   => s(i+1) := '7';
        when x"8"   => s(i+1) := '8';
        when x"9"   => s(i+1) := '9';
        when x"A"   => s(i+1) := 'A';
        when x"B"   => s(i+1) := 'B';
        when x"C"   => s(i+1) := 'C';
        when x"D"   => s(i+1) := 'D';
        when x"E"   => s(i+1) := 'E';
        when x"F"   => s(i+1) := 'F';
        when others => null;
      end case;
    end loop;
    write(L, s, JUSTIFIED, FIELD);
  end HWRITE;


  procedure sin1_4 (file_name : in string) is
    
    file file_out  : text open write_mode is file_name;  --APPEND_MODE ou READ_MODE 
    variable linha : line;


    constant max_value : integer   := (2**DATA_WIDTH)-1;
    --constant half_value                       : integer := ((max_value+1)/2)-1; -- para onda completa
    --constant offset                   : integer := max_value/2; -- para onda completa
    constant t3        : real      := real(max_value);
    constant t2        : real      := MATH_PI/2.0;  -- 2*pi --> onda completa                
    variable t1        : real;
    variable t0        : real;
    variable z1        : integer;
    variable z2        : unsigned(DATA_WIDTH-1 downto 0);
    variable z3        : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable t         : character := ';';
    variable y         : character := ' ';
    variable z         : character := ':';
    
  begin
    
    write(linha, string'("WIDTH="));
    write(linha, DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("DEPTH="));
    write(linha, 2**DATA_WIDTH);
    write(linha, t);
    writeline(file_out, linha);
    write(linha, string'("ADDRESS_RADIX=HEX;"));
    writeline(file_out, linha);
    write(linha, string'("DATA_RADIX = BIN;"));
    writeline(file_out, linha);
    write(linha, string'("CONTENT BEGIN"));
    writeline(file_out, linha);
    writeline(file_out, linha);

    for i in 0 to max_value loop
      t1 := real(i);
      t0 := sin((t1*t2) / t3);
      -- z1 :=  integer(t0 * real(half_value)) + offset;        PARA ONDA COMPLETA                              
      z1 := integer(t0 * real(max_value));
      z2 := to_unsigned(z1, DATA_WIDTH);
      z3 := std_logic_vector(z2);

      -- converte o vetor em hexadecimal -- usa procedure adaptado, s� funciona com mult de 4
      hwrite(linha, std_logic_vector(to_unsigned(i, 12)));  -- 12 - multiplo de 4 
      write(linha, y);
      write(linha, z);
      write(linha, y);
      write(linha, z3);
      write(linha, t);
      writeline(file_out, linha);
    end loop;
    writeline(file_out, linha);
    write(linha, string'("END;"));
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    writeline(file_out, linha);
    
  end procedure sin1_4;
  
begin
  --simular para que seja criado o arquivo
  grava_arquivo : sin1_4("sin1_4_altera.mif");
  
end sin1_4_mif_altera;





