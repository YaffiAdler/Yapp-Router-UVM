class router_module_env extends uvm_env;

  `uvm_component_utils(router_module_env)

  router_reference  ref_model;
  router_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_model = router_reference::type_id::create("ref_model", this);
    sb        = router_scoreboard::type_id::create("sb", this);
  endfunction

  // Only packets the reference model accepts reach the scoreboard
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ref_model.valid_yapp_port.connect(sb.yapp_in);
  endfunction

endclass : router_module_env
