/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : YAPP UVC packet (sequence item)
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

typedef enum {
  GOOD_PARITY,
  BAD_PARITY
} parity_type_e;

class yapp_packet extends uvm_sequence_item;

  rand bit [1:0]     addr;
  rand bit [5:0]     length;
  rand bit [7:0]     payload[];
       bit [7:0]     parity;

  rand parity_type_e parity_type;
  rand int           packet_delay;

  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(addr,          UVM_ALL_ON)
    `uvm_field_int(length,        UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity,        UVM_ALL_ON)
    `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay,  UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "yapp_packet");
    super.new(name);
  endfunction

  // XOR of the header byte and all payload bytes
  function bit [7:0] calc_parity();
    bit [7:0] parity_value;
    parity_value = 8'h00;
    parity_value ^= {6'b0, addr, length};
    foreach (payload[i])
      parity_value ^= payload[i];
    return parity_value;
  endfunction

  // Set correct or corrupted parity according to parity_type
  function void set_parity();
    if (parity_type == GOOD_PARITY)
      parity = calc_parity();
    else
      parity = ~calc_parity();
  endfunction

  function void post_randomize();
    set_parity();
  endfunction

  constraint valid_addr {
    addr inside {[0:2]};
  }

  constraint valid_length {
    length inside {[1:63]};
    payload.size() == length;
  }

  constraint parity_distribution {
    parity_type dist {
      GOOD_PARITY := 5,
      BAD_PARITY  := 1
    };
  }

  constraint valid_packet_delay {
    packet_delay inside {[1:20]};
  }

endclass : yapp_packet
