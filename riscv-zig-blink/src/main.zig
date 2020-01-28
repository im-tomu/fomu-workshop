const builtin = @import("builtin");
const std = @import("std");
const fomu = @import("./fomu.zig");

pub fn panic(message: []const u8, stack_trace: ?*builtin.StackTrace) noreturn {
    @setCold(true);
    fomu.panic(message, stack_trace);
}

fn rgb_init() void {
    // Turn on the RGB block and current enable, as well as enabling led control
    fomu.RGB.CTRL.* = .{
        .EXE = true,
        .CURREN = true,
        .RGBLEDEN = true,
        .RRAW = false,
        .GRAW = false,
        .BRAW = false,
    };

    // Enable the LED driver, and set 250 Hz mode.
    // Also set quick stop, which we'll use to switch patterns quickly.
    fomu.RGB.setControlRegister(.{
        .enable = true,
        .fr = .@"250",
        .quick_stop = true,
        .outskew = false,
        .output_polarity = .active_high,
        .pwm_mode = .linear,
        .BRMSBEXT = 0,
    });

    // Set clock register to 12 MHz / 64 kHz - 1
    fomu.RGB.setRegister(.BR, (fomu.SYSTEM_CLOCK_FREQUENCY / 64000) - 1);

    // Blink on/off time is in 32 ms increments
    fomu.RGB.setRegister(.ONR, 1); // Amount of time to stay "on"
    fomu.RGB.setRegister(.OFR, 0); // Amount of time to stay "off"

    fomu.RGB.setBreatheRegister(.On, .{
        .enable = true,
        .pwm_range_extend = false,
        .mode = .fixed,
        .rate = 1,
    });
    fomu.RGB.setBreatheRegister(.Off, .{
        .enable = true,
        .pwm_range_extend = false,
        .mode = .fixed,
        .rate = 1,
    });
}

const Colour = struct {
    r: u8,
    g: u8,
    b: u8,
};

/// Input a value 0 to 255 to get a colour value.
/// The colours are a transition r - g - b - back to r.
fn colourWheel(wheelPos: u8) Colour {
    var c: Colour = undefined;
    var wp = 255 - wheelPos;
    switch (wp) {
        0...84 => {
            c = .{
                .r = 255 - wp * 3,
                .g = 0,
                .b = wp * 3,
            };
        },
        85...169 => {
            wp -= 85;
            c = .{
                .r = 0,
                .g = wp * 3,
                .b = 255 - wp * 3,
            };
        },
        170...255 => {
            wp -= 170;
            c = .{
                .r = wp * 3,
                .g = 255 - wp * 3,
                .b = 0,
            };
        },
    }
    return c;
}

fn msleep(ms: usize) void {
    fomu.TIMER0.stop();
    fomu.TIMER0.reload(0);
    fomu.TIMER0.load(fomu.SYSTEM_CLOCK_FREQUENCY / 1000 * ms);
    fomu.TIMER0.start();
    while (fomu.TIMER0.value() != 0) {}
}

pub fn main() noreturn {
    rgb_init();

    var i: u8 = 0;
    while (true) : (i +%= 1) {
        const colour = colourWheel(i);
        fomu.RGB.setColour(colour.r, colour.g, colour.b);

        msleep(80);
    }

    unreachable;
}
