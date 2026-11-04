class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  virtual interface yapp_if vif;

  function new(string name = "yapp_tx_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Collected packet
  yapp_packet pkt;

  // Number of packets collected
  int num_pkt_col;

  task run_phase(uvm_phase phase);
    // Look for packets only after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin
      pkt = yapp_packet::type_id::create("pkt", this);

      // Collect the packet and record the transaction concurrently
      fork
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      num_pkt_col++;
    end
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", "vif not set")
  endfunction

endclass : yapp_tx_monitor
