--
--  File Name:         CoveragePkg.vhd
--  Design Unit Name:  CoveragePkg
--  Revision:          STANDARD VERSION,  revision 2.3
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis          email:  jim@synthworks.com
--     Jerry Kaczynski    email:  jerry@aldec.com  (GetBin Function)
--
--
--  Package Defines
--      Utilities to support coverage of boolean expressions,
--      ranges on a single object (point or item coverage), and
--      ranges on multiple objects (cross coverage)
--
--  Developed for:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        11898 SW 128th Ave.  Tigard, Or  97223
--        http://www.SynthWorks.com
--
--  Latest standard version available at:
--        http://www.SynthWorks.com/downloads
--
--  Revision History:
--    Date      Version    Description
--    06/2010:  0.1        Initial revision
--    09/2010              Release in SynthWorks' VHDL Testbenches and Verification classes
--    02/2011:  1.0        STANDARD VERSION, Public Release,
--                         Requires VHDL-2008 types integer_vector and boolean_vecctor
--                         Changed CoverBinType to facilitage long term support of cross coverage
--    02/2011:  1.1        STANDARD VERSION, Public Release
--                         Added GetMinCov, GetMaxCov, CountCovHole, GetCovHole
--    04/2011:  2.0        STANDARD VERSION, Public Release
--                         Added CovPType
--    06/2011:  2.1        STANDARD VERSION, Public Release
--                         Removed Signal Based Coverage
--    07/2011:  2.2        STANDARD VERSION, Public Release
--                         Added Weight, AtLeast, randomization with percentage thresholds
--                         Randomization with weights/weight modes
--                         Cleaned up parameter naming
--    11/2011:  2.2a       STANDARD VERSION, Public Release
--                         Made ALL_RANGE and constants in ZERO_BIN and ONE_BIN have a 1 index 
--                         rather than 0 to match the range of BinVal
--    12/2011:  2.2b       STANDARD VERSION, Public Release
--                         Fixed minor inconsistencies on interface declarations.
--                         Library RandomPkg is assumed to be in the same library as CoveragePkg
--    01/2012:  2.3        STANDARD VERSION, Public Release
--                         Added Function GetBin from Jerry K.
--                         Made write for RangeArrayType visible
--                         
--
--
--  Development Notes:
--      The coverage procedures are named ICover to avoid conflicts with
--      future language changes which may add cover as a keyword
--      Procedure WriteBin writes each CovBin on a separate line, as such
--      it was inappropriate to overload either textio write or to_string
--      In the notes VHDL-2008 notes refers to
--      composites with unconstrained elements
--
--
--  Copyright (c) 2010 - 2012 by SynthWorks Design Inc.  All rights reserved.
--
--  Verbatim copies of this source file may be used and
--  distributed without restriction.
--
--  This source file is free software; you can redistribute it
--  and/or modify it under the terms of the ARTISTIC License
--  as published by The Perl Foundation; either version 2.0 of
--  the License, or (at your option) any later version.
--
--  This source is distributed in the hope that it will be
--  useful, but WITHOUT ANY WARRANTY; without even the implied
--  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
--  PURPOSE. See the Artistic License for details.
--
--  You should have received a copy of the license with this source.
--  If not download it from,
--     http://www.perlfoundation.org/artistic_license_2_0
--
--  Credits:
--    CovBinBaseType is inspired by a structure proposed in the
--    paper "Functional Coverage - without SystemVerilog!"
--    by Alan Fitch and Doug Smith.  Presented at DVCon 2010
--    However the approach in their paper uses entities and
--    architectures where this approach relies on functions
--    and procedures, so the usage models differ greatly however.
--

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
use ieee.math_real.all ;
use std.textio.all ;

-- comment out following 2 lines with VHDL-2008.  Leave in for VHDL-2002
-- library ieee_proposed ;						          -- remove with VHDL-2008
-- use ieee_proposed.standard_additions.all ;   -- remove with VHDL-2008

use work.RandomPkg.all ;
use work.RandomBasePkg.all ;

