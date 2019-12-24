------------------------------------------------------------------------------------------------------------------------
-- $Header: /devl/xcs/repo/env/Databases/ip/src2/O/axi_utils_v1_1/simulation/global_util_pkg_v1_1.vhd,v 1.2 2011/02/03 13:17:40 drobins Exp $
------------------------------------------------------------------------------------------------------------------------
--
--  (c) Copyright 2009 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------------------------------------------------------
--
--  Title: global_util_pkg_v1_1.vhd
--  Author: David Andrews
--  Date  : August 2008
--  Description: Define global utility functions.
--               In general functions/types/constants that are not project specific are defined here.
--
--               Project specific functions/types/constants are defined in the
--               global_func_pkg/global_types_pkg/global_const_pkg packages
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package global_util_pkg_v1_1 is

  ------------------------------------------------------------------------------------------------------------------------
  --Useful Xilinx attributes
  attribute use_carry_chain      : string;
  attribute register_duplication : string;
  attribute use_clock_enable     : string;
  attribute use_sync_set         : string;
  attribute use_sync_reset       : string;
  attribute keep_hierarchy       : string;
  attribute signal_encoding      : string;
  attribute fsm_encoding         : string;
  attribute keep                 : string;
  attribute shreg_extract        : string;


  ------------------------------------------------------------------------------------------------------------------------
  --Generic integer vector
  type GLB_IntegerVector is array(natural range <>) of integer;

  --Generic natural vector
  type GLB_NaturalVector is array(natural range <>) of natural;

  --Generic positive vector
  type GLB_PositiveVector is array(natural range <>) of positive;

  --Generic real vector
  type GLB_RealVector is array(natural range <>) of real;

  --Boolean vector
  type GLB_BooleanVector is array(natural range <>) of boolean;

  ------------------------------------------------------------------------------------------------------------------------
  --Functions for determining environment

  --True if this is simulation
  function GLB_is_simulation return boolean;

  --True if this is synthesis/implementation
  function GLB_is_synthesis return boolean;

  ------------------------------------------------------------------------------------------------------------------------
  --Functions for reducing boolean vectors

  --True if any of the elements of a boolean_vector are true
  function GLB_any_true(v : GLB_BooleanVector) return boolean;

  --True if any of the elements of a boolean_vector are false
  function GLB_any_false(v : GLB_BooleanVector) return boolean;

  --True if all of the elements of a boolean_vector are true
  function GLB_all_true(v : GLB_BooleanVector) return boolean;

  --True if all of the elements of a boolean_vector are false
  function GLB_all_false(v : GLB_BooleanVector) return boolean;

  ------------------------------------------------------------------------------------------------------------------------
  --Calculate ceil(log2(x))
  function GLB_log2(x : natural) return natural;

  --Calculate min(ceil(log2(x)),y) (i.e. log2min(x,1) is always >=1)
  function GLB_log2min(x, y : natural) return natural;

  --Calculate next power-of-2 >=x
  function GLB_next_pow2(x : natural) return natural;

  --Find bit number of LSB/MSB in x
  function GLB_find_lsb(x : natural) return natural;
  function GLB_find_msb(x : natural) return natural;

  ------------------------------------------------------------------------------------------------------------------------
  --Return true if log2(x)==ceil(log2(x))
  function GLB_is_pow2(x : natural) return boolean;

  --Return true if x is even
  function GLB_is_even(x : integer) return boolean;
  function GLB_is_even(x : unsigned) return boolean;
  function GLB_is_even(x : signed) return boolean;

  --Return true if x is odd
  function GLB_is_odd(x : integer) return boolean;
  function GLB_is_odd(x : unsigned) return boolean;
  function GLB_is_odd(x : signed) return boolean;

  --Select a value based on boolean [equivalent to (cond ? v_true : v_false) in C/C++/Verilog]
  --  Overloaded for lots of useful types
  function GLB_if(cond : boolean; v_true, v_false : integer) return integer;
  function GLB_if(cond : boolean; v_true, v_false : real) return real;
  function GLB_if(cond : boolean; v_true, v_false : string) return string;
  function GLB_if(cond : boolean; v_true, v_false : std_logic) return std_logic;
  function GLB_if(cond : boolean; v_true, v_false : std_logic_vector) return std_logic_vector;
  function GLB_if(cond : boolean; v_true, v_false : signed) return signed;
  function GLB_if(cond : boolean; v_true, v_false : unsigned) return unsigned;
  function GLB_if(cond : boolean; v_true, v_false : time) return time;
  function GLB_if(cond : boolean; v_true, v_false : character) return character;
  function GLB_if(cond : boolean; v_true, v_false : boolean) return boolean;
  function GLB_if(cond : std_logic; v_true, v_false : std_logic) return std_logic;

  --Convert a boolean to std_logic (false->'0', true->'1')
  function GLB_to_std_logic(x : boolean) return std_logic;
  function GLB_to_sl(x        : boolean) return std_logic;

  --Convert a boolean to bit (false->'0', true->'1')
  function GLB_to_bit(x : boolean) return bit;

  --Convert a number to boolean (0->false, anything else->true)
  function GLB_to_boolean(x : integer) return boolean;
  function GLB_to_boolean(x : real) return boolean;

  --Convert a std_logic to boolean ('1/H'->true, anything else->false)
  function GLB_to_boolean(x : std_logic) return boolean;

  --Convert a boolean to integer (true->1, anything else->0)
  function GLB_to_integer(x : boolean) return integer;
  function GLB_to_integer(x : std_logic) return integer;

  --Return minimum of a pair of values
  function GLB_min(a, b : integer) return integer;
  function GLB_min(a, b : real) return real;
  function GLB_min(a, b : time) return time;
  function GLB_min(a, b : signed) return signed;
  function GLB_min(a, b : unsigned) return unsigned;

  --Return maximum of a pair of values
  function GLB_max(a, b : integer) return integer;
  function GLB_max(a, b : real) return real;
  function GLB_max(a, b : time) return time;
  function GLB_max(a, b : signed) return signed;
  function GLB_max(a, b : unsigned) return unsigned;

  --Limit value within range [a,b]
  function GLB_limit(value, a, b : integer) return integer;
  function GLB_limit(value, a, b : real) return real;
  function GLB_limit(value, a, b : time) return time;
  function GLB_limit(value, a, b : signed) return signed;
  function GLB_limit(value, a, b : unsigned) return unsigned;

  -----------------------------------------------------------------------------------------------------------------------
  --Reduce a std_logic_vector to std_logic by applying logic function
  function GLB_and_reduce(v  : std_logic_vector) return std_logic;
  function GLB_or_reduce(v   : std_logic_vector) return std_logic;
  function GLB_xor_reduce(v  : std_logic_vector) return std_logic;
  function GLB_nand_reduce(v : std_logic_vector) return std_logic;
  function GLB_nor_reduce(v  : std_logic_vector) return std_logic;
  function GLB_xnor_reduce(v : std_logic_vector) return std_logic;

  --Reduce a signed to std_logic by applying logic function
  function GLB_and_reduce(v  : signed) return std_logic;
  function GLB_or_reduce(v   : signed) return std_logic;
  function GLB_xor_reduce(v  : signed) return std_logic;
  function GLB_nand_reduce(v : signed) return std_logic;
  function GLB_nor_reduce(v  : signed) return std_logic;
  function GLB_xnor_reduce(v : signed) return std_logic;

  --Reduce an unsigned to std_logic by applying logic function
  function GLB_and_reduce(v  : unsigned) return std_logic;
  function GLB_or_reduce(v   : unsigned) return std_logic;
  function GLB_xor_reduce(v  : unsigned) return std_logic;
  function GLB_nand_reduce(v : unsigned) return std_logic;
  function GLB_nor_reduce(v  : unsigned) return std_logic;
  function GLB_xnor_reduce(v : unsigned) return std_logic;

  --Reduce a bit_vector to bit by applying logic function
  function GLB_and_reduce(v  : bit_vector) return bit;
  function GLB_or_reduce(v   : bit_vector) return bit;
  function GLB_xor_reduce(v  : bit_vector) return bit;
  function GLB_nand_reduce(v : bit_vector) return bit;
  function GLB_nor_reduce(v  : bit_vector) return bit;
  function GLB_xnor_reduce(v : bit_vector) return bit;

  -----------------------------------------------------------------------------------------------------------------------
  --Perform a vector resize, but check that numerical represntation of result is identical to x
  --  Note that Modeltech numeric_std does this check automatically, but there is no guarentee
  function GLB_safe_resize(x : unsigned; len : natural) return unsigned;
  function GLB_safe_resize(x : signed; len : natural) return signed;
  function GLB_safe_resize(x : std_logic_vector; len : natural) return std_logic_vector;

  -----------------------------------------------------------------------------------------------------------------------
  --Slice a vector with stride and offset
  --  e.g.
  --    variable x:  unsigned(7 downto 0);
  --    GLB_slice(x,2,0)       --Returns (x(6) & x(4) & x(2) & x(0))
  --    GLB_slice(x,2,1)       --Returns (x(7) & x(5) & x(3) & x(1))

  function GLB_slice(x : bit_vector; stride : positive; offset : natural) return bit_vector;
  function GLB_slice(x : std_logic_vector; stride : positive; offset : natural) return std_logic_vector;
  function GLB_slice(x : unsigned; stride : positive; offset : natural) return unsigned;
  function GLB_slice(x : signed; stride : positive; offset : natural) return signed;

  -----------------------------------------------------------------------------------------------------------------------
  --Pad a vector upto a length with the given bit
  --  x must be a descending vector (m downto n) and is placed in the LSBs of the result
  --  pad is applied to the MSBs of the result
  function GLB_pad(x : bit_vector; len : positive; pad : bit) return bit_vector;
  function GLB_pad(x : std_logic_vector; len : positive; pad : std_logic) return std_logic_vector;
  function GLB_pad(x : unsigned; len : positive; pad : std_logic) return unsigned;
  function GLB_pad(x : signed; len : positive; pad : std_logic) return signed;

  -----------------------------------------------------------------------------------------------------------------------
  --Replicate each bit of a vector
  --  e.g.
  --    variable x:  unsigned(1 downto 0);
  --    GLB_replicate(x,2)         --Returns (x(1) & x(1) & x(0) & x(0))
  --    GLB_replicate(x,3)         --Returns (x(1) & x(1) & x(1) & x(0) & x(0) & x(0))
  function GLB_replicate(x : std_logic_vector; rep : positive) return std_logic_vector;
  function GLB_replicate(x : unsigned; rep : positive) return unsigned;
  function GLB_replicate(x : signed; rep : positive) return signed;

  -----------------------------------------------------------------------------------------------------------------------
  --Convert a hex character into a slv4
  function GLB_hex_to_slv(digit : character) return std_logic_vector;

  --Convert a hex string into a slv
  function GLB_hex_to_slv(digits : string) return std_logic_vector;

  --Convert a hex string into a slv of given width
  function GLB_hex_to_slv(digits : string; width : positive) return std_logic_vector;

  --Convert a slv4 to a hex character
  function GLB_slv_to_hex(v : std_logic_vector) return character;

  --Convert a slv to a hex string
  function GLB_slv_to_hex(v : std_logic_vector) return string;

  ------------------------------------------------------------------------------------------------------------------------
  --Polymorphic method to translate anything into a string
  function GLB_to_string(x : integer) return string;
  function GLB_to_string(x : real) return string;
  function GLB_to_string(x : boolean) return string;
  function GLB_to_string(x : time) return string;
  function GLB_to_string(x : character) return string;
  function GLB_to_string(x : string) return string;  --For completeness
  function GLB_to_string(x : bit) return string;
  function GLB_to_string(x : bit_vector) return string;
  function GLB_to_string(x : std_logic) return string;
  function GLB_to_string(x : std_logic_vector) return string;
  function GLB_to_string(x : unsigned) return string;
  function GLB_to_string(x : signed) return string;

  function GLB_to_hstring(x : std_logic_vector) return string;
  function GLB_to_hstring(x : unsigned) return string;
  function GLB_to_hstring(x : signed) return string;

  --Convert to character
  function GLB_to_character(x : bit) return character;
  function GLB_to_character(x : std_logic) return character;

  ------------------------------------------------------------------------------------------------------------------------
  --Convert character/string to upper/lower case
  function GLB_toupper(c : character) return character;
  function GLB_tolower(c : character) return character;
  function GLB_toupper(s : string) return string;
  function GLB_tolower(s : string) return string;

  ------------------------------------------------------------------------------------------------------------------------
  --Convert an unsigned number into real (not limited by width of x)
  function GLB_to_real(x : unsigned) return real;
  --Convert an unsigned number with given number of fractional bits into real (not limited by width of x)
  function GLB_to_real(x : unsigned; frac : natural) return real;

  --Convert a signed number into real (not limited by width of x)
  function GLB_to_real(x : signed) return real;
  --Convert a signed number with given number of fractional bits into real (not limited by width of x)
  function GLB_to_real(x : signed; frac : natural) return real;

  --Convert a real to an unsigned fixed point value
  function GLB_to_unsigned(x : real; width : positive; frac : natural) return unsigned;
  function GLB_to_unsigned(x : real; width : positive) return unsigned;

  --Convert a real to a signed fixed point value
  function GLB_to_signed(x : real; width : positive; frac : natural) return signed;
  function GLB_to_signed(x : real; width : positive) return signed;

  --Convert a fixed point value from one number format to the other
  --  An error is produced is the result is numerically different from the input
  --  i.e. truncation of significant bits is not permitted
  function GLB_resize(x : unsigned; IN_NBITS : natural; IN_BINPT : natural; OUT_NBITS : natural; OUT_BINPT : natural) return unsigned;
  function GLB_resize(x : signed; IN_NBITS : natural; IN_BINPT : natural; OUT_NBITS : natural; OUT_BINPT : natural) return signed;

  ------------------------------------------------------------------------------------------------------------------------
  --Perform an equality test between two vectors by reducing to a sum-of-product form on the carry-chain
  --  The reduction parameter controls how many bits are combined into each muxcy stage
  --  On V4: comparison to a constant should use reduction=4, comparison to a signal should use reduction=2
  --  On V5: comparison to a constant should use reduction=6, comparison to a signal should use reduction=3
  function GLB_muxcy_eq(lhs : signed; rhs : signed; reduction : natural     := 2) return std_logic;
  function GLB_muxcy_eq(lhs : unsigned; rhs : unsigned; reduction : natural := 2) return std_logic;

  --Perform magnitude comparisons using subtraction
  --  XST has a bad habit of producing LUT-MUXCY-INV structures for comparisons
  --  These functions avoid that
  function GLB_lt(lhs : unsigned; rhs : unsigned) return std_logic;
  function GLB_lt(lhs : signed; rhs : signed) return std_logic;
  function GLB_lt(lhs : unsigned; rhs : integer) return std_logic;
  function GLB_lt(lhs : signed; rhs : integer) return std_logic;

  function GLB_gt(lhs : unsigned; rhs : unsigned) return std_logic;
  function GLB_gt(lhs : signed; rhs : signed) return std_logic;
  function GLB_gt(lhs : unsigned; rhs : integer) return std_logic;
  function GLB_gt(lhs : signed; rhs : integer) return std_logic;

  function GLB_le(lhs : unsigned; rhs : unsigned) return std_logic;
  function GLB_le(lhs : signed; rhs : signed) return std_logic;
  function GLB_le(lhs : unsigned; rhs : integer) return std_logic;
  function GLB_le(lhs : signed; rhs : integer) return std_logic;

  function GLB_ge(lhs : unsigned; rhs : unsigned) return std_logic;
  function GLB_ge(lhs : signed; rhs : signed) return std_logic;
  function GLB_ge(lhs : unsigned; rhs : integer) return std_logic;
  function GLB_ge(lhs : signed; rhs : integer) return std_logic;

  ------------------------------------------------------------------------------------------------------------------------
  --Return either x or -x depending on a control signal
  --    neg    result
  --    false  x
  --    true   -x
  --  The result is one bit wider than x due to sign extension
  --  Always implemened as a single adder (ie. returns x+0 or not(x)+1)
  function GLB_negate(neg : std_logic; x : signed) return signed;
  function GLB_negate(neg : std_logic; x : unsigned) return signed;

  ------------------------------------------------------------------------------------------------------------------------
  --Implements a two input mux as a boolean equation:
  --  result(n)=(not sel and in0(n)) or (sel and in1(n))
  --Result width will be max(in0'length,in1'length) with both inputs extended (zero or sign depending on type) to the required width
  --This form is useful with registered MUXes where XST is using the R/S control signal to implement logic in silly ways
  function GLB_mux(sel : std_logic; in0 : std_logic; in1 : std_logic) return std_logic;
  function GLB_mux(sel : std_logic; in0 : std_logic_vector; in1 : std_logic_vector) return std_logic_vector;
  function GLB_mux(sel : std_logic; in0 : unsigned; in1 : unsigned) return unsigned;
  function GLB_mux(sel : std_logic; in0 : natural; in1 : unsigned) return unsigned;
  function GLB_mux(sel : std_logic; in0 : unsigned; in1 : natural) return unsigned;
  function GLB_mux(sel : std_logic; in0 : signed; in1 : signed) return signed;
  function GLB_mux(sel : std_logic; in0 : integer; in1 : signed) return signed;
  function GLB_mux(sel : std_logic; in0 : signed; in1 : integer) return signed;

