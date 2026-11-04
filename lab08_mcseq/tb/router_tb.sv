class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)

  yapp_env            yapp;
  channel_env         chan0, chan1, chan2;
  hbus_env            hbus;
  clock_and_reset_env clk_rst;
  router_mcsequencer  mcseq;

  function new(string name = "router_tb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    yapp = yapp_env::type_id::create("yapp", this);

    // Output channels
    chan0 = channel_env::type_id::create("chan0", this);
    chan1 = channel_env::type_id::create("chan1", this);
    chan2 = channel_env::type_id::create("chan2", this);

    uvm_config_db#(int)::set(this, "chan0", "channel_id", 0);
    uvm_config_db#(int)::set(this, "chan1", "channel_id", 1);
    uvm_config_db#(int)::set(this, "chan2", "channel_id", 2);

    // HBUS: one master, no slaves
    hbus = hbus_env::type_id::create("hbus", this);
    uvm_config_db#(int)::set(this, "hbus", "num_masters", 1);
    uvm_config_db#(int)::set(this, "hbus", "num_slaves",  0);

    // Clock and reset
    clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);

    `uvm_info("ROUTER_TB", "Build phase of the testbench is being executed", UVM_HIGH)

    mcseq = router_mcsequencer::type_id::create("mcseq", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mcseq.yapp_seqr = yapp.agent.sequencer;
    mcseq.hbus_seqr = hbus.masters[0].sequencer;
  endfunction

endclass : router_tb
