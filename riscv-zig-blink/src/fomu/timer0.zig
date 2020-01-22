/// Provides a generic Timer core.
///
/// The Timer is implemented as a countdown timer that can be used in various modes:
///  - Polling: Returns current countdown value to software.
///  - One-Shot: Loads itself and stops when value reaches 0.
///  - Periodic: (Re-)Loads itself when value reaches 0.
///
/// *en* register allows the user to enable/disable the Timer. When the Timer
/// is enabled, it is automatically loaded with the value of load register.
///
/// When the Timer reaches 0, it is automatically reloaded with value of reload register.
///
/// The user can latch the current countdown value by writing to update_value
/// register, it will update value register with current countdown value.
///
/// To use the Timer in One-Shot mode, the user needs to:
///  - Disable the timer.
///  - Set the load register to the expected duration.
///  - (Re-)Enable the Timer.
///
/// To use the Timer in Periodic mode, the user needs to:
///  - Disable the Timer.
///  - Set the load register to 0.
///  - Set the reload register to the expected period.
///  - Enable the Timer.
///
/// For both modes, the CPU can be advertised by an IRQ that the
/// duration/period has elapsed. (The CPU can also do software polling with
/// update_value and value to know the elapsed duration)
pub const TIMER0 = struct {
    const base = 0xe0002800;

    pub const LOAD3 = @intToPtr(*volatile u8, base + 0x0);
    pub const LOAD2 = @intToPtr(*volatile u8, base + 0x4);
    pub const LOAD1 = @intToPtr(*volatile u8, base + 0x8);
    pub const LOAD0 = @intToPtr(*volatile u8, base + 0xc);

    /// Load value when Timer is (re-)enabled.
    /// In One-Shot mode, the value written to this register specify the
    /// Timer’s duration in clock cycles.
    pub fn load(x: u32) void {
        LOAD3.* = @truncate(u8, x >> 24);
        LOAD2.* = @truncate(u8, x >> 16);
        LOAD1.* = @truncate(u8, x >> 8);
        LOAD0.* = @truncate(u8, x);
    }

    pub const RELOAD3 = @intToPtr(*volatile u8, base + 0x10);
    pub const RELOAD2 = @intToPtr(*volatile u8, base + 0x14);
    pub const RELOAD1 = @intToPtr(*volatile u8, base + 0x18);
    pub const RELOAD0 = @intToPtr(*volatile u8, base + 0x1c);

    /// Reload value when Timer reaches 0.
    /// In Periodic mode, the value written to this register specify the
    /// Timer’s period in clock cycles.
    pub fn reload(x: u32) void {
        RELOAD3.* = @truncate(u8, x >> 24);
        RELOAD2.* = @truncate(u8, x >> 16);
        RELOAD1.* = @truncate(u8, x >> 8);
        RELOAD0.* = @truncate(u8, x);
    }

    /// Enable of the Timer.
    /// Set if to 1 to enable/start the Timer and 0 to disable the Timer
    pub const EN = @intToPtr(*volatile bool, base + 0x20);

    pub fn start() void {
        EN.* = true;
    }

    pub fn stop() void {
        EN.* = false;
    }

    /// Update of the current countdown value.
    /// A write to this register latches the current countdown value to value
    /// register.
    pub const UPDATE_VALUE = @intToPtr(*volatile bool, base + 0x24);

    pub const VALUE3 = @intToPtr(*volatile u8, base + 0x28);
    pub const VALUE2 = @intToPtr(*volatile u8, base + 0x2c);
    pub const VALUE1 = @intToPtr(*volatile u8, base + 0x30);
    pub const VALUE0 = @intToPtr(*volatile u8, base + 0x34);

    pub fn latchedValue() u32 {
        return (@as(u32, VALUE3.*) << 24) |
            (@as(u32, VALUE2.*) << 16) |
            (@as(u32, VALUE1.*) << 8) |
            (@as(u32, VALUE0.*));
    }

    pub fn value() u32 {
        UPDATE_VALUE.* = true;
        return latchedValue();
    }

    /// This register contains the current raw level of the Event trigger.
    /// Writes to this register have no effect.
    pub const EV_STATUS = @intToPtr(*volatile bool, base + 0x38);

    /// When an Event occurs, the corresponding bit will be set in this
    /// register. To clear the Event, set the corresponding bit in this
    /// register.
    pub const EV_PENDING = @intToPtr(*volatile bool, base + 0x3c);

    /// This register enables the corresponding Events. Write a 0 to this
    /// register to disable individual events.
    pub const EV_ENABLE = @intToPtr(*volatile bool, base + 0x40);
};
