

vlib UNISIM
vmap  UNISIM  {\\Smkn33\s10169\projetos\VHDL\JIGA_TESTES_V_V00\Test_Rig\FPGA_1\TEST_RIG_FPGA_1_V11\modelsim\UNISIM}
vcom -reportprogress 300 -work UNISIM \\Xilinx\14.1\ISE_DS\ISE\vhdl\src\unisims\usisim_VCOMP.vhd


vlib {\\Smkn33\s10169\projetos\VHDL\JIGA_TESTES_V_V00\Test_Rig\FPGA_1\TEST_RIG_FPGA_1_V11\modelsim\work}
vmap work {\\Smkn33\s10169\projetos\VHDL\JIGA_TESTES_V_V00\Test_Rig\FPGA_1\TEST_RIG_FPGA_1_V11\modelsim\work}


vlib {\\Smkn33\s10169\projetos\VHDL\JIGA_TESTES_V_V00\Test_Rig\FPGA_1\TEST_RIG_FPGA_1_V11\modelsim\XilinxCoreLib}
vmap XilinxCoreLib {\\Smkn33\s10169\projetos\VHDL\JIGA_TESTES_V_V00\Test_Rig\FPGA_1\TEST_RIG_FPGA_1_V11\modelsim\XilinxCoreLib}

vcom -reportprogress 300 -work XilinxCoreLib C:/Xilinx/14.1/ISE_DS/ISE/vhdl/src/XilinxCoreLib/BLK_MEM_GEN_V4_1.vhd


vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/ipcore_dir/M2Kx16.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/AD_AFE_INIT.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/AD_CLOCK.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/AD_CONFIG.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/AD_MAIN.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/AD_MAIN_tb.vhd
vcom -reportprogress 300 -work work //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/vhdl/uart/*



do //Smkn33/s10169/projetos/VHDL/JIGA_TESTES_V_V00/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V11/modelsim/AD_MAIN_tb_wave.do





process run "Implement Design" -force rerun_all
