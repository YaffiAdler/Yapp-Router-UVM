class yapp_tx_driver extends uvm_driver #(yapp_packet);

  `uvm_component_utils(yapp_tx_driver)

  virtual interface yapp_if vif;

  function new(string name = "yapp_tx_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", "vif not set")
  endfunction

  // Number of packets sent
  int num_sent;

  task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // Gets packets from the sequencer and drives them through the interface
  task get_and_drive();
    @(posedge vif.reset);
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)

      // Drive the packet and record the transaction concurrently
      fork
        begin
          // For acceleration efficiency, copy the dynamic payload array into
          // the interface's static payload array
          foreach (req.payload[i])
            vif.payload_mem[i] = req.payload[i];
          vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
        end
        // Start transaction recording when the interface signals start of packet
        @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
      join

      end_tr(req);
      num_sent++;
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // Reset all TX signals
  task reset_signals();
    forever
      vif.yapp_reset();
  endtask : reset_signals

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction : report_phase

  // Placeholder from earlier labs (no longer called)
  task send_to_dut(yapp_packet packet);
    `uvm_info("DRV", $sformatf("Packet is \n%s", packet.sprint()), UVM_LOW)
    #10ns;
  endtask

endclass : yapp_tx_driver
