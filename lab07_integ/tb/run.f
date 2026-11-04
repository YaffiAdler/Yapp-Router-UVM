// 64 bit option for AWS labs
-64
-timescale 1ns/1ns
-uvmhome $UVMHOME


+incdir+../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv

+incdir+../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv
+incdir+../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv
+incdir+../../yapp/sv
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv
clkgen.sv
hw_top.sv
tb_top.sv
../../router_rtl/yapp_router.sv

+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_LOW
