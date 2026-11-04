class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BASE_TEST", "Build phase of the test is being executed", UVM_HIGH)

    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_5_packets::get_type());

    tb = router_tb::type_id::create("tb", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass : base_test
