/// https://rm.fomu.im/touch.html
pub const TOUCH = struct {
    const base = 0xe0005800;

    /// Output values for pads 1-4
    pub const TOUCH_O = @intToPtr(*volatile u4, base + 0x0);

    /// Output enable control for pads 1-4
    pub const TOUCH_OE = @intToPtr(*volatile u4, base + 0x4);

    /// Input value for pads 1-4
    pub const TOUCH_1 = @intToPtr(*volatile u4, base + 0x8);
};
