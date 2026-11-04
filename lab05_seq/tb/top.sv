/*-----------------------------------------------------------------
File name     : top.sv
Description   : Top module - includes the testbench and test library and starts the test
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import yapp_pkg::*;

  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial begin
    run_test();
  end

endmodule : top
