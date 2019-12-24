 function SLV_TO_ASCII_HEX (
    SLV : in std_logic_vector  
    ) return std_logic_vector is

    variable i : integer := 1;   
    variable STR : std_logic_vector((SLV'length*2)-1 downto 0);
    variable nibble : std_logic_vector(3 downto 0) := "0000";
    variable full_nibble_count : natural := 0;

  begin
    full_nibble_count := SLV'length/4;
    for i in 1 to full_nibble_count loop
      nibble := SLV(((4*i) - 1) downto ((4*i) - 4));
      if (nibble = "0000")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110000"; -- 0
      elsif (nibble = "0001")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110001"; -- 1
      elsif (nibble = "0010")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110010"; -- 2
      elsif (nibble = "0011")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110011"; -- 3
      elsif (nibble = "0100")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110100"; -- 4
      elsif (nibble = "0101")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110101"; -- 5
      elsif (nibble = "0110")  then
        STR((8*i)-1 downto (8*(i-1))) := "00110110"; -- 6
      elsif (nibble = "0111")  then
      STR((8*i)-1 downto (8*(i-1))) := "00110111";  -- 7
      elsif (nibble = "1000")  then
        STR((8*i)-1 downto (8*(i-1))) := "00111000"; -- 8
      elsif (nibble = "1001")  then
      STR((8*i)-1 downto (8*(i-1))) := "00111001";  -- 9
      elsif (nibble = "1010")  then
        STR((8*i)-1 downto (8*(i-1))) := "01000001"; -- A
      elsif (nibble = "1011")  then
       STR((8*i)-1 downto (8*(i-1))) := "01000010";  -- B
      elsif (nibble = "1100")  then
       STR((8*i)-1 downto (8*(i-1))) := "01000011";  -- C
      elsif (nibble = "1101")  then
       STR((8*i)-1 downto (8*(i-1))) := "01000100";  -- D
      elsif (nibble = "1110")  then
       STR((8*i)-1 downto (8*(i-1))) := "01000101";  -- E
      elsif (nibble = "1111")  then
        STR((8*i)-1 downto (8*(i-1))) := "01000110"; -- F        
      end if;    
    end loop;
    return STR;
  end SLV_TO_ASCII_HEX; 
  
  
  
   function SLV_TO_ASCII_HEX_simp(
    SLV : in std_logic_vector;  
    ) return std_logic_vector is
  
    variable STR : std_logic_vector(7 downto 0);    

  begin
      if (SLV = "0000")  then
        STR := "00110000"; -- 0
      elsif (nibble = "0001")  then
        STR := "00110001"; -- 1
      elsif (nibble = "0010")  then
      STR := "00110010"; -- 2
      elsif (nibble = "0011")  then
        STR := "00110011"; -- 3
      elsif (nibble = "0100")  then
        STR := "00110100"; -- 4
      elsif (nibble = "0101")  then
        STR := "00110101"; -- 5
      elsif (nibble = "0110")  then
        STR := "00110110"; -- 6
      elsif (nibble = "0111")  then
       STR :="00110111";  -- 7
      elsif (nibble = "1000")  then
        STR := "00111000"; -- 8
      elsif (nibble = "1001")  then
       STR := "00111001";  -- 9
      elsif (nibble = "1010")  then
        STR := "01000001"; -- A
      elsif (nibble = "1011")  then
       STR := "01000010";  -- B
      elsif (nibble = "1100")  then
       STR := "01000011";  -- C
      elsif (nibble = "1101")  then
       STR := "01000100";  -- D
      elsif (nibble = "1110")  then
       STR := "01000101";  -- E
      elsif (nibble = "1111")  then
       STR := "01000110"; -- F        
      end if;    
    end loop;
    return STR;
  end SLV_TO_ASCII_HEX_simp; 
  
  
  