/*-----------------------------------------------------------------
File name     : run.f
Description   : Simulator run file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64
-timescale 1ns/1ns
-uvmhome $UVMHOME

// include directories
-incdir ../sv

// compile files
../sv/yapp_pkg.sv
../sv/yapp_if.sv
clkgen.sv
hw_top.sv
tb_top.sv
../../router_rtl/yapp_router.sv

+UVM_TESTNAME=yapp_012_test
+UVM_VERBOSITY=UVM_LOW
