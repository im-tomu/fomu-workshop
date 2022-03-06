/// Messible: An Ansible for Messages
/// https://rm.fomu.im/messible.html
///
/// An Ansible is a system for instant communication across vast distances,
/// from a small portable device to a huge terminal far away. A Messible is
/// a message- passing system from embedded devices to a host system. You can
/// use it to get very simple printf()-style support over a debug channel.
///
/// The Messible assumes the host has a way to peek into the device’s memory
/// space. This is the case with the Wishbone bridge, which allows both the
/// device and the host to access the same memory.
///
/// At its core, a Messible is a FIFO. As long as the STATUS.FULL bit is 0,
/// the device can write data into the Messible by writing into the IN.
/// However, if this value is 1, you need to decide if you want to wait for it
/// to empty (if the other side is just slow), or if you want to drop the
/// message. From the host side, you need to read STATUS.HAVE to see if there
/// is data in the FIFO. If there is, read OUT to get the most recent byte,
/// which automatically advances the READ pointer.
pub const MESSIBLE = struct {
    const base = 0xe0008000;

    /// Write half of the FIFO to send data out the Messible. Writing to this register advances the write pointer automatically.
    pub const IN = @intToPtr(*volatile u8, base + 0x0);

    /// Read half of the FIFO to receive data on the Messible. Reading from this register advances the read pointer automatically.
    pub const OUT = @intToPtr(*volatile u8, base + 0x4);

    pub const STATUS = @intToPtr(*volatile packed struct {
        /// if more data can fit into the IN FIFO.
        FULL: bool,

        /// if data can be read from the OUT FIFO.
        HAVE: bool,
    }, base + 0x8);

    pub fn write(data: []const u8) usize {
        for (data) |c, i| {
            if (STATUS.FULL) return i;
            IN.* = c;
        }
        return data.len;
    }

    pub fn read(dst: []u8) usize {
        for (dst) |*c, i| {
            if (!STATUS.HAVE) return i;
            c.* = OUT.*;
        }
        return dst.len;
    }
};
