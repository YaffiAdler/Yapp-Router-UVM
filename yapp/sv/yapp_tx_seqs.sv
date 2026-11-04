/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// SEQUENCE: yapp_base_seq
//   Base sequence that raises/drops objections; all sequences derive from it.
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_base_seq)

  function new(string name = "yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // In UVM 1.2 the starting phase is read through a method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // In UVM 1.2 the starting phase is read through a method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_5_packets
//   Five random packets. Set as default sequence with:
//     uvm_config_wrapper::set(this, "<sequencer path>.run_phase",
//                             "default_sequence", yapp_5_packets::get_type());
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_5_packets)

  function new(string name = "yapp_5_packets");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
    repeat (5)
      `uvm_do(req)
  endtask

endclass : yapp_5_packets

//------------------------------------------------------------------------------
// SEQUENCE: yapp_1_seq - one packet to address 1
//------------------------------------------------------------------------------
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 1;})
  endtask

endclass : yapp_1_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_012_seq - three packets to addresses 0, 1, 2
//------------------------------------------------------------------------------
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 0;})
    `uvm_do_with(req, {addr == 1;})
    `uvm_do_with(req, {addr == 2;})
  endtask

endclass : yapp_012_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_111_seq - three packets to address 1
//------------------------------------------------------------------------------
class yapp_111_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_111_seq)

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat (3)
      `uvm_do_with(req, {addr == 1;})
  endtask

endclass : yapp_111_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_repeat_addr_seq
//   Two packets to the same random address (never 3).
//------------------------------------------------------------------------------
class yapp_repeat_addr_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_repeat_addr_seq)

  rand bit [1:0] addr_sel;

  constraint addr_c { addr_sel inside {0, 1, 2}; }

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)

    if (!this.randomize())
      `uvm_error(get_type_name(), "Failed to randomize addr_sel")

    `uvm_do_with(req, {addr == addr_sel;})
    `uvm_do_with(req, {addr == addr_sel;})
  endtask

endclass : yapp_repeat_addr_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_incr_payload_seq
//   One packet whose payload increments from 0 to (length-1).
//------------------------------------------------------------------------------
class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)

    `uvm_create(req)

    // Randomize first to get a random address and length
    if (!req.randomize())
      `uvm_error(get_type_name(), "Failed to randomize req")

    foreach (req.payload[i])
      req.payload[i] = i;

    // Recompute parity now that the payload changed
    req.parity = req.calc_parity();

    `uvm_send(req)
  endtask

endclass : yapp_incr_payload_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_6_packets - six random packets
//------------------------------------------------------------------------------
class yapp_6_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_6_packets)

  function new(string name = "yapp_6_packets");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_6_packets sequence", UVM_LOW)
    repeat (6)
      `uvm_do(req)
  endtask

endclass : yapp_6_packets

//------------------------------------------------------------------------------
// SEQUENCE: yapp_exhaustive_seq - runs all of the sequences above in order
//------------------------------------------------------------------------------
class yapp_exhaustive_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  virtual task body();
    yapp_5_packets        seq_5;
    yapp_1_seq            seq_1;
    yapp_012_seq          seq_012;
    yapp_111_seq          seq_111;
    yapp_repeat_addr_seq  seq_repeat;
    yapp_incr_payload_seq seq_incr;

    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq", UVM_LOW)

    seq_5      = yapp_5_packets::type_id::create("seq_5");
    seq_1      = yapp_1_seq::type_id::create("seq_1");
    seq_012    = yapp_012_seq::type_id::create("seq_012");
    seq_111    = yapp_111_seq::type_id::create("seq_111");
    seq_repeat = yapp_repeat_addr_seq::type_id::create("seq_repeat");
    seq_incr   = yapp_incr_payload_seq::type_id::create("seq_incr");

    seq_5.start(m_sequencer);
    seq_1.start(m_sequencer);
    seq_012.start(m_sequencer);
    seq_111.start(m_sequencer);
    seq_repeat.start(m_sequencer);
    seq_incr.start(m_sequencer);
  endtask

endclass : yapp_exhaustive_seq

//------------------------------------------------------------------------------
// SEQUENCE: yapp_cov_seq
//   Targets the yapp_tx_monitor covergroup: every length bin x legal address
//   with bad parity, illegal address 3, then plain random traffic.
//------------------------------------------------------------------------------
class yapp_cov_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_cov_seq)

  int unsigned reps_per_bin = 4;
  int unsigned num_illegal  = 10;
  int unsigned num_random   = 100;

  function new(string name = "yapp_cov_seq");
    super.new(name);
  endfunction

  virtual task body();
    // Bounds of the length_cp bins: MIN, SMALL, MEDIUM, LARGE, MAX
    int unsigned len_lo[5] = '{1, 2, 11, 41, 63};
    int unsigned len_hi[5] = '{1, 10, 40, 62, 63};
    int unsigned lo_v, hi_v, addr_v;

    `uvm_info(get_type_name(), "Executing yapp_cov_seq", UVM_LOW)

    // REQ1 + REQ3: every length range x every legal address x bad parity
    foreach (len_lo[i]) begin
      lo_v = len_lo[i];
      hi_v = len_hi[i];
      for (addr_v = 0; addr_v <= 2; addr_v++) begin
        repeat (reps_per_bin) begin
          `uvm_do_with(req, {
            length inside {[lo_v:hi_v]};
            addr == addr_v;
            parity_type == BAD_PARITY;
          })
        end
      end
    end

    // REQ2: illegal address 3 - disable valid_addr on this object only
    repeat (num_illegal) begin
      `uvm_create(req)
      req.valid_addr.constraint_mode(0);
      `uvm_rand_send_with(req, { addr == 3; })
    end

    // Regular random traffic
    repeat (num_random) begin
      `uvm_do(req)
    end
  endtask

endclass : yapp_cov_seq