end package;


------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package body global_util_pkg_v1_1 is

  --True if this is simulation
  function GLB_is_simulation return boolean is
  begin
    --translate off
    return true;
    --translate on
    return false;
  end function;

  --True if this is synthesis/implementation
  function GLB_is_synthesis return boolean is
  begin
    return not GLB_is_simulation;
  end function;

  --True if any of the elements of a boolean_vector are true
  function GLB_any_true(v : GLB_BooleanVector) return boolean is
  begin
    for I in v'range loop
      if v(I) then return true; end if;
    end loop;
    return false;
  end function;

  --True if any of the elements of a boolean_vector are false
  function GLB_any_false(v : GLB_BooleanVector) return boolean is
  begin
    for I in v'range loop
      if not v(I) then return true; end if;
    end loop;
    return false;
  end function;

  --True if all of the elements of a boolean_vector are true
  function GLB_all_true(v : GLB_BooleanVector) return boolean is
  begin
    return not GLB_any_false(v);
  end function;

  --True if all of the elements of a boolean_vector are false
  function GLB_all_false(v : GLB_BooleanVector) return boolean is
  begin
    return not GLB_any_true(v);
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  function GLB_log2(x : natural) return natural is
    variable width : natural := 0;
    variable cnt   : natural := 1;
  begin
    while (cnt < x) loop
      width := width+1;
      cnt   := cnt*2;
    end loop;
    return width;
  end;

  function GLB_log2min(x, y : natural) return natural is
  begin
    return GLB_min(GLB_log2(x), y);
  end function;

  function GLB_next_pow2(x : natural) return natural is
    variable width : natural := 0;
    variable cnt   : natural := 1;
  begin
    while (cnt < x) loop
      width := width+1;
      cnt   := cnt*2;
    end loop;
    return cnt;
  end function;

  function GLB_find_lsb(x : natural) return natural is
    variable xx    : natural := x;
    variable width : natural := 0;
  begin
    while (GLB_is_even(xx)) loop
      xx    := xx/2;
      width := width+1;
    end loop;
    return width;
  end function;

  function GLB_find_msb(x : natural) return natural is
    variable xx    : natural := x;
    variable width : natural := 0;
  begin
    while (xx > 1) loop
      xx    := xx/2;
      width := width+1;
    end loop;
    return width;
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_is_pow2(x : natural) return boolean is
  begin
    return x = GLB_next_pow2(x);
  end function;

  function GLB_is_even(x : integer) return boolean is
  begin
    return (x rem 2) = 0;
  end function;

  function GLB_is_even(x : unsigned) return boolean is
  begin
    return (x(x'right) = '0');
  end function;

  function GLB_is_even(x : signed) return boolean is
  begin
    return (x(x'right) = '0');
  end function;

  function GLB_is_odd(x : integer) return boolean is
  begin
    return (x rem 2) /= 0;
  end function;

  function GLB_is_odd(x : unsigned) return boolean is
  begin
    return (x(x'right) = '1');
  end function;

  function GLB_is_odd(x : signed) return boolean is
  begin
    return (x(x'right) = '1');
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_if(cond : boolean; v_true, v_false : integer) return integer is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : real) return real is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : string) return string is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : std_logic) return std_logic is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : std_logic_vector) return std_logic_vector is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : signed) return signed is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : unsigned) return unsigned is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : time) return time is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : character) return character is
  begin
    if (cond) then return v_true; else return v_false; end if;
  end function;

  function GLB_if(cond : boolean; v_true, v_false : boolean) return boolean is
  begin
    return (cond and v_true) or (not cond and v_false);
  end function;

  function GLB_if(cond : std_logic; v_true, v_false : std_logic) return std_logic is
  begin
    return (cond and v_true) or (not cond and v_false);
  end function;

  function GLB_to_std_logic(x : boolean) return std_logic is
  begin
    if (x) then return '1'; else return '0'; end if;
  end function;

  function GLB_to_sl(x : boolean) return std_logic is
  begin
    if (x) then return '1'; else return '0'; end if;
  end function;

  function GLB_to_bit(x : boolean) return bit is
  begin
    if (x) then return '1'; else return '0'; end if;
  end function;

  function GLB_to_boolean(x : integer) return boolean is
  begin
    if (x /= 0) then return true; else return false; end if;
  end function;

  function GLB_to_boolean(x : real) return boolean is
  begin
    if (x /= 0.0) then return true; else return false; end if;
  end function;

  function GLB_to_boolean(x : std_logic) return boolean is
  begin
    if (to_X01(x) = '1') then return true; else return false; end if;
  end function;

  function GLB_to_integer(x : boolean) return integer is
  begin
    if x then return 1; else return 0; end if;
  end function;

  function GLB_to_integer(x: std_logic) return integer is
  begin
    if x='1' then return 1; else return 0; end if;
  end function;
