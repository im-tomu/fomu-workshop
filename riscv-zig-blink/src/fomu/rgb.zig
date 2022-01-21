/// https://rm.fomu.im/rgb.html
pub const RGB = struct {
    const base = 0xe0006800;

    /// This is the value for the SB_LEDDA_IP.DAT register.
    /// It is directly written into the SB_LEDDA_IP hardware block, so you
    /// should refer to http://www.latticesemi.com/view_document?document_id=50668.
    /// The contents of this register are written to the address specified
    /// in ADDR immediately upon writing this register.
    pub const DAT = @intToPtr(*volatile u8, base + 0x0);

    /// This register is directly connected to SB_LEDDA_IP.ADDR.
    /// This register controls the address that is updated whenever DAT is written.
    /// Writing to this register has no immediate effect – data isn’t written until the DAT register is written.
    pub const ADDR = @intToPtr(*volatile u4, base + 0x4);

    pub const Register = enum(u4) {
        PWRR = 1,
        PWRG = 2,
        PWRB = 3,

        BCRR = 5,
        BCFR = 6,

        CR0 = 8,
        BR = 9,
        ONR = 10,
        OFR = 11,
    };

    pub fn setRegister(reg: Register, value: u8) void {
        ADDR.* = @enumToInt(reg);
        DAT.* = value;
    }

    const CR0 = packed struct {
        BRMSBEXT: u2,

        pwm_mode: enum(u1) {
            linear = 0,

            /// The Polynomial for the LFSR is X^(8) + X^(5) + X^3 + X + 1
            LFSR = 1,
        },

        quick_stop: bool,

        outskew: bool,

        /// PWM output polarity
        output_polarity: enum(u1) {
            active_high = 0,
            active_low = 1,
        },

        /// Flick rate for PWM (in Hz)
        fr: enum(u1) {
            @"125" = 0,
            @"250" = 1,
        },

        /// LED Driver enabled?
        enable: bool,
    };

    pub fn setControlRegister(value: CR0) void {
        setRegister(.CR0, @bitCast(u8, value));
    }

    pub const Breathe = packed struct {
        /// Breathe rate is in 128 ms increments
        rate: u4,

        _pad: u1 = 0,

        mode: enum(u1) {
            fixed = 0,
            modulate = 1,
        },

        pwm_range_extend: bool,

        enable: bool,
    };

    pub fn setBreatheRegister(reg: enum {
        On,
        Off,
    }, value: Breathe) void {
        setRegister(switch (reg) {
            .On => .BCRR,
            .Off => .BCFR,
        }, @bitCast(u8, value));
    }

    /// Control logic for the RGB LED and LEDDA hardware PWM LED block.
    pub const CTRL = @intToPtr(*volatile packed struct {
        /// Enable the fading pattern?
        /// Connected to `SB_LEDDA_IP.LEDDEXE`.
        EXE: bool,

        /// Enable the current source?
        /// Connected to `SB_RGBA_DRV.CURREN`.
        CURREN: bool,

        /// Enable the RGB PWM control logic?
        /// Connected to `SB_RGBA_DRV.RGBLEDEN`.
        RGBLEDEN: bool,

        /// Enable raw control of the red LED via the RAW.R register.
        RRAW: bool,

        /// Enable raw control of the green LED via the RAW.G register.
        GRAW: bool,

        /// Enable raw control of the blue LED via the RAW.B register.
        BRAW: bool,
    }, base + 0x8);

    /// Normally the hardware SB_LEDDA_IP block controls the brightness of the
    /// LED, creating a gentle fading pattern.
    /// However, by setting the appropriate bit in CTRL, it is possible to
    /// manually control the three individual LEDs.
    pub const RAW = @intToPtr(*volatile packed struct {
        /// Red
        R: bool,

        /// Green
        G: bool,

        /// Blue
        B: bool,
    }, base + 0xc);

    pub fn setColour(r: u8, g: u8, b: u8) void {
        setRegister(.PWRR, r);
        setRegister(.PWRG, g);
        setRegister(.PWRB, b);
    }
};
