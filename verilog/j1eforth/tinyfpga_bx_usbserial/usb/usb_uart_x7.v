/*
   usb_uart_x7

  Simple wrapper around the usb_uart which incorporates the Pin driver logic
  so this doesn't clutter the top level circuit

  Make the signature generic (usb_uart) and rely on the file inclusion process (makefile)
  to bring the correct architecture in

  The layer above has to assert the Host Pull Up line

    usb_uart u_u (
        .clk_48mhz  (clk_48mhz),
        .reset      (reset),

        // pins
        .pin_usb_p( pin_usb_p ),
        .pin_usb_n( pin_usb_n ),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        // uart pipeline out
        .uart_out_data( uart_out_data ),
        .uart_out_valid( uart_out_valid ),
        .uart_out_ready( uart_out_ready ),
    );

*/

`include "../../pipe/rtl/pipe_defs.v"

module usb_uart (
        input  clk_48mhz,
        input reset,

        // USB pins
        inout  pin_usb_p,
        inout  pin_usb_n,

        // uart pipeline in (out of the device, into the host)
        input [7:0] uart_in_data,
        input       uart_in_valid,
        output      uart_in_ready,

        // uart pipeline out (into the device, out of the host)
        output [7:0] uart_out_data,
        output       uart_out_valid,
        input        uart_out_ready,

        output [11:0] debug
    );

    wire usb_p_tx;
    wire usb_n_tx;
    wire usb_p_rx;
    wire usb_n_rx;
    wire usb_tx_en;

    //wire [3:0] debug;

    usb_uart_core_np u_u_c_np (
        .clk_48mhz  (clk_48mhz),
        .reset      (reset),

        // pins - these must be connected properly to the outside world.  See below.
        .usb_p_tx(usb_p_tx),
        .usb_n_tx(usb_n_tx),
        .usb_p_rx(usb_p_rx),
        .usb_n_rx(usb_n_rx),
        .usb_tx_en(usb_tx_en),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        // uart pipeline out
        .uart_out_data( uart_out_data ),
        .uart_out_valid( uart_out_valid ),
        .uart_out_ready( uart_out_ready ),

        .debug( debug )
    );

    wire usb_p_in;
    wire usb_n_in;

    assign usb_p_rx = usb_tx_en ? 1'b1 : usb_p_in;
    assign usb_n_rx = usb_tx_en ? 1'b0 : usb_n_in;

    IOBUF #(
        .DRIVE(16), // Specify the output drive strength
        .IBUF_LOW_PWR("FALSE"),  // Low Power - "TRUE", High Performance = "FALSE"
        .IOSTANDARD("DEFAULT"), // Specify the I/O standard
        .SLEW("FAST") // Specify the output slew rate
    ) iobuf_p (
        .O( usb_p_in  ),       // Buffer output
        .I( usb_p_tx ),       // Buffer input
        .IO( pin_usb_p ),     // Buffer inout port (connect directly to top-level port)
        .T( !usb_tx_en )      // 3-state enable input, high=input, low=output
    );

    IOBUF #(
        .DRIVE(16), // Specify the output drive strength
        .IBUF_LOW_PWR("FALSE"),  // Low Power - "TRUE", High Performance = "FALSE"
        .IOSTANDARD("DEFAULT"), // Specify the I/O standard
        .SLEW("FAST") // Specify the output slew rate
    ) iobuf_n (
        .O( usb_n_in  ),      // Buffer output
        .I( usb_n_tx ),       // Buffer input
        .IO( pin_usb_n ),     // Buffer inout port (connect directly to top-level port)
        .T( !usb_tx_en )      // 3-state enable input, high=input, low=output
    );

endmodule
