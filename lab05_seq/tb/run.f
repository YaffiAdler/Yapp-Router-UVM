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

-uvmhome $UVMHOME

// include directories
-incdir ../sv

// compile files
../sv/yapp_pkg.sv
top.sv
+UVM_TESTNAME=set_config_test
+UVM_VERBOSITY=UVM_LOW
