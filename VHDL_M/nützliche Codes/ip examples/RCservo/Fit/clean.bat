@echo off
echo.
echo  Cleaning Up Altera Result Files.
echo  Copyright ALSE www.alse-fr.com
echo  -------------------------------
echo.
echo  THIS WILL ERASE ALL THE RESULT FILES !
echo.
echo  Press Ctrl-Break to abort, any key to Clean up...
pause >nul

rem echo ModelSim specific files & work dir...
rem if exist transcript del transcript
rem if exist *.wav  del *.wav
rem if exist *.wlf  del *.wlf
rem del work /f /S /Q
rem rmdir work /S/Q

echo.
echo Generic Temp files...
rem if exist *.hex  del *.hex
if exist *.bak  del *.bak
if exist *.wbk  del *.wbk
if exist *.err  del *.err
if exist *.cnf  del *.cnf
if exist *.hif  del *.hif
if exist *.log  del *.log
if exist *.$$$  del *.$$$
if exist *.fit  del *.fit
if exist *.ndb  del *.ndb
if exist *.xdb  del *.xdb
if exist *.ndb  del *.ndb
if exist *.lmf  del *.lmf
if exist fitfstio.txt del fitfstio.txt
if exist *.vfd del *.vfd
if exist *.spl del *.spl
if exist *.vtd del *.vtd
if exist undo_redo.txt del undo_redo.txt

if exist *.pin  del *.pin
if exist *.ttf  del *.ttf
if exist *.vho  del *.vho
if exist *.sdo  del *.sdo
if exist *.wlf  del *.wlf
if exist *.snf  del *.snf
if exist *.mmf  del *.mmf
if exist *.rpt  del *.rpt
rem if exist *.sum  del *.sum
if exist *).mif del *).mif

if exist *.eqn del *.eqn
if exist *.summary del *.summary
if exist *.done del *.done
if exist *.*.htm del *.*.htm
if exist *.ssf del *.ssf
if exist serv_req_info.txt del serv_req_info.txt
if exist *.qws del *.qws
if exist cmp_state.ini del cmp_state.ini
if exist *.edf del *.edf
if exist *.smsg del *.smsg


rem don't shoot the project files !
 if exist *.q?f del *.q?f

rem Erase or Keep the programming files !
 if exist *.pof  del *.pof
 if exist *.sof  del *.sof

echo.
echo Deleting db and simulation sub-directories !
del  /f /s /q db  >nul
del  /f /s /q incremental_db >nul
rmdir db /s /q    >nul
rmdir incremental_db /s /q    >nul
del /f /s /q simulation >nul
rmdir simulation /s /q  >nul

echo.
echo DONE !
echo.
rem pause

