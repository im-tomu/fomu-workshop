// Simple tri-colour LED blink example, with button control
//
// Green LED blinks forever.  Blue LED turned on when Button 5 is pressed.
// Red LED turned on when Button 6 is pressed.
//
// LOG2DELAY controls the division of the module clock to the bit interval
// (by requiring count to 2 ** LOG2DELAY before changing LED state bits)
//
// On EVT Fomu boards:
//
// 1st LED colour - Blue  - controlled by pressing Button 5, or connect 1 to 2
// 2nd LED colour - Red   - controlled by pressing Button 6, or connect 3 to 4
// 3rd LED colour - Green - controlled by clock (blinking)
//
// On DVT / Hacker / Production Fomu boards:
//
// 1st LED colour - Blue  - turn on by connecting pin 1 to pin 2
// 2nd LED colour - Green - controlled by clock (blinking)
// 3rd LED colour - Red   - turn on by connecting pin 3 to pin 4
//
// We use `defines to handle these two cases, because the SB_RGBA_DRV
// iCE40UP5K hard macro is unable to do RGBn to output pin mapping internally
// (the RGB0 / RGB1 / RGB2 parameters to SB_RGBA_DRV *must* be mapped
// to the same named RGB0 / RGB1 / RGB2 physical pins; arachne-pnr
// errors if they are not, and currently nextpnr just ignores mismapped
// pins and enforces this mapping)
//
// This is all kludged into a single file to make a standalone simple test;
// a better design would wrap SB_RGBA_DRV into a Fomu specific module and
// hide the LED colour mapping; and also set the appropriate pins for
// the buttons at instantiation time.
//
`ifdef EVT
`define BLUEPWM  RGB0PWM
`define REDPWM   RGB1PWM
`define GREENPWM RGB2PWM
`else
`ifdef PVT
`define GREENPWM RGB0PWM
`define REDPWM   RGB1PWM
`define BLUEPWM  RGB2PWM
`elsif HACKER
`define BLUEPWM  RGB0PWM
`define GREENPWM RGB1PWM
`define REDPWM   RGB2PWM
`else
`error_board_not_supported
`endif
`endif

module blink (
    output rgb0,       // SB_RGBA_DRV external pins
    output rgb1,
    output rgb2,
    output usb_dp,
    output usb_dn,
    output usb_dp_pu,
    input clki         // Clock
);

    // Assign USB pins to "0" so as to disconnect Fomu from
    // the host system.  Otherwise it would try to talk to
    // us over USB, which wouldn't work since we have no stack.
    assign usb_dp = 1'b0;
    assign usb_dn = 1'b0;
    assign usb_dp_pu = 1'b0;

    // Connect to system clock (with buffering)
    wire clkosc;
    SB_GB clk_gb (
        .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
        .GLOBAL_BUFFER_OUTPUT(clkosc)
    );

    assign clk = clkosc;

    // Use counter logic to divide system clock.  The clock is 48 MHz,
    // so we divide it down by 2^28.
    reg [28:0] counter = 0;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // Instantiate iCE40 LED driver hard logic, connecting up
    // latched button state, counter state, and LEDs.
    //
    // Note that it's possible to drive the LEDs directly,
    // however that is not current-limited and results in
    // overvolting the blue LED.
    SB_RGBA_DRV #(
        .CURRENT_MODE("0b1"),       // half current
        .RGB0_CURRENT("0b000011"),  // 4 mA
        .RGB1_CURRENT("0b000011"),  // 4 mA
        .RGB2_CURRENT("0b000011")   // 4 mA
    ) RGBA_DRIVER (
        .CURREN(1'b1),
        .RGBLEDEN(1'b1),
        .`BLUEPWM(counter[26]),     // Blue
        .`REDPWM(counter[27]),      // Red
        .`GREENPWM(counter[28]),    // Green
        .RGB0(rgb0),
        .RGB1(rgb1),
        .RGB2(rgb2)
    );

    // For more information see the iCE40 UltraPlus LED Driver Usage Guide, pages 19-20
    //
    // https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/ICE40LEDDriverUsageGuide.ashx?document_id=50668

endmodule
