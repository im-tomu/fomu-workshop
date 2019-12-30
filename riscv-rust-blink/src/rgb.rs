use fomu_pac::RGB;

const BREATHE_ENABLE: u8 = (1 << 7);
const BREATHE_MODE_FIXED: u8 = (0 << 5);

// Breathe rate is in 128 ms increments
const fn breathe_rate_ms(x: u8) -> u8 {
    ((x + 1) / 128) & 7
}

// Blink on/off time is in 32 ms increments
const fn blink_time_ms(x: u8) -> u8 {
    x / 32
}

const LEDDEN: u8 = (1 << 7);
const FR250: u8 = (1 << 6);
//const OUTPUL: u8 = (1 << 5);
//const OUTSKEW: u8 = (1 << 4);
const QUICK_STOP: u8 = (1 << 3);
//const PWM_MODE_LFSR: u8 = (1 << 2);
//const PWM_MODE_LINEAR: u8 = (0 << 2);

enum LedRegister {
    LEDDCR0 = 8,
    LEDDBR = 9,
    LEDDONR = 10,
    LEDDOFR = 11,
    LEDDBCRR = 5,
    LEDDBCFR = 6,
    LEDDPWRR = 1,
    LEDDPWRG = 2,
    LEDDPWRB = 3,
}

pub struct RgbControl {
    registers: RGB,
}

impl RgbControl {
    pub fn new(registers: RGB) -> Self {
        let mut ctrl = RgbControl { registers };

        ctrl.init();

        ctrl
    }

    fn init(&mut self) {
        self.registers
            .ctrl
            .write(|w| w.exe().bit(true).curren().bit(true).rgbleden().bit(true));

        self.write(LEDDEN | FR250 | QUICK_STOP, LedRegister::LEDDCR0);

        // Set clock register to 12 MHz / 64 kHz - 1
        self.write(((12_000_000u32 / 64_000u32) - 1) as u8, LedRegister::LEDDBR);

        self.write(blink_time_ms(32), LedRegister::LEDDONR); // Amount of time to stay "on"
        self.write(blink_time_ms(0), LedRegister::LEDDOFR); // Amount of time to stay "off"

        self.write(
            BREATHE_ENABLE | BREATHE_MODE_FIXED | breathe_rate_ms(128),
            LedRegister::LEDDBCRR,
        );
        self.write(
            BREATHE_ENABLE | BREATHE_MODE_FIXED | breathe_rate_ms(128),
            LedRegister::LEDDBCFR,
        );
    }

    fn write(&mut self, value: u8, addr: LedRegister) {
        self.addr_write(addr);
        self.data_write(value);
    }

    pub fn set(&mut self, r: u8, g: u8, b: u8) {
        self.write(r, LedRegister::LEDDPWRR); // Blue
        self.write(g, LedRegister::LEDDPWRG); // Red
        self.write(b, LedRegister::LEDDPWRB); // Green
    }

    fn addr_write(&mut self, addr: LedRegister) {
        unsafe {
            self.registers.addr.write(|w| w.bits(addr as u32));
        }
    }

    fn data_write(&mut self, value: u8) {
        unsafe {
            self.registers.dat.write(|w| w.bits(value as u32));
        }
    }
}
