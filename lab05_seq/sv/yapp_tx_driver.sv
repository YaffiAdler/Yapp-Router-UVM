class yapp_tx_driver extends uvm_driver #(yapp_packet);

  `uvm_component_utils(yapp_tx_driver)

  function new(string name = "yapp_tx_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask

  // Placeholder: prints the packet instead of driving a DUT
  task send_to_dut(yapp_packet packet);
    `uvm_info("DRV", $sformatf("Packet is \n%s", packet.sprint()), UVM_LOW)
    #10ns;
  endtask

endclass : yapp_tx_driver
