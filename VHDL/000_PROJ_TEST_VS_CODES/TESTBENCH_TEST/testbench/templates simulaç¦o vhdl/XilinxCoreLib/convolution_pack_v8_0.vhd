--
--  (c) Copyright 1995-2005, 2009 Xilinx, Inc. All rights reserved.
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


library ieee;
use ieee.std_logic_1164.all;  -- needed for logic operations

PACKAGE convolution_pack_v8_0 IS

------------------------------------------------------------
-- Default values
------------------------------------------------------------
  -- axi
  constant   c_has_aclken_default               : integer := 0;
  constant   c_has_m_axis_data_tready_default   : integer := 0;
  constant   c_xdevicefamily_default            : string  := "no_family";
  constant   c_family_default                   : string  := "no_family";

  -- encoding
  constant   c_s_axis_data_tdata_width_default : integer := 8; 
  constant   c_m_axis_data_tdata_width_default: integer := 8;
  constant   c_din_width                        : integer := 1;
  constant   c_dout_width_max                   : integer := 2;
  constant   c_output_rate_default              : integer := 2; 
  constant   c_constraint_length_default        : integer := 7; 
  constant   c_punctured_default                : integer := 0;
  constant   c_dual_channel_default             : integer := 0;
  constant   c_punc_input_rate_default          : integer := 3; 
  constant   c_punc_output_rate_default         : integer := 4;
  constant   c_convolution_code0_default        : integer := 121;
  constant   c_convolution_code1_default        : integer := 91;
  constant   c_convolution_code2_default        : integer := 5;
  constant   c_convolution_code3_default        : integer := 7;
  constant   c_convolution_code4_default        : integer := 5;
  constant   c_convolution_code5_default        : integer := 7;
  constant   c_convolution_code6_default        : integer := 5;
  constant   c_punc_code0_default               : integer := 0;
  constant   c_punc_code1_default               : integer := 0;

------------------------------------------------------------
--
------------------------------------------------------------

   CONSTANT new_line : STRING(1 TO 1) := (1 => lf); -- For assertion reports

   CONSTANT def_output_rate         : INTEGER := 7;
   CONSTANT def_constraint_limit    : INTEGER := 9;   
   CONSTANT def_puncin_rate_limit   : INTEGER := 16;

   CONSTANT DEFAULT_OUTPUT_RATE        : INTEGER := 3;   
   CONSTANT DEFAULT_CONSTRAINT_LENGTH  : INTEGER := 3;   
   CONSTANT DEFAULT_PUNCTURED          : INTEGER := 0;   
   CONSTANT DEFAULT_PUNC_INPUT_RATE    : INTEGER := 3;   
   CONSTANT DEFAULT_PUNC_OUTPUT_RATE    : INTEGER := 4;   
   CONSTANT DEFAULT_CONVOLUTION_LOGIC0 : INTEGER := 5;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC1 : INTEGER := 7;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC2 : INTEGER := 7;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC3 : INTEGER := 7;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC4 : INTEGER := 7;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC5 : INTEGER := 7;  
   CONSTANT DEFAULT_CONVOLUTION_LOGIC6 : INTEGER := 7;  
   CONSTANT DEFAULT_PUNCTURE_CODE0     : INTEGER := 0;   
   CONSTANT DEFAULT_PUNCTURE_CODE1     : INTEGER := 0;   
   CONSTANT DEFAULT_HAS_ND             : INTEGER := 0;       
   CONSTANT DEFAULT_HAS_RFD            : INTEGER := 0;      
   CONSTANT DEFAULT_HAS_RDY            : INTEGER := 0;      
   CONSTANT DEFAULT_HAS_FD             : INTEGER := 0;       
   CONSTANT DEFAULT_HAS_RFFD           : INTEGER := 0;     
   CONSTANT DEFAULT_HAS_CE             : INTEGER := 1;     
   CONSTANT DEFAULT_SYNC_ENABLE        : INTEGER := 0;   
   CONSTANT DEFAULT_HAS_SCLR           : INTEGER := 0;  
      
   TYPE convolution_array  IS ARRAY (0 TO def_output_rate-1) OF INTEGER;
   TYPE punctured_array    IS ARRAY (0 TO 1) OF INTEGER;

   FUNCTION select_val(i0 : INTEGER; i1 : INTEGER; sel : BOOLEAN) 
      RETURN INTEGER;
   FUNCTION count_bits( data,bit_width : INTEGER)
      RETURN INTEGER;
   FUNCTION count1s(value : INTEGER)
      RETURN INTEGER;
  FUNCTION int_2_std_logic_vector( value, bitwidth : INTEGER )
    RETURN std_logic_vector;
  FUNCTION two_comp(vect : std_logic_vector)
    RETURN std_logic_vector;