------------------------------------------------------------------------------------------------------------------------
  function GLB_min(a, b : integer) return integer is
  begin
    if (a < b) then return a; else return b; end if;
  end function;

  function GLB_min(a, b : real) return real is
  begin
    if (a < b) then return a; else return b; end if;
  end function;

  function GLB_min(a, b : time) return time is
  begin
    if (a < b) then return a; else return b; end if;
  end function;

  function GLB_min(a, b : signed) return signed is
  begin
    if (a < b) then return a; else return b; end if;
  end function;

  function GLB_min(a, b : unsigned) return unsigned is
  begin
    if (a < b) then return a; else return b; end if;
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_max(a, b : integer) return integer is
  begin
    if (a > b) then return a; else return b; end if;
  end function;

  function GLB_max(a, b : real) return real is
  begin
    if (a > b) then return a; else return b; end if;
  end function;

  function GLB_max(a, b : time) return time is
  begin
    if (a > b) then return a; else return b; end if;
  end function;

  function GLB_max(a, b : signed) return signed is
  begin
    if (a > b) then return a; else return b; end if;
  end function;

  function GLB_max(a, b : unsigned) return unsigned is
  begin
    if (a > b) then return a; else return b; end if;
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_limit(value, a, b : integer) return integer is
  begin
    if (value < a) then return a; end if;
    if (value > b) then return b; end if;
    return value;
  end function;

  function GLB_limit(value, a, b : real) return real is
  begin
    if (value < a) then return a; end if;
    if (value > b) then return b; end if;
    return value;
  end function;

  function GLB_limit(value, a, b : time) return time is
  begin
    if (value < a) then return a; end if;
    if (value > b) then return b; end if;
    return value;
  end function;

  function GLB_limit(value, a, b : signed) return signed is
  begin
    if (value < a) then return a; end if;
    if (value > b) then return b; end if;
    return value;
  end function;

  function GLB_limit(value, a, b : unsigned) return unsigned is
  begin
    if (value < a) then return a; end if;
    if (value > b) then return b; end if;
    return value;
  end function;

