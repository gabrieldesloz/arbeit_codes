# DoQuartus.tcl
# ----------------------------------------------------
# Tornado Exercise 1
# Complete Tcl script File :
# Project creation, assignments, compilation, download
# ----------------------------------------------------
# (c) ALSE - http://www.alse-fr.com
#
# Can run this script from Quartus II Tcl console, or directly :
#  quartus_sh -t doquartus.tcl

set MyProj tornado

# ---- Load Quartus II Tcl Project package

package require ::quartus::project
package require ::quartus::flow

# ---- Introduction

set make_assignments 1
puts "\n====    Ex1 Script (c) ALSE ===="
puts   "     http://www.alse-fr.com\n"

# ---- Check that the right project is open
if {[is_project_open]} {
  if {[string compare -nocase $quartus(project) $MyProj]} {
    puts "Error : another project is already opened."
    puts "Please close this project and try again."
    exit
  } else {
    puts "The project $MyProj was already open..."
  }
} else {
  # Only open if not already open
  if {[project_exists $MyProj]} {
    project_open -cmp $MyProj $MyProj
  } else {
    project_new $MyProj
  }
}

# -- remove the old rbf file (if exists)
if [file exists ${MyProj}.rbf]  {
  file delete  ${MyProj}.rbf
  }

# ---- Project Assignments (VHDL source files, order is IMPORTANT)

  set_global_assignment -name VHDL_FILE "../src/fdiv.vhd"
  set_global_assignment -name VHDL_FILE "../src/servo.vhd"
  set_global_assignment -name VHDL_FILE "../src/tornado.vhd"

# ---- Compiler Assignments for top
  set_project_settings -cmp $MyProj
  set_global_assignment -name COMPILATION_LEVEL FULL
  set_global_assignment -name FAMILY CYCLONE
  set_global_assignment -name FOCUS_ENTITY_NAME $MyProj
  set_global_assignment -name DEVICE EP1C6T144C8

# ---- Pin assignments

# Note that EP1C3 has these extra pins available :
# 54, 55, 91, 94, 104, 126, 127, 130

  set_location_assignment -to Reset_n       Pin_10
  set_location_assignment -to Clk           Pin_16

  set_location_assignment -to SW1           Pin_42   ;# ex BP(0)
  set_location_assignment -to SW2           Pin_47   ;# ex BP(1)
  set_location_assignment -to SW3           Pin_48   ;# ex BP(2)

  set_location_assignment -to RCserv\[0\]   Pin_71
  set_location_assignment -to RCserv\[1\]   Pin_72
  set_location_assignment -to RCserv\[2\]   Pin_73
  set_location_assignment -to RCserv\[3\]   Pin_74

  set_location_assignment -to Cdisp\[0\]    Pin_49
  set_location_assignment -to Cdisp\[1\]    Pin_50
  set_location_assignment -to Cdisp\[2\]    Pin_51
  set_location_assignment -to Cdisp\[3\]    Pin_52

  set_location_assignment -to SevSeg\[0\]   Pin_122
  set_location_assignment -to SevSeg\[1\]   Pin_123
  set_location_assignment -to SevSeg\[2\]   Pin_124
  set_location_assignment -to SevSeg\[3\]   Pin_125
  set_location_assignment -to SevSeg\[4\]   Pin_128
  set_location_assignment -to SevSeg\[5\]   Pin_129
  set_location_assignment -to SevSeg\[6\]   Pin_130
  set_location_assignment -to SevSeg\[7\]   Pin_131


  set_location_assignment -to USB_D\[0\]    Pin_75
  set_location_assignment -to USB_D\[1\]    Pin_76
  set_location_assignment -to USB_D\[2\]    Pin_77
  set_location_assignment -to USB_D\[3\]    Pin_78
  set_location_assignment -to USB_D\[4\]    Pin_79
  set_location_assignment -to USB_D\[5\]    Pin_82
  set_location_assignment -to USB_D\[6\]    Pin_83
  set_location_assignment -to USB_D\[7\]    Pin_84

# Spare pins : 92, 93 (clock inputs)

  set_location_assignment -to USB_WR        Pin_85
  set_location_assignment -to USB_nRD       Pin_96
  set_location_assignment -to USB_nRxF      Pin_97
  set_location_assignment -to USB_nTxE      Pin_98

  set_location_assignment -to LED4          Pin_144

  # --- Weak Pull Ups !  (important...)
  set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SW3
  set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SW2
  set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SW1
  set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to Reset_n

  # this below to help nConfig staying up after USB programming :
  set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to "USB_D\[3\]"

  # Make sure unused pins are not grounded !
  set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"

  # -- Global Clock et Fmax
  set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to Clk
  set_global_assignment -name fmax_requirement 60MHz

  # -- Misc Compilation options
  set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION ON
  set_global_assignment -name CYCLONE_CONFIGURATION_DEVICE EPCS1
  set_global_assignment -name GENERATE_RBF_FILE ON

  # -- Run Design Assistant
  set_global_assignment -name ENABLE_DRC_SETTINGS ON

  #---- Commit assignments
  export_assignments
  puts "Assignments done, starting compilation..."

  #---- Compile using ::quartus::flow
  execute_flow -compile
  if [file exists ${MyProj}.rbf]  {
  #  (we have no way to verify automatically that no error occured -since v4.1-
    puts "\nCompilation apparently succeeded.\n"
    puts "Press Enter key when you are ready to download Tornado board..."
    gets stdin
    puts "Press SW5 and keep it down !"
    exec cmd.exe /c c:/Tornado/usb.exe ${MyProj}.rbf
    puts "Release SW5 now..."
    after 2000
    puts "End of script."
  } else {
    puts "\nCompilation failed !\nPlease analyze the error messages."
  }


