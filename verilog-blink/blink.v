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
    output usb_dn,
    output usb_dp_pu,
`ifdef HAVE_PMOD
    output pmod_1,     // PMOD ouput connector (on EVT boards)
    output pmod_2,
    output pmod_3,
    output pmod_4,
`endif
    input  user_1,     // User touchable pins
    output user_2,     // Connect 1-2 to enable blue LED
    output user_3,     // Connect 3-4 to enable red LED
    input  user_4,
`ifdef EVT
    input  user_5,      // Button 5 on EVT only
    input  user_6,      // Button 6 on EVT only
`endif
    input clki         // Clock
);

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
    //
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

    // On EVT boards, there are also physical buttons
    //
`ifdef EVT
    // Connect first physical button, with pullup enabled
    wire user_5_pulled;
    SB_IO #(
        .PIN_TYPE(SB_IO_TYPE_SIMPLE_INPUT),
        .PULLUP(1'b 1)
    ) user_5_io (
        .PACKAGE_PIN(user_5),
        .OUTPUT_ENABLE(1'b0),
        .INPUT_CLK(clk),
        .D_IN_0(user_5_pulled),
    );

    // Connect second physical button, with pullup enabled
    wire user_6_pulled;
    SB_IO #(
        .PIN_TYPE(SB_IO_TYPE_SIMPLE_INPUT),
        .PULLUP(1'b 1)
    ) user_6_io (
        .PACKAGE_PIN(user_6),
        .OUTPUT_ENABLE(1'b0),
        .INPUT_CLK(clk),
        .D_IN_0(user_6_pulled),
    );

    // Allow touch buttons or physical buttons to control LEDs
    wire enable_blue = ~user_1_pulled | ~user_5_pulled;
    wire enable_red  = ~user_4_pulled | ~user_6_pulled;
`else
    // On non-EVT platorms, there are only touch buttons
    wire enable_blue = ~user_1_pulled;
    wire enable_red  = ~user_4_pulled;
`endif

    // Use system PLL module to divide system clock
    // (connected to pmod output below)
    wire pll_out;
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0010),		// DIVR =  2
        .DIVF(7'b0110001),	// DIVF = 49
        .DIVQ(3'b010),		// DIVQ =  2
        .FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
    ) mypll (
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

    // Make signals available on PMOD header output for scope
    // (or to inspect during simulation)
`ifdef HAVE_PMOD
    assign pmod_1 = clk;
    assign pmod_2 = outcnt ^ (outcnt >> 1);
    assign pmod_3 = counter[0];
    assign pmod_4 = pll_out;
`endif

    // Instantiate iCE40 LED driver hard logic, connecting up
    // latched button state, counter state, and LEDs.
    //
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

    // Parameters from iCE40 UltraPlus LED Driver Usage Guide, pages 19-20
    //
    // https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/ICE40LEDDriverUsageGuide.ashx?document_id=50668
    //
    localparam RGBA_CURRENT_MODE_FULL = "0b0";
    localparam RGBA_CURRENT_MODE_HALF = "0b1";

    // Current levels in Full / Half mode
    localparam RGBA_CURRENT_04MA_02MA = "0b000001";
    localparam RGBA_CURRENT_08MA_04MA = "0b000011";
    localparam RGBA_CURRENT_12MA_06MA = "0b000111";
    localparam RGBA_CURRENT_16MA_08MA = "0b001111";
    localparam RGBA_CURRENT_20MA_10MA = "0b011111";
    localparam RGBA_CURRENT_24MA_12MA = "0b111111";

    // Set parameters of RGBA_DRIVER (output current)
    //
    // Mapping of RGBn to LED colours determined experimentally
    //
    defparam RGBA_DRIVER.CURRENT_MODE = RGBA_CURRENT_MODE_HALF;
    defparam RGBA_DRIVER.RGB0_CURRENT = RGBA_CURRENT_08MA_04MA;  // Blue
    defparam RGBA_DRIVER.RGB1_CURRENT = RGBA_CURRENT_08MA_04MA;  // Red
    defparam RGBA_DRIVER.RGB2_CURRENT = RGBA_CURRENT_08MA_04MA;  // Green

endmodule
