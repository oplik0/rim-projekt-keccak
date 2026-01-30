#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vitis/bin:/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vivado/ids_lite/ISE/bin/lin64:/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vivado/bin
else
  PATH=/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vitis/bin:/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vivado/ids_lite/ISE/bin/lin64:/proj/xbuilds/SWIP/2025.1_0522_0155/installs/lin64/2025.1/Vivado/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/scratch/jenkins-BUILDS-hw_designs_builds-2025.1_amd-yocto-hw-platforms-528_kr260_base/kria_base/k26/kr260_base/hw_project/kr260_base/kr260_base.runs/kria_starter_kit_zynq_ultra_ps_e_0_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log kria_starter_kit_zynq_ultra_ps_e_0_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source kria_starter_kit_zynq_ultra_ps_e_0_0.tcl
