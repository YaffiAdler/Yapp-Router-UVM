class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  virtual interface yapp_if vif;

  uvm_analysis_port #(yapp_packet) item_collected_port;

  // Collected packet
  yapp_packet pkt;

  // Number of packets collected
  int num_pkt_col;

  covergroup packet_cg;
    length_cp : coverpoint pkt.length {
      bins MIN    = {1};
      bins SMALL  = {[2:10]};
      bins MEDIUM = {[11:40]};
      bins LARGE  = {[41:62]};
      bins MAX    = {63};
    }
    addr_cp : coverpoint pkt.addr {
      bins LEGAL[] = {[0:2]};
      bins ILLEGAL = {3};
    }
    parity_cp : coverpoint pkt.parity_type {
      bins GOOD = {GOOD_PARITY};
      bins BAD  = {BAD_PARITY};
    }

    // Only legal addresses with bad parity are crossed
    len_addr_parity_cross : cross length_cp, addr_cp, parity_cp {
      ignore_bins ILLEGAL_ADDR = binsof(addr_cp.ILLEGAL);
      ignore_bins GOOD_ONLY    = binsof(parity_cp.GOOD);
    }
  endgroup : packet_cg

  function new(string name = "yapp_tx_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    packet_cg = new();
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", "vif not set")
  endfunction

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
      packet_cg.sample();
      end_tr(pkt);
      item_collected_port.write(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      num_pkt_col++;
    end
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass : yapp_tx_monitor