-----------------------------------------------------------------------------------------------------------------------
  --Reduce a std_logic_vector to std_logic by applying logic function
  function GLB_and_reduce(v : std_logic_vector) return std_logic is
    variable res : std_logic := '1';
  begin
    for I in v'range loop
      res := res and v(I);
    end loop;
    return res;
  end function;

  function GLB_or_reduce(v : std_logic_vector) return std_logic is
    variable res : std_logic := '0';
  begin
    for I in v'range loop
      res := res or v(I);
    end loop;
    return res;
  end function;

  function GLB_xor_reduce(v : std_logic_vector) return std_logic is
    variable res : std_logic := '0';
  begin
    for I in v'range loop
      res := res xor v(I);
    end loop;
    return res;
  end function;

  function GLB_nand_reduce(v : std_logic_vector) return std_logic is
  begin
    return not GLB_and_reduce(v);
  end function;

  function GLB_nor_reduce(v : std_logic_vector) return std_logic is
  begin
    return not GLB_or_reduce(v);
  end function;

  function GLB_xnor_reduce(v : std_logic_vector) return std_logic is
  begin
    return not GLB_xor_reduce(v);
  end function;

  --Reduce a signed to std_logic by applying logic function
  function GLB_and_reduce(v : signed) return std_logic is
  begin
    return GLB_and_reduce(std_logic_vector(v));
  end function;

  function GLB_or_reduce(v : signed) return std_logic is
  begin
    return GLB_or_reduce(std_logic_vector(v));
  end function;

  function GLB_xor_reduce(v : signed) return std_logic is
  begin
    return GLB_xor_reduce(std_logic_vector(v));
  end function;

  function GLB_nand_reduce(v : signed) return std_logic is
  begin
    return GLB_nand_reduce(std_logic_vector(v));
  end function;

  function GLB_nor_reduce(v : signed) return std_logic is
  begin
    return GLB_nor_reduce(std_logic_vector(v));
  end function;

  function GLB_xnor_reduce(v : signed) return std_logic is
  begin
    return GLB_xnor_reduce(std_logic_vector(v));
  end function;

  --Reduce an unsigned to std_logic by applying logic function
  function GLB_and_reduce(v : unsigned) return std_logic is
  begin
    return GLB_and_reduce(std_logic_vector(v));
  end function;

  function GLB_or_reduce(v : unsigned) return std_logic is
  begin
    return GLB_or_reduce(std_logic_vector(v));
  end function;

  function GLB_xor_reduce(v : unsigned) return std_logic is
  begin
    return GLB_xor_reduce(std_logic_vector(v));
  end function;

  function GLB_nand_reduce(v : unsigned) return std_logic is
  begin
    return GLB_nand_reduce(std_logic_vector(v));
  end function;

  function GLB_nor_reduce(v : unsigned) return std_logic is
  begin
    return GLB_nor_reduce(std_logic_vector(v));
  end function;

  function GLB_xnor_reduce(v : unsigned) return std_logic is
  begin
    return GLB_xnor_reduce(std_logic_vector(v));
  end function;

  --Reduce a bit_vector to bit by applying logic function
  function GLB_and_reduce(v : bit_vector) return bit is
    variable res : bit := '1';
  begin
    for I in v'range loop
      res := res and v(I);
    end loop;
    return res;
  end function;

  function GLB_or_reduce(v : bit_vector) return bit is
    variable res : bit := '0';
  begin
    for I in v'range loop
      res := res or v(I);
    end loop;
    return res;
  end function;

  function GLB_xor_reduce(v : bit_vector) return bit is
    variable res : bit := '0';
  begin
    for I in v'range loop
      res := res xor v(I);
    end loop;
    return res;
  end function;

  function GLB_nand_reduce(v : bit_vector) return bit is
  begin
    return not GLB_and_reduce(v);
  end function;

  function GLB_nor_reduce(v : bit_vector) return bit is
  begin
    return not GLB_or_reduce(v);
  end function;

  function GLB_xnor_reduce(v : bit_vector) return bit is
  begin
    return not GLB_xor_reduce(v);
  end function;

