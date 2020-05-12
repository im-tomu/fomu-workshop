const std = @import("std");

pub const MESSIBLE = @import("./fomu/messible.zig").MESSIBLE;
pub const REBOOT = @import("./fomu/reboot.zig").REBOOT;
pub const RGB = @import("./fomu/rgb.zig").RGB;
pub const TIMER0 = @import("./fomu/timer0.zig").TIMER0;
pub const TOUCH = @import("./fomu/touch.zig").TOUCH;

pub const SYSTEM_CLOCK_FREQUENCY = 12000000;

pub const start = @import("./fomu/start.zig");
// This forces start.zig file to be imported
comptime {
    _ = start;
}

/// Panic function that sets LED to red and flashing + prints the panic message over messible
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace) noreturn {
    @setCold(true);

    // Put LED into non-raw flashing mode
    RGB.CTRL.* = .{
        .EXE = true,
        .CURREN = true,
        .RGBLEDEN = true,
        .RRAW = false,
        .GRAW = false,
        .BRAW = false,
    };
    // Set colour to red
    RGB.setColour(255, 0, 0);
    // Enable the LED driver, and set 250 Hz mode.
    RGB.setControlRegister(.{
        .enable = true,
        .fr = .@"250",
        .quick_stop = false,
        .outskew = false,
        .output_polarity = .active_high,
        .pwm_mode = .linear,
        .BRMSBEXT = 0,
    });

    messibleOutStream.print("PANIC: {}\r\n", .{message}) catch void;

    while (true) {
        @breakpoint();
    }
}


const WriteError = error{};
fn messibleWrite(self: void, bytes: []const u8) WriteError!usize {
    while (true) {
        const bytes_written = MESSIBLE.write(bytes);
        if (bytes_written != 0) return bytes_written;
    }
}
pub const messibleOutStream = std.io.OutStream(void, WriteError, messibleWrite){.context = {}};

const ReadError = error{};
fn messibleRead(self: void, buffer: []u8) ReadError!usize {
    while (true) {
        const bytes_read = MESSIBLE.read(buffer);
        if (bytes_read != 0) return bytes_read;
    }
}
pub const messibleInStream = std.io.InStream(void, ReadError, messibleRead){.context = {}};
