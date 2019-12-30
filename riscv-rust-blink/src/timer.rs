use fomu_pac::TIMER0;

pub struct Timer {
    registers: TIMER0,
}

impl Timer {
    pub fn new(registers: TIMER0) -> Self {
        Self { registers }
    }

    pub fn enable(&mut self) {
        unsafe {
            self.registers.en.write(|w| w.bits(1));
        }
    }

    pub fn disable(&mut self) {
        unsafe {
            self.registers.en.write(|w| w.bits(0));
        }
    }

    pub fn load(&mut self, value: u32) {
        let buff = value.to_le_bytes();

        unsafe {
            self.registers.load0.write(|w| w.bits(buff[0] as u32));
            self.registers.load1.write(|w| w.bits(buff[1] as u32));
            self.registers.load2.write(|w| w.bits(buff[2] as u32));
            self.registers.load3.write(|w| w.bits(buff[3] as u32));
        }
    }

    pub fn reload(&mut self, value: u32) {
        let buff = value.to_le_bytes();

        unsafe {
            self.registers.reload0.write(|w| w.bits(buff[0] as u32));
            self.registers.reload1.write(|w| w.bits(buff[1] as u32));
            self.registers.reload2.write(|w| w.bits(buff[2] as u32));
            self.registers.reload3.write(|w| w.bits(buff[3] as u32));
        }
    }

    pub fn value(&mut self) -> u32 {
        unsafe {
            self.registers.update_value.write(|w| w.bits(1));
        }

        let mut buff = [0u8; 4];

        buff[0] = self.registers.value0.read().bits() as u8;
        buff[1] = self.registers.value1.read().bits() as u8;
        buff[2] = self.registers.value2.read().bits() as u8;
        buff[3] = self.registers.value3.read().bits() as u8;

        u32::from_le_bytes(buff)
    }
}
