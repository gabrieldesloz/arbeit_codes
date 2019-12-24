-- ----------------------------------------------------------------------
-- >>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<>>>>>> Warrantee <<<<<<<<<<<<<<<
-- ----------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Title       : 
-- Project     : 
-- Library:    : 
-------------------------------------------------------------------------------
-- File name   : 
-- Author      : 
-- Company     : 
-- Last update : 
-- Platform    : 
-------------------------------------------------------------------------------
-- Purpose     : do file for test bench
-------------------------------------------------------------------------------
-- Assumptions : -
-- Limitations : -
-- Known Errors: -
-- Notes       : -
-------------------------------------------------------------------------------
-- Revisions   :
-- Date        Version  Author          Description
-- 2005/07/27  0.01     Hendrik Hanff	Created
-------------------------------------------------------------------------------

puts {
  ModelSim general compile script version 0.1
  by Hendrik Hanff, March 2006.
}

----------------------------------------------------------------------------------------------------------
-- set up the environment - where are the sources???
----------------------------------------------------------------------------------------------------------
--../design/Mailbox"
set workdir_tbench "."

-- important for Modelsim 6.0a SE as it sometimes crashes when all project files are comiled before 
-- simulation was ended.
quit -sim

----------------------------------------------------------------------------------------------------------
-- compile the sources - add sources as shown below
----------------------------------------------------------------------------------------------------------
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/InFifo.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/OutFifo.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/afifo_in.vhd
--vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/dpram_in.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/afifo_out.vhd
--vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/dpram_out.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/dpram.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/rptr_empty.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/sync_gray.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/wptr_full.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/conv_32_to_8.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/conv_8_to_32.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/Mailbox_Toplevel_SysCont.vhd
vcom -work work -2002 -explicit -nocasestaticerror ${workdir_vhdl}/Mailbox_Toplevel_10G.vhd
vcom -work work -2002 -explicit -nocasestaticerror C:/Projects/DiscPack/syscontrol/hw/hdl/test/DiscPack_syscontrol_Mailbox_Toplevel_tb.vhd	
					     
								     
-- -check synthesis option enables a check, if it is possible to use the VHDL code for synthesis later on.
--  VHDL files. Without this option it is first checked if the source code has changed since the
--  last compilation run and only if there was a modification in the source code it is recompiled.

-- -force_refresh option is used to force the compiler to recompile all specified

-- -work : The target library, into which the code should be compiled is specified with the parameter
-- -work <library_name>. The target library can be specified using the logical library name
-- or the Unix path to the library directory. If no target library is specified the library ’work’ is
-- used.

----------------------------------------------------------------------------------------------------------
-- start simulation
----------------------------------------------------------------------------------------------------------
vsim -t 1ps work.DiscPack_syscontrol_Toplevel_Mailbox_tb

----------------------------------------------------------------------------------------------------------
-- add all signals to list window
----------------------------------------------------------------------------------------------------------
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/fifol/rptr_empty_inst/*
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/fifoh/rptr_empty_inst/*
--do DiscPack_syscontrol_Mailbox_list.do
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/*
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_rw_strb
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_rw_strb_i
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_rw_strb_r
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_dir
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_dir_i
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/ctl_dir_r

--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_10g/inst_conv_8_to_32/*
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_outfifo/*
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/*

--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/ctl_rw_strb_r
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/ctl_rw_strb
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/ctl_dir
--add list sim:/discpack_syscontrol_toplevel_mailbox_tb/inst_toplevel_mailbox_syscont/inst_infifo/ctl_dir

-- set width of signal names inside the list windwo:
--configure list -signalnamewidth 1

----------------------------------------------------------------------------------------------------------
-- add signals to wave from the wave.do file
----------------------------------------------------------------------------------------------------------
do wave.do

---------------------------------------------------------------------
-- force signals
---------------------------------------------------------------------
--force -freeze sim:/diskpack_sdabuscontroler_toplevel/clk_80 1 0, 0 {50 ns} -r 100
--force -freeze sim:/diskpack_sdabuscontroler_toplevel/rst_80 0 0

--onerror {abort all}
---------------------------------------------------------------------
-- run
---------------------------------------------------------------------
run 3 us

--write report -l report.txt 
--coverage report -zeros -lines.

---------------------------------------------------------------------
-- configure wave
---------------------------------------------------------------------


