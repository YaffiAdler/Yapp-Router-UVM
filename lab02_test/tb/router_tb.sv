class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)

  function new(string name = "router_tb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ROUTER_TB", "Build phase of the testbench is being executed", UVM_HIGH)
  endfunction

endclass : router_tb