package CoveragePkg is

  -- CovPType allocates bins that are multiples of MIN_NUM_BINS
  constant MIN_NUM_BINS : integer := 2**7 ;  -- power of 2

  type RangeType is record
    min : integer ;
    max : integer ;
  end record ;
  type RangeArrayType is array (integer range <>) of RangeType ;
  constant ALL_RANGE : RangeArrayType := (1=>(Integer'left, Integer'right)) ;

  procedure write ( file f :  text ;  BinVal : RangeArrayType ) ;
  

  -- CovBinBaseType.action values.
  -- Note that coverage counting depends on these values
  constant COV_COUNT   : integer := 1 ;
  constant COV_IGNORE  : integer := 0 ;
  constant COV_ILLEGAL : integer := -1 ;

  constant DEFAULT_AT_LEAST : integer := 10 ;

  -- Used for easy manual entry.  Order: min, max, action
  -- Intentionally did not use a record to allow other input
  -- formats in the future with VHDL-2008 unconstrained arrays
  -- of unconstrained elements
  type CovBinManualType is array (natural range <>) of integer_vector(0 to 2) ;

  type CovBinBaseType is record
    BinVal    : RangeArrayType(1 to 1) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovBinType is array (natural range <>) of CovBinBaseType ;

  constant ALL_BIN     : CovBinType := (0 => ( BinVal => ALL_RANGE,  Action => COV_COUNT,   Count => 0, AtLeast => 1, Weight => 1 )) ;
  constant ALL_COUNT   : CovBinType := (0 => ( BinVal => ALL_RANGE,  Action => COV_COUNT,   Count => 0, AtLeast => 1, Weight => 1 )) ;
  constant ALL_ILLEGAL : CovBinType := (0 => ( BinVal => ALL_RANGE,  Action => COV_ILLEGAL, Count => 0, AtLeast => 0, Weight => 0 )) ;
  constant ALL_IGNORE  : CovBinType := (0 => ( BinVal => ALL_RANGE,  Action => COV_IGNORE,  Count => 0, AtLeast => 0, Weight => 0 )) ;
  constant ZERO_BIN    : CovBinType := (0 => ( BinVal => (1=>(0,0)), Action => COV_COUNT,   Count => 0, AtLeast => 1, Weight => 1 )) ;
  constant ONE_BIN     : CovBinType := (0 => ( BinVal => (1=>(1,1)), Action => COV_COUNT,   Count => 0, AtLeast => 1, Weight => 1 )) ;
  constant NULL_BIN    : CovBinType(1 to 0) := (others => ( BinVal => ALL_RANGE,  Action => integer'high, Count => 0, AtLeast => integer'high, Weight => integer'high )) ;

  type CountModeType   is (COUNT_FIRST, COUNT_ALL) ;
  type IllegalModeType is (ILLEGAL_ON, ILLEGAL_OFF) ;
  type WeightModeType  is (AT_LEAST, WEIGHT, REMAIN, REMAIN_AT_LEAST, REMAIN_WEIGHT) ;


  -- In VHDL-2008 CovMatrix?BaseType and CovMatrix?Type will be subsumed
  -- by CovBinBaseType and CovBinType with RangeArrayType as an unconstrained array.
  type CovMatrix2BaseType is record
    BinVal    : RangeArrayType(1 to 2) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix2Type is array (natural range <>) of CovMatrix2BaseType ;

  type CovMatrix3BaseType is record
    BinVal    : RangeArrayType(1 to 3) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix3Type is array (natural range <>) of CovMatrix3BaseType ;

  type CovMatrix4BaseType is record
    BinVal    : RangeArrayType(1 to 4) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix4Type is array (natural range <>) of CovMatrix4BaseType ;

  type CovMatrix5BaseType is record
    BinVal    : RangeArrayType(1 to 5) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix5Type is array (natural range <>) of CovMatrix5BaseType ;

  type CovMatrix6BaseType is record
    BinVal    : RangeArrayType(1 to 6) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix6Type is array (natural range <>) of CovMatrix6BaseType ;

  type CovMatrix7BaseType is record
    BinVal    : RangeArrayType(1 to 7) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix7Type is array (natural range <>) of CovMatrix7BaseType ;

  type CovMatrix8BaseType is record
    BinVal    : RangeArrayType(1 to 8) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix8Type is array (natural range <>) of CovMatrix8BaseType ;

  type CovMatrix9BaseType is record
    BinVal    : RangeArrayType(1 to 9) ;
    Action    : integer ;
    Count     : integer ;
    AtLeast   : integer ;
    Weight    : integer ;
  end record ;
  type CovMatrix9Type is array (natural range <>) of CovMatrix9BaseType ;


-- ======================================================================
-- Remove these?  =======================================================
-- ======================================================================
  ------------------------------------------------------------
  procedure RandCovPoint(
  -- better as a function, however, inout not supported on functions
  ------------------------------------------------------------
    variable RV       : inout RandomPType ;
    constant BinVal   : in    RangeArrayType ;
    variable result   : out   integer
  ) ;


  ------------------------------------------------------------
  procedure RandCovPoint(
  ------------------------------------------------------------
    variable RV       : inout RandomPType ;
    constant BinVal   : in    RangeArrayType ;
    variable result   : out   integer_vector
  ) ;


  ------------------------------------------------------------------------------------------
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ------------------------------------------------------------------------------------------
  type CovPType is protected
    procedure SetCountMode (A : CountModeType) ;
    procedure SetIllegalMode (A : IllegalModeType) ;
    procedure SetWeightMode (A : WeightModeType;  Scale : real := 1.5) ;
    procedure SetName (NameIn : String) ;
    procedure SetItemName (ItemNameIn : String) ;
    procedure SetCovThreshold (Percent : real) ;

    procedure InitSeed (S  : string ) ;
    procedure InitSeed (I  : integer ) ;
    procedure SetSeed (RandomSeedIn : RandomSeedType ) ;
    impure function GetSeed return RandomSeedType ;

    procedure SetBinSize (NewNumBins : integer) ;

    ------------------------------------------------------------
    procedure AddBins (
      AtLeast : integer ;
      Weight  : integer ;
      CovBin : CovBinType
    ) ;

    procedure AddBins (AtLeast : integer ;  CovBin : CovBinType) ;
    procedure AddBins (CovBin : CovBinType) ;

    ------------------------------------------------------------
    procedure AddCross(
      AtLeast : integer ;
      Weight  : integer ;
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) ;

    ------------------------------------------------------------
    procedure AddCross(
      AtLeast : integer ;
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) ;

    ------------------------------------------------------------
    procedure AddCross(
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) ;

    procedure Deallocate ;

    procedure ICover( CovPoint : integer_vector) ;
    procedure ICover( CovPoint : integer) ;

    procedure SetCovZero ;

    impure function GetMinCov return real ;
    impure function GetMaxCov return real ;
    impure function CountCovHoles ( PercentCov : real := 100.0 ) return integer ;
    impure function IsCovered ( PercentCov : real := 100.0 ) return boolean ;
    impure function GetCovHole ( ReqHoleNum : integer := 1 ; PercentCov : real := 100.0 ) return RangeArrayType ;
    impure function RandCovHole ( PercentCov : real := 100.0 ) return RangeArrayType ;
    -- impure function RandCovPoint ( PercentCov : real := 100.0 ) return integer ;
    impure function RandCovPoint ( PercentCov : real := 100.0 ) return integer_vector ;

    -- The following 7 functions are subsumed by the versions above that use the 
    -- PercentCov parameter.  They are maintained for backward compatibility only and
    -- may be removed in the future.    
    impure function GetMinCov return integer ;
    impure function GetMaxCov return integer ;
    impure function CountCovHoles ( AtLeast : integer ) return integer ;
    impure function IsCovered ( AtLeast : integer ) return boolean ;
    impure function GetCovHole ( ReqHoleNum : integer := 1 ; AtLeast : integer ) return RangeArrayType ;
    impure function RandCovHole ( AtLeast : integer ) return RangeArrayType ;
    impure function RandCovPoint (AtLeast : integer ) return integer_vector ;

    -- GetBin returns an internal value of the coverage data structure
    -- The return value may change as the package evolves
    -- Use it only for debugging.    
    impure function GetBin ( Num : integer ) return CovBinBaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix2BaseType  ;
    impure function GetBin ( Num : integer ) return CovMatrix3BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix4BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix5BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix6BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix7BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix8BaseType ;
    impure function GetBin ( Num : integer ) return CovMatrix9BaseType ;  
    
    -- procedure WriteBin ( file f : text ) ;
    procedure WriteBin ;
    procedure WriteBin ( FileName : string; OpenKind : File_Open_Kind := APPEND_MODE ) ;
    procedure WriteCovHoles ( PercentCov : real := 100.0 ) ;
    procedure WriteCovHoles ( FileName : string;  PercentCov : real := 100.0 ; OpenKind : File_Open_Kind := APPEND_MODE ) ;
    procedure WriteCovHoles ( AtLeast : integer ) ;
    procedure WriteCovHoles ( FileName : string;  AtLeast : integer ; OpenKind : File_Open_Kind := APPEND_MODE ) ;
    procedure DumpBin ;  -- Development only
    procedure WriteOrderCount ;  -- Development only

    procedure ReadCovDb (FileName : string) ;
    procedure WriteCovDb (FileName : string; OpenKind : File_Open_Kind := APPEND_MODE ) ;
    impure function CovBinErrCnt return integer ;

    -- These support the older AddBins(GenCross(...)) methodology
    -- which has been replaced by AddCross
    procedure AddBins (CovBin : CovMatrix2Type) ;
    procedure AddBins (CovBin : CovMatrix3Type) ;
    procedure AddBins (CovBin : CovMatrix4Type) ;
    procedure AddBins (CovBin : CovMatrix5Type) ;
    procedure AddBins (CovBin : CovMatrix6Type) ;
    procedure AddBins (CovBin : CovMatrix7Type) ;
    procedure AddBins (CovBin : CovMatrix8Type) ;
    procedure AddBins (CovBin : CovMatrix9Type) ;


  end protected CovPType ;
  ------------------------------------------------------------------------------------------
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ------------------------------------------------------------------------------------------


  --
  --  Support for AddBins and AddCross
  --

  ------------------------------------------------------------
  function GenBin(
  ------------------------------------------------------------
    AtLeast       : integer ;
    Weight        : integer ;
    Min, Max      : integer ;
    NumBin        : integer 
  ) return CovBinType ;

  -- Each item in range in a separate CovBin
  function GenBin(AtLeast : integer ;  Min, Max, NumBin : integer ) return CovBinType ;
  function GenBin(Min, Max, NumBin : integer ) return CovBinType ;
  function GenBin(Min, Max : integer) return CovBinType ;
  function GenBin(A : integer) return CovBinType ;


  ------------------------------------------------------------
  function IllegalBin ( Min, Max, NumBin : integer ) return CovBinType ; 
  ------------------------------------------------------------

  -- All items in range in a single CovBin
  function IllegalBin ( Min, Max : integer ) return CovBinType ;
  function IllegalBin ( A : integer ) return CovBinType ;


  ------------------------------------------------------------
  function IgnoreBin (
  ------------------------------------------------------------
    AtLeast       : integer ;
    Weight        : integer ;
    Min, Max      : integer ;
    NumBin        : integer 
  ) return CovBinType ;

  -- All items in range in a single CovBin
  function IgnoreBin (AtLeast : integer ;  Min, Max, NumBin : integer) return CovBinType ;
  function IgnoreBin (Min, Max, NumBin : integer) return CovBinType ;
  function IgnoreBin (Min, Max : integer) return CovBinType ;
  function IgnoreBin (A : integer) return CovBinType ;


  ------------------------------------------------------------
  function GenBin (
  -- Manual entry format for CovBin within lots of extra parens
  ------------------------------------------------------------
    ManualBin    : CovBinManualType
  ) return CovBinType ;


  -- With VHDL-2008, there will be one GenCross that returns CovBinType
  -- and has inputs initialized to NULL_BIN - see AddCross
  ------------------------------------------------------------
  function GenCross(  -- 2
  -- Cross existing bins  
  -- Use AddCross for adding values directly to coverage database
  -- Use GenCross for constants
  ------------------------------------------------------------
    AtLeast     : integer ;
    Weight      : integer ;
    Bin1, Bin2  : CovBinType
  ) return CovMatrix2Type ;

  function GenCross(AtLeast : integer ; Bin1, Bin2 : CovBinType) return CovMatrix2Type ;
  function GenCross(Bin1, Bin2 : CovBinType) return CovMatrix2Type ;


  ------------------------------------------------------------
  function GenCross(  -- 3
  ------------------------------------------------------------
    AtLeast           : integer ;
    Weight            : integer ;
    Bin1, Bin2, Bin3  : CovBinType
  ) return CovMatrix3Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3 : CovBinType ) return CovMatrix3Type ;
  function GenCross( Bin1, Bin2, Bin3 : CovBinType ) return CovMatrix3Type ;


  ------------------------------------------------------------
  function GenCross(  -- 4
  ------------------------------------------------------------
    AtLeast                 : integer ;
    Weight                  : integer ;
    Bin1, Bin2, Bin3, Bin4  : CovBinType
  ) return CovMatrix4Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4 : CovBinType ) return CovMatrix4Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4 : CovBinType ) return CovMatrix4Type ;


  ------------------------------------------------------------
  function GenCross(  -- 5
  ------------------------------------------------------------
    AtLeast                       : integer ;
    Weight                        : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5  : CovBinType
  ) return CovMatrix5Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5 : CovBinType ) return CovMatrix5Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5 : CovBinType ) return CovMatrix5Type ;


  ------------------------------------------------------------
  function GenCross(  -- 6
  ------------------------------------------------------------
    AtLeast                             : integer ;
    Weight                              : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6  : CovBinType
  ) return CovMatrix6Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6 : CovBinType ) return CovMatrix6Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6 : CovBinType ) return CovMatrix6Type ;


  ------------------------------------------------------------
  function GenCross(  -- 7
  ------------------------------------------------------------
    AtLeast                                   : integer ;
    Weight                                    : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7  : CovBinType
  ) return CovMatrix7Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7 : CovBinType ) return CovMatrix7Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7 : CovBinType ) return CovMatrix7Type ;


  ------------------------------------------------------------
  function GenCross(  -- 8
  ------------------------------------------------------------
    AtLeast                                         : integer ;
    Weight                                          : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8  : CovBinType
  ) return CovMatrix8Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8 : CovBinType ) return CovMatrix8Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8 : CovBinType ) return CovMatrix8Type ;


  ------------------------------------------------------------
  function GenCross(  -- 9
  ------------------------------------------------------------
    AtLeast                                               : integer ;
    Weight                                                : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9  : CovBinType
  ) return CovMatrix9Type ;

  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9 : CovBinType ) return CovMatrix9Type ;
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9 : CovBinType ) return CovMatrix9Type ;


  ------------------------------------------------------------
  procedure increment( signal Count : inout integer ) ;
  procedure increment( signal Count : inout integer ; enable : boolean ) ;
  procedure increment( signal Count : inout integer ; enable : std_ulogic ) ;


  ------------------------------------------------------------
  -- Utilities.  Remove if added to std.standard
  function to_integer ( B : boolean ) return integer ;
  function to_integer ( SL : std_logic ) return integer ;
  function to_integer_vector ( BV : boolean_vector ) return integer_vector ;
  function to_integer_vector ( SLV : std_logic_vector ) return integer_vector ;


end package CoveragePkg ;

--- //////////////////////////////////////////////////////////////////////////////////////////////
--- //////////////////////////////////////////////////////////////////////////////////////////////

