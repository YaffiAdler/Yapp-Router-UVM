/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module - randomizes and prints YAPP packets
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import yapp_pkg::*;

  // Generate 5 random packets and print them
  initial begin
    yapp_packet packet;

    packet = new("packet");

    repeat (5) begin
      if (!packet.randomize())
        `uvm_error("RAND", "Packet randomization failed")
      packet.print();
    end
  end

endmodule : top