END convolution_pack_v8_0;
PACKAGE BODY convolution_pack_v8_0 IS

--------------------------------------------------------------------------------
    FUNCTION select_val(i0 : INTEGER; i1 : INTEGER; sel : BOOLEAN) RETURN INTEGER IS
    BEGIN
        IF sel THEN
            RETURN i1;
        ELSE
            RETURN i0;
        END IF; -- sel
    END select_val;
-- ------------------------------------------------------------------------ --
   FUNCTION count_bits( data,bit_width : INTEGER
                        )
      RETURN INTEGER IS
   VARIABLE total_bits,data_reduced : INTEGER;  
   BEGIN
      total_bits := 0;
      data_reduced := data;
      FOR i IN 0 TO bit_width-1 LOOP
         IF (data_reduced REM 2) = 1 THEN
            total_bits := total_bits +1;
         END IF;  
         data_reduced := data_reduced/2;
      END LOOP;
      RETURN total_bits;
   END count_bits;      
   
-- ------------------------------------------------------------------------ --
FUNCTION count1s(value : INTEGER)
   RETURN INTEGER IS
VARIABLE cnt_bits : INTEGER;
VARIABLE vl : INTEGER := value;
BEGIN
   cnt_bits := 0;
   FOR j in 0 TO 32 -1 LOOP
      IF((vl MOD 2) = 1) THEN
         cnt_bits := cnt_bits + 1;
      END IF;
      vl := vl/2;
      IF(vl = 0) THEN
         EXIT;
      END IF;         
   END LOOP;
   RETURN cnt_bits;
END count1s;
-- ------------------------------------------------------------------------ --
  FUNCTION int_2_std_logic_vector( value, bitwidth : INTEGER )
    RETURN std_logic_vector IS

    VARIABLE running_value  : INTEGER := value;
    VARIABLE running_result : std_logic_vector(bitwidth-1 DOWNTO 0);

  BEGIN

    IF (value < 0) THEN
      running_value := -1 * value;
    END IF;

    FOR i IN 0 TO bitwidth-1 LOOP

      IF running_value MOD 2 = 0 THEN
        running_result(i) := '0';
      ELSE
        running_result(i) := '1';
      END IF;
        running_value := running_value/2;
    END LOOP;

    IF (value < 0) THEN -- find the 2s complement
       RETURN two_comp(running_result);
    ELSE
      RETURN running_result;
    END IF;

  END int_2_std_logic_vector;

-- ------------------------------------------------------------------------ --
  FUNCTION two_comp(vect : std_logic_vector)
    RETURN std_logic_vector IS

  variable local_vect : std_logic_vector(vect'HIGH downto 0);
  variable toggle : INTEGER := 0;

  BEGIN

    FOR i IN 0 to vect'HIGH LOOP
      IF (toggle = 1) THEN
	IF (vect(i) = '0') THEN
	  local_vect(i) := '1';
	ELSE
	  local_vect(i) := '0';
	END IF;
      ELSE
	local_vect(i) := vect(i);
	IF (vect(i) = '1') THEN
	  toggle := 1;
	END IF;
      END IF;
    END LOOP;

    RETURN local_vect;

  END two_comp;

-- ------------------------------------------------------------------------ --

END convolution_pack_v8_0;

-- ------------------------------------------------------------------------ --
