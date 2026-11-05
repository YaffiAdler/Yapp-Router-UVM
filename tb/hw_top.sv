module hw_top;

  logic [31:0] clock_period;
  logic        run_clock;
  logic        clock;
  logic        reset;

  // Interfaces
  clock_and_reset_if clock_and_reset_if_inst (
    .clock        (clock),
    .reset        (reset),
    .run_clock    (run_clock),
    .clock_period (clock_period)
  );

  yapp_if    in0(clock, reset);
  hbus_if    hbus_if_inst(clock, reset);
  channel_if chan0_if(clock, reset);
  channel_if chan1_if(clock, reset);
  channel_if chan2_if(clock, reset);

  // Clock generator, controlled by the clock_and_reset UVC
  clkgen clkgen (
    .clock        (clock),
    .run_clock    (run_clock),
    .clock_period (clock_period)
  );

  yapp_router dut (
    .reset       (reset),
    .clock       (clock),
    .error       (),

    // YAPP input
    .in_data     (in0.in_data),
    .in_data_vld (in0.in_data_vld),
    .in_suspend  (in0.in_suspend),

    // Channel 0
    .data_0      (chan0_if.data),
    .data_vld_0  (chan0_if.data_vld),
    .suspend_0   (chan0_if.suspend),

    // Channel 1
    .data_1      (chan1_if.data),
    .data_vld_1  (chan1_if.data_vld),
    .suspend_1   (chan1_if.suspend),

    // Channel 2
    .data_2      (chan2_if.data),
    .data_vld_2  (chan2_if.data_vld),
    .suspend_2   (chan2_if.suspend),

    // HBUS
    .haddr       (hbus_if_inst.haddr),
    .hdata       (hbus_if_inst.hdata_w),
    .hen         (hbus_if_inst.hen),
    .hwr_rd      (hbus_if_inst.hwr_rd)
  );

endmodule : hw_top
