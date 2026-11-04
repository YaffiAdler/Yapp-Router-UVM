//------------------------------------------------------------------------------
// SEQUENCE: router_simple_mcseq
//   Sets MAXPKTSIZE to 20 and sends YAPP packets, then sets it to 63 and
//   sends random packets, checking the register value after each write.
//------------------------------------------------------------------------------
class router_simple_mcseq extends uvm_sequence;

  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)

  function new(string name = "router_simple_mcseq");
    super.new(name);
  endfunction

  hbus_small_packet_seq     small_pkt;
  hbus_set_default_regs_seq large_pkt;
  hbus_read_max_pkt_seq     read_max;
  yapp_012_seq              yapp_012;
  yapp_6_packets            yapp_rnd;

  task body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) phase.raise_objection(this, get_type_name());

    `uvm_do_on(small_pkt, p_sequencer.hbus_seqr)

    `uvm_do_on(read_max, p_sequencer.hbus_seqr)
    `uvm_info(get_type_name(),
              $sformatf("MAXPKTSIZE read = %0d (expected 20)", read_max.max_pkt_reg),
              UVM_LOW)
    if (read_max.max_pkt_reg != 20)
      `uvm_error(get_type_name(), "MAXPKTSIZE is not 20!")

    repeat (2)
      `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)

    `uvm_do_on(large_pkt, p_sequencer.hbus_seqr)
    `uvm_do_on(read_max, p_sequencer.hbus_seqr)
    `uvm_info(get_type_name(),
              $sformatf("MAXPKTSIZE read = %0d (expected 63)", read_max.max_pkt_reg),
              UVM_LOW)
    if (read_max.max_pkt_reg != 63)
      `uvm_error(get_type_name(), "MAXPKTSIZE is not 63!")

    `uvm_do_on(yapp_rnd, p_sequencer.yapp_seqr)

    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask

endclass : router_simple_mcseq
