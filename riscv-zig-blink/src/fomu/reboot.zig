/// https://rm.fomu.im/reboot.html
pub const REBOOT = struct {
    const base = 0xe0006000;

    /// Provides support for rebooting the FPGA.
    /// You can select which of the four images to reboot to.
    pub const CTRL = @intToPtr(*volatile packed struct {
        /// Which image to reboot to. SB_WARMBOOT supports four images that are configured at FPGA startup.
        /// The bootloader is image 0, so set these bits to 0 to reboot back into the bootloader.
        image: u2,

        /// A reboot key used to prevent accidental reboots when writing to random areas of memory.
        /// To initiate a reboot, set this to 0b101011.
        key: u6,
    }, base + 0x0);

    /// This sets the reset vector for the VexRiscv.
    /// This address will be used whenever the CPU is reset, for example
    /// through a debug bridge. You should update this address whenever
    /// you load a new program, to enable the debugger to run `mon reset`
    pub const ADDR = @intToPtr(*volatile u32, base + 0x4);
};