package body CoveragePkg is
  ------------------------------------------------------------
  function inside (
  -- local
  ------------------------------------------------------------
    CovPoint : integer ;
    BinVal   : RangeType
  ) return boolean is
  begin
    return CovPoint >= BinVal.min and CovPoint <= BinVal.max ;
  end function inside ;


  ------------------------------------------------------------
  function inside (
  -- local
  ------------------------------------------------------------
    CovPoint : integer_vector ;
    BinVal   : RangeArrayType
  ) return boolean is
    alias iCovPoint : integer_vector(BinVal'range) is CovPoint ;
  begin
    for i in BinVal'range loop
      if not (iCovPoint(i) >= BinVal(i).min and iCovPoint(i) <= BinVal(i).max) then
        return FALSE ;
      end if ;
    end loop ;
    return TRUE ;
  end function inside ;


  ------------------------------------------------------------
  procedure write ( file f :  text ;  CovPoint : integer_vector ) is
  -- local.  called by ICover
  ------------------------------------------------------------
    alias iCovPoint : integer_vector(1 to CovPoint'length) is CovPoint ;
  begin
    write(f, "(" & integer'image(iCovPoint(1)) ) ;
    for i in 2 to iCovPoint'right loop
      write(f, "," & integer'image(iCovPoint(i)) ) ;
    end loop ;
    write(f, ")") ;
  end procedure write ;


  ------------------------------------------------------------
  procedure write ( file f :  text ;  BinVal : RangeArrayType ) is
  -- called by WriteBin and WriteCovHoles
  ------------------------------------------------------------
  begin
    for i in BinVal'range loop
      if BinVal(i).min = BinVal(i).max then
        write(f, "(" & integer'image(BinVal(i).min) & ") " ) ;
      elsif  (BinVal(i).min = integer'left) and (BinVal(i).max = integer'right) then
        write(f, "(ALL) " ) ;
      else
        write(f, "(" & integer'image(BinVal(i).min) & " to " &
                       integer'image(BinVal(i).max) & ") " ) ;
      end if ;
    end loop ;
  end procedure write ;


  ------------------------------------------------------------
  -- Local
  function failed (InValid : boolean ; Message : string := " ") return boolean is
  -- Move to TbUtilPkg and make visible?
  ------------------------------------------------------------
  begin
    if InValid then
      report Message severity failure ;
    end if ;
    return InValid ;
  end function failed ;


  ------------------------------------------------------------
  -- Local
  procedure EmptyOrCommentLine (
  -- Better as Function, but not supported in VHDL functions
  ------------------------------------------------------------
    variable L     : InOut line ;
    variable Empty : out   boolean
  ) is
    variable Valid : boolean ;
    variable Char  : character ;
    constant NBSP  : CHARACTER := CHARACTER'val(160);  -- space character
  begin
    Empty := TRUE ;

    -- if line empty (null or 0 length), Empty = TRUE
    if L = null or L.all'length = 0 then
      return ;
    end if ;

    -- if line starts with '#', empty = TRUE
    if L.all(1) = '#' then
      return ;
    end if ;

    -- if line starts with '--', empty = TRUE
    if L.all'length >= 2 and L.all(1) = '-' and L.all(2) = '-' then
      return ;
    end if ;

    -- Otherwise, remove white space and check for end of line
    -- Code borrowed from David Bishop, skip_whitespace
    WhiteSpLoop : while L /= null and L.all'length > 0 loop
      if (L.all(1) = ' ' or L.all(1) = NBSP or L.all(1) = HT) then
        read (L, Char, Valid) ;
      else
        Empty := FALSE ;
        exit WhiteSpLoop ;
      end if ;
    end loop WhiteSpLoop ;
  end procedure EmptyOrCommentLine ;


  ------------------------------------------------------------
  -- Local
  procedure GetCovDbInfo (
  ------------------------------------------------------------
    File     CovDbFile     :       text ;
    variable NumRangeItems : out integer ;
    variable NumLines      : out integer
  ) is
    variable buf           : line ;
    variable ReadValid     : boolean ;
    variable Empty         : boolean ;
  begin

    ReadLoop : while not EndFile(CovDbFile) loop
      ReadLine(CovDbFile, buf) ;
      EmptyOrCommentLine(buf, Empty) ;
      next when Empty ;

      read(buf, NumRangeItems, ReadValid) ;
      exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading NumRangeItems") ;
      read(buf, NumLines, ReadValid) ;
      assert ReadValid
          report "ReadCovDb: Failed while reading NumLines"
          severity failure ;
      exit ;
    end loop ReadLoop ;
  end procedure GetCovDbInfo ;


  ------------------------------------------------------------
  -- local for now
  procedure read (
  -- if public, also create one that does not use valid flag
  ------------------------------------------------------------
    variable buf    : inout line ;
    variable BinVal : out   RangeArrayType ;
    variable Valid  : out   boolean
  ) is
    variable ReadValid : boolean ;
  begin
    for i in BinVal'range loop
      read(buf, BinVal(i).min, ReadValid) ;
      exit when not ReadValid ;
      read(buf, BinVal(i).max, ReadValid) ;
      exit when not ReadValid ;
    end loop ;
    Valid := ReadValid ;
  end procedure read ;


  ------------------------------------------------------------
  procedure write (
  -- local for now
  ------------------------------------------------------------
    variable buf    : inout line ;
    constant BinVal : in    RangeArrayType
  ) is
  begin
    for i in BinVal'range loop
      write(buf, BinVal(i).min) ;
      write(buf, ' ') ;
      write(buf, BinVal(i).max) ;
      write(buf, ' ') ;
    end loop ;
  end procedure write ;


  -- ------------------------------------------------------------
  function BinLengths (
  -- local, used by AddCross, GenCross
  -- ------------------------------------------------------------
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
    Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
 ) return integer_vector is
   variable result : integer_vector(1 to 20) := (others => 0 ) ;
   variable i : integer := result'left ;
   variable Len : integer ;
  begin
    loop
      case i is
        when  1 =>  Len := Bin1'length ;
        when  2 =>  Len := Bin2'length ;
        when  3 =>  Len := Bin3'length ;
        when  4 =>  Len := Bin4'length ;
        when  5 =>  Len := Bin5'length ;
        when  6 =>  Len := Bin6'length ;
        when  7 =>  Len := Bin7'length ;
        when  8 =>  Len := Bin8'length ;
        when  9 =>  Len := Bin9'length ;
        when 10 =>  Len := Bin10'length ;
        when 11 =>  Len := Bin11'length ;
        when 12 =>  Len := Bin12'length ;
        when 13 =>  Len := Bin13'length ;
        when 14 =>  Len := Bin14'length ;
        when 15 =>  Len := Bin15'length ;
        when 16 =>  Len := Bin16'length ;
        when 17 =>  Len := Bin17'length ;
        when 18 =>  Len := Bin18'length ;
        when 19 =>  Len := Bin19'length ;
        when 20 =>  Len := Bin20'length ;
        when others =>  Len := 0 ;
      end case ;
      result(i) := Len ;
      exit when Len = 0 ;
      i := i + 1 ;
      exit when i = 21 ;
    end loop ;
    return result(1 to (i-1)) ;
  end function BinLengths ;


  -- ------------------------------------------------------------
  function CalcNumCrossBins ( BinLens : integer_vector ) return integer is
  -- local, used by AddCross
  -- ------------------------------------------------------------
    variable result : integer := 1 ;
  begin
    for i in BinLens'range loop
      result := result * BinLens(i) ;
    end loop ;
    return result ;
  end function CalcNumCrossBins ;


  -- ------------------------------------------------------------
  procedure IncBinIndex (
  -- local, used by AddCross
  -- ------------------------------------------------------------
    variable BinIndex : inout integer_vector ;
    constant BinLens  : in    integer_vector
  ) is
    alias aBinIndex : integer_vector(1 to BinIndex'length) is BinIndex ;
    alias aBinLens  : integer_vector(aBinIndex'range) is BinLens ;
  begin
    -- increment right most one, then if overflow, increment next
    -- assumes bins numbered from 1 to N.  - assured by ConcatenateBins
    for i in aBinIndex'reverse_range loop
      aBinIndex(i) := aBinIndex(i) + 1 ;
      exit when aBinIndex(i) <= aBinLens(i) ;
      aBinIndex(i) := 1 ;
    end loop ;
  end procedure IncBinIndex ;


  -- ------------------------------------------------------------
  function ConcatenateBins (
  -- local, used by AddCross
  -- ------------------------------------------------------------
    BinIndex : integer_vector ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
    Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
  ) return CovBinType is
    alias aBin1  : CovBinType (1 to Bin1'length) is Bin1 ;
    alias aBin2  : CovBinType (1 to Bin2'length) is Bin2 ;
    alias aBin3  : CovBinType (1 to Bin3'length) is Bin3 ;
    alias aBin4  : CovBinType (1 to Bin4'length) is Bin4 ;
    alias aBin5  : CovBinType (1 to Bin5'length) is Bin5 ;
    alias aBin6  : CovBinType (1 to Bin6'length) is Bin6 ;
    alias aBin7  : CovBinType (1 to Bin7'length) is Bin7 ;
    alias aBin8  : CovBinType (1 to Bin8'length) is Bin8 ;
    alias aBin9  : CovBinType (1 to Bin9'length) is Bin9 ;
    alias aBin10 : CovBinType (1 to Bin10'length) is Bin10 ;
    alias aBin11 : CovBinType (1 to Bin11'length) is Bin11 ;
    alias aBin12 : CovBinType (1 to Bin12'length) is Bin12 ;
    alias aBin13 : CovBinType (1 to Bin13'length) is Bin13 ;
    alias aBin14 : CovBinType (1 to Bin14'length) is Bin14 ;
    alias aBin15 : CovBinType (1 to Bin15'length) is Bin15 ;
    alias aBin16 : CovBinType (1 to Bin16'length) is Bin16 ;
    alias aBin17 : CovBinType (1 to Bin17'length) is Bin17 ;
    alias aBin18 : CovBinType (1 to Bin18'length) is Bin18 ;
    alias aBin19 : CovBinType (1 to Bin19'length) is Bin19 ;
    alias aBin20 : CovBinType (1 to Bin20'length) is Bin20 ;
    alias aBinIndex : integer_vector(1 to BinIndex'length) is BinIndex ;
    variable result : CovBinType(aBinIndex'range) ;
  begin
    for i in aBinIndex'range loop
      case i is
        when  1 =>  result(i) := aBin1(aBinIndex(i)) ;
        when  2 =>  result(i) := aBin2(aBinIndex(i)) ;
        when  3 =>  result(i) := aBin3(aBinIndex(i)) ;
        when  4 =>  result(i) := aBin4(aBinIndex(i)) ;
        when  5 =>  result(i) := aBin5(aBinIndex(i)) ;
        when  6 =>  result(i) := aBin6(aBinIndex(i)) ;
        when  7 =>  result(i) := aBin7(aBinIndex(i)) ;
        when  8 =>  result(i) := aBin8(aBinIndex(i)) ;
        when  9 =>  result(i) := aBin9(aBinIndex(i)) ;
        when 10 =>  result(i) := aBin10(aBinIndex(i)) ;
        when 11 =>  result(i) := aBin11(aBinIndex(i)) ;
        when 12 =>  result(i) := aBin12(aBinIndex(i)) ;
        when 13 =>  result(i) := aBin13(aBinIndex(i)) ;
        when 14 =>  result(i) := aBin14(aBinIndex(i)) ;
        when 15 =>  result(i) := aBin15(aBinIndex(i)) ;
        when 16 =>  result(i) := aBin16(aBinIndex(i)) ;
        when 17 =>  result(i) := aBin17(aBinIndex(i)) ;
        when 18 =>  result(i) := aBin18(aBinIndex(i)) ;
        when 19 =>  result(i) := aBin19(aBinIndex(i)) ;
        when 20 =>  result(i) := aBin20(aBinIndex(i)) ;
        when others =>  report "ConcatenateBins: More than 20 bins not supported" severity failure ;
      end case ;
    end loop ;
    return result ;
  end function ConcatenateBins ;


  ------------------------------------------------------------
  function MergeState( CrossBins : CovBinType) return integer is
  -- local, Used by AddCross, GenCross
  ------------------------------------------------------------
    variable resultState : integer ;
  begin
    resultState := COV_COUNT ;
    for i in CrossBins'range loop
      if CrossBins(i).action = COV_ILLEGAL then
        return COV_ILLEGAL ;
      end if ;
      if CrossBins(i).action = COV_IGNORE then
        resultState := COV_IGNORE ;
      end if ;
    end loop ;
    return resultState ;
  end function MergeState ;


  ------------------------------------------------------------
  function MergeBinVal( CrossBins : CovBinType) return RangeArrayType is
  -- local, Used by AddCross, GenCross
  ------------------------------------------------------------
    alias aCrossBins : CovBinType(1 to CrossBins'length) is CrossBins ;
    variable BinVal : RangeArrayType(aCrossBins'range) ;
  begin
    for i in aCrossBins'range loop
      BinVal(i to i) := aCrossBins(i).BinVal ;
    end loop ;
    return BinVal ;
  end function MergeBinVal ;


  ------------------------------------------------------------
  function MergeAtLeast(
  -- local, Used by AddCross, GenCross
  ------------------------------------------------------------
    Action    : in integer ;
    AtLeast   : in integer ;
    CrossBins : in CovBinType
  ) return integer is
    variable Result : integer := AtLeast ;
  begin
    if Action /= COV_COUNT then 
      return 0 ; 
    end if ; 
    for i in CrossBins'range loop
      if CrossBins(i).Action = Action then
        Result := maximum (Result, CrossBins(i).AtLeast) ;
      end if ;
    end loop ;
    return result ;
  end function MergeAtLeast ;


  ------------------------------------------------------------
  function MergeWeight(
  -- local, Used by AddCross, GenCross
  ------------------------------------------------------------
    Action    : in integer ;
    Weight    : in integer ;
    CrossBins : in CovBinType
  ) return integer is
    variable Result : integer := Weight ;
  begin
    if Action /= COV_COUNT then 
      return 0 ; 
    end if ; 
    for i in CrossBins'range loop
      if CrossBins(i).Action = Action then
        Result := maximum (Result, CrossBins(i).Weight) ;
      end if ;
    end loop ;
    return result ;
  end function MergeWeight ;


-- ======================================================================
-- Remove these?  =======================================================
-- ======================================================================
  ------------------------------------------------------------
  procedure RandCovPoint(
  ------------------------------------------------------------
    variable RV       : inout RandomPType ;
    constant BinVal   : in    RangeArrayType ;
    variable result   : out   integer
  ) is
  begin
    result := RV.RandInt(BinVal(BinVal'left).min, BinVal(BinVal'left).max) ;
  end procedure RandCovPoint ;


  ------------------------------------------------------------
  procedure RandCovPoint(
  ------------------------------------------------------------
    variable RV       : inout RandomPType ;
    constant BinVal   : in    RangeArrayType ;
    variable result   : out   integer_vector
  ) is
    variable VectorVal : integer_vector(BinVal'range) ;
  begin
    for i in BinVal'range loop
      VectorVal(i) := RV.RandInt(BinVal(i).min, BinVal(i).max) ;
    end loop ;
    result := VectorVal ;
  end procedure RandCovPoint ;


  ------------------------------------------------------------------------------------------
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ------------------------------------------------------------------------------------------
  type CovPType is protected body

    -- CoverageBin Data Structures
    type RangeArrayPtrType is access RangeArrayType ;

    type CovBinBaseTempType is record
      BinVal        : RangeArrayPtrType ;
      Action        : integer ;
      Count         : integer ;
      AtLeast       : integer ;
      Weight        : integer ;
      PercentCov    : real ;
      OrderCount    : integer ;
    end record CovBinBaseTempType ;
    type CovBinTempType is array (natural range <>) of CovBinBaseTempType ;
    type CovBinPtrType is access CovBinTempType ;

    variable CovBinPtr  : CovBinPtrType ;
    variable NumBins    : integer := 0 ;
    variable OrderCount : integer := 0 ; 

    -- Internal Modes and Names
    variable CountMode     : CountModeType   := COUNT_FIRST ;
    variable IllegalMode   : IllegalModeType := ILLEGAL_ON ;
    variable WeightMode    : WeightModeType  := AT_LEAST ;
    variable WeightScale   : real            := 1.5 ;
    variable DonePercent   : real            := 100.0 ; 
    variable Name          : line ;
    variable ItemName      : line;
    variable CovThresholdPercent : real := 45.0 ;

    -- Randomization Variable
    variable RV : RandomPType ;


    ------------------------------------------------------------
    procedure SetCountMode (A : CountModeType) is
    ------------------------------------------------------------
    begin
      CountMode := A ;
    end procedure SetCountMode ;

    ------------------------------------------------------------
    procedure SetIllegalMode (A : IllegalModeType) is
    ------------------------------------------------------------
    begin
      IllegalMode := A ;
    end procedure SetIllegalMode ;

    ------------------------------------------------------------
    procedure SetWeightMode (A : WeightModeType;  Scale : real := 1.5) is
    ------------------------------------------------------------
    begin
      WeightMode := A ;
      WeightScale := Scale ; 
    end procedure SetWeightMode ;

    ------------------------------------------------------------
    procedure SetName (NameIn : String) is
    ------------------------------------------------------------
    begin
      deallocate(Name) ;
      Name := new string'(NameIn) ;
      RV.InitSeed(NameIn) ;
    end procedure SetName ;

    ------------------------------------------------------------
    procedure SetItemName (ItemNameIn : String) is
    ------------------------------------------------------------
    begin
      deallocate(ItemName) ;
      ItemName := new string'(ItemNameIn) ;
    end procedure SetItemName ;

    ------------------------------------------------------------
    procedure SetCovThreshold (Percent : real) is
    ------------------------------------------------------------
    begin
      CovThresholdPercent := Percent ; 
    end procedure SetCovThreshold ;

    ------------------------------------------------------------
    procedure InitSeed (S : string ) is
    ------------------------------------------------------------
    begin
      RV.InitSeed(S) ;
    end procedure InitSeed ;

    ------------------------------------------------------------
    procedure InitSeed (I : integer ) is
    ------------------------------------------------------------
    begin
      RV.InitSeed(I) ;
    end procedure InitSeed ;

    ------------------------------------------------------------
    procedure SetSeed (RandomSeedIn : RandomSeedType ) is
    ------------------------------------------------------------
    begin
      RV.SetSeed(RandomSeedIn) ;
    end procedure SetSeed ;

    ------------------------------------------------------------
    impure function GetSeed return RandomSeedType is
    ------------------------------------------------------------
    begin
      return RV.GetSeed ;
    end function GetSeed ;


    ------------------------------------------------------------
    procedure SetBinSize (NewNumBins : integer) is
    -- Sets a CovBin to a particular size
    -- Use for small bins to save space or large bins to
    -- suppress the resize and copy as a CovBin autosizes.
    ------------------------------------------------------------
      variable oldCovBinPtr : CovBinPtrType ;
    begin
      if CovBinPtr = NULL then
        CovBinPtr := new CovBinTempType(1 to NewNumBins) ;
      elsif NewNumBins > CovBinPtr'length then
        -- make message bigger
        oldCovBinPtr := CovBinPtr ;
        CovBinPtr := new CovBinTempType(1 to NewNumBins) ;
        CovBinPtr.all(1 to NumBins) := oldCovBinPtr.all(1 to NumBins) ;
        deallocate(oldCovBinPtr) ;
      end if ;
    end procedure SetBinSize ;


    ------------------------------------------------------------
    -- local
    impure function NormalizeNumBins( ReqNumBins : integer ) return integer is
      variable NormNumBins : integer := MIN_NUM_BINS ;
    begin
      while NormNumBins < ReqNumBins loop
        NormNumBins := NormNumBins + MIN_NUM_BINS ;
      end loop ;
      return NormNumBins ;
    end function NormalizeNumBins ;


    ------------------------------------------------------------
    -- local
    procedure GrowBins (ReqNumBins : integer) is
      variable oldCovBinPtr : CovBinPtrType ;
      variable NewNumBins   : integer ;
    begin
      NewNumBins := NumBins + ReqNumBins ;
      if CovBinPtr = NULL then
        CovBinPtr := new CovBinTempType(1 to NormalizeNumBins(NewNumBins)) ;
      elsif NewNumBins > CovBinPtr'length then
        -- make message bigger
        oldCovBinPtr := CovBinPtr ;
        CovBinPtr := new CovBinTempType(1 to NormalizeNumBins(NewNumBins)) ;
        CovBinPtr.all(1 to NumBins) := oldCovBinPtr.all(1 to NumBins) ;
        deallocate(oldCovBinPtr) ;
      end if ;
    end procedure GrowBins ;


    ------------------------------------------------------------
    -- local
    procedure NewBin(
      BinVal       : RangeArrayType ;
      Action       : integer ;
      Count        : integer ;
      AtLeast      : integer ;
      Weight       : integer ;
      PercentCov   : real := 0.0
    ) is
    begin
      NumBins := NumBins + 1 ;
      CovBinPtr.all(NumBins).BinVal      := new RangeArrayType'(BinVal) ;
      CovBinPtr.all(NumBins).Action      := Action ;
      CovBinPtr.all(NumBins).Count       := Count ;
      CovBinPtr.all(NumBins).AtLeast     := AtLeast ;
      CovBinPtr.all(NumBins).Weight      := Weight ;
      CovBinPtr.all(NumBins).PercentCov  := PercentCov ;
      CovBinPtr.all(NumBins).OrderCount  := 0 ;  --- Temp
    end procedure NewBin ;


    ------------------------------------------------------------
    procedure AddBins (
    ------------------------------------------------------------
      AtLeast : integer ;
      Weight  : integer ;
      CovBin : CovBinType
    ) is
      variable calcAtLeast : integer ; 
      variable calcWeight  : integer ; 
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
      if CovBin(i).Action = COV_COUNT then
        calcAtLeast := maximum(AtLeast, CovBin(i).AtLeast) ; 
        calcWeight  := maximum(Weight, CovBin(i).Weight) ;
      else
        calcAtLeast := 0 ; 
        calcWeight  := 0 ;
      end if ; 
        NewBin(
          BinVal   => CovBin(i).BinVal,
          Action   => CovBin(i).Action,
          Count    => CovBin(i).Count,
          AtLeast  => calcAtLeast,
          Weight   => calcWeight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (AtLeast : integer ; CovBin : CovBinType) is
    ------------------------------------------------------------
    begin
      AddBins(AtLeast, 0, CovBin) ;
    end procedure AddBins ;


     ------------------------------------------------------------
    procedure AddBins (CovBin : CovBinType) is
    ------------------------------------------------------------
    begin
      AddBins(0, 0, CovBin) ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddCross(
    -- Cross existing bins
    ------------------------------------------------------------
      AtLeast : integer ;
      Weight  : integer ;
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) is
      constant BIN_LENS : integer_vector :=
          BinLengths(
             Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
             Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20
           ) ;
      constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
      variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
      variable CrossBins    : CovBinType(BinIndex'range) ;
      variable calcAction, calcCount, calcAtLeast, calcWeight : integer ;
      variable calcBinVal   : RangeArrayType(BinIndex'range) ;
    begin
      GrowBins(NUM_NEW_BINS) ;
      calcCount := 0 ;
      for MatrixIndex in 1 to NUM_NEW_BINS loop
        CrossBins := ConcatenateBins(BinIndex,
             Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
             Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20
           ) ;
        calcAction   := MergeState(CrossBins) ;
        calcBinVal   := MergeBinVal(CrossBins) ;
        calcAtLeast  := MergeAtLeast( calcAction, AtLeast, CrossBins) ;
        calcWeight   := MergeWeight ( calcAction, Weight,  CrossBins) ;
        NewBin(calcBinVal, calcAction, calcCount, calcAtLeast, calcWeight) ;
        IncBinIndex( BinIndex, BIN_LENS) ; -- increment right most one, then if overflow, increment next
      end loop ;
    end procedure AddCross ;


    ------------------------------------------------------------
    procedure AddCross(
    -- Cross existing bins
    ------------------------------------------------------------
      AtLeast : integer ;
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) is
    begin
      AddCross(AtLeast, 0,
           Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
           Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20
        ) ;
    end procedure AddCross ;


    ------------------------------------------------------------
    procedure AddCross(
    -- Cross existing bins
    ------------------------------------------------------------
      Bin1, Bin2 : CovBinType ;
      Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11, Bin12, Bin13,
      Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20 : CovBinType := NULL_BIN
    ) is
    begin
      AddCross(0, 0,
           Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9, Bin10, Bin11,
           Bin12, Bin13, Bin14, Bin15, Bin16, Bin17, Bin18, Bin19, Bin20
        ) ;
    end procedure AddCross ;


    ------------------------------------------------------------
    procedure Deallocate is
    ------------------------------------------------------------
    begin
      for i in 1 to NumBins loop
        deallocate(CovBinPtr(i).BinVal) ;
      end loop ;
      deallocate(CovBinPtr) ;
      NumBins := 0 ;
    end procedure deallocate ;


    ------------------------------------------------------------
    procedure ICover( CovPoint : integer_vector) is
    ------------------------------------------------------------
    begin
      CovLoop : for i in 1 to NumBins loop
        -- skip this CovBin if CovPoint is not in it
        next CovLoop when not inside(CovPoint, CovBinPtr(i).BinVal.all) ;

        -- found CovPoint in this CovBin, run this code and exit.
        CovBinPtr(i).Count := CovBinPtr(i).Count + CovBinPtr(i).action ;

        -- place holder for actions to do to weight vector
        CovBinPtr(i).PercentCov := real(CovBinPtr(i).Count)*100.0/maximum(real(CovBinPtr(i).AtLeast), 1.0) ;
        if CovBinPtr(i).PercentCov >= DonePercent then   -- OrderCount
          OrderCount := OrderCount + 1 ; 
          CovBinPtr(i).OrderCount := OrderCount ;
        end if ;  -- OrderCount

        if CovBinPtr(i).action = COV_ILLEGAL and IllegalMode = ILLEGAL_ON then
          write(OUTPUT, "%%Illegal Value: " ) ;
          write(OUTPUT, CovPoint) ;
          write(OUTPUT, " is in an illegal Bin. " & "Time: " & time'image(now) & LF) ;
        end if ;
        exit CovLoop when CountMode = COUNT_FIRST ;   -- only find first one
      end loop CovLoop ;
    end procedure ICover ;


    ------------------------------------------------------------
    procedure ICover ( CovPoint : integer) is
    ------------------------------------------------------------
    begin
     ICover((1=> CovPoint)) ;
    end procedure ICover ;


    ------------------------------------------------------------
    procedure SetCovZero is
    ------------------------------------------------------------
    begin
      for i in 1 to NumBins loop
        CovBinPtr(i).Count := 0 ;
        CovBinPtr(i).PercentCov := 0.0 ;
        CovBinPtr(i).OrderCount := 0 ;
        OrderCount := 0 ; 
      end loop ;
    end procedure SetCovZero ;


    ------------------------------------------------------------
    impure function GetMinCov return real is
    ------------------------------------------------------------
      variable MinCov : real := real'right ;  -- big number
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov < MinCov then
          MinCov := CovBinPtr(i).PercentCov ;
        end if ;
      end loop CovLoop ;
      return MinCov ;
    end function GetMinCov ;


    ------------------------------------------------------------
    impure function GetMinCov return integer is
    ------------------------------------------------------------
      variable MinCov : integer := integer'right ; -- big number
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count < MinCov then
          MinCov := CovBinPtr(i).Count ;
        end if ;
      end loop CovLoop ;
      return MinCov ;
    end function GetMinCov ;


    ------------------------------------------------------------
    impure function GetMaxCov return real is
    ------------------------------------------------------------
      variable MaxCov : real := 0.0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov > MaxCov then
          MaxCov := CovBinPtr(i).PercentCov ;
        end if ;
      end loop CovLoop ;
      return MaxCov ;
    end function GetMaxCov ;


    ------------------------------------------------------------
    impure function GetMaxCov return integer is
    ------------------------------------------------------------
      variable MaxCov : integer := 0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count > MaxCov then
          MaxCov := CovBinPtr(i).Count ;
        end if ;
      end loop CovLoop ;
      return MaxCov ;
    end function GetMaxCov ;


    ------------------------------------------------------------
    impure function CountCovHoles ( PercentCov : real := 100.0 ) return integer is
    ------------------------------------------------------------
      variable HoleCount : integer := 0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov < PercentCov then
          HoleCount := HoleCount + 1 ;
        end if ;
      end loop CovLoop ;
      return HoleCount ;
    end function CountCovHoles ;


    ------------------------------------------------------------
    impure function IsCovered ( PercentCov : real := 100.0 ) return boolean is
    ------------------------------------------------------------
    begin
      DonePercent := PercentCov ; 
      return CountCovHoles(PercentCov) = 0 ;
    end function IsCovered ;


    ------------------------------------------------------------
    impure function CountCovHoles ( AtLeast : integer ) return integer is
    ------------------------------------------------------------
      variable HoleCount : integer := 0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count < maximum(AtLeast, CovBinPtr(i).AtLeast) then
          HoleCount := HoleCount + 1 ;
        end if ;
      end loop CovLoop ;
      return HoleCount ;
    end function CountCovHoles ;
    
   
    ------------------------------------------------------------
    impure function IsCovered ( AtLeast : integer ) return boolean is
    ------------------------------------------------------------
    begin
      return CountCovHoles(AtLeast) = 0 ;
    end function IsCovered ;


    ------------------------------------------------------------
    impure function GetCovHole ( ReqHoleNum : integer := 1 ; PercentCov : real := 100.0 ) return RangeArrayType is
    ------------------------------------------------------------
      variable HoleCount : integer := 0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov < PercentCov then
          HoleCount := HoleCount + 1 ;
          if HoleCount = ReqHoleNum  then
           return CovBinPtr(i).BinVal.all ;
          end if ;
        end if ;
      end loop CovLoop ;
      write(OUTPUT, "%%Error GetCovHole did not find hole.  " &
                     "HoleCount = " & integer'image(HoleCount) &
                     "ReqHoleNum = " & integer'image(ReqHoleNum) & LF) ;
      return CovBinPtr(NumBins).BinVal.all ;
    end function GetCovHole ;


    ------------------------------------------------------------
    impure function GetCovHole ( ReqHoleNum : integer := 1 ; AtLeast : integer ) return RangeArrayType is
    ------------------------------------------------------------
      variable HoleCount : integer := 0 ;
    begin
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count < maximum(AtLeast, CovBinPtr(i).AtLeast) then
          HoleCount := HoleCount + 1 ;
          if HoleCount = ReqHoleNum  then
           return CovBinPtr(i).BinVal.all ;
          end if ;
        end if ;
      end loop CovLoop ;
      write(OUTPUT, "%%Error GetCovHole did not find hole.  " &
                     "HoleCount = " & integer'image(HoleCount) &
                     "ReqHoleNum = " & integer'image(ReqHoleNum) & LF) ;
      return CovBinPtr(NumBins).BinVal.all ;
    end function GetCovHole ;


    ------------------------------------------------------------
    impure function CalcWeight ( BinIndex : integer ; Scale : real  ) return integer is
    -- local
    ------------------------------------------------------------
    begin
      case WeightMode is
        when AT_LEAST =>        
          return CovBinPtr(BinIndex).AtLeast ;
          
        when WEIGHT =>
          return CovBinPtr(BinIndex).Weight ;
          
        when REMAIN =>   
          -- return CovBinPtr(BinIndex).AtLeast - 
          --       integer(floor(real(CovBinPtr(BinIndex).Count)/Scale)) ;
        
          return integer( Ceil( Scale * real(CovBinPtr(BinIndex).AtLeast))) - 
                          CovBinPtr(BinIndex).Count ;
          
        when REMAIN_AT_LEAST =>          
          -- return integer(1000.0 * (WeightScale * real(CovBinPtr(BinIndex).AtLeast) - 
          --                          real(CovBinPtr(BinIndex).Count)/Scale ) ) ;
          return integer( Ceil( WeightScale * Scale * real(CovBinPtr(BinIndex).AtLeast))) - 
                          CovBinPtr(BinIndex).Count ;
          
        when REMAIN_WEIGHT =>   
          -- return integer(1000.0 * (WeightScale * real(CovBinPtr(BinIndex).Weight + CovBinPtr(BinIndex).AtLeast) / 2.0 - 
          --                          real(CovBinPtr(BinIndex).Count)/Scale ) ) ;
          return integer( Ceil( WeightScale * Scale * real(CovBinPtr(BinIndex).Weight + CovBinPtr(BinIndex).AtLeast) / 2.0)) - 
                         CovBinPtr(BinIndex).Count ;
      end case ; 
    end function CalcWeight ;


    ------------------------------------------------------------
    impure function RandHoleIndex ( PercentCov : real ) return integer is
    -- local
    ------------------------------------------------------------
      variable WeightVec : integer_vector(1 to NumBins) ;
      variable intPercentCov : real ;
      variable MinCov : real ;
    begin
      MinCov := GetMinCov ;
      if PercentCov > MinCov then
        intPercentCov := PercentCov ;  -- Valid
      else
        intPercentCov := MinCov + CovThresholdPercent ;
        if MinCov < 100.0 then  -- threshold at 100.0
          intPercentCov := minimum(100.0, intPercentCov) ;
        end if ;
      end if ;
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov < intPercentCov then
          WeightVec(i) := CalcWeight(i, intPercentCov/100.0) ; -- CovBinPtr(i).Weight ;
        else
          WeightVec(i) := 0 ;
        end if ;
      end loop CovLoop ;
      -- DistInt returns integer range 0 to Numbins-1
      return 1 + RV.DistInt( WeightVec )  ; -- return range 1 to NumBins
    end function RandHoleIndex ;


    ------------------------------------------------------------
    impure function RandCovHole ( PercentCov : real := 100.0 ) return RangeArrayType is
    ------------------------------------------------------------
    begin
      return CovBinPtr( RandHoleIndex(PercentCov) ).BinVal.all ;  -- GetBinVal
    end function RandCovHole ;


    ------------------------------------------------------------
    impure function RandCovPoint( BinVal : RangeArrayType ) return integer_vector is
    -- Local
    ------------------------------------------------------------
      variable CovPoint : integer_vector(BinVal'range) ;
      variable normCovPoint : integer_vector(1 to BinVal'length) ;
    begin
      for i in BinVal'range loop
        CovPoint(i) := RV.RandInt(BinVal(i).min, BinVal(i).max) ;
      end loop ;
      normCovPoint := CovPoint ;
      return normCovPoint ;
    end function RandCovPoint ;


    ------------------------------------------------------------
    impure function RandCovPoint ( PercentCov : real := 100.0 ) return integer_vector is
    ------------------------------------------------------------
    begin
      return RandCovPoint(RandCovHole(PercentCov)) ;
    end function RandCovPoint ;


    -- ------------------------------------------------------------
    -- impure function RandCovPoint ( PercentCov : real ) return integer is
    -- Ambiguous?
    -- ------------------------------------------------------------
      -- variable BinVal : RangeArrayType(1 to 1) ;
    -- begin
      -- BinVal := RandCovHole(PercentCov) ;
      -- return RV.RandInt(BinVal(1).min, BinVal(1).max) ;
    -- end function RandCovPoint ;


    ------------------------------------------------------------
    impure function RandHoleIndex ( AtLeast : integer ) return integer is
    -- local
    ------------------------------------------------------------
      variable WeightVec : integer_vector(1 to NumBins) ;
      variable intAtLeast, curAtLeast : integer ;
    begin
      if AtLeast > GetMinCov then
        intAtLeast := AtLeast ;  -- Valid
      else
        write(OUTPUT, "RandHoleIndex: AtLeast = " & integer'image(AtLeast) & " already achieved" &  LF) ;
        intAtLeast := integer'right ;  -- Get All
        -- intAtLeast := GetMaxCov + 1 ;  -- Get All
      end if ;
      CovLoop : for i in 1 to NumBins loop
        curAtLeast := maximum(intAtLeast, CovBinPtr(i).AtLeast) ; 
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count < curAtLeast then
          WeightVec(i) := CalcWeight(i, real(curAtLeast) / real(CovBinPtr(i).AtLeast) ) ; -- CovBinPtr(i).Weight ;
        else
          WeightVec(i) := 0 ;
        end if ;
      end loop CovLoop ;
      -- DistInt returns integer range 0 to Numbins-1
      return 1 + RV.DistInt( WeightVec )  ; -- return range 1 to NumBins
    end function RandHoleIndex ;


    ------------------------------------------------------------
    impure function RandCovHole (AtLeast : integer ) return RangeArrayType is
    ------------------------------------------------------------
      variable Index : integer ;
    begin
      return CovBinPtr( RandHoleIndex(AtLeast) ).BinVal.all ;  -- GetBinVal
    end function RandCovHole ;


    ------------------------------------------------------------
    impure function RandCovPoint (AtLeast : integer ) return integer_vector is
    ------------------------------------------------------------
    begin
      return RandCovPoint(RandCovHole(AtLeast)) ;
    end function RandCovPoint ;
    

    -- ------------------------------------------------------------
    -- impure function RandCovPoint (AtLeast : integer ) return integer is
    -- Ambiguous?
    -- ------------------------------------------------------------
      -- variable BinVal : RangeArrayType(1 to 1) ;
    -- begin
      -- BinVal := RandCovHole(AtLeast) ;
      -- return RV.RandInt(BinVal(1).min, BinVal(1).max) ;
    -- end function RandCovPoint ;

    
    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovBinBaseType is
    -- ------------------------------------------------------------
      variable result : CovBinBaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix2BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix2BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix3BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix3BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix4BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix4BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix5BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix5BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix6BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix6BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix7BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix7BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix8BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix8BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    -- ------------------------------------------------------------
    impure function GetBin ( Num : integer ) return CovMatrix9BaseType is
    -- ------------------------------------------------------------
      variable result : CovMatrix9BaseType ;
    begin
      result.BinVal  := CovBinPtr(Num).BinVal.all;
      result.Action  := CovBinPtr(Num).Action; 
      result.Count   := CovBinPtr(Num).Count;  
      result.AtLeast := CovBinPtr(Num).AtLeast;
      result.Weight  := CovBinPtr(Num).Weight;
      return result ;
    end function GetBin ;


    ------------------------------------------------------------
    -- local for now -- file formal parameter not allowed with method
    procedure WriteBinName ( file f : text ; S : string ) is
    ------------------------------------------------------------
    begin
      if Name /= NULL then
        write(f, "%%" & S & Name.all & LF);
      else
        write(f, "%%" & S & LF);
      end if ;
      if ItemName /= NULL then
        write(f, "%%" & ItemName.all & LF);
      end if ;
    end procedure WriteBinName ;


    ------------------------------------------------------------
    -- local for now -- file formal parameter not allowed with method
    procedure WriteBin ( file f : text ) is
    ------------------------------------------------------------
      variable PrintItemName : boolean := FALSE ;
    begin
      WriteBinName(f, "WriteBin: ") ;
      for i in 1 to NumBins loop      -- CovBinPtr.all'range
        if CovBinPtr(i).count < 0 then
          write(f, "%%Illegal Bin:") ;
          write(f, CovBinPtr(i).BinVal.all) ;
          write(f, "  Count = " & integer'image(-CovBinPtr(i).count)) ;
          write(f, "" & LF) ;
        elsif CovBinPtr(i).action = COV_COUNT then
          write(f, "%% Bin:") ;
          write(f, CovBinPtr(i).BinVal.all) ;
          write(f, "  Count = " & integer'image(CovBinPtr(i).count)) ;
          write(f, "  AtLeast = " & integer'image(CovBinPtr(i).AtLeast)) ;
          write(f, "  Weight = " & integer'image(CovBinPtr(i).Weight)) ;
          write(f, "" & LF) ;
        end if ;
      end loop ;
      write(f, "" & LF) ;
    end procedure WriteBin ;


    ------------------------------------------------------------
    procedure WriteBin is
    ------------------------------------------------------------
    begin
      WriteBin(OUTPUT) ;
    end procedure WriteBin ;


    ------------------------------------------------------------
    procedure WriteBin (FileName : string; OpenKind : File_Open_Kind := APPEND_MODE ) is
    ------------------------------------------------------------
      file BinFile : text open OpenKind is FileName ;
    begin
      WriteBin(BinFile) ;
    end procedure WriteBin ;
    

    ------------------------------------------------------------
    -- Development only
    procedure DumpBin is
    ------------------------------------------------------------
    begin
      WriteBinName(OUTPUT, "WriteBin: ") ;
      for i in 1 to NumBins loop      -- CovBinPtr.all'range
        write(OUTPUT, "%% Bin:") ;
        write(OUTPUT, CovBinPtr(i).BinVal.all) ;
        write(OUTPUT, "  Action = " & integer'image(CovBinPtr(i).action)) ;
        write(OUTPUT, "  Count = " & integer'image(CovBinPtr(i).count)) ;
        write(OUTPUT, "  AtLeast = " & integer'image(CovBinPtr(i).AtLeast)) ;
        write(OUTPUT, "  Weight = " & integer'image(CovBinPtr(i).Weight)) ;
        write(OUTPUT, "  OrderCount = " & integer'image(CovBinPtr(i).OrderCount)) ;
        write(OUTPUT, "" & LF) ;
      end loop ;
      write(OUTPUT, "" & LF) ;
    end procedure DumpBin ;


    ------------------------------------------------------------
    procedure WriteOrderCount is
    ------------------------------------------------------------
    begin
      WriteBinName(OUTPUT, "WriteOrderCount: ") ;
      for CurOrderCount in 1 to OrderCount loop      -- CovBinPtr.all'range
        for i in 1 to NumBins loop 
          if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).OrderCount = CurOrderCount then
            write(OUTPUT, "%% Bin:") ;
            write(OUTPUT, CovBinPtr(i).BinVal.all) ;
            write(OUTPUT, "  Count = " & integer'image(CovBinPtr(i).count)) ;
            write(OUTPUT, "  AtLeast = " & integer'image(CovBinPtr(i).AtLeast)) ;
            write(OUTPUT, "  Weight = " & integer'image(CovBinPtr(i).Weight)) ;
            write(OUTPUT, "  OrderCount = " & integer'image(CovBinPtr(i).OrderCount)) ;
            write(OUTPUT, "" & LF) ;
          end if ;
        end loop ;
      end loop ;
      write(OUTPUT, "" & LF) ;
    end procedure WriteOrderCount ;


    ------------------------------------------------------------
    -- Local
    procedure WriteCovHoles ( file f : text;  PercentCov : real := 100.0 ) is
    ------------------------------------------------------------
    begin
      WriteBinName(f, "WriteCovHoles: ") ;
      CovLoop : for i in 1 to NumBins loop
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).PercentCov < PercentCov then
          write(f, "%% Bin:") ;
          write(f, CovBinPtr(i).BinVal.all) ;
          write(f, "  Count = " & integer'image(CovBinPtr(i).Count)) ;
          write(f, "  AtLeast = " & integer'image(CovBinPtr(i).AtLeast)) ;
          write(f, "  Weight = " & integer'image(CovBinPtr(i).Weight)) ;
          write(f, "" & LF) ;
        end if ;
      end loop CovLoop ;
      write(f, "" & LF) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    procedure WriteCovHoles ( PercentCov : real := 100.0 ) is
    ------------------------------------------------------------
    begin
      WriteCovHoles(Output, PercentCov) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    procedure WriteCovHoles ( FileName : string;  PercentCov : real := 100.0 ; OpenKind : File_Open_Kind := APPEND_MODE ) is
    ------------------------------------------------------------
      file CovHoleFile : text open OpenKind is FileName ;
    begin
      WriteCovHoles(CovHoleFile, PercentCov) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    -- Local
    procedure WriteCovHoles ( file f : text;  AtLeast : integer ) is
    ------------------------------------------------------------
      variable maxAtLeast : integer ;
    begin
      WriteBinName(f, "WriteCovHoles: ") ;
      CovLoop : for i in 1 to NumBins loop
        maxAtLeast := maximum(AtLeast,CovBinPtr(i).AtLeast) ;
        if CovBinPtr(i).action = COV_COUNT and CovBinPtr(i).Count < maxAtLeast then
          write(f, "%% Bin:") ;
          write(f, CovBinPtr(i).BinVal.all) ;
          write(f, "  Count = " & integer'image(CovBinPtr(i).Count)) ;
          write(f, "  AtLeast = " & integer'image(CovBinPtr(i).AtLeast)) ;
          write(f, "  Weight = " & integer'image(CovBinPtr(i).Weight)) ;
          write(f, "" & LF) ;
        end if ;
      end loop CovLoop ;
      write(f, "" & LF) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    procedure WriteCovHoles ( AtLeast : integer ) is
    ------------------------------------------------------------
    begin
      WriteCovHoles(Output, AtLeast) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    procedure WriteCovHoles ( FileName : string;  AtLeast : integer ; OpenKind : File_Open_Kind := APPEND_MODE ) is
    ------------------------------------------------------------
      file CovHoleFile : text open OpenKind is FileName ;
    begin
      WriteCovHoles(CovHoleFile, AtLeast) ;
    end procedure WriteCovHoles ;


    ------------------------------------------------------------
    -- local
    impure function FindBin (
    ------------------------------------------------------------
	    BinVal  : RangeArrayType ;
      Action  : integer
    ) return integer is
    begin
      for i in 1 to NumBins loop
        if BinVal = CovBinPtr(i).BinVal.all and Action = CovBinPtr(i).Action then
          return i ;
        end if;
      end loop ;
      return 0 ;
    end function FindBin ;


    ------------------------------------------------------------
    -- local
    procedure ReadCovDb (
    ------------------------------------------------------------
      File     CovDbFile     :     text ;
      constant NumRangeItems : in  integer ;
      constant NumLines      : in  integer
    )  is
      variable buf         : line ;
      variable Empty       : boolean ;
      variable ReadValid   : boolean ;
      -- Format:  Action Count min1 max1 min2 max2 ....
      variable Action      : integer ;
      variable Count       : integer ;
      variable BinVal      : RangeArrayType(1 to NumRangeItems) ;
      variable index       : integer ;
      variable AtLeast     : integer ;
      variable Weight      : integer ;
      variable PercentCov  : real ;
    begin
      GrowBins(NumLines) ;
      ReadLoop : for i in 1 to NumLines loop
        exit ReadLoop when failed(EndFile(CovDbFile), "ReadCovDb:  Did not read specified number of lines") ;
        ReadLine(CovDbFile, buf) ;
        EmptyOrCommentLine(buf, Empty) ;
        next when Empty ;  -- replace with EmptyLine(buf)

        read(buf, Action, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading Action") ;
        read(buf, Count, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading Count") ;
        read(buf, AtLeast, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading AtLeast") ;
        read(buf, Weight, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading Weight") ;
        read(buf, PercentCov, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading PercentCov") ;
        read(buf, BinVal, ReadValid) ;
        exit ReadLoop when failed(not ReadValid, "ReadCovDb: Failed while reading BinVal") ;

        index := FindBin(BinVal, Action) ;
        if index > 0 then  -- found it.
-- Should count add to current count?
          CovBinPtr(index).Count := Count ;
        else
          NewBin(BinVal, Action, Count, AtLeast, Weight, PercentCov) ;
        end if ;
      end loop ReadLoop ;
    end ReadCovDb ;


    ------------------------------------------------------------
    procedure ReadCovDb (FileName : string) is
    ------------------------------------------------------------
      -- Format:  Action Count min1 max1 min2 max2
      file CovDbFile         : text open READ_MODE is FileName ;
      variable NumRangeItems : integer ;
      variable NumLines      : integer ;
    begin
      -- Get Coverage dimensions and number of items in file.
      GetCovDbInfo(CovDbFile, NumRangeItems, NumLines) ;

      -- Read the file
      ReadCovDb(CovDbFile, NumRangeItems, NumLines) ;
    end ReadCovDb ;


    -- Not allowed in a protected type
    ------------------------------------------------------------
    -- procedure ReadCovDb ( File CovDbFile : text ) is
    ------------------------------------------------------------
      -- variable NumRangeItems : integer ;
      -- variable NumLines      : integer ;
    -- begin
      -- -- Get Coverage dimensions and number of items in file.
      -- GetCovDbInfo(CovDbFile, NumRangeItems, NumLines) ;
      -- -- Read the file
      -- ReadCovDb(CovDbFile, NumRangeItems, NumLines) ;
    -- end ReadCovDb ;


    ------------------------------------------------------------
    -- Local
    procedure WriteCovDb (file CovDbFile : text ) is
    ------------------------------------------------------------
      -- Format:  Action Count min1 max1 min2 max2
      variable buf       : line ;
    begin
      -- write NumRangeItems, NumLines
      write(buf, CovBinPtr(1).BinVal'length) ;
      write(buf, ' ') ;
      write(buf, NumBins) ;
      write(buf, ' ') ;
      writeline(CovDbFile, buf) ;
      -- write coverage to a file
      writeloop : for LineCount in 1 to NumBins loop
        write(buf, CovBinPtr(LineCount).Action) ;
        write(buf, ' ') ;
        write(buf, CovBinPtr(LineCount).Count) ;
        write(buf, ' ') ;
        write(buf, CovBinPtr(LineCount).AtLeast) ;
        write(buf, ' ') ;
        write(buf, CovBinPtr(LineCount).Weight) ;
        write(buf, ' ') ;
        write(buf, CovBinPtr(LineCount).PercentCov) ;
        write(buf, ' ') ;
        write(buf, CovBinPtr(LineCount).BinVal.all) ;
        writeline(CovDbFile, buf) ;
      end loop WriteLoop ;
    end procedure WriteCovDb ;


    ------------------------------------------------------------
    procedure WriteCovDb (FileName : string; OpenKind : File_Open_Kind := APPEND_MODE ) is
    ------------------------------------------------------------
      -- Format:  Action Count min1 max1 min2 max2
      file CovDbFile : text open OpenKind is FileName ;
    begin
      WriteCovDb(CovDbFile) ;
    end procedure WriteCovDb ;


    ------------------------------------------------------------
    impure function CovBinErrCnt return integer is
    ------------------------------------------------------------
      variable ErrorCnt : integer := 0 ;
    begin
      for i in 1 to NumBins loop
        if CovBinPtr(i).count < 0 then -- illegal CovBin
          ErrorCnt := ErrorCnt + CovBinPtr(i).count ;
        end if ;
      end loop ;
      return - ErrorCnt ;
    end function CovBinErrCnt ;


    ------------------------------------------------------------
    -- These support the older AddBins(GenCross(...)) methodology
    -- which has been replaced by AddCross
    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix2Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix3Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix4Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix5Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix6Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix7Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix8Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


    ------------------------------------------------------------
    procedure AddBins (CovBin : CovMatrix9Type) is
    ------------------------------------------------------------
    begin
      GrowBins(CovBin'length) ;
      for i in CovBin'range loop
        NewBin(
          CovBin(i).BinVal, CovBin(i).Action, CovBin(i).Count,
          CovBin(i).AtLeast, CovBin(i).Weight
        ) ;
      end loop ;
    end procedure AddBins ;


  end protected body CovPType ;

  ------------------------------------------------------------------------------------------
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  --  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CovPType  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ------------------------------------------------------------------------------------------


  ------------------------------------------------------------
  -- Local, Used by GenBin, IllegalBin, and IgnoreBin
  function MakeBin(
  ------------------------------------------------------------
    Min, Max      : integer ;
    NumBin        : integer ;
    AtLeast       : integer ;
    Weight        : integer ;
    Action        : integer
  ) return CovBinType is
    constant CALC_NUM_BINS : integer := minimum(NumBin, Max-Min+1) ;
    variable iCovBin : CovBinType(0 to CALC_NUM_BINS -1) ;
    variable CurMin, NextMin, RemainingBins, NumItemsInBin : integer ;
  begin
    CurMin := Min ;
    for i in iCovBin'range loop
      RemainingBins := CALC_NUM_BINS - i ;
      NumItemsInBin := (Max - CurMin + 1) / RemainingBins ;
      NextMin := CurMin + NumItemsInBin ;
      iCovBin(i) := (
        BinVal => (1 => (CurMin, NextMin - 1)),
        Action => Action,
        Count => 0,
        Weight => Weight,
        AtLeast => AtLeast
      ) ;
      CurMin := NextMin ;
    end loop ;
    return iCovBin ;
  end function MakeBin ;

  ------------------------------------------------------------
  function GenBin(
  ------------------------------------------------------------
    AtLeast       : integer ;
    Weight        : integer ;
    Min, Max      : integer ;
    NumBin        : integer 
  ) return CovBinType is
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => AtLeast,
              Weight   => Weight,
              Action   => COV_COUNT
            ) ;
  end function GenBin ;

  
  ------------------------------------------------------------
  function GenBin(AtLeast : integer ;  Min, Max, NumBin : integer ) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => AtLeast,
              Weight   => 1,
              Action   => COV_COUNT
            ) ;
  end function GenBin ;


  ------------------------------------------------------------
  function GenBin( Min, Max, NumBin : integer ) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => 1,
              Weight   => 1,
              Action   => COV_COUNT
            ) ;
  end function GenBin ;


  ------------------------------------------------------------
  function GenBin ( Min, Max : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    -- default, create a separate CovBin for each value
    -- AtLeast and Weight = 1 (must use longer version to specify)
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => Max - Min + 1,
              AtLeast  => 1,
              Weight   => 1,
              Action   => COV_COUNT
            ) ;
  end function GenBin ;


  ------------------------------------------------------------
  function GenBin ( A : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    -- default, create a separate CovBin for each value
    -- AtLeast and Weight = 1 (must use longer version to specify)
    return  MakeBin(
              Min      => A,
              Max      => A,
              NumBin   => 1,
              AtLeast  => 1,
              Weight   => 1,
              Action   => COV_COUNT
            ) ;
  end function GenBin ;


  ------------------------------------------------------------
  function IllegalBin ( Min, Max, NumBin : integer ) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_ILLEGAL
            ) ;
  end function IllegalBin ;

  ------------------------------------------------------------
  function IllegalBin ( Min, Max : integer ) return CovBinType is
  ------------------------------------------------------------
  begin
    -- default, generate one CovBin with the entire range of values
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => 1,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_ILLEGAL
            ) ;
  end function IllegalBin ;


  ------------------------------------------------------------
  function IllegalBin ( A : integer ) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => A,
              Max      => A,
              NumBin   => 1,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_ILLEGAL
            ) ;
  end function IllegalBin ;


  ------------------------------------------------------------
  function IgnoreBin (
  ------------------------------------------------------------
    AtLeast       : integer ;
    Weight        : integer ;
    Min, Max      : integer ;
    NumBin        : integer 
  ) return CovBinType is
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => AtLeast,
              Weight   => Weight,
              Action   => COV_IGNORE
            ) ;
  end function IgnoreBin ;


  ------------------------------------------------------------
  function IgnoreBin (AtLeast : integer ;  Min, Max, NumBin : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => AtLeast,
              Weight   => 0,
              Action   => COV_IGNORE
            ) ;
  end function IgnoreBin ;


  ------------------------------------------------------------
  function IgnoreBin (Min, Max, NumBin : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => NumBin,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_IGNORE
            ) ;
  end function IgnoreBin ;


  ------------------------------------------------------------
  function IgnoreBin (Min, Max : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    -- default, generate one CovBin with the entire range of values
    return  MakeBin(
              Min      => Min,
              Max      => Max,
              NumBin   => 1,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_IGNORE
            ) ;
  end function IgnoreBin ;


  ------------------------------------------------------------
  function IgnoreBin (A : integer) return CovBinType is
  ------------------------------------------------------------
  begin
    return  MakeBin(
              Min      => A,
              Max      => A,
              NumBin   => 1,
              AtLeast  => 0,
              Weight   => 0,
              Action   => COV_IGNORE
            ) ;
  end function IgnoreBin ;


  ------------------------------------------------------------
  function GenBin (
  -- Manual entry format for CovBin within lots of extra parens
  ------------------------------------------------------------
    ManualBin    : CovBinManualType
  ) return CovBinType is
    alias    imBin    : CovBinManualType (1 to ManualBin'length) is ManualBin ;
    variable iCovBin : CovBinType(imBin'range) ;
  begin
    for i in iCovBin'range loop
      iCovBin(i) := ( (1 => (imBin(i)(0),imBin(i)(1))), imBin(i)(2), 0, 1, 1) ;
    end loop ;
    return iCovBin ;
  end function GenBin ;


  ------------------------------------------------------------
  function GenCross(  -- 2
  -- Cross existing bins  
  -- Use AddCross for adding values directly to coverage database
  -- Use GenCross for constants
  ------------------------------------------------------------
    AtLeast     : integer ;
    Weight      : integer ;
    Bin1, Bin2  : CovBinType
  ) return CovMatrix2Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix2Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(AtLeast : integer ; Bin1, Bin2 : CovBinType) return CovMatrix2Type is
  -- Cross existing bins  -- use AddCross instead
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(Bin1, Bin2 : CovBinType) return CovMatrix2Type is
  -- Cross existing bins  -- use AddCross instead
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 3
  ------------------------------------------------------------
    AtLeast           : integer ;
    Weight            : integer ;
    Bin1, Bin2, Bin3  : CovBinType
  ) return CovMatrix3Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix3Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3 : CovBinType ) return CovMatrix3Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3 : CovBinType ) return CovMatrix3Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 4
  ------------------------------------------------------------
    AtLeast                 : integer ;
    Weight                  : integer ;
    Bin1, Bin2, Bin3, Bin4  : CovBinType
  ) return CovMatrix4Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix4Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4 : CovBinType ) return CovMatrix4Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4 : CovBinType ) return CovMatrix4Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 5
  ------------------------------------------------------------
    AtLeast                       : integer ;
    Weight                        : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5  : CovBinType
  ) return CovMatrix5Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4, Bin5) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix5Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4, Bin5) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5 : CovBinType ) return CovMatrix5Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4, Bin5) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5 : CovBinType ) return CovMatrix5Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4, Bin5) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 6
  ------------------------------------------------------------
    AtLeast                             : integer ;
    Weight                              : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6  : CovBinType
  ) return CovMatrix6Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4, Bin5, Bin6) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix6Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;

  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6 : CovBinType ) return CovMatrix6Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6 : CovBinType ) return CovMatrix6Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 7
  ------------------------------------------------------------
    AtLeast                                   : integer ;
    Weight                                    : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7  : CovBinType
  ) return CovMatrix7Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix7Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7 : CovBinType ) return CovMatrix7Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7 : CovBinType ) return CovMatrix7Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 8
  ------------------------------------------------------------
    AtLeast                                         : integer ;
    Weight                                          : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8  : CovBinType
  ) return CovMatrix8Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix8Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8 : CovBinType ) return CovMatrix8Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8 : CovBinType ) return CovMatrix8Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross(  -- 9
  ------------------------------------------------------------
    AtLeast                                               : integer ;
    Weight                                                : integer ;
    Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9  : CovBinType
  ) return CovMatrix9Type is
    constant BIN_LENS : integer_vector := BinLengths(Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9) ;
    constant NUM_NEW_BINS : integer := CalcNumCrossBins(BIN_LENS) ;
    variable BinIndex     : integer_vector(1 to BIN_LENS'length) := (others => 1) ;
    variable CrossBins    : CovBinType(BinIndex'range) ;
    variable Action       : integer ;
    variable iCovMatrix   : CovMatrix9Type(1 to NUM_NEW_BINS) ;
  begin
    for MatrixIndex in iCovMatrix'range loop
      CrossBins := ConcatenateBins(BinIndex, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9) ;
      Action       := MergeState(CrossBins) ;
      iCovMatrix(MatrixIndex).action  := Action ;
      iCovMatrix(MatrixIndex).count   := 0 ;
      iCovMatrix(MatrixIndex).BinVal  := MergeBinVal(CrossBins) ;
      iCovMatrix(MatrixIndex).AtLeast := MergeAtLeast( Action, AtLeast, CrossBins) ;
      iCovMatrix(MatrixIndex).Weight  := MergeWeight ( Action, Weight,  CrossBins) ;
      IncBinIndex( BinIndex, BIN_LENS ) ; -- increment right most one, then if overflow, increment next
    end loop ;
    return iCovMatrix ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( AtLeast : integer ; Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9 : CovBinType ) return CovMatrix9Type is
  ------------------------------------------------------------
  begin
    return GenCross(AtLeast, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9) ;
  end function GenCross ;


  ------------------------------------------------------------
  function GenCross( Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9 : CovBinType ) return CovMatrix9Type is
  ------------------------------------------------------------
  begin
    return GenCross(0, 0, Bin1, Bin2, Bin3, Bin4, Bin5, Bin6, Bin7, Bin8, Bin9) ;
  end function GenCross ;


  ------------------------------------------------------------
  procedure increment( signal Count : inout integer ) is
  ------------------------------------------------------------
  begin
    Count <= Count + 1 ;
  end procedure increment ;


  ------------------------------------------------------------
  procedure increment( signal Count : inout integer ; enable : boolean ) is
  ------------------------------------------------------------
  begin
    if enable then
      Count <= Count + 1 ;
    end if ;
  end procedure increment ;


  ------------------------------------------------------------
  procedure increment( signal Count : inout integer ; enable : std_ulogic ) is
  ------------------------------------------------------------
  begin
    if to_x01(enable) = '1' then
      Count <= Count + 1 ;
    end if ;
  end procedure increment ;


  ------------------------------------------------------------
  function to_integer ( B : boolean ) return integer is
  ------------------------------------------------------------
  begin
    if B then
      return 1 ;
    else
      return 0 ;
    end if ;
  end function to_integer ;


  ------------------------------------------------------------
  function to_integer ( SL : std_logic ) return integer is
  -------------------------------------------------------------
  begin
    case SL is
      when '1' | 'H' =>  return 1 ;
      when '0' | 'L' =>  return 0 ;
      when others    =>  return -1 ;
    end case ;
  end function to_integer ;


  ------------------------------------------------------------
  function to_integer_vector ( BV : boolean_vector ) return integer_vector is
  ------------------------------------------------------------
    variable result : integer_vector(BV'range) ;
  begin
    for i in BV'range loop
      result(i) := to_integer(BV(i)) ;
    end loop ;
    return result ;
  end function to_integer_vector ;


  ------------------------------------------------------------
  function to_integer_vector ( SLV : std_logic_vector ) return integer_vector is
  -------------------------------------------------------------
    variable result : integer_vector(SLV'range) ;
  begin
    for i in SLV'range loop
      result(i) := to_integer(SLV(i)) ;
    end loop ;
    return result ;
  end function to_integer_vector ;


end package body CoveragePkg ;
