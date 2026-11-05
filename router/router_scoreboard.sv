`uvm_analysis_imp_decl(_yapp)
`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)

//------------------------------------------------------------------------------
// CLASS: router_scoreboard
//   Queues each input YAPP packet by address and compares it in order with the
//   packet that comes out of the matching channel.
//------------------------------------------------------------------------------
class router_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(router_scoreboard)

  uvm_analysis_imp_yapp  #(yapp_packet,    router_scoreboard) yapp_in;
  uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;
  uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;
  uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;

  // One queue per address
  yapp_packet queue0[$], queue1[$], queue2[$];

  int received, wrong, matched;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    yapp_in  = new("yapp_in",  this);
    chan0_in = new("chan0_in", this);
    chan1_in = new("chan1_in", this);
    chan2_in = new("chan2_in", this);
  endfunction

  // comp_equal()
  `include "packet_compare.sv"

  // Clone the YAPP packet and push it to the queue of its address
  function void write_yapp(yapp_packet packet);
    yapp_packet copy;
    $cast(copy, packet.clone());
    received++;
    case (copy.addr)
      0: queue0.push_back(copy);
      1: queue1.push_back(copy);
      2: queue2.push_back(copy);
      default: `uvm_info("SB", "YAPP packet with illegal address - not queued", UVM_MEDIUM)
    endcase
  endfunction

  function void write_chan0(channel_packet cp);
    yapp_packet yp;
    if (queue0.size() == 0) begin
      `uvm_error("SB", "Chan0 packet but queue0 is empty") wrong++; return;
    end
    yp = queue0.pop_front();
    if (comp_equal(yp, cp)) matched++; else wrong++;
  endfunction

  function void write_chan1(channel_packet cp);
    yapp_packet yp;
    if (queue1.size() == 0) begin
      `uvm_error("SB", "Chan1 packet but queue1 is empty") wrong++; return;
    end
    yp = queue1.pop_front();
    if (comp_equal(yp, cp)) matched++; else wrong++;
  endfunction

  function void write_chan2(channel_packet cp);
    yapp_packet yp;
    if (queue2.size() == 0) begin
      `uvm_error("SB", "Chan2 packet but queue2 is empty") wrong++; return;
    end
    yp = queue2.pop_front();
    if (comp_equal(yp, cp)) matched++; else wrong++;
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SB", $sformatf(
      "\n--- Scoreboard Report ---\nYAPP packets received : %0d\nMatched               : %0d\nWrong                 : %0d\nLeft in queues        : q0=%0d q1=%0d q2=%0d",
      received, matched, wrong, queue0.size(), queue1.size(), queue2.size()), UVM_LOW)
  endfunction

endclass : router_scoreboard
