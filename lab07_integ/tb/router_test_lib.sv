class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*", "recording_detail", 1);

    `uvm_info("BASE_TEST", "Build phase of the test is being executed", UVM_HIGH)

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_5_packets::get_type());

    tb = router_tb::type_id::create("tb", this);
  endfunction

  // Report any config_db settings that were never read
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    check_config_usage();
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask

endclass : base_test

//------------------------------------------------------------------------------
// TEST: short_packet_test - replaces yapp_packet with short_yapp_packet
//------------------------------------------------------------------------------
class short_packet_test extends base_test;

  `uvm_component_utils(short_packet_test)

  function new(string name = "short_packet_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  endfunction

endclass : short_packet_test

//------------------------------------------------------------------------------
// TEST: set_config_test - builds the YAPP agent as passive
//------------------------------------------------------------------------------
class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  function new(string name = "set_config_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // The configuration must be set before the environment is built
    uvm_config_int::set(this, "tb.yapp.agent", "is_active", UVM_PASSIVE);

    super.build_phase(phase);
  endfunction

endclass : set_config_test

//------------------------------------------------------------------------------
// TEST: incr_payload_test - short packets with an incrementing payload
//------------------------------------------------------------------------------
class incr_payload_test extends base_test;

  `uvm_component_utils(incr_payload_test)

  function new(string name = "incr_payload_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_incr_payload_seq::get_type());

    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  endfunction

endclass : incr_payload_test

//------------------------------------------------------------------------------
// TEST: exhaustive_seq_test - runs yapp_exhaustive_seq with short packets
//------------------------------------------------------------------------------
class exhaustive_seq_test extends base_test;

  `uvm_component_utils(exhaustive_seq_test)

  function new(string name = "exhaustive_seq_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_exhaustive_seq::get_type());

    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  endfunction

endclass : exhaustive_seq_test

//------------------------------------------------------------------------------
// TEST: yapp_012_test - runs yapp_012_seq
//------------------------------------------------------------------------------
class yapp_012_test extends base_test;

  `uvm_component_utils(yapp_012_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_012_seq::get_type());
  endfunction

endclass : yapp_012_test

//------------------------------------------------------------------------------
// TEST: simple_test - YAPP, channel and clock/reset default sequences
//------------------------------------------------------------------------------
class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  function new(string name = "simple_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_012_seq::get_type());
    // One wildcard covers all three channels
    uvm_config_wrapper::set(this, "tb.chan*.rx_agent.sequencer.run_phase",
                            "default_sequence", channel_rx_resp_seq::get_type());
    uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                            "default_sequence", clk10_rst5_seq::get_type());
    // HBUS has no default sequence
  endfunction

endclass : simple_test
