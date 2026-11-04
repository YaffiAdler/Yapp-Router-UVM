`uvm_analysis_imp_decl(_ref_yapp)
`uvm_analysis_imp_decl(_ref_hbus)

//------------------------------------------------------------------------------
// CLASS: router_reference
//   Mirrors the router registers from HBUS writes and forwards to the
//   scoreboard only the YAPP packets the router is expected to route.
//------------------------------------------------------------------------------
class router_reference extends uvm_component;

  `uvm_component_utils(router_reference)

  // Inputs
  uvm_analysis_imp_ref_yapp #(yapp_packet,      router_reference) yapp_in;
  uvm_analysis_imp_ref_hbus #(hbus_transaction, router_reference) hbus_in;

  // Output: valid packets to the scoreboard
  uvm_analysis_port #(yapp_packet) valid_yapp_port;

  // Mirror of the router registers, initialized to the RTL reset values
  bit [7:0] maxpktsize = 8'h3F;
  bit       router_en  = 1'b1;

  // Counters
  int received, forwarded;
  int dropped_size, dropped_en, dropped_addr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    yapp_in         = new("yapp_in", this);
    hbus_in         = new("hbus_in", this);
    valid_yapp_port = new("valid_yapp_port", this);
  endfunction

  // HBUS: update the register mirror on writes
  function void write_ref_hbus(hbus_transaction tr);
    if (tr.hwr_rd == HBUS_WRITE) begin
      case (tr.haddr)
        16'h1000: maxpktsize = tr.hdata;
        16'h1001: router_en  = tr.hdata[0];
        default: ;
      endcase
    end
  endfunction

  // YAPP: forward only packets the router will not drop
  function void write_ref_yapp(yapp_packet packet);
    received++;
    if (!router_en) begin
      dropped_en++;
      `uvm_info("REF", $sformatf("Dropped (router disabled): addr=%0d len=%0d", packet.addr, packet.length), UVM_MEDIUM)
    end
    else if (packet.addr > 2) begin
      dropped_addr++;
      `uvm_info("REF", $sformatf("Dropped (bad address %0d)", packet.addr), UVM_MEDIUM)
    end
    else if (packet.length > maxpktsize) begin
      dropped_size++;
      `uvm_info("REF", $sformatf("Dropped (length %0d > maxpktsize %0d)", packet.length, maxpktsize), UVM_MEDIUM)
    end
    else begin
      forwarded++;
      valid_yapp_port.write(packet);
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("REF", $sformatf(
      "\n--- Reference Report ---\nYAPP received  : %0d\nForwarded      : %0d\nDropped (size) : %0d\nDropped (en)   : %0d\nDropped (addr) : %0d",
      received, forwarded, dropped_size, dropped_en, dropped_addr), UVM_LOW)
  endfunction

endclass : router_reference
