/*-----------------------------------------------------------------
File name     : hw_top.sv
Description   : lab06_vif hardware top module
              : Instantiates clock generator, YAPP interface and the
              : router DUT
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP interface to the DUT
  yapp_if in0(clock, reset);

  clkgen clkgen (
    .clock        (clock),
    .run_clock    (1'b1),
    .clock_period (32'd10)
  );

  // Only the YAPP input is used in this lab; outputs and HBUS are left unconnected
  yapp_router dut (
    .reset       (reset),
    .clock       (clock),
    .error       (),

    // YAPP interface (in_suspend is driven by the DUT)
    .in_data     (in0.in_data),
    .in_data_vld (in0.in_data_vld),
    .in_suspend  (in0.in_suspend),

    // Output channel 0
    .data_0      (),
    .data_vld_0  (),
    .suspend_0   (1'b0),

    // Output channel 1
    .data_1      (),
    .data_vld_1  (),
    .suspend_1   (1'b0),

    // Output channel 2
    .data_2      (),
    .data_vld_2  (),
    .suspend_2   (1'b0),

    // HBUS interface
    .haddr       (),
    .hdata       (),
    .hen         (),
    .hwr_rd      ()
  );

  // Single reset pulse
  initial begin
    reset <= 1'b0;
    @(negedge clock)
      #1 reset <= 1'b1;
    @(negedge clock)
      #1 reset <= 1'b0;
  end

endmodule : hw_top
