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

    messibleOutstream.print("PANIC: {}\r\n", .{message}) catch void;

    while (true) {
        // TODO: Use @breakpoint() once https://reviews.llvm.org/D69390 is available
        asm volatile ("ebreak");
    }
}

const OutStream = std.io.OutStream(error{});
pub const messibleOutstream = &OutStream{
    .writeFn = struct {
        pub fn messibleWrite(self: *const OutStream, bytes: []const u8) error{}!void {
            var left: []const u8 = bytes;
            while (left.len > 0) {
                const bytes_written = MESSIBLE.write(left);
                left = left[bytes_written..];
            }
        }
    }.messibleWrite,
};

const InStream = std.io.InStream(error{});
pub const messibleInstream = &InStream{
    .writeFn = struct {
        pub fn messibleRead(self: *const InStream, buffer: []u8) error{}!usize {
            while (true) {
                const bytes_read = MESSIBLE.read(buffer);
                if (bytes_read != 0) return bytes_read;
            }
        }
    }.messibleRead,
};
