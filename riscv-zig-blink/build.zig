const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    b.setPreferredReleaseMode(.ReleaseSmall);
    const mode = b.standardReleaseOptions();

    const elf = b.addExecutable("riscv-zig-blink", "src/main.zig");
    elf.setTarget(.{
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_arch = .riscv32,
        .cpu_model = .{
            .explicit = &std.Target.riscv.cpu.generic_rv32,
        },
    });
    elf.setLinkerScriptPath(.{ .path = "ld/linker.ld" });
    elf.setBuildMode(mode);
    // The ELF file contains debug symbols and can be passed to gdb for remote debugging
    if (b.option(bool, "emit-elf", "Should an ELF file be emitted in the current directory?") orelse false) {
        elf.setOutputDir(".");
    }

    const binary = elf.installRaw("riscv-zig-blink.bin", .{ .dest_dir = .{ .custom = "../" } });
    b.default_step.dependOn(&binary.step);

    const run_cmd = b.addSystemCommand(&[_][]const u8{
        "dfu-util",
        "-D",
        "riscv-zig-blink.bin",
    });

    // Blinky example does not support USB, so when dfu-util uses libusb
    // to reset FOMU after flashing, it is no longer visible.
    // libusb returns LIBUSB_ERROR_NOT_FOUND (-5) and dfu-util recognizes
    // it as an error and returns EX_IOERR (74).
    run_cmd.expected_exit_code = 74;

    run_cmd.step.dependOn(&binary.step);
    const run_step = b.step("run", "Upload and run the app on your FOMU");
    run_step.dependOn(&run_cmd.step);
}
