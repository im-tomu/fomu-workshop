module clkgen (
  input  wire       clk,
  output wire [2:0] cnt
);

  // Connect to system clock (with buffering)
  wire clko;
  SB_GB clk_gb (
      .USER_SIGNAL_TO_GLOBAL_BUFFER(clk),
      .GLOBAL_BUFFER_OUTPUT(clko)
  );

  // Use counter logic to divide system clock.  The clock is 48 MHz,
  // so we divide it down by 2^28.
  reg [28:0] counter = 0;
  always @(posedge clko) begin
      counter <= counter + 1;
  end
  assign cnt = counter[25:23];

endmodule
