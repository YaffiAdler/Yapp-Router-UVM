class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);

  `uvm_component_utils(yapp_tx_sequencer)

  function new(string name = "yapp_tx_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass : yapp_tx_sequencer