------------------------------------------------------------------------------------------------------------------------
  --Perform a vector resize, but check that numerical represntation of result is identical to x
  function GLB_safe_resize(x : unsigned; len : natural) return unsigned is
    variable res : unsigned(len-1 downto 0) := resize(x, len);
  begin
    --translate off
    assert x = res
      report "ERROR:Resize operation caused change in numerical value of result"
      severity failure;
    --translate on
    return res;
  end function;

  function GLB_safe_resize(x : signed; len : natural) return signed is
    variable res : signed(len-1 downto 0) := resize(x, len);
  begin
    --translate off
    assert x = res
      report "ERROR:Resize operation caused change in numerical value of result"
      severity failure;
    --translate on
    return res;
  end function;

  function GLB_safe_resize(x : std_logic_vector; len : natural) return std_logic_vector is
  begin
    return std_logic_vector(GLB_safe_resize(unsigned(x), len));
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_slice(x : bit_vector; stride : positive; offset : natural) return bit_vector is
    constant SLICE_LEN : natural                          := x'length/stride;
    variable res       : bit_vector(SLICE_LEN-1 downto 0) := (others => '0');
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert x'length = SLICE_LEN*stride
      report "ERROR:x'length must be an integer multiple of stride"
      severity failure;
    assert offset >= 0 and offset < stride
      report "ERROR:offset must be in range [0 stride-1]"
      severity failure;
    --translate on

    for I in res'range loop
      res(I) := x(x'right+I*stride+offset);
    end loop;

    return res;
  end function;

  function GLB_slice(x : std_logic_vector; stride : positive; offset : natural) return std_logic_vector is
    constant SLICE_LEN : natural                                := x'length/stride;
    variable res       : std_logic_vector(SLICE_LEN-1 downto 0) := (others => '0');
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert x'length = SLICE_LEN*stride
      report "ERROR:x'length must be an integer multiple of stride"
      severity failure;
    assert offset >= 0 and offset < stride
      report "ERROR:offset must be in range [0 stride-1]"
      severity failure;
    --translate on

    for I in res'range loop
      res(I) := x(x'right+I*stride+offset);
    end loop;

    return res;
  end function;

  function GLB_slice(x : unsigned; stride : positive; offset : natural) return unsigned is
  begin
    return unsigned(GLB_slice(std_logic_vector(x), stride, offset));
  end function;

  function GLB_slice(x : signed; stride : positive; offset : natural) return signed is
  begin
    return signed(GLB_slice(std_logic_vector(x), stride, offset));
  end function;

-----------------------------------------------------------------------------------------------------------------------
  function GLB_pad(x : bit_vector; len : positive; pad : bit) return bit_vector is
    variable res : bit_vector(len-1 downto 0) := (others => pad);
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert len >= x'length
      report "ERROR:len must be >=x'length"
      severity failure;
    --translate on

    res(x'length-1 downto 0) := x;

    return res;
  end function;

  function GLB_pad(x : std_logic_vector; len : positive; pad : std_logic) return std_logic_vector is
    variable res : std_logic_vector(len-1 downto 0) := (others => pad);
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert len >= x'length
      report "ERROR:len must be >=x'length"
      severity failure;
    --translate on

    res(x'length-1 downto 0) := x;

    return res;
  end function;

  function GLB_pad(x : unsigned; len : positive; pad : std_logic) return unsigned is
  begin
    return unsigned(GLB_pad(std_logic_vector(x), len, pad));
  end function;

  function GLB_pad(x : signed; len : positive; pad : std_logic) return signed is
  begin
    return signed(GLB_pad(std_logic_vector(x), len, pad));
  end function;


------------------------------------------------------------------------------------------------------------------------
  function GLB_replicate(x : bit_vector; rep : positive) return bit_vector is
    variable res : bit_vector(x'length*rep-1 downto 0) := (others => '0');
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    --translate on

    for I in 0 to x'length-1 loop
      res(I*rep+rep-1 downto I*rep) := (others => x(x'low+I));
    end loop;

    return res;
  end function;

  function GLB_replicate(x : std_logic_vector; rep : positive) return std_logic_vector is
    variable res : std_logic_vector(x'length*rep-1 downto 0) := (others => '0');
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    --translate on

    for I in 0 to x'length-1 loop
      res(I*rep+rep-1 downto I*rep) := (others => x(x'low+I));
    end loop;

    return res;
  end function;

  function GLB_replicate(x : unsigned; rep : positive) return unsigned is
  begin
    return unsigned(GLB_replicate(std_logic_vector(x), rep));
  end function;

  function GLB_replicate(x : signed; rep : positive) return signed is
  begin
    return signed(GLB_replicate(std_logic_vector(x), rep));
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_hex_to_slv(digit : character) return std_logic_vector is
  begin
    case digit is
      when '0'       => return "0000";
      when '1'       => return "0001";
      when '2'       => return "0010";
      when '3'       => return "0011";
      when '4'       => return "0100";
      when '5'       => return "0101";
      when '6'       => return "0110";
      when '7'       => return "0111";
      when '8'       => return "1000";
      when '9'       => return "1001";
      when 'a' | 'A' => return "1010";
      when 'b' | 'B' => return "1011";
      when 'c' | 'C' => return "1100";
      when 'd' | 'D' => return "1101";
      when 'e' | 'E' => return "1110";
      when 'f' | 'F' => return "1111";
      when others    => return "XXXX";
    end case;
  end function;

  function GLB_hex_to_slv(digits : string) return std_logic_vector is
    variable i   : integer := 0;
    variable res : std_logic_vector(digits'length*4-1 downto 0);
  begin
    for x in digits'reverse_range loop
      res(i+3 downto i) := GLB_hex_to_slv(digits(x));
      i                 :=i+4;
    end loop;
    return res;
  end function;

  function GLB_hex_to_slv(digits : string; width : positive) return std_logic_vector is
    variable x   : std_logic_vector(digits'length*4-1 downto 0) := GLB_hex_to_slv(digits);
    variable res : std_logic_vector(width-1 downto 0)           := (others => '0');
  begin
    if (digits'length*4 < width) then
      res(x'range) := x;
    else
      res := x(res'range);
    end if;
    return res;
  end function;

  --Convert a slv4 to a hex character
  function GLB_slv_to_hex(v : std_logic_vector) return character is
    variable vv : std_logic_vector(3 downto 0) := v;
  begin
    case vv is
      when "0000" => return '0';
      when "0001" => return '1';
      when "0010" => return '2';
      when "0011" => return '3';
      when "0100" => return '4';
      when "0101" => return '5';
      when "0110" => return '6';
      when "0111" => return '7';
      when "1000" => return '8';
      when "1001" => return '9';
      when "1010" => return 'A';
      when "1011" => return 'B';
      when "1100" => return 'C';
      when "1101" => return 'D';
      when "1110" => return 'E';
      when "1111" => return 'F';
      when others => return 'X';
    end case;
  end function;

  --Convert a slv to a hex string
  function GLB_slv_to_hex(v : std_logic_vector) return string is
    constant NUM_DIGITS : integer                               := (v'length+3)/4;
    variable x          : std_logic_vector(0 to 4*NUM_DIGITS-1) := std_logic_vector(resize(unsigned(v), 4*NUM_DIGITS));
    variable res        : string(1 to NUM_DIGITS);
  begin
    for i in res'range loop
      res(i) := GLB_slv_to_hex(x(4*i-4 to 4*i-1));
    end loop;
    return res;
  end function;

------------------------------------------------------------------------------------------------------------------------
  function GLB_to_string(x : integer) return string is
  begin
    return integer'image(x);
  end function;

  function GLB_to_string(x : real) return string is
  begin
    return real'image(x);
  end function;

  function GLB_to_string(x : boolean) return string is
  begin
    return boolean'image(x);
  end function;

  function GLB_to_string(x : time) return string is
  begin
    return time'image(x);
  end function;

  function GLB_to_string(x : character) return string is
  begin
    --Note that this converts all characters to a textual representation (i.e. 0->nul, 9->ht, etc.)
    return character'image(x);
  end function;

  function GLB_to_string(x : string) return string is
  begin
    return x;
  end function;

  function GLB_to_string(x : std_logic) return string is
  begin
    return GLB_to_string(GLB_to_character(x));
  end function;

  function GLB_to_string(x : bit) return string is
  begin
    return GLB_to_string(GLB_to_character(x));
  end function;

  function GLB_to_string(x : bit_vector) return string is
    variable res : string(1 to x'length);
    variable j   : integer := 1;
  begin
    for i in x'range loop
      res(j) := GLB_to_character(x(i));
      j      :=j+1;
    end loop;
    return res;
  end function;

  function GLB_to_string(x : std_logic_vector) return string is
    variable res : string(1 to x'length);
    variable j   : integer := 1;
  begin
    for i in x'range loop
      res(j) := GLB_to_character(x(i));
      j      :=j+1;
    end loop;
    return res;
  end function;

  function GLB_to_string(x : unsigned) return string is
  begin
    return GLB_to_string(std_logic_vector(x));
  end function;

  function GLB_to_string(x : signed) return string is
  begin
    return GLB_to_string(std_logic_vector(x));
  end function;

  function GLB_to_hstring(x : std_logic_vector) return string is
  begin
    return GLB_slv_to_hex(x);
  end function;

  function GLB_to_hstring(x : unsigned) return string is
  begin
    return GLB_to_hstring(std_logic_vector(x));
  end function;

  function GLB_to_hstring(x : signed) return string is
  begin
    return GLB_to_hstring(std_logic_vector(x));
  end function;

  function GLB_to_character(x : bit) return character is
  begin
    case x is
      when '0'    => return '0';
      when '1'    => return '1';
      when others => return '.';
    end case;
  end function;

  function GLB_to_character(x : std_logic) return character is
  begin
    case x is
      when 'U'    => return 'U';
      when 'X'    => return 'X';
      when '0'    => return '0';
      when '1'    => return '1';
      when 'Z'    => return 'Z';
      when 'W'    => return 'W';
      when 'L'    => return 'L';
      when 'H'    => return 'H';
      when '-'    => return '-';
      when others => return '.';
    end case;
  end function;

------------------------------------------------------------------------------------------------------------------------
  --Convert character/string to upper/lower case
  function GLB_toupper(c : character) return character is
    constant LUT : string(64 to 126) := "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~";
    variable res : character         := c;
  begin
    if (res >= 'a' and res <= 'z') then
      res := LUT(character'pos(res));
    end if;
    return res;
  end function;

  function GLB_tolower(c : character) return character is
    constant LUT : string(64 to 126) := "@abcdefghijklmnopqrstuvwxyz[\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    variable res : character         := c;
  begin
    if (res >= 'A' and res <= 'Z') then
      res := LUT(character'pos(res));
    end if;
    return res;
  end function;

  function GLB_toupper(s : string) return string is
    variable res : string(s'range) := s;
  begin
    for I in res'range loop
      res(I) := GLB_toupper(res(I));
    end loop;
    return res;
  end function;

  function GLB_tolower(s : string) return string is
    variable res : string(s'range) := s;
  begin
    for I in res'range loop
      res(I) := GLB_tolower(res(I));
    end loop;
    return res;
  end function;


------------------------------------------------------------------------------------------------------------------------
  --Generating large integers in VHDL is painful - so split long vectors into managable chunks
  constant VEC_CHUNK : positive := 28;
  constant VEC_SCALE : real     := real(2**VEC_CHUNK);

  function GLB_to_real(x : unsigned) return real is
  begin
    if (x'length > VEC_CHUNK) then
      if (x'ascending) then
        return GLB_to_real(x(x'left to x'right-VEC_CHUNK))*VEC_SCALE+GLB_to_real(x(x'right-VEC_CHUNK+1 to x'right));
      else
        return GLB_to_real(x(x'left downto x'right+VEC_CHUNK))*VEC_SCALE+GLB_to_real(x(x'right+VEC_CHUNK-1 downto x'right));
      end if;
    end if;

    --Simple vector, so convert directly
    return real(to_integer(x));
  end function;

  function GLB_to_real(x : signed) return real is
    variable res : real := 0.0;
  begin
    if (x < 0) then
      return -GLB_to_real(unsigned(-x));
    else
      return GLB_to_real(unsigned(x));
    end if;
  end function;

  function GLB_to_real(x : unsigned; frac : natural) return real is
  begin
    return GLB_to_real(x)/(2.0**real(frac));
  end function;

  function GLB_to_real(x : signed; frac : natural) return real is
  begin
    return GLB_to_real(x)/(2.0**real(frac));
  end function;

  function GLB_to_unsigned(x : real; width : positive) return unsigned is
    variable v     : unsigned(VEC_CHUNK-1 downto 0);
    constant SCALE : real := 2.0**(width-VEC_CHUNK);
    variable y     : real;
    variable i, j  : integer;
  begin
    --Is resulting vector too large to calculate in one?
    if (width > VEC_CHUNK) then
      v :=GLB_to_unsigned(x/SCALE, VEC_CHUNK);
      y :=x-GLB_to_real(v)*SCALE;
      return v & GLB_to_unsigned(y, width-VEC_CHUNK);
    end if;

    j :=2**width;
    i :=GLB_limit(integer(x-0.499999), 0, j-1);
    return to_unsigned(i, width);
  end function;

  function GLB_to_signed(x : real; width : positive) return signed is
    variable v     : signed(VEC_CHUNK-1 downto 0);
    constant SCALE : real := 2.0**(width-VEC_CHUNK);
    variable y     : real;
    variable i, j  : integer;
  begin
    --Is resulting vector too large to calculate in one?
    if (width > VEC_CHUNK) then
      v :=GLB_to_signed(x/SCALE, VEC_CHUNK);
      y :=x-GLB_to_real(v)*SCALE;
      return v & signed(GLB_to_unsigned(y, width-VEC_CHUNK));
    end if;

    j :=2**(width-1);
    i :=GLB_limit(integer(x-0.499999), -j, j-1);
    return to_signed(i, width);
  end function;

  function GLB_to_unsigned(x : real; width : positive; frac : natural) return unsigned is
  begin
    return GLB_to_unsigned(x*(2.0**real(frac)), width);
  end function;

  function GLB_to_signed(x : real; width : positive; frac : natural) return signed is
  begin
    return GLB_to_signed(x*(2.0**real(frac)), width);
  end function;

  function GLB_resize(x : unsigned; IN_NBITS : natural; IN_BINPT : natural; OUT_NBITS : natural; OUT_BINPT : natural) return unsigned is
    variable res : unsigned(OUT_NBITS-1 downto 0);
    variable xx  : unsigned(OUT_NBITS-1 downto 0);
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert x'length = IN_NBITS
      report "ERROR:Invalid x and/or IN_NBITS; length of x must be the same as IN_NBITS"
      severity failure;
    --translate on

    if (IN_NBITS >= OUT_NBITS) then
      res := x(x'low+OUT_NBITS-1 downto x'low);
    else
      res(IN_NBITS-1 downto 0) := x;
    end if;

    --Need to realign binary point
    if (IN_BINPT >= OUT_BINPT) then
      --res:=res sra (IN_BINPT-OUT_BINPT);
      --xx :=res sla (IN_BINPT-OUT_BINPT);
      res := resize(res(OUT_NBITS-1 downto (IN_BINPT-OUT_BINPT)), OUT_NBITS);
      xx  := res sll (IN_BINPT-OUT_BINPT);
    else
      --res:=res sla (OUT_BINPT-IN_BINPT);
      --xx :=res sra (OUT_BINPT-IN_BINPT);
      res := res sll (OUT_BINPT-IN_BINPT);
      xx  := resize(res(OUT_NBITS-1 downto (OUT_BINPT-IN_BINPT)), OUT_NBITS);
    end if;

    --Check for change in value
    --translate off
    if (not is_x(std_logic_vector(x))) then
      assert x = xx
        report "ERROR:Numeric value changed after resize"
        severity failure;
    end if;
    --translate on

    return res;
  end function;

  function GLB_resize(x : signed; IN_NBITS : natural; IN_BINPT : natural; OUT_NBITS : natural; OUT_BINPT : natural) return signed is
    variable res : signed(OUT_NBITS-1 downto 0);
    variable xx  : signed(OUT_NBITS-1 downto 0);
  begin
    --translate off
    assert not x'ascending
      report "ERROR:x must be a descending vector (n downto m)"
      severity failure;
    assert x'length = IN_NBITS
      report "ERROR:Invalid x and/or IN_NBITS; length of x must be the same as IN_NBITS"
      severity failure;
    --translate on

    if (IN_NBITS >= OUT_NBITS) then
      res := x(x'low+OUT_NBITS-1 downto x'low);
    else
      res(IN_NBITS-1 downto 0) := x;
    end if;

    --Need to realign binary point
    if (IN_BINPT >= OUT_BINPT) then
      --res:=res sra (IN_BINPT-OUT_BINPT);
      --xx :=res sla (IN_BINPT-OUT_BINPT);
      res := resize(res(OUT_NBITS-1 downto (IN_BINPT-OUT_BINPT)), OUT_NBITS);
      xx  := res sll (IN_BINPT-OUT_BINPT);
    else
      --res:=res sla (OUT_BINPT-IN_BINPT);
      --xx :=res sra (OUT_BINPT-IN_BINPT);
      res := res sll (OUT_BINPT-IN_BINPT);
      xx  := resize(res(OUT_NBITS-1 downto (OUT_BINPT-IN_BINPT)), OUT_NBITS);
    end if;

    --Check for change in value
    --translate off
    if (not is_x(std_logic_vector(x))) then
      assert x = xx
        report "ERROR:Numeric value changed after resize"
        severity failure;
    end if;
    --translate on

    return res;
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --Perform an equality test between two vectors by reducing to a sum-of-product form on the carry-chain
  --  The reduction parameter controls how many bits are combined into each muxcy stage
  --  On V4: comparison to a constant should use reduction=4, comparison to a signal should use reduction=2
  --  On V5: comparison to a constant should use reduction=6, comparison to a signal should use reduction=3
  function GLB_muxcy_eq(lhs : unsigned; rhs : unsigned; reduction : natural := 2) return std_logic is
    constant WIDTH : natural                    := (GLB_max(lhs'length, rhs'length)+reduction-1)/reduction;
    variable int   : unsigned(WIDTH*reduction-1 downto 0);
    variable add   : unsigned(WIDTH-1 downto 0) := (others => '0');
    variable cin   : unsigned(0 downto 0)       := (others => '1');
    variable res   : unsigned(WIDTH downto 0);
  begin
    --Intermediate result is the bit wise xor
    int := resize(lhs, int'length) xor resize(rhs, int'length);

    --Reduce each pair of bits to a product
    for I in add'range loop
      if (int(I*reduction+reduction-1 downto I*reduction) = 0) then add(I) := '1'; end if;
    end loop;

    --Final addition
    res := resize(add, res'length)+cin;

    return res(res'left);
  end function;

  function GLB_muxcy_eq(lhs : signed; rhs : signed; reduction : natural := 2) return std_logic is
    constant WIDTH : natural                    := (GLB_max(lhs'length, rhs'length)+reduction-1)/reduction;
    variable int   : signed(WIDTH*reduction-1 downto 0);
    --We're using addition to implement sum-of-product, not arithemtic
    --  We can drop the signedness of the inputs now
    variable add   : unsigned(WIDTH-1 downto 0) := (others => '0');
    variable cin   : unsigned(0 downto 0)       := (others => '1');
    variable res   : unsigned(WIDTH downto 0);
  begin
    --Intermediate result is the bit wise xor
    int := resize(lhs, int'length) xor resize(rhs, int'length);

    --Reduce each pair of bits to a product
    for I in add'range loop
      if (int(I*reduction+reduction-1 downto I*reduction) = 0) then add(I) := '1'; end if;
    end loop;

    --Final addition
    res := resize(add, res'length)+cin;

    return res(res'left);
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  -- lhs<rhs can be re-written as lhs-rhs<0
  function GLB_lt(lhs : unsigned; rhs : unsigned) return std_logic is
    variable res : unsigned(GLB_max(lhs'length, rhs'length)+1 downto 0);
  begin
    res := resize(lhs, res'length)-resize(rhs, res'length);
    return res(res'left);
  end function;

  function GLB_lt(lhs : signed; rhs : signed) return std_logic is
    variable res : signed(GLB_max(lhs'length, rhs'length)+1 downto 0);
  begin
    res := resize(lhs, res'length)-resize(rhs, res'length);
    return res(res'left);
  end function;

  function GLB_lt(lhs : unsigned; rhs : integer) return std_logic is
  begin
    return GLB_lt(lhs, to_unsigned(rhs, lhs'length));
  end function;

  function GLB_lt(lhs : signed; rhs : integer) return std_logic is
  begin
    return GLB_lt(lhs, to_signed(rhs, lhs'length));
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  -- lhs>rhs is equivalent to rhs<lhs
  function GLB_gt(lhs : unsigned; rhs : unsigned) return std_logic is
  begin
    return GLB_lt(rhs, lhs);
  end function;

  function GLB_gt(lhs : signed; rhs : signed) return std_logic is
  begin
    return GLB_lt(rhs, lhs);
  end function;

  function GLB_gt(lhs : unsigned; rhs : integer) return std_logic is
  begin
    return GLB_gt(lhs, to_unsigned(rhs, lhs'length));
  end function;

  function GLB_gt(lhs : signed; rhs : integer) return std_logic is
  begin
    return GLB_gt(lhs, to_signed(rhs, lhs'length));
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --  lhs<=rhs can be re-written as:
  --  lhs-rhs<=0
  --  lhs+not(rhs)+1<=0  (i.e. 2's compliment addition)
  --  lhs+not(rhs)<=-1
  --  lhs+not(rhs)<0
  function GLB_le(lhs : unsigned; rhs : unsigned) return std_logic is
    variable res : unsigned(GLB_max(lhs'length, rhs'length)+1 downto 0);
  begin
    res := resize(lhs, res'length)+not(resize(rhs, res'length));
    return res(res'left);
  end function;

  function GLB_le(lhs : signed; rhs : signed) return std_logic is
    variable res : signed(GLB_max(lhs'length, rhs'length)+1 downto 0);
  begin
    res := resize(lhs, res'length)+not(resize(rhs, res'length));
    return res(res'left);
  end function;

  function GLB_le(lhs : unsigned; rhs : integer) return std_logic is
  begin
    return GLB_le(lhs, to_unsigned(rhs, lhs'length));
  end function;

  function GLB_le(lhs : signed; rhs : integer) return std_logic is
  begin
    return GLB_le(lhs, to_signed(rhs, lhs'length));
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --  lhs>=rhs can be re-written as rhs<=lhs
  function GLB_ge(lhs : unsigned; rhs : unsigned) return std_logic is
  begin
    return GLB_le(rhs, lhs);
  end function;

  function GLB_ge(lhs : signed; rhs : signed) return std_logic is
  begin
    return GLB_le(rhs, lhs);
  end function;

  function GLB_ge(lhs : unsigned; rhs : integer) return std_logic is
  begin
    return GLB_ge(lhs, to_unsigned(rhs, lhs'length));
  end function;

  function GLB_ge(lhs : signed; rhs : integer) return std_logic is
  begin
    return GLB_ge(lhs, to_signed(rhs, lhs'length));
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --Return either x or -x depending on a control signal
  --    neg    result
  --    false  x
  --    true   -x
  --  Note that when x is unsigned, the result is one bit wider than x to allow for sign extension
  --  Always implemened as a single adder (ie. returns x+0 or not(x)+1)
  function GLB_negate(neg : std_logic; x : signed) return signed is
    variable res : signed(x'length downto 0) := resize(x, x'length+1);
    variable cin : signed(1 downto 0)        := (others => '0');
  begin
    if (to_X01(neg) = '1') then
      res    := not res;
      cin(0) := '1';
    end if;
    return res+cin;
  end function;

  function GLB_negate(neg : std_logic; x : unsigned) return signed is
    variable res : signed(x'length downto 0) := signed(resize(x, x'length+1));
    variable cin : signed(1 downto 0)        := (others => '0');
  begin
    if (to_X01(neg) = '1') then
      res    := not res;
      cin(0) := '1';
    end if;
    return res+cin;
  end function;

  ------------------------------------------------------------------------------------------------------------------------
  --Implements a two input mux as a boolean equation:
  --  result(n)=(not sel and in0(n)) or (sel and in1(n))
  --This form is useful with registered MUXes where XST is using the R/S control signal to implement logic in silly ways
  function GLB_mux(sel : std_logic; in0 : std_logic; in1 : std_logic) return std_logic is
  begin
    return (not sel and in0) or (sel and in1);
  end function;

  function GLB_mux(sel : std_logic; in0 : std_logic_vector; in1 : std_logic_vector) return std_logic_vector is
    constant RES_NBITS : natural                                := GLB_max(in0'length, in1'length);
    variable sel_wide  : std_logic_vector(RES_NBITS-1 downto 0) := (others => sel);
    variable in0_wide  : std_logic_vector(RES_NBITS-1 downto 0);
    variable in1_wide  : std_logic_vector(RES_NBITS-1 downto 0);
  begin
    in0_wide(in0'length-1 downto 0) := in0;
    in1_wide(in1'length-1 downto 0) := in1;
    return (not sel_wide and in0_wide) or (sel_wide and in1_wide);
  end function;

  function GLB_mux(sel : std_logic; in0 : unsigned; in1 : unsigned) return unsigned is
    constant RES_NBITS : natural                        := GLB_max(in0'length, in1'length);
    variable sel_wide  : unsigned(RES_NBITS-1 downto 0) := (others => sel);
    variable in0_wide  : unsigned(RES_NBITS-1 downto 0) := resize(in0, RES_NBITS);
    variable in1_wide  : unsigned(RES_NBITS-1 downto 0) := resize(in1, RES_NBITS);
  begin
    return (not sel_wide and in0_wide) or (sel_wide and in1_wide);
  end function;

  function GLB_mux(sel : std_logic; in0 : natural; in1 : unsigned) return unsigned is
  begin
    return GLB_mux(sel, to_unsigned(in0, in1'length), in1);
  end function;

  function GLB_mux(sel : std_logic; in0 : unsigned; in1 : natural) return unsigned is
  begin
    return GLB_mux(sel, in0, to_unsigned(in1, in0'length));
  end function;

  function GLB_mux(sel : std_logic; in0 : signed; in1 : signed) return signed is
    constant RES_NBITS : natural                      := GLB_max(in0'length, in1'length);
    variable sel_wide  : signed(RES_NBITS-1 downto 0) := (others => sel);
    variable in0_wide  : signed(RES_NBITS-1 downto 0) := resize(in0, RES_NBITS);
    variable in1_wide  : signed(RES_NBITS-1 downto 0) := resize(in1, RES_NBITS);
  begin
    return (not sel_wide and in0_wide) or (sel_wide and in1_wide);
  end function;

  function GLB_mux(sel : std_logic; in0 : integer; in1 : signed) return signed is
  begin
    return GLB_mux(sel, to_signed(in0, in1'length), in1);
  end function;

  function GLB_mux(sel : std_logic; in0 : signed; in1 : integer) return signed is
  begin
    return GLB_mux(sel, in0, to_signed(in1, in0'length));
  end function;

end package body;
