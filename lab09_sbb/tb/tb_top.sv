module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // UVC packages
  import yapp_pkg::*;
  import channel_pkg::*;
  import clock_and_reset_pkg::*;
  import hbus_pkg::*;
  import router_module_pkg::*;  // Router module UVC (reference model + scoreboard + env)

  `include "router_mcsequencer.sv"
  `include "router_mcseqs_lib.sv"
  // router_scoreboard.sv is now included through router_module_pkg
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  // Pass the virtual interfaces from hw_top to the UVCs
  initial begin
    yapp_vif_config::set(null, "*.tb.yapp.*", "vif", hw_top.in0);
    channel_vif_config::set(null, "*.tb.chan0.*", "vif", hw_top.chan0_if);
    channel_vif_config::set(null, "*.tb.chan1.*", "vif", hw_top.chan1_if);
    channel_vif_config::set(null, "*.tb.chan2.*", "vif", hw_top.chan2_if);
    hbus_vif_config::set(null, "*.tb.hbus.*", "vif", hw_top.hbus_if_inst);
    clock_and_reset_vif_config::set(null, "*.tb.clk_rst.*", "vif", hw_top.clock_and_reset_if_inst);
    run_test();
  end

endmodule : tb_top
