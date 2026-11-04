class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  function new(string name = "yapp_tx_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("MON", "You are in the monitor", UVM_LOW)
  endtask

endclass : yapp_tx_monitor
