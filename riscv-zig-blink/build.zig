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

    const binary = b.addSystemCommand(&[_][]const u8{
        b.option([]const u8, "objcopy", "objcopy executable to use (defaults to riscv64-unknown-elf-objcopy)") orelse "riscv64-unknown-elf-objcopy",
        "-I",
        "elf32-littleriscv",
        "-O",
        "binary",
    });
    binary.addArtifactArg(elf);
    binary.addArg("riscv-zig-blink.bin");
    b.default_step.dependOn(&binary.step);

    const run_cmd = b.addSystemCommand(&[_][]const u8{
        "dfu-util",
        "-D",
        "riscv-zig-blink.bin",
    });
    run_cmd.step.dependOn(&binary.step);
    const run_step = b.step("run", "Upload and run the app on your FOMU");
    run_step.dependOn(&run_cmd.step);
}
