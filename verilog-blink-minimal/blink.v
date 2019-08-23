// Simple tri-colour LED blink example, with button control
//
// Green LED blinks forever.
// Blue LED turned on when Button 5 is pressed.
// Red LED turned on when Button 6 is pressed.
//
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
`else
`define BLUEPWM  RGB0PWM
`define GREENPWM RGB1PWM
`define REDPWM   RGB2PWM
`endif
`endif

module blink (
    // 48MHz Clock input
    // --------
    input clki,
    // LED outputs
    // --------
    output rgb0,
    output rgb1,
    output rgb2,
    // User touchable pins
    // --------
    // Connect 1-2 to enable blue LED
    input  user_1,
    output user_2,
    // Connect 3-4 to enable red LED
    output user_3,
    input  user_4,
    // USB Pins (which should be statically driven if not being used).
    // --------
    output usb_dp,
    output usb_dn,
    output usb_dp_pu
);

    // Drive the USB outputs to constant values as they are not in use.
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

    // Configure user pins so that we can detect the user connecting
    // 1-2 or 3-4 with conductive material.
    //
    // We do this by grounding user_2 and user_3, and configuring inputs
    // with pullups on user_1 and user_4.
    localparam SB_IO_TYPE_SIMPLE_INPUT = 6'b000001;

    wire user_1_pulled;
    SB_IO #(
        .PIN_TYPE(SB_IO_TYPE_SIMPLE_INPUT),
        .PULLUP(1'b1)
    ) user_1_io (
        .PACKAGE_PIN(user_1),
        .OUTPUT_ENABLE(1'b0),
        .INPUT_CLK(clk),
        .D_IN_0(user_1_pulled),
    );

    assign user_2 = 1'b0;
    assign user_3 = 1'b0;

    wire user_4_pulled;
    SB_IO #(
        .PIN_TYPE(SB_IO_TYPE_SIMPLE_INPUT),
        .PULLUP(1'b 1)
    ) user_4_io (
        .PACKAGE_PIN(user_4),
        .OUTPUT_ENABLE(1'b0),
        .INPUT_CLK(clk),
        .D_IN_0(user_4_pulled),
    );

    wire enable_blue = ~user_1_pulled;
    wire enable_red  = ~user_4_pulled;

    // Use system PLL module to divide system clock
    wire pll_out;
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0010),		// DIVR =  2
        .DIVF(7'b0110001),	// DIVF = 49
        .DIVQ(3'b010),		// DIVQ =  2
        .FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
    ) pll (
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk),
        .PLLOUTCORE(pll_out),
    );

    // Use counter logic to divide system clock
    // (for blinking LED state)
    //
    // BITS controls LED state
    // LOG2DELAY controls divisor
    // -- requires counting to 2**LOG2DELAY before spilling onto LED state BITS
    //
    localparam BITS = 5;
    localparam LOG2DELAY = 21;

    reg [28:0] counter = 0;
    reg [BITS-1:0] outcnt;

    always @(posedge clk) begin
        counter <= counter + 1;
        outcnt <= counter >> LOG2DELAY;
    end

    // Parameters from iCE40 UltraPlus LED Driver Usage Guide, pages 19-20
    //
    // https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/ICE40LEDDriverUsageGuide.ashx?document_id=50668
    localparam RGBA_CURRENT_MODE_FULL = "0b0";
    localparam RGBA_CURRENT_MODE_HALF = "0b1";

    // Current levels in Full / Half mode
    localparam RGBA_CURRENT_04MA_02MA = "0b000001";
    localparam RGBA_CURRENT_08MA_04MA = "0b000011";
    localparam RGBA_CURRENT_12MA_06MA = "0b000111";
    localparam RGBA_CURRENT_16MA_08MA = "0b001111";
    localparam RGBA_CURRENT_20MA_10MA = "0b011111";
    localparam RGBA_CURRENT_24MA_12MA = "0b111111";

    // Instantiate iCE40 LED driver hard logic, connecting up
    // latched button state, counter state, and LEDs.
    SB_RGBA_DRV RGBA_DRIVER (
        .CURREN(1'b1),
        .RGBLEDEN(1'b1),
        .`BLUEPWM(enable_blue),     // Blue
        .`REDPWM(enable_red),       // Red
        .`GREENPWM(counter[23]),    // Green (blinking)
        .RGB0(rgb0),
        .RGB1(rgb1),
        .RGB2(rgb2)
    );

    // Set parameters of RGBA_DRIVER (output current)
    //
    // Mapping of RGBn to LED colours determined experimentally
    defparam RGBA_DRIVER.CURRENT_MODE = RGBA_CURRENT_MODE_HALF;
    defparam RGBA_DRIVER.RGB0_CURRENT = RGBA_CURRENT_16MA_06MA;  // Blue - Needs more current.
    defparam RGBA_DRIVER.RGB1_CURRENT = RGBA_CURRENT_08MA_04MA;  // Red
    defparam RGBA_DRIVER.RGB2_CURRENT = RGBA_CURRENT_08MA_04MA;  // Green

endmodule
